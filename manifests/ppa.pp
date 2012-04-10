class apt_get_update {
  $sentinel = "/var/lib/apt/first-puppet-run"

  exec { "initial apt-get update":
    command => "/usr/bin/apt-get update && touch ${sentinel}",
    onlyif  => "/usr/bin/env test \\! -f ${sentinel} || /usr/bin/env test \\! -z \"$(find /etc/apt -type f -cnewer ${sentinel})\"",
    timeout => 3600,
  }
}

class python_software_properties {
  $package = "python-software-properties"
  package { $package:
    ensure  => installed,
    require => Exec['initial apt-get update'],
  }
}

define ppa($user, $package) {
  include python_software_properties
  include apt_get_update
  $slashed="${user}/${package}"
  $dashed="${user}-${package}"
  exec { "ppa-repo-added-${dashed}":
    command => "/usr/bin/add-apt-repository ppa:${slashed}",
    creates => "/etc/apt/sources.list.d/${dashed}-${lsbdistcodename}.list",
    require => Package[$python_software_properties::package],
  }

  exec { "ppa-repo-ready-${dashed}" :
    command => "/usr/bin/apt-get update && touch ${apt_get_update::sentinel}",
    require => Exec["ppa-repo-added-${dashed}"],
    creates => "/var/lib/apt/lists/ppa.launchpad.net_${dashed}_ubuntu_dists_${lsbdistcodename}_Release",
    timeout => 3600,
  }
}
