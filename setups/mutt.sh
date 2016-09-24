mkdir -p ~/.mutt/andreas.wachowski/headers
mkdir -p ~/.mutt/andreas.wachowski/bodies
touch ~/.mutt/certificates

if [ ! -f ~/.mutt/andreaswachowskigmail.gpg ]; then
  cat >~/.mutt/passwords <<EOF
set imap_pass="password"
set smtp_pass="password"
EOF
  echo Insert the Google email passwords in ~/.mutt/passwords,
  echo then encrypt the file like so:
  echo gpg -r your.email@example.com -e ~/.mutt/passwords
  echo shred ~/.mutt/passwords
  echo rm ~/.mutt/passwords
  echo mv ~/.mutt/{passwords,andreaswachowskigmail}.gpg
fi
