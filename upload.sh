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

JSON_FILE="/Users/ashu/Freelance/ButterrEmailer/uploaded_urls.json"
echo "{" > "$JSON_FILE"

len=${#IMAGES[@]}
for i in "${!IMAGES[@]}"; do
  img="${IMAGES[$i]}"
  echo "Uploading $img..."
  res=$(curl -s -F "file=@/Users/ashu/Freelance/ButterrEmailer/img/$img" https://tmpfiles.org/api/v1/upload)
  url=$(echo "$res" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['data']['url'])" 2>/dev/null)
  
  if [ -n "$url" ]; then
    direct_url="${url/https:\/\/tmpfiles.org\//https:\/\/tmpfiles.org\/dl\/}"
    if [ $((i+1)) -eq $len ]; then
      echo "  \"$img\": \"$direct_url\"" >> "$JSON_FILE"
    else
      echo "  \"$img\": \"$direct_url\"," >> "$JSON_FILE"
    fi
    echo "Uploaded: $img -> $direct_url"
  else
    echo "Failed: $img. Response: $res"
  fi
done

echo "}" >> "$JSON_FILE"
echo "Done! Saved to $JSON_FILE"
