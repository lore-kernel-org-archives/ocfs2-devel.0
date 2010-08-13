From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 13 Aug 2010 09:20:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <20100813010459.GH22777@mail.oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
	<20100812094350.GB6561@mail.oracle.com>
	<4C64968C.6030403@oracle.com>
	<20100813010459.GH22777@mail.oracle.com>
Message-ID: <4C649DD6.20104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Aug 13, 2010 at 08:49:16AM +0800, Tao Ma wrote:
>   
>>> 	I don't see why you don't extend the existing cache and make one
>>> cache.  Make it live the lifetime of the filesystem.  No real reason to
>>> a) have to caches or b) limit the system inodes we might cache.  If we
>>> don't have the lock we're going to re-read them anyway.
>>>       
>> You want me to do:
>> -        struct inode *system_inodes[NUM_SYSTEM_INODES];
>> +        struct inode **system_inodes
>>
>> and do
>> +    system_inodes = kzalloc((NUM_SYSTEM_INODES -
>> GROUP_QUOTA_SYSTEM_INODE) *
>> +                                            sizeof(struct inode *)
>> * osb->max_slots);
>>     
>
> 	Something like that.  I'd be more inclined to have a global
> inode cache, and a per-slot cache.  No need to have max_slots spaces for
> the global inodes.
> 	Actually, why not an rb-tree?  We just want to be able to avoid
> the dir lookup, really, right?  Why pre-alloc anything?  Just have a
> node:
>   
no, this patch doesn't want to reduce dir lookup, although it resolve 
dir lookup somehow. ;) This patch just want to resolve
the problem of (read_disk + journal_checkpoint when we orphan scan 
another slot). It seems that I have put the most
important part of this patch in the head of  the commit log. :)
> 	struct ocfs2_system_inode_cache_node {
> 		struct rb_node sic_node;
> 		int sic_type;
> 		int sic_slot;
> 		u64 sic_blkno;
> 		struct inode *sic_inode;
> 	};
>
> Although frankly a linked-list might work just as well.
>   
rb-tree may be too much for us. I would prefer what Sunil describe in 
another mail. Just use a pointer array should be fine for us.
what we lose is just some pointers that will never be initialized.

Regards,
Tao
