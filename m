From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Sep 20 16:48:17 2007
Subject: [Ocfs2-devel] [PATCH 14/15] ocfs2: Read support for
	directories with inline data
In-Reply-To: <200709192012.l8JKCHo9029366@rgmgw2.us.oracle.com>
References: <200709192012.l8JKCHo9029366@rgmgw2.us.oracle.com>
Message-ID: <20070920234740.GF3490@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 12, 2007 at 01:01:18PM -0700, Mark Fasheh wrote:
> +static int ocfs2_dir_foreach_blk_id(struct inode *inode,
> +				    unsigned long *f_version,
> +				    loff_t *f_pos, void *priv,
> +				    filldir_t filldir)
> +{

	Isn't this function basically the center of foreach_blk_el()?
Is there any way to consolidate that?

Joel

> +	int ret, i, filldir_ret;
> +	unsigned long offset = *f_pos;
> +	struct buffer_head *di_bh = NULL;
> +	struct ocfs2_dinode *di;
> +	struct ocfs2_inline_data *data;
> +	struct ocfs2_dir_entry *de;
> +
> +	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), OCFS2_I(inode)->ip_blkno,
> +			       &di_bh, OCFS2_BH_CACHED, inode);
> +	if (ret) {
> +		mlog(ML_ERROR, "Unable to read inode block for dir %llu\n",
> +		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		goto out;
> +	}
> +
> +	di = (struct ocfs2_dinode *)di_bh->b_data;
> +	data = &di->id2.i_data;
> +
> +	while (*f_pos < i_size_read(inode)) {
> +revalidate:
> +		/* If the dir block has changed since the last call to
> +		 * readdir(2), then we might be pointing to an invalid
> +		 * dirent right now.  Scan from the start of the block
> +		 * to make sure. */
> +		if (*f_version != inode->i_version) {
> +			for (i = 0; i < i_size_read(inode) && i < offset; ) {
> +				de = (struct ocfs2_dir_entry *)
> +					(data->id_data + i);
> +				/* It's too expensive to do a full
> +				 * dirent test each time round this
> +				 * loop, but we do have to test at
> +				 * least that it is non-zero.  A
> +				 * failure will be detected in the
> +				 * dirent test below. */
> +				if (le16_to_cpu(de->rec_len) <
> +				    OCFS2_DIR_REC_LEN(1))
> +					break;
> +				i += le16_to_cpu(de->rec_len);
> +			}
> +			*f_pos = offset = i;
> +			*f_version = inode->i_version;
> +		}
> +
> +		de = (struct ocfs2_dir_entry *) (data->id_data + *f_pos);
> +		if (!ocfs2_check_dir_entry(inode, de, di_bh, *f_pos)) {
> +			/* On error, skip the f_pos to the end. */
> +			*f_pos = i_size_read(inode);
> +			goto out;
> +		}
> +		offset += le16_to_cpu(de->rec_len);
> +		if (le64_to_cpu(de->inode)) {
> +			/* We might block in the next section
> +			 * if the data destination is
> +			 * currently swapped out.  So, use a
> +			 * version stamp to detect whether or
> +			 * not the directory has been modified
> +			 * during the copy operation.
> +			 */
> +			unsigned long version = *f_version;
> +			unsigned char d_type = DT_UNKNOWN;
> +
> +			if (de->file_type < OCFS2_FT_MAX)
> +				d_type = ocfs2_filetype_table[de->file_type];
> +
> +			filldir_ret = filldir(priv, de->name,
> +					      de->name_len,
> +					      *f_pos,
> +					      le64_to_cpu(de->inode),
> +					      d_type);
> +			if (filldir_ret)
> +				break;
> +			if (version != *f_version)
> +				goto revalidate;
> +		}
> +		*f_pos += le16_to_cpu(de->rec_len);
> +	}
> +
> +out:
> +	brelse(di_bh);
> +
> +	return 0;
> +}

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
