From: Eric Ren <zren@suse.com>
Date: Thu, 7 Jan 2016 13:03:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Do not lock/unlock() inode DLM lock
In-Reply-To: <5683B274020000F900023B30@relay2.provo.novell.com>
References: <1451413209-26406-1-git-send-email-rgoldwyn@suse.de>
	<5683B274020000F900023B30@relay2.provo.novell.com>
Message-ID: <20160107050316.GA22340@desktop.lab.bej.apac.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Tue, Dec 29, 2015 at 07:31:16PM -0700, He Gang wrote: 
> Hello Goldwyn,
> 
> When read path can't get the DLM lock immediately (NONBLOCK way), next get the lock with BLOCK way, this behavior will cost some time (several msecs).
> It looks make sense to delete that two line code. 
> But why there are two line code existed? I just worry about, if we delete two line code, when read path can't get the DLM lock with NONBLOCK way, read path will retry to get this DLM lock repeatedly, this will lead to cost too much CPU (Not waiting in sleep).
> I just worry about this possibility, Eric will test this case, and give a feedback.
Sorry for the late reply. After applying this patch, the performance is improved very much,
but "soft lockup" occurred several times(log message is placed at the end). The two lines:

       if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
           ocfs2_inode_unlock(inode, ex);

is similar with the lines of this commit:

commit c7e25e6e0b0486492c5faaf6312b37413642c48e
Author: Jan Kara <jack@suse.cz>
Date:   Thu Jun 23 22:51:47 2011 +0200

    ocfs2: Avoid livelock in ocfs2_readpage()
    
    When someone writes to an inode, readers accessing the same inode via
    ocfs2_readpage() just busyloop trying to get ip_alloc_sem because
    do_generic_file_read() looks up the page again and retries ->readpage()
    when previous attempt failed with AOP_TRUNCATED_PAGE. When there are enough
    readers, they can occupy all CPUs and in non-preempt kernel the system is
    deadlocked because writer holding ip_alloc_sem is never run to release the
    semaphore. Fix the problem by making reader block on ip_alloc_sem to break
    the busy loop.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Joel Becker <jlbec@evilplan.org>
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4c1ec8f..ba3ca1e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -290,7 +290,15 @@ static int ocfs2_readpage(struct file *file, struct page *page)
        }
 
        if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
+               /*
+                * Unlock the page and cycle ip_alloc_sem so that we don't
+                * busyloop waiting for ip_alloc_sem to unlock
+                */
                ret = AOP_TRUNCATED_PAGE;
+               unlock_page(page);
+               unlock = 0;
+               down_read(&oi->ip_alloc_sem);
+               up_read(&oi->ip_alloc_sem);
                goto out_inode_unlock;
        }

So, this patch removing the two lines of code may result in "busy wait" potentially that
reading thread repeatedly checks to see if cluster lock is available. Please correct me if
I'm wrong. 

