

provider "http" {
}


data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com/"
}
output "my_public_ip" {
  value = trimspace(data.http.my_public_ip.response_body)
}

