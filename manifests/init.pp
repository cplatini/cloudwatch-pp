

class cloudwatchmetric (
  $proxy_host = "prxy-lb.${::domain}",
  $proxy_url = "https://prxy-lb.${::domain}:3128"
){

# aws s3 cp s3://$env_type-lin-config-3mhis-cloud/MISC/CloudWatchDiskMetric/boto.cfg /etc/boto.cfg
# echo "proxy = prxy-lb.soa-$env_type.aws.3mhis.net" >> /etc/boto.cfg 
# echo "proxy_port = 3128" >> /etc/boto.cfg

    file { "/etc/boto.cfg":
        ensure => present,
        mode => "0644",
        owner => 'root',
        group => 'root',
        content => template('cloudwatchmetric/boto.cfg.erb'),
        #source => 'puppet:///modules/cloudwatchmetric/boto.cfg',
    }

# pip --proxy https://prxy-lb.soa-$env_type.aws.3mhis.net:3128 install --upgrade boto setuptools
# pip --proxy https://prxy-lb.soa-$env_type.aws.3mhis.net:3128 install cloudwatchmon
# printf "* * * * * /usr/bin/mon-put-instance-stats.py --mem-avail --disk-space-avail --disk-path=/ --from-cron\n" | tee -a /var/spool/cron/root

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
