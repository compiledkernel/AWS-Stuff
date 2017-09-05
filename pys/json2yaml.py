import yaml
import json
import argparse
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--json', help='Input file should be json bro. Totes. (JSON)', required=True)
parser.add_argument('--yaml', help='Output file will be, Yaml ,ok bro? (YAML)', required=True)

if len(sys.argv) == 1:
    parser.print_help()
    sys.exit(1)

args = parser.parse_args()
json_file = args.json
yaml_file = args.yaml

with open(json_file, 'r') as fp:
    input_object = json.load(fp)
with open(yaml_file, 'w') as yaml_fp:
    yaml.safe_dump(input_object, yaml_fp, allow_unicode=True, default_flow_style=False)
print "Created YAML file for you, bro. {0}".format(yaml_file)
