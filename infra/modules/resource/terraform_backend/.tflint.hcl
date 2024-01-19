plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# ==============================================================
# Resource modules don't need to worry about unused declarations
# ==============================================================

rule "terraform_unused_declarations" {
  enabled = false
}
