#!/bin/bash
IMAGES=(
  "Vector.png"
  "stijn-te-strake-g9cwzFk-NwI-unsplash 1.png"
  "Handshake.png"
  "FilePdf.png"
  "FilePlus.png"
  "UsersThree.png"
  "IMG_7461 1.png"
  "Ellipse 2029.png"
  "LinkedinLogo.png"
  "InstagramLogo.png"
)

BIN_ID="butterr-welcome-assets-$(date +%s)"
JSON_FILE="/Users/ashu/Freelance/ButterrEmailer/uploaded_urls.json"
echo "{" > "$JSON_FILE"

len=${#IMAGES[@]}
for i in "${!IMAGES[@]}"; do
  img="${IMAGES[$i]}"
  echo "Uploading $img..."
  encoded_name=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$img'''))")
  
  res=$(curl -k -s -X POST -H "filename: $img" --data-binary "@/Users/ashu/Freelance/ButterrEmailer/img/$img" "https://filebin.net/$BIN_ID/$encoded_name")
  
  direct_url="https://filebin.net/$BIN_ID/$encoded_name"
  if [ $((i+1)) -eq $len ]; then
    echo "  \"$img\": \"$direct_url\"" >> "$JSON_FILE"
  else
    echo "  \"$img\": \"$direct_url\"," >> "$JSON_FILE"
  fi
  echo "Uploaded: $img -> $direct_url"
done

echo "}" >> "$JSON_FILE"
echo "Done! Saved to $JSON_FILE"
