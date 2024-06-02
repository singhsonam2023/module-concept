resource "azurerm_resource_group" "resourcegroup" {
    for_each = var.resourcegrp
   name   =  each.value.rgname
   location = each.value.location

}