# @summary Install software as required to be available on ispconfig nodes
#
# Beside requirements for ISPC, can further install administrative stuff like default editors
#
# @example
#   include isp3node::base::software
# 
# @param required
#   Required packages as suggested by perfect server setup
# @param additional
#   Additional packages to install on all systems, e.g. preferred editor
class isp3node::base::software(
  Array[String] $required,
  Optional[Array[String]] $additional = [],
) {
  # include apt module and refresh package list
  include apt
  package{$required + $additional:
    ensure  => latest,
    require => Class['apt::update']
  }
}
