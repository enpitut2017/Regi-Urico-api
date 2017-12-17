from support.request import request
from support.assertions import assert_valid_schema


def test_get_sellers():
    """Can get my seller object"""

    data = request('get', '/sellers')
    assert_valid_schema(data, 'seller.json')

