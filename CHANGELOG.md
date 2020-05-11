# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.1

**Features**
- rspamd: add satellite ips to list of trusted local adresses
- postfix:
  - set satellite interface to loopback-only

**Bugfixes**
- only "ensure_resource" of system base software to avoid conficts with other packages as long as they do the same
- mariadb: set correct permissions for remote isproot users in master db
- add installation of PHP base set to profile::dns
- add php-fpm to profile::master
- postfix:
  - dont use camptocamp configuration of satellite or mta nodes, too less configurable
  - move master_submission and _smtps to postfix standalone, not required on satellite
  - check for installed dovecot/mailman before listing corresponding lines in main.cf
  - set standalone to listen on public ip
  - add ispconfig related options only on standalone, not required for satellite

## Release 0.1.0

**Features**
- Initial release for installing all required services to host server nodes with ISPConfig 3.1

**Bugfixes**

**Known Issues**
