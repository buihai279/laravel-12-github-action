#!/bin/bash

# Backup Script for ThinkView Laravel Migration
# Created: $(date)

BACKUP_DIR="/Users/haibv/Desktop/workspace/www/thinkview-laravel-12/backups"
PROJECT_DIR="/Users/haibv/Desktop/workspace/www/thinkview-laravel-12/thinkview-old"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "=== ThinkView Laravel Backup Script ==="
echo "Timestamp: $TIMESTAMP"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# 1. Backup source code
echo "1. Backing up source code..."
tar -czf "$BACKUP_DIR/thinkview-old-source-$TIMESTAMP.tar.gz" -C "$PROJECT_DIR" .

# 2. Backup database (if exists)
echo "2. Backing up database..."
if [ -f "$PROJECT_DIR/.env" ]; then
    # Extract database credentials from .env
    DB_DATABASE=$(grep DB_DATABASE "$PROJECT_DIR/.env" | cut -d '=' -f2)
    DB_USERNAME=$(grep DB_USERNAME "$PROJECT_DIR/.env" | cut -d '=' -f2)
    DB_PASSWORD=$(grep DB_PASSWORD "$PROJECT_DIR/.env" | cut -d '=' -f2)
    DB_HOST=$(grep DB_HOST "$PROJECT_DIR/.env" | cut -d '=' -f2)
    
    if [ ! -z "$DB_DATABASE" ]; then
        mysqldump -h "$DB_HOST" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" > "$BACKUP_DIR/thinkview-old-db-$TIMESTAMP.sql"
        echo "Database backed up successfully"
    fi
else
    echo "No .env file found, skipping database backup"
fi

# 3. Backup storage files
echo "3. Backing up storage files..."
if [ -d "$PROJECT_DIR/storage" ]; then
    tar -czf "$BACKUP_DIR/thinkview-old-storage-$TIMESTAMP.tar.gz" -C "$PROJECT_DIR" storage/
fi

# 4. Create backup manifest
echo "4. Creating backup manifest..."
cat > "$BACKUP_DIR/backup-manifest-$TIMESTAMP.txt" << EOF
ThinkView Laravel Backup Manifest
Generated: $(date)
Project: thinkview-old
Laravel Version: 8.0
PHP Version: 8.0

Files Created:
- thinkview-old-source-$TIMESTAMP.tar.gz (Source code)
- thinkview-old-db-$TIMESTAMP.sql (Database backup)
- thinkview-old-storage-$TIMESTAMP.tar.gz (Storage files)

Restore Instructions:
1. Extract source code: tar -xzf thinkview-old-source-$TIMESTAMP.tar.gz
2. Restore database: mysql -u username -p database_name < thinkview-old-db-$TIMESTAMP.sql
3. Extract storage: tar -xzf thinkview-old-storage-$TIMESTAMP.tar.gz
EOF

echo "=== Backup completed successfully ==="
echo "Backup location: $BACKUP_DIR"
echo "Manifest: $BACKUP_DIR/backup-manifest-$TIMESTAMP.txt"