From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 16:54:26 -0800
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Add a name indexed b-tree to
	directory	inodes
In-Reply-To: <1233351753-14640-3-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-3-git-send-email-mfasheh@suse.com>
Message-ID: <20090131005426.GB6155@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:28PM -0800, Mark Fasheh wrote:
> This patch makes use of Ocfs2's flexible btree code to add an additional
> tree to directory inodes. The new tree stores an array of small,
> fixed-length records in each leaf block. Each record stores a hash value,
> and pointer to a block in the traditional (unindexed) directory tree where a
> dirent with the given name hash resides. Lookup exclusively uses this tree
> to find dirents, thus providing us with constant time name lookups.
> 
> Some of the hashing code was copied from ext3. Unfortunately, it has lots of
> unfixed checkpatch errors. I left that as-is so that tracking changes would
> be easier.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

	Big patch to review.  Whew!  But overall it looks very good.
Comments inline.

> +/*
> + * Read the block at 'phys' which belongs to this directory
> + * inode. This function does no virtual->physical block translation -
> + * what's passed in is assumed to be a valid directory block.
> + */
> +static int ocfs2_read_dir_block_direct(struct inode *dir, u64 phys,
> +				       struct buffer_head **bh)
> +{
> +	int ret;
> +	struct buffer_head *tmp = *bh;
> +
> +	ret = ocfs2_read_block(dir, phys, &tmp, ocfs2_validate_dir_block);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_check_dir_trailer(dir, tmp);
> +	if (ret) {
> +		if (!*bh)
> +			brelse(tmp);
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	if (!ret && !*bh)
> +		*bh = tmp;
> +out:
> +	return ret;
> +}

	I think you need the same guard check as ocfs2_read_dir_block():

  	if (!(flags & OCFS2_BH_READAHEAD) &&
  	    ocfs2_dir_has_trailer(inode)) {

because otherwise ocfs2_check_dir_trailer() will run unconditionally.  I
realize that the current code doesn't call ocfs2_read_dir_block_direct()
except in the indexed case, but that's just for now.
	Alternatively, you could BUG_ON(!ocfs2_dir_has_trailer()).

> @@ -1184,6 +1849,8 @@ static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
>   * routine to check that the specified directory is empty (for rmdir)
>   *
>   * Returns 1 if dir is empty, zero otherwise.
> + *
> + * XXX: This is a performance problem
>   */
>  int ocfs2_empty_dir(struct inode *inode)
>  {

	Why can't an indexed directory store the directory's child count
in the dx_root?  That way we can just read the dx_root and
ocfs2_empty_dir() gets much faster.  You already have the dx_root in
memory for all link/unlink operations anyway.
	While we're at it, the two places that call ocfs2_empty_dir()
should reorder their checks.  If they check (i_nlink != 2) first, they
can skip calling ocfs2_empty_dir() altogether when i_nlink has a
subdirectory.

> @@ -1401,29 +2435,57 @@ static void ocfs2_expand_last_dirent(char *start, unsigned int old_size,
>   */
>  static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
>  				   unsigned int blocks_wanted,
> +				   struct ocfs2_dir_lookup_result *lookup,
>  				   struct buffer_head **first_block_bh)
>  {
> -	u32 alloc, bit_off, len;
> +	u32 alloc, dx_alloc, bit_off, len;
>  	struct super_block *sb = dir->i_sb;
> -	int ret, credits = ocfs2_inline_to_extents_credits(sb);
> -	u64 blkno, bytes = blocks_wanted << sb->s_blocksize_bits;
> +	int ret, i, num_dx_leaves = 0,
> +		credits = ocfs2_inline_to_extents_credits(sb);
> +	u64 dx_insert_blkno, blkno,
> +		bytes = blocks_wanted << sb->s_blocksize_bits;
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>  	struct ocfs2_inode_info *oi = OCFS2_I(dir);
>  	struct ocfs2_alloc_context *data_ac;
> +	struct ocfs2_alloc_context *meta_ac = NULL;
>  	struct buffer_head *dirdata_bh = NULL;
> +	struct buffer_head *dx_root_bh = NULL;
> +	struct buffer_head **dx_leaves = NULL;
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  	handle_t *handle;
>  	struct ocfs2_extent_tree et;
> -	int did_quota = 0;
> +	struct ocfs2_extent_tree dx_et;
> +	int did_quota = 0, bytes_allocated = 0;

	Holy bejeezus we have a lot on the stack here?  Can we factor
this function into a couple of subfunctions somewhere?  That said, I
don't think it's needed for the initial merge.  So not right now.

> +int ocfs2_dx_dir_truncate(struct inode *dir, struct buffer_head *di_bh)
> +{
> +	int ret;
> +	unsigned int uninitialized_var(clen);
> +	u32 major_hash = UINT_MAX, p_cpos, uninitialized_var(cpos);

	I suppose I would have used U32_MAX instead of UINT_MAX, just to
match the u32 type, but in the end it is obviously the same value.

Joel

-- 

Life's Little Instruction Book #173

	"Be kinder than necessary."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
