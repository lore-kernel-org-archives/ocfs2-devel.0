Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4028690
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 07:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775113636; cv=none; b=rSHiMN7djmgbdvr6oQcpkfsx4ZMNhg28W123Z24SRy/ahARgrNyo3x6Q+1txnnqUt6n2j+ujJOol7rGanD9W5daJXxv/prlzcZ7xbl30HQVJPRfCY7Jx5LInMMm4LWAwBRQfjPLmEdAQrBTh5xqRGcTsr6E3LrbKJGl2wJTN2BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775113636; c=relaxed/simple;
	bh=OSzKQGDuhXJqD9HZDOZKkE1IN+xYp0ZlipzRJaQjuzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MMFRrKUUfpfAY9s65vflcYjjHkbQHCqsK+x/4SWbgoX4jk7wP9/XCj3GjnUKTzoaoGSbwFt/kdkEciEfAJx+9t0IVtgdqB9QGWpqVPntEN/WfBGvlQXbiri5DhtQQRiNMyjDzSL6XZkuMOd7NmgQ1tk1wd1/3F66IvtLVIkV+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PiRyS50g; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PiRyS50g"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775113631; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UdlLW/9HMi0kTzS6LJ8lH9S3oYrp29NsyeAog5YXL9U=;
	b=PiRyS50gmj8E2VW+w640VXCES2GFB7NQZlGwTJQPgW4Z4sPiPCDAp5Va5jF97PklVR545c9NU5x0psxcHMKm3s/DCc5KxWjM0oQSTbTbHUxJPR3eCWoQydoKSDrNFKpek7T56H6db21wRTzSiOdoQVUwcQGTay+p8RXuQQHiz9Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0GOw16_1775113630;
Received: from 30.221.145.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0GOw16_1775113630 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 15:07:11 +0800
Message-ID: <a2fc77e1-3790-44fe-b146-78b1275fd953@linux.alibaba.com>
Date: Thu, 2 Apr 2026 15:07:10 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com, Jan Kara <jack@suse.cz>
References: <20260402022655.19714-1-heming.zhao@suse.com>
 <20260402022655.19714-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260402022655.19714-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/2/26 10:26 AM, Heming Zhao wrote:
> During ocfs2 dio operations, JBD2 may report warnings via following
> call trace:
> ocfs2_dio_end_io_write
>  ocfs2_mark_extent_written
>   ocfs2_change_extent_flag
>    ocfs2_split_extent
>     ocfs2_try_to_merge_extent
>      ocfs2_extend_rotate_transaction
>       ocfs2_extend_trans
>        jbd2__journal_restart
>         start_this_handle
>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> 
> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> handle extents in a batch of transaction.
> 
> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> only be removed from the orphan list after the extent tree update is complete.
> This ensures that if a crash occurs in the middle of extent tree updates, we
> won't leave stale blocks beyond EOF.
> 
> This patch also changes the logic for updating the inode size and removing
> orphan, making it similar to ext4_dio_write_end_io(). Both operations are
> performed only when everything looks good.
> 
> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> suggestions.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..0c88f751ffd5 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -37,6 +37,8 @@
>  #include "namei.h"
>  #include "sysfile.h"
>  
> +#define OCFS2_DIO_MARK_EXTENT_BATCH 200
> +
>  static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  				   struct buffer_head *bh_result, int create)
>  {
> @@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	handle_t *handle = NULL;
>  	loff_t end = offset + bytes;
> -	int ret = 0, credits = 0;
> +	int ret = 0, credits = 0, batch = 0;
>  
>  	ocfs2_init_dealloc_ctxt(&dealloc);
>  
> @@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  		goto out;
>  	}
>  
> -	/* Delete orphan before acquire i_rwsem. */
> -	if (dwc->dw_orphaned) {
> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> -
> -		end = end > i_size_read(inode) ? end : 0;
> -
> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> -				!!end, end);
> -		if (ret < 0)
> -			mlog_errno(ret);
> -	}
> -
>  	down_write(&oi->ip_alloc_sem);
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  
> @@ -2326,24 +2316,25 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  
>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
>  
> -	handle = ocfs2_start_trans(osb, credits);
> -	if (IS_ERR(handle)) {
> -		ret = PTR_ERR(handle);
> -		mlog_errno(ret);
> -		goto unlock;
> -	}
> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto commit;
> -	}
> -
>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> +		if (!handle) {
> +			handle = ocfs2_start_trans(osb, credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				mlog_errno(ret);
> +				goto unlock;
> +			}
> +			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +					OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				goto commit;
> +			}
> +		}
>  		ret = ocfs2_assure_trans_credits(handle, credits);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> -			break;
> +			goto commit;
>  		}
>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>  						ue->ue_cpos, 1,
> @@ -2351,19 +2342,43 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  						meta_ac, &dealloc);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> -			break;
> +			goto commit;
> +		}
> +
> +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> +			ocfs2_commit_trans(osb, handle);
> +			handle = NULL;
> +			batch = 0;
>  		}
>  	}
>  
>  	if (end > i_size_read(inode)) {
> +		if (!handle) {
> +			handle = ocfs2_start_trans(osb, credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				mlog_errno(ret);
> +				goto unlock;
> +			}
> +		}
>  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>  		if (ret < 0)
>  			mlog_errno(ret);
>  	}
> +
>  commit:
>  	ocfs2_commit_trans(osb, handle);

Seems checking 'handle' is still missing here.

Joseph

>  unlock:
>  	up_write(&oi->ip_alloc_sem);
> +
> +	/* everything looks good, let's start the cleanup */
> +	if (!ret && dwc->dw_orphaned) {
> +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> +
> +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:

