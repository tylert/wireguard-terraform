plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# ==============================================================
# Infrastructure modules don't need required version definitions
# ==============================================================

rule "terraform_required_version" {
  enabled = false
}

# ===============================================================
# Infrastructure modules don't need required provider definitions
# ===============================================================

rule "terraform_required_providers" {
  enabled = false
}
