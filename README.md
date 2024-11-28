# btrfsmaintenance

Welcome to your new module. A short overview of the generated parts can be found
in the [PDK documentation][1].

The README template below provides a starting point with details about what
information to include in your README.

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with btrfsmaintenance](#setup)
    * [What btrfsmaintenance affects](#what-btrfsmaintenance-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with btrfsmaintenance](#beginning-with-btrfsmaintenance)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Btrfsmaintenance configures BTRFS file system maintenance jobs based on the
Debian package by the same name. It is possible to periodically run scrub,
defrag, balance, and trim jobs and parametrize those.

Configuration ends up in a single central file /etc/default/btrfsmaintenance,
and systemd timers are configured and updated based on that.

## Setup

### What btrfsmaintenance affects **OPTIONAL**

* btrfsmaintenance package installation through apt
* rewrites /etc/default/btrfsmaintenance file
* systemd service btrfsmaintenance-refresh restart, which takes care of
  updating the timers

### Setup Requirements **OPTIONAL**

Have Debian. RedHat does not even support BTRFS.

### Beginning with btrfsmaintenance

`include btrfsmaintenance`

By default, this will not balance, defrag or scrub, but will trim any file
system it can find on a monthly basis.

## Usage

Use Hiera. To eg. balance /home every week:

```
btrfsmaintenance::balance_period: weekly
btrfsmaintenance::balance_mountpoints:
    - /home
```

Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

## Limitations

Only useful on systems that use btrfs file system, which for whatever reason
need housekeeping.
