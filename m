From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 Jul 2011 02:22:11 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Disable indexing for directory with
	corrupt index
In-Reply-To: <BANLkTimpmS9GKwCvzBdswkzcaAY5YiugSw@mail.gmail.com>
References: <BANLkTimpmS9GKwCvzBdswkzcaAY5YiugSw@mail.gmail.com>
Message-ID: <20110728092210.GD9495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 15, 2011 at 10:57:54AM -0500, Goldwyn Rodrigues wrote:
> Introduces ocfs2_dx_disable() to disable the index of a directory.
> This function is called when a index directory is encountered.
> Calling function must try and revert to regular directory handling,
> instead of using indexes, in order to complete the operation.
> 
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

Hey Goldwyn,
	I like the idea of this.  I have a few comments.

> @@ -649,9 +649,9 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
>  	}
> 
>  	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
> -		ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s",
> -			    7, dx_leaf->dl_signature);
> -		return -EROFS;
> +		mlog(ML_ERROR, "Dir Index Leaf has bad signature %.*s",
> +				7, dx_leaf->dl_signature);
> +		return -EINVAL;

	The meta_ecc validation functions return -EIO.  Perhaps we
should do the same?  -EIO signifies an attempt to continue.

> +static void ocfs2_dx_disable(struct inode *dir, struct buffer_head *di_bh)
> +{
> +	struct ocfs2_inode_info *oi = OCFS2_I(dir);
> +	struct ocfs2_dinode *di;
> +	if (!di_bh) {
> +		mlog(ML_ERROR, "Index directory corruption but unable "
> +			"to disable dx_dir for <%llu>. Please execute "
> +			"fsck.ocfs2\n",	OCFS2_I(dir)->ip_blkno);
> +		return;
> +	}
> +	di = (struct ocfs2_dinode *)di_bh->b_data;
> +	BUG_ON(di->i_blkno != oi->ip_blkno);
> +	mlog(ML_ERROR, "Disabling index for directory <%llu> due to"
> +		" corruption. Please execute fsck.ocfs2\n", oi->ip_blkno);

	Please match the indentation to the open parenthesis.

> +	oi->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
> +	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
> +	di->i_dx_root = cpu_to_le64(0ULL);
> +}
> +
> +
>  /*
>   * Try to find an entry of the provided name within 'dir'.
>   *
> @@ -4364,11 +4392,17 @@ int ocfs2_prepare_dir_for_insert(struct
> ocfs2_super *osb,
>  	if (ocfs2_dir_indexed(dir)) {
>  		ret = ocfs2_prepare_dx_dir_for_insert(dir, parent_fe_bh,
>  						      name, namelen, lookup);
> -		if (ret)
> +		if (ret == -EINVAL) {
> +			ocfs2_dx_disable(dir, parent_fe_bh);
> +			/* Reset ret */
> +			ret = 0;
> +			goto no_index;
> +		} else if (ret)
>  			mlog_errno(ret);

	See here, you'll disable the index on a bad signature, but you
error when ECC fails.  You should disable the index on both cases.  I
say you return -EIO as I described above, and then disable when ret ==
-EIO.  Yes, we might disable the index upon an actual read error, but
that's OK.  We can rebuild it later.

Joel

-- 

"Also, all of life's big problems include the words 'indictment' or
	'inoperable.' Everything else is small stuff."
	- Alton Brown

			http://www.jlbec.org/
			jlbec at evilplan.org
