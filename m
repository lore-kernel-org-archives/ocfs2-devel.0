From: =?utf-8?Q?Marek_Kr=C3=B3likowski?= <admin@wset.edu.pl>
Date: Wed, 28 Dec 2011 17:26:44 +0100
Subject: [Ocfs2-devel] Gentoo 3.1.5 and ocfs2 1.6.4 instability
In-Reply-To: <694854D8FC5D42A1B09AEDC87772DEF4@SERWER>
References: <4EFB165C.7040205@s-cubed.net><F3905FB5AC18479597BEC1E185F27A03@SERWER>
	<694854D8FC5D42A1B09AEDC87772DEF4@SERWER>
Message-ID: <F04EFF12EE2143E48E9EE570183CFDD5@SERWER>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello
After compile 3.1.6 i got this same effect:
kworker/u:0     D ffff88107f2d2c40     0 15962      2 0x00000000
ffff8810163a7810 0000000000000046 ffff880f00000000 ffff8810207347d0
0000000000012c40 ffff880a3413ffd8 0000000000012c40 ffff880a3413e010
ffff880a3413ffd8 0000000000012c40 ffff880f64211e40 0000000100000000
Call Trace:
[<ffffffff8148d53d>] ? schedule_timeout+0x1ed/0x2d0
[<ffffffffa0b871ea>] ? dlmlock+0x8a/0xda0 [ocfs2_dlm]
[<ffffffff8148d53d>] ? schedule_timeout+0x1ed/0x2d0
[<ffffffff8148cf3c>] ? wait_for_common+0x12c/0x1a0
[<ffffffff81052270>] ? try_to_wake_up+0x280/0x280
[<ffffffffa0a459c0>] ? __ocfs2_cluster_lock+0x1f0/0x780 [ocfs2]
[<ffffffff8105f749>] ? ns_to_timeval+0x9/0x40
[<ffffffff81019df5>] ? read_tsc+0x5/0x20
[<ffffffff81085e61>] ? ktime_get+0x61/0xf0
[<ffffffffa0a4abc6>] ? ocfs2_inode_lock_full_nested+0x126/0x540 [ocfs2]
[<ffffffffa0a5680f>] ? ocfs2_wipe_inode+0x12f/0x6a0 [ocfs2]
[<ffffffffa0a5680f>] ? ocfs2_wipe_inode+0x12f/0x6a0 [ocfs2]
[<ffffffffa0a563a4>] ? ocfs2_query_inode_wipe+0xc4/0x360 [ocfs2]
[<ffffffffa0a56ff2>] ? ocfs2_delete_inode+0x272/0x3e0 [ocfs2]
[<ffffffffa0a36f90>] ? ocfs2_drop_all_dl_inodes+0x10/0x10 [ocfs2]
[<ffffffffa0a57ad9>] ? ocfs2_evict_inode+0x19/0x40 [ocfs2]
[<ffffffff8114ea7c>] ? evict+0x8c/0x170
[<ffffffffa0a36f46>] ? __ocfs2_drop_dl_inodes+0x36/0x70 [ocfs2]
[<ffffffffa0a36fb5>] ? ocfs2_drop_dl_inodes+0x25/0x90 [ocfs2]
[<ffffffff81075433>] ? process_one_work+0x123/0x450
[<ffffffff8107694b>] ? worker_thread+0x15b/0x370
[<ffffffff810767f0>] ? manage_workers+0x110/0x110
[<ffffffff810767f0>] ? manage_workers+0x110/0x110
[<ffffffff8107b6c6>] ? kthread+0x96/0xa0
[<ffffffff81498b74>] ? kernel_thread_helper+0x4/0x10
[<ffffffff8107b630>] ? kthread_worker_fn+0x190/0x190
[<ffffffff81498b70>] ? gs_change+0x13/0x13

Happy New Year!


-----Oryginalna wiadomo??----- 
From: Marek Kr?likowski
Sent: Wednesday, December 28, 2011 3:17 PM
To: ocfs2-devel at oss.oracle.com
Subject: Re: [Ocfs2-devel] Gentoo 3.1.5 and ocfs2 1.6.4 instability

Hello i downloaded and compile right now kernel 3.1.6 but i check sources
and i don`t see any change between 3.1.4, 3.1.5 and 3.1.6 in ocfs2 sources
and i read changelog of 3.1.6 kernel and don`t see any information about any
change for ocfs2.
Ofc i do few hours test and we will see what happened.


-----Oryginalna wiadomo??----- 
From: Marek Kr?likowski
Sent: Wednesday, December 28, 2011 2:53 PM
To: William Fuller ; ocfs2-devel at oss.oracle.com
Subject: Re: [Ocfs2-devel] Gentoo 3.1.5 and ocfs2 1.6.4 instability

Hello
I don`t use gentoo-sources or hardened-sources i do test on vanilla 3.1.4
and 3.1.5 downloaded from www.kernel.org and on both version i get oops.
Now i compiling vanilla 3.1.6 and we will see in 24 hours what happened.
Thanks
Marek


-----Oryginalna wiadomo??----- 
From: William Fuller
Sent: Wednesday, December 28, 2011 2:15 PM
To: ocfs2-devel at oss.oracle.com
Subject: [Ocfs2-devel] Gentoo 3.1.5 and ocfs2 1.6.4 instability

Hi,

I saw the posting from Marek regarding the kernel oops after many reads
and writes.  I saw another posting in the users group where someone
simply changed their kernel to a vanilla 3.1.6 and the problem went
away.  Can anyone confirm that this change corrects the problem?

Thanks,
Bill

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel 
