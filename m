From: tao.ma <tao.ma@oracle.com>
Date: Thu Feb 28 21:17:30 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing
	for	ocfs2_reserve_new_inode.V2
In-Reply-To: <20080229014201.GB9349@ca-server1.us.oracle.com>
References: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
	<20080228070026.GA29377@tma-pc1.cn.oracle.com>
	<20080228233042.GW27865@ca-server1.us.oracle.com>
	<47C75B74.2090009@oracle.com>
	<20080229014201.GB9349@ca-server1.us.oracle.com>
Message-ID: <47C7955D.8010207@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Fri, Feb 29, 2008 at 09:10:12AM +0800, tao.ma wrote:
>>>> @@ -542,6 +577,17 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>>>>  	status = ocfs2_reserve_suballoc_bits(osb, *ac,
>>>>  					     INODE_ALLOC_SYSTEM_INODE,
>>>>  					     osb->slot_num, ALLOC_NEW_GROUP);
>>>> +	if (status >= 0) {
>>>> +		status = 0;
>>>> +		goto bail;
>>>> +	} else if (status < 0 && status != -ENOSPC) {
>>>> +		mlog_errno(status);
>>>> +		goto bail;
>>>> +	}
>>>> +
>>>> +	ocfs2_free_ac_resource(*ac);
>>>> +
>>>> +	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
>>> Does this mean we always search our own first, even if we know it's not
>>> likely to have anything in it? Wouldn't it be better to ignore once it's
>>> full until we get to one of the spots where you've inserted a call to
>>> ocfs2_init_inode_steal_slot)?
>> I am worried about the situation that the global bitmap is flushed by other 
>> nodes and how the current node notice this and use its own local allocator 
>> again. Or should it notice this?
>> Another thing is that what if the inode which is owned by this slot deleted 
>> by other slots? We should have the ability to allocate the inode from our 
>> own slot now.
> 
> Both your points come down to "how do we know when another node has changed
> the allocators such that we can now allocate inodes from our local
> inode_alloc file."
> 
> Unfortunately, we have no way of knowing what another node does. I'm mostly 
> worried about the inefficency of continuously searching ours when there
> isn't likely any room left in it.
> 
> One thing we could do is only go back to our local allocator after some time
> has passed (or some number of allocs). That way we don't check it every
> single time, but we never completely leave it out of the picture either.
OK, so I will modify it. thanks.
