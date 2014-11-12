# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

define gridengine::execd (
  $sgeroot    => "/usr/share/gridengine",
  $sgecell    => "default",
  $sgecluster => "bigcluster",
){
  require gridengine
  $sgemaster = $name
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
		  subscribe => [ 
        Package["gridengine-execd"], 
        File["$sgecfgdir/bootstrap"], 
        File["$sgecfgdir/act_qmaster"], 
        File["/etc/sysconfig/gridengine"],
        File["/etc/init.d/sgeexecd"],
      ];
	}
}
