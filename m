From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 01 Sep 2009 13:32:37 +0800
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <1251448563-12508-2-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-2-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9CB1F5.3050809@oracle.com>
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
>  fs/ocfs2/xattr.c |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 227 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index a3eed49..848f24e 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -141,6 +141,51 @@ struct ocfs2_xattr_search {
>  	int not_found;
>  };
>  
> +/* Operations on struct ocfs2_xa_entry */
> +struct ocfs2_xa_loc;
> +struct ocfs2_xa_loc_operations {
> +	/*
> +	 * Return a pointer to the appropriate buffer in loc->xl_storage
> +	 * at the given offset from loc->xl_header.
> +	 */
> +	void *(*xlo_offset_pointer)(struct ocfs2_xa_loc *loc, int offset);
> +
> +	/*
> +	 * Remove the name+value at this location.  Do whatever is
> +	 * appropriate with the remaining name+value pairs.
> +	 */
> +	void (*xlo_wipe_namevalue)(struct ocfs2_xa_loc *loc);
> +};
<snip>
> +
> +static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
> +					   int offset)
> +{
> +	struct buffer_head *bh = loc->xl_storage;
> +
> +	BUG_ON(offset >= bh->b_size);
> +	return bh->b_data + offset;
> +}
It looks that the "offset" is from the start of the buffer, while in 
your description above "offset" is from "loc->xl_header". In both inline 
and block case, header != buffer_start. xl_size seems to be against 
xl_header, so I would guess here you need to change somehow.

Regards,
Tao
