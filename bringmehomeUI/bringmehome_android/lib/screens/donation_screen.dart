import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learning_app/widgets/master_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  // THIS IS A SANDBOX CLIENT ID AND SECRET. DO NOT USE IN PRODUCTION.THESE ARE PURELY FOR TESTING PURPOSES.
  final String _clientId =
      'Aduh2tT3KS7YXvEorQc-KqGfrZxqOJiA5P_pTFrM5JmvFOJ3Q2X3nF1oaIpKioNEPcnYbyy1yVlyt0cf';
  final String _clientSecret =
      'EFhJ3zNTNQRcRkPw8zgo50asaPGZl_J9aWNqj4GUby0VsKB7eQJ2ZNTefB4GJuj7w3Zkr7jjozr202hN';

  final String _paypalBaseUrl = 'https://api-m.sandbox.paypal.com';

  final String _returnUrl = 'https://example.com/success';
  final String _cancelUrl = 'https://example.com/cancel';
  final String _brandName = 'BringMeHome';

  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  double _totalAmount = 0.0;
  String? _currentOrderId;
  String? _currentAccessToken;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _startDonationProcess() async {
    final String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showSnackBar('Please enter a donation amount.', isError: true);
      return;
    }

    final double? donationAmount = double.tryParse(amountText);

    if (donationAmount == null || donationAmount <= 0) {
      _showSnackBar('Please enter a valid amount greater than 0.', isError: true);
      return;
    }
    _totalAmount = donationAmount;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await _getAccessToken();
      final orderData = await _createOrder(accessToken, _totalAmount);
      final approvalUrl = orderData['approvalUrl'];
      final orderId = orderData['orderId'];

      _currentOrderId = orderId;
      _currentAccessToken = accessToken;

      if (!mounted) return;

      if (approvalUrl != null) {
        _redirectToPayPal(approvalUrl);
      } else {
        throw Exception('Approval URL is null.');
      }
    } catch (e) {
      debugPrint("Error during PayPal donation process: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Error: ${e.toString()}', isError: true);
      }
    }
  }

  Future<String> _getAccessToken() async {
    final String basicAuth =
        base64Encode(utf8.encode('$_clientId:$_clientSecret'));

    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $basicAuth',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'] as String;
    } else {
      debugPrint('Failed to obtain PayPal access token: ${response.body}');
      throw Exception(
          'Failed to obtain PayPal access token. Please check your client credentials.');
    }
  }

  Future<Map<String, String>> _createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'PayPal-Request-Id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'description': 'Donation to $_brandName',
            'amount': {
              'currency_code': 'USD',
              'value': total.toStringAsFixed(2),
            },
          }
        ],
        'application_context': {
          'brand_name': _brandName,
          'return_url': _returnUrl,
          'cancel_url': _cancelUrl,
          'user_action': 'PAY_NOW',
          'shipping_preference': 'NO_SHIPPING',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final List<dynamic> links = data['links'] ?? [];
      final String? approvalUrl = links.firstWhere(
        (link) => link['rel'] == 'approve',
        orElse: () => null,
      )?['href'] as String?;
      
      final String orderId = data['id'] as String;
      
      if (approvalUrl != null && orderId.isNotEmpty) {
        return {'approvalUrl': approvalUrl, 'orderId': orderId};
      } else {
        throw Exception('Approve URL or Order ID not found in PayPal order response.');
      }
    } else {
      debugPrint('Failed to create PayPal order: ${response.body}');
      throw Exception('Failed to create PayPal order (Status: ${response.statusCode})');
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('WebView: Page started loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            debugPrint('WebView: Page finished loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView: Error: ${error.description}');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              _showSnackBar('WebView error: ${error.description}', isError: true);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            debugPrint('Navigation request to: $url');

            if (url.contains(_returnUrl)) {
              _capturePayment();
              return NavigationDecision.prevent;
            } else if (url.contains(_cancelUrl)) {
              if (mounted) {
                Navigator.pop(context);
                _showSnackBar('Donation cancelled.', isError: true);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Complete Donation'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Donation process aborted.', isError: true);
            },
          ),
        ),
        body: WebViewWidget(controller: controller),
      );
    }));
  }

  Future<void> _capturePayment() async {
    if (_currentOrderId == null || _currentAccessToken == null) {
      _showSnackBar('Payment information missing.', isError: true);
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('$_paypalBaseUrl/v2/checkout/orders/$_currentOrderId/capture'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_currentAccessToken',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'COMPLETED') {
          if (mounted) {
            Navigator.pop(context);
            _showSnackBar('Donation successful! Thank you!', isError: false);
            _amountController.clear();
          }
        } else {
          throw Exception('Payment not completed: ${data['status']}');
        }
      } else {
        throw Exception('Failed to capture payment: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error capturing payment: $e');
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Payment failed: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      settingsIcon: true,
      titleText: 'DONATE',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Image(
                  image: AssetImage('assets/cat.png'),
                  height: 100.0,
                  width: 100.0,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Support $_brandName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(149, 117, 205, 1),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'e.g., 25.00',
                    labelText: 'Donation Amount (USD)',
                    prefixText: '\$',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _startDonationProcess,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color.fromRGBO(149, 117, 205, 1),
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Donate with PayPal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}