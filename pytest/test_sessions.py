from support.request import get_token


def test_post_signin():
    """Can get authorized token"""

    token = get_token()
    assert token is not None and token != ''
