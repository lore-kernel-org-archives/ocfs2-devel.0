From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Aug 2010 18:04:59 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Cache some system inodes of other
	nodes.
In-Reply-To: <4C64968C.6030403@oracle.com>
References: <1281603796-3867-1-git-send-email-tao.ma@oracle.com>
	<20100812094350.GB6561@mail.oracle.com>
	<4C64968C.6030403@oracle.com>
Message-ID: <20100813010459.GH22777@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 13, 2010 at 08:49:16AM +0800, Tao Ma wrote:
> >	I don't see why you don't extend the existing cache and make one
> >cache.  Make it live the lifetime of the filesystem.  No real reason to
> >a) have to caches or b) limit the system inodes we might cache.  If we
> >don't have the lock we're going to re-read them anyway.
> You want me to do:
> -        struct inode *system_inodes[NUM_SYSTEM_INODES];
> +        struct inode **system_inodes
> 
> and do
> +    system_inodes = kzalloc((NUM_SYSTEM_INODES -
> GROUP_QUOTA_SYSTEM_INODE) *
> +                                            sizeof(struct inode *)
> * osb->max_slots);

	Something like that.  I'd be more inclined to have a global
inode cache, and a per-slot cache.  No need to have max_slots spaces for
the global inodes.
	Actually, why not an rb-tree?  We just want to be able to avoid
the dir lookup, really, right?  Why pre-alloc anything?  Just have a
node:

	struct ocfs2_system_inode_cache_node {
		struct rb_node sic_node;
		int sic_type;
		int sic_slot;
		u64 sic_blkno;
		struct inode *sic_inode;
	};

Although frankly a linked-list might work just as well.
	Essentially, anything that doesn't have the lock is going to
have to re-read the block, so what we really need cached is the mapping
from sic_type+sic_slot to iget().  Caching the inode itself is just
convenience.

> So we will save other system inodes such as local_alloc,
> truncate_log, local_user_quota and local_group_quota and
> actually we will never touch these inodes in the most cases(well,
> recovery is an exception). So why cache them
> if in the most case they will not be used?

	If we never touch them, we won't worry.  We've just used up a
pointer.  If we do use them, eg because we've recovered them, it doesn't
hurt to have them still in cache.  If you were really worried, you could
even hook into icache shrinking and drop them when kicked.  Keep the
tree nodes mapping sic_type+sic_slot->sic_blkno but drop sic_inode.
Maybe skip the ones where sic_slot==(this_slot || -1).

> In
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-June/006562.html,
> Goldwyn try to reduce our size by just
> moving the postion of some fields, so I think we should save these
> memory for the kernel. :)

	Goldwyn's work is important because we have hundreds of
thousands of each thing.  We have very few system inodes.

Joel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
