#!/bin/bash

#First, let's define the metadata URL
METADATA_URL="http://79.125.92.21/latest/meta-data/"

#We can start fetching the required instance metadata for this task
INSTANCE_ID=$(curl -s $METADATA_URL/instance-id)
PUBLIC_IP=$(curl -s $METADATA_URL/public-ipv4)
PRIVATE_IP=$(curl -s $METADATA_URL/local-ipv4)
SECURITY_GROUPS=$(curl -s $METADATA_URL/security-groups)

#Next, we fetch the OS details and a list of users with grep
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
OS_VERSION=$(grep '^VERSION=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
USERS=$(grep -E '(/bin/bash|/bin/sh)' /etc/passwd | cut -d: -f1)

#Now let's define the output file and save data to it
OUTPUT_FILE="instance_information.txt"
echo "Instance ID: $INSTANCE_ID" > $OUTPUT_FILE
echo "Public IP: $PUBLIC_IP" >> $OUTPUT_FILE
echo "Private IP: $PRIVATE_IP" >> $OUTPUT_FILE
echo "Security Groups: $SECURITY_GROUPS" >> $OUTPUT_FILE
echo "OS Name: $OS_NAME" >> $OUTPUT_FILE
echo "OS Version: $OS_VERSION" >> $OUTPUT_FILE
echo "Users with shell access:" >> $OUTPUT_FILE
echo "$USERS" >> $OUTPUT_FILE

#Finally, we have to define S3 bucket name and upload our output file
S3_BUCKET="applicant-task/r2d2"
aws s3 cp $OUTPUT_FILE s3://$S3_BUCKET/

#We can also add output confirmation
echo "Instance information saved to $OUTPUT_FILE and uploaded to s3://$S3_BUCKET/"