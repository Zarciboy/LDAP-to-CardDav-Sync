#!/bin/bash

# Configuration
VCARD_FOLDER="/path/to/contacts" # path to folder with vCards
SERVER_URL="http://YOUR_BAIKAL_SERVER/dav.php/addressbooks/carddav/contacts/"
USERNAME="carddav"
PASSWORD="YOUR_PASSWORD"

# Loop for all .vcf-Files in folder
for vcard in "$VCARD_FOLDER"/*.vcf; do
  if [ -f "$vcard" ]; then
    echo "Uploading $vcard..."
    curl --digest -u "$USERNAME:$PASSWORD" -T "$vcard" "$SERVER_URL"
    if [ $? -eq 0 ]; then
      echo "$vcard successfully uploaded."
    else
      echo "Error while uploading $vcard."
    fi
  else
    echo "No vCards found in folder: $VCARD_FOLDER"
  fi
done
