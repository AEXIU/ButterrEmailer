import os
import requests
import json

img_dir = "/Users/ashu/Freelance/ButterrEmailer/img"
images = [
    "Vector.png",
    "stijn-te-strake-g9cwzFk-NwI-unsplash 1.png",
    "Handshake.png",
    "FilePdf.png",
    "FilePlus.png",
    "UsersThree.png",
    "IMG_7461 1.png",
    "Ellipse 2029.png",
    "LinkedinLogo.png",
    "InstagramLogo.png"
]

results = {}

print("Starting uploads to tmpfiles.org...")
for img in images:
    path = os.path.join(img_dir, img)
    if not os.path.exists(path):
        print(f"Error: {path} does not exist!")
        continue
    
    print(f"Uploading {img}...")
    try:
        with open(path, 'rb') as f:
            files = {'file': f}
            response = requests.post("https://tmpfiles.org/api/v1/upload", files=files)
            if response.status_code == 200:
                data = response.json()
                if data.get("status") == "success":
                    raw_url = data["data"]["url"]
                    # Convert to direct download link:
                    # https://tmpfiles.org/12345/filename.png -> https://tmpfiles.org/dl/12345/filename.png
                    direct_url = raw_url.replace("https://tmpfiles.org/", "https://tmpfiles.org/dl/")
                    results[img] = direct_url
                    print(f"Success: {img} -> {direct_url}")
                else:
                    print(f"Failed to upload {img}: {data}")
            else:
                print(f"Failed to upload {img}: Status code {response.status_code}")
    except Exception as e:
        print(f"Exception uploading {img}: {e}")

# Save results to a json file
out_path = "/Users/ashu/Freelance/ButterrEmailer/uploaded_urls.json"
with open(out_path, 'w') as f:
    json.dump(results, f, indent=2)

print("\nAll uploads completed!")
print(f"JSON mappings saved to {out_path}")
