import boto3
import json
import os

outputs = json.loads(os.environ['TF_OUTPUTS'])

artifacts_bucket_name = outputs['artifacts_bucket_name']['value']
build_role_arn = outputs['build_role_arn']['value']
pipeline_role_arn = outputs['pipeline_role_arn']['value']
repo_name = outputs['repo_name']['value']
repo_url = outputs['repo_url']['value']

from pprint import pprint

s3 = boto3.client('s3')

block_config = s3.get_public_access_block(Bucket=artifacts_bucket_name)['PublicAccessBlockConfiguration']
assert block_config['BlockPublicAcls'], 'BlockPublicAcls'
assert block_config['BlockPublicPolicy'], 'BlockPublicPolicy'
assert block_config['RestrictPublicBuckets'], 'RestrictPublicBuckets'

bucket_encryption_config = s3.get_bucket_encryption(Bucket=artifacts_bucket_name)['ServerSideEncryptionConfiguration']
assert bucket_encryption_config['Rules'][0]['ApplyServerSideEncryptionByDefault']['SSEAlgorithm'] == 'AES256', 'encryption'