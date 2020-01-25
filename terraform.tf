provider "digitalocean" {
  #token = var.token-->pedira valor en input prompt
  token = "${var.token}"
}

resource "digitalocean_droplet" "centos" {
  image = "centos-7-x64"
  name = "web-122"
  region = "nyc3"
  size = "s-1vcpu-1gb"
  ssh_keys =["${digitalocean_ssh_key.centos.fingerprint}"]
  # Para configurar usando cloud-init (esto omitiria usar el connection y los provisioners files y remote exec de este recurso)
  user_data = "${file("user_data.yml")}"
  # Para ejecutar scripts en la maquina remota
  connection {
      user = "root"
      type = "ssh"
      host = "${digitalocean_droplet.centos.ipv4_address}"
      private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "remote-exec" {
      inline = [
          "yum update -y",
          "yum install -y vi yum-utils device-mapper-persistent-data lvm2",
          "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
          "yum install docker-ce docker-ce-cli containerd.io -y",
          "systemctl start docker",
          "systemctl enable docker",
          "systemctl daemon-reload"

      ]
  }
# Provisioners para traspaso de archivos
 provisioner "file" {
    content = "La pata salta"
    destination = "/tmp/historia.txt"
 }  
 provisioner "file" {
    source = "data.txt"
    destination = "/tmp/data.txt"
 }
}