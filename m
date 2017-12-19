From: piaojun <piaojun@huawei.com>
Date: Tue, 19 Dec 2017 09:44:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fall back to buffer IO when append
 dio is disabled with file hole existing
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A386F0C.3090501@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2017/12/18 20:06, Changwei Ge wrote:
> Before ocfs2 supporting allocating clusters while doing append-dio, all append
> dio will fall back to buffer io to allocate clusters firstly. Also, when it
> steps on a file hole, it will fall back to buffer io, too. But for current
> code, writing to file hole will leverage dio to allocate clusters. This is not
> right, since whether append-io is enabled tells the capability whether ocfs2 can
> allocate space while doing dio.
> So introduce file hole check function back into ocfs2.
> Once ocfs2 is doing dio upon a file hole with append-dio disabled, it will fall
> back to buffer IO to allocate clusters.
> 
1. Do you mean that filling hole can't go with dio when append-dio is disabled?
2. Is your checking-hole just for 'append-dio' or for 'all-common-dio'?
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>   fs/ocfs2/aops.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d151632..a982cf6 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2414,6 +2414,44 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>   	return ret;
>   }
>   
> +/*
> + * Will look for holes and unwritten extents in the range starting at
> + * pos for count bytes (inclusive).
> + */
> +static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
> +				       size_t count)
> +{
> +	int ret = 0;
> +	unsigned int extent_flags;
> +	u32 cpos, clusters, extent_len, phys_cpos;
> +	struct super_block *sb = inode->i_sb;
> +
> +	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
> +	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
> +
> +	while (clusters) {
> +		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
> +					 &extent_flags);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
> +			ret = 1;
> +			break;
> +		}
> +
> +		if (extent_len > clusters)
> +			extent_len = clusters;
> +
> +		clusters -= extent_len;
> +		cpos += extent_len;
> +	}
> +out:
> +	return ret;
> +}
> +
>   static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>   {
>   	struct file *file = iocb->ki_filp;
> @@ -2429,8 +2467,10 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>   		return 0;
>   
>   	/* Fallback to buffered I/O if we do not support append dio. */
> -	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
> -	    !ocfs2_supports_append_dio(osb))
> +	if (!ocfs2_supports_append_dio(osb) &&
> +			(iocb->ki_pos + iter->count > i_size_read(inode) ||
> +			 ocfs2_check_range_for_holes(inode, iocb->ki_pos,
> +						     iter->count)))
we should check error here, right?

thanks,
Jun
>   		return 0;
>   
>   	if (iov_iter_rw(iter) == READ)
> 
