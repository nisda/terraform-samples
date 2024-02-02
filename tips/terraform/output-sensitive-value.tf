
locals {
  pseudo_sensitive_value = "abcdefghijklmn"
}

# 隠す
output "sensitive_value_hidden" {
 value = local.pseudo_sensitive_value
 sensitive = true
}

# 強制的に表示する
output "sensitive_value_open" {
 value = nonsensitive(local.pseudo_sensitive_value)
}

