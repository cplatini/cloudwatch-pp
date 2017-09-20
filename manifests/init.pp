

class cloudwatchmetric (
  $proxy_host = "prxy-lb.${::domain}",
  $proxy_url = "https://prxy-lb.${::domain}:3128"
){


    file { "/etc/boto.cfg":
        ensure => present,
        mode => "0644",
        owner => 'root',
        group => 'root',
        content => template('cloudwatchmetric/boto.cfg.erb'),
        #source => 'puppet:///modules/cloudwatchmetric/boto.cfg',
    }


    exec { "pip-1":
        command => "pip --proxy ${proxy_url} install --upgrade boto setuptools",
        creates => "/usr/lib/python2.6/site-packages/boto-2.47.0.dist-info",
        path    => ["/usr/bin", "/usr/sbin"],
        timeout => 100,
    }

    exec { "pip-2":
        command => "pip --proxy ${proxy_url} install cloudwatchmon",
        creates => "/usr/lib/python2.6/site-packages/cloudwatchmon",
        path    => ["/usr/bin", "/usr/sbin"],
        timeout => 100,
    }

    cron { 'mon_cron':
        command => "/usr/bin/mon-put-instance-stats.py --mem-avail --disk-space-avail --disk-path=/ --from-cron",
        user    => 'root',
    }

}
