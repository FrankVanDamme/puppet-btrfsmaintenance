# @author Frank Van Damme
# @summary
#   Configures the btrfsmaintenance package in Debian distros
#
# @api public
#
# @param log_output
#   Where and how to log messages: none,stdout,journal,syslog
#
# @param defrag_paths
#
#   Array of paths
#
#   Paths to run periodic defrag on. Does not cross subvolumes.
#
# @param defrag_period
#   How often to defrag: none,daily,weekly,monthly
#
# @param defrag_min_size
#   Minimal file size to consider for defragmentation
#
# @param balance_mountpoints
#   List of mount points to include in periodical balance routine
#
#   Array of paths, or "auto".
#
# @param balance_period
#   How often to balance: none,daily,weekly,monthly
#
# @param balance_musage
#   Usage % for balancing metadata or mixed block groups; multiple values for
#   subsequent runs
#
#   Array or space separated list of integer numbers
#
# @param balance_dusage
#   Usage % for balancing data block groups; multiple values for subsequent
#   runs
#
#   Array or space separated list of integer numbers
#
# @param scrub_mountpoints
#   List of mountpoints to include in periodical scrub routing
#
#   Array of paths, or "auto".
#
# @param scrub_period
#   How often to scrub:
#
# @param scrub_read_only
#   Read-only means: do not try to fix (if true).
#
# @param trim_period
#   How often to run fstrim (for SSD disks).
#
# @param trim_mountpoints
#   List of mountpoints to include in periodical fstrim run 
#
#   Array of paths, or "auto".
#
# @param allow_concurrency
#   Allow or disallow running more than one of these maintenance tasks at the
#   same time
#
class btrfsmaintenance (
    Enum[none,stdout,journal,syslog] $log_output = "stdout",

    Array[Stdlib::Absolutepath] $defrag_paths = [],
    Enum['none','daily','weekly','monthly'] $defrag_period = "none",
    Pattern[/^\+\d+[kKmMgGtTpPeE]/] $defrag_min_size = "+1M",

    Variant[Enum["auto"],Array[Stdlib::Absolutepath]] $balance_mountpoints = [],
    Enum['none','daily','weekly','monthly'] $balance_period = "none",
    Variant[Pattern[/^(\d* *)*$/],Array[Integer]] $balance_dusage = [5, 10, 20, 40],
    Variant[Pattern[/^(\d* *)*$/],Array[Integer]] $balance_musage = [5, 20, 40],

    Variant[Enum["auto"],Array[Stdlib::Absolutepath]] $scrub_mountpoints = [],
    Enum['none','daily','weekly','monthly'] $scrub_period = "monthly",
    Enum['idle','normal'] $scrub_priority = "idle",
    Boolean $scrub_read_only = false,

    Enum['none','daily','weekly','monthly'] $trim_period = "none",
    Variant[Enum["auto"],Array[Stdlib::Absolutepath]] $trim_mountpoints = "auto",

    Boolean $allow_concurrency = false,

){
    package { "btrfsmaintenance":
        ensure => present,
    }
    -> file { "/etc/default/btrfsmaintenance":
        content => template("${module_name}/default.erb"),
    }
    ~> exec {"refresh btrfsmaintenance timers":
        refreshonly => true,
        command     => "systemctl restart btrfsmaintenance-refresh",
        path        => "/sbin:/usr/sbin:/bin:/usr/bin",
    }
}
