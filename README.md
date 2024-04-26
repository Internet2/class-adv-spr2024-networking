---
author: Scott Taylor
date: 2024-04-25
---
# [Internet2 CLASS Advanced Spring 2024 - Networking/IaC Project](https://github.com/Internet2/class-adv-spr2024-proj1)

## Overview

This repository supports the CLASS Advanced Spring 2024 - Networking/IaC Project.

This README.md is intended to help provide a starting point for the project. Should your cohort choose this project, you should consider this a proposal and take liberty to modify this project. Ultimately the goal of project week is to present a real-world challenge while reinforcing knowledge through a practical application of learned skills. Feel free to change the scope of this project to something that is achievable by the cohort and can show some working code or proof of concept within the time of the project week (5 days).

### Background

Internet2 is a cloud interconnect partner with the major Cloud Service Providers (CSPs). Supporting hybrid cloud connectivity for our member community through it's [Internet2's Cloud Connect (I2CC)](https://internet2.edu/services/cloud-connect/) service which provides "hosted" connections with speeds from 50 Mbps to 10+ Gbps. As part of the circuit qualification process Internet2 manually builds some connectivity over new interconnects prior to putting them into production for member use. The testing includes, but is not limited to, creating virtual circuits from [Internet2's Insight Console (I2IC)](https://console.internet2.edu/) using the Virtual Networks service into the CSP infrastructure and verifying that connectivity works.

### Objective

The primary objectives of this repository are as follows:

> - Quickly and repeatably build out a qualification/test environment for qualifying new hosted interconnects with each CSP.
> - Infrastructure as Code (IaC): Learn and use Terraform to quickly provision a barebones non-resiliant cloud environment that incurs minimal expense during qualification testing.
> - Serve as a non-redundant test environment for qualifying new Hosted Dedicated Cloud connections, with the major Cloud Service Providers (CSPs), prior to placing them into production.
> - Serve as a multi-cloud, hands-on, lab environment for training at workshops and tutorials for Network Engineers and Cloud Architects from Internet2 member organizations.

By particiating in this project as proposed you are helping the Internet2 team reach it's goal of getting closer to automating the testing and qualification of new hosted internetconnect circuits.

It is envisioned that the code in this repo primarily uses Terraform (TF) to build minimally viable cloud networking components necessary to provision a test VM/instance for qualification purposes. It assumes hosted connectivity built through [Internet2's Cloud Connect (I2CC)](https://internet2.edu/services/cloud-connect/) service with circuits built across, and possibly between CSP's, using [Internet2's Insight Console (I2IC)](https://console.internet2.edu/). Leverage the Insight Console to build and provision a Virtual Router and peerings toward each CSP. For now this is a manual process that is fairly quick and easy.

## Requirements

> *Documented below are the necessary requirements to run the code*

- An account with each CSP that you wish to provision a cloud environment.
- Working knowledge of CSP networking for each provider that you wish to include.
- Your account has sufficient permissions to create/delete network resources in each CSP you wish to deploy the testing environment.
- Familiarity working with Terraform and [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed on your local machine.
- Familiarity with CLI's for [AWS](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [Azure](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli), [Google Cloud](https://cloud.google.com/sdk/docs/install) and [Oracle Cloud](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#Quickstart).
- Access to [Internet2 Insight Console](https://console.internet2.edu)

## Questions to be answered along the way

> *What else goes here?*

- Where should we store Terraform State Files
- How should we deal with secrets

## Directions for each CSP

1. Provision a test VPC/VNET/VCN
2. Provision a private subnet in the VPC/VNET/VCN
3. Provision a test VM/instance using DHCP from the private IPv4 subnet
    a. Output the IP address of the test instance
4. Configure the security group/firewall/security list to allow ICMP and SSH to the test VM/instance
    a. Output the SSH key
5. Configure the RT/UDR/Routes for the private subnet
6. Configure a Gateway/Cloud Router
7. Create the necessary attachments between resources to allow end-to-end connectivity

> [!NOTE]
> While best practices for reliability or resiliancy dictate multiple AZ's, regions, etc, that isn't required for the qualification environment. The qualification environment is focused on cost optimization and qualifying connectivity without any sensitive data.

The follow are not required for the qualification environment:

- Redundancy of instances/vms
- Resilancy through multiple regions or zones
- Encryption
- Public subnets, Internet gateways, etc are not used in this qualification environment

## Cost

The goal is cost optimization, it is recommended to use the smallest size virtual circuit possible.

> [!CAUTION]  
> Don't forget to `terraform destroy` to avoid paying more than you need!

### AWS

Builds a single direct connect circuit of 50Mbps to an AWS region and spins up a private subnet with a single test server for validating connectivity.

> [!NOTE]
> For AWS the cost for an hour of testing should be approximately $0.05 if minimal egress data transfer is accrued.

This provisions:

- A VPC named `test_env` using IPv4 subnet of 10.100.0.0/16
- Private subnet named `priv-subnet-test_env` using IPv4 subnet of 10.100.1.0/24
- Test Instance named `test_server` using DHCP for an IPv4 private address in 10.100.1.0/24
- Security Group named `sg_test_env`that allow ICMP+SSH to test_server
- Route Table for the private subnet named `priv-rt_test_env`

- VPG = for attachment to Direct Connect Gateway
- Direct Connect Gateway with ASN #####
- Direct Connect private virtual interface
- Direct Connect Connection with 50Mbps

> *Maybe replace this with a nice diagram*
Connectivity: I2CC <-> Hosted DX <-> DXG attachment <-> VPG <-> VPC <-> Test Instance

### Azure

*place holder*

### Google Cloud

*place holder*

### Oracle Cloud

*place holder*

---

## How to use this code for a qualification test

1. Clone/fork repo to your local machine.
2. do some other stuff
3. do more stuff
4. set your credentials for each CSP
5. uncomment the cloud(s) you wish to provision test environments for in ==_some\_file.tf_==
6. `Terraform init`
7. `Terraform apply`

## How to de-provision the qualification environment(s)

From the directory that you did your terraform apply you will now run

1. `terraform destroy`

---

## Possible Future improvements

- Leverage the Insight Console API to build and provision the Virtual Router and peerings toward a CSP. (For now this is a manual process that is fairly quick and easy)
- Deploy iPerf or PerfSonar node instance for throughput testing
- Include IPv6 configuration
- Fork this code base to quickly provision environments for demos, tutorials, and workshops.