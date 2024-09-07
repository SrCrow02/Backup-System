#!/usr/bin/bash

echo "Type 'enc' if you want to encrypt or 'dec' if you want to decrypt:"
read CHOICE

# Origin
SOURCE_DIR="Path to your folder"

# Destination
external_storage="Path to the HD/SSD/Whatever you want folder"

if [ "$CHOICE" = "enc" ]; then
  backup_dir="$external_storage/backup"
  backup_file="$backup_dir/backup.tar.gz"   
  encrypted_backup_file="$backup_dir/backup.tar.gz.enc"

  if [ ! -d "$external_storage" ]; then
    echo "The destination directory does not exist!"   
    exit 1
  fi

  mkdir -p "$backup_dir"

  tar -czvf "$backup_file" -C "$SOURCE_DIR" .

  # Encrypt with AES-256-CBC
  openssl enc -aes-256-cbc -salt -in "$backup_file" -out "$encrypted_backup_file" -k "guilherme"

  rm "$backup_file"

  echo "Backup completed and encrypted successfully."

elif [ "$CHOICE" = "dec" ]; then
  backup_dir="$external_storage/backup"
  backup_file="$backup_dir/backup.tar.gz"   
  encrypted_backup_file="$backup_dir/backup.tar.gz.enc"

  if [ ! -f "$encrypted_backup_file" ]; then
    echo "Encrypted file not found!"
    exit 1
  fi

  # Decrypt with AES-256-CBC
  openssl enc -d -aes-256-cbc -in "$encrypted_backup_file" -out "$backup_file" -k "guilherme"

  # Restore the backup
  tar -xzvf "$backup_file" -C "$SOURCE_DIR" 

  echo "Backup decrypted and restored successfully."

else
  echo "Invalid choice"
  exit 1
fi
