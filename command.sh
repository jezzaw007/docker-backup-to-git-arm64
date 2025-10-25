#!/bin/bash
set -euo pipefail

: ${GIT_NAME:?"GIT_NAME env variable is required"}
: ${GIT_EMAIL:?"GIT_EMAIL env variable is required"}
: ${GIT_URL:?"GIT_URL env variable is required"}
: ${GIT_BRANCH:="main"}
: ${GIT_COMMIT_MESSAGE:="Backup: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"}
: ${TARGET_FOLDER:="/target"}

export GIT_DIR="/var/git"
export GIT_WORK_TREE="$TARGET_FOLDER"

echo "Job started: $(date)"
echo "Backing up $GIT_WORK_TREE to $GIT_URL ($GIT_BRANCH)"

if [ ! -d "$GIT_DIR" ]; then
    mkdir -p "$GIT_DIR"
    git init -b "$GIT_BRANCH"
    git config user.name "$GIT_NAME"
    git config user.email "$GIT_EMAIL"
    git remote add origin "$GIT_URL"
fi

git fetch origin "$GIT_BRANCH" || true
git checkout -B "$GIT_BRANCH" "origin/$GIT_BRANCH" || git checkout -B "$GIT_BRANCH"

git add -A
git commit -m "$GIT_COMMIT_MESSAGE" || echo "Nothing to commit"
git push origin "$GIT_BRANCH"

echo "Job finished: $(date)"
