From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 17:45:10 -0700
Subject: [Ocfs2-devel] [PATCH] Reoganize data elements to reduce memory
 footprint
In-Reply-To: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
References: <AANLkTinTCrwXLiCjOm4l7uIzjRSz-17vJLLhNaCMDFJa@mail.gmail.com>
Message-ID: <20100610004509.GA27385@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 09, 2010 at 04:57:11PM -0500, Goldwyn Rodrigues wrote:
> This is the re-arrangement of the data elements of ocfs2 data structures
> to reduce memory consumption as shown by pahole on an x86_64 box.
> I have tried to keep the context as close as possible, though I was
> pretty agressive to get the numbers down.
> 
> Statistics in bytes: (before - after = reduction)
> ocfs2_write_ctxt: 2144 - 2136 = 8
> ocfs2_inode_info: 1960 - 1896 = 64
> ocfs2_journal: 168 - 160 = 8
> ocfs2_lock_res: 336 - 320 = 16
> ocfs2_refcount_tree: 512 - 488 = 24

	You should know that these won't actually affect ocfs2's memory
usage yet.  All of our structures come from slabs, so they matter in
multiples as they fit into slabs.  What do I mean?  When
ocfs2_inode_info was 1960 bytes, you could fit two of them into a 4K
page.  Now that you've made it 1896 bytes, you can still only fit two of
them into a 4K page.  So you're still using the same number of pages.
	However, every step we take to reducing the sizes gets us closer
to actual memory improvements.  As an example, your change to
ocfs2_lock_res reduces ocfs2_dentry_lock from 356 to 340 bytes on
32-bit.  If we had a slab for dentry locks, that would go from 11 locks
per slab to 12.  Currently, though, we get them from kmalloc().  Because
kmalloc() allocates in power-of-two chunks, we're using 512 byte
allocations for all of our dentry locks.  So a next step is to get
dentry locks out to their own slab.  Move the dl_count field to the end
of the structure and you can pack 12 of them on 64-bit too.  On top of
your changes here, you would get a 50% usage improvement over the
kmalloc() version (8 per kmalloc page to 12 per slab page).

> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index c67003b..34b9c79 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -151,17 +151,16 @@ struct ocfs2_lock_res {
>  	void                    *l_priv;
>  	struct ocfs2_lock_res_ops *l_ops;
>  	spinlock_t               l_lock;
> +	enum ocfs2_lock_type     l_type;

	I think you should change l_type, l_action, l_requested,
l_blocking, and l_level to unsigned char.  While the enums that set them
should be not modified, they do not have more than 256 values.  All the
functions around them can use the enum type in their arguments.  Just
the ocfs2_lock_res itself stores them in unsigned char.
	This would potentially save us 15 bytes per ocfs2_lock_res,
45 per inode.  More realistic is probably 12 per lock_res and 36 per
inode, but still!
	Here's the thing - we have more inodes and dentries than
anything else in memory, at least as far as the filesystem is concerned.
Those are big wins.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
