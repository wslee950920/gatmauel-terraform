resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "Default subnet for ap-northeast-2a"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "Default subnet for ap-northeast-2b"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Default subnet for ap-northeast-2c"
  }
}