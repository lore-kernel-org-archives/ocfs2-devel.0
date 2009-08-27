From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 27 Aug 2009 15:48:19 +0800
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <1250711679-12441-2-git-send-email-joel.becker@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
	<1250711679-12441-2-git-send-email-joel.becker@oracle.com>
Message-ID: <4A963A43.70009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> The ocfs2 extended attribute (xattr) code is very flexible.  It can
> store xattrs in the inode itself, in an external block, or in a tree of
> data structures.  This allows the number of xattrs to be bounded by the
> filesystem size.
> 
> However, the code that manages each possible storage location is
> different.  Maintaining the ocfs2 xattr code requires changing each hunk
> separately.
> 
> This patch is the start of a series introducing the ocfs2_xa_loc
> structure.  This structure wraps the on-disk details of an xattr
> entry.  The goal is that the generic xattr routines can use
> ocfs2_xa_loc without knowing the underlying storage location.
> 
> This first pass merely implements the basic structure, initializing it,
> and wiping the name+value pair of the entry.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  243 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 228 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index d1a27cd..953cf32 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -140,6 +140,51 @@ struct ocfs2_xattr_search {
>  	int not_found;
>  };
<snip>
> +static void ocfs2_xa_bucket_wipe_namevalue(struct ocfs2_xa_loc *loc)
> +{
> +	int namevalue_size;
> +	struct ocfs2_xattr_entry *entry = loc->xl_entry;
> +	u64 value_size = le64_to_cpu(entry->xe_value_size);
> +
> +	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
> +	if (value_size > OCFS2_XATTR_INLINE_SIZE)
> +		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
> +	else
> +		namevalue_size += OCFS2_XATTR_SIZE(value_size);
A minor issue. I see a similar part in the function in 
ocfs2_xa_block_wipe_namevalue, so can we create a inline function for 
it? maybe ocfs2_xe_name_value_size?
> +	le16_add_cpu(&loc->xl_header->xh_name_value_len, -namevalue_size);
> +}
> +
> +/* Operations for xattrs stored in buckets. */
> +static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
> +	.xlo_offset_pointer	= ocfs2_xa_bucket_offset_pointer,
> +	.xlo_wipe_namevalue	= ocfs2_xa_bucket_wipe_namevalue,
> +};
> +
<snip>
> @@ -1376,7 +1586,14 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  {
>  	size_t name_len = strlen(xi->name);
>  	int i;
> +	struct ocfs2_xa_loc loc;
>  
> +	if (xs->xattr_bh == xs->inode_bh)
> +		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
> +					 xs->not_found ? NULL : xs->here);
> +	else
> +		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
> +					      xs->not_found ? NULL : xs->here);
>  	if (xi->value && xs->not_found) {
>  		/* Insert the new xattr entry. */
>  		le16_add_cpu(&xs->header->xh_count, 1);
> @@ -1415,9 +1632,9 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  			       xi->value_len);
>  			return;
>  		}
> +
>  		/* Remove the old name+value. */
> -		memmove(first_val + size, first_val, val - first_val);
> -		memset(first_val, 0, size);
> +		ocfs2_xa_wipe_namevalue(&loc);
>  		xs->here->xe_name_hash = 0;
>  		xs->here->xe_name_offset = 0;
>  		ocfs2_xattr_set_local(xs->here, 1);
> @@ -1425,23 +1642,16 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
>  
>  		min_offs += size;
>  
> -		/* Adjust all value offsets. */
> -		last = xs->header->xh_entries;
> -		for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
> -			size_t o = le16_to_cpu(last->xe_name_offset);
> -
> -			if (o < offs)
> -				last->xe_name_offset = cpu_to_le16(o + size);
> -			last += 1;
> -		}
> -
>  		if (!xi->value) {
>  			/* Remove the old entry. */
> -			last -= 1;
> +			i = le16_to_cpu(xs->header->xh_count);
> +			i--;
any reason why not "i = le16_to_cpu(xs->header->xh_count) - 1"?
> +			last = &xs->header->xh_entries[i - 1];
here is a bug. last should be "&xs->header->xh_entries[i]". In the old 
implementation, the above "for" loop ends with last = xh_entries[xh_count].
> +			xs->header->xh_count = cpu_to_le16(i);
> +
>  			memmove(xs->here, xs->here + 1,
>  				(void *)last - (void *)xs->here);
>  			memset(last, 0, sizeof(struct ocfs2_xattr_entry));
> -			le16_add_cpu(&xs->header->xh_count, -1);
>  		}
>  	}
>  	if (xi->value) {

Regards,
Tao
