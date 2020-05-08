# FACTS

Status ISPConfig: 
- Installiert?
- Version
- Angebotene Services
- Config Kram aus ISP Server Config?

Mailserver:
ISPConfig Mail Domains auf dem System
- Domain
- DNS Host (MX) (automatisch per prefix `mail.`? in hiera festgelegt?)
- DNS Host valide (löst DNS auf mich auf?)

# Notes
LE Zertifikat für Dienste kann Hostnamen von Kundendomains einschließen
Liste aus Mailserver Fact, gefiltert auf valide aufgelöste!
z.B. für Mailserver: mail.autark-app.de

# isp3node

This module manages the installation and configuration of all services and tools required to run an ISPConfig server node.
Currently it contains everything needed for a setup according to the current Debian 10 PerfectServer Tutorial from howtoforge.com
with modifications for the already suggested replacement of amavis+spamassassin with rspamd.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with isp3node](#setup)
    * [What isp3node affects](#what-isp3node-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with isp3node](#beginning-with-isp3node)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Install, configure and manage all services required to host web services with ISPConfig on your nodes.

Each host managed with this module can be set up as full hosting node (all services) or with the specific configuration to run a node dedicated as master, dns, mail or web/db server.

It further automates the deployment of a manually created SSL Certificate (paid) or obtaining one for the hosts FQDN via letsencrypt.
All services that depend on a valid certificate, like postfix, dovecot, isp panel, pureftpd, get provisioned with that certificate.

In Addition the module places a default ssl nginx host on its FQDN with links to all locally installed customer web interfaces like mailman, phpmyadmin or roundcube. There will be no link to rspamd. On the mailserver it is also configured at yourhost.fqdn/rspand/, but as it is no interface for customers, it is not listed in public.

## Setup

```
# in your data.yml, default is master only for multiserver master and ISPConfig panel
isp3node::mode: full
# in your site manifest
inlcude isp3node
```
Alternativly you can include the isp3node class with a mode parameter `class {'isp3node': mode => 'full'}` or directly include one of the provided server profiles like this:
- `include isp3node::profiles::full`
- `include isp3node::profiles::master`
- `include isp3node::profiles::dns`
- `include isp3node::profiles::mail`
- `include isp3node::profiles::web`

### Required configuration

The following configuration options need to be present in your data files. These are important project-specific settings and thus I do not set any defaults to it.

```yaml
isp3node::email: your@e.mail
# FQDN of the master node, used in the manifests to determine if a node is the current master in your setup
isp3node::master: your.master.fqdn
isp3node::mariadb::root_password: supersecret
# User and Password to use from this host to connect to the master database during ISPConfig Setup or Update
# Do not use username root! This conficts with a resource that is created in the mysql installation manifests setting your local root access
isp3node::mariadb::connect_master::user: isproot
isp3node::mariadb::connect_master::password: supersecret
# If running as postfix satellite, FQDN of the used relay server
# The relay server will automatically add IPs of all its satellites to the mynetworks config variable
isp3node::postfix::satellite::relay: isptest02.spicyweb.de
# ISPConfig needs some configuration that can not be made with camptocamp-postfix module, so we need to use an own template
# That cannot be overwritten on module level, so you have to place this option on site level in your data files
postfix::params::master_os_template: isp3node/postfix/master.cf.debian.erb

# Configuration for phpMyAdmin session encryption and access to phpmyadmins config tables
isp3node::phpmyadmin::setup::blowfish_secret: supersecret
isp3node::phpmyadmin::setup::controlpass: supersecret

# Credentials to access mailmans admin settings
isp3node::mailman::configure::admin_email: your@e.mail
isp3node::mailman::configure::admin_password: supersecret
```

### What isp3node affects

Well, the installation and configuration of about every service needed for ISPConfig.
Especially dovecot, fail2ban, php and postfix config is hardly set by isp3node or additional modules used for service management.
So if you want to change congigurations for one of the installed services, safest way is to use possibilities that are already given in this module or create a pull request to extend the code to be able to apply your config changes.

The installation of ISPConfig itself it does only affect by creating remote users with privileges on dbispconfig.* for your ISP slave servers.
The module further brings the deployed (hiera) or obtained (LE) SSL Certificate in place for the ISP Panel, but it does not install ISPConfig for you. That last step is still up to you.

### Setup Requirements

#### PuppetDB

The IP List for allowed satellites to send mails using a standalone Postfix as relay is obtained from PuppetDB.
So a setup running a PuppetDB along with your puppet master is a must.

#### Hiera Data

Some parameters for managed services need to be set for your project.  
Thats because I dont want to spread my mail address over the net and receive all your LetsEncrypt notifications but also because no one shoud know passwords that are set on your installation.

As alternative to blow up variables passed from the highest to the lowest class, I decided to just define them in hiera.
Less possible mistakes by forgetting to pass a variable and such.

Long story short: The parameters in _Required configuration_ above are mandatory in your hiera data. So you can use this module only in conjunction with data files in your project.

### Beginning with isp3node

Add and configure the parameters from _Required configuration_ in your hiera data files.

Then add `include isp3node` to a host to install everything required for an ISPConfig3 Master Panel server (not ment to host customer data, really only 
made for panel and master database).

## Usage

As said before, first make sure to add the required configuration to your data files. I recommend to use eyaml for storing passwords, secrets or private keys in yaml files, but that's up to you.

By default this module installs requirements for the master database and ISPConfig configuration panel, but not to host customer sites, DNS or mail accounts.
To set up your host for a different role, you can choose from different roles:
- full: Complete installation from HowtoForge perfect server tutorial for hosting everything on one machine
- master: Prepared to host the master DB and the panel. In fact just an installation of 'web' with some not required features stripped out. If you don't want to have a dedicated master, just use a full or web node as master.
- dns: BIND9 DNS Server
- mail: Postfix MTA and dovecot, usable as mail relay for all other servers
- web: nginx webserver and MariaDB server configured for public access

You have different options to set a role for your host:
- Set it on import in class style: `class {'isp3node': mode => 'full'}`
- Set it in a host-specific hiera file: `isp3node::role: full`
- Directly import the desired isp3node profile: `import isp3node::profile::full`

There is no risk in importing the desired profile as the main class does nothing else than that.

The profiles on the other hand just import the main setup classes of the required components, some with additional parameters.
So if you need a special scenario, you can peek into the profiles and build your own one featuring a public accessible database, jailkit, Mail and DNS. Just include the desired service setup classes. (PS: Mail with rspamd still requires nginx for access to the rspamd dashboard).

## Limitations

Currently this module is limited to Debian 10 only!  
It will not work on any other OS as a lot of distributionspecific configuration is contained in a OS-Version-Datafile for Debian 10.

Further it does not install or update ISPConfig for you. You still have to do that on your own.

Be also warned that some of the services managed by this module will have any manual configuration changes overwritten on next run of your puppet agent.  
For some services there already are variables in the configuation classes to insert some custom config. So first dig into there and look at the documented parameters of the classes.  
If you cannot find anything there to make your desired configuration managable, I welcome senseful feature requests or, if you are in hurry, pull requests.

## Development

Because I am as most human beings limited to 24 hours per day and am doing this in my spare time, I highly appreciate developers willing to push this module forward with me. So if you want to introduce a change in this modules code, please open a pull request.

A great description in the PR would describe the reason for the PR and telling details about what it changes and what else it could affect.

### Importent for all chages
- Extract configurations, package names and so on into the data files
- Set up a default configuration that makes sense with a minimum of configuration requirements
- Require but do not include sensitive information like passwords. I think they should be forced to be set even in a testing environment.
- Speaking of: TEST. Test your changes with all predefined server roles. There is no automated test suite yet. So set up test VMs or such and assing the different roles to it (maybe the same VM again and again with reset to a snapshot in between)

### In case of bugfix or code improvement

Please open an Issue first and describe the bug. In your Pull Rerquest please refer to this issue and explain the solution.

### In case of new features

If you are adding new managable features or possibilities of fine-grain configuration to existing services or a new service at all, please start by opening an issue. Describe the new feature that you want to implement, why and to whom it is important.

If possible, your new feature for an existing feature should take place in a dedicated subclass of that service, that is to be included by the services main setup class. Yes, that will not work for all services. Especially when they are managend through 3rd party modules requiring to pass the whole configuration at class initialization ...

For introducing new services, please stick wherever possible to my class pattern having a main class importing first a setup class followed by a main config class and additional feature classes. That keeps the code units small and maintainable.

### In case of new OSses

I can only test and maintain the code for Debian from 10 up. I dont have any other servers in my possession and especially with CentOS or RedHat too few practical experience.

So if you want to introduce a different OS than Debian, I invite you to become maintainer for isp3node regarding to this OS.
- Add the OS specific data files listing required packages
- make required changes (especially if supporting non-APT and dpkg related OSses, as that is used a lot in this module)
- Test it on your OS, I will do so on debian
- Create your pull request
- Be ready to pick up the co-maintainer hat for your OS

*Sidenote:* As mentioned before I can support only debian. That is why I will remove OSses without active maintainer.