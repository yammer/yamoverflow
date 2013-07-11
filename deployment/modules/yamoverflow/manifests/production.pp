#
# Production Environment setup for YamOverflow
#
class yamoverflow::production {
  package{["nginx-full","postgresql","build-essential","libpq-dev"]:
    ensure => present,
  }

  group{ yamoverflow:
    ensure => present,
  }

  user{ yamoverflow:
    ensure => present,
    gid => yamoverflow,
    shell => "/bin/false",
    require => Group[yamoverflow],
  }

  file{"/opt/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
    mode => 0640,
    require => [Group[yamoverflow],User[yamoverflow]],
  }

  file{"/var/run/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
  }

  file{"/var/log/yamoverflow":
    ensure => directory,
    owner => yamoverflow,
    group => yamoverflow,
  }

  file{"/etc/init/yamoverflow.conf":
    ensure => present,
    source => "puppet:///modules/yamoverflow/yamoverflow.conf",
    owner => root,
    group => root,
    mode => 0644,
  }

  file{"/etc/nginx/sites-available/yamoverflow":
    ensure => present,
    owner => root,
    group => root,
    mode => 0600,
    source => "puppet:///modules/yamoverflow/nginx.conf",
    notify => Service[nginx],
  }

  file{"/etc/nginx/sites-enabled/yamoverflow":
    ensure => link,
    target => "/etc/nginx/sites-available/yamoverflow",
    notify => Service[nginx],
  }

  service{"nginx":
    ensure => running,
  }

  #rvm setup
  package{"ruby-rvm":
    ensure => purged,
  }

  file{["/usr/share/ruby-rvm","/etc/rvmrc","/etc/profile.d/rvm.sh"]:
    ensure => absent,
    recurse => true,
  }

  exec {"install-rvm":
    path => ["/usr/bin","/usr/sbin","/sbin","/bin"],
    command => "curl -L https://get.rvm.io | bash -s stable",
    creates => "/usr/local/rvm",
  }
}