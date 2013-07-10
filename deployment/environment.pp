#
# Production Environment setup for YamOverflow
#

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