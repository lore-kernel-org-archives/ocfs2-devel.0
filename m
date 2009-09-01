From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Sep 2009 15:33:07 +0800
Subject: [Ocfs2-devel] [PATCH 06/14] ocfs2: Set the xattr name+value
	pair in one place
In-Reply-To: <1251448563-12508-7-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-7-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9CCE33.2070506@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> We create two new functions on ocfs2_xa_loc, ocfs2_xa_prepare_entry()
> and ocfs2_xa_store_inline_value().
> 
> ocfs2_xa_prepare_entry() makes sure that the xl_entry field of
> ocfs2_xa_loc is ready to receive an xattr.  The entry will point to an
> appropriately sized name+value region in storage.  If an existing entry
> can be reused, it will be.  If no entry already exists, it will be
> allocated.  If there isn't space to allocate it, -ENOSPC will be
> returned.
> 
> ocfs2_xa_store_inline_value() stores the data that goes into the 'value'
> part of the name+value pair.  For values that don't fit directly, this
> stores the value tree root.
> 
> A number of operations are added to ocfs2_xa_loc_operations to support
> these functions.  This reflects the disparate behaviors of xattr blocks
> and buckets.
> 
> With these functions, the overlapping ocfs2_xattr_set_entry_local() and
> ocfs2_xattr_set_entry_normal() can be replaced with a single call
> scheme.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |  606 ++++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 386 insertions(+), 220 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 4c5c566..3d14c1c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
<snip>
> +/*
> + * Prepares loc->xl_entry to receive the new xattr.  This includes
> + * properly setting up the name+value pair region.  If loc->xl_entry
> + * already exists, it will take care of modifying it appropriately.
> + * This also includes deleting entries, but don't call this to remove
> + * a non-existant entry.  That's just a bug.
> + *
> + * Note that this modifies the data.  You did journal_access already,
> + * right?
> + */
> +static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
> +				  struct ocfs2_xattr_info *xi,
> +				  u32 name_hash)
> +{
> +	int rc = 0;
> +	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
> +	char *nameval_buf;
> +
> +	if (!xi->xi_value) {
> +		ocfs2_xa_remove_entry(loc);
> +		goto out;
> +	}
> +
> +	rc = ocfs2_xa_has_space(loc, xi);
> +	if (rc)
> +		goto out;
could you please add some comments here or change the function name.
when I read ocfs2_xa_has_space, I always think that "if we have space, 
goto out". But actually we get 0 here if we have space.
> +
> +	if (loc->xl_entry) {
> +		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> +			nameval_buf = ocfs2_xa_offset_pointer(loc,
> +				le16_to_cpu(loc->xl_entry->xe_name_offset));
oh, I see you use ocfs2_xa_offset_pointer and offset = xe_name_offset 
here. So in patch 01/14, that is really a bug in 
ocfs2_xa_block_offset_pointer.

Regards,
Tao
