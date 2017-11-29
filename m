From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 29 Nov 2017 12:05:00 +0000
Subject: [Ocfs2-devel] [PATCH v2 2/3] ocfs2: add ocfs2_overwrite_io
 function
References: <1511944612-9629-1-git-send-email-ghe@suse.com>
	<1511944612-9629-3-git-send-email-ghe@suse.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F147DC9A@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, "mfasheh@versity.com" <mfasheh@versity.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "rgoldwyn@suse.com" <rgoldwyn@suse.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

It looks fine to me.

On 2017/11/29 16:39, Gang He wrote:
> Add ocfs2_overwrite_io function, which is used to judge if
> overwrite allocated blocks, otherwise, the write will bring extra
> block allocation overhead.
> 
> Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>

> ---
>   fs/ocfs2/extent_map.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   fs/ocfs2/extent_map.h |  3 +++
>   2 files changed, 44 insertions(+)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index e4719e0..4da33e9 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -832,6 +832,47 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   	return ret;
>   }
>   
> +/* Is IO overwriting allocated blocks? */
> +int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
> +		       u64 map_start, u64 map_len)
> +{
> +	int ret = 0, is_last;
> +	u32 mapping_end, cpos;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	struct ocfs2_extent_rec rec;
> +
> +	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> +	   ((map_start + map_len) <= i_size_read(inode)))
> +		goto out;
> +
> +	cpos = map_start >> osb->s_clustersize_bits;
> +	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
> +					       map_start + map_len);
> +	is_last = 0;
> +	while (cpos < mapping_end && !is_last) {
> +		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
> +						 NULL, &rec, &is_last);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		if (rec.e_blkno == 0ULL)
> +			break;
> +
> +		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
> +			break;
> +
> +		cpos = le32_to_cpu(rec.e_cpos) +
> +			le16_to_cpu(rec.e_leaf_clusters);
> +	}
> +
> +	if (cpos < mapping_end)
> +		ret = -EAGAIN;
> +out:
> +	return ret;
> +}
> +
>   int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
>   {
>   	struct inode *inode = file->f_mapping->host;
> diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
> index 67ea57d..1057586 100644
> --- a/fs/ocfs2/extent_map.h
> +++ b/fs/ocfs2/extent_map.h
> @@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct inode *inode, u64 v_blkno, u64 *p_blkno,
>   int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>   		 u64 map_start, u64 map_len);
>   
> +int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
> +		       u64 map_start, u64 map_len);
> +
>   int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
>   
>   int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
> 
