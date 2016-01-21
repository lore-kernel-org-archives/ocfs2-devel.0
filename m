From: Gang He <ghe@suse.com>
Date: Wed, 20 Jan 2016 19:23:37 -0700
Subject: [Ocfs2-devel] OCFS2 causing system instability
References: <56A0B17C020000F900026809@relay2.provo.novell.com>
	<56A0B1A9020000F90002680C@relay2.provo.novell.com>
Message-ID: <56A0B1A9020000F90002680C@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guy,




>>> 
> Hello Gang,
> 
> Thank you for the quick response, it looks like the right direction for me
> - similar to other file systems (not clustered) have.
> 
> I've checked and saw that the mount forwards this parameter to the OCFS2
> kernel driver and it looks the version I have in my kernel does not support
> the errors=continue but only panic and remount-ro.
> 
> You've mentioned the "latest code" ... my question is:  On which kernel
> version it should be supported? I'm currently using 3.16 on ubuntu 14.04.

please refer to git commit in kernel.git
commit 7d0fb9148ab6f52006de7cce18860227594ba872
Author: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date:   Fri Sep 4 15:44:11 2015 -0700

    ocfs2: add errors=continue

    OCFS2 is often used in high-availaibility systems.  However, ocfs2
    converts the filesystem to read-only at the drop of the hat.  This may
    not be necessary, since turning the filesystem read-only would affect
    other running processes as well, decreasing availability.

Finally, as Joseph said, you can't unplug a hard disk on a running file system, this is a shared disk cluster file system, not a multiple copy distributed file system.
option "errors=continue" can let the file system continue when encountering a local inode meta-data corruption problem.

Thanks
Gang 

> 
> 
> Thanks,
> 
> Guy
> 
> On Wed, Jan 20, 2016 at 4:21 AM, Gang He <ghe@suse.com> wrote:
> 
>> Hello guy,
>>
>> First, OCFS2 is a shared disk cluster file system, not a distibuted file
>> system (like Ceph), we only share the same data/metadata copy on this
>> shared disk, please make sure this shared disk are always integrated.
>> Second, if file system encounters any error, the behavior is specified by
>> mount options "errors=xxx",
>> The latest code should support "errors=continue" option, that means file
>> system will not panic the OS, and just return -EIO error and let the file
>> system continue.
>>
>> Thanks
>> Gang
>>
>>
>> >>>
>> > Dear OCFS2 guys,
>> >
>> >
>> >
>> > My name is Guy, and I'm testing ocfs2 due to its features as a clustered
>> > filesystem that I need.
>> >
>> > As part of the stability and reliability test I?ve performed, I've
>> > encountered an issue with ocfs2 (format + mount + remove disk...), that I
>> > wanted to make sure it is a real issue and not just a mis-configuration.
>> >
>> >
>> >
>> > The main concern is that the stability of the whole system is compromised
>> > when a single disk/volumes fails. It looks like the OCFS2 is not handling
>> > the error correctly but stuck in an endless loop that interferes with the
>> > work of the server.
>> >
>> >
>> >
>> > I?ve test tested two cluster configurations ? (1) Corosync/Pacemaker and
>> > (2) o2cb that react similarly.
>> >
>> > Following the process and log entries:
>> >
>> >
>> > Also below additional configuration that were tested.
>> >
>> >
>> > Node 1:
>> >
>> > =======
>> >
>> > 1. service corosync start
>> >
>> > 2. service dlm start
>> >
>> > 3. mkfs.ocfs2 -v -Jblock64 -b 4096 --fs-feature-level=max-features
>> > --cluster-=pcmk --cluster-name=cluster-name -N 2 /dev/<path to device>
>> >
>> > 4. mount -o
>> > rw,noatime,nodiratime,data=writeback,heartbeat=none,cluster_stack=pcmk
>> > /dev/<path to device> /mnt/ocfs2-mountpoint
>> >
>> >
>> >
>> > Node 2:
>> >
>> > =======
>> >
>> > 5. service corosync start
>> >
>> > 6. service dlm start
>> >
>> > 7. mount -o
>> > rw,noatime,nodiratime,data=writeback,heartbeat=none,cluster_stack=pcmk
>> > /dev/<path to device> /mnt/ocfs2-mountpoint
>> >
>> >
>> >
>> > So far all is working well, including reading and writing.
>> >
>> > Next
>> >
>> > 8. I?ve physically, pull out the disk at /dev/<path to device> to
>> simulate
>> > a hardware failure (that may occur?) , in real life the disk is (hardware
>> > or software) protected. Nonetheless, I?m testing a hardware failure that
>> > the one of the OCFS2 file systems in my server fails.
>> >
>> > Following  - messages observed in the system log (see below) and
>> >
>> > ==>  9. kernel panic(!) ... in one of the nodes or on both, or reboot on
>> > one of the nodes or both.
>> >
>> >
>> > Is there any configuration or set of parameters that will enable the
>> system
>> > to continue working, disabling the access to the failed disk without
>> > compromising the system stability and not cause the kernel to panic?!
>> >
>> >
>> >
>> >>From my point of view it looks basics ? when a hardware failure occurs:
>> >
>> > 1. All remaining hardware should continue working
>> >
>> > 2. The failed disk/volume should be inaccessible ? but not compromise the
>> > whole system availability (Kernel panic).
>> >
>> > 3. OCFS2 ?understands? there?s a failed disk and stop trying to access
>> it.
>> >
>> > 3. All disk commands such as mount/umount, df etc. should continue
>> working.
>> >
>> > 4. When a new/replacement drive is connected to the system, it can be
>> > accessed.
>> >
>> > My settings:
>> >
>> > ubuntu 14.04
>> >
>> > linux:  3.16.0-46-generic
>> >
>> > mkfs.ocfs2 1.8.4 (downloaded from git)
>> >
>> >
>> >
>> >
>> >
>> > Some other scenarios which also were tested:
>> >
>> > 1. Remove the max-features in the mkfs (i.e. mkfs.ocfs2 -v -Jblock64 -b
>> > 4096 --cluster-stack=pcmk --cluster-name=cluster-name -N 2 /dev/<path to
>> > device>)
>> >
>> > This improved in some of the cases with no kernel panic but still the
>> > stability of the system was compromised, the syslog indicates that
>> > something unrecoverable is going on (See below - Appendix A1).
>> Furthermore,
>> > System is hanging when trying to software reboot.
>> >
>> > 2. Also tried with the o2cb stack, with similar outcomes.
>> >
>> > 3. The configuration was also tested with (1,2 and
