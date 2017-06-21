From: Eric Ren <zren@suse.com>
Date: Wed, 21 Jun 2017 16:26:16 +0800
Subject: [Ocfs2-devel] deadlock with setfacl
In-Reply-To: <A2168124-9365-4A38-AFD2-3874F7FB38AC@suse.com>
References: <alpine.LSU.2.20.1706200949540.10351@er-systems.de>
	<A2168124-9365-4A38-AFD2-3874F7FB38AC@suse.com>
Message-ID: <83491529-39b2-d3c1-469d-fc663184d676@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Thomas,

I'm attaching a patch for the issue you reported. I've tested myself.
Could you please also try it out?

If it's OK, I'll submit a formal patch later.

Thanks,
Eric

On 06/20/2017 04:38 PM, Eric Ren wrote:
> Hi!
>
> Thanks for reporting! I will get to this issue quickly.
>
> Eric
>
> Sent from my iPhone
>
>> On 20 Jun 2017, at 16:02, Thomas Voegtle <tv@lio96.de> wrote:
>>
>>
>> Hello,
>>
>>
>> We see a deadlock with setfacl on 4.4.70 and on 4.12-rc5, too.
>>
>> node1: copies a big file from /home/user to the ocfs2 mountpoint
>> node2: runs setfacl on that file in the ocfs2 mountpoint while cp still running
>> => both jobs never end.
>>
>>
>> When we revert
>> 743b5f1434f57a147226c747fe228cadeb7b05ed ocfs2: take inode lock in
>> ocfs2_iop_set/get_acl()
>> and the other two follow-up fixes (5ee0fbd50fdf1c132 and b891fa5024a95c77)
>> we see no deadlock anymore.
>>
>> commit b891fa5024a95c77 fixed it for getacl (we can confirm this) but not
>> for setacl, as we encounter?
>>
>> Reference:
>> https://oss.oracle.com/pipermail/ocfs2-devel/2016-October/012455.html
>>
>> Thanks,
>>
>> Thomas
>>
>>
>>
>> This gets printed in the dmesg on node1:
>>
>> [  484.345226] INFO: task cp:10633 blocked for more than 120 seconds.
>> [  484.345230]       Not tainted 4.12.0-rc5 #1
>> [  484.345230] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  484.345232] cp              D    0 10633   5594 0x00000000
>> [  484.345235] Call Trace:
>> [  484.345295]  __schedule+0x2e8/0x5f7
>> [  484.345298]  schedule+0x35/0x80
>> [  484.345300]  schedule_timeout+0x1a7/0x230
>> [  484.345326]  ? check_preempt_curr+0x61/0x90
>> [  484.345358]  ? ocfs2_control_read+0x60/0x60 [ocfs2_stack_user]
>> [  484.345360]  wait_for_completion+0x9b/0x100
>> [  484.345361]  ? try_to_wake_up+0x250/0x250
>> [  484.345447]  __ocfs2_cluster_lock.isra.42+0x29b/0x740 [ocfs2]
>> [  484.345463]  ? radix_tree_tag_set+0x7e/0xf0
>> [  484.345475]  ocfs2_inode_lock_full_nested+0x1d2/0x3a0 [ocfs2]
>> [  484.345486]  ? ocfs2_wake_downconvert_thread+0x4d/0x60 [ocfs2]
>> [  484.345497]  ocfs2_write_begin+0x4a/0x190 [ocfs2]
>> [  484.345509]  generic_perform_write+0xa7/0x190
>> [  484.345516]  __generic_file_write_iter+0x191/0x1e0
>> [  484.345528]  ocfs2_file_write_iter+0x1a5/0x490 [ocfs2]
>> [  484.345541]  ? ext4_file_read_iter+0xae/0xf0
>> [  484.345550]  new_sync_write+0xc0/0x100
>> [  484.345552]  __vfs_write+0x27/0x40
>> [  484.345553]  vfs_write+0xc4/0x1b0
>> [  484.345555]  SyS_write+0x4a/0xa0
>> [  484.345561]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>> [  484.345563] RIP: 0033:0x7fb5111a8150
>> [  484.345564] RSP: 002b:00007fff125140d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> [  484.345566] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb5111a8150
>> [  484.345567] RDX: 0000000000020000 RSI: 00007fb511c3f000 RDI: 0000000000000004
>> [  484.345678] RBP: 00007fff125141d0 R08: 0000000000000000 R09: 00007fff12515c82
>> [  484.345680] R10: 00007fff12513e70 R11: 0000000000000246 R12: 00000000004030b0
>> [  484.345681] R13: 00007fff12514ca0 R14: 0000000000000000 R15: 0000000000000000
>>
>>
>> This gets printed in the dmesg on node2:
>>
>> [  484.483726] INFO: task setfacl:10279 blocked for more than 120 seconds.
>> [  484.483729]       Not tainted 4.12.0-rc5 #1
>> [  484.483730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  484.483731] setfacl         D    0 10279  10278 0x00000000
>> [  484.483734] Call Trace:
>> [  484.483793]  __schedule+0x2e8/0x5f7
>> [  484.483797]  schedule+0x35/0x80
>> [  484.483799]  schedule_timeout+0x1a7/0x230
>> [  484.483825]  ? default_wake_function+0xd/0x10
>> [  484.483832]  ? autoremove_wake_function+0x11/0x40
>> [  484.483834]  ? __wake_up_common+0x4f/0x80
>> [  484.483835]  wait_for_completion+0x9b/0x100
>> [  484.483837]  ? try_to_wake_up+0x250/0x250
>> [  484.483973]  __ocfs2_cluster_lock.isra.42+0x29b/0x740 [ocfs2]
>> [  484.483993]  ? radix_tree_lookup_slot+0x13/0x30
>> [  484.484005]  ocfs2_inode_lock_full_nested+0x1d2/0x3a0 [ocfs2]
>> [  484.484018]  ocfs2_xattr_set+0x143/0x740 [ocfs2]
>> [  484.484035]  ? jbd2_journal_cancel_revoke+0xbf/0xf0
>> [  484.484049]  ocfs2_set_acl+0x177/0x190 [ocfs2]
>> [  484.484061]  ? ocfs2_inode_lock_tracker+0xee/0x180 [ocfs2]
>> [  484.484074]  ocfs2_iop_set_acl+0x60/0xa0 [ocfs2]
>> [  484.484084]  set_posix_acl+0x84/0xc0
>> [  484.484090]  posix_acl_xattr_set+0x4c/0xb0
>> [  484.484099]  __vfs_setxattr+0x71/0x90
>> [  484.484102]  __vfs_setxattr_noperm+0x70/0x1b0
>> [  484.484104]  vfs_setxattr+0xae/0xb0
>> [  484.484106]  setxattr+0x160/0x190
>> [  484.484112]  ? strncpy_from_user+0x43/0x140
>> [  484.484118]  ? getname_flags.part.41+0x56/0x1c0
>> [  484.484121]  ? __mnt_want_write+0x4d/0x60
>> [  484.484123]  path_setxattr+0x85/0xb0
>> [  484.484125]  SyS_setxattr+0xf/0x20
>> [  484.484131]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>> [  484.484133] RIP: 0033:0x7f203f2b23f9
>> [  484.484134] RSP: 002b:00007ffd7d8585d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
>> [  484.484136] RAX: ffffffffffffffda RBX: 0000000001d9d3a0 RCX: 00007f203f2b23f9
>> [  484.484137] RDX: 0000000001d9d5a0 RSI: 00007f203f782b5f RDI: 00007ffd7d858890
>> [  484.484137] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000026
>> [  484.484138] R10: 0000000000000034 R11: 0000000000000246 R12: 0000000000000000
>> [  484.484139] R13: 0000000001d9d240 R14: 0000000001d9d270 R15: 00007ffd7d859a38
>>
>>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>

-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-fix-deadlock-caused-by-recursive-locking-in-xa.patch
Type: text/x-patch
Size: 5022 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170621/11d890cc/attachment.bin 
