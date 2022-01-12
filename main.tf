locals {
  # if requirements.txt path is not specified, assume it's located under the source folder
  requirements_path = var.requirements_path != null ? var.requirements_path : "${var.src_dir}/requirements.txt"
  # calculate file hashes of source directory and requirements.txt to use as a trigger
  dependencies_hash = filesha1(local.requirements_path)
  # calculate concatenated hash of every file in the source directory, then calculate
  # hash of that concatenated string. ref: https://stackoverflow.com/a/66501021/1360267
  source_hash = sha1(join("", [for f in fileset(var.src_dir, "**") : filesha1("${var.src_dir}/${f}")]))
  # concatenate depdenencies_hash and source_hash then hash to use as a trigger
  content_hash      = sha1("${local.dependencies_hash}-${local.source_hash}")
  temp_package_path = "/tmp/${basename(var.src_dir)}-${local.content_hash}"
}

# random_id resource will be used to keep track of changes to trigger
# package and archive_zip steps
resource "random_id" "hash" {
  keepers = {
    # Generate a new id each time source or dependencies has changed
    content_hash = local.content_hash
  }

  byte_length = 8
}

# Prepare given source folder and dependencies to be packaged
resource "null_resource" "package" {
  # trigers only if script or dependencies were changed
  triggers = {
    content_hash = random_id.hash.id
  }


  # Ensure an empty folder exists on the target path, then copy the contents of the
  # source folder and requirements.txt to the target path. requirements.txt file
  # is not required but can be useful to identify any unexpected behaviour in the
  # deployment
  provisioner "local-exec" {
    command = <<EOT
    rm -rf ${local.temp_package_path} && \
    mkdir -p ${local.temp_package_path} && \
    cp -rf ${local.requirements_path} ${local.temp_package_path} && \
    cp -rf ${var.src_dir}/* ${local.temp_package_path}
    EOT
  }


  # Install dependencies without source (binary-only) from the given requirement file to
  # the target folder. The following command will assume the package will be deployed
  # to 64 bit linux platforms running Python 3.9. If you are deploying to a different
  # platform, you need to change the platform option to match your platform. For a
  # different python version, you need to change the python-version option.
  provisioner "local-exec" {
    command = <<EOT
    python -m pip install \
    --disable-pip-version-check --isolated --no-python-version-warning -q \
    --only-binary :all: \
    --python-version 39 \
    --platform=manylinux1_x86_64  \
    --target ${local.temp_package_path} \
    -r ${local.requirements_path}
    EOT
  }
}


# Archive package folder as zip
data "archive_file" "package" {
  depends_on  = [null_resource.package, random_id.hash]
  type        = "zip"
  source_dir  = local.temp_package_path
  output_path = var.package_name
}
