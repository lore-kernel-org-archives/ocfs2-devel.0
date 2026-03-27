Received: from out199-16.us.a.mail.aliyun.com (out199-16.us.a.mail.aliyun.com [47.90.199.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888D25E469
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Mar 2026 01:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575792; cv=none; b=Mbad1MNZnp/YiFof6C11OWjQtO9O9V3Fjkv+qfO9eSmRLYTTQtXQHi4pgRdFHPvSyPQy2gO1An3+sX2e+r7Cil5YRahMT4mTg42V12ZmvtgdWYMP82Ie2q35ne7QvAmxKIf3WxdYqzsZhaYwu/RuZLFH7ZbIT/rd3DBWEuz+JqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575792; c=relaxed/simple;
	bh=97TTtV1QmknuLPHLfSlTxwbys4n/8KwjIMcTr9ku5Pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHl7ipyCsFUZypo0OIeYJnAZvFzUkLvRRz/qclds5F0K4LMT5tjzYFe4yfvkpCin8UrKjHZxwxSq9xhZOs1No6jeq1cmB+Sbh2757oanYfkTIgw3CmYpdnA+1GGO1OaEI3T2n+z7ZwYZYQ9UiZmi2qmmqd4TWFFYdDmsvPwY7RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x5k6kEM8; arc=none smtp.client-ip=47.90.199.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x5k6kEM8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774575777; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OjP7vHcaBBgvfkSKHKEWvdSlaszyP7wk6rKJESZpG1c=;
	b=x5k6kEM8eYYpraPsEMAqObgCOKDn7I9Falv4dF/UT/vR0DxR+cbwxoWZ4iMS6YEms3BVOBlTSMaQ+Un3ia/GpBxN2BL4m9iZrJQMtWD20XydcrLIPuAkXDoXjx8NVHbR3QRDEusY3f1sO3auIKoNT5e1drUQushxPdIc/i6OJHM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X.mUgoK_1774575775;
Received: from 30.221.145.61(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.mUgoK_1774575775 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 09:42:56 +0800
Message-ID: <b0ba52bb-ab01-48a2-ab40-b2dfe4cdc236@linux.alibaba.com>
Date: Fri, 27 Mar 2026 09:42:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com, Jan Kara <jack@suse.cz>
References: <20260326142640.20077-1-heming.zhao@suse.com>
 <20260326142640.20077-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260326142640.20077-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/26/26 10:26 PM, Heming Zhao wrote:
> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
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
> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write()
> to handle extent in a batch of transaction.
> 
> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> only be removed from the orphan list after the extent tree update is complete.
> this ensures that if a crash occurs in the middle of extent tree updates, we
> won't leave stale blocks beyond EOF.
> 
> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> suggestions.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 44 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..60f1b607022f 100644
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
> @@ -2326,20 +2316,22 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> +				handle = NULL;
> +				break;
> +			}
> +			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +					OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				break;
> +			}
> +		}
>  		ret = ocfs2_assure_trans_credits(handle, credits);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> @@ -2353,17 +2345,41 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  			mlog_errno(ret);
>  			break;
>  		}
> +
> +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> +			ocfs2_commit_trans(osb, handle);
> +			handle = NULL;
> +			batch = 0;
> +		}
>  	}
>  
>  	if (end > i_size_read(inode)) {

I still don't think it is a good idea to update inode size in case error.
The original logic behaves inconsistent, if ocfs2_start_trans() and
ocfs2_journal_access_di() fails, it won't update inode size, but if
ocfs2_assure_trans_credits() and ocfs2_mark_extent_written(), it will do.
So let's make it behave consistent by both checking 'ret' here.

Other looks fine.

Joseph


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
> -commit:> -	ocfs2_commit_trans(osb, handle);
> +	if (handle)
> +		ocfs2_commit_trans(osb, handle);
> +
>  unlock:
>  	up_write(&oi->ip_alloc_sem);
> +
> +	/* everything looks good, let's start the cleanup */
> +	if (dwc->dw_orphaned) {
> +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> +
> +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:

