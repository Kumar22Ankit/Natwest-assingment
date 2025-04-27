import boto3

# Initialize S3 client
s3 = boto3.client('s3')

# List all S3 buckets
response = s3.list_buckets()
print("Your S3 Buckets:")
for bucket in response['Buckets']:
    print(f"- {bucket['Name']}")

# Specify your bucket name
bucket_name = input("\nEnter the bucket name to count objects: ")

# Count objects in the specified bucket
s3_resource = boto3.resource('s3')
bucket = s3_resource.Bucket(bucket_name)

object_count = sum(1 for _ in bucket.objects.all())

print(f"\nTotal number of objects in '{bucket_name}': {object_count}")
