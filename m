From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 6 Jan 2009 13:23:32 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Optimize inode group
	allocation by recording last used group.
In-Reply-To: <1227826725-13107-3-git-send-email-tao.ma@oracle.com>
References: <492F946F.1060409@oracle.com>
	<1227826725-13107-3-git-send-email-tao.ma@oracle.com>
Message-ID: <20090106212332.GS17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 28, 2008 at 06:58:45AM +0800, Tao Ma wrote:
> In ocfs2, the block group search looks for the "emptiest" group
> to allocate from. So if the allocator has many equally(or almost
> equally) empty groups, new block group will tend to get spread
> out amongst them.
> 
> We add osb_last_alloc_group in ocfs2_super to record the last used
> allocation group so that next time we can allocate inode group
> directly from it.
> For more details, please see
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/ocfs2.h    |    3 +++
>  fs/ocfs2/suballoc.c |   18 +++++++++++++++++-
>  fs/ocfs2/super.c    |    1 +
>  3 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 5c77798..a99b53e 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -335,6 +335,9 @@ struct ocfs2_super
>  	struct ocfs2_node_map		osb_recovering_orphan_dirs;
>  	unsigned int			*osb_orphan_wipes;
>  	wait_queue_head_t		osb_wipe_event;
> +
> +	/* the group we used to allocate inodes. */
> +	u64				osb_last_alloc_group;

Can you give this a name which is more specific to the inode allocators?
That way we can just add another u64 later for the metadata allocators,
should we decide to do the same for them.


>  };
>  
>  #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 98e32b2..3ab1135 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -49,6 +49,7 @@
>  #define NOT_ALLOC_NEW_GROUP		0
>  #define ALLOC_NEW_GROUP			0x1
>  #define ALLOC_NEW_GROUP_FROM_GLOBAL	0x2
> +#define ALLOC_USE_RECORD_GROUP		0x4
>  
>  #define OCFS2_MAX_INODES_TO_STEAL	1024
>  
> @@ -411,6 +412,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> +	if (flags & ALLOC_USE_RECORD_GROUP && osb->osb_last_alloc_group) {
> +		mlog(0, "use old allocation group %llu\n",
> +		     (unsigned long long)osb->osb_last_alloc_group);
> +		ac->ac_last_group = osb->osb_last_alloc_group;
> +	}
>  	status = ocfs2_claim_clusters(osb,
>  				      handle,
>  				      ac,
> @@ -485,6 +491,15 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
>  
>  	status = 0;
> +
> +	if (flags & ALLOC_USE_RECORD_GROUP) {
> +		spin_lock(&osb->osb_lock);
> +		osb->osb_last_alloc_group = ac->ac_last_group;
> +		spin_unlock(&osb->osb_lock);
> +		mlog(0, "after reservation, new allocation group is "
> +		     "%llu\n", (unsigned long long)osb->osb_last_alloc_group);
> +	}
> +

How about we instead add a u64 * argument to ocfs2_block_group_alloc() and
ocfs2_reserve_suballoc_bits(). Inside ocfs2_block_group_alloc, we'd test for
it to be non-null before using it. That way, any other allocator code which
wants to use this mechanism only has to modify a function parameter. If
you'd rather test for the flag instead of non-null, that's ok too so long as
the end result is the same - new users just have to modify their parameters to
ocfs2_reserve_suballoc_bits().


> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index bc43138..3593759 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -843,6 +843,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	osb->osb_commit_interval = parsed_options.commit_interval;
>  	osb->local_alloc_default_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
>  	osb->local_alloc_bits = osb->local_alloc_default_bits;
> +	osb->osb_last_alloc_group = 0;

Won't this already be zero'd for us by ocfs2_initialize_super()?
	--Mark

--
Mark Fasheh
