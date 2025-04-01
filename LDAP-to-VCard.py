import ldap
import os

# LDAP server details
LDAP_SERVER = "ldap://YOUR_LDAP_SERVER"
BIND_DN = "CN=xxx,OU=xxx,DC=xxx,DC=xxx"
PASSWORD = "YOUR_PASSWORD"
BASE_DN = "OU=xxx,DC=xxx,DC=xxx"

# Connect to the LDAP server
conn = ldap.initialize(LDAP_SERVER)
conn.simple_bind_s(BIND_DN, PASSWORD)

# Search for contacts
search_filter = "(objectClass=person)"
attributes = ['cn', 'sn', 'mail', 'telephoneNumber']
result = conn.search_s(BASE_DN, ldap.SCOPE_SUBTREE, search_filter, attributes)

# Create contacts directory if it doesn't exist
if not os.path.exists('contacts'):
    os.makedirs('contacts')

# Function to create vCard content
def create_vcard(entry):
    vcard = "BEGIN:VCARD\n"
    vcard += "VERSION:3.0\n"
    vcard += f"FN:{entry['cn'][0].decode('utf-8')}\n"
    if 'mail' in entry:
        vcard += f"EMAIL:{entry['mail'][0].decode('utf-8')}\n"
    if 'telephoneNumber' in entry:
        vcard += f"TEL:{entry['telephoneNumber'][0].decode('utf-8')}\n"
    vcard += "END:VCARD\n"
    return vcard

# Save each contact as a vCard file with the full name without spaces
for dn, entry in result:
    if 'cn' in entry and 'sn' in entry:
        full_name = entry['cn'][0].decode('utf-8').replace(" ", "")
        filename = f"contacts/{full_name}.vcf"
        with open(filename, 'w') as f:
            f.write(create_vcard(entry))

print("Contacts have been saved as vCards in the 'contacts' directory.")
