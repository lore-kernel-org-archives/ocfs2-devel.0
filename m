From: xiaowei hu <xiaowei.hu@oracle.com>
Date: Tue, 22 Mar 2011 09:09:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Fix a potential piece of code that
 may induce kernel bug.
In-Reply-To: <1299563136.1677.59.camel@redfuture-desktop>
References: <1299562327-21019-1-git-send-email-xiaowei.hu@oracle.com>
	<1299563136.1677.59.camel@redfuture-desktop>
Message-ID: <1300756154.1677.456.camel@redfuture-desktop>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil, could you please review this patch? One CT is waiting for this
response:)

Thanks,
Xiaowei


On Tue, 2011-03-08 at 13:45 +0800, xiaowei hu wrote:
> sorry for some mistakes in this message, please use this description:
> 
> 
> In function dlm_migrate_lockres, it calls dlm_add_migration_mle() before
> the dlm_mark_lockres_migrating() ,this dlm_mark_lockres_migrating()
> should make sure the lockres is not dirty ,if it is dirty wait until it
> becomes undirty, and then mark this lockres as migrating. But the
> dlm_add_migration_mle() doesn't check this dirty flag , it just adds the
> mle with migrate type, this could have problem, if the migrate target
> dean at this point then another node becames the recovery master,
> current node will migrate this lockres to the recovery master ,no matter
> if it is in the dirty list.So this makes the lockres in the dirty lists
> but this owner becomes the recovery master, then panic.
> 
> This fix is for oracle bug10376468. Please refer to this bug.
> Here comes the panic stack:
> Kernel BUG at ...mushran/BUILD/ocfs2-1.4.4/fs/ocfs2/dlm/dlmthread.c:684 
> invalid opcode: 0000 [1] SMP 
> last sysfs file: /devices/pci0000:00/0000:00:00.0/irq 
> CPU 13 
> Modules linked in: hangcheck_timer mptctl mptbase ipmi_devintf ipmi_si 
> ipmi_msghandler netconsole ocfs2(U) ocfs2_dlmfs(U) ocfs2_dlm(U) 
> ocfs2_nodemanager(U) configfs bonding dm_mirror dm_round_robin
> dm_multipath dm_mod video sbs backlight i2c_ec i2c_core button battery
> asus_acpi acpi_memhotplug ac parport_pc lp parport ide_cd sg shpchp
> cdrom pcspkr serio_raw bnx2 e1000e lpfc scsi_transport_fc ata_piix
> libata cciss sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd 
> Pid: 10852, comm: dlm_thread Tainted: G      2.6.18-92.el5 #1 
> RIP: 0010:[<ffffffff8839d055>]  [<ffffffff8839d055>] 
> :ocfs2_dlm:dlm_thread+0x1b8/0xdcc 
> RSP: 0018:ffff810823813e70  EFLAGS: 00010297 
> RAX: 0000000000000004 RBX: ffff81080b0d59f0 RCX: ffffffff802ec9a8 
> RDX: ffffffff802ec9a8 RSI: 0000000000000000 RDI: ffffffff802ec9a0 
> RBP: ffff81080b0d59a8 R08: ffffffff802ec9a8 R09: 0000000000000046 
> R10: 0000000000000000 R11: 0000000000000280 R12: ffff81080b0d5940 
> R13: 0000000000000282 R14: ffff81082e094800 R15: ffffffff8009dbca 
> FS:  0000000000000000(0000) GS:ffff81082fcb1dc0(0000)
> knlGS:0000000000000000 
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
> CR2: 00002b71cee0d000 CR3: 0000000000201000 CR4: 00000000000006e0 
> Process dlm_thread (pid: 10852, threadinfo ffff810823812000, task 
> ffff81082dd3e820) 
> Stack:  ffff810823813eb0 0000000100000064 0000000000000000
> ffff81082dd3e820 
> ffffffff8009dde2 ffff810823813e98 ffff810823813e98 ffffffff8009dbca 
> ffff810823813ee0 ffff81082e094800 ffffffff8839ce9d ffff810827bb98b8 
> Call Trace: 
> [<ffffffff8009dde2>] autoremove_wake_function+0x0/0x2e 
> [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4 
> [<ffffffff8839ce9d>] :ocfs2_dlm:dlm_thread+0x0/0xdcc 
> [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4 
> [<ffffffff8003253d>] kthread+0xfe/0x132 
> [<ffffffff8005dfb1>] child_rip+0xa/0x11 
> [<ffffffff8009dbca>] keventd_create_kthread+0x0/0xc4 
> [<ffffffff8003243f>] kthread+0x0/0x132 
> [<ffffffff8005dfa7>] child_rip+0x0/0x11
> 
> Thanks
> Xiaowei
> 
> On Tue, 2011-03-08 at 13:32 +0800, xiaowei.hu at oracle.com wrote:
> > From: XiaoweiHu <xiaowei.hu@oracle.com>
> > 
> > In function dlm_migrate_lockres, it calls dlm_add_migration_mle() before 
> > the dlm_add_migration_mle() ,this dlm_add_migration_mle() should make sure 
> > the lockres is not dirty ,if it is dirty wait until it becomes undirty, 
> > and then mark this lockres as migrating. but the dlm_add_migration_mle() 
> > doesn't check this dirty flag , it just adds the mle with migrate type, 
> > this could have problem, if the migrate target dean at this point then 
> > another node becames the recovery master, current node will migrate this 
> > lockres to the recovery master ,no matter if it is in the dirty list.
> > So this makes the lockres in the dirty lists but this owner becomes the 
> > recovery master, then panic.
> > 
> > Signed-off-by: XiaoweiHu <xiaowei.hu@oracle.com>
> > Reviewed-by: WengangWang <wen.gang.wang@oracle.com>
> > ---
> >  fs/ocfs2/dlm/dlmmaster.c |   62 +++++++++++++++++++++++-----------------------
> >  1 files changed, 31 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> > index 59f0f6b..bdb2323 100644
> > --- a/fs/ocfs2/dlm/dlmmaster.c
> > +++ b/fs/ocfs2/dlm/dlmmaster.c
> > @@ -2402,6 +2402,16 @@ leave:
> >  	return ret;
> >  }
> >  
> > +static int dlm_lockres_is_dirty(struct dlm_ctxt *dlm,
> > +				struct dlm_lock_resource *res)
> > +{
> > +	int ret;
> > +	spin_lock(&res->spinlock);
> > +	ret = !!(res->state & DLM_LOCK_RES_DIRTY);
> > +	spin_unlock(&res->spinlock);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * DLM_MIGRATE_LOCKRES
> >   */
> > @@ -2463,6 +2473,20 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
> >  	}
> >  	ret = 0;
> >  
> > +	/* moved this out from dlm_mark_lockres_migrating,
> > +	 * to pervent the local recovery handler, migrate a dirty lockres.*/
> > +
> > +	/* now flush all the pending asts */
> > +	dlm_kick_thread(dlm, res);
> > +	/* before waiting on DIRTY, block processes which may
> > +	 * try to dirty the lockres before MIGRATING is set */
> > +	spin_lock(&res->spinlock);
> > +	BUG_ON(res->state & DLM_LOCK_RES_BLOCK_DIRTY);
> > +	res->state |= DLM_LOCK_RES_BLOCK_DIRTY;
> > +	spin_unlock(&res->spinlock);
> > +	/* now wait on any pending asts and the DIRTY state */
> > +	wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
> > +
> >  	/*
> >  	 * find a node to migrate the lockres to
> >  	 */
> > @@ -2521,6 +2545,13 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
> >  	}
> >  
> >  fail:
> > +	/* now no matter if it fails or not the block dirty state needs to
> > +	 * be cleared.*/
> > +	spin_lock(&res->spinlock);
> > +	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
> > +	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
> > +	spin_unlock(&res->spinlock);
> > +
> >  	if (oldmle) {
> >  		/* master is known, detach if not already detached */
> >  		dlm_mle_detach_hb_events(dlm, oldmle);
> > @@ -2748,16 +2779,6 @@ static int dlm_migration_can_proceed(struct dlm_ctxt *dlm,
> >  	return can_proceed;
> >  }
> >  
> > -static int dlm_lockres_is_dirty(struct dlm_ctxt *dlm,
> > -				struct dlm_lock_resource *res)
> > -{
> > -	int ret;
> > -	spin_lock(&res->spinlock);
> > -	ret = !!(res->state & DLM_LOCK_RES_DIRTY);
> > -	spin_unlock(&res->spinlock);
> > -	return ret;
> > -}
> > -
> >  
> >  static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
> >  				       struct dlm_lock_resource *res,
> > @@ -2778,16 +2799,6 @@ static int dlm_mark_lockres_migrating(struct dlm_ctxt *dlm,
> >  	__dlm_lockres_reserve_ast(res);
> >  	spin_unlock(&res->spinlock);
> >  
> > -	/* now flush all the pending asts */
> > -	dlm_kick_thread(dlm, res);
> > -	/* before waiting on DIRTY, block processes which may
> > -	 * try to dirty the lockres before MIGRATING is set */
> > -	spin_lock(&res->spinlock);
> > -	BUG_ON(res->state & DLM_LOCK_RES_BLOCK_DIRTY);
> > -	res->state |= DLM_LOCK_RES_BLOCK_DIRTY;
> > -	spin_unlock(&res->spinlock);
> > -	/* now wait on any pending asts and the DIRTY state */
> > -	wait_event(dlm->ast_wq, !dlm_lockres_is_dirty(dlm, res));
> >  	dlm_lockres_release_ast(dlm, res);
> >  
> >  	mlog(0, "about to wait on migration_wq, dirty=%s\n",
> > @@ -2823,17 +2834,6 @@ again:
> >  	}
> >  	spin_unlock(&dlm->spinlock);
> >  
> > -	/*
> > -	 * if target is down, we need to clear DLM_LOCK_RES_BLOCK_DIRTY for
> > -	 * another try; otherwise, we are sure the MIGRATING state is there,
> > -	 * drop the unneded state which blocked threads trying to DIRTY
> > -	 */
> > -	spin_lock(&res->spinlock);
> > -	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
> > -	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
> > -	if (!ret)
> > -		BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
> > -	spin_unlock(&res->spinlock);
> >  
> >  	/*
> >  	 * at this point:
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
