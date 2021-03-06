# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

define gridengine::execd (
  $sgemaster  = $title,
  $sgeroot    = "/usr/share/gridengine",
  $sgecell    = "default",
  $sgecluster = "bigcluster",
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

	cron {
    orphanprocs:
	    command => "/usr/sbin/cleanorphans",
	    user => root,
	    minute => ip_to_cron(2);
	  tmpwatch:
	    command => "/usr/sbin/tmppurge",
	    user => root,
	    minute => ip_to_cron(4);
	}

  file {
    "/etc/init.d/sgeexecd":     source => "$mod_file_path/sgeexecd", mode => 700;
    "/usr/sbin/tmppurge":       source => "$mod_file_path/tmppurge", mode => 700;
    "/usr/sbin/cleanorphans":   source => "$mod_file_path/cleanorphans", mode => 700;
  }
	
	service { 
    sgeexecd:
	    enable => true,
		  ensure => running,
		  hasstatus => true,
		  hasrestart => true,
      require => [ Class['gridengine'], File['/etc/init.d/sgexecd'] ],
		  subscribe => Class['gridengine'];
	}
}
