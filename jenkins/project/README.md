# CI pipeline (Jenkins + Git + Maven + SonarQube + Nexus)

## 1. Purpose

This repo automates:
- ALl server is EC2 instances and have secure SG to connect privately
- Fetching source code from a central Git repository
- Building the application and generating artifacts
- Running unit tests and publishing test reports
- Performing static code analysis (quality + security)
- Enforcing a **Quality Gate** (block pipeline on violations)
- Publishing a verified artifact to an artifact repository (Nexus)
- Notification with Slack

## 2. Pipeline

```
Commit/Push
        |
        v
Jenkins triggers pipeline
        |
        v
Fetch Code (Git)
        |
        v
Build (Maven)
        |
        v
Unit Tests (Maven)
        |
        v
Static Code Analysis (SonarQube / Checkstyle)
        |
        v
Quality Gate (Pass/Fail)
        |
        v
Publish Artifact (Nexus Repository)
```

---

## 3. Tools Used

| Tool       | Role in the Pipeline |
|------------|-----------------------|
| GitHub     | Source code repository (centralized SCM) |
| Jenkins    | CI orchestrator (pipeline execution engine) |
| Git        | Fetch/checkout source code |
| Maven      | Build automation + unit testing |
| SonarQube  | Static code analysis, security checks, quality gate |
| Nexus OSS  | Artifact repository (store/version built packages) |

---

## 4. Prerequisites

### Jenkins
- Jenkins installed and reachable
- Recommended plugins:
  - Git plugin
  - Pipeline
  - Maven Integration (optional, can run Maven via shell)
  - SonarQube Scanner for Jenkins (recommended)
  - Nexus Artifact Uploader (optional; Maven deploy can be used instead)

### SonarQube
- SonarQube server up and accessible from Jenkins
- SonarQube token for Jenkins integration
- Quality Gate configured (optional but recommended)

### Nexus OSS
- Nexus Repository Manager OSS up and accessible from Jenkins
- Maven hosted repository created (e.g., `maven-releases`, `maven-snapshots`)
- Credentials configured for uploading/deploying artifacts

### Build Requirements
- JDK installed (matching project)
- Maven installed (or use Maven tool in Jenkins Global Tools)

---
