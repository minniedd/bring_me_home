using BringMeHome.RabbitMQ;
using Microsoft.Extensions.Configuration;
class Program
{
    static void Main(string[] args)
    {
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json")
            .AddEnvironmentVariables();

        var configuration = builder.Build();

        var emailService = new EmailService(configuration);

        var reservationEmailConsumer = new AdoptionEmailConsumer(configuration, emailService);
        reservationEmailConsumer.SendEmail();
        Console.WriteLine("Adoption Email Consumer started");
        Thread.Sleep(Timeout.Infinite);
    }
}