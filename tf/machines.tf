variable "ssh_keys" {
  description = "List of SSH keys to allow on the machines"
  type        = list(string)
}

data "digitalocean_project" "kindelia_project" {
  name = "Kindelia"
}

resource "digitalocean_project_resources" "kindelia" {
  project = data.digitalocean_project.kindelia_project.id
  resources = [
    digitalocean_droplet.testnet_1.urn
  ]
}

# Create a web server
resource "digitalocean_droplet" "testnet_1" {
  image  = "ubuntu-22-04-x64"
  name   = "testnet-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb-amd"

  ssh_keys = var.ssh_keys

  provisioner "remote-exec" {
    inline = ["sudo apt update", "echo Done!"] # "sudo apt install python3 -y",

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      # private_key = file(var.pvt_key)
    }
  }

  provisioner "local-exec" {
    command = <<-OET
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook \
        -u root -i '${self.ipv4_address},' \
        ../playbooks/setup-rust.yml \
      OET
  }
}
