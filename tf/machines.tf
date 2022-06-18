variable "ssh_keys" {
  description = "List of SSH keys to allow on the machines"
  type        = list(string)
}

variable "regions" {
  default = [
    // "nyc3", // New York
    "sfo3", // San Francisco
    "ams3", // Amsterdan
    "sgp1", // Singapore
    # "blr1", // Bangalore (India)
  ]
}

data "digitalocean_project" "kindelia_project" {
  name = "Kindelia"
}

resource "digitalocean_project_resources" "kindelia" {
  project = data.digitalocean_project.kindelia_project.id
  resources = [
    for m in digitalocean_droplet.testnet : m.urn
  ]
}

# Create a web server
resource "digitalocean_droplet" "testnet" {
  count  = length(var.regions)
  name   = "testnet-${count.index}"

  image  = "ubuntu-22-04-x64"
  region = "${var.regions[count.index]}"

  # size = "s-1vcpu-1gb-amd"
  size = "s-2vcpu-4gb-amd"

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
        -i '../inventory/config/datadog.ini' \
        ../playbooks/setup-journald.yml \
        ../playbooks/setup-datadog.yml \
        ../playbooks/setup-rust.yml \
      OET
  }
}

output "testnet_ips" {
  value = digitalocean_droplet.testnet[*].ipv4_address
}
