From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 Aug 2009 13:43:32 -0700
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <1250866552-10333-1-git-send-email-tao.ma@oracle.com>
References: <4A8E028B.50802@oracle.com>
	<1250866552-10333-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821204332.GB4330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 21, 2009 at 10:55:52PM +0800, Tao Ma wrote:
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 02244bb..0978abe 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1677,6 +1677,47 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
>  	return ret;
>  }
>  
> +/*
> + * CoW all refcounted clusters within [cow_start, cow_start + cow_len).
> + *
> + * Note: We may meet with non-refcounted clusters or even holes, just skip
> + * them and iterate until we reach cow_start + cow_len.
> + */
> +static int ocfs2_refcount_clusters(struct inode *inode,
> +				   struct buffer_head *di_bh,
> +				   u32 cow_start, u32 cow_len)
> +{
> +	int ret = 0;
> +	u32 p_cluster, num_clusters;
> +	unsigned int ext_flags;
> +
> +	while (cow_len) {
> +		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
> +					 &num_clusters, &ext_flags);
> +		if (ret) {
> +			mlog_errno(ret);
> +			break;
> +		}
> +
> +		if (cow_len < num_clusters)
> +			num_clusters = cow_len;
> +
> +		if (ext_flags & OCFS2_EXT_REFCOUNTED) {
> +			ret = ocfs2_refcount_cow(inode, di_bh, cow_start,
> +						 num_clusters);
> +			if (ret) {
> +				mlog_errno(ret);
> +				break;
> +			}
> +		}
> +
> +		cow_len -= num_clusters;
> +		cow_start += num_clusters;
> +	}
> +
> +	return ret;
> +}
> +

	This belongs in refcounttree.c and should be called
ocfs2_refcount_cow().  It should have the exact same prototype as
ocfs2_refcount_cow() does now.  Inside this function the length should
be called write_len, not cow_len, because it's the length of the write
we're trying, not the length of the actual CoW.   Rename
ocfs2_refcount_cow() to ocfs2_refcount_cow_hunk():

	/*
	 * Starting at cpos, try to CoW write_len clusters.  Don't CoW
	 * past max_cpos.  This will stop when it runs into a hole or an
	 * unrefcounted extent.
	 */
	int ocfs2_refcount_cow_hunk(struct inode *inode,
				    struct buffer_head *di_bh,
				    u32 cpos, u32 write_len, u32 max_cpos);

	/*
	 * CoW any and all clusters between cpos and cpos+write_len.
	 * Don't CoW past max_cpos.  If this returns successfully, all
	 * clusters between cpos and cpos+write_len are safe to modify.
	 */
	int ocfs2_refcount_cow(struct inode *inode,
			       struct buffer_head *di_bh,
			       u32 cpos, u32 write_len, u32 max_cpos);

	The idea is that any part of the ocfs2 code should be able to
call ocfs2_refcount_cow() for any cpos+write_len and be assured that the
clusters are writable when the function returns.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
