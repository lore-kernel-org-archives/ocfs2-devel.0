From: Gang He <ghe@suse.com>
Date: Tue, 11 Jun 2019 01:51:48 -0600
Subject: [Ocfs2-devel] [Ocfs2-users] umount hung on two hosts
In-Reply-To: <CAG8B0Ozk=J4WZ_L9dKry9AMp3JahQ002gNE0UsWqcsc_RB6Hdw@mail.gmail.com>
References: <CAG8B0Ozk=J4WZ_L9dKry9AMp3JahQ002gNE0UsWqcsc_RB6Hdw@mail.gmail.com>
Message-ID: <5CFF5D94020000F90006B725@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Robin,

Since OCFS2 in SUSE HA extension uses pcmk stack, rather than o2cb stack, I can not give you more detailed comments.
But from the back-trace of the first umount process, it looks there is a msleep loop in dlmunlock function until certain condition is met.
Hello Alex, 
could your guys help to look at this case? I feel the first hang process reveal the current o2cb based DLM is exceptional? 


Thanks a lot.
Gang

>>> On 6/4/2019 at  5:46 pm, in message
<CAG8B0Ozk=J4WZ_L9dKry9AMp3JahQ002gNE0UsWqcsc_RB6Hdw@mail.gmail.com>, Robin Lee
<robinlee.sysu@gmail.com> wrote:
> Hi,
> 
> In a OCFS2 cluster of XenServer 7.1.1 hosts, we met umount hung on two
> different hosts.
> The kernel is based on Linux 4.4.27.
> The cluster has 9 hosts and 8 OCFS2 filesystems.
> Though umount is hanging, the mountpoint entry already disappeared in
> /proc/mounts.
> Despite this issue, the OCFS2 filesystems are working well.
> 
> the first umount stack: (by cat /proc/PID/stack)
> [<ffffffff810d05cd>] msleep+0x2d/0x40
> [<ffffffffa0620409>] dlmunlock+0x2c9/0x490 [ocfs2_dlm]
> [<ffffffffa04461a5>] o2cb_dlm_unlock+0x35/0x50 [ocfs2_stack_o2cb]
> [<ffffffffa0574120>] ocfs2_dlm_unlock+0x20/0x30 [ocfs2_stackglue]
> [<ffffffffa06531e0>] ocfs2_drop_lock.isra.20+0x250/0x370 [ocfs2]
> [<ffffffffa0654a36>] ocfs2_drop_inode_locks+0xa6/0x180 [ocfs2]
> [<ffffffffa0661d13>] ocfs2_clear_inode+0x343/0x6d0 [ocfs2]
> [<ffffffffa0663616>] ocfs2_evict_inode+0x526/0x5d0 [ocfs2]
> [<ffffffff811cd816>] evict+0xb6/0x170
> [<ffffffff811ce495>] iput+0x1c5/0x1f0
> [<ffffffffa068cbd0>] ocfs2_release_system_inodes+0x90/0xd0 [ocfs2]
> [<ffffffffa068dfad>] ocfs2_dismount_volume+0x17d/0x390 [ocfs2]
> [<ffffffffa068e210>] ocfs2_put_super+0x50/0x80 [ocfs2]
> [<ffffffff811b6e6f>] generic_shutdown_super+0x6f/0x100
> [<ffffffff811b6f87>] kill_block_super+0x27/0x70
> [<ffffffff811b68bb>] deactivate_locked_super+0x3b/0x70
> [<ffffffff811b6949>] deactivate_super+0x59/0x60
> [<ffffffff811d18a8>] cleanup_mnt+0x58/0x80
> [<ffffffff811d1922>] __cleanup_mnt+0x12/0x20
> [<ffffffff8108c2ad>] task_work_run+0x7d/0xa0
> [<ffffffff8106d2b9>] exit_to_usermode_loop+0x73/0x98
> [<ffffffff81003961>] syscall_return_slowpath+0x41/0x50
> [<ffffffff815a0acc>] int_ret_from_sys_call+0x25/0x8f
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> the second umount stack:
> [<ffffffff81087398>] flush_workqueue+0x1c8/0x520
> [<ffffffffa06700c9>] ocfs2_shutdown_local_alloc+0x39/0x410 [ocfs2]
> [<ffffffffa0692edd>] ocfs2_dismount_volume+0xad/0x390 [ocfs2]
> [<ffffffffa0693210>] ocfs2_put_super+0x50/0x80 [ocfs2]
> [<ffffffff811b6e6f>] generic_shutdown_super+0x6f/0x100
> [<ffffffff811b6f87>] kill_block_super+0x27/0x70
> [<ffffffff811b68bb>] deactivate_locked_super+0x3b/0x70
> [<ffffffff811b6949>] deactivate_super+0x59/0x60
> [<ffffffff811d18a8>] cleanup_mnt+0x58/0x80
> [<ffffffff811d1922>] __cleanup_mnt+0x12/0x20
> [<ffffffff8108c2ad>] task_work_run+0x7d/0xa0
> [<ffffffff8106d2b9>] exit_to_usermode_loop+0x73/0x98
> [<ffffffff81003961>] syscall_return_slowpath+0x41/0x50
> [<ffffffff815a0acc>] int_ret_from_sys_call+0x25/0x8f
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -robin
> 
> _______________________________________________
> Ocfs2-users mailing list
> Ocfs2-users at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-users
