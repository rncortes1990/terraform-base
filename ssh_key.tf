resource "digitalocean_ssh_key" "centos" {
  name = "centos"
  public_key = "${file("id_rsa.pub")}"
}