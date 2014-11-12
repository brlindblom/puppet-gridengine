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
      sgemaster =>  $sgemaster, 
      sgeroot =>    $sgeroot, 
      sgecell =>    $sgecell,
      sgecluster => $sgecluster;
  }

  File {
    require => Class['gridengine'],
  }

  file {
    "$sgecommon/system.jsv":  source  => "$mod_file_path/system.jsv", mode => 555;
    "/etc/init.d/sgemaster":  source  => "$mod_file_path/sgemaster", mode => 700;
    "/etc/sgeinstall.conf":   content => template("gridengine/sgeinstall.conf.erb"), mode => 600;
  }

  exec {
    "install_qmaster":
      path    => ["/bin","/usr/bin","$sgeroot"],
      command => "inst_sge -m -auto /etc/sgeinstall.conf",
      onlyif  => "test ! -d /var/spool/sge",
      require => File["/etc/sgeinstall.conf"];
  }

  service { 
    sgemaster:
      enable => true,
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      require => [ 
        Class['gridengine'], 
        File["$sgecommon/system.jsv"], 
        File["/etc/init.d/sgemaster"],
        File["/etc/sgeinstall.conf"],
        Exec["install_qmaster"]
      ],
      subscribe => Class['gridengine'];
  }
}
