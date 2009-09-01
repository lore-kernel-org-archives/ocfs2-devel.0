From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Sep 2009 14:03:55 +0800
Subject: [Ocfs2-devel] [PATCH 02/14] ocfs2: Remove xattrs via
	ocfs2_xa_loc
In-Reply-To: <1251448563-12508-3-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-3-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9CB94B.1010003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> Add ocfs2_xa_remove_entry(), which will remove an xattr entry from its
> storage via the ocfs2_xa_loc descriptor.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/xattr.c |   61 ++++++++++++++++++++++++-----------------------------
>  1 files changed, 28 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 848f24e..333d384 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1580,7 +1580,28 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
>  
>  static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  {
> +	int index, count;
> +	struct ocfs2_xattr_header *xh = loc->xl_header;
> +	struct ocfs2_xattr_entry *entry = loc->xl_entry;
> +
>  	ocfs2_xa_wipe_namevalue(loc);
> +
> +	le16_add_cpu(&xh->xh_count, -1);
> +	count = le16_to_cpu(xh->xh_count);
> +
> +	/*
> +	 * Only zero out the entry if there are more remaining.  This is
> +	 * important for an empty bucket, as it keeps track of the
> +	 * bucket's hash value.  It doesn't hurt empty block storage.
> +	 */
> +	if (count) {
> +		index = ((char *)entry - (char *)&xh->xh_entries) /
> +			sizeof(struct ocfs2_xattr_entry);
	index = entry - xh->xh_entries should work?
> +		memmove(&xh->xh_entries[index], &xh->xh_entries[index + 1],
> +			(count - index) * sizeof(struct ocfs2_xattr_entry));
> +		memset(&xh->xh_entries[count], 0,
> +		       sizeof(struct ocfs2_xattr_entry));
> +	}
>  }

Regards,
Tao
