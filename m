From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 6 Jan 2009 11:02:45 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Optimize inode allocation by
	remembering last group.
In-Reply-To: <1227826725-13107-1-git-send-email-tao.ma@oracle.com>
References: <492F946F.1060409@oracle.com>
	<1227826725-13107-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090106190245.GQ17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 28, 2008 at 06:58:43AM +0800, Tao Ma wrote:
> In ocfs2, the inode block search looks for the "emptiest" inode
> group to allocate from. So if an inode alloc file has many equally
> (or almost equally) empty groups, new inodes will tend to get
> spread out amongst them, which in turn can put them all over the
> disk. This is undesirable because directory operations on conceptually
> "nearby" inodes force a large number of seeks.
> 
> The good thing is that in ocfs2_alloc_context, there is a field named
> ac_last_group which will record the last group we allocate from. So
> we can only pass the right group to it and the following allocation
> will do as what we expect.
> 
> So we add ip_last_used_group in core directory inodes which records
> the last used allocation group. Another field named ip_last_used_slot
> is also added in case inode stealing happens. When claiming new inode,
> we passed in directory's inode so that the allocation can use this
> information.
> For more details, please see
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/inode.c    |    2 ++
>  fs/ocfs2/inode.h    |    4 ++++
>  fs/ocfs2/namei.c    |    4 ++--
>  fs/ocfs2/suballoc.c |   21 +++++++++++++++++++++
>  fs/ocfs2/suballoc.h |    2 ++
>  5 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 288512c..c3463c1 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -350,6 +350,8 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
>  
>  	ocfs2_set_inode_flags(inode);
>  
> +	OCFS2_I(inode)->ip_last_used_slot = 0;
> +	OCFS2_I(inode)->ip_last_used_group = 0;
>  	mlog_exit_void();
>  }
>  
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index eb3c302..e1978ac 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -72,6 +72,10 @@ struct ocfs2_inode_info
>  
>  	struct inode			vfs_inode;
>  	struct jbd2_inode		ip_jinode;
> +
> +	/* Only valid if the inode is the dir. */
> +	u32				ip_last_used_slot;
> +	u64				ip_last_used_group;
>  };
>  
>  /*
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 02c8026..a601dd5 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -469,8 +469,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
>  
>  	*new_fe_bh = NULL;
>  
> -	status = ocfs2_claim_new_inode(osb, handle, inode_ac, &suballoc_bit,
> -				       &fe_blkno);
> +	status = ocfs2_claim_new_inode(osb, handle, dir, parent_fe_bh,
> +				       inode_ac, &suballoc_bit, &fe_blkno);
>  	if (status < 0) {
>  		mlog_errno(status);
>  		goto leave;
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 226fe21..f75782f 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1587,6 +1587,8 @@ bail:
>  
>  int ocfs2_claim_new_inode(struct ocfs2_super *osb,
>  			  handle_t *handle,
> +			  struct inode *dir,
> +			  struct buffer_head *parent_fe_bh,
>  			  struct ocfs2_alloc_context *ac,
>  			  u16 *suballoc_bit,
>  			  u64 *fe_blkno)
> @@ -1594,6 +1596,8 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
>  	int status;
>  	unsigned int num_bits;
>  	u64 bg_blkno;
> +	struct ocfs2_dinode *parent_fe =
> +			(struct ocfs2_dinode *)parent_fe_bh->b_data;
>  
>  	mlog_entry_void();
>  
> @@ -1602,6 +1606,21 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
>  	BUG_ON(ac->ac_bits_wanted != 1);
>  	BUG_ON(ac->ac_which != OCFS2_AC_USE_INODE);
>  
> +	/*
> +	 * Try to allocate inodes from some specific group.
> +	 *
> +	 * If the parent dir has recorded the last group used in allocation,
> +	 * cool, use it. Otherwise if we try to allocate new inode from the
> +	 * same slot the parent dir belongs to, use the same chunk.
> +	 */
> +	if (OCFS2_I(dir)->ip_last_used_group &&
> +	    OCFS2_I(dir)->ip_last_used_slot == ac->ac_alloc_slot)
> +		ac->ac_last_group = OCFS2_I(dir)->ip_last_used_group;
> +	else if (le16_to_cpu(parent_fe->i_suballoc_slot) ==
> +		 ac->ac_alloc_slot)
> +		ac->ac_last_group = le64_to_cpu(parent_fe->i_blkno) -
> +				    le16_to_cpu(parent_fe->i_suballoc_bit);

You should use ocfs2_which_suballoc_group() here, instead of open coding the
math to get ac_last_group.

Also, would it be possible for us to put this block in it's own function so
that it's easier to play with the logic in the future?


One last thing - can you add to the comment:

*
* We are very careful here to avoid the mistake of setting ac_last_group to
* a group descriptor from a different (unlocked) slot.
*/
	--Mark

--
Mark Fasheh
