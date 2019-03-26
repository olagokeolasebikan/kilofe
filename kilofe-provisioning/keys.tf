resource "aws_key_pair" "default" {
  key_name   = "${var.org}"
  public_key = "${file("./.private/kilofeci.pub")}"
}
