From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 15 Jul 2008 14:28:03 -0700
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
	support v2
In-Reply-To: <1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080715212803.GF28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 03:27:35PM +0800, Tiger Yang wrote:
> +/*
> + * ocfs2_xattr_set()
> + *
> + * Set, replace or remove an extended attribute for this inode.
> + * value is NULL to remove an existing extended attribute, else either
> + * create or replace an extended attribute.
> + */
> +int ocfs2_xattr_set(struct inode *inode,
> +		    int name_index,
> +		    const char *name,
> +		    const void *value,
> +		    size_t value_len,
> +		    int flags)
> +{
> +	struct buffer_head *di_bh = NULL;
> +	struct ocfs2_dinode *di;
> +	int ret;
> +
> +	struct ocfs2_xattr_info xi = {
> +		.name_index = name_index,
> +		.name = name,
> +		.value = value,
> +		.value_len = value_len,
> +	};
> +
> +	struct ocfs2_xattr_search xis = {
> +		.not_found = -ENODATA,
> +	};
> +
> +	struct ocfs2_xattr_search xbs = {
> +		.not_found = -ENODATA,
> +	};
> +
> +	ret = ocfs2_inode_lock(inode, &di_bh, 1);
> +	if (ret < 0) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +	xis.inode_bh = xbs.inode_bh = di_bh;
> +	di = (struct ocfs2_dinode *)di_bh->b_data;
> +
> +
> +	/*
> +	 * Scan inode and external block to find the same name
> +	 * extended attribute and collect search infomation.
> +	 */
> +	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
> +	if (ret)
> +		goto cleanup;
> +	if (xis.not_found) {
> +		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
> +		if (ret)
> +			goto cleanup;
> +	}
> +
> +	if (xis.not_found && xbs.not_found) {
> +		ret = -ENODATA;
> +		if (flags & XATTR_REPLACE)
> +			goto cleanup;
> +		ret = 0;
> +		if (!value)
> +		goto cleanup;

Btw, your indentation here needs fixing.
	--Mark

--
Mark Fasheh
