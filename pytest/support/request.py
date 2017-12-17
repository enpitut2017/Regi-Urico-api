import json
import requests

HOST = 'http://localhost:3001'
DEFAULT_USER = 'ほげ茶'
DEFAULT_PASSWORD = 'password'


def get_token(name=None, password=None):
    """Get X-Authorized-Token"""

    if name is None:
        name = DEFAULT_USER
    if password is None:
        password = DEFAULT_PASSWORD

    r = requests.post(HOST + '/signin', {'name': name, 'password': password})
    data = json.loads(r.text)
    return data['token']


def request(method, url, data=None):
    """Send authorized request with token"""

    if data is None:
        data = {}

    # Set authorized token
    token = get_token()
    headers = {'X-Authorized-Token': token}

    r = requests.request(method, HOST + url, data=data, headers=headers)
    return json.loads(r.text)