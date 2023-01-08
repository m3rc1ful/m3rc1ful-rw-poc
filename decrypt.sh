#!/bin/bash

## Goto subdir where CURRENTLY ENCRYPTED Data is stored
cd Data

## Delete CURRENTLY ENCRYPTED content of this Data directory
rm -rf *

## Copy ORIGINAL UNENCRYPTED content to this Data directory
cp -r --no-preserve=links ../OriginalData/* ./

## Delete CURRENTLY ENCRYPTED content of S3 bucket
aws s3 rm --recursive s3://platinum-sec-blood-private/poc1/

## Upload ORIGINAL UNENCRYPTED files to s3 bucket
aws s3 cp --recursive ./ s3://platinum-sec-blood-private/poc1/