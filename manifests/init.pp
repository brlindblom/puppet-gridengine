# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

class gridengine ($sgeroot, $sgecell, $sgemaster, $sgecluster) {
  $mod_file_path  = "puppet:///modules/gridengine"
  $sgecfgdir      = "$sgeroot/$sgecell"
  $sgecommon      = "$sgecfgdir/common"

  yumrepo {
    "loveshack-SGE":
      baseurl => "http://copr-be.cloud.fedoraproject.org/results/loveshack/SGE/epel-6-\$basearch/",
      skip_if_unavailable => true,
      gpgcheck => false,
      enabled => true
  }

  Package {
    install_options => "--nogpgcheck",
    require => Yumrepo["loveshack-SGE"],
  }

  package {
    "gridengine":         ensure => present;
    "gridengine-execd":   ensure => present;
    "gridengine-qmaster": ensure => present;
    "gridengine-qmon":    ensure => present;
  }

  File {
    owner   => "root",
    group   => "root",
    mode    => "444",
    require => Package["gridengine", "gridengine-execd"],
  }

  file {
    "$sgecfgdir":                 ensure  => directory, mode => 755;
    "$sgecommon":                 ensure  => directory, mode => 755;
    "$sgecommon/bootstrap":       content => template("gridengine/bootstrap.erb");
    "$sgecommon/act_qmaster":     content => template("gridengine/act_qmaster.erb");
    "$sgecommon/sge_request":     source  => "$mod_file_path/sge_request";
    "$sgecommon/settings.sh":     source  => "$mod_file_path/settings.sh";
    "$sgecommon/settings.csh":    content => template("gridengine/settings.csh.erb");
    "/etc/sysconfig/gridengine":  content => template("gridengine/gridengine.erb");
    "/etc/profile.d/sge.sh":      ensure => link, target => "$sgecommon/settings.sh";
    "/etc/profile.d/sge.csh":     ensure => link, target => "$sgecommon/settings.csh";
  }
}
