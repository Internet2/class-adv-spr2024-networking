// ***GCP VPC Build***
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
provider "aws" {
  // AWS credentials added as Windows environment variable in VScode settings.json file
  region = "us-east-1"
}

resource "aws_vpc" "i2_project_aws_terraform_vpc" {
  cidr_block = "172.16.0.0/16"  
  tags = {
    Name = "i2_project_aws_terraform_vpc"
  }
}

resource "aws_subnet" "i2_project_aws_terraform_subnet_1" {
  vpc_id            = aws_vpc.i2_project_aws_terraform_vpc.id
  cidr_block        = "172.16.1.0/24" 
  availability_zone = "us-east-1a"
  tags = {
    Name = "i2_project_aws_terraform_subnet_1"
  }
}
