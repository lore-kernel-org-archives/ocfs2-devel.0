From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 23 May 2011 12:39:02 -0700
Subject: [Ocfs2-devel] [PATCH 3/3 V3] ocfs2: Add trace event for trim.
In-Reply-To: <1306118205-3148-3-git-send-email-tm@tao.ma>
References: <4DD9C1A3.5020005@tao.ma>	<1306118205-3148-1-git-send-email-tm@tao.ma>
	<1306118205-3148-3-git-send-email-tm@tao.ma>
Message-ID: <4DDAB7D6.5050106@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reviewed-by: Sunil Mushran<sunil.mushran@oracle.com>



On 05/22/2011 07:36 PM, Tao Ma wrote:
> From: Tao Ma<boyu.mt@taobao.com>
>
> Add the corresponding trace event for trim.
>
> Signed-off-by: Tao Ma<boyu.mt@taobao.com>
> ---
>   fs/ocfs2/alloc.c       |    7 +++++++
>   fs/ocfs2/ocfs2_trace.h |   25 +++++++++++++++++++++++++
>   2 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index ae3ea78..ed553c6 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7196,6 +7196,8 @@ static int ocfs2_trim_extent(struct super_block *sb,
>   	discard = le64_to_cpu(gd->bg_blkno) +
>   			ocfs2_clusters_to_blocks(sb, start);
>
> +	trace_ocfs2_trim_extent(sb, (unsigned long long)discard, bcount);
> +
>   	return sb_issue_discard(sb, discard, bcount, GFP_NOFS, 0);
>   }
>
> @@ -7209,6 +7211,9 @@ static int ocfs2_trim_group(struct super_block *sb,
>   	if (le16_to_cpu(gd->bg_free_bits_count)<  minbits)
>   		return 0;
>
> +	trace_ocfs2_trim_group((unsigned long long)le64_to_cpu(gd->bg_blkno),
> +			       start, max, minbits);
> +
>   	while (start<  max) {
>   		start = ocfs2_find_next_zero_bit(bitmap, max, start);
>   		if (start>= max)
> @@ -7292,6 +7297,8 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
>   	if (start + len>  le32_to_cpu(main_bm->i_clusters))
>   		len = le32_to_cpu(main_bm->i_clusters) - start;
>
> +	trace_ocfs2_trim_fs(start, len, minlen);
> +
>   	/* Determine first and last group to examine based on start and len */
>   	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
>   	if (first_group == osb->first_cluster_group_blkno)
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index a1dae5b..3b481f4 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -688,6 +688,31 @@ TRACE_EVENT(ocfs2_cache_block_dealloc,
>   		  __entry->blkno, __entry->bit)
>   );
>
> +TRACE_EVENT(ocfs2_trim_extent,
> +	TP_PROTO(struct super_block *sb, unsigned long long blk,
> +		 unsigned long long count),
> +	TP_ARGS(sb, blk, count),
> +	TP_STRUCT__entry(
> +		__field(int, dev_major)
> +		__field(int, dev_minor)
> +		__field(unsigned long long, blk)
> +		__field(__u64,	count)
> +	),
> +	TP_fast_assign(
> +		__entry->dev_major = MAJOR(sb->s_dev);
> +		__entry->dev_minor = MINOR(sb->s_dev);
> +		__entry->blk = blk;
> +		__entry->count = count;
> +	),
> +	TP_printk("%d %d %llu %llu",
> +		  __entry->dev_major, __entry->dev_minor,
> +		  __entry->blk, __entry->count)
> +);
> +
> +DEFINE_OCFS2_ULL_UINT_UINT_UINT_EVENT(ocfs2_trim_group);
> +
> +DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_trim_fs);
> +
>   /* End of trace events for fs/ocfs2/alloc.c. */
>
>   /* Trace events for fs/ocfs2/localalloc.c. */
