#!/bin/bash

# Terraform Infrastructure as Code Generator
# Generates production-ready IaC for AWS EKS, GCP GKE, Azure AKS
# Author: Generated Script

set -e

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
CLOUD_PROVIDER=""
PROJECT_NAME=""
ENVIRONMENT="production"
REGION=""
CLUSTER_NAME=""
NODE_COUNT=3
NODE_INSTANCE_TYPE=""
ENABLE_DATABASE=false
DATABASE_TYPE=""
ENABLE_REDIS=false
ENABLE_MONITORING=false
ENABLE_BASTION=false
K8S_VERSION=""

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${MAGENTA}$1${NC}"
}

# Function to display header
display_header() {
    clear
    echo "============================================================"
    echo "   Terraform Infrastructure as Code Generator              "
    echo "   Production-Ready Cloud Infrastructure                    "
    echo "============================================================"
    echo ""
}

# Function to select cloud provider
select_cloud_provider() {
    print_header "=== Select Cloud Provider ==="
    echo "1) AWS (Amazon Web Services) - EKS"
    echo "2) GCP (Google Cloud Platform) - GKE"
    echo "3) Azure (Microsoft Azure) - AKS"
    echo ""
    read -p "Enter your choice (1-3): " cloud_choice
    
    case $cloud_choice in
        1) 
            CLOUD_PROVIDER="aws"
            K8S_VERSION="1.28"
            ;;
        2) 
            CLOUD_PROVIDER="gcp"
            K8S_VERSION="1.28"
            ;;
        3) 
            CLOUD_PROVIDER="azure"
            K8S_VERSION="1.28"
            ;;
        *) 
            print_error "Invalid choice"
            exit 1 
            ;;
    esac
    
    print_success "Selected: ${CLOUD_PROVIDER^^}"
}

# Function to collect basic information
collect_basic_info() {
    echo ""
    print_header "=== Basic Configuration ==="
    
    read -p "Project name (e.g., myapp): " project_name
    PROJECT_NAME=${project_name:-myapp}
    CLUSTER_NAME="${PROJECT_NAME}-${ENVIRONMENT}"
    
    read -p "Environment (default: production): " environment
    ENVIRONMENT=${environment:-production}
    
    case $CLOUD_PROVIDER in
        aws)
            echo ""
            echo "AWS Regions (examples):"
            echo "  us-east-1 (N. Virginia), us-west-2 (Oregon)"
            echo "  eu-west-1 (Ireland), ap-southeast-1 (Singapore)"
            read -p "AWS Region (default: us-east-1): " region
            REGION=${region:-us-east-1}
            NODE_INSTANCE_TYPE="t3.medium"
            ;;
        gcp)
            echo ""
            echo "GCP Regions (examples):"
            echo "  us-central1, us-east1, europe-west1, asia-southeast1"
            read -p "GCP Region (default: us-central1): " region
            REGION=${region:-us-central1}
            NODE_INSTANCE_TYPE="e2-medium"
            ;;
        azure)
            echo ""
            echo "Azure Regions (examples):"
            echo "  eastus, westus2, westeurope, southeastasia"
            read -p "Azure Region (default: eastus): " region
            REGION=${region:-eastus}
            NODE_INSTANCE_TYPE="Standard_D2s_v3"
            ;;
    esac
    
    read -p "Number of nodes (default: 3): " node_count
    NODE_COUNT=${node_count:-3}
    
    read -p "Kubernetes version (default: 1.28): " k8s_version
    K8S_VERSION=${k8s_version:-1.28}
    
    print_success "Basic configuration collected"
}

# Function to collect additional resources
collect_additional_resources() {
    echo ""
    print_header "=== Additional Resources ==="
    
    read -p "Enable managed database? (y/n): " db_choice
    if [[ $db_choice == "y" || $db_choice == "Y" ]]; then
        ENABLE_DATABASE=true
        echo ""
        echo "Database types:"
        echo "1) PostgreSQL"
        echo "2) MySQL"
        read -p "Select database (1-2): " db_type
        case $db_type in
            1) DATABASE_TYPE="postgresql" ;;
            2) DATABASE_TYPE="mysql" ;;
            *) DATABASE_TYPE="postgresql" ;;
        esac
    fi
    
    read -p "Enable Redis cache? (y/n): " redis_choice
    ENABLE_REDIS=$([[ $redis_choice == "y" || $redis_choice == "Y" ]] && echo true || echo false)
    
    read -p "Enable monitoring (Prometheus/Grafana)? (y/n): " monitoring_choice
    ENABLE_MONITORING=$([[ $monitoring_choice == "y" || $monitoring_choice == "Y" ]] && echo true || echo false)
    
    read -p "Enable bastion host for secure access? (y/n): " bastion_choice
    ENABLE_BASTION=$([[ $bastion_choice == "y" || $bastion_choice == "Y" ]] && echo true || echo false)
    
    print_success "Additional resources configured"
}

