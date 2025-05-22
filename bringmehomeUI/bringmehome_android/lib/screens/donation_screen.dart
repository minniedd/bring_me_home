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
      _showSnackBar('Please enter a valid amount greater than 0.',
          isError: true);
      return;
    }
    _totalAmount = donationAmount;

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final accessToken = await _getAccessToken();
      final approvalUrl = await _createOrder(accessToken, _totalAmount);

      if (!mounted) return;

      _redirectToPayPal(approvalUrl);
    } catch (e) {
      print("Error during PayPal donation process: $e");
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
      return data['access_token'];
    } else {
      print('Failed to obtain PayPal access token: ${response.body}');
      throw Exception(
          'Failed to obtain PayPal access token. Please check your client credentials.');
    }
  }

  Future<String> _createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
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
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final String? approvalUrl = data['links']?.firstWhere(
          (link) => link['rel'] == 'approve',
          orElse: () => null)?['href'];
      if (approvalUrl != null) {
        return approvalUrl;
      } else {
        throw Exception('Approve URL not found in PayPal order response.');
      }
    } else {
      print('Failed to create PayPal order: ${response.body}');
      throw Exception(
          'Failed to create PayPal order (Status: ${response.statusCode})');
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    late final WebViewController controller;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            print('WebView: Page started loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            print('WebView: Page finished loading: $url');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView: Error: ${error.description}');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              _showSnackBar('WebView error: ${error.description}',
                  isError: true);
            }
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            print('WebView URL changed: $url');
            _handleUrlChange(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            print('WebView: Navigating to $url');

            if (_shouldHandleUrl(url)) {
              print("Special URL detected: $url");
              _handleUrl(url);
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
          title: Text(
              _isLoading ? 'Connecting to PayPal...' : 'Complete Donation'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
              _showSnackBar('Donation process aborted.', isError: true);
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (_isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
          ],
        ),
      );
    }));
  }

  bool _shouldHandleUrl(String url) {
    return url.startsWith(_returnUrl) || url.startsWith(_cancelUrl);
  }

  void _handleUrl(String url) {
    if (!mounted) return;

    if (url.startsWith(_returnUrl)) {
      print("Donation successful redirect detected.");

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Donation successful! Thank you!', isError: false);
      _amountController.clear();
    } else if (url.startsWith(_cancelUrl)) {
      print("Donation cancelled redirect detected.");

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Donation cancelled.', isError: true);
    }
  }

  void _handleUrlChange(String url) {
    if (_shouldHandleUrl(url)) {
      _handleUrl(url);
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
                  'Support $_brandName !',
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
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
