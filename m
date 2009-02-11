From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Feb 2009 10:50:08 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: set xh_free_start when xattr
	header in	inode/block
In-Reply-To: <1234319891-7020-1-git-send-email-tiger.yang@oracle.com>
References: <499238F3.9010208@oracle.com>
	<1234319891-7020-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20090211185007.GJ9512@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 11, 2009 at 10:38:11AM +0800, Tiger Yang wrote:
> This patch update fields about xh_free_start and
> xh_name_value_len when xattr header in inode/block.
> Those fields only be used for bucket before.
> With xh_free_start, we are free to calculate minimum
> offset of xattr name/value.

	The math of the patch is fine, but it doesn't take into account
filesystems in the wild.  xattrs were released with .28, which means
there are filesystems in the wild that have xh_free_start==0.  This
patch removes the old math that calculated offsets without
xh_free_start.  We probably should checking for xh_free_start==0 and
recalculating it.
	The places in this patch and the next patch where you pad the
space with 4 bytes shouldn't use 'sizeof(__u32)'.  Create a #define
(something like OCFS2_XATTR_HEADER_GAP == 4).

Joel

> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/ocfs2_fs.h |    2 +-
>  fs/ocfs2/xattr.c    |  118 ++++++++++++++++++---------------------------------
>  2 files changed, 42 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index c7ae45a..597d047 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -839,7 +839,7 @@ struct ocfs2_xattr_header {
>  	__le16	xh_free_start;                  /* current offset for storing
>  						   xattr. */
>  	__le16	xh_name_value_len;              /* total length of name/value
> -						   length in this bucket. */
> +						   length in this object. */
>  	__le16	xh_num_buckets;                 /* Number of xattr buckets
>  						   in this extent record,
>  						   only valid in the first
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 915039f..ce793af 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -89,6 +89,9 @@ struct ocfs2_xattr_set_ctxt {
>  					 - sizeof(struct ocfs2_xattr_block) \
>  					 - sizeof(struct ocfs2_xattr_header) \
>  					 - sizeof(__u32))
> +#define OCFS2_XATTR_HEADER_SIZE(ptr)	(le16_to_cpu((ptr)->xh_count) \
> +					 * sizeof(struct ocfs2_xattr_entry) \
> +					 + sizeof(struct ocfs2_xattr_header))
>  
>  static struct ocfs2_xattr_def_value_root def_xv = {
>  	.xv.xr_list.l_count = cpu_to_le16(1),
> @@ -1365,8 +1368,7 @@ static int ocfs2_xattr_set_value_outside(struct inode *inode,
>  static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  					struct ocfs2_xattr_info *xi,
>  					struct ocfs2_xattr_search *xs,
> -					struct ocfs2_xattr_entry *last,
> -					size_t min_offs)
> +					struct ocfs2_xattr_entry *last)
>  {
>  	size_t name_len = strlen(xi->name);
>  	int i;
> @@ -1382,7 +1384,7 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  		void *val;
>  		size_t offs, size;
>  
> -		first_val = xs->base + min_offs;
> +		first_val = xs->base + le16_to_cpu(xs->header->xh_free_start);
>  		offs = le16_to_cpu(xs->here->xe_name_offset);
>  		val = xs->base + offs;
>  
> @@ -1417,7 +1419,8 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  		ocfs2_xattr_set_local(xs->here, 1);
>  		xs->here->xe_value_size = 0;
>  
> -		min_offs += size;
> +		le16_add_cpu(&xs->header->xh_free_start, size);
> +		le16_add_cpu(&xs->header->xh_name_value_len, -size);
>  
>  		/* Adjust all value offsets. */
>  		last = xs->header->xh_entries;
> @@ -1440,11 +1443,14 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  	}
>  	if (xi->value) {
>  		/* Insert the new name+value. */
> +		void *val;
>  		size_t size = OCFS2_XATTR_SIZE(name_len) +
>  				OCFS2_XATTR_SIZE(xi->value_len);
> -		void *val = xs->base + min_offs - size;
>  
> -		xs->here->xe_name_offset = cpu_to_le16(min_offs - size);
> +		le16_add_cpu(&xs->header->xh_free_start, -size);
> +		le16_add_cpu(&xs->header->xh_name_value_len, size);
> +		val = xs->base + le16_to_cpu(xs->header->xh_free_start);
> +		xs->here->xe_name_offset = xs->header->xh_free_start;
>  		memset(val, 0, size);
>  		memcpy(val, xi->name, name_len);
>  		memcpy(val + OCFS2_XATTR_SIZE(name_len),
> @@ -1476,10 +1482,10 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  	struct ocfs2_xattr_entry *last;
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)xs->inode_bh->b_data;
> -	size_t min_offs = xs->end - xs->base, name_len = strlen(xi->name);
> +	size_t name_len = strlen(xi->name);
>  	size_t size_l = 0;
>  	handle_t *handle = ctxt->handle;
> -	int free, i, ret;
> +	int free, ret;
>  	struct ocfs2_xattr_info xi_l = {
>  		.name_index = xi->name_index,
>  		.name = xi->name,
> @@ -1497,17 +1503,10 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  	} else
>  		BUG_ON(xs->xattr_bh != xs->inode_bh);
>  
> -	/* Compute min_offs, last and free space. */
> -	last = xs->header->xh_entries;
> -
> -	for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
> -		size_t offs = le16_to_cpu(last->xe_name_offset);
> -		if (offs < min_offs)
> -			min_offs = offs;
> -		last += 1;
> -	}
> -
> -	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
> +	/* Compute last entry and free space. */
> +	last = &xs->header->xh_entries[le16_to_cpu(xs->header->xh_count)];
> +	free = le16_to_cpu(xs->header->xh_free_start) -
> +		OCFS2_XATTR_HEADER_SIZE(xs->header) - sizeof(__u32);
>  	if (free < 0)
>  		return -EIO;
>  
> @@ -1522,22 +1521,17 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  		free += (size + sizeof(struct ocfs2_xattr_entry));
>  	}
>  	/* Check free space in inode or block */
> -	if (xi->value && xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
> -		if (free < sizeof(struct ocfs2_xattr_entry) +
> -			   OCFS2_XATTR_SIZE(name_len) +
> -			   OCFS2_XATTR_ROOT_SIZE) {
> +	if (xi->value) {
> +		if (ocfs2_xattr_entry_real_size(name_len,
> +						xi->value_len) > free) {
>  			ret = -ENOSPC;
>  			goto out;
>  		}
> -		size_l = OCFS2_XATTR_SIZE(name_len) + OCFS2_XATTR_ROOT_SIZE;
> -		xi_l.value = (void *)&def_xv;
> -		xi_l.value_len = OCFS2_XATTR_ROOT_SIZE;
> -	} else if (xi->value) {
> -		if (free < sizeof(struct ocfs2_xattr_entry) +
> -			   OCFS2_XATTR_SIZE(name_len) +
> -			   OCFS2_XATTR_SIZE(xi->value_len)) {
> -			ret = -ENOSPC;
> -			goto out;
> +		if (xi->value_len > OCFS2_XATTR_INLINE_SIZE) {
> +			size_l = OCFS2_XATTR_SIZE(name_len) +
> +				 OCFS2_XATTR_ROOT_SIZE;
> +			xi_l.value = (void *)&def_xv;
> +			xi_l.value_len = OCFS2_XATTR_ROOT_SIZE;
>  		}
>  	}
>  
> @@ -1629,7 +1623,7 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
>  	 * Set value in local, include set tree root in local.
>  	 * This is the first step for value size >INLINE_SIZE.
>  	 */
> -	ocfs2_xattr_set_entry_local(inode, &xi_l, xs, last, min_offs);
> +	ocfs2_xattr_set_entry_local(inode, &xi_l, xs, last);
>  
>  	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
>  		ret = ocfs2_journal_dirty(handle, xs->xattr_bh);
> @@ -1973,9 +1967,12 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
>  	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
>  		xs->header = (struct ocfs2_xattr_header *)
>  			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
> -	else
> +	else {
>  		xs->header = (struct ocfs2_xattr_header *)
>  			(xs->end - OCFS2_SB(inode->i_sb)->s_xattr_inline_size);
> +		xs->header->xh_free_start = cpu_to_le16(
> +				OCFS2_SB(inode->i_sb)->s_xattr_inline_size);
> +	}
>  	xs->base = (void *)xs->header;
>  	xs->here = xs->header->xh_entries;
>  
> @@ -2138,6 +2135,8 @@ static int ocfs2_xattr_block_set(struct inode *inode,
>  		xs->base = (void *)xs->header;
>  		xs->end = (void *)xblk + inode->i_sb->s_blocksize;
>  		xs->here = xs->header->xh_entries;
> +		xblk->xb_attrs.xb_header.xh_free_start =
> +					cpu_to_le16(xs->end - xs->base);
>  
>  		ret = ocfs2_journal_dirty(handle, new_bh);
>  		if (ret < 0) {
> @@ -2168,46 +2167,6 @@ end:
>  	return ret;
>  }
>  
> -/* Check whether the new xattr can be inserted into the inode. */
> -static int ocfs2_xattr_can_be_in_inode(struct inode *inode,
> -				       struct ocfs2_xattr_info *xi,
> -				       struct ocfs2_xattr_search *xs)
> -{
> -	u64 value_size;
> -	struct ocfs2_xattr_entry *last;
> -	int free, i;
> -	size_t min_offs = xs->end - xs->base;
> -
> -	if (!xs->header)
> -		return 0;
> -
> -	last = xs->header->xh_entries;
> -
> -	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
> -		size_t offs = le16_to_cpu(last->xe_name_offset);
> -		if (offs < min_offs)
> -			min_offs = offs;
> -		last += 1;
> -	}
> -
> -	free = min_offs - ((void *)last - xs->base) - sizeof(__u32);
> -	if (free < 0)
> -		return 0;
> -
> -	BUG_ON(!xs->not_found);
> -
> -	if (xi->value_len > OCFS2_XATTR_INLINE_SIZE)
> -		value_size = OCFS2_XATTR_ROOT_SIZE;
> -	else
> -		value_size = OCFS2_XATTR_SIZE(xi->value_len);
> -
> -	if (free >= sizeof(struct ocfs2_xattr_entry) +
> -		   OCFS2_XATTR_SIZE(strlen(xi->name)) + value_size)
> -		return 1;
> -
> -	return 0;
> -}
> -
>  static int ocfs2_calc_xattr_set_need(struct inode *inode,
>  				     struct ocfs2_dinode *di,
>  				     struct ocfs2_xattr_info *xi,
> @@ -2303,7 +2262,13 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
>  		 * one will be removed from the xattr block, and this xattr
>  		 * will be inserted into inode as a new xattr in inode.
>  		 */
> -		if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
> +		int free = le16_to_cpu(xis->header->xh_free_start) -
> +			   OCFS2_XATTR_HEADER_SIZE(xis->header) -
> +			   sizeof(__u32);
> +		int size = ocfs2_xattr_entry_real_size(strlen(xi->name),
> +						       xi->value_len);
> +
> +		if (size <= free) {
>  			clusters_add += new_clusters;
>  			credits += ocfs2_remove_extent_credits(inode->i_sb) +
>  				    OCFS2_INODE_UPDATE_CREDITS;
> @@ -5058,8 +5023,7 @@ try_again:
>  	xh = xs->header;
>  	count = le16_to_cpu(xh->xh_count);
>  	xh_free_start = le16_to_cpu(xh->xh_free_start);
> -	header_size = sizeof(struct ocfs2_xattr_header) +
> -			count * sizeof(struct ocfs2_xattr_entry);
> +	header_size = OCFS2_XATTR_HEADER_SIZE(xh);
>  	max_free = OCFS2_XATTR_BUCKET_SIZE -
>  		le16_to_cpu(xh->xh_name_value_len) - header_size;
>  
> -- 
> 1.5.4.1
> 

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our overnment."
	- Sissy Farenthold

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