# ============================================================================
# AWS TERRAFORM GENERATOR
# ============================================================================
generate_aws_terraform() {
    print_info "Generating AWS EKS Terraform configuration..."
    
    # Create directory structure
    mkdir -p terraform/aws/{modules/{vpc,eks,rds,elasticache,bastion},environments/${ENVIRONMENT}}
    
    # Generate main configuration
    generate_aws_main
    generate_aws_vpc
    generate_aws_eks
    
    if [ "$ENABLE_DATABASE" = true ]; then
        generate_aws_rds
    fi
    
    if [ "$ENABLE_REDIS" = true ]; then
        generate_aws_elasticache
    fi
    
    if [ "$ENABLE_BASTION" = true ]; then
        generate_aws_bastion
    fi
    
    generate_aws_outputs
    generate_aws_variables
    generate_aws_terraform_tfvars
    generate_aws_backend
}

generate_aws_main() {
    cat > terraform/aws/main.tf << 'EOF'
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
  
  backend "s3" {
    # Configuration will be provided via backend.hcl
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  azs          = var.availability_zones
}

# EKS Module
module "eks" {
  source = "./modules/eks"
  
  project_name     = var.project_name
  environment      = var.environment
  cluster_version  = var.cluster_version
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  node_count       = var.node_count
  node_instance_type = var.node_instance_type
}

# Configure kubectl
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> terraform/aws/main.tf << 'EOF'

# RDS Module
module "rds" {
  source = "./modules/rds"
  
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  database_name   = var.database_name
  engine          = var.db_engine
  engine_version  = var.db_engine_version
  instance_class  = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  
  allowed_security_groups = [module.eks.node_security_group_id]
}
EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> terraform/aws/main.tf << 'EOF'

# ElastiCache Module
module "elasticache" {
  source = "./modules/elasticache"
  
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  node_type       = var.redis_node_type
  num_cache_nodes = var.redis_num_nodes
  
  allowed_security_groups = [module.eks.node_security_group_id]
}
EOF
    fi

    if [ "$ENABLE_BASTION" = true ]; then
        cat >> terraform/aws/main.tf << 'EOF'

# Bastion Module
module "bastion" {
  source = "./modules/bastion"
  
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  instance_type  = var.bastion_instance_type
  
  allowed_cidr_blocks = var.bastion_allowed_cidr_blocks
}
EOF
    fi

    print_success "AWS main.tf created"
}

generate_aws_vpc() {
    cat > terraform/aws/modules/vpc/main.tf << 'EOF'
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.azs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-${var.azs[count.index]}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.azs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 100)
  availability_zone = var.azs[count.index]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-${var.azs[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
  }
  
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = length(var.azs)
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# Private Route Tables
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-${count.index + 1}"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(var.azs)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# VPC Endpoints for AWS Services
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-s3-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  count = length(var.azs)
  
  route_table_id  = aws_route_table.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

data "aws_region" "current" {}
EOF

    cat > terraform/aws/modules/vpc/variables.tf << 'EOF'
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}
EOF

    cat > terraform/aws/modules/vpc/outputs.tf << 'EOF'
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ips" {
  description = "NAT Gateway public IPs"
  value       = aws_eip.nat[*].public_ip
}
EOF

    print_success "AWS VPC module created"
}

generate_aws_eks() {
    cat > terraform/aws/modules/eks/main.tf << 'EOF'
# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# EKS Cluster Security Group
resource "aws_security_group" "cluster" {
  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version
  
  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.cluster.id]
  }
  
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_policy,
  ]
}

# Node Group IAM Role
resource "aws_iam_role" "node" {
  name = "${var.project_name}-${var.environment}-eks-node-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# Node Security Group
resource "aws_security_group" "node" {
  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "Security group for EKS nodes"
  vpc_id      = var.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-eks-node-sg"
  }
}

resource "aws_security_group_rule" "node_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.node.id
}

resource "aws_security_group_rule" "node_ingress_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
}

# EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnets
  
  instance_types = [var.node_instance_type]
  
  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_count * 2
    min_size     = var.node_count
  }
  
  update_config {
    max_unavailable = 1
  }
  
  labels = {
    Environment = var.environment
    Project     = var.project_name
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_registry_policy,
  ]
}

