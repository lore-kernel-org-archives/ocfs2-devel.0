From: Jan Kara <jack@suse.cz>
Date: Wed, 17 Jan 2018 16:21:35 +0100
Subject: [Ocfs2-devel] [Ocfs2-dev] BUG: deadlock with umount and ocfs2
 workqueue triggered by ocfs2rec thread
In-Reply-To: <0044cc89-5cda-c4a9-5eb0-1e5d85416805@suse.com>
References: <D1E4D02760513D4B90DC3B40FF32AF35E22EC390@H3CMLB14-EX.srv.huawei-3com.com>
	<0044cc89-5cda-c4a9-5eb0-1e5d85416805@suse.com>
Message-ID: <20180117152135.nhiho7agzxige6xl@quack2.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

On Fri 12-01-18 16:25:56, Eric Ren wrote:
> On 01/12/2018 11:43 AM, Shichangkuo wrote:
> > Hi all,
> > ??Now we are testing ocfs2 with 4.14 kernel, and we finding a deadlock with umount and ocfs2 workqueue triggered by ocfs2rec thread. The stack as follows:
> > journal recovery work:
> > [<ffffffff8a8c0694>] call_rwsem_down_read_failed+0x14/0x30
> > [<ffffffffc0d5d652>] ocfs2_finish_quota_recovery+0x62/0x450 [ocfs2]
> > [<ffffffffc0d21221>] ocfs2_complete_recovery+0xc1/0x440 [ocfs2]
> > [<ffffffff8a09a1f0>] process_one_work+0x130/0x350
> > [<ffffffff8a09a946>] worker_thread+0x46/0x3b0
> > [<ffffffff8a0a0e51>] kthread+0x101/0x140
> > [<ffffffff8aa002ff>] ret_from_fork+0x1f/0x30
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > /bin/umount:
> > [<ffffffff8a099b24>] flush_workqueue+0x104/0x3e0
> > [<ffffffffc0cf18db>] ocfs2_truncate_log_shutdown+0x3b/0xc0 [ocfs2]
> > [<ffffffffc0d4fd6c>] ocfs2_dismount_volume+0x8c/0x3d0 [ocfs2]
> > [<ffffffffc0d500e1>] ocfs2_put_super+0x31/0xa0 [ocfs2]
> > [<ffffffff8a2445bd>] generic_shutdown_super+0x6d/0x120
> > [<ffffffff8a24469d>] kill_block_super+0x2d/0x60
> > [<ffffffff8a244e71>] deactivate_locked_super+0x51/0x90
> > [<ffffffff8a263a1b>] cleanup_mnt+0x3b/0x70
> > [<ffffffff8a09e9c6>] task_work_run+0x86/0xa0
> > [<ffffffff8a003d70>] exit_to_usermode_loop+0x6d/0xa9
> > [<ffffffff8a003a2d>] do_syscall_64+0x11d/0x130
> > [<ffffffff8aa00113>] entry_SYSCALL64_slow_path+0x25/0x25
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > ??
> > Function ocfs2_finish_quota_recovery try to get sb->s_umount, which was already locked by umount thread, then get a deadlock.
> 
> Good catch, thanks for reporting.? Is it reproducible? Can you please share
> the steps for reproducing this issue?
> > This issue was introduced by c3b004460d77bf3f980d877be539016f2df4df12 and 5f530de63cfc6ca8571cbdf58af63fb166cc6517.
> > I think we cannot use :: s_umount, but the mutex ::dqonoff_mutex was already removed.
> > Shall we add a new mutex?
> 
> @Jan, I don't look into the code yet, could you help me understand why we
> need to get sb->s_umount in ocfs2_finish_quota_recovery?
> Is it because that the quota recovery process will start at umounting? or
> some where else?

I was refreshing my memory wrt how ocfs2 quota recovery works. The problem
is the following: We load information about all quota information that
needs recovering (this is possibly for other nodes) in
ocfs2_begin_quota_recovery() that gets called during mount. Real quota
recovery happens from the recovery thread in ocfs2_finish_quota_recovery().
We need to protect code running there from dquot_disable() calls as that
will free structures we use for updating quota information etc. Currently
we use sb->s_umount for that protection.

The problem above apparently happens when someone calls umount before the
recovery thread can finish quota recovery. I will think more about how to
fix the locking so that this lock inversion does not happen...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
