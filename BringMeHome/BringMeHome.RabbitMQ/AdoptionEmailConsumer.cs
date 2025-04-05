using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Configuration;

namespace BringMeHome.RabbitMQ
{
    public class AdoptionEmailConsumer
    {
        private readonly IModel _channel;
        private readonly IConfiguration _configuration;
        private readonly EmailService _emailService;
        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

        public AdoptionEmailConsumer(IConfiguration configuration, EmailService emailService)
        {
            _configuration = configuration;
            _emailService = emailService;
            var factory = new ConnectionFactory
            {
                HostName = _host,
                UserName = _username,
                Password = _password,
                VirtualHost = _virtualhost
            };
            var connection = factory.CreateConnection();
            _channel = connection.CreateModel();
        }

        public void SendEmail()
        {
            _channel.QueueDeclare(queue: _configuration["RabbitMQ:QueueName"],
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);
                Console.WriteLine(" [x] Received {0}", message);
                var email = ExtractEmailFromMessage(message);
                if (!string.IsNullOrEmpty(email))
                {
                    _emailService.SendEmail(email, "Your adoption application has been successfully created.");
                }
            };

            _channel.BasicConsume(queue: _configuration["RabbitMQ:QueueName"],
                                autoAck: true,
                                consumer: consumer);
        }

        private string ExtractEmailFromMessage(string message)
        {
            var parts = message.Split(' ');
            return parts.Length > 3 ? parts[3] : string.Empty;
        }
    }
}