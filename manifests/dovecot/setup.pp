# @summary Install Dovecot Mailbox Server
#
# @example
#   include isp3node::dovecot::setup
# @param packages
#   dovecot main packages for setting up with ISPConfig
# @param additional_packages
#   Additional Required packages for setting up with ISPConfig
class isp3node::dovecot::setup(
  Array[String] $packages,
  Array[String] $additional_packages,
) {
  # Install dovecot and required packages
  package{$packages + $additional_packages:
    ensure => latest,
  }
}
