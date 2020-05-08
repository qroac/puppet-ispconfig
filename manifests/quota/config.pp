# @summary Configures quota
#
# Adds required quota options to fstab and initially enables user quota on the system
#
# @example
#   include isp3node::quota::config
# @param mountpoint
#   Mountpoint in fstab to set quota on
# @param mountopts
#   Mount options to apply to this mountpoint. Defaults to minimum options for system partition + required opts for quota
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
