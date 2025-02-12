using BringMeHome.Services.Interfaces;
using BringMeHome.Services.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace BringMeHome.API.Authentification
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        IUsersService _userService;

        public BasicAuthenticationHandler(IUsersService userService, IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock) : base(options, logger, encoder, clock)
        {
            _userService = userService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var autHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialsBytes = Convert.FromBase64String(autHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            var email = credentials[0];
            var password = credentials[1];
            var user = await _userService.Login(email, password);

            if (user == null)
            {
                return AuthenticateResult.Fail("Email or Password was null");
            }

            var claim = new List<Claim>()
    {
        new Claim(ClaimTypes.Email, user.UserEmail),
        new Claim(ClaimTypes.NameIdentifier, user.Username)
    };

            foreach (var role in user.UserRoles)
            {
                claim.Add(new Claim(ClaimTypes.Role, role.Role.Name));
            }

            var identity = new ClaimsIdentity(claim, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);

            var ticket = new AuthenticationTicket(principal, Scheme.Name);
            return AuthenticateResult.Success(ticket);
        }

    }
}
