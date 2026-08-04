# 🚀 Enterprise DevSecOps Pipeline: Node.js Microservice on Azure Kubernetes Service (AKS)

<div align="center">

[![Cloud: Azure](https://img.shields.io/badge/Cloud-Microsoft%20Azure-0089D6?style=flat-square&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Orchestration: Kubernetes](https://img.shields.io/badge/Orchestration-AKS-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://azure.kubernetes.com)
[![IaC: Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![CI/CD: Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Security: Snyk](https://img.shields.io/badge/Security-Snyk-4C4A73?style=flat-square&logo=snyk&logoColor=white)](https://snyk.io/)
[![Security: Trivy](https://img.shields.io/badge/Security-Trivy-23B9B0?style=flat-square&logo=aquasecurity&logoColor=white)](https://aquasecurity.github.io/trivy/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

*An enterprise-grade, fully automated shift-left DevSecOps and CI/CD reference architecture for securely deploying cloud-native Node.js microservices to Azure Kubernetes Service (AKS).*

</div>

---

## 🏛️ System Architecture & Workflow

The architecture implements a rigorous **shift-left security posture**, validating source code, third-party dependencies, and container images for vulnerabilities prior to hitting production clusters.

<a href="./images/Untitled.png" target="_blank">
  <img src="./images/Untitled.png" width="100%" alt="Enterprise DevSecOps Architecture Diagram">
</a>

### End-to-End Pipeline Stages
1. **Infrastructure as Code (IaC):** Modular Terraform provisions resource groups, virtual networks, and private/public AKS clusters on Azure.
2. **Checkout & Source Validation:** Jenkins orchestrates the build triggers upon Git push events.
3. **Static Application Security Testing (SAST) & SCA:** **Snyk** scans source code and package dependencies (`package.json`) to block known CVEs and license violations.
4. **Containerization & Image Scanning:** Docker builds an immutable, Alpine-based Node.js container image. **Trivy** performs deep filesystem and layer scanning for critical vulnerabilities.
5. **Artifact Publishing:** Securely pushed and stored in an Azure Container Registry (ACR) or repository.
6. **Declarative Release Management:** **Helm** charts handle deployment lifecycle automation into the AKS cluster with strictly constrained resource requests and limits.
7. **Ingress & Observability:** Traffic routed via NGINX Ingress Controller with automated TLS termination alongside health probes.

---

## 📂 Repository Structure

```text
├── terraform/                # Infrastructure as Code (Azure VNet, AKS, RG)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── helm/                     # Declarative Kubernetes Helm charts
│   ├── templates/            # Deployment, Service, Ingress manifests
│   ├── Chart.yaml
│   └── values.yaml           # Environment tuning & resource allocation
├── src/                      # Node.js application codebase
│   ├── server.js
│   ├── package.json
│   └── Dockerfile            # Multi-stage, security-hardened container build
├── images/                   # Architecture blueprints & visual documentation
│   └── Untitled.png
├── Jenkinsfile               # Declarative multi-stage CI/CD pipeline script
└── README.md
```

---

## 🛠️ Technology Stack

| Domain | Technology | Purpose |
| :--- | :--- | :--- |
| **Cloud Provider** | Microsoft Azure | High-availability cloud infrastructure and managed services |
| **Container Engine** | Azure Kubernetes Service (AKS) | Production-grade container orchestration |
| **Infrastructure as Code** | Terraform v1.5+ | Declarative cloud resource lifecycle management |
| **CI/CD Orchestration** | Jenkins | Automated multi-stage pipeline execution |
| **Security Scanning** | Snyk & Trivy | Dependency vulnerability checks & container layer scanning |
| **Package Management** | Helm 3 | Templated Kubernetes manifest packaging and releases |
| **Ingress Controller** | NGINX | Reverse proxy, secure routing, and TLS termination |

---

## 🔒 Security Best Practices Implemented

* **Shift-Left Vulnerability Gates:** Build jobs fail automatically if Snyk or Trivy identify High or Critical severity CVEs.
* **Immutable Base Images:** Node.js runtime utilizes explicit digest-pinned Alpine versions to minimize kernel surface exposure.
* **Principle of Least Privilege:** Dynamic secret injection handled securely through Jenkins Credentials Store rather than inline or plaintext environment variables.
* **Kubernetes Resource Governance:** Enforced CPU/Memory request and limit boundaries in Helm `values.yaml` to prevent pod resource starvation.

---

## 🚀 Getting Started & Deployment Guide

### Prerequisites
Ensure your local administrative environment or CI worker has access to the following tools:
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (Authenticated with subscription write permissions)
* [Terraform](https://www.terraform.io/) (v1.5.0+)
* [Helm](https://helm.sh/) (v3.0+)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/)

### Step 1: Clone the Repository
```bash
git clone https://github.com/praveenbhise07-art/life-insurance-app.git
cd life-insurance-app
```

### Step 2: Provision Infrastructure via Terraform
```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Step 3: Configure Jenkins Pipeline Credentials
In your Jenkins dashboard, navigate to **Manage Jenkins > Credentials** and configure the following secret keys:
* `AZURE_CREDENTIALS` (Service Principal JSON)
* `SNYK_TOKEN` (API Token for code and dependency auditing)
* `ACR_CREDENTIALS` (Registry username and password)

### Step 4: Execute Pipeline
Trigger the pipeline using the provided `Jenkinsfile` from your Jenkins master node or connected worker agents.

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