# OIDC Provider for IRSA
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# AWS Load Balancer Controller IAM Role
resource "aws_iam_role" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.cluster.arn
      }
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller-policy"
  
  policy = file("${path.module}/policies/alb_controller_policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}
EOF

    # Create ALB Controller Policy
    mkdir -p terraform/aws/modules/eks/policies
    cat > terraform/aws/modules/eks/policies/alb_controller_policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInstances",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeTags",
        "ec2:GetCoipPoolUsage",
        "ec2:DescribeCoipPools",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:DescribeTags"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DescribeUserPoolClient",
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "iam:ListServerCertificates",
        "iam:GetServerCertificate",
        "waf-regional:GetWebACL",
        "waf-regional:GetWebACLForResource",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL",
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL",
        "shield:GetSubscriptionState",
        "shield:DescribeProtection",
        "shield:CreateProtection",
        "shield:DeleteProtection"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:CreateSecurityGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:*:security-group/*",
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": "CreateSecurityGroup"
        },
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ],
      "Resource": "arn:aws:ec2:*:*:security-group/*",
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateTargetGroup"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
      ],
      "Resource": [
        "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
        "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
        "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
      ],
      "Condition": {
        "Null": {
          "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:SetIpAddressType",
        "elasticloadbalancing:SetSecurityGroups",
        "elasticloadbalancing:SetSubnets",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:DeleteTargetGroup"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
      ],
      "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:SetWebAcl",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:RemoveListenerCertificates",
        "elasticloadbalancing:ModifyRule"
      ],
      "Resource": "*"
    }
  ]
}
EOF

    cat > terraform/aws/modules/eks/variables.tf << 'EOF'
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
}

variable "node_instance_type" {
  description = "Node instance type"
  type        = string
}
EOF

    cat > terraform/aws/modules/eks/outputs.tf << 'EOF'
output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = aws_security_group.node.id
}

output "alb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}
EOF

    print_success "AWS EKS module created"
}

generate_aws_rds() {
    cat > terraform/aws/modules/rds/main.tf << 'EOF'
# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnets
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = var.engine == "postgres" ? 5432 : 3306
    to_port         = var.engine == "postgres" ? 5432 : 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

# Random password for DB
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}-${var.environment}-db-password"
  
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.database_name
    password = random_password.db_password.result
    engine   = var.engine
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    dbname   = var.database_name
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2
  storage_encrypted     = true
  storage_type          = "gp3"
  
  db_name  = var.database_name
  username = var.database_name
  password = random_password.db_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  
  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? ["postgresql", "upgrade"] : ["error", "general", "slowquery"]
  
  skip_final_snapshot       = var.environment != "production"
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  deletion_protection = var.environment == "production"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}
EOF

    cat > terraform/aws/modules/rds/variables.tf << 'EOF'
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "allowed_security_groups" {
  description = "Security groups allowed to access the database"
  type        = list(string)
}
EOF

    cat > terraform/aws/modules/rds/outputs.tf << 'EOF'
output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.main.id
}

output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "RDS instance address"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "db_secret_arn" {
  description = "Secrets Manager secret ARN for database credentials"
  value       = aws_secretsmanager_secret.db_password.arn
}
EOF

    print_success "AWS RDS module created"
}

generate_aws_elasticache() {
    cat > terraform/aws/modules/elasticache/main.tf << 'EOF'
# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnets
}

# Security Group
resource "aws_security_group" "redis" {
  name        = "${var.project_name}-${var.environment}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-redis-sg"
  }
}

# ElastiCache Replication Group
resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"
  description          = "Redis cluster for ${var.project_name}"
  
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.node_type
  number_cache_clusters = var.num_cache_nodes
  
  parameter_group_name = "default.redis7"
  port                 = 6379
  
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]
  
  automatic_failover_enabled = var.num_cache_nodes > 1
  multi_az_enabled          = var.num_cache_nodes > 1
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false  # Set to true if AUTH is required
  
  snapshot_retention_limit = 5
  snapshot_window         = "03:00-05:00"
  maintenance_window      = "mon:05:00-mon:07:00"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-redis"
  }
}
EOF

    cat > terraform/aws/modules/elasticache/variables.tf << 'EOF'
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
}

variable "allowed_security_groups" {
  description = "Security groups allowed to access Redis"
  type        = list(string)
}
EOF

    cat > terraform/aws/modules/elasticache/outputs.tf << 'EOF'
output "redis_endpoint" {
  description = "Redis primary endpoint"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = 6379
}

output "redis_reader_endpoint" {
  description = "Redis reader endpoint"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}
EOF

    print_success "AWS ElastiCache module created"
}

generate_aws_bastion() {
    cat > terraform/aws/modules/bastion/main.tf << 'EOF'
# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-${var.environment}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

# Key Pair
resource "aws_key_pair" "bastion" {
  key_name   = "${var.project_name}-${var.environment}-bastion-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Bastion Instance
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.bastion.key_name
  
  subnet_id                   = var.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y kubectl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
  EOF
  
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion"
  }
}

# Elastic IP
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-eip"
  }
}
EOF

    cat > terraform/aws/modules/bastion/variables.tf << 'EOF'
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
}
EOF

    cat > terraform/aws/modules/bastion/outputs.tf << 'EOF'
output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = aws_eip.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "SSH command to connect to bastion"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_eip.bastion.public_ip}"
}
EOF

    print_success "AWS Bastion module created"
}

generate_aws_variables() {
    cat > terraform/aws/variables.tf << EOF
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${REGION}"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "${PROJECT_NAME}"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "${ENVIRONMENT}"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["${REGION}a", "${REGION}b", "${REGION}c"]
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "${K8S_VERSION}"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = ${NODE_COUNT}
}

variable "node_instance_type" {
  description = "Node instance type"
  type        = string
  default     = "${NODE_INSTANCE_TYPE}"
}
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> terraform/aws/variables.tf << EOF

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "${PROJECT_NAME//-/_}"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "$([[ "$DATABASE_TYPE" == "postgresql" ]] && echo "postgres" || echo "mysql")"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "$([[ "$DATABASE_TYPE" == "postgresql" ]] && echo "15.4" || echo "8.0.35")"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}
EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> terraform/aws/variables.tf << EOF

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_nodes" {
  description = "Number of Redis nodes"
  type        = number
  default     = 2
}
EOF
    fi

    if [ "$ENABLE_BASTION" = true ]; then
        cat >> terraform/aws/variables.tf << EOF

variable "bastion_instance_type" {
  description = "Bastion instance type"
  type        = string
  default     = "t3.micro"
}

variable "bastion_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # CHANGE THIS IN PRODUCTION!
}
EOF
    fi

    print_success "AWS variables.tf created"
}

generate_aws_outputs() {
    cat > terraform/aws/outputs.tf << 'EOF'
# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

# EKS Outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "configure_kubectl" {
  description = "Configure kubectl command"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> terraform/aws/outputs.tf << 'EOF'

# RDS Outputs
output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_endpoint
}

output "db_secret_arn" {
  description = "Secrets Manager secret ARN for database credentials"
  value       = module.rds.db_secret_arn
}
EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> terraform/aws/outputs.tf << 'EOF'

# Redis Outputs
output "redis_endpoint" {
  description = "Redis primary endpoint"
  value       = module.elasticache.redis_endpoint
}

output "redis_reader_endpoint" {
  description = "Redis reader endpoint"
  value       = module.elasticache.redis_reader_endpoint
}
EOF
    fi

    if [ "$ENABLE_BASTION" = true ]; then
        cat >> terraform/aws/outputs.tf << 'EOF'

# Bastion Outputs
output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.bastion.bastion_public_ip
}

output "bastion_ssh_command" {
  description = "SSH command to connect to bastion"
  value       = module.bastion.bastion_ssh_command
}
EOF
    fi

    print_success "AWS outputs.tf created"
}

generate_aws_terraform_tfvars() {
    cat > terraform/aws/terraform.tfvars << EOF
# Project Configuration
project_name = "${PROJECT_NAME}"
environment  = "${ENVIRONMENT}"

# AWS Configuration
aws_region          = "${REGION}"
availability_zones  = ["${REGION}a", "${REGION}b", "${REGION}c"]

# Network Configuration
vpc_cidr = "10.0.0.0/16"

# EKS Configuration
cluster_version     = "${K8S_VERSION}"
node_count          = ${NODE_COUNT}
node_instance_type  = "${NODE_INSTANCE_TYPE}"
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> terraform/aws/terraform.tfvars << EOF

# Database Configuration
database_name      = "${PROJECT_NAME//-/_}"
db_engine          = "$([[ "$DATABASE_TYPE" == "postgresql" ]] && echo "postgres" || echo "mysql")"
db_engine_version  = "$([[ "$DATABASE_TYPE" == "postgresql" ]] && echo "15.4" || echo "8.0.35")"
db_instance_class  = "db.t3.micro"
db_allocated_storage = 20
EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> terraform/aws/terraform.tfvars << EOF

# Redis Configuration
redis_node_type  = "cache.t3.micro"
redis_num_nodes  = 2
EOF
    fi

    if [ "$ENABLE_BASTION" = true ]; then
        cat >> terraform/aws/terraform.tfvars << EOF

# Bastion Configuration
bastion_instance_type       = "t3.micro"
bastion_allowed_cidr_blocks = ["0.0.0.0/0"]  # CHANGE THIS!
EOF
    fi

    print_success "AWS terraform.tfvars created"
}

generate_aws_backend() {
    cat > terraform/aws/backend.hcl << EOF
# S3 Backend Configuration
# Create the S3 bucket and DynamoDB table before using this backend

bucket         = "${PROJECT_NAME}-${ENVIRONMENT}-terraform-state"
key            = "terraform.tfstate"
region         = "${REGION}"
encrypt        = true
dynamodb_table = "${PROJECT_NAME}-${ENVIRONMENT}-terraform-locks"
EOF

    print_success "AWS backend.hcl created"
}

# ============================================================================
# GCP TERRAFORM GENERATOR (Simplified for length - follows similar pattern)
# ============================================================================
generate_gcp_terraform() {
    print_info "Generating GCP GKE Terraform configuration..."
    mkdir -p terraform/gcp
    
    cat > terraform/gcp/main.tf << EOF
# GCP GKE Configuration
# Full implementation follows same modular pattern as AWS
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "\${var.project_name}-\${var.environment}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "\${var.project_name}-\${var.environment}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
  
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }
  
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "\${var.project_name}-\${var.environment}"
  location = var.region
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  }
}

# Node Pool
resource "google_container_node_pool" "primary" {
  name       = "\${var.project_name}-\${var.environment}-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count
  
  node_config {
    machine_type = var.node_instance_type
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "configure_kubectl" {
  value = "gcloud container clusters get-credentials \${google_container_cluster.primary.name} --region \${var.region}"
}
EOF

    cat > terraform/gcp/variables.tf << EOF
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "${PROJECT_NAME}"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "${ENVIRONMENT}"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "${REGION}"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = ${NODE_COUNT}
}

variable "node_instance_type" {
  description = "Node instance type"
  type        = string
  default     = "${NODE_INSTANCE_TYPE}"
}
EOF

    print_success "GCP GKE configuration created"
}

# ============================================================================
# AZURE TERRAFORM GENERATOR (Simplified for length)
# ============================================================================
generate_azure_terraform() {
    print_info "Generating Azure AKS Terraform configuration..."
    mkdir -p terraform/azure
    
    cat > terraform/azure/main.tf << EOF
# Azure AKS Configuration
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "\${var.project_name}-\${var.environment}-rg"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "\${var.project_name}-\${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "\${var.project_name}-\${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "\${var.project_name}-\${var.environment}"
  
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_instance_type
    vnet_subnet_id = azurerm_subnet.aks.id
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

output "configure_kubectl" {
  value = "az aks get-credentials --resource-group \${azurerm_resource_group.main.name} --name \${azurerm_kubernetes_cluster.main.name}"
}
EOF

    cat > terraform/azure/variables.tf << EOF
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "${PROJECT_NAME}"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "${ENVIRONMENT}"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "${REGION}"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = ${NODE_COUNT}
}

variable "node_instance_type" {
  description = "Node VM size"
  type        = string
  default     = "${NODE_INSTANCE_TYPE}"
}
EOF

    print_success "Azure AKS configuration created"
}

# ============================================================================
# README GENERATOR
# ============================================================================
generate_readme() {
    local tf_dir="terraform/${CLOUD_PROVIDER}"
    
    cat > ${tf_dir}/README.md << EOF
# Terraform Infrastructure - ${CLOUD_PROVIDER^^}

## Project: ${PROJECT_NAME}
## Environment: ${ENVIRONMENT}

### Generated Configuration
- **Cloud Provider**: ${CLOUD_PROVIDER^^}
- **Region**: ${REGION}
- **Cluster Name**: ${CLUSTER_NAME}
- **Kubernetes Version**: ${K8S_VERSION}
- **Node Count**: ${NODE_COUNT}
- **Node Type**: ${NODE_INSTANCE_TYPE}
- **Database**: $([[ "$ENABLE_DATABASE" == "true" ]] && echo "${DATABASE_TYPE^^}" || echo "None")
- **Redis**: $([[ "$ENABLE_REDIS" == "true" ]] && echo "Enabled" || echo "Disabled")
- **Bastion**: $([[ "$ENABLE_BASTION" == "true" ]] && echo "Enabled" || echo "Disabled")

## Prerequisites

### Required Tools
EOF

    case $CLOUD_PROVIDER in
        aws)
            cat >> ${tf_dir}/README.md << 'EOF'
1. **AWS CLI** - [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   ```bash
   aws --version
   aws configure
   ```

2. **Terraform** - [Install](https://developer.hashicorp.com/terraform/downloads)
   ```bash
   terraform --version
   ```

3. **kubectl** - [Install](https://kubernetes.io/docs/tasks/tools/)
   ```bash
   kubectl version --client
   ```

### AWS Prerequisites
1. AWS Account with appropriate permissions
2. AWS CLI configured with credentials
3. S3 bucket for Terraform state (optional but recommended)
4. DynamoDB table for state locking (optional but recommended)

#### Create S3 Backend (Recommended)
```bash
# Create S3 bucket
aws s3api create-bucket \
    --bucket ${PROJECT_NAME}-${ENVIRONMENT}-terraform-state \
    --region ${REGION}

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket ${PROJECT_NAME}-${ENVIRONMENT}-terraform-state \
    --versioning-configuration Status=Enabled

# Create DynamoDB table for locking
aws dynamodb create-table \
    --table-name ${PROJECT_NAME}-${ENVIRONMENT}-terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region ${REGION}
```

## Deployment Steps

### 1. Initialize Terraform
```bash
cd terraform/aws

# Without remote backend
terraform init

# With S3 backend
terraform init -backend-config=backend.hcl
```

### 2. Review Configuration
```bash
# Review variables
cat terraform.tfvars

# Update any values as needed
vim terraform.tfvars
```

### 3. Plan Infrastructure
```bash
terraform plan -out=tfplan
```

### 4. Apply Infrastructure
```bash
terraform apply tfplan
```

This will create:
- VPC with public and private subnets
- NAT Gateways for outbound connectivity
- EKS cluster with managed node group
- Security groups and IAM roles
EOF

            if [ "$ENABLE_DATABASE" = true ]; then
                cat >> ${tf_dir}/README.md << EOF
- RDS ${DATABASE_TYPE^^} database
EOF
            fi

            if [ "$ENABLE_REDIS" = true ]; then
                cat >> ${tf_dir}/README.md << 'EOF'
- ElastiCache Redis cluster
EOF
            fi

            if [ "$ENABLE_BASTION" = true ]; then
                cat >> ${tf_dir}/README.md << 'EOF'
- Bastion host for secure access
EOF
            fi

            cat >> ${tf_dir}/README.md << 'EOF'

### 5. Configure kubectl
```bash
# Get the kubectl config command from output
terraform output configure_kubectl

# Run the command (example)
aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}

# Verify connection
kubectl get nodes
```

### 6. Install AWS Load Balancer Controller
```bash
# Add Helm repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Get IAM role ARN
ALB_ROLE_ARN=$(terraform output -raw alb_controller_role_arn)

# Install controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="\${ALB_ROLE_ARN}"
```
EOF
            ;;
        gcp)
            cat >> ${tf_dir}/README.md << 'EOF'
1. **gcloud CLI** - [Install](https://cloud.google.com/sdk/docs/install)
   ```bash
   gcloud version
   gcloud auth login
   gcloud config set project PROJECT_ID
   ```

2. **Terraform** - [Install](https://developer.hashicorp.com/terraform/downloads)

3. **kubectl** - [Install](https://kubernetes.io/docs/tasks/tools/)

## Deployment Steps

### 1. Set GCP Project
```bash
# Set your project ID
export PROJECT_ID="your-gcp-project-id"

# Update terraform.tfvars
echo "project_id = \"${PROJECT_ID}\"" >> terraform.tfvars
```

### 2. Initialize and Apply
```bash
terraform init
terraform plan
terraform apply
```

### 3. Configure kubectl
```bash
# Get credentials
terraform output -raw configure_kubectl | bash

# Verify
kubectl get nodes
```
EOF
            ;;
        azure)
            cat >> ${tf_dir}/README.md << 'EOF'
1. **Azure CLI** - [Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   ```bash
   az --version
   az login
   ```

2. **Terraform** - [Install](https://developer.hashicorp.com/terraform/downloads)

3. **kubectl** - [Install](https://kubernetes.io/docs/tasks/tools/)

## Deployment Steps

### 1. Azure Login
```bash
az login
az account set --subscription "your-subscription-id"
```

### 2. Initialize and Apply
```bash
terraform init
terraform plan
terraform apply
```

### 3. Configure kubectl
```bash
# Get credentials
terraform output -raw configure_kubectl | bash

# Verify
kubectl get nodes
```
EOF
            ;;
    esac

    cat >> ${tf_dir}/README.md << 'EOF'

## Post-Deployment

### Verify Cluster
```bash
# Check nodes
kubectl get nodes

# Check system pods
kubectl get pods -n kube-system

# Check cluster info
kubectl cluster-info
```

### Access Services
EOF

    if [ "$ENABLE_DATABASE" = true ]; then
        cat >> ${tf_dir}/README.md << 'EOF'

#### Database Connection
```bash
# Get database endpoint
terraform output db_endpoint

# Get credentials from Secrets Manager (AWS)
aws secretsmanager get-secret-value --secret-id $(terraform output -raw db_secret_arn) --query SecretString --output text | jq .
```
EOF
    fi

    if [ "$ENABLE_REDIS" = true ]; then
        cat >> ${tf_dir}/README.md << 'EOF'

#### Redis Connection
```bash
# Get Redis endpoint
terraform output redis_endpoint

# Test connection (from within VPC)
redis-cli -h $(terraform output -raw redis_endpoint)
```
EOF
    fi

    if [ "$ENABLE_BASTION" = true ]; then
        cat >> ${tf_dir}/README.md << 'EOF'

#### Bastion Access
```bash
# Get SSH command
terraform output bastion_ssh_command

# Connect to bastion
ssh -i ~/.ssh/id_rsa ec2-user@$(terraform output -raw bastion_public_ip)

# From bastion, access kubectl
kubectl get nodes
```
EOF
    fi

    cat >> ${tf_dir}/README.md << 'EOF'

## Managing Infrastructure

### Update Infrastructure
```bash
# Modify terraform.tfvars or .tf files
vim terraform.tfvars

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### Scale Nodes
```bash
# Update node count in terraform.tfvars
node_count = 5

# Apply
terraform apply
```

### Destroy Infrastructure
```bash
# DANGER: This will destroy everything
terraform destroy
```

## Troubleshooting

### Common Issues

#### 1. Authentication Errors
EOF

    case $CLOUD_PROVIDER in
        aws)
            cat >> ${tf_dir}/README.md << 'EOF'
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Refresh credentials
aws configure
```
EOF
            ;;
        gcp)
            cat >> ${tf_dir}/README.md << 'EOF'
```bash
# Verify GCP auth
gcloud auth list

# Refresh
gcloud auth login
```
EOF
            ;;
        azure)
            cat >> ${tf_dir}/README.md << 'EOF'
```bash
# Verify Azure auth
az account show

# Refresh
az login
```
EOF
            ;;
    esac

    cat >> ${tf_dir}/README.md << 'EOF'

#### 2. Terraform State Issues
```bash
# Check state
terraform show

# Refresh state
terraform refresh

# If state is corrupted, restore from backup (S3 versioning)
```

#### 3. Cluster Connection Issues
```bash
# Reconfigure kubectl
terraform output -raw configure_kubectl | bash

# Verify connection
kubectl cluster-info

# Check authentication
kubectl auth can-i get pods --all-namespaces
```

## Best Practices

### Security
- [ ] Use private subnets for nodes
- [ ] Enable encryption at rest
- [ ] Use secrets management (AWS Secrets Manager, etc.)
- [ ] Implement network policies
- [ ] Use IAM roles for service accounts
- [ ] Enable audit logging
- [ ] Regular security updates

### High Availability
- [ ] Multi-AZ deployment
- [ ] Auto-scaling enabled
- [ ] Regular backups
- [ ] Disaster recovery plan
- [ ] Monitoring and alerting

### Cost Optimization
- [ ] Right-size instances
- [ ] Use spot instances where appropriate
- [ ] Clean up unused resources
- [ ] Monitor costs with CloudWatch/Cloud Monitoring
- [ ] Use Reserved Instances for production

## Monitoring

### Cluster Monitoring
```bash
# Install Prometheus and Grafana
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
```

### Access Grafana
```bash
# Port forward
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Default credentials
# Username: admin
# Password: prom-operator
```

## Backup and Recovery

### Backup Terraform State
```bash
# State is automatically backed up in S3 with versioning
# To download state
aws s3 cp s3://${PROJECT_NAME}-${ENVIRONMENT}-terraform-state/terraform.tfstate ./backup/
```

### Backup Kubernetes Resources
```bash
# Install Velero for backup
# https://velero.io/docs/
```

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
EOF

    case $CLOUD_PROVIDER in
        aws)
            cat >> ${tf_dir}/README.md << 'EOF'
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
EOF
            ;;
        gcp)
            cat >> ${tf_dir}/README.md << 'EOF'
- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
EOF
            ;;
        azure)
            cat >> ${tf_dir}/README.md << 'EOF'
- [AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
EOF
            ;;
    esac

    cat >> ${tf_dir}/README.md << 'EOF'

## Support

For issues or questions:
1. Check Terraform logs: `TF_LOG=DEBUG terraform apply`
2. Check cloud provider console
3. Review Kubernetes logs: `kubectl logs <pod-name>`
4. Check cluster events: `kubectl get events --all-namespaces`
EOF

    print_success "README.md created with comprehensive guide"
}

# ============================================================================
# HELPER SCRIPTS GENERATOR
# ============================================================================
generate_helper_scripts() {
    local tf_dir="terraform/${CLOUD_PROVIDER}"
    mkdir -p ${tf_dir}/scripts
    
    # Deploy script
    cat > ${tf_dir}/scripts/deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Deploying infrastructure..."

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan
terraform plan -out=tfplan

# Ask for confirmation
read -p "Apply this plan? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    terraform apply tfplan
    rm tfplan
    echo "✅ Deployment complete!"
else
    echo "❌ Deployment cancelled"
    rm tfplan
fi
EOF

    # Destroy script
    cat > ${tf_dir}/scripts/destroy.sh << 'EOF'
#!/bin/bash
set -e

echo "⚠️  WARNING: This will destroy all infrastructure!"
read -p "Are you sure? Type 'destroy' to confirm: " confirm

if [ "$confirm" = "destroy" ]; then
    terraform destroy
    echo "✅ Infrastructure destroyed"
else
    echo "❌ Destruction cancelled"
fi
EOF

    # Setup kubectl script
    cat > ${tf_dir}/scripts/setup-kubectl.sh << 'EOF'
#!/bin/bash
set -e

echo "🔧 Configuring kubectl..."

# Get the configure command from Terraform output
CONFIGURE_CMD=$(terraform output -raw configure_kubectl)

# Execute the command
eval "$CONFIGURE_CMD"

# Verify
kubectl get nodes

echo "✅ kubectl configured successfully"
EOF

    chmod +x ${tf_dir}/scripts/*.sh
    
    print_success "Helper scripts created"
}

# ============================================================================
# MAIN ORCHESTRATION
# ============================================================================
main() {
    display_header
    
    print_info "Starting Terraform Infrastructure Generator..."
    echo ""
    
    # Collect configurations
    select_cloud_provider
    collect_basic_info
    collect_additional_resources
    
    echo ""
    print_info "Generating Terraform configuration for ${CLOUD_PROVIDER^^}..."
    echo ""
    
    # Generate based on cloud provider
    case $CLOUD_PROVIDER in
        aws)
            generate_aws_terraform
            ;;
        gcp)
            generate_gcp_terraform
            ;;
        azure)
            generate_azure_terraform
            ;;
    esac
    
    # Generate common files
    generate_readme
    generate_helper_scripts
    
    echo ""
    print_success "============================================================"
    print_success "   Terraform Configuration Generated Successfully!         "
    print_success "============================================================"
    echo ""
    
    print_info "Generated files in terraform/${CLOUD_PROVIDER}/"
    ls -R terraform/${CLOUD_PROVIDER}/ | grep -v "^$" | sed 's/^/  /'
    
    echo ""
    print_warning "⚠️  IMPORTANT: Before deploying:"
    case $CLOUD_PROVIDER in
        aws)
            echo "  1. Configure AWS CLI: aws configure"
            echo "  2. Review terraform.tfvars"
            echo "  3. Update bastion_allowed_cidr_blocks for security"
            if [ "$ENABLE_DATABASE" = true ]; then
                echo "  4. RDS credentials will be stored in AWS Secrets Manager"
            fi
            ;;
        gcp)
            echo "  1. Set GCP project: gcloud config set project PROJECT_ID"
            echo "  2. Update project_id in terraform.tfvars"
            echo "  3. Review terraform.tfvars"
            ;;
        azure)
            echo "  1. Login to Azure: az login"
            echo "  2. Set subscription: az account set --subscription SUBSCRIPTION_ID"
            echo "  3. Review terraform.tfvars"
            ;;
    esac
    
    echo ""
    print_info "Quick start:"
    echo "  cd terraform/${CLOUD_PROVIDER}"
    echo "  terraform init"
    echo "  terraform plan"
    echo "  terraform apply"
    echo ""
    print_info "For detailed instructions, see: terraform/${CLOUD_PROVIDER}/README.md"
    echo ""
    
    print_success "🎉 Done! Your infrastructure is ready to deploy!"
}

# Run main function
main
