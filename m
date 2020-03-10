From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 10 Mar 2020 09:07:50 +0800
Subject: [Ocfs2-devel] [PATCH][next] ocfs2: ocfs2_fs.h: Replace
 zero-length array with flexible-array member
In-Reply-To: <20200309202155.GA8432@embeddedor>
References: <20200309202155.GA8432@embeddedor>
Message-ID: <bbaead13-d6aa-5820-ce2f-05cb11305f8c@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 2020/3/10 04:21, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!JTw1NYKmjtcAGIuR1tXUzdiVuY3gSXbPJ7RUiTDWFqVfZxM6GVzAejGpyplPNEMo000aCg$ 
> [2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!JTw1NYKmjtcAGIuR1tXUzdiVuY3gSXbPJ7RUiTDWFqVfZxM6GVzAejGpyplPNENIcqEuAA$ 
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ocfs2_fs.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> index 0db4a7ec58a2..0dd8c41bafd4 100644
> --- a/fs/ocfs2/ocfs2_fs.h
> +++ b/fs/ocfs2/ocfs2_fs.h
> @@ -470,7 +470,7 @@ struct ocfs2_extent_list {
>  	__le16 l_reserved1;
>  	__le64 l_reserved2;		/* Pad to
>  					   sizeof(ocfs2_extent_rec) */
> -/*10*/	struct ocfs2_extent_rec l_recs[0];	/* Extent records */
> +/*10*/	struct ocfs2_extent_rec l_recs[];	/* Extent records */
>  };
>  
>  /*
> @@ -484,7 +484,7 @@ struct ocfs2_chain_list {
>  	__le16 cl_count;		/* Total chains in this list */
>  	__le16 cl_next_free_rec;	/* Next unused chain slot */
>  	__le64 cl_reserved1;
> -/*10*/	struct ocfs2_chain_rec cl_recs[0];	/* Chain records */
> +/*10*/	struct ocfs2_chain_rec cl_recs[];	/* Chain records */
>  };
>  
>  /*
> @@ -496,7 +496,7 @@ struct ocfs2_truncate_log {
>  /*00*/	__le16 tl_count;		/* Total records in this log */
>  	__le16 tl_used;			/* Number of records in use */
>  	__le32 tl_reserved1;
> -/*08*/	struct ocfs2_truncate_rec tl_recs[0];	/* Truncate records */
> +/*08*/	struct ocfs2_truncate_rec tl_recs[];	/* Truncate records */
>  };
>  
>  /*
> @@ -640,7 +640,7 @@ struct ocfs2_local_alloc
>  	__le16 la_size;		/* Size of included bitmap, in bytes */
>  	__le16 la_reserved1;
>  	__le64 la_reserved2;
> -/*10*/	__u8   la_bitmap[0];
> +/*10*/	__u8   la_bitmap[];
>  };
>  
>  /*
> @@ -653,7 +653,7 @@ struct ocfs2_inline_data
>  				 * for data, starting at id_data */
>  	__le16	id_reserved0;
>  	__le32	id_reserved1;
> -	__u8	id_data[0];	/* Start of user data */
> +	__u8	id_data[];	/* Start of user data */
>  };
>  
>  /*
> @@ -798,7 +798,7 @@ struct ocfs2_dx_entry_list {
>  					 * possible in de_entries */
>  	__le16		de_num_used;	/* Current number of
>  					 * de_entries entries */
> -	struct	ocfs2_dx_entry		de_entries[0];	/* Indexed dir entries
> +	struct	ocfs2_dx_entry		de_entries[];	/* Indexed dir entries
>  							 * in a packed array of
>  							 * length de_num_used */
>  };
> @@ -935,7 +935,7 @@ struct ocfs2_refcount_list {
>  	__le16 rl_used;		/* Current number of used records */
>  	__le32 rl_reserved2;
>  	__le64 rl_reserved1;	/* Pad to sizeof(ocfs2_refcount_record) */
> -/*10*/	struct ocfs2_refcount_rec rl_recs[0];	/* Refcount records */
> +/*10*/	struct ocfs2_refcount_rec rl_recs[];	/* Refcount records */
>  };
>  
>  
> @@ -1021,7 +1021,7 @@ struct ocfs2_xattr_header {
>  						    buckets.  A block uses
>  						    xb_check and sets
>  						    this field to zero.) */
> -	struct ocfs2_xattr_entry xh_entries[0]; /* xattr entry list. */
> +	struct ocfs2_xattr_entry xh_entries[]; /* xattr entry list. */
>  };
>  
>  /*
> @@ -1207,7 +1207,7 @@ struct ocfs2_local_disk_dqinfo {
>  /* Header of one chunk of a quota file */
>  struct ocfs2_local_disk_chunk {
>  	__le32 dqc_free;	/* Number of free entries in the bitmap */
> -	__u8 dqc_bitmap[0];	/* Bitmap of entries in the corresponding
> +	__u8 dqc_bitmap[];	/* Bitmap of entries in the corresponding
>  				 * chunk of quota file */
>  };
>  
> 
