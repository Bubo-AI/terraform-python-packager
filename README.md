# terraform-python-packager

Terraform module to create an archive for a python package with its dependencies.
A possible use case is to deploy a lambda function to AWS with custom dependencies.

## Example usage

```hcl
module python_packager {
  source  = "github.com/Bubo-AI/terraform-python-packager?ref=v0.1.0"
  src_dir = "/path/to/python/package"
}
```

Fully working example for deploying a custom python module to AWS Lambda function can be found inside the [`example`](example) folder.

## Inputs

| Variable             | Description                                                          | Type   | Default                    |
|----------------------|----------------------------------------------------------------------|--------|----------------------------|
| src_dir              | Path to python package directory without trailing `/`.               | string | _N/A_                      |
| _requirements_path_* | Path to `requirements.txt`. Required if src_dir does not contain it. | string | `src_dir/requirements.txt` |
| _package_name_*      | Path to output archive file.                                         | string | `pkg.zip`                  |

> \* optional variable

## Outputs

| Name         | Description                                             |
|--------------|---------------------------------------------------------|
| package_path | The path of zip archive.                                |
| package_hash | The base64-encoded SHA256 checksum of the archive file. |

## Requirements

This module was tested against Terraform v1.1.3. It does not use any Terraform providers, and does not declare any Terraform resources. It is compatible with *nix systems.

## Limitations

This module assumes archived package will run on 64-bit linux environment and required python version is 3.9.

If you have different requirements, please adjust the parameters of pip from the last `local-exec` provider inside the `main.tf`.

## Note regarding symbolic links

Due to a bug, this module does not currently create proper zip archives when the source includes symbolic links (also known as "symlinks"). Please see [Terraform Archive Issue #6](https://github.com/hashicorp/terraform-provider-archive/issues/6) for more details and workaround options.