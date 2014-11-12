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
    "/var/spool/sge":         ensure => "directory", mode => 755;
    "/var/spool/sge/qmaster": ensure => "directory", mode => 755;
    "/var/spool/sge/db":      ensure => "directory", mode => 755;
    "/var/spool/sge/qmaster/defaultcfg": source => "$mod_file_path/defaultcfg", mode => 600;
  }

  exec {
    "berkeley_db_init":
      path        => ["/bin","/usr/bin","$sgeroot/utilbin/lx-amd64"],
      environment => ["SGE_ROOT=$sgeroot", "SGE_CELL=$sgecell"],
      cwd         => "$sgeroot/utilbin/lx-amd64",
      command     => join([
        "spoolinit berkeleydb $sgeroot/lib/lx-amd64/libspoolb /var/spool/sge/db init",
        "spooldefaults configuration /var/spool/sge/qmaster/defaultcfg",
        "spooldefaults complexes $sgeroot/util/resources/centry",
        "spooldefaults pes $sgeroot/util/resources/pes"
        ], ";"),
      onlyif      => "test ! -f /var/spool/sge/db/sge",
      require     => [ File["/var/spool/sge/db"], File["/var/spool/sge/qmaster/defaultcfg"] ];
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
        File["/var/spool/sge/qmaster"],
        Exec["berkeley_db_init"]
      ],
      subscribe => Class['gridengine'];
  }
}
