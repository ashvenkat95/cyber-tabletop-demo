# DevSecOps Simulation Demo

A simple Node.js application demonstrating automated security testing with **Snyk** (dependency vulnerability scanning) and **GitLeaks** (secret detection) in a DevSecOps pipeline.

## Project Structure

```
cyber-tabletop-demo/
├── frontend/
│   └── index.html
├── backend/
│   ├── server.js           (clean - no vulnerabilities)
│   ├── server-vulnerable.js (example with hardcoded secret)
│   └── package.json
├── .github/
│   └── workflows/
│       └── security-pipeline.yml
└── README.md
```

---

## How to Simulate

### Option A: Run the App Locally

1. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Start the backend server**
   ```bash
   node server.js
   ```
   Server runs at: **http://localhost:3000**

3. **Open the frontend**  
   Open `frontend/index.html` in your browser. Click **"Run Simulation"** to call the API.

---

### Option B: Run Security Scans Locally (Without GitHub)

1. **Install Snyk CLI** (via npm)
   ```bash
   npm install -g snyk
   ```

2. **Install GitLeaks**  
   - Download from [GitLeaks releases](https://github.com/gitleaks/gitleaks/releases), or  
   - Run via Docker: `docker pull zricethezav/gitleaks:v8.18.0`

3. **Get and set Snyk token**  
   - Sign up at [app.snyk.io](https://app.snyk.io) (free)
   - Account → Settings → API token → copy
   ```powershell
   # Windows (PowerShell)
   $env:SNYK_TOKEN = "your-snyk-token"
   ```

4. **Run security scans**
   ```powershell
   cd cyber-tabletop-demo
   .\run-security-scan.ps1
   ```

5. **Or run scans manually**
   ```bash
   # Snyk (in backend folder)
   cd backend && snyk test

   # GitLeaks
   gitleaks detect
   # or: docker run --rm -v ${PWD}:/repo zricethezav/gitleaks:v8.18.0 detect --source=/repo
   ```

---

### Option C: Full GitHub Actions Pipeline

1. **Add Snyk token to GitHub**
   - GitHub repo → **Settings** → **Secrets and variables** → **Actions**
   - Add secret: `SNYK_TOKEN` = (get from [app.snyk.io](https://app.snyk.io) → Account → API token)

2. **Create and push to a GitHub repo**
   ```bash
   cd cyber-tabletop-demo
   git init
   git add .
   git commit -m "Initial demo app"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

3. **Pipeline runs on push**  
   - Snyk scans dependencies for vulnerabilities  
   - GitLeaks scans for secrets  
   - Check **Actions** tab for results

---

### Testing Secret Detection (Pipeline Failure)

1. Add a hardcoded secret to `backend/server.js`:
   ```javascript
   const apiKey = "12345-SECRET-KEY";
   ```

2. Push to GitHub. GitLeaks will detect it and the pipeline will **FAIL**.

3. Or run GitLeaks locally after adding the line:
   ```bash
   gitleaks detect
   # or
   docker run --rm -v ${PWD}:/repo zricethezav/gitleaks:v8.18.0 detect --source=/repo
   ```

---

## Architecture

```
User Browser → Frontend (HTML) → Node.js Express Backend → API Response
```

## DevSecOps Flow

```
Developer pushes code → GitHub Actions → Snyk + GitLeaks → Pass / Fail
```
