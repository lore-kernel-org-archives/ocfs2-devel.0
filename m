From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 09 Feb 2010 10:03:00 -0800
Subject: [Ocfs2-devel] ocfs2: Possible deadlock in dlm?
In-Reply-To: <1265705003-10501-1-git-send-email-tao.ma@oracle.com>
References: <1265705003-10501-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4B71A354.4010508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes. This was added via the following commit.

commit b0d4f817ba5de8adb875ace594554a96d7737710
Author: Sunil Mushran <sunil.mushran@oracle.com>
Date:   Tue Dec 16 15:49:22 2008 -0800

    ocfs2/dlm: Fix race in adding/removing lockres' to/from the tracking 
list

File a bugzilla. I'll get to this later.

Tao Ma wrote:
> Hi Sunil/Joel,
> 	I just got a lockdep warning today when I enable it to
> reflink check.
>
> So the question is that dlm_domain_lock and dlm->spinlock are
> spin_locked in different order.
>
> In dlm_run_purge_list, we lock dlm->spinlock first and then in
> dlm_lockres_release->dlm_put we lock dlm_domain_lock.
> While in dlm_mark_domain_leaving we use the reverse order.
>
> So is this a problem or these 2 scenarios can never happen together?
> I have attached the lockdep print below.
>
> Regards,
> Tao
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.33-rc6 #2
> -------------------------------------------------------
> umount/3880 is trying to acquire lock:
>  (&(&dlm->spinlock)->rlock){+.+...}, at: [<ffffffffa045c6e0>] dlm_unregister_domain+0x465/0x7ce [ocfs2_dlm]
>
> but task is already holding lock:
>  (dlm_domain_lock){+.+...}, at: [<ffffffffa045c6d7>] dlm_unregister_domain+0x45c/0x7ce [ocfs2_dlm]
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (dlm_domain_lock){+.+...}:
>        [<ffffffff82065a01>] validate_chain+0xa40/0xd38
>        [<ffffffff820664a6>] __lock_acquire+0x7ad/0x813
>        [<ffffffff820665d3>] lock_acquire+0xc7/0xe4
>        [<ffffffff8233d3da>] _raw_spin_lock+0x31/0x66
>        [<ffffffffa045bf74>] dlm_put+0x1f/0x3e [ocfs2_dlm]
>        [<ffffffffa046b6f6>] dlm_lockres_release+0x132/0x30e [ocfs2_dlm]
>        [<ffffffff8218bbea>] kref_put+0x43/0x4f
>        [<ffffffffa046999d>] dlm_lockres_put+0x14/0x16 [ocfs2_dlm]
>        [<ffffffffa0460277>] dlm_run_purge_list+0x494/0x4df [ocfs2_dlm]
>        [<ffffffffa04605c7>] dlm_thread+0x9d/0xe32 [ocfs2_dlm]
>        [<ffffffff82054d4d>] kthread+0x7d/0x85
>        [<ffffffff82003794>] kernel_thread_helper+0x4/0x10
>
> -> #0 (&(&dlm->spinlock)->rlock){+.+...}:
>        [<ffffffff820656ed>] validate_chain+0x72c/0xd38
>        [<ffffffff820664a6>] __lock_acquire+0x7ad/0x813
>        [<ffffffff820665d3>] lock_acquire+0xc7/0xe4
>        [<ffffffff8233d3da>] _raw_spin_lock+0x31/0x66
>        [<ffffffffa045c6e0>] dlm_unregister_domain+0x465/0x7ce [ocfs2_dlm]
>        [<ffffffffa04941d5>] o2cb_cluster_disconnect+0x38/0x4a [ocfs2_stack_o2cb]
>        [<ffffffffa04012ba>] ocfs2_cluster_disconnect+0x2a/0x4e [ocfs2_stackglue]
>        [<ffffffffa04e95f4>] ocfs2_dlm_shutdown+0xf9/0x167 [ocfs2]
>        [<ffffffffa051f606>] ocfs2_dismount_volume+0x1d8/0x39e [ocfs2]
>        [<ffffffffa051fbe8>] ocfs2_put_super+0x88/0xf4 [ocfs2]
>        [<ffffffff820dcc6d>] generic_shutdown_super+0x58/0xcc
>        [<ffffffff820dcd03>] kill_block_super+0x22/0x3a
>        [<ffffffffa051d671>] ocfs2_kill_sb+0x77/0x7f [ocfs2]
>        [<ffffffff820dd438>] deactivate_super+0x68/0x7d
>        [<ffffffff820f11ba>] mntput_no_expire+0x75/0xb0
>        [<ffffffff820f172a>] sys_umount+0x2c2/0x321
>        [<ffffffff8200296b>] system_call_fastpath+0x16/0x1b
>
> other info that might help us debug this:
>
