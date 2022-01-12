output "package_path" {
  value = var.package_name
}

output "package_hash" {
  value = data.archive_file.package.output_base64sha256
}
