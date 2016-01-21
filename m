From: Guy 2212112 <guy2212112@gmail.com>
Date: Thu, 21 Jan 2016 19:46:00 +0200
Subject: [Ocfs2-devel] OCFS2 causing system instability
In-Reply-To: <569F4A74.4020309@oracle.com>
References: <CAPtxBQiObC2yHcQvjzFstD_A-yf9ORjsgWN0sr2-nLpTDBcFFg@mail.gmail.com>
	<569F4A74.4020309@oracle.com>
Message-ID: <CAPtxBQgV5JDB5EZwj_2now3EjHAhX6joP7DPUGa=XoZpChaP-g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
First, I'm well aware that OCFS2 is not a distributed file system, but a
shared, clustered file system. This is the main reason that I want to use
it - access the same filesystem from multiple nodes.
I've checked the latest Kernel 4.4 release that include the
"errors=continue" option and installed also (manually) the patch described
in this thread - "[PATCH V2] ocfs2: call ocfs2_abort when journal abort" .

Unfortunately the issues I've described where not solved.

Also, I understand that OCFS2 relies on the SAN availability and is not
replicating the data to other locations (like a distributed file system),
so I don't expect to be able to access the data when a disk/volume is not
accessible (for example because of hardware failure).

In other filesystems, clustered or even local, when a disk/volume fails -
this and only this disk/volume cannot be accessed - and all the other
filesystems continue to function and can accessed and the whole system
stability is definitely not compromised.

Of course, I can understand that if this specific disk/volume contains the
operating system it probably cause a  panic/reboot, or if the disk/volume
is used by the cluster as heartbeat, it may influence the whole cluster -
if it's the only way the nodes in the cluster are using to communicate
between themselves.

The configuration I use rely on Global heartbeat on three different
dedicated disks and the "simulated error" is on an additional,fourth disk
that doesn't include a heartbeat.

Errors may occur on storage arrays and if I'm connecting my OCFS2 cluster
to 4 storage arrays with each 10 disks/volumes, I don't expect that the
whole OCFS2 cluster will fail when only one array is down. I still expect
that the other 30 disks from the other 3 remaining arrays will continue
working.
Of course, I will not have any access to the failed array disks.

I hope this describes better the situation,

Thanks,

Guy

