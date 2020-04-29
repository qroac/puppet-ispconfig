# @summary Changes the systems default shell
#
# Changes the default shell to bash, as required for ispconfig
#
# @example
#   include isp3node::base::shell
class isp3node::base::shell {
  exec{'Change default shell to bash':
    command => 'rm /bin/sh && ln -s /bin/bash /bin/sh && dpkg-reconfigure -f noninteractive dash',
    onlyif  => 'ls -la /bin/sh | grep dash',
    path    => $facts['path'],
  }
}
