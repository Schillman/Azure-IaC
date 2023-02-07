locals {
  role_assignments = flatten([
    for kv_name, roles in var.key_vaults : flatten([
      for role, pids in roles : [
        for id in pids : {
          "p_id"      = id
          "role_name" = role
          "kv_name"   = kv_name
        }
    ]])]
  )

  secrets = flatten([
    for kv_name, kv_secrets in var.key_vaults_secrets : [
      for name, value in kv_secrets : {
        "kv_name" = kv_name
        "name"    = name
        "value"   = value
      }
    ]
  ])
}