This is the "soft lookup" log:
Dec 30 17:30:40 n2 kernel: [  248.084012] BUG: soft lockup - CPU#3 stuck for 23s! [iomaker:4061]
Dec 30 17:30:40 n2 kernel: [  248.084015] Modules linked in: ocfs2(FN) jbd2 ocfs2_nodemanager(F) quota_tree ocfs2_stack_user(FN) ocfs2_stackglue(FN) dlm(F) sctp libcrc32c configfs edd sg sd_mod crc_t10dif crc32c iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi af_packet mperf fuse loop dm_mod ipv6 ipv6_lib 8139too pcspkr acpiphp rtc_cmos pci_hotplug floppy 8139cp button i2c_piix4 mii virtio_balloon ext3 jbd mbcache ttm drm_kms_helper drm i2c_core sysimgblt sysfillrect syscopyarea uhci_hcd ehci_hcd processor thermal_sys hwmon usbcore usb_common intel_agp intel_gtt scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac scsi_dh virtio_pci ata_generic ata_piix libata scsi_mod virtio_blk virtio virtio_ring
Dec 30 17:30:40 n2 kernel: [  248.084049] Supported: No, Unsupported modules are loaded
Dec 30 17:30:40 n2 kernel: [  248.084050] CPU 3 
Dec 30 17:30:40 n2 kernel: [  248.084051] Modules linked in: ocfs2(FN) jbd2 ocfs2_nodemanager(F) quota_tree ocfs2_stack_user(FN) ocfs2_stackglue(FN) dlm(F) sctp libcrc32c configfs edd sg sd_mod crc_t10dif crc32c iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi af_packet mperf fuse loop dm_mod ipv6 ipv6_lib 8139too pcspkr acpiphp rtc_cmos pci_hotplug floppy 8139cp button i2c_piix4 mii virtio_balloon ext3 jbd mbcache ttm drm_kms_helper drm i2c_core sysimgblt sysfillrect syscopyarea uhci_hcd ehci_hcd processor thermal_sys hwmon usbcore usb_common intel_agp intel_gtt scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac scsi_dh virtio_pci ata_generic ata_piix libata scsi_mod virtio_blk virtio virtio_ring
Dec 30 17:30:40 n2 kernel: [  248.084074] Supported: No, Unsupported modules are loaded
Dec 30 17:30:40 n2 kernel: [  248.084075] 
Dec 30 17:30:40 n2 kernel: [  248.084077] Pid: 4061, comm: iomaker Tainted: GF          N  3.0.76-0.11-default #1 Bochs Bochs
Dec 30 17:30:40 n2 kernel: [  248.084080] RIP: 0010:[<ffffffff8145c7a9>]  [<ffffffff8145c7a9>] _raw_spin_lock+0x9/0x20
Dec 30 17:30:40 n2 kernel: [  248.084087] RSP: 0018:ffff8800db3fbb10  EFLAGS: 00000206
Dec 30 17:30:40 n2 kernel: [  248.084088] RAX: 0000000071967196 RBX: ffff880114c1c000 RCX: 0000000000000004
Dec 30 17:30:40 n2 kernel: [  248.084090] RDX: 0000000000007195 RSI: 0000000000000000 RDI: ffff880114c1c0d0
Dec 30 17:30:40 n2 kernel: [  248.084091] RBP: ffff880114c1c0d0 R08: 0000000000000000 R09: 0000000000000003
Dec 30 17:30:40 n2 kernel: [  248.084092] R10: 0000000000000100 R11: 0000000000014819 R12: ffffffff81464f6e
Dec 30 17:30:40 n2 kernel: [  248.084094] R13: ffff880037b34908 R14: ffff880037b342c0 R15: ffff880037b34908
Dec 30 17:30:40 n2 kernel: [  248.084096] FS:  00007fdbe0f7a720(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
Dec 30 17:30:40 n2 kernel: [  248.084097] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 30 17:30:40 n2 kernel: [  248.084099] CR2: 00007ff1df54b000 CR3: 00000000db2da000 CR4: 00000000000006e0
Dec 30 17:30:40 n2 kernel: [  248.084103] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 30 17:30:40 n2 kernel: [  248.084106] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 30 17:30:40 n2 kernel: [  248.084108] Process iomaker (pid: 4061, threadinfo ffff8800db3fa000, task ffff880037b342c0)
Dec 30 17:30:40 n2 kernel: [  248.084109] Stack:
Dec 30 17:30:40 n2 kernel: [  248.084112]  ffffffffa04ab9b5 0000000000000000 00000039c2f58103 0000000000000000
Dec 30 17:30:40 n2 kernel: [  248.084115]  0000000000000000 ffff880114c1c0d0 ffff880114c1c0d0 ffff880114c1c0d0
Dec 30 17:30:40 n2 kernel: [  248.084117]  0000000000000000 ffff880114c1c000 ffff8800dba0ec38 0000000000000004
Dec 30 17:30:40 n2 kernel: [  248.084120] Call Trace:
Dec 30 17:30:40 n2 kernel: [  248.084145]  [<ffffffffa04ab9b5>] ocfs2_wait_for_recovery+0x25/0xc0 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084182]  [<ffffffffa049aed8>] ocfs2_inode_lock_full_nested+0x298/0x510 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084204]  [<ffffffffa049b161>] ocfs2_inode_lock_with_page+0x11/0x40 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084225]  [<ffffffffa048170f>] ocfs2_readpage+0x8f/0x210 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084234]  [<ffffffff810f938e>] do_generic_file_read+0x13e/0x490
Dec 30 17:30:40 n2 kernel: [  248.084238]  [<ffffffff810f9d3c>] generic_file_aio_read+0xfc/0x260
Dec 30 17:30:40 n2 kernel: [  248.084250]  [<ffffffffa04a168b>] ocfs2_file_aio_read+0x14b/0x390 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084265]  [<ffffffff811584b8>] do_sync_read+0xc8/0x110
Dec 30 17:30:40 n2 kernel: [  248.084268]  [<ffffffff81158c67>] vfs_read+0xc7/0x130
Dec 30 17:30:40 n2 kernel: [  248.084271]  [<ffffffff81158dd3>] sys_read+0x53/0xa0
Dec 30 17:30:40 n2 kernel: [  248.084275]  [<ffffffff81464592>] system_call_fastpath+0x16/0x1b
Dec 30 17:30:40 n2 kernel: [  248.084280]  [<00007fdbe03532a0>] 0x7fdbe035329f
Dec 30 17:30:40 n2 kernel: [  248.084281] Code: 00 75 04 f0 0f b1 17 0f 94 c2 0f b6 c2 85 c0 ba 01 00 00 00 75 02 31 d2 89 d0 c3 0f 1f 80 00 00 00 00 b8 00 00 01 00 f0 0f c1 07 <0f> b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5 c3 0f 1f 44 
Dec 30 17:30:40 n2 kernel: [  248.084307] Call Trace:
Dec 30 17:30:40 n2 kernel: [  248.084319]  [<ffffffffa04ab9b5>] ocfs2_wait_for_recovery+0x25/0xc0 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084344]  [<ffffffffa049aed8>] ocfs2_inode_lock_full_nested+0x298/0x510 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084366]  [<ffffffffa049b161>] ocfs2_inode_lock_with_page+0x11/0x40 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084386]  [<ffffffffa048170f>] ocfs2_readpage+0x8f/0x210 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084394]  [<ffffffff810f938e>] do_generic_file_read+0x13e/0x490
Dec 30 17:30:40 n2 kernel: [  248.084397]  [<ffffffff810f9d3c>] generic_file_aio_read+0xfc/0x260
Dec 30 17:30:40 n2 kernel: [  248.084409]  [<ffffffffa04a168b>] ocfs2_file_aio_read+0x14b/0x390 [ocfs2]
Dec 30 17:30:40 n2 kernel: [  248.084423]  [<ffffffff811584b8>] do_sync_read+0xc8/0x110
Dec 30 17:30:40 n2 kernel: [  248.084426]  [<ffffffff81158c67>] vfs_read+0xc7/0x130
Dec 30 17:30:40 n2 kernel: [  248.084429]  [<ffffffff81158dd3>] sys_read+0x53/0xa0
Dec 30 17:30:40 n2 kernel: [  248.084431]  [<ffffffff81464592>] system_call_fastpath+0x16/0x1b
Dec 30 17:30:40 n2 kernel: [  248.084435]  [<00007fdbe03532a0>] 0x7fdbe035329f