On Wed, Jan 20, 2016 at 10:51 AM, Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Guy,
>
> ocfs2 is shared-disk fs, there is no way to do replication like dfs,
> also no volume manager integrated in ocfs2. Ocfs2 depends on underlying
> storage stack to handler disk failure, so you can configure multipath,
> raid or storage to handle removing disk issue. If io error is still
> reported to ocfs2, then there is no way to workaround, ocfs2 will be set
> read-only or even panic to avoid fs corruption. This is the same
> behavior with local fs.
> If io error not reported to ocfs2, then there is a fix i just posted to
> ocfs2-devel to avoid the node panic, please try patch serial [ocfs2:
> o2hb: not fence self if storage down]. Note this is only useful to o2cb
> stack. Nodes will hung on io and wait storage online again.
>
> For the endless loop you met in "Appendix A1", it is a bug and fixed by
> "[PATCH V2] ocfs2: call ocfs2_abort when journal abort", you can get it
> from ocfs2-devel. This patch will set fs readonly or panic node since io
> error have been reported to ocfs2.
>
> Thanks,
> Junxiao.
>
> On 01/20/2016 03:19 AM, Guy 1234 wrote:
> > Dear OCFS2 guys,
> >
> >
> >
> > My name is Guy, and I'm testing ocfs2 due to its features as a clustered
> > filesystem that I need.
> >
> > As part of the stability and reliability test I?ve performed, I've
> > encountered an issue with ocfs2 (format + mount + remove disk...), that
> > I wanted to make sure it is a real issue and not just a
> mis-configuration.
> >
> >
> >
> > The main concern is that the stability of the whole system is
> > compromised when a single disk/volumes fails. It looks like the OCFS2 is
> > not handling the error correctly but stuck in an endless loop that
> > interferes with the work of the server.
> >
> >
> >
> > I?ve test tested two cluster configurations ? (1) Corosync/Pacemaker and
> > (2) o2cb that react similarly.
> >
> > Following the process and log entries:
> >
> >
> > Also below additional configuration that were tested.
> >
> >
> > Node 1:
> >
> > =======
> >
> > 1. service corosync start
> >
> > 2. service dlm start
> >
> > 3. mkfs.ocfs2 -v -Jblock64 -b 4096 --fs-feature-level=max-features
> > --cluster-=pcmk --cluster-name=cluster-name -N 2 /dev/<path to device>
> >
> > 4. mount -o
> > rw,noatime,nodiratime,data=writeback,heartbeat=none,cluster_stack=pcmk
> > /dev/<path to device> /mnt/ocfs2-mountpoint
> >
> >
> >
> > Node 2:
> >
> > =======
> >
> > 5. service corosync start
> >
> > 6. service dlm start
> >
> > 7. mount -o
> > rw,noatime,nodiratime,data=writeback,heartbeat=none,cluster_stack=pcmk
> > /dev/<path to device> /mnt/ocfs2-mountpoint
> >
> >
> >
> > So far all is working well, including reading and writing.
> >
> > Next
> >
> > 8. I?ve physically, pull out the disk at /dev/<path to device> to
> > simulate a hardware failure (that may occur?) , in real life the disk is
> > (hardware or software) protected. Nonetheless, I?m testing a hardware
> > failure that the one of the OCFS2 file systems in my server fails.
> >
> > Following  - messages observed in the system log (see below) and
> >
> > ==>  9. kernel panic(!) ... in one of the nodes or on both, or reboot on
> > one of the nodes or both.
> >
> >
> > Is there any configuration or set of parameters that will enable the
> > system to continue working, disabling the access to the failed disk
> > without compromising the system stability and not cause the kernel to
> > panic?!
> >
> >
> >
> > From my point of view it looks basics ? when a hardware failure occurs:
> >
> > 1. All remaining hardware should continue working
> >
> > 2. The failed disk/volume should be inaccessible ? but not compromise
> > the whole system availability (Kernel panic).
> >
> > 3. OCFS2 ?understands? there?s a failed disk and stop trying to access
> it.
> >
> > 3. All disk commands such as mount/umount, df etc. should continue
> working.
> >
> > 4. When a new/replacement drive is connected to the system, it can be
> > accessed.
> >
> > My settings:
> >
> > ubuntu 14.04
> >
> > linux:  3.16.0-46-generic
> >
> > mkfs.ocfs2 1.8.4 (downloaded from git)
> >
> >
> >
> >
> >
> > Some other scenarios which also were tested:
> >
> > 1. Remove the max-features in the mkfs (i.e. mkfs.ocfs2 -v -Jblock64 -b
> > 4096 --cluster-stack=pcmk --cluster-name=cluster-name -N 2 /dev/<path to
> > device>)
> >
> > This improved in some of the cases with no kernel panic but still the
> > stability of the system was compromised, the syslog indicates that
> > something unrecoverable is going on (See below - Appendix A1).
> > Furthermore, System is hanging when trying to software reboot.
> >
> > 2. Also tried with the o2cb stack, with similar outcomes.
> >
> > 3. The configuration was also tested with (1,2 and 3) Local and Global
> > heartbeat(s) that were NOT on the simulated failed disk, but on other
> > physical disks.
> >
> > 4. Also tested:
> >
> > Ubuntu 15.15
> >
> > Kernel: 4.2.0-23-generic
> >
> > mkfs.ocfs2 1.8.4 (git clone git://oss.oracle.com/git/ocfs2-tools.git
> > <http://oss.oracle.com/git/ocfs2-tools.git>)
> >
> >
> >
> >
> >
> > ==============
> >
> > Appendix A1:
> >
> > ==============
> >
> > from syslog:
> >
> > [ 1676.608123] (ocfs2cmt,5316,14):ocfs2_commit_thread:2195 ERROR: status
> > = -5, journal is already aborted.
> >
> > [ 1677.611827] (ocfs2cmt,5316,14):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1678.616634] (ocfs2cmt,5316,15):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1679.621419] (ocfs2cmt,5316,15):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1680.626175] (ocfs2cmt,5316,15):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1681.630981] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1682.107356] INFO: task kworker/u64:0:6 blocked for more than 120
> seconds.
> >
> > [ 1682.108440]       Not tainted 3.16.0-46-generic #62~14.04.1
> >
> > [ 1682.109388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> >
> > [ 1682.110381] kworker/u64:0   D ffff88103fcb30c0     0     6      2
> > 0x00000000
> >
> > [ 1682.110401] Workqueue: fw_event0 _firmware_event_work [mpt3sas]
> >
> > [ 1682.110405]  ffff88102910b8a0 0000000000000046 ffff88102977b2f0
> > 00000000000130c0
> >
> > [ 1682.110411]  ffff88102910bfd8 00000000000130c0 ffff88102928c750
> > ffff88201db284b0
> >
> > [ 1682.110415]  ffff88201db28000 ffff881028cef000 ffff88201db28138
> > ffff88201db28268
> >
> > [ 1682.110419] Call Trace:
> >
> > [ 1682.110427]  [<ffffffff8176a8b9>] schedule+0x29/0x70
> >
> > [ 1682.110458]  [<ffffffffc08d6c11>] ocfs2_clear_inode+0x3b1/0xa30
> [ocfs2]
> >
> > [ 1682.110464]  [<ffffffff810b4de0>] ? prepare_to_wait_event+0x100/0x100
> >
> > [ 1682.110487]  [<ffffffffc08d8c7e>] ocfs2_evict_inode+0x6e/0x730 [ocfs2]
> >
> > [ 1682.110493]  [<ffffffff811eee04>] evict+0xb4/0x180
> >
> > [ 1682.110498]  [<ffffffff811eef09>] dispose_list+0x39/0x50
> >
> > [ 1682.110501]  [<ffffffff811efdb4>] invalidate_inodes+0x134/0x150
> >
> > [ 1682.110506]  [<ffffffff8120a64a>] __invalidate_device+0x3a/0x60
> >
> > [ 1682.110510]  [<ffffffff81367e81>] invalidate_partition+0x31/0x50
> >
> > [ 1682.110513]  [<ffffffff81368f45>] del_gendisk+0xf5/0x290
> >
> > [ 1682.110519]  [<ffffffff815177a1>] sd_remove+0x61/0xc0
> >
> > [ 1682.110524]  [<ffffffff814baf7f>] __device_release_driver+0x7f/0xf0
> >
> > [ 1682.110529]  [<ffffffff814bb013>] device_release_driver+0x23/0x30
> >
> > [ 1682.110534]  [<ffffffff814ba918>] bus_remove_device+0x108/0x180
> >
> > [ 1682.110538]  [<ffffffff814b7169>] device_del+0x129/0x1c0
> >
> > [ 1682.110543]  [<ffffffff815123a5>] __scsi_remove_device+0xd5/0xe0
> >
> > [ 1682.110547]  [<ffffffff815123d6>] scsi_remove_device+0x26/0x40
> >
> > [ 1682.110551]  [<ffffffff81512590>] scsi_remove_target+0x170/0x230
> >
> > [ 1682.110561]  [<ffffffffc03551e5>] sas_rphy_remove+0x65/0x80
> > [scsi_transport_sas]
> >
> > [ 1682.110570]  [<ffffffffc035707d>] sas_port_delete+0x2d/0x170
> > [scsi_transport_sas]
> >
> > [ 1682.110575]  [<ffffffff8124a6f9>] ? sysfs_remove_link+0x19/0x30
> >
> > [ 1682.110588]  [<ffffffffc03f1599>]
> > mpt3sas_transport_port_remove+0x1c9/0x1e0 [mpt3sas]
> >
> > [ 1682.110598]  [<ffffffffc03e60b5>] _scsih_remove_device+0x55/0x80
> > [mpt3sas]
> >
> > [ 1682.110610]  [<ffffffffc03e6159>]
> > _scsih_device_remove_by_handle.part.21+0x79/0xa0 [mpt3sas]
> >
> > [ 1682.110619]  [<ffffffffc03eca97>] _firmware_event_work+0x1337/0x1690
> > [mpt3sas]
> >
> > [ 1682.110626]  [<ffffffff8101c315>] ? native_sched_clock+0x35/0x90
> >
> > [ 1682.110630]  [<ffffffff8101c379>] ? sched_clock+0x9/0x10
> >
> > [ 1682.110636]  [<ffffffff81011574>] ? __switch_to+0xe4/0x580
> >
> > [ 1682.110640]  [<ffffffff81087bc9>] ?
> pwq_activate_delayed_work+0x39/0x80
> >
> > [ 1682.110644]  [<ffffffff8108a302>] process_one_work+0x182/0x450
> >
> > [ 1682.110648]  [<ffffffff8108aa71>] worker_thread+0x121/0x570
> >
> > [ 1682.110652]  [<ffffffff8108a950>] ? rescuer_thread+0x380/0x380
> >
> > [ 1682.110657]  [<ffffffff81091309>] kthread+0xc9/0xe0
> >
> > [ 1682.110662]  [<ffffffff81091240>] ? kthread_create_on_node+0x1c0/0x1c0
> >
> > [ 1682.110667]  [<ffffffff8176e818>] ret_from_fork+0x58/0x90
> >
> > [ 1682.110672]  [<ffffffff81091240>] ? kthread_create_on_node+0x1c0/0x1c0
> >
> > [ 1682.635761] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1683.640549] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1684.645336] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1685.650114] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1686.654911] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1687.659684] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1688.664466] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1689.669252] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1690.674026] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1691.678810] (ocfs2cmt,5316,9):ocfs2_commit_cache:324 ERROR: status =
> -5
> >
> > [ 1691.679920] (ocfs2cmt,5316,9):ocfs2_commit_thread:2195 ERROR: status
> > = -5, journal is already aborted.
> >
> >
> >
> > Thanks in advance,
> >
> > Guy
> >
> >
> >
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160121/c6745955/attachment-0001.html 
