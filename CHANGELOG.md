# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2024-01-31

- Removed the trigger introduced in version 0.1.2 to avoid an issue where an empty zip file was created. This caused failures in plan and apply commands when the state stored the unchanged source hash and the /tmp directory was removed after a system reboot. To ensure the package is always available, we now rebuild it every time, compromising on build time.

## [0.1.2] - 2023-12-12

- Add trigger to python packaging resource to ensure that the package is rebuilt when the source code changes and fix the initial build.

## [0.1.1] - 2022-05-17

- Disable archive file caching to support idempotency - fix for CI/CD pipelines.