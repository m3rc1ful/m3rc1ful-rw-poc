#!/bin/bash

## Delete CURRENTLY ENCRYPTED content of S3 bucket
aws s3 rm --recursive s3://platinum-sec-blood-private/poc1/

## Goto subdir where ORIGINAL UNENCRYPTED OriginalData is backed-up
cd ./.OriginalData

## Upload ORIGINAL UNENCRYPTED files to s3 bucket
aws s3 cp --recursive ./ s3://platinum-sec-blood-private/poc1/

## Go up one directory and delete locally-stored OriginalData dir
cd ..
rm -rfv ./.OriginalData
rm decrypt.sh
