variable "src_dir" {
  description = "The directory where the source files are located"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^.*[^/]$", var.src_dir) == var.src_dir)
    error_message = "The src_dir must not end with a slash."
  }
}

variable "requirements_path" {
  description = "Path to requirements.txt file, defaults to src_dir/requirements.txt"
  type        = string
  default     = null
  validation {
    # I could really use an XOR operator here if HCL has one
    condition     = var.requirements_path != null ? fileexists(var.requirements_path) : true
    error_message = "The requirements file does not exist."
  }
}

variable "package_name" {
  default = "pkg.zip"
}
