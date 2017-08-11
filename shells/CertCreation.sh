#!/bin/bash

# Script that will run a command across all regions by appending --region 
echo "Which Region?" 
read REGIONS

echo "Base Name of the Public key?"
read PUBLIC

echo "Base Name of the Private key?" 
read PRIVATE

echo "Base Name of Certificate?"
read CERT

echo "Here are your regions"
echo $REGIONS

for r in {0..10},; do 
	echo "Running $COM --region $r"
	aws iot create-keys-and-certificates --set-as-active --certificate-pem-outfile $CERT-${i}.pem --public-key-outfile $PUBLIC-${i}.pub --private-key-outfile $PRIVATE-${i} 
	$COM --region $r
done


