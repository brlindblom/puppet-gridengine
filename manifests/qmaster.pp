# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

class gridengine::qmaster inherits gridengine (
  $sgeroot    => "/usr/share/gridengine",
  $sgecell    => "default",
  $sgecluster => "bigcluster"
){
  file {
    "$sgecommon/system.jsv":  source  => "$mod_file_path/system.jsv"), mode => 555;
    "/etc/init.d/sgemaster":  source  => "$mod_file_path/sgemaster"), mode => 700;
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
