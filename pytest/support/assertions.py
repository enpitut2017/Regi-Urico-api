from os.path import join, dirname
import json
from jsonschema.validators import validate


def assert_valid_schema(data, schema_file):
    """Assert json data using json schema file"""

    schema = _load_json_schema(schema_file)
    return validate(data, schema)


def _load_json_schema(schema_file):
    """Load json schema file"""

    relative_path = join('schemas', schema_file)
    absolute_path = join(dirname(__file__), relative_path)

    with open(absolute_path) as f:
        return json.load(f)