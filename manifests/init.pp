class mosh {
  $package = 'mosh'
  $reponame = 'keithw-mosh'
  $repokey = '7BF6DFCD'
  $keyserver = 'keyserver.ubuntu.com'
  $repository = "deb http://ppa.launchpad.net/keithw/mosh/ubuntu ${lsbdistcodename} main\n"

  package { $package:
    ensure => installed,
  }

  if ($repository and $::operatingsystem == 'Ubuntu') {
    # friendly unique titles
    $_repokey = "get ${repokey} from ${keyserver}"
    $_update  = "apt-get update for ${reponame}"
    $_source  = "/etc/apt/sources.list.d/${reponame}.list"

    # fetch the key
    exec { $_repokey:
      path    => '/bin:/usr/bin',
      unless  => "apt-key list | grep '${repokey}'",
      command => "apt-key adv --keyserver ${keyserver} --recv-keys ${repokey}",
    }

    # add the source
    file { $_source:
      ensure  => present,
      content => "${repository}\n",
    }

    # apt-get update if it hasn't been done since adding the source
    $find_newer_lists = "find /var/lib/apt/lists -type f -cnewer ${_source}"
    exec { $_update:
      path    => '/usr/bin',
      command => 'apt-get update',
      onlyif  => "test -z \"\$(${find_newer_lists})\"",
      timeout => 3600,
      require => [Exec[$_repokey], File[$_source]],
    }

    # tell the package to depend on the update check
    Package[$package] {
      require +> Exec[$_update],
    }
  }
}
