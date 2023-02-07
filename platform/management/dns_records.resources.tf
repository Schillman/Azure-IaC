resource "azurerm_resource_group" "dns_zone" {
  name     = "rg-azure-dns"
  location = "Sweden Central"
}

resource "azurerm_dns_zone" "schillman" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.dns_zone.name
}

resource "azurerm_dns_a_record" "www" {
  name                = "*"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600

  records = ["140.82.121.4"]
}

resource "azurerm_dns_txt_record" "spf" {
  name                = "@"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600

  record {
    value = "v=spf1 include:spf.protection.outlook.com -all"
  }
}

resource "azurerm_dns_txt_record" "_dmarc" {
  name                = "_dmarc"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600

  record {
    value = "v=DMARC1; p=quarantine; pct=100"
  }
}

resource "azurerm_dns_mx_record" "mx" {
  name                = "@"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600

  record {
    preference = 1
    exchange   = var.mx_record
  }
}

resource "azurerm_dns_cname_record" "autodiscover" {
  name                = "autodiscover"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600
  record              = "autodiscover.outlook.com."
}

resource "azurerm_dns_cname_record" "enterpriseenrollment" {
  name                = "enterpriseenrollment"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600
  record              = "enterpriseenrollment.manage.microsoft.com"
}

resource "azurerm_dns_cname_record" "enterpriseregistration" {
  name                = "enterpriseregistration"
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600
  record              = "enterpriseregistration.windows.net."
}

resource "azurerm_dns_cname_record" "dkim_selector" {
  for_each            = var.dns_cname_record
  name                = each.key
  zone_name           = azurerm_dns_zone.schillman.name
  resource_group_name = azurerm_resource_group.dns_zone.name
  ttl                 = 3600
  record              = each.value.record
}
