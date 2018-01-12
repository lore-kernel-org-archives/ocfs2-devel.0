From: Shichangkuo <shi.changkuo@h3c.com>
Date: Fri, 12 Jan 2018 06:15:01 +0000
Subject: [Ocfs2-devel] [Ocfs2-dev] BUG: deadlock with umount and ocfs2
 workqueue triggered by ocfs2rec thread
In-Reply-To: <784f7cc8-8899-97dd-94ee-bcc16f4415d9@gmail.com>
References: <D1E4D02760513D4B90DC3B40FF32AF35E22EC390@H3CMLB14-EX.srv.huawei-3com.com>
	<784f7cc8-8899-97dd-94ee-bcc16f4415d9@gmail.com>
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF35E22EC513@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph
    Thanks for replying.
    Umount will flush the ocfs2 workqueue in function ocfs2_truncate_log_shutdown and journal recovery is one work of ocfs2 wq.

Thanks
Changkuo

> -----Original Message-----
> From: Joseph Qi [mailto:jiangqi903 at gmail.com]
> Sent: Friday, January 12, 2018 1:51 PM
> To: shichangkuo (Cloud); zren at suse.com; jack at suse.cz
> Cc: ocfs2-devel at oss.oracle.com
> Subject: Re: [Ocfs2-devel] [Ocfs2-dev] BUG: deadlock with umount and ocfs2
> workqueue triggered by ocfs2rec thread
> 
> Hi Changkuo,
> 
> You said s_umount was acquired by umount and ocfs2rec was blocked when
> acquiring it. But you didn't describe why umount was blocked.
> 
> Thanks,
> Joseph
> 
> On 18/1/12 11:43, Shichangkuo wrote:
> > Hi all,
> > ??Now we are testing ocfs2 with 4.14 kernel, and we finding a deadlock
> with umount and ocfs2 workqueue triggered by ocfs2rec thread. The stack as
> follows:
> > journal recovery work:
> > [<ffffffff8a8c0694>] call_rwsem_down_read_failed+0x14/0x30
> > [<ffffffffc0d5d652>] ocfs2_finish_quota_recovery+0x62/0x450 [ocfs2]
> > [<ffffffffc0d21221>] ocfs2_complete_recovery+0xc1/0x440 [ocfs2]
> > [<ffffffff8a09a1f0>] process_one_work+0x130/0x350 [<ffffffff8a09a946>]
> > worker_thread+0x46/0x3b0 [<ffffffff8a0a0e51>] kthread+0x101/0x140
> > [<ffffffff8aa002ff>] ret_from_fork+0x1f/0x30 [<ffffffffffffffff>]
> > 0xffffffffffffffff
> >
> > /bin/umount:
> > [<ffffffff8a099b24>] flush_workqueue+0x104/0x3e0 [<ffffffffc0cf18db>]
> > ocfs2_truncate_log_shutdown+0x3b/0xc0 [ocfs2] [<ffffffffc0d4fd6c>]
> > ocfs2_dismount_volume+0x8c/0x3d0 [ocfs2] [<ffffffffc0d500e1>]
> > ocfs2_put_super+0x31/0xa0 [ocfs2] [<ffffffff8a2445bd>]
> > generic_shutdown_super+0x6d/0x120 [<ffffffff8a24469d>]
> > kill_block_super+0x2d/0x60 [<ffffffff8a244e71>]
> > deactivate_locked_super+0x51/0x90 [<ffffffff8a263a1b>]
> > cleanup_mnt+0x3b/0x70 [<ffffffff8a09e9c6>] task_work_run+0x86/0xa0
> > [<ffffffff8a003d70>] exit_to_usermode_loop+0x6d/0xa9
> > [<ffffffff8a003a2d>] do_syscall_64+0x11d/0x130 [<ffffffff8aa00113>]
> > entry_SYSCALL64_slow_path+0x25/0x25
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > Function ocfs2_finish_quota_recovery try to get sb->s_umount, which was
> already locked by umount thread, then get a deadlock.
> > This issue was introduced by
> c3b004460d77bf3f980d877be539016f2df4df12 and
> 5f530de63cfc6ca8571cbdf58af63fb166cc6517.
> > I think we cannot use :: s_umount, but the mutex ::dqonoff_mutex was
> already removed.
> > Shall we add a new mutex?
> >
> > Thanks
> > Changkuo
> > ----------------------------------------------------------------------
> > ---------------------------------------------------------------
> > ???????????????????????????????
> ??????
> > ???????????????????????????????
> ?????????
> > ???????????????????????????????
> ?????????
> > ???
> > This e-mail and its attachments contain confidential information from
> > New H3C, which is intended only for the person or entity whose address
> > is listed above. Any use of the information contained herein in any
> > way (including, but not limited to, total or partial disclosure,
> > reproduction, or dissemination) by persons other than the intended
> > recipient(s) is prohibited. If you receive this e-mail in error,
> > please notify the sender by phone or email immediately and delete it!
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
