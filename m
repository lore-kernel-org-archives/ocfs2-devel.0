From: Larry Chen <lchen@suse.com>
Date: Fri, 17 Aug 2018 11:11:30 +0800
Subject: [Ocfs2-devel] [PATCH] fix crash on
 ocfs2_duplicate_clusters_by_page
In-Reply-To: <9b09dcf7-0027-e71f-7f3d-a063d9704af5@suse.com>
References: <20180816112426.12218-1-lchen@suse.com>
	<HK0PR06MB25611B846516928348EF7AD5D53E0@HK0PR06MB2561.apcprd06.prod.outlook.com>
	<9b09dcf7-0027-e71f-7f3d-a063d9704af5@suse.com>
Message-ID: <7edf8996-1cf2-8238-ef90-f82f60b682d4@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is backtrace printed from crash bt command

crash> bt
PID: 7655   TASK: ffff8f2b44e70640  CPU: 0   COMMAND: "defragfs.ocfs2"
  #0 [ffff9fbdc887f830] machine_kexec at ffffffff8405bd81
  #1 [ffff9fbdc887f880] __crash_kexec at ffffffff8411be5e
  #2 [ffff9fbdc887f938] crash_kexec at ffffffff8411caed
  #3 [ffff9fbdc887f950] oops_end at ffffffff8402e0fe
  #4 [ffff9fbdc887f970] do_trap at ffffffff8402c196
  #5 [ffff9fbdc887f9b0] do_error_trap at ffffffff8402c210
  #6 [ffff9fbdc887fa60] invalid_op at ffffffff84800fa1
     [exception RIP: ocfs2_duplicate_clusters_by_page+822]
     RIP: ffffffffc08fb256  RSP: ffff9fbdc887fb10  RFLAGS: 00010202
     RAX: 000fffffc000107d  RBX: 0000000000301000  RCX: 0000000000000000
     RDX: 0000000000000000  RSI: ffffd4ea010a9440  RDI: ffffd4ea010a9440
     RBP: ffffd4ea010a9440   R8: ffffd4ea010a945c   R9: ffffd4ea010a9440
     R10: 0000000000000000  R11: 0000000000000040  R12: 00000000003e0000
     R13: ffff8f2b76559800  R14: 0000000000300000  R15: 000000000019ed8f
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
  #7 [ffff9fbdc887fb78] __ocfs2_move_extent at ffffffffc0901e70 [ocfs2]
  #8 [ffff9fbdc887fc08] ocfs2_defrag_extent at ffffffffc0902a18 [ocfs2]
  #9 [ffff9fbdc887fc88] __ocfs2_move_extents_range at ffffffffc0903814 
[ocfs2]
#10 [ffff9fbdc887fd20] ocfs2_move_extents at ffffffffc0903b60 [ocfs2]
#11 [ffff9fbdc887fd80] ocfs2_ioctl_move_extents at ffffffffc0903ec3 [ocfs2]
#12 [ffff9fbdc887fe10] ocfs2_ioctl at ffffffffc08e5a53 [ocfs2]
#13 [ffff9fbdc887fe88] do_vfs_ioctl at ffffffff84256480
#14 [ffff9fbdc887fef8] sys_ioctl at ffffffff84256a54
#15 [ffff9fbdc887ff30] do_syscall_64 at ffffffff84003ae4
#16 [ffff9fbdc887ff50] entry_SYSCALL_64_after_hwframe at ffffffff8480009a
     RIP: 00007f1442027477  RSP: 00007ffd295e0268  RFLAGS: 00000202
     RAX: ffffffffffffffda  RBX: 00007ffd295e4350  RCX: 00007f1442027477
     RDX: 00007ffd295e0290  RSI: 0000000040406f06  RDI: 0000000000000004
     RBP: 00007ffd295e02e0   R8: 000000000000ffff   R9: 00007f1442500500
     R10: 0000000000000000  R11: 0000000000000202  R12: 00007ffd295e0450
     R13: 0000000000000008  R14: 00007ffd295e0350  R15: 00000000ffffffff
     ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b



