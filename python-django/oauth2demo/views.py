from django.shortcuts import render, redirect
from django.core.urlresolvers import reverse
from django.http import HttpResponse, HttpResponseRedirect
import urllib.parse
import requests
from requests.auth import HTTPBasicAuth
from .appconfig import AppConfig

def auth(request):
    params = urllib.parse.urlencode({'redirect_uri': AppConfig.redirect_uri, 'response_type': AppConfig.response_type, 'state': AppConfig.state, 'client_id': AppConfig.client_id, 'scope': AppConfig.scope})

    return redirect(AppConfig.oauthserver_uri + '/authorize?' + params, {})

def authCallback(request):
    state = request.GET['state']
    code = request.GET['code']

    if state == AppConfig.state:
        data = {'grant_type': AppConfig.grant_type, 'code': code, 'redirect_uri': AppConfig.redirect_uri}
        response = requests.post(AppConfig.oauthserver_uri + '/token', auth=HTTPBasicAuth(AppConfig.client_id, AppConfig.client_secret), data=data) 
        result = response.json();
        request.session['access_token'] = result['access_token']
        
        rurl = reverse('api')
        return HttpResponseRedirect(rurl) 
    return HttpResponse('')

def api(request):
    token = request.session['access_token']
    if token is None:    
        return HttpResponse('')
    
    uri = AppConfig.api_uri + '/DataSourceList?sample=true'
    headers = { 'Authorization': 'Bearer {}'.format(token) }
    response = requests.get(uri, headers=headers)
     
    return render(request, 'apiResponse.html', {'response_json': response.json()})
