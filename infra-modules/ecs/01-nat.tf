
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this[0].id
  subnet_id     = var.public_subnets_ids[0]

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [var.internet_gw_id]
}