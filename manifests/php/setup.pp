# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::php::setup
# @param version
#   PHP Version to install and manage
# @param set
#   The configuration set to manage on this host
# @param sets
#   Config sets defining system packages, extensions and features
#   managed on all isp nodes and on special ones like webserver
class isp3node::php::setup(
  String $version,
  Hash[String, Struct[{
    Optional[packages]   => Array[String],
    Optional[extensions] => Hash[String, Hash],
    Optional[features]   => Array[Enum['fpm', 'dev', 'composer', 'pear', 'phpunit']],
    Optional[settings]   => Hash[String, Any]
  }]] $sets,
  Optional[String] $set = undef,
) {
  unless ($set =~ Undef or has_key($sets, $set)) {
    fail("PHP setup set ${set} is not defined")
  }
  # maybe additional versions from sury, like so:
  # https://github.com/codingfuture/puppet-cfweb/search?q=php&unscoped_q=php

  $my_set = $set ? {
    undef => $sets['default'],
    default => deep_merge($sets['default'], $sets[$set]),
  }
  $my_features = pick($my_set['features'], [])

  ensure_packages($my_set['packages'], {ensure => latest})

  class { '::php::globals':
    php_version => $version,
    config_root => "/etc/php/${version}",
  }
  -> class { '::php':
    ensure       => latest,
    manage_repos => true,
    fpm          => member($my_features, 'fpm'),
    dev          => member($my_features, 'dev'),
    composer     => member($my_features, 'composer'),
    pear         => member($my_features, 'pear'),
    phpunit      => member($my_features, 'phpunit'),
    settings     => $my_set['settings'],
    extensions   => $my_set['extensions'],
  }
}
