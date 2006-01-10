From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 9 Jan 2006 23:09:56 -0500
Subject: [Ocfs2-devel] Userspace Cluster Testing HOWTO
Message-ID: <20060110040956.GA22270@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


OCFS2 Userspace Cluster HOWTO
*****************************

This document will lay out, briefly, how to use the userspace
cluster manager interface. I will use several shorthand terms,
defined as follows:
 * <cluster> -> <configfs>/cluster/<clustername>
 * o2cb -> <initscripts>/o2cb

One of the things that has changed from the old one-heartbeat
implementation is that the heartbeat modes have been split out
into modules. This means that you'll need to either change your
o2cb script to load the appropriate mode module prior to starting
the cluster, or you'll need to load it yourself.

The disk mode module is called ocfs2_disk_heartbeat. The user mode
module is called ocfs2_user_heartbeat. Both may be loaded at the
same time, but only one may be active. Choosing which one is
active is controlled by /sys/o2cb/heartbeat_mode. This file will
contain "inactive" if no mode module is loaded, but will otherwise
contain the active mode's name. When the first mode module is loaded,
it will automatically become the active mode. The mode cannot be
changed while a cluster is active, so before changing modes, make
sure that <configfs>/cluster is empty, otherwise the write will fail
with -EBUSY. If you attempt to change to a mode that isn't loaded,
the write will fail with -EINVAL.

To reiterate: With these patches applied, o2cb will fail to start
without modification. There is no way to keep them as separate
modules and have it automatically load since it creates a dependency
loop when ocfs2_nodemanager's module_init requests ocfs2_disk_heartbeat.
ocfs2_nodemanager technically isn't finished loading, so it locks up.

I suppose it would be possible to just link in the disk heartbeat by
default without much more hassle and avoid this problem entirely.

** Quick start

The easiest way to set up a quick userspace managed cluster is to unload
the disk mode module, load the user mode module, and restart o2cb. This
will automatically populate your node/ directory, and allow you to get
started creating heartbeat resources right away.

Otherwise, you'll need to populate the node/ directory manually.

** Interface basics

ConfigFS allows the user to create symbolic links to objects inside
the configfs namespace. This seemed like a natural way to allow the
user to manage heartbeat resources in an intuitive manner.

In order to create a userspace-managed heartbeat resource, the
<cluster>/node/ must be populated. There is no real reason why this
can't be done dynamically. The format of each node is unchanged
from the disk-based heartbeat.

Once the nodes are configured, a heartbeat resource can be defined
by creating a directory under <cluster>/heartbeat. Like the disk
heartbeat, this should be named with the capitalized UUID string of
the file system to be mounted. Unlike the disk heartbeat, the directory
will be created completely empty. This is normal.

To add nodes to the resource, you create a symbolic link from the node
you want to add in <cluster>/node to the <cluster>/heartbeat/<uuid>
directory. This should be done at approximately the same time on all
nodes affected by the changes. The solution we plan to use is to have
the Linux HA hb2 project manage all this, but for testing, just cut
and paste the changes into sessions on each node. Every time a link
is created, a node up event is issued.

To inform the kernel that a node has left the resource, whether by
crashing or umounting the file system, remove the link. The underlying
layers will make the determination themselves if the event was expected
or not, the same as how it is handled with the disk heartbeat.

Once you've created a heartbeat resource and added, minimally, the local
node, you'll be able to mount a file system. One thing to be sure about
though is that there are no kernel threads automatically managing
membership anymore. If you want to define two separate heartbeat groups
on multiple nodes with different memberships, it will be perfectly
happy to allow you to do so.

A quick way to get the UUID in the format heartbeat needs is this:
% mounted.ocfs2 -d <dev>|tail -1|awk '{print $3}'|tr -d -- -|tr a-z A-Z

** Example

% o2cb stop
% rmmod ocfs2_disk_heartbeat
% modprobe ocfs2_user_heartbeat
% o2cb start
% cat /sys/o2cb/heartbeat_mode

Verify that the output contains "user".

At this point <cluster>/node contains a number of directories,
corresponding to your node membership

% cd <cluster>/heartbeat
% UUID=`mounted.ocfs2 -d <dev>|tail -1|awk '{print $3}'|tr -d -- -|tr a-z A-Z`
% mkdir $UUID
% cd $UUID
% ln -s ../../node/* .

Execute this on all nodes and all nodes will be a part of the
resource and in sync. The file system will be able to be mounted
normally.
