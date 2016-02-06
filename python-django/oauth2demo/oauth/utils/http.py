import requests
from requests.auth import HTTPBasicAuth


def do_basic_secure_post(uri, auth_params, params):
    response = requests.post(uri, auth=HTTPBasicAuth(auth_params.client_id, auth_params.client_secret),
                             data=params, verify=False)

    __check_response(response)
    return response.json()


def do_oauth_secure_get(uri, token):
    headers = { 'Authorization': 'Bearer %s' % token.access_token }
    response = requests.get(uri, headers=headers, verify=False)

    __check_response(response)
    return response.json()

def __check_response(response):
    if response.status_code != 200:
        raise RuntimeError(response.url + ' return code ' + response.status_code)
