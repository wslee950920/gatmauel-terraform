import cv2
import boto3
import uuid
from urllib.parse import unquote_plus

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    src=cv2.imread(image_path, cv2.IMREAD_COLOR)
    dst=cv2.resize(src, dsize=(1080, 1080), interpolation=cv2.INTER_LINEAR)
    cv2.imwrite(resized_path, dst)

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        tmpkey = key.replace('/', '')
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), tmpkey)
        upload_path = '/tmp/resized-{}'.format(tmpkey)
        s3_client.download_file(bucket, key, download_path)
        resize_image(download_path, upload_path)
        s3_client.upload_file(upload_path, bucket, key.replace('original', 'resized', 1))