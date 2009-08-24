From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Aug 2009 11:32:07 -0700
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <1251126399-8296-1-git-send-email-tao.ma@oracle.com>
References: <20090821234210.GH4330@mail.oracle.com>
	<1251126399-8296-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090824183207.GB7698@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 24, 2009 at 11:06:39PM +0800, Tao Ma wrote:
> @@ -1449,6 +1452,9 @@ static int ocfs2_populate_write_desc(struct inode *inode,
>  				goto out;
>  			}
>  
> +			/* We should already CoW the refcountd extent. */
> +			BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);
> +
>  			/*
>  			 * Assume worst case - that we're writing in
>  			 * the middle of the extent.

	What is this patch against?  I don't see the removal of the
refcounted_cpos lines.

> +	if (ocfs2_refcount_tree(OCFS2_SB(inode->i_sb))) {
> +		ret = ocfs2_refcount_cow(inode, di_bh,
> +					 wc->w_cpos, wc->w_clen);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +	}

	Probably can check (ocfs2_refcount_tree() &&
(OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FLAG)).  Why walk
the tree here if we don't need to? :-)  Actually, why not use
ocfs2_check_range_for_refcount()?

> +static int ocfs2_check_range_for_refcount(struct inode *inode, loff_t pos,
> +					  size_t count)
> +{
> +	int ret = 0;
> +	unsigned int extent_flags;
> +	u32 cpos, clusters, extent_len, phys_cpos;
> +	struct super_block *sb = inode->i_sb;

	And here, check ocfs2_refcount_tree(OCFS2_SB(inode->i_sb) &&
OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL), returning 0 if
not set.

> @@ -1712,6 +1773,22 @@ static int ocfs2_prepare_inode_for_write(struct dentry *dentry,
>  
>  		end = saved_pos + count;
>  
> +		ret = ocfs2_check_range_for_refcount(inode, saved_pos, count);
> +		if (ret == 1) {
> +			ocfs2_inode_unlock(inode, meta_level);
> +			meta_level = -1;
> +
> +			ret = ocfs2_prepare_inode_for_refcount(inode,
> +							       saved_pos,
> +							       count,
> +							       &meta_level);
> +		}

	Because here you didn't check for refcount support.  If
ocfs2_check_range_for_refcount() has that check, then both places
benefit.

Joel

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
