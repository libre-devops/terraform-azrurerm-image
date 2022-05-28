resource "azurerm_image" "azure_image" {
  for_each            = var.images
  name                = each.key
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  hyper_v_generation        = upper(try(each.value.image_hyper_v_generation, null))
  zone_resilient            = try(each.value.zone_resilient, null)
  source_virtual_machine_id = try(each.value.source_virtual_machine_id, null)

  dynamic "os_disk" {
    for_each = lookup(var.images[each.key], "os_disk", {}) != {} ? [1] : []
    content {
      os_type         = lookup(var.images[each.key].os_disk, "os_type", title(each.value.image_os_type))
      os_state        = lookup(var.images[each.key].os_disk, "os_state", "Generalized")
      caching         = lookup(var.images[each.key].os_disk, "caching", null)
      managed_disk_id = lookup(var.images[each.key].os_disk, "managed_disk_id", null)
      size_gb         = lookup(var.images[each.key].os_disk, "size_gb", null)
      blob_uri        = lookup(var.images[each.key].os_disk, "blob_uri", null)
    }
  }

  dynamic "data_disk" {
    for_each = lookup(var.images[each.key], "data_disk", {}) != {} ? [1] : []
    content {
      lun             = lookup(var.images[each.key].data_disk, "lun", null)
      caching         = lookup(var.images[each.key].data_disk, "caching", null)
      managed_disk_id = lookup(var.images[each.key].data_disk, "managed_disk_id", null)
      size_gb         = lookup(var.images[each.key].data_disk, "size_gb", null)
      blob_uri        = lookup(var.images[each.key].data_disk, "blob_uri", null)
    }
  }
}