On 08/17/2018 11:05 AM, Larry Chen wrote:
> Hi Changwei,
> 
> It's easy to reproduce the bug.
> 
> The bug was found during developing a defragmentation tool for ocfs2.
> 
> To achieve that, I use ioctl interface against each file like:
> 
> 
> 	struct ocfs2_move_extents me = {
> 		.me_start = 0,
> 		.me_len = buf->st_size,
> 		.me_flags = OCFS2_MOVE_EXT_FL_AUTO_DEFRAG,
> 	};
> 
> 	fd = open64(file, O_RDWR, 0400);
> 
> 
> 	ret = ioctl(fd, OCFS2_IOC_MOVE_EXT, &me);
> 
> Then I setup a cluster with only 1 node, and keep writing and deleting a
> file while another process keep using the ioctl to defragment the file.
> 
> After the patch applied, the bug disappeared, but I'm not sure whether
> it has been totally fixed.
> 
> Thanks
> Larry
> 
> 
> On 08/16/2018 07:43 PM, Changwei Ge wrote:
>> Hi Larry,
>>
>> Do you have a method to reproduce this issue?
>>
>> I would be nice that such a method is provided :-)
>>
>>
>> On 2018/8/16 19:24, Larry Chen wrote:
>>> ocfs2_duplicate_clusters_by_page may crash if an extent's page is dirty.
>>> When a page has not been written back, it is still in dirty state. If at
>>> that moment, ocfs2_duplicate_clusters_by_page is called against this
>>> page, the crash happens.
>>>
>>> To fix this bug, we can just unlock the page and wait the page until
>>> it's not dirty.
>>>
>>> I don't know whether the patch is appropriate, so I need comments,
>>> thanks.
>>>
>>> The following is the core dump:
>>>
>>> kernel BUG at /root/code/ocfs2/refcounttree.c:2961!
>>> __ocfs2_move_extent+0x80/0x450 [ocfs2]
>>
>> Because we may work on different base of git tree.
>> Can you paste in what function the crash occurs?
>> I guess you might miss something with your backtrace. Function
>> __ocfs2_move_extent shouldn't be in
>> file refcounttree.c
>>
>> Thanks,
>> Changwei
>>
>>> ? __ocfs2_claim_clusters+0x130/0x250 [ocfs2]
>>> ocfs2_defrag_extent+0x5b8/0x5e0 [ocfs2]
>>> __ocfs2_move_extents_range+0x2a4/0x470 [ocfs2]
>>> ocfs2_move_extents+0x180/0x3b0 [ocfs2]
>>> ? ocfs2_wait_for_recovery+0x13/0x70 [ocfs2]
>>> ocfs2_ioctl_move_extents+0x133/0x2d0 [ocfs2]
>>> ocfs2_ioctl+0x253/0x640 [ocfs2]
>>> do_vfs_ioctl+0x90/0x5f0
>>> SyS_ioctl+0x74/0x80
>>> do_syscall_64+0x74/0x140
>>> entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>>>
>>> To: mfasheh at versity.com,
>>>        jlbec at evilplan.org
>>> Cc: linux-kernel at vger.kernel.org,
>>>        ocfs2-devel at oss.oracle.com,
>>>        akpm at linux-foundation.org
>>>
>>> Signed-off-by: Larry Chen <lchen@suse.com>
>>> ---
>>>     fs/ocfs2/refcounttree.c | 10 ++++++++--
>>>     1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>>> index 7869622af22a..ee3b9dbbc310 100644
>>> --- a/fs/ocfs2/refcounttree.c
>>> +++ b/fs/ocfs2/refcounttree.c
>>> @@ -2946,6 +2946,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>>     		if (map_end & (PAGE_SIZE - 1))
>>>     			to = map_end & (PAGE_SIZE - 1);
>>>     
>>> +retry:
>>>     		page = find_or_create_page(mapping, page_index, GFP_NOFS);
>>>     		if (!page) {
>>>     			ret = -ENOMEM;
>>> @@ -2957,8 +2958,13 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>>     		 * In case PAGE_SIZE <= CLUSTER_SIZE, This page
>>>     		 * can't be dirtied before we CoW it out.
>>>     		 */
>>> -		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize)
>>> -			BUG_ON(PageDirty(page));
>>> +		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
>>> +			if (PageDirty(page)) {
>>> +				unlock_page(page);
>>> +				cond_resched();
>>> +				goto retry;
>>> +			}
>>> +		}
>>>     
>>>     		if (!PageUptodate(page)) {
>>>     			ret = block_read_full_page(page, ocfs2_get_block);
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
