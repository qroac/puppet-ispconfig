# @summary Install and configure Jailkit on the host
#
# @example
#   include isp3node::jailkit
class isp3node::jailkit {
  # TODO add some typical jail configs for git, composer, nodejs, ...
  # TODO add a version fact and check for requirement to install a new version
  include isp3node::jailkit::setup
}
