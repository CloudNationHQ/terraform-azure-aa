# Changelog

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v3.0.0...v3.1.0) (2025-11-12)


### Features

* **deps:** bump github.com/ulikunitz/xz from 0.5.10 to 0.5.14 in /tests ([#55](https://github.com/CloudNationHQ/terraform-azure-aa/issues/55)) ([d48e3bc](https://github.com/CloudNationHQ/terraform-azure-aa/commit/d48e3bcedeea4dcb8533f14a07773cbf1d7b4eac))
* remove redundant null values and version increment examples ([#60](https://github.com/CloudNationHQ/terraform-azure-aa/issues/60)) ([c0a073d](https://github.com/CloudNationHQ/terraform-azure-aa/commit/c0a073dae3d2085eadf8095eaa7f74edb764749f))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.7.0...v3.0.0) (2025-08-26)


### ⚠ BREAKING CHANGES

* this change causes recreates

### Features

* small refactor and changed data structure ([#53](https://github.com/CloudNationHQ/terraform-azure-aa/issues/53)) ([86b46f9](https://github.com/CloudNationHQ/terraform-azure-aa/commit/86b46f9a05a804721b41930b1dcb1c73dbcd314f))

### Upgrade from v2.7.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- The property and variable resource_group is renamed to resource_group_name

## [2.7.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.6.0...v2.7.0) (2025-05-08)


### Features

* add missing functionality ([#45](https://github.com/CloudNationHQ/terraform-azure-aa/issues/45)) ([53000f3](https://github.com/CloudNationHQ/terraform-azure-aa/commit/53000f33e0dce4bce76c8cb4e57e8e15e206c947))
* **deps:** bump golang.org/x/net from 0.36.0 to 0.38.0 in /tests ([#46](https://github.com/CloudNationHQ/terraform-azure-aa/issues/46)) ([b29d674](https://github.com/CloudNationHQ/terraform-azure-aa/commit/b29d6746cea10115fe6459d4a92d3141c358a8b5))

## [2.6.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.5.0...v2.6.0) (2025-03-20)


### Features

* add missing functionality runbooks ([#43](https://github.com/CloudNationHQ/terraform-azure-aa/issues/43)) ([73a2524](https://github.com/CloudNationHQ/terraform-azure-aa/commit/73a2524a02dc52bec0d0e4a5c5879095305a3cb3))
* **deps:** bump golang.org/x/net from 0.33.0 to 0.36.0 in /tests ([#42](https://github.com/CloudNationHQ/terraform-azure-aa/issues/42)) ([24b738b](https://github.com/CloudNationHQ/terraform-azure-aa/commit/24b738bcdac14bca9cf1b607dae2165a31bd21ba))

## [2.5.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.4.1...v2.5.0) (2025-01-15)


### Features

* add hash support for automation modules, added encrypted capabilities to all variable objects and remove temporary files when deployment tests fails ([#35](https://github.com/CloudNationHQ/terraform-azure-aa/issues/35)) ([3a0c540](https://github.com/CloudNationHQ/terraform-azure-aa/commit/3a0c5405bef97d725aac91aac5b2299d58d643b7))
* add private endpoint usage and updated documentation ([#39](https://github.com/CloudNationHQ/terraform-azure-aa/issues/39)) ([a22ec3e](https://github.com/CloudNationHQ/terraform-azure-aa/commit/a22ec3e386d942584a73d23b00938e5cf7ff74c1))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#34](https://github.com/CloudNationHQ/terraform-azure-aa/issues/34)) ([42500dd](https://github.com/CloudNationHQ/terraform-azure-aa/commit/42500ddf33193255d606d4a337694a95f127e357))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#38](https://github.com/CloudNationHQ/terraform-azure-aa/issues/38)) ([a968fe3](https://github.com/CloudNationHQ/terraform-azure-aa/commit/a968fe32f4711f9bafd4838ba17515e5cda8cf43))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#37](https://github.com/CloudNationHQ/terraform-azure-aa/issues/37)) ([011a74d](https://github.com/CloudNationHQ/terraform-azure-aa/commit/011a74dc0430eb0d2fba820991732b1107a6435d))

## [2.4.1](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.4.0...v2.4.1) (2024-11-13)


### Bug Fixes

* fix submodule documentation generation ([#31](https://github.com/CloudNationHQ/terraform-azure-aa/issues/31)) ([219bf70](https://github.com/CloudNationHQ/terraform-azure-aa/commit/219bf7012ff89c5ce05112da1631ca7522b40238))

## [2.4.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.3.0...v2.4.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#29](https://github.com/CloudNationHQ/terraform-azure-aa/issues/29)) ([505b067](https://github.com/CloudNationHQ/terraform-azure-aa/commit/505b067b602a11fc299098e165c4b1aff2e9b1a0))

## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.2.0...v2.3.0) (2024-10-29)


### Features

* add output for runbook and webhook ([#27](https://github.com/CloudNationHQ/terraform-azure-aa/issues/27)) ([a8834ea](https://github.com/CloudNationHQ/terraform-azure-aa/commit/a8834ea23dc73013debd07e6330a87ada2535342))

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.1.0...v2.2.0) (2024-10-29)


### Features

* add webhook support for runbooks ([#25](https://github.com/CloudNationHQ/terraform-azure-aa/issues/25)) ([f09b7cf](https://github.com/CloudNationHQ/terraform-azure-aa/commit/f09b7cffe5138e60befe2d94e057d4592d42a2ef))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#22](https://github.com/CloudNationHQ/terraform-azure-aa/issues/22)) ([09aa463](https://github.com/CloudNationHQ/terraform-azure-aa/commit/09aa4631b313325e86d6904c462beb2e57c9d603))
* **deps:** Bump github.com/gruntwork-io/terratest in /tests ([#21](https://github.com/CloudNationHQ/terraform-azure-aa/issues/21)) ([8744771](https://github.com/CloudNationHQ/terraform-azure-aa/commit/87447713bcf95d546adc9e13814a9b9653d7f837))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v1.0.0...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#18](https://github.com/CloudNationHQ/terraform-azure-aa/issues/18)) ([afb66e6](https://github.com/CloudNationHQ/terraform-azure-aa/commit/afb66e604b93644f80066c4dd99dd4abb0fc03fc))

### Upgrade from v1.0.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v0.4.0...v1.0.0) (2024-09-20)


### ⚠ BREAKING CHANGES

* data structure has changed due to renaming of properties.

### Features

* aligned several properties ([#16](https://github.com/CloudNationHQ/terraform-azure-aa/issues/16)) ([f769253](https://github.com/CloudNationHQ/terraform-azure-aa/commit/f769253f72fa721572ed55f7a1021a5a93c2818e))

### Upgrade from v0.4.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Rename object account to config
- Rename properties in config object:
  - resourcegroup -> resource_group
- Rename variable:
  - resourcegroup -> resource_group
- Rename output variable:
  - account -> config

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v0.3.0...v0.4.0) (2024-09-19)


### Features

* **deps:** Bump github.com/gruntwork-io/terratest in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-aa/issues/12)) ([6c91449](https://github.com/CloudNationHQ/terraform-azure-aa/commit/6c91449ca042a51d2264d9ef4eadc05a5686a65c))
* refactor automation variables to integrate type detection logic and simplified tests ([#13](https://github.com/CloudNationHQ/terraform-azure-aa/issues/13)) ([40b10cd](https://github.com/CloudNationHQ/terraform-azure-aa/commit/40b10cd6177be3238634cf4f1b615b2c449e8748))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v0.2.0...v0.3.0) (2024-08-29)


### Features

* update documentation ([#10](https://github.com/CloudNationHQ/terraform-azure-aa/issues/10)) ([5a9323f](https://github.com/CloudNationHQ/terraform-azure-aa/commit/5a9323f88b2e29d5c7b1164e6c0bd5c49815126f))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v0.1.1...v0.2.0) (2024-08-05)


### Features

* **deps:** Bump github.com/gruntwork-io/terratest in /tests ([#6](https://github.com/CloudNationHQ/terraform-azure-aa/issues/6)) ([01d3251](https://github.com/CloudNationHQ/terraform-azure-aa/commit/01d32512779ed26caaa7e2c41c756b3f0f8184e5))
* dynamic type inference for automation variables ([#8](https://github.com/CloudNationHQ/terraform-azure-aa/issues/8)) ([e23cbd8](https://github.com/CloudNationHQ/terraform-azure-aa/commit/e23cbd8cc24ff44e27b28ab22845eb6e740d8e34))

## [0.1.1](https://github.com/CloudNationHQ/terraform-azure-aa/compare/v0.1.0...v0.1.1) (2024-07-11)


### Bug Fixes

* fix invalid submodule references in examples ([#4](https://github.com/CloudNationHQ/terraform-azure-aa/issues/4)) ([4c7e4a7](https://github.com/CloudNationHQ/terraform-azure-aa/commit/4c7e4a73ea7584bde75539aab16ffdecb559ab32))

## 0.1.0 (2024-07-11)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-aa/issues/2)) ([8d1851c](https://github.com/CloudNationHQ/terraform-azure-aa/commit/8d1851cc497f2d31cad5c31eaf71ee4e072f46c9))
