Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23F933E355
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775179875; cv=none; b=G+2f1RwFXSbfsQqvcF5z9L1xCyc5Ut09+iqn/Tk0zZjwH2/h8VFfWW+1gNydStGESpr/zU2QoNoT2n/R/KTWP3cu+639CJM5ABd+Lvd10a7vKRdRvWhgVWFkS+kC4RVppylbNbtZ/GHPtn2Nkm3HaV5U/RZnd0EO8x0hZN1Pkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775179875; c=relaxed/simple;
	bh=re7vFCAdKuvvwMXsIo1r9UMzfxOpklxgdMMt13G+IOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ssSpBefKDYd6SVbajJAHz6kkO8khGLAoh/9Rl7EDd9ZEs0DrTIxGSOnTs1El0kZrwtWmr2hALAJ40p4RpRrs8ZVVBfCGr9P3sN15xKPBYzY3Y4Kgw0km81tqBdyLZhpB4XAonwRn7AJS4CuNSrX6kjhBdZvl3i9xZas09aLrS7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nWuf32OU; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nWuf32OU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775179865; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+DYcIE8OpYoi//+M6dxiZjajEHepjWDLuUXLjokUwg0=;
	b=nWuf32OUQYaTgm/C4LOFReNOsLgIPYqJhvX8g+XmnQIITUaOCMx96m3biVp+JXlFPFKCxzSb9dVnQQZo3haJrDLJd1mIwlKtjfB+WkMZXL/MzT1CKgtsZFvTbv5j9cbDqhvMo3iHeTk4HIWZQLMRkoHimi+wwJkZgd9rukY/Egg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X0IV4R-_1775179864;
Received: from 30.221.145.18(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0IV4R-_1775179864 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 09:31:05 +0800
Message-ID: <5f57c27e-037e-48b5-90e7-8d1b388781c1@linux.alibaba.com>
Date: Fri, 3 Apr 2026 09:31:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, jack@suse.cz,
 glass.su@suse.com
References: <20260402134328.27334-1-heming.zhao@suse.com>
 <20260402134328.27334-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260402134328.27334-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/2/26 9:43 PM, Heming Zhao wrote:
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

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/aops.c | 74 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..c6dbec1693b1 100644
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
> @@ -2351,19 +2342,44 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> -	ocfs2_commit_trans(osb, handle);
> +	if (handle)
> +		ocfs2_commit_trans(osb, handle);
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

