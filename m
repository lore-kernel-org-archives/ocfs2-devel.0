From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Jun 2008 16:32:21 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
	support. v1
In-Reply-To: <1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20080617233221.GD28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, this more or less completes my review of this patch for this version of
the changes.

On Thu, Jun 05, 2008 at 03:24:54PM +0800, Tiger Yang wrote:
> index c223ab0..ed07448 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -21,6 +21,19 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#include <linux/capability.h>
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/highmem.h>
> +#include <linux/pagemap.h>
> +#include <linux/uio.h>
> +#include <linux/sched.h>
> +#include <linux/splice.h>
> +#include <linux/mount.h>
> +#include <linux/writeback.h>
> +#include <linux/falloc.h>
> +
>  #define MLOG_MASK_PREFIX ML_INODE

How about adding a new prefix, ML_XATTR? That would make debugging a bit
easier.


> +static int ocfs2_xattr_block_list(struct inode *inode,
> +				  struct ocfs2_dinode *di,
> +				  char *buffer,
> +				  size_t buffer_size)
> +{
> +	struct buffer_head *blk_bh = NULL;
> +	struct ocfs2_xattr_header *header = NULL;
> +	int ret = 0;
> +
> +	if (!di->i_xattr_loc)
> +		return ret;
> +	else {
> +		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb),
> +				       le64_to_cpu(di->i_xattr_loc),
> +				       &blk_bh, OCFS2_BH_CACHED, inode);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	header = &((struct ocfs2_xattr_block *)blk_bh->b_data)->
> +		 xb_attrs.xb_header;

Any reason why we don't do any signature checks of the newly read block
before proceeding here?


> +static int ocfs2_xattr_set_entry(struct inode *inode,
> +				 struct ocfs2_xattr_info *xi,
> +				 struct ocfs2_xattr_search *xs)
> +{

Hmm, some comments describing this function would be helpfull. In
particular, I'd like to know how failure in the middle of an operation is
handled. Say you're expanding the ea because the user asked to store a
larger size, but you hit a problem shortly after growing it. What happens?


> +	struct ocfs2_xattr_entry *last;
> +	size_t free, min_offs = xs->end - xs->base, name_len = strlen(xi->name);
> +	size_t size_l = 0;
> +	handle_t *handle = NULL;
> +	int i, ret;
> +	struct ocfs2_xattr_info xi_l = {
> +		.name_index = xi->name_index,
> +		.name = xi->name,
> +		.value = xi->value,
> +		.value_len = xi->value_len,
> +	};
> +
> +	/* Compute min_offs and last. */
> +	last = xs->header->xh_entries;
> +
> +	for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
> +		size_t offs = le16_to_cpu(last->xe_name_offset);
> +		if (offs < min_offs)
> +			min_offs = offs;
> +		last += 1;
> +	}
> +
> +	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
> +
> +	if (!xs->not_found) {
> +		size_t size = 0;
> +		if (xs->here->xe_local)
> +			size = OCFS2_XATTR_SIZE(name_len) +
> +			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
> +		else
> +			size = OCFS2_XATTR_SIZE(name_len) +
> +				OCFS2_XATTR_ROOT_SIZE;
> +		free += (size + sizeof(struct ocfs2_xattr_entry));
> +	}
> +	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
> +		if (free < sizeof(struct ocfs2_xattr_entry) +
> +			   OCFS2_XATTR_SIZE(name_len) +
> +			   OCFS2_XATTR_ROOT_SIZE) {
> +			ret = -ENOSPC;
> +			goto out;
> +		}
> +		size_l = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
> +		xi_l.value = (void *)&def_xv;
> +		xi_l.value_len = OCFS2_XATTR_ROOT_SIZE;
> +	} else if (xi->value) {
> +		if (free < sizeof(struct ocfs2_xattr_entry) +
> +			   OCFS2_XATTR_SIZE(name_len) +
> +			   OCFS2_XATTR_SIZE(xi->value_len)) {
> +			ret = -ENOSPC;
> +			goto out;
> +		}
> +	}
> +
> +	if (!xs->not_found) {
> +		size_t size = OCFS2_XATTR_SIZE(name_len) +
> +			OCFS2_XATTR_SIZE(le64_to_cpu(xs->here->xe_value_size));
> +		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
> +		void *val = xs->base + offs;
> +
> +		if (xs->here->xe_local && size == size_l) {
> +			ret = ocfs2_xattr_set_value_outside(inode, xi, xs,
> +							    offs);
> +			goto out;
> +		} else if (!xs->here->xe_local) {
> +			struct ocfs2_xattr_value_root *xv = NULL;
> +			xv = (struct ocfs2_xattr_value_root *)(val +
> +				OCFS2_XATTR_SIZE(name_len));
> +
> +			if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
> +				ret = ocfs2_xattr_value_truncate(inode,
> +								 xs->xattr_bh,
> +								 xv,
> +								 xi->value_len);
> +				if (ret < 0)
> +					goto out;
> +
> +				ret = __ocfs2_xattr_set_value_outside(inode,
> +								xv,
> +								xi->value,
> +								xi->value_len);
> +				if (ret < 0)
> +					goto out;
> +
> +				ret = ocfs2_xattr_update_entry(inode,
> +							       xi,
> +							       xs,
> +							       offs);
> +				goto out;
> +			} else
> +				ret = ocfs2_xattr_value_truncate(inode,
> +								 xs->xattr_bh,
> +								 xv,
> +								 0);
> +		}
> +	}
> +
> +	handle = ocfs2_start_trans((OCFS2_SB(inode->i_sb)),
> +				   OCFS2_INODE_UPDATE_CREDITS);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out;
> +	}
> +
> +	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
> +				   OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
> +	ocfs2_xattr_set_entry_local(inode, &xi_l, xs, last, min_offs);
> +
> +	ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
> +	if (ret < 0)
> +		mlog_errno(ret);
> +

What are the atime/mtime/ctime semantics of xattr updates? I don't see any
handling of that here. I think at the very least we want to update ctime on
changes.



> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index debde62..0732a00 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -77,6 +77,11 @@ struct ocfs2_xattr_tree_root {
>  /*10*/	struct ocfs2_extent_list	xt_list;
>  };
>  
> +struct ocfs2_xattr_def_value_root {
> +	struct ocfs2_xattr_value_root	xv;
> +	struct ocfs2_extent_rec		er;
> +};
> +
>  #define OCFS2_XATTR_INDEXED 0x1
>  
>  struct ocfs2_xattr_block {
> @@ -95,4 +100,26 @@ struct ocfs2_xattr_block {
>  	} xb_attrs;
>  };
>  
> +extern struct xattr_handler ocfs2_xattr_user_handler;
> +extern struct xattr_handler ocfs2_xattr_trusted_handler;
> +#ifdef CONFIG_OCFS2_FS_POSIX_ACL
> +extern struct xattr_handler ocfs2_xattr_acl_access_handler;
> +extern struct xattr_handler ocfs2_xattr_acl_default_handler;
> +#endif
> +#ifdef CONFIG_OCFS2_FS_LUSTRE
> +extern struct xattr_handler ocfs2_xattr_lustre_handler;
> +#endif

Drop the lustre prefix from these patches. It's just something that
ext3/ext4 need to care about.

Speaking of ext3/ext4 - it's clear that some of this code was inspired or
copied from them. That's a good thing as it's well tested code, but you need
to make sure to give them proper credit at the top of the C files in
question.
	--Mark

--
Mark Fasheh
