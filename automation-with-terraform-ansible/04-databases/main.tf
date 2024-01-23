module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.name}-mondodb"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
        Name = "${local.name}-mongodb"
        Component = "mongodb"
    }
  )
}

resource "null_resource" "mongodb" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mongodb.id
  }

  # Bootstrap script will be run on the MongoDB instance
  connection {
    host = module.mongodb.private_ip
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
  source      = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the inventory
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb dev"
    ]
  }
}

module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.name}-redis"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
        Name = "${local.name}-redis"
        Component = "redis"
    }
  )
}

resource "null_resource" "redis" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.redis.id
  }

  # Bootstrap script will be run on the REDIS instance
  connection {
    host = module.redis.private_ip
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
  source      = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the inventory
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis dev"
    ]
  }
}

module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.name}-mysql"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_ids
  iam_instance_profile = "db-ansible-tf"

  tags = merge(
    var.common_tags,
    {
        Name = "${local.name}-mysql"
        Component = "mysql"
    }
  )
}

resource "null_resource" "mysql" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.mysql.id
  }

  # Bootstrap script will be run on the MYSQL instance
  connection {
    host = module.mysql.private_ip
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
  source      = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the inventory
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}

module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.name}-rabbitmq"
  ami = data.aws_ami.centos8.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_ids
  iam_instance_profile = "db-ansible-tf"

  tags = merge(
    var.common_tags,
    {
        Name = "${local.name}-rabbitmq"
        Component = "rabbitmq"
    }
  )
}

resource "null_resource" "rabbitmq" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.rabbitmq.id
  }

  # Bootstrap script will be run on the MongoDB instance
  connection {
    host = module.rabbitmq.private_ip
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
  source      = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the inventory
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq dev"
    ]
  }
}
