From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 12 Dec 2017 01:05:38 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: check the metadate alloc before
 marking extent written
References: <5A261299.6080403@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5A147@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Alex,

On 2017/12/5 11:31, alex chen wrote:
> We need to check the free number of the records in each loop to mark
> extent written, because the last extent block may be changed through
> many times marking extent written and the 'num_free_extents' also be
> changed. In the worst case, the 'num_free_extents' may become less
> than the beginning of the loop. So we should not estimate the free
> number of the records at the beginning of the loop to mark extent
> written.
> 
> Reported-by: John Lightsey <john@nixnuts.net>
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>   fs/ocfs2/aops.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 64 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index d151632..7e1659d 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2272,6 +2272,35 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>   	return ret;
>   }
> 
> +static int ocfs2_dio_should_restart(struct ocfs2_extent_tree *et,
> +		struct ocfs2_alloc_context *meta_ac, int max_rec_needed)
> +{
> +	int status = 0, free_extents;
> +
> +	free_extents = ocfs2_num_free_extents(et);
> +	if (free_extents < 0) {
> +		status = free_extents;
> +		mlog_errno(status);
> +		return status;
> +	}
> +
> +	/*
> +	 * there are two cases which could cause us to EAGAIN in the
> +	 * we-need-more-metadata case:
> +	 * 1) we haven't reserved *any*
> +	 * 2) we are so fragmented, we've needed to add metadata too
> +	 *    many times.
> +	 */
> +	if (free_extents < max_rec_needed) {
> +		if (!meta_ac || (ocfs2_alloc_context_bits_left(meta_ac)
> +				< ocfs2_extend_meta_needed(et->et_root_el)))
> +			status = 1;
> +	}
> +
> +	return status;
> +}
> +
> +#define OCFS2_MAX_REC_NEEDED_SPLIT 2
>   static int ocfs2_dio_end_io_write(struct inode *inode,
>   				  struct ocfs2_dio_write_ctxt *dwc,
>   				  loff_t offset,
> @@ -2281,14 +2310,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   	struct ocfs2_extent_tree et;
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>   	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> -	struct ocfs2_unwritten_extent *ue = NULL;
> +	struct ocfs2_unwritten_extent *ue = NULL, *tmp_ue;
>   	struct buffer_head *di_bh = NULL;
>   	struct ocfs2_dinode *di;
> -	struct ocfs2_alloc_context *data_ac = NULL;
>   	struct ocfs2_alloc_context *meta_ac = NULL;
>   	handle_t *handle = NULL;
>   	loff_t end = offset + bytes;
> -	int ret = 0, credits = 0, locked = 0;
> +	int ret = 0, credits = 0, locked = 0, restart = 0;
> 
>   	ocfs2_init_dealloc_ctxt(&dealloc);
> 
> @@ -2328,10 +2356,10 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> 
>   	di = (struct ocfs2_dinode *)di_bh->b_data;
> 
> +restart_all:
>   	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> -
> -	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
> -				    &data_ac, &meta_ac);
> +	ret = ocfs2_lock_allocators(inode, &et, 0, OCFS2_MAX_REC_NEEDED_SPLIT,
> +				    NULL, &meta_ac);
>   	if (ret) {
>   		mlog_errno(ret);
>   		goto unlock;
> @@ -2343,7 +2371,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   	if (IS_ERR(handle)) {
>   		ret = PTR_ERR(handle);
>   		mlog_errno(ret);
> -		goto unlock;
> +		goto free_ac;
>   	}
>   	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>   				      OCFS2_JOURNAL_ACCESS_WRITE);
> @@ -2352,7 +2380,17 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   		goto commit;
>   	}
> 
> -	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> +	list_for_each_entry_safe(ue, tmp_ue, &dwc->dw_zero_list, ue_node) {
> +		ret = ocfs2_dio_should_restart(&et, meta_ac,
> +				OCFS2_MAX_REC_NEEDED_SPLIT * 2);
> +		if (ret < 0) {
> +			mlog_errno(ret);
> +			break;
> +		} else if (ret == 1) {
> +			restart = 1;

If there isn't enough extent records here, you break this loop and also 
commit transaction.
After re-executing from _restart_all_, a new transaction is started.
So you separate 'before _restart_all_' and 'after _restart_all_' into 
different transactions.


> +			break;
> +		}
> +
>   		ret = ocfs2_mark_extent_written(inode, &et, handle,
>   						ue->ue_cpos, 1,
>   						ue->ue_phys,
> @@ -2361,24 +2399,37 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>   			mlog_errno(ret);
>   			break;
>   		}
> +
> +		dwc->dw_zero_count--;
> +		list_del_init(&ue->ue_node);
> +		spin_lock(&oi->ip_lock);
> +		list_del_init(&ue->ue_ip_node);
> +		spin_unlock(&oi->ip_lock);
> +		kfree(ue);
>   	}
> 
> -	if (end > i_size_read(inode)) {
> +	if (!restart && end > i_size_read(inode)) {

Here you don't change inode size, however, obviously you already mark 
extents as *written*.

>   		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>   		if (ret < 0)
>   			mlog_errno(ret);
>   	}
> +
>   commit:
>   	ocfs2_commit_trans(osb, handle);

You commit transaction here and host just crashes at this point.
Then you will have a file with a smaller size than its real size.
Moreover, those space could not be declaimed.

Should we do more work on JBD2?

Thanks,
Changwei


> +free_ac:
> +	if (meta_ac) {
> +		ocfs2_free_alloc_context(meta_ac);
> +		meta_ac = NULL;
> +	}
> +	if (restart) {
> +		restart = 0;
> +		goto restart_all;
> +	}
>   unlock:
>   	up_write(&oi->ip_alloc_sem);
>   	ocfs2_inode_unlock(inode, 1);
>   	brelse(di_bh);
>   out:
> -	if (data_ac)
> -		ocfs2_free_alloc_context(data_ac);
> -	if (meta_ac)
> -		ocfs2_free_alloc_context(meta_ac);
>   	ocfs2_run_deallocs(osb, &dealloc);
>   	if (locked)
>   		inode_unlock(inode);
> 
