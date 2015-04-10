using System.Collections.Generic;
using System.Linq;
using RestSharp;

namespace OAuth2Demo.Controllers
{
    /// <summary>
    /// Simple class representing work with API through OAuth2 token. It has only one simple method <see cref="BasicApiWorker.ListFiles" /> which returns list of users available files in basic form.
    /// </summary>
    public class BasicApiWorker
    {
        private readonly TokenInfo token;
        private readonly string apiUrl;

        public BasicApiWorker(TokenInfo token, string apiUrl)
        {
            this.token = token;
            this.apiUrl = apiUrl;
        }

        /// <summary>
        /// Returns list of users available files
        /// </summary>
        /// <returns></returns>
        public List<string> ListFiles()
        {
            var _restClient = new RestClient(apiUrl)
                              {
                                  Authenticator =
                                      new OAuth2AuthorizationRequestHeaderAuthenticator(
                                      token.access_token)
                              };
            var _restRequest = new RestRequest("DataFileList", Method.GET);
            _restRequest.AddQueryParameter("all", "true");
            var _restResponse = _restClient.Execute(_restRequest);
            var _content = _restResponse.Content;
            var _list = SimpleJson.DeserializeObject<DataFile[]>(_content);
            return _list.Select(file => file.Name).ToList();
        }
    }
}