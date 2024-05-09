// ***GCP VPC Build***
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#example-usage---basic-provider-blocks
provider "google" {
  // GCP credentials added as Windows environment variable in VScode settings.json file
  project = "class-adv2024-vueibaezis10"
  region  = "us-east1"
}

resource "google_compute_network" "i2_project_gcp_terraform_vpc" {
  name                    = "i2-project-gcp-terraform-vpc"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "i2_project_gcp_terraform_subnet_1" {
  name          = "i2-project-gcp-terraform-subnet-1"
  ip_cidr_range = "10.2.0.0/24"
  network       = google_compute_network.i2_project_gcp_terraform_vpc.name
}

// ***AWS VPC Build***
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/connect_instance
provider "aws" {
  // AWS credentials added as Windows environment variable in VScode settings.json file
  region = "us-east-1"
}

resource "aws_vpc" "i2_project_aws_terraform_vpc" {
  cidr_block = "10.3.0.0/16"  
  tags = {
    Name = "i2_project_aws_terraform_vpc"
  }
}

// Create AWS subnet based primary VPC cidr block
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "i2_project_aws_terraform_subnet_1" {
  vpc_id            = aws_vpc.i2_project_aws_terraform_vpc.id
  cidr_block        = "10.3.1.0/24" 
  availability_zone = "us-east-1a"
  tags = {
    Name = "i2_project_aws_terraform_subnet_1"
  }
}

// ***AWS Security Group***
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_ssh_icmp_from_gcp" {
  name        = "allow_ssh_icmp_from_gcp"
  description = "Security group allowing SSH and ICMP from GCP"
  vpc_id      = aws_vpc.i2_project_aws_terraform_vpc.id
  
  // ***AWS SSH and ICMP inbound rule exceptions from GCP***
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/24"] // Allow ssh traffic from GCP CIDR
  }
  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.2.0.0/24"] // Allow icmp traffic from GCP CIDR
  }
  
  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// ***GCP SSH and ICMP inbound rule exceptions from AWS***
// https://registry.terraform.io/providers/hashicorp/google/3.0.0-beta.1/docs/resources/compute_firewall
resource "google_compute_firewall" "allow_ssh_icmp_from_aws" {
  name    = "allow-ssh-icmp-from-aws"
  network = google_compute_network.i2_project_gcp_terraform_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.3.0.0/16"] // Allow ssh and icmp traffic from AWS CIDR
}

