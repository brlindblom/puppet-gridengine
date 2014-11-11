# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

class gridengine::qmaster inherits gridengine (
  $sgeqmaster = "sge.master",
  $sgeroot    = "/usr/lib/gridengine",
  $sgecell    = "default",
  $sgecluster = "default"
){
  file {
    "$ge_common/system.jsv":  source  => "puppet:///modules/gridengine/system.jsv"), mode => 555;
    "/etc/init.d/sgemaster":  source  => "puppet:///modules/gridengine/sgemaster"), mode => 700;
  }

  service { 
    sgemaster:
      enable => true,
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      subscribe => [ 
        Package["gridengine-qmaster"], 
        File["$ge_path/bootstrap"], 
        File["$ge_path/act_qmaster"], 
        File["/etc/sysconfig/gridengine"],
        File["/etc/init.d/sgemaster"],
      ];
  }
}
