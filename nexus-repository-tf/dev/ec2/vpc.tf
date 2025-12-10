data "aws_vpc" "nexus-repository-vpc" {
    filter {
        name = "tag:Name"
        values = ["nexus-repository-vpc"]
    }
    filter {
        name = "cidr"
        values = ["10.0.0.0/16"]
    }
}

data "aws_subnet" "nexus-repository-public-subnet" {
    filter {
        name = "tag:Name"
        values = ["nexus-repository-public-subnet"]
    }
    filter {
        name = "cidr-block"
        values = ["10.0.0.0/24"]
    }
}