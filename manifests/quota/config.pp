# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::quota::config
class isp3node::quota::config(
  String $mountpoint,
  Array[String] $mountopts,
) {
  mounttab{$mountpoint:
    options  => $mountopts,
    provider => augeas,
  }
  ~> exec{'quota-remount':
    command     => "mount -o remount ${mountpoint}",
    path        => $facts['path'],
    refreshonly => true
  }
  ~> exec{'quota-check':
    command     => 'quotacheck -avugm',
    path        => $facts['path'],
    refreshonly => true
  }
  ~> exec{'quota-on':
    command     => 'quotaon -avug',
    path        => $facts['path'],
    refreshonly => true
  }

}
