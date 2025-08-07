#!/usr/bin/env python3
import os
import sys
import hashlib
import json
from datetime import datetime

BASE_FOLDER = "/storage/emulated/0/Milyes76"
EXPORT_FOLDER = os.path.join(BASE_FOLDER, "MyMap_Exports")
ARCHIVE_LOG = os.path.join(BASE_FOLDER, "netsecure_map_archive.json")

def hash_file(filepath):
    sha256 = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            sha256.update(chunk)
    return sha256.hexdigest()

def archive_map_file(filename):
    os.makedirs(EXPORT_FOLDER, exist_ok=True)
    full_path = os.path.join(EXPORT_FOLDER, filename)

    if not os.path.exists(full_path):
        print(f"❌ Le fichier {filename} n'existe pas dans {EXPORT_FOLDER}.")
        return 1

    file_hash = hash_file(full_path)

    archive_entry = {
        "filename": filename,
        "date": datetime.now().isoformat(),
        "sha256": file_hash,
        "project": "NetSecurePro_IA"
    }

    if os.path.exists(ARCHIVE_LOG):
        with open(ARCHIVE_LOG, "r") as f:
            archive = json.load(f)
    else:
        archive = []

    if any(e["sha256"] == file_hash for e in archive):
        print("⚠️ Ce fichier est déjà archivé.")
        return 0

    archive.append(archive_entry)
    with open(ARCHIVE_LOG, "w") as f:
        json.dump(archive, f, indent=2)

    print(f"✅ Fichier archivé : {filename}")
    print(f"🔒 SHA256 : {file_hash}")
    return 0

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: archive_map_android <nom_fichier>")
        sys.exit(1)
    filename = sys.argv[1]
    sys.exit(archive_map_file(filename))
