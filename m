From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 6 Nov 2008 16:11:12 -0800
Subject: [Ocfs2-devel] [PATCH 04/15] ocfs2/xattr: Reserve meta/data at
	the beginning of ocfs2_xattr_set.
In-Reply-To: <1225345335-11527-4-git-send-email-tao.ma@oracle.com>
References: <49099B13.9030802@oracle.com>
	<1225345335-11527-4-git-send-email-tao.ma@oracle.com>
Message-ID: <20081107001111.GE15154@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 30, 2008 at 01:42:14PM +0800, Tao Ma wrote:

> @@ -1548,6 +1528,11 @@ static int ocfs2_remove_value_outside(struct inode*inode,
>  				      struct ocfs2_xattr_header *header)
>  {
>  	int ret = 0, i;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_xattr_set_ctxt ctxt;
> +
> +	memset(&ctxt, 0, sizeof(ctxt));
> +	ocfs2_init_dealloc_ctxt(&ctxt.dealloc);


You can lose the memset if you just do:

	struct ocfs2_xattr_set_ctxt ctxt = { NULL, };

>  
>  	for (i = 0; i < le16_to_cpu(header->xh_count); i++) {
>  		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];


> +static int ocfs2_init_xattr_set_ctxt(struct inode *inode,
> +				     struct ocfs2_dinode *di,
> +				     struct ocfs2_xattr_info *xi,
> +				     struct ocfs2_xattr_search *xis,
> +				     struct ocfs2_xattr_search *xbs,
> +				     struct ocfs2_xattr_set_ctxt *ctxt)
> +{

This function looks suspiciously like ocfs2_lock_allocators()... That said,
I think it's probably fine to leave it on it's own for now ;)


> +	int clusters_add, meta_add, ret;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	memset(ctxt, 0, sizeof(struct ocfs2_xattr_set_ctxt));
> +
> +	ocfs2_init_dealloc_ctxt(&ctxt->dealloc);
> +
> +	ret = ocfs2_calc_xattr_set_need(inode, di, xi, xis, xbs,
> +					&clusters_add, &meta_add);
> +	if (ret) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +
> +	mlog(0, "Set xattr %s, reserve meta blocks = %d, clusters = %d\n",
> +	     xi->name, meta_add, clusters_add);
> +
> +	if (meta_add) {
> +		ret = ocfs2_reserve_new_metadata_blocks(osb, meta_add,
> +							&ctxt->meta_ac);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +	}


> @@ -2146,10 +2377,18 @@ int ocfs2_xattr_set(struct inode *inode,
>  				 */
>  				xi.value = NULL;
>  				xi.value_len = 0;
> -				ret = ocfs2_xattr_ibody_set(inode, &xi, &xis);
> +				ret = ocfs2_xattr_ibody_set(inode, &xi,
> +							    &xis, &ctxt);
>  			}
>  		}
>  	}
> +free:
> +	if (ctxt.data_ac)
> +		ocfs2_free_alloc_context(ctxt.data_ac);
> +	if (ctxt.meta_ac)
> +		ocfs2_free_alloc_context(ctxt.meta_ac);
> +	ocfs2_schedule_truncate_log_flush(osb, 1);

Since this is a set function, which only a small part of the time will be
deleteing clusters, I think it would be better not to unconditionally start
a truncate log flush. Maybe you can do that only in the case where we have
clusters to free?
	--Mark

--
Mark Fasheh
