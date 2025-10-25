# docker-backup-to-git-arm64

Based on [istepanov/backup-to-git], adapted for **ARM64** platforms with a patched `command.sh` and `crontab`.

This container periodically backs up files from a mounted folder into a remote Git repository.

---

## **1. Prerequisites**

- Install **[Docker](https://docs.docker.com/get-docker/)** and **[Docker Compose](https://docs.docker.com/compose/)**  
- Have a **GitHub account**  
- Create a **GitHub repository** to store your backups (e.g. `my-backup-repo`)

---

## **2. Create a GitHub Personal Access Token (PAT)**

The container needs permission to push commits to your backup repository.

1. Go to **[GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)**  
2. Click **Generate new token (classic)**  
3. Give it a name like **`docker-backup`**  
4. Select scopes:  
   - **`repo`** → full control of private repositories  
   - **`workflow`** (optional, only if you want to push workflow files)  
5. **Generate the token** and copy it somewhere safe.  
   ⚠️ You won’t be able to see it again.

---

## **3. Configure environment variables**

This project uses a **`.env` file** to keep secrets out of your `compose.yaml`.

1. **Copy the example file**:  
   ```bash
   cp .env.example .env
   ```
2. **Open `.env`** in your editor and replace the placeholders:

```dotenv
# Daily backup identity
GIT_NAME_DAILY=Backup-Daily
GIT_EMAIL_DAILY=your-github-email@example.com
GIT_URL_DAILY=https://<your-username>:<your-personal-access-token>@github.com/<your-username>/<your-daily-repo>.git

# Monthly backup identity
GIT_NAME_MONTHLY=Backup-Monthly
GIT_EMAIL_MONTHLY=your-github-email@example.com
GIT_URL_MONTHLY=https://<your-username>:<your-personal-access-token>@github.com/<your-username>/<your-monthly-repo>.git
```

- Replace **`<your-username>`** with your GitHub username  
- Replace **`<your-personal-access-token>`** with the PAT you created  
- Replace **`<your-daily-repo>`** and **`<your-monthly-repo>`** with the names of your backup repositories  

---

## **4. Run with Docker Compose**

The `compose.yaml` defines two services: one for daily backups and one for monthly backups.

- **Start the containers**:  
  ```bash
  docker compose up -d
  ```

- **Check logs**:  
  ```bash
  docker compose logs -f git-backup-daily
  ```

- **Stop the containers**:  
  ```bash
  docker compose down
  ```

---

## **5. One-shot backup (optional)**

If you want to run a backup immediately without cron scheduling:

```bash
docker run --rm \
  --env-file .env \
  -v /path/to/data:/target:ro \
  ghcr.io/<your-username>/docker-backup-to-git-arm64 no-cron
```

---

## **6. Notes**

- `.env` should **never** be committed to Git — it contains secrets. Only commit `.env.example`.  
- The container defaults to pushing to the **`main` branch**.  
- Commit messages include a **UTC timestamp** by default.  

---

## **Example directory layout**

```
.
├── Dockerfile
├── command.sh
├── crontab
├── compose.yaml
├── .env.example
└── README.md
```
