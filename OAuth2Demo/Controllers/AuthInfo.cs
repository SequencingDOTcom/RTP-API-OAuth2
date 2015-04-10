namespace OAuth2Demo.Controllers
{
    public class AuthInfo
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }
        public TokenInfo Token { get; set; }
    }
}