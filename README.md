# docker-backup-to-git-arm64

Based on [istepanov/backup-to-git], adapted for **ARM64** platforms with a patched `command.sh` and `crontab`.

This container periodically backs up files from a mounted folder into a remote Git repository.

## Usage

```bash
docker run -d \
  -e GIT_NAME="Backup User" \
  -e GIT_EMAIL="backup_user@example.com" \
  -e GIT_URL="https://username:TOKEN@github.com/username/repo.git" \
  -v /home/user/data:/target:ro \
  ghcr.io/jezzaw007/docker-backup-to-git-arm64
