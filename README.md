# DevOps Tutorials For Beginner

> [!NOTE]
> *Find the best way to contribute my knowledge into DevOps for beginner :rocket:*

---

## What is DevOps?

DevOps is a mindset — not just a set of tools. It bridges the gap between **Development** (writing code) and **Operations** (deploying and running code). The goal is to deliver software faster, more reliably, and with fewer manual steps.

If you are new, think of it this way:

```
Code → Build → Test → Package → Deploy → Monitor → Repeat
```

This repo walks you through each phase using real Azure cloud tools so you learn by doing, not just reading.

---

## Prerequisites

Before starting, make sure you have these installed and configured:

| Tool | Purpose | Install Guide |
|------|---------|---------------|
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) | Interact with Azure cloud | `curl -sL https://aka.ms/InstallAzureCLIDeb \| sudo bash` |
| [Docker](https://docs.docker.com/get-docker/) | Build and run containers | `curl -fsSL https://get.docker.com \| sudo sh` |
| [Terraform](https://developer.hashicorp.com/terraform/install) | Provision cloud infrastructure | HashiCorp APT repo |
| [Packer](https://developer.hashicorp.com/packer/install) | Build VM images | HashiCorp APT repo |
| [Helm](https://helm.sh/docs/intro/install/) | Package manager for Kubernetes | `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \| bash` |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | Manage Kubernetes clusters | `az aks install-cli` |

You also need an **Azure subscription** with sufficient permissions to create resource groups, AKS clusters, and ACR registries.

---

## Learning Path — Start Here

Follow the modules in order. Each module builds on the previous one.

```
Module 1: Scripting Basics  →  Module 2: Docker  →  Module 3: Packer
                                                          ↓
Module 6: CI/CD Pipelines  ←  Module 5: Kubernetes  ←  Module 4: Terraform
```

---

## Module 1 — Scripting Basics

**Where:** [`script/`](script/)

**What you learn:** How to write Bash and PowerShell scripts for real DevOps tasks — file operations, process management, networking, SSL certificates, and JSON parsing.

**Why it matters:** Automation scripts are the backbone of DevOps. Before you use any fancy tool, you need to understand how to automate tasks from the command line.

### Challenges

The `script/resource/` folder contains 10 guided challenges in both Bash (`.sh`) and PowerShell (`.ps1`). Work through them in order:

| Script | Topic |
|--------|-------|
| [`p1`](script/resource/p1.sh) | Date validation and arithmetic |
| [`p2`](script/resource/p2.sh) | File listing and filtering |
| [`p3`](script/resource/p3.sh) | Dynamic script creation and execution |
| [`p4`](script/resource/p4.sh) | Process management |
| [`p5`](script/resource/p5.sh) | File download and ZIP extraction |
| [`p6`](script/resource/p6.sh) | Recursive directory cleanup |
| [`p7`](script/resource/p7.sh) | JSON parsing with `jq` |
| [`p8`](script/resource/p8.sh) | Port connectivity testing |
| [`p9`](script/resource/p9.sh) | SSH service control |
| [`p10`](script/resource/p10.sh) | Self-signed SSL certificate generation |

### Run the full setup script

```bash
cd script/
bash run_setup.sh
```

This script builds Docker images, manages SSL certs, and pushes to Azure Container Registry — a real-world example of automating a full workflow.

---

## Module 2 — Docker

**Where:** [`docker/`](docker/)

**What you learn:** How to containerize applications, build images, configure Nginx as a load balancer, and run multi-container apps with Docker Compose.

**Why it matters:** Containers are the unit of deployment in modern DevOps. Everything on Kubernetes runs as a container.

### Core concepts covered

```
Dockerfile → docker build → docker image
docker run → container
docker-compose → multiple containers working together
```

### Project structure

```
docker/
├── Dockerfile.web          # Node.js app image
├── Dockerfile.nginx        # Nginx reverse proxy with SSL
├── Dockerfile.nk8s         # Nginx for Kubernetes deployments
├── docker-compose.yaml     # 4-app + load balancer setup
├── conf/                   # Nginx configuration files
├── src/                    # Node.js app source code
└── resource/               # Step-by-step building blocks
    ├── Node_create/        # Learn: build Alpine + Node image from scratch
    ├── Node_project_hello/ # Node 20 hello world app
    ├── Node_project_hello_v12/ # Node 18 hello world (LTS)
    └── Node_project_hello_v14/ # Node 20 hello world (LTS)
```

### Hands-on steps

**Step 1 — Run a single Node app:**
```bash
cd docker/resource/Node_project_hello
bash bash_rundocker.sh
```

**Step 2 — Build custom Node image from scratch:**
```bash
cd docker/resource/Node_create
bash bash_node.sh
```

**Step 3 — Run the full multi-app setup:**
```bash
cd docker/resource
bash bash_run_all.sh
# Check all apps are up
bash bash_check_web_available.sh
```

**Step 4 — Clean up:**
```bash
bash bash_clear_all.sh
```

### Architecture (Docker Compose)
```
               ┌─────────────────┐
Internet ─────►│  nginx_alb :80  │  (load balancer)
               └────────┬────────┘
          ┌─────────────┼──────────────┐
          ▼             ▼              ▼
       app1:8001    app2:8002      app3:8003 ...
```

---

## Module 3 — Packer (VM Image Baking)

**Where:** [`packer/`](packer/)

**What you learn:** How to bake custom Azure VM images using Packer so every VM starts pre-configured instead of being configured at runtime.

**Why it matters:** "Immutable infrastructure" — instead of SSHing into a server to fix things, you bake a new image and redeploy. This makes your infrastructure predictable and faster to scale.

### Files overview

```
packer/
├── linux-vanilla.pkr.hcl   # HCL2 template: Ubuntu VM with Azure CLI
├── linux-docker.pkr.hcl    # HCL2 template: Ubuntu VM with Docker + Azure CLI
├── linux-vanilla.json      # Legacy JSON format (same as .hcl, kept for reference)
├── linux-docker.json       # Legacy JSON format (same as .hcl, kept for reference)
└── script/
    ├── setup-az.sh         # Installs Azure CLI on the VM
    └── setup-docker.sh     # Installs Docker Engine + Compose V2 on the VM
```

> **Note:** Prefer the `.pkr.hcl` files — they use the modern HCL2 format. The `.json` files are kept as a reference to understand legacy Packer syntax.

### Base image

All templates use **Ubuntu 22.04 LTS** on Azure:
- Publisher: `Canonical`
- Offer: `0001-com-ubuntu-server-jammy`
- SKU: `22_04-lts`

### Validate and build

```bash
# Login to Azure first
az login

# Validate the template
packer init packer/linux-docker.pkr.hcl
packer validate \
  -var "render_image_name=my-docker-image" \
  -var "resource_group_name=my-rg" \
  -var "build_resource_group_name=my-rg" \
  packer/linux-docker.pkr.hcl

# Build the image
packer build \
  -var "render_image_name=my-docker-image" \
  -var "resource_group_name=my-rg" \
  -var "build_resource_group_name=my-rg" \
  packer/linux-docker.pkr.hcl
```

---

## Module 4 — Terraform (Infrastructure as Code)

**Where:** [`terraform/`](terraform/)

**What you learn:** How to provision Azure infrastructure declaratively — VNets, AKS clusters, databases, storage accounts, load balancers, and CI/CD agent VMs.

**Why it matters:** Infrastructure as Code (IaC) means your cloud setup is version-controlled, repeatable, and reviewable like any other code. No more clicking through the Azure portal.

### Project structure

```
terraform/
├── azure/                  # Main Azure infrastructure
│   ├── env/dev/            # Entry point — run terraform here
│   └── modules/
│       ├── aks/            # Azure Kubernetes Service cluster
│       ├── networking/     # VNet, subnets
│       ├── iam/            # Identity and role assignments (ACR pull, AKS access)
│       ├── storageAccount/ # Azure Blob Storage
│       ├── database/       # Azure Database
│       ├── bastion/        # Azure Bastion for secure VM access
│       ├── loadBalancer/   # Azure Load Balancer
│       ├── serverless/     # Azure Functions / serverless resources
│       └── vmss/           # Virtual Machine Scale Sets
├── azure-agent/            # Self-hosted Azure DevOps pipeline agent VM
│   ├── linux-agent/        # Entry point for agent VM
│   └── modules/
│       ├── iam/
│       ├── network/
│       └── vm/
└── k8s/                    # Kubernetes-level deployments via Terraform + Helm
    ├── env/dev/            # Entry point — run terraform here after AKS is up
    └── modules/
        ├── ingress-controller/
        ├── applications/
        └── monitoring/
```

### Core Terraform workflow

```bash
cd terraform/azure/env/dev

# 1 — Initialize (downloads providers, sets up backend)
terraform init

# 2 — See what will be created
terraform plan -var-file="dev.tfvars"

# 3 — Create the infrastructure
terraform apply -var-file="dev.tfvars" -auto-approve

# 4 — Destroy when done (saves cost!)
terraform destroy -var-file="dev.tfvars" -auto-approve
```

### Or use the helper script

```bash
cd script/
bash run_terraform.sh
```

### Key concepts used here

| Feature | Where |
|---------|-------|
| Remote state (Azure Blob) | `azure/env/dev/providers.tf` |
| Module composition | `azure/env/dev/main.tf` |
| Conditional resource creation | `count = var.condition_variable == "aks" ? 1 : 0` |
| Dependency management | `depends_on = [module.network]` |
| Output passing between modules | `module.aks[0].principal_id` |

---

## Module 5 — Kubernetes with Helm

**Where:** [`kubernetes/`](kubernetes/)

**What you learn:** How to deploy applications to Kubernetes using Helm charts — deployments, services, ingress, persistent storage, and RBAC.

**Why it matters:** Kubernetes is the industry standard for running containers at scale. Helm makes managing Kubernetes manifests maintainable by templating repeated patterns.

### Chart overview

```
kubernetes/
├── app1/ app2/ app3/ app4/   # One Helm chart per Node.js microservice
├── nginx/                    # Nginx load balancer with ConfigMap routing
├── nginx-persistent/         # Nginx with persistent Azure File storage
├── common/                   # Shared ingress (nginx ingress controller)
└── rbac/                     # Service account + Role + RoleBinding
```

### Deploy flow

```bash
# 0 — Point kubectl to your AKS cluster
az aks get-credentials --resource-group <rg> --name <cluster>

# 1 — Create namespace
kubectl create namespace devops

# 2 — Install RBAC (service account and roles)
helm install rbac kubernetes/rbac -n devops

# 3 — Install apps
helm install web-app1 kubernetes/app1 -n devops
helm install web-app2 kubernetes/app2 -n devops
helm install web-app3 kubernetes/app3 -n devops
helm install web-app4 kubernetes/app4 -n devops

# 4 — Install Nginx load balancer
helm install nginx kubernetes/nginx -n devops

# 5 — Install ingress
helm install common kubernetes/common -n devops

# Verify everything is running
kubectl get pods -n devops
kubectl get svc -n devops
kubectl get ingress -n devops
```

### Architecture (Kubernetes)

```
                   ┌──────────────────┐
Internet ─────────►│  Ingress (nginx) │
                   └────────┬─────────┘
                            │
                   ┌────────▼─────────┐
                   │  Nginx ConfigMap │  (upstream routing)
                   └──┬──┬──┬──┬─────┘
                      │  │  │  │
                   app1 app2 app3 app4   (ClusterIP services)
```

### Key Kubernetes concepts used

| Concept | File |
|---------|------|
| Deployment | `app*/templates/deployment.yaml` |
| ClusterIP Service with session affinity | `app*/templates/service.yaml` |
| Nginx Ingress with `ingressClassName` | `common/templates/ingress.yaml` |
| ConfigMap for Nginx config | `nginx/templates/config.yaml` |
| PersistentVolumeClaim | `nginx-persistent/templates/pv-claim.yaml` |
| StorageClass (Azure File CSI) | `nginx-persistent/templates/storage.yaml` |
| Role + RoleBinding + ServiceAccount | `rbac/templates/` |

---

## Module 6 — CI/CD with Azure Pipelines

**Where:** [`azure-pipeline/`](azure-pipeline/)

**What you learn:** How to automate everything from the previous modules into a pipeline that runs on every code push — infrastructure provisioning, image building, and Kubernetes deployment.

**Why it matters:** CI/CD is the final piece of the DevOps loop. Humans stop clicking buttons; pipelines do the work consistently every time.

### Pipeline files

```
azure-pipeline/
├── azure-pipelines.yml         # Provision Azure infrastructure (Terraform)
├── azure-pipelines-destroy.yml # Destroy infrastructure (cleanup / teardown)
├── k8s-pipelines.yml           # Deploy to Kubernetes via Terraform + Helm
└── packer-pipeline.yml         # Build custom VM images with Packer
```

### Pipeline stages (azure-pipelines.yml)

```
┌──────────────────┐     ┌──────────────────┐
│  terraform_plan  │────►│ terraform_apply  │
│  (PR preview)    │     │ (after approval) │
└──────────────────┘     └──────────────────┘
```

### Self-hosted agent

The pipelines run on a **self-hosted Linux agent** provisioned by `terraform/azure-agent/`. This avoids Microsoft-hosted agent limitations and keeps your Azure resources on the same private network.

**To provision the agent VM:**
```bash
cd terraform/azure-agent/linux-agent
terraform init
terraform apply \
  -var "url_org=https://dev.azure.com/YOUR_ORG" \
  -var "token=YOUR_PAT_TOKEN" \
  -var "pool=linuxAgent" \
  -var "agent=agent-01"
```

### Pipeline variables to set in Azure DevOps

| Variable | Description |
|----------|-------------|
| `serviceConnection` | Azure service connection name |
| `environmentName` | Azure DevOps environment for approvals |
| `resourceGroup` | Terraform backend resource group |
| `storageAccount` | Terraform state storage account |
| `renderImageName` | Name for Packer-built VM image |

---

## Full Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Azure DevOps                            │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────────┐  │
│  │  Packer     │  │  Terraform   │  │  K8s Deployment   │  │
│  │  Pipeline   │  │  Pipeline    │  │  Pipeline         │  │
│  └──────┬──────┘  └──────┬───────┘  └────────┬──────────┘  │
└─────────┼───────────────-┼───────────────────-┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
   Azure Managed    ┌─────────────┐      ┌───────────┐
   Image (Ubuntu    │ Azure IaaS  │      │  AKS      │
   22.04 + Docker)  │ VNet / IAM  │      │  Cluster  │
                    │ Storage     │      │  + Helm   │
                    └─────────────┘      └───────────┘
                                               │
                                    ┌──────────▼─────────┐
                                    │  app1  app2  app3  │
                                    │  app4  nginx  rbac │
                                    └────────────────────┘
```

---

## Troubleshooting

**Terraform state lock:**
```bash
terraform force-unlock <lock-id>
```

**AKS credentials expired:**
```bash
az aks get-credentials --resource-group <rg> --name <cluster> --overwrite-existing
```

**Helm release already exists:**
```bash
helm upgrade --install <release-name> <chart-path> -n <namespace>
```

**Packer build fails on authentication:**
```bash
az login
az account set --subscription <subscription-id>
```

**Docker Compose not found (V2):**
```bash
docker compose version   # note: no hyphen in V2
# If missing, install the plugin:
mkdir -p ~/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
```

---

## Contributing

Found something outdated or want to add a new module? Open a PR! Focus areas for future modules:
- Module 7: Monitoring with Prometheus + Grafana (see `terraform/k8s/modules/monitoring/`)
- Module 8: Azure Key Vault integration for secrets management
- Module 9: GitOps with ArgoCD or Flux

---

*Happy learning! DevOps is a journey, not a destination.*

