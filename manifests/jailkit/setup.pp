# @summary Install the current version of Jailkit on the host
#
# Downloads the sourcecode archive, builds and installs the deb package
#
# @example
#   include isp3node::jailkit::setup
#
# @param build_packages
#   Packages required to build the software
# @param source
#   source url to download the {file}
# @param file
#   Filename to download from the {source}
# @param checksum
#   Expected checksum of the file
# @param checksum_type
#   Hash type of the checksum
# @param tmpfolder
#   Folder under /tmp/ that will be created by extracting the archive
class isp3node::jailkit::setup(
  Array[String] $build_packages,
  String $source,
  String $file,
  String $checksum,
  String $checksum_type,
  String $tmpfolder,
) {
  unless($facts['isp3node']['jailkit']['installed']){
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
}
