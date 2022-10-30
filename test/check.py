import boto3
import json
import os

outputs = json.loads(os.environ['TF_OUTPUTS'])

build_role_arn = outputs['build_role_arn']['value']
repo_name = outputs['repo_name']['value']
repo_url = outputs['repo_url']['value']

assert repo_name == 'axetrading/terraform-github-actions-pipeline-resources-test-repo'
