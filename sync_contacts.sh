#!/bin/bash

# paths to scripts and folder
DELETE_SCRIPT="/home/YOUR_USER/delete_contacts.sh"
VCARD_FOLDER="/home/YOUR_USER/contacts"
LDAP2VCARD_SCRIPT="/home/YOUR_USER/LDAP2VCard_V2.py"
UPLOAD_SCRIPT="/home/YOUR_USER/upload_contacts.sh"

# function to execute scripts
run_script() {
    script_path="$1"
    echo "Executing $script_path..."
    result=$(bash "$script_path")
    if [ $? -eq 0 ]; then
        echo "$script_path successfully executed."
    else
        echo "Error while executing $script_path."
    fi
}

# delete_contacts.sh Skript ausführen
run_script "$DELETE_SCRIPT"

# deleting contacts folder
echo "Deleting folder contents: $VCARD_FOLDER"
rm -rf "$VCARD_FOLDER"/*
if [ $? -eq 0 ]; then
    echo "Contents of folder successfully deleted."
else
    echo "Error while deleting contents of folder."
    exit 1
fi

# LDAP2VCard.py 
echo "Executing LDAP2VCard.py: $LDAP2VCARD_SCRIPT"
python3 "$LDAP2VCARD_SCRIPT"
if [ $? -eq 0 ]; then
    echo "LDAP2VCard.py successfully executed."
else
    echo "Error while executing LDAP2VCard.py script."
    exit 1
fi

# upload_contacts.sh 
run_script "$UPLOAD_SCRIPT"
