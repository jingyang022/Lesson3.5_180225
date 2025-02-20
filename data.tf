data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["yap-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public-*"]
  }
}