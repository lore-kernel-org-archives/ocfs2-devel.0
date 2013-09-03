From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 03 Sep 2013 16:08:48 +0800
Subject: [Ocfs2-devel] OCFS2: ocfs2_read_blocks:285 ERROR: block 532737
 had the JBD bit set while I was in lock_buffer!
In-Reply-To: <522584DD.8070401@nod.at>
References: <CAFLxGvwLJs0ZrOZN-g=fCDEN4eAOQMjW_Nojm9fm5Rq0GKk9AQ@mail.gmail.com>
	<522554D6.4070000@oracle.com> <522584DD.8070401@nod.at>
Message-ID: <52259910.4030405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sunil Mushran <sunil.mushran@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>

On 09/03/2013 02:42 PM, Richard Weinberger wrote:

> Hi!
> 
> Am 03.09.2013 05:17, schrieb Jeff Liu:
>> Hello,
>>
>> It seems like Sunil has fixed a similar issue against ocfs2-1.4
>> several years ago:
>> https://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff_plain;h=2fd250839d0f5073af8d42e97f1db74beb621674;hp=e882faf84930431524f84598caea7d4e9a9529c5
>> https://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff_plain;h=eccff85213d4c2762f787d9e7cb1503042ba75b9;hp=edc147473ffd9c03790dc4502b893823f44a9ec4
>>
>> The old bug ticket for the discussion:
>> https://oss.oracle.com/bugzilla/show_bug.cgi?id=1235
>>
>> This fix is specifically for ocfs2-1.4, but Mark once mentioned that
>> the BUG() there can be removed if we have a good explanation for this
>> sort of behavior, is it time to have it in mainline?
> 
> Hmm, not fun.
> In my case I'm not using NFS or any other network filesystem.
> The OCFS2 is also used in local mode (no cluster).

It seems that this problem is irrelevant to cluster/network mode.
Any test case can help reproducing this problem if possible.

> 
> What really worries me is that this another proof that Oracles OCFS2 branch is out of sync with mainline.

Andrew help us merging OCFS2 mainlines fixes, you can fetch the updated
from his tree.

> 
> - Are there more fixes pending?

Sure.  That depends on how many fixes have been posted and how many person
are got involved in the patch review over a period of time.

> - Why aren't you pushing things back to mainline?

Because am not dedicated developer for OCFS2, although it spent me some time
to take care of OCFS2 issues recently.

Thanks,
-Jeff

> 
> Thanks,
> //richard
> 
>> Thanks,
>> -Jeff
>> On 09/03/2013 04:32 AM, richard -rw- weinberger wrote:
>>
>>> Hi!
>>>
>>> Today one of my computers crashed with the following panic.
>>> The machine is heavily using reflinks.
>>> Looks like it managed to hit a CATCH_BH_JBD_RACES error check.
>>>
>>> <3>[37628.934461] (reflink,512,0):ocfs2_reflink_ioctl:4459 ERROR: status = -17
>>> <3>[37628.943160] (kworker/u:2,809,1):ocfs2_read_blocks:285 ERROR:
>>> block 532737 had the JBD bit set while I was in lock_buffer!
>>> <4>[37628.943169] ------------[ cut here ]------------
>>> <2>[37628.944464] kernel BUG at
>>> /home/rw/work/ssworkstation/maker/_source/kernel/fs/ocfs2/buffer_head_io.c:286!
>>> <4>[37628.945134] invalid opcode: 0000 [#1] PREEMPT SMP
>>> <4>[37628.945809] CPU 1
>>> <4>[37628.945817] Pid: 809, comm: kworker/u:2 Not tainted 3.8.4+ #46
>>>                /
>>> <4>[37628.947167] RIP: 0010:[<ffffffff8125afa0>]  [<ffffffff8125afa0>]
>>> ocfs2_read_blocks+0x410/0x610
>>> <4>[37628.947880] RSP: 0018:ffff880234631908  EFLAGS: 00010292
>>> <4>[37628.948593] RAX: 000000000000006d RBX: 0000000000000001 RCX:
>>> 0000000000000067
>>> <4>[37628.949317] RDX: 0000000000000048 RSI: 0000000000000046 RDI:
>>> ffffffff8214c0dc
>>> Oops#1 Part3
>>> <4>[37628.950037] RBP: ffff880234631988 R08: 000000000000000a R09:
>>> 000000000000d490
>>> <4>[37628.950758] R10: 0000000000000000 R11: 0000000000000004 R12:
>>> 0000000000082101
>>> <4>[37628.951477] R13: ffff880233147980 R14: 0000000000000000 R15:
>>> ffff880216ca2208
>>> <4>[37628.952201] FS:  0000000000000000(0000)
>>> GS:ffff88023e280000(0000) knlGS:0000000000000000
>>> <4>[37628.952936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> <4>[37628.953669] CR2: 00007fe7ea29fc62 CR3: 0000000006c0b000 CR4:
>>> 00000000000407e0
>>> <4>[37628.954421] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> <4>[37628.955176] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>> 0000000000000400
>>> <4>[37628.955925] Process kworker/u:2 (pid: 809, threadinfo
>>> ffff880234630000, task ffff880234ba86e0)
>>> <4>[37628.956689] Stack:
>>> <4>[37628.957461]  0000000000082101 ffffea0008900880 ffff880234631948
>>> 0000000000001000
>>> <4>[37628.958250]  0000000000082102 0000000000082102 ffffffff81295eb0
>>> 0000000000000000
>>> Oops#1 Part2
>>> <4>[37628.959044]  ffff88023428c000 0000000100000000 0000000000000000
>>> ffff8802346319f0
>>> <4>[37628.959844] Call Trace:
>>> <4>[37628.960639]  [<ffffffff81295eb0>] ? ocfs2_read_refcount_block+0x50/0x50
>>> <4>[37628.961453]  [<ffffffff81295e8b>] ocfs2_read_refcount_block+0x2b/0x50
>>> <4>[37628.962249]  [<ffffffff81297417>] ocfs2_get_refcount_tree+0xa7/0x350
>>> <4>[37628.963042]  [<ffffffff8115c6d1>] ? __find_get_block+0xa1/0x1e0
>>> <4>[37628.963835]  [<ffffffff8129c5e8>] ocfs2_lock_refcount_tree+0x48/0x4f0
>>> <4>[37628.964645]  [<ffffffff8124fccb>] ocfs2_remove_btree_range+0xab/0xb30
>>> <4>[37628.965452]  [<ffffffff81253a99>] ocfs2_commit_truncate+0x139/0x550
>>> <4>[37628.966247]  [<ffffffff812844c0>] ? ocfs2_extend_trans+0x1c0/0x1c0
>>> <4>[37628.967049]  [<ffffffff8127e36e>] ocfs2_evict_inode+0x89e/0x2530
>>> <4>[37628.967851]  [<ffffffff81154a78>] ? __inode_wait_for_writeback+0x68/0xc0
>>> <4>[37628.968645]  [<ffffffff8114878f>] evict+0xaf/0x1b0
>>> <4>[37628.969432]  [<ffffffff81149495>] iput+0x105/0x1a0
>>> Oops#1 Part1
>>> <4>[37628.970213]  [<ffffffff8125b557>] __ocfs2_drop_dl_inodes.isra.14+0x47/0x80
>>> <4>[37628.971002]  [<ffffffff8125bd65>] ocfs2_drop_dl_inodes+0x25/0xa0
>>> <4>[37628.971788]  [<ffffffff81087dc7>] process_one_work+0x147/0x470
>>> <4>[37628.972580]  [<ffffffff810884bd>] worker_thread+0x14d/0x3f0
>>> <4>[37628.973381]  [<ffffffff81088370>] ? rescuer_thread+0x240/0x240
>>> <4>[37628.974175]  [<ffffffff8108db5b>] kthread+0xbb/0xc0
>>> <4>[37628.974960]  [<ffffffff8108daa0>] ? __kthread_parkme+0x80/0x80
>>> <4>[37628.975747]  [<ffffffff817dd9ec>] ret_from_fork+0x7c/0xb0
>>> <4>[37628.976529]  [<ffffffff8108daa0>] ? __kthread_parkme+0x80/0x80
>>> <4>[37628.977307] Code: 0f 0b 4c 89 ff e8 11 0b f0 ff e9 f2 fc ff ff
>>> 48 b8 00 00 00 00 00 00 00 10 48 85 05 2b 58 9d 00 74 09 48 85 05 c2
>>> 79 f4 00 74 02 <0f> 0b 65 48 8b 14 25 70 b8 00 00 48 8d 82 28 e0 ff ff
>>> 4d 8b 67
>>> <1>[37628.979053] RIP  [<ffffffff8125afa0>] ocfs2_read_blocks+0x410/0x610
>>> <4>[37628.979893]  RSP <ffff880234631908>
>>> <4>[37628.983420] ---[ end trace c03a48f44cf30d5e ]---
>>>
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
