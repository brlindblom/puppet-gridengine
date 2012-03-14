# /etc/puppet/modules/gridengine/manifests/init.pp
# Created by root on Thu Dec  3 16:40:42 EST 2009

class gridengine {
    package { 
        "gridengine-execd":     ensure => present; 
        "gridengine":           ensure => present; 
        "gridengine-qmaster":   ensure => present; 
        "gridengine-qmon":      ensure => present;
    }

    $ge_root    = "/usr/share/gridengine"
    $ge_cell    = "default"
    $ge_cluster = "circe"
    $ge_common  = "$ge_root/$ge_cell/common"
    $ge_qmaster = "sge.rc.usf.edu"

    File {
        owner => "root",
        group => "root",
        mode  => "444",
        require => Package["gridengine", "gridengine-execd"],
    }

	file {
        "$ge_root/$ge_cell":            ensure => directory, mode => 755;
        "$ge_common":                   ensure => directory, mode => 755;
        "$ge_common/bootstrap":         content => template("gridengine/bootstrap.erb");
        "$ge_common/act_qmaster":       content => template("gridengine/act_qmaster.erb");
        "$ge_common/sge_request":       content => template("gridengine/sge_request.erb");
        "$ge_common/settings.sh":       content => template("gridengine/settings.sh.erb");
        "$ge_common/settings.csh":      content => template("gridengine/settings.csh.erb");
        "/etc/sysconfig/gridengine":    content => template("gridengine/gridengine.erb");
    }
}