Thanks,
Eric

> 
> Thanks
> Gang   
> 
> 
> >>> 
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > DLM does not cache locks. So, blocking lock and unlock
> > will only make the performance worse where contention over
> > the locks is high.
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/ocfs2/dlmglue.c | 8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> > index 20276e3..f92612e 100644
> > --- a/fs/ocfs2/dlmglue.c
> > +++ b/fs/ocfs2/dlmglue.c
> > @@ -2432,12 +2432,6 @@ bail:
> >   * done this we have to return AOP_TRUNCATED_PAGE so the aop method
> >   * that called us can bubble that back up into the VFS who will then
> >   * immediately retry the aop call.
> > - *
> > - * We do a blocking lock and immediate unlock before returning, though, so 
> > that
> > - * the lock has a great chance of being cached on this node by the time the 
> > VFS
> > - * calls back to retry the aop.    This has a potential to livelock as nodes
> > - * ping locks back and forth, but that's a risk we're willing to take to 
> > avoid
> > - * the lock inversion simply.
> >   */
> >  int ocfs2_inode_lock_with_page(struct inode *inode,
> >  			      struct buffer_head **ret_bh,
> > @@ -2449,8 +2443,6 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
> >  	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
> >  	if (ret == -EAGAIN) {
> >  		unlock_page(page);
> > -		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
> > -			ocfs2_inode_unlock(inode, ex);
> >  		ret = AOP_TRUNCATED_PAGE;
> >  	}
> >  
> > -- 
> > 2.6.2
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
