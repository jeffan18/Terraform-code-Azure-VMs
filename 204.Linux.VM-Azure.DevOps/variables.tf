/*1- Azure Credentials for Terraform */
/* Not required for DevOps */

/* 2- Project, environment, location */
variable "project" {
 default = "projectvmdevops"
}

variable "environment" {
 default = "POC"
}

variable "location" {
 default = "East US"
}

variable "prefix" {
 default = "fan"
}

variable "tag" {
 description = "Specify the environment as tags"
 default = "POC"
}

/* 3- Main Resources Name Definition */
locals {
vm1_name = "VM-Linux-${var.prefix}-${var.project}-${substr(var.environment, 0, 3)}-01"
}

/* 4- Resources to Deploy*/
variable "resource_group_name" {
 default = "RG-Fan-projectvm-DevOps"
}

variable "virtual_network_name" {
 default = "VNet-Fan-projectvm"
}

variable "virtual_network_address_prefix" {
 description = "VNET IP address range."
 default     = "10.0.0.0/8"
}

variable "subnet_vmpool" {
 default     = "Subnet-VM-pool"
}

