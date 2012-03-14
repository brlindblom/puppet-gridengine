# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

class gridengine::execd inherits gridengine {

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
        "/etc/init.d/sgeexecd":     source => "puppet:///modules/gridengine/sgeexecd", mode => 700;
        "/usr/sbin/tmppurge":       source => "puppet:///modules/gridengine/tmppurge", mode => 700;
        "/usr/sbin/cleanorphans":   source => "puppet:///modules/gridengine/cleanorphans", mode => 700;
    }
	
	service { 
        sgeexecd:
		    enable => true,
		    ensure => running,
		    hasstatus => true,
		    hasrestart => true,
		    subscribe => [ Package["gridengine-execd"], 
                           File["$ge_path/bootstrap"], 
                           File["$ge_path/act_qmaster"], 
                           File["/etc/sysconfig/gridengine"],
                           File["/etc/init.d/sgeexecd"],
                           ];
	}
}
