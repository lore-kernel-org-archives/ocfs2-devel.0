From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 Jan 2009 08:27:03 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation Strategy
	Improvement
In-Reply-To: <20090106214139.GT17410@wotan.suse.de>
References: <492F946F.1060409@oracle.com>
	<20090106214139.GT17410@wotan.suse.de>
Message-ID: <4963F6D7.9050703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	Thanks for the review.

Mark Fasheh wrote:
> On Fri, Nov 28, 2008 at 02:49:19PM +0800, Tao Ma wrote:
>> Hi all,
>> 	In ocfs2, when we create a fresh file system and create inodes in 
>> 	it, they are contiguous and good for readdir+stat. While if we delete all 
>> the inodes and created again, the new inodes will get spread out and 
>> that isn't what we need. The core problem here is that the inode block 
>> search looks for the "emptiest" inode group to allocate from. So if an 
>> inode alloc file has many equally (or almost equally) empty groups, new 
>> inodes will tend to get spread out amongst them, which in turn can put 
>> them all over the disk. This is undesirable because directory operations 
>> on conceptually "nearby" inodes force a large number of seeks. For more 
>> details, please see 
>> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.(I 
>> have modified it a little, Mark, if you are interested, please look at 
>> it. They are underlined.)
> 
> Your edits look fine. Thanks for updating the design doc.
cool.
> 
> 
>> So this patch set try to fix this problem.
>> patch 1: Optimize inode allocation by remembering last group.
>> We add ip_last_used_group in core directory inodes which records
>> the last used allocation group. Another field named ip_last_used_slot
>> is also added in case inode stealing happens. When claiming new inode,
>> we passed in directory's inode so that the allocation can use this
>> information.
>>
>> patch 2: let the Inode group allocs use the global bitmap directly.
>>
>> patch 3: we add osb_last_alloc_group in ocfs2_super to record the last
>> used allocation group so that we can make inode groups contiguous enough.
> 
> So, the logic in your patches is correct. As you can see, most of my
> comments were more about code flow or trivial cleanups. Assuming this all
> works as we expect, there shouldn't be much code for you to modify before
> the patches can be put in the merge_window branch.
> 
> 
> One things though - would you mind providing a small amount of data to show
> what sort of improvement (if any) we're getting from these patches? I don't
> think we need anything fancy - just enough to answer the following two
> questions:
> 
> - How much does this improve our inode fragmentation level?
Actually I have some statistics and the result is cool. ;)  I will 
attach it in the next round of patches.
> 
> Any test that fragments the inode space would be appropriate for this.
> 
> We could then simply express fragmentation as some value - maybe a ratio of
> adjacent inodes as compared to total # of inodes, expressed as a percentage
> value. It would be nice for future testing if we had a small tool to
> calculate this (maybe by libocfs2, or by just making readdir calls and
> looking at inode number),
> 
> 
> - Does the 2nd patch impact overall inode creation times in a cluster, since
>   we're now using the cluster bitmap instead of local alloc.
No statistics here since I originally think there should be not much 
difference. But I will test it and attach the result. Thanks.

Regards,
Tao
