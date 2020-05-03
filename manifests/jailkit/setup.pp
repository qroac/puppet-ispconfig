# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include isp3node::jailkit::setup
class isp3node::jailkit::setup(
  Array[String] $build_packages,
  String $source,
  String $file,
  String $checksum,
  String $checksum_type,
  String $tmpfolder,
) {
  package{$build_packages:
    ensure => latest,
    tag    => ['build-req'],
  }
  -> archive { $file:
    ensure        => present,
    path          => "/tmp/${file}",
    extract       => true,
    extract_path  => '/tmp',
    source        => "${source}/${file}",
    checksum      => $checksum,
    checksum_type => $checksum_type,
    creates       => "/tmp/${tmpfolder}",
    cleanup       => true,
  }
  -> file{"/tmp/${tmpfolder}/debian/comapat":
    ensure  => file,
    content => '5',
  }
  -> exec{'jailkit-build':
    command => 'rules binary && mv /tmp/jailkit_*.deb /tmp/jailkit.deb',
    path    => "${facts['path']}:/tmp/${tmpfolder}/debian",
    cwd     => "/tmp/${tmpfolder}",
    unless  => 'ls /tmp/jailkit.deb',
  }
  -> package{'jailkit':
    ensure   => installed,
    provider => 'dpkg',
    source   => '/tmp/jailkit.deb',
  }
  -> exec{'jailkit-cleanup':
    command => 'rm -rf /tmp/jailkit*',
    onlyif  => 'ls /tmp/jailkit*',
    path    => $facts['path'],
  }
}
