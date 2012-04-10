class mosh {
  $key = "7BF6DFCD"
  exec { 'apt-key keithw':
    path    => "/bin:/usr/bin",
    onlyif  => "apt-key list | grep '${key}'",
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${key}",
  }

  ppa { 'ppa:keithw/mosh':
    user    => 'keithw',
    package => 'mosh',
    require => Exec['apt-key keithw'],
  }

  package { 'language-pack-en-base':
    ensure => installed,
    notify => Exec['dpkg-reconfigure locales'],
  }

  exec { 'dpkg-reconfigure locales':
    refreshonly => true,
    command     => "/usr/sbin/dpkg-reconfigure locales",
  }

  package { 'mosh':
    ensure  => installed,
    require => Ppa['ppa:keithw/mosh'],
  }
}
