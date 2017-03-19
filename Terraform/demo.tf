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

resource "aws_subnet" "PrivateSubnetA" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.1.0/24"

    tags {
        Name = "PrivateSubnet1a"
    }
}

resource "aws_subnet" "PrivateSubnetB" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.2.0/24"

    tags {
        Name = "PrivateSubnet1b"
    }
}

resource "aws_subnet" "PublicSubnetA" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.3.0/24"

    tags {
        Name = "PublicSubnet1a"
    }
}
resource "aws_subnet" "PublicSubnetB" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    cidr_block = "10.0.4.0/24"

    tags {
        Name = "PublicSubnet1b"
    }
}

resource "aws_internet_gateway" "DemoInternetGateway" {
    vpc_id = "${aws_vpc.Demoterraform.id}"

    tags {
        Name = "DemoInternetGateway"
    }
}

resource "aws_route_table" "PublicRouteA" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "${aws_internet_gateway.DemoInternetGateway.id}"
    }

    tags {
        Name = "Public"
    }
}
resource "aws_route_table" "PublicRouteB" {
    vpc_id = "${aws_vpc.Demoterraform.id}"
    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "${aws_internet_gateway.DemoInternetGateway.id}"
    }

    tags {
        Name = "Private"
    }
}
