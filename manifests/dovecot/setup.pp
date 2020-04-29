# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::dovecot::setup
# @param packages
#   Required dovecot packages for setting up with ISPConfig
class isp3node::dovecot::setup(
  Array[String] $packages,
) {
  # Install dovecot and required packages
  package{$packages:
    ensure => latest,
  }
}
