# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

define gridengine::qmaster (
  $sgemaster  = $title,
  $sgeroot    = "/usr/share/gridengine",
  $sgecell    = "default",
  $sgecluster = "bigcluster"
){
  $mod_file_path  = "puppet:///modules/gridengine"
  $sgecfgdir      = "$sgeroot/$sgecell"
  $sgecommon      = "$sgecfgdir/common"

  class { 
    'gridengine':
      sgemaster   => $sgemaster,
      sgeroot     => $sgeroot,
      sgecell     => $sgecell,
      sgecluster  => $sgecluster;
  }

  file {
    "$sgecommon/system.jsv":  source  => "$mod_file_path/system.jsv", mode => 555;
    "/etc/init.d/sgemaster":  source  => "$mod_file_path/sgemaster", mode => 700;
  }

  service { 
    sgemaster:
      enable => true,
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      subscribe => [ 
        Package["gridengine-qmaster"], 
        File["$sgecfgdir/bootstrap"], 
        File["$sgecfgdir/act_qmaster"], 
        File["/etc/sysconfig/gridengine"],
        File["/etc/init.d/sgemaster"],
      ];
  }
}
