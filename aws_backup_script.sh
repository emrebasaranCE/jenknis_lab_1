#!/bin/bash

DATE=$(date +%Y-%m-%d)
BACKUP_NAME=db-$DATE.sql

DB_HOST=$1
DB_PASSWORD=$2
DB_NAME=$3
AWS_SECRET=$4
BUCKET_NAME=$5

# to create a backup of the database
mysqldump -h $DB_HOST -u root -p$DB_PASSWORD $DB_NAME > /tmp/$BACKUP_NAME && \
export AWS_ACCESS_KEY_ID=AKIAQ62SYYRA4DPOTGNM && \
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET && \
echo "Uploading `$BACKUP_NAME` to S3 bucket" && \
aws s3 cp /tmp/$BACKUP_NAME s3://$BUCKET_NAME/$BACKUP_NAME