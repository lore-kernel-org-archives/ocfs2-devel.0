From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 24 Oct 2017 08:55:51 +0800
Subject: [Ocfs2-devel] ocfs2 hangs
In-Reply-To: <59EE1175020000D40009EADC@prv-mh.provo.novell.com>
References: <ec1e7376-5292-1c79-3b8d-9476423edec2@belkam.com>
	<59EE1175020000D40009EADC@prv-mh.provo.novell.com>
Message-ID: <049767e6-444e-843f-4d59-6300c34c5e89@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Dmitry,

Please wait our new kernel, we will drop this issue and backport
upstream commit c25a1e0671fb ("ocfs2: fix posix_acl_create deadlock") to
fix this issue.

Thanks,
Junxiao.
On 10/23/2017 11:57 PM, Zhen Ren wrote:
> Hi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknode :  fix recursive locking hung
> 
> Eric
> 
> 
>>>> Dmitry Melekhov <dm@belkam.com> 10/18/17 1:20 PM >>>
> Hello!
> 
> I run two dovecot servers over ocfs2 for years.
> 
> Previously I used ubuntu, but migrated to Oracle Linux this year.
> 
> And all kernels older then
> 
> 4.1.12-94.5.9.el7uek.x86_64
> 
> hangs with
> Aug 27 07:14:17 dovecot1 kernel: INFO: task deliver:15573 blocked for more than
> 120 seconds.
> Aug 27 07:14:17 dovecot1 kernel:      Not tainted 4.1.12-103.3.8.el7uek.x86_64
> #2
> Aug 27 07:14:17 dovecot1 kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Aug 27 07:14:17 dovecot1 kernel: deliver         D 0000000000000001     0 15573
>   15572 0x00000080
> Aug 27 07:14:17 dovecot1 kernel: ffff88003d0af6c8 0000000000000086
> ffff880079039c00 ffff88007c1ff000
> Aug 27 07:14:17 dovecot1 kernel: ffff88003d0af6b8 ffff88003d0b0000
> ffff88003d0af890 7fffffffffffffff
> Aug 27 07:14:17 dovecot1 kernel: ffff88007c1ff000 0000000000000000
> ffff88003d0af6e8 ffffffff81739c57
> Aug 27 07:14:17 dovecot1 kernel: Call Trace:
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81739c57>] schedule+0x37/0x90
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8173cd3c>]
> schedule_timeout+0x24c/0x2c0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff811945de>] ?
> find_get_entry+0x1e/0xa0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff811956a1>] ?
> pagecache_get_page+0xd1/0x1a0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff812499aa>] ?
> bh_lru_install+0x18a/0x1e0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8173a844>]
> wait_for_completion+0x134/0x190
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff810b65c0>] ? wake_up_state+0x20/0x20
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa045d4d1>]
> __ocfs2_cluster_lock.isra.36+0x231/0x9c0 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa04bab96>] ?
> ocfs2_buffer_cached.isra.6+0xb6/0x240 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa045ebfa>]
> ocfs2_inode_lock_full_nested+0x1da/0x530 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa045f00b>]
> ocfs2_inode_lock_tracker+0xbb/0x1c0 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa04d699d>]
> ocfs2_iop_get_acl+0x5d/0x25e [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa047892d>] ?
> ocfs2_reserve_local_alloc_bits+0x8d/0x380 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff812740a7>] get_acl+0x47/0x70
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8127478a>]
> posix_acl_create+0x5a/0x160
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa04818f8>] ocfs2_mknod+0x938/0x1620
> [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa045a599>] ?
> ocfs2_wake_downconvert_thread+0x49/0x50 [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffffa04827b6>] ocfs2_create+0x66/0x170
> [ocfs2]
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8121f865>] vfs_create+0xd5/0x140
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81222a5d>] do_last+0x9ed/0x1270
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8122336f>] path_openat+0x8f/0x630
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81224dde>] ?
> user_path_at_empty+0x6e/0xc0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81224ee9>] do_filp_open+0x49/0xc0
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81351545>] ?
> find_next_zero_bit+0x25/0x30
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff812320a7>] ? __alloc_fd+0xa7/0x130
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81212367>] do_sys_open+0x137/0x240
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff81130b16>] ?
> __audit_syscall_exit+0x1e6/0x280
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff811cf554>] ?
> SyS_mprotect+0x1f4/0x290
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8121248e>] SyS_open+0x1e/0x20
> Aug 27 07:14:17 dovecot1 kernel: [<ffffffff8173deee>]
> system_call_fastpath+0x12/0x71
>      
>    
> 
> Here is my bug report
> https://bugzilla.oracle.com/bugzilla/show_bug.cgi?id=16056
> 
> But, unfortunately, there is no activity here and bug is still not fixed 
> in latest UEK kernels.
> 
> I think that Oracle takes ocfs2 from here anyway.
> 
> May be somebody knows what was changed in
> 4.1.12-103.3.8.el7uek ?
> 
> 
> Thank you!<mailto:greg.marsden@oracle.com>
> Hi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> EricHi,
> 
>>From the backtrace below, it seems very like the issue fixed by Junxiao recently
> by this patch:
> 
> [PATCH] ocfs2: mknod: fix recursive locking hung
> 
> Eric
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
