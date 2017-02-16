provider "aws" {
  region                   = "us-east-1"
  shared_credentials_file  = "/root/.aws/credentials"
  profile                  = "default"
}

resource "aws_vpc" "Demoterraform" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "Demoterraform"
    }
}

resource "aws_subnet" "PrivateSubnet1a" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.1.0/24"

    tags {
        Name = "PrivateSubnet1"
    }
}

resource "aws_subnet" "PrivateSubnet1b" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.2.0/24"

    tags {
        Name = "PrivateSubnet1b"
    }
}

resource "aws_subnet" "PublicSubnet1a" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.3.0/24"

    tags {
        Name = "PublicSubnet1a"
    }
}
resource "aws_subnet" "PublicSubnet1b" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.4.0/24"

    tags {
        Name = "PublicSubnet1b"
    }
}
