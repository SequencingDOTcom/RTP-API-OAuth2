using System.Configuration;

namespace OAuth2Demo.Controllers
{
    public static class Options
    {
        public static string OAuthRedirectUrl { get { return ConfigurationManager.AppSettings["OAuthRedirectUrl"]; } }
        public static string OAuthAppId { get { return ConfigurationManager.AppSettings["OAuthAppId"]; } }
        public static string OAuthSecret { get { return ConfigurationManager.AppSettings["OAuthSecret"]; } }
        public static string ApiUrl { get { return ConfigurationManager.AppSettings["ApiUrl"]; } }
        public static string OAuthUrl { get { return ConfigurationManager.AppSettings["OAuthUrl"]; } }
    }
}