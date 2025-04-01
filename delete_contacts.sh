#!/bin/bash

# Variablen
VCARD_FOLDER="/home/YOUR_USER/contacts" # Path to vCards folder
server="http://YOUR_BAIKAL_SERVER/dav.php/addressbooks/carddav/contacts/"
user="carddav"
pass="YOUR_PASSWORD"

# Function to delete a contact
delete_contact() {
    contact_name="$1"
    contact_url="${server}${contact_name}"
    echo "Delete Contact: $contact_url"

    response=$(curl --digest -u "$user:$pass" -X DELETE "$contact_url")
    if [ $? -eq 0 ]; then
        echo "Contact $contact_name successfully deleted."
    else
        echo "Error while deleting Contact $contact_name."
    fi
}
# Loop for all .vcf-files in contacts folder and deletion of all contacts
for vcard in "$VCARD_FOLDER"/*.vcf; do
  if [ -f "$vcard" ]; then
    vcard_name=$(basename "$vcard")
    echo "working on vCard: $vcard_name"
    delete_contact "$vcard_name"
  else
    echo "No vCards found in folder: $VCARD_FOLDER"
  fi
done
