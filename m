From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 02 May 2008 15:48:51 +0800
Subject: [Ocfs2-devel] [patch 0/2] Add inode steal in ocfs2-1.2
In-Reply-To: <4818A8CB.3000304@oracle.com>
References: <20080430070805.GA11248@dhcp-beijing-cdc-10-182-121-54.cn.oracle	.com>
	<48181D3B.3070503@oracle.com> <4818A8CB.3000304@oracle.com>
Message-ID: <481AC763.9080301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OK, no problem.
Marcos, please verify it and I will commit it into ocfs2-test.
You must have at least 3 nodes to run this test since one node will 
steal inodes from other 2 nodes.
any problem, please let me know. Thanks.

Regards,
Tao

Sunil Mushran wrote:
> Thanks.
> 
> Can you work with Marcos to check this in ocfs2-test repo.
> 
> Tao Ma wrote:
>> One more thing, it has been tested with my script which has been sent 
>> to ocfs2-tools-devel for review. Please see
>> http://oss.oracle.com/pipermail/ocfs2-tools-devel/2008-March/000621.html
>>
>> Regards,
>> Tao
>>
>> tao.ma at oracle.com wrote:
>>  
>>> Hi all,
>>> This patch series add inode steal mechanism for inode allocation and
>>> it is backported from 2.6.26.
>>>
>>> In OCFS2, we allocate the inodes from slot specific inode_alloc to avoid
>>> inode creation congestion. The local alloc file grows in a large 
>>> contiguous
>>> chunk. As for a 4K bs, it grows 4M every time. So 1024 inodes will be
>>> allocated at a time.
>>>
>>> Over time, if the fs gets fragmented enough(e.g, the user has created
>>> many small files and also delete some of them), we can end up in a 
>>> situation,
>>> whereby we cannot extend the inode_alloc as we don't have a large chunk
>>> free in the global_bitmap even if df shows few gigs free. More annoying
>>> is that this situation will invariably mean that while one cannot create
>>> inodes on one node but can from another node. Still more annoying is 
>>> that an
>>> unused slot may have space for plenty of inodes but is unusable as 
>>> the user may
>>> not be mounting as many nodes anymore.
>>>
>>> This patch series implement a solution which is to steal inodes from
>>> another slot. Now the whole inode allocation process looks like this:
>>> 1. Allocate from its own inode_alloc:000X
>>>    1) If we can reserve, OK.
>>>    2) If fails, try to allocate a large chunk and reserve once again.
>>> 2. If 1 fails, try to allocate from the ocfs2_super->inode_steal_slot.
>>>    This time, Just try to reserve, we don't go for global_bitmap if
>>>    this inode also can't allocate the inode.
>>> 3. If 2 fails, try the node next until we reach that steal slot again.
>>>
>>> ocfs2_super->inode_steal_slot is initalized as the node next to our own
>>> slot. And once the inode stealing successes, we will refresh it with
>>> the slot we steal inode from. It will also be reinitalized when the
>>> local truncate log or local alloc recovery is flushed in which case 
>>> the global
>>> bitmap may be refreshed.
>>>
>>>     
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>   
> 
