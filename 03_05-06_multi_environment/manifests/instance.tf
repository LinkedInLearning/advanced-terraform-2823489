# //////////////////////////////
# EC2 MODULE
# //////////////////////////////
module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "frontend-linux"
  instance_count         = var.env_instance_count

  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.env_instance_type

  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  subnet_id              = module.vpc.public_subnets[1]

  tags = var.env_instance_tags
}