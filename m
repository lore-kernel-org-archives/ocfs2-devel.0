Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E8A331211
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 02:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773367463; cv=none; b=aRnORu25WshXf2UrpeV4KlospXS3eixnezNQ2pUjVx+HgQruZrftXaz+puX8AThqdMAfFrj/DBpwBxDqyYKSxUqXEq2Roy+qHGN4BNgcyIfH2S2UfKWCDzLK4NTd5FE2idJK/3Js0i9n66pAN/eramU1qCkkKSoowjDPT7uoj+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773367463; c=relaxed/simple;
	bh=3oL3wzCpHf9LQtVFmJfgNvi/YGhIkkmmkwrsQt7hWyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bn+NsH0vQdyyIHIZly5zIliwrgQ0w31tkCsCSbQ5UXHShdvjIPZWbWsCPIMCoLuaKHSUU6Fv5kOa3mR0DWzdP8wf6pX8fjgIhR8kOVwZggn6wkU9DXmOByAl39tVzzYuMwLIyZJ5Icwy8nP3I2gzYGQFQFfLv6t5JYb0kdlLEno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wzkOSfxh; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wzkOSfxh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773367452; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TG/Dl2F4q5L14jJ3iHKHtdcBKHUfENp/+r1Bz/i2BV4=;
	b=wzkOSfxhd5nizEWbHvrYETpny0mxvIpViMrtSVnK7tT7uUgougOTOLmQasXTx8RHMvdApk83ocJDUz8Vnhg0JUFFDFpiN7+2W8ieTVyQcT3ymmCoq50kFGQnCLcqiLppv93ha77FgaYf/X2mfvHEU/6eDArzazl4wUIenpDnIt4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-qNXvA_1773367451;
Received: from 30.221.129.56(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-qNXvA_1773367451 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 10:04:11 +0800
Message-ID: <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
Date: Fri, 13 Mar 2026 10:04:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260312162725.15523-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Almost looks fine, minor updates below.

On 3/13/26 12:27 AM, Heming Zhao wrote:
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
> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> handle each extent in a separate transaction.
> 
> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> only be removed from the orphan list after the extent tree update is complete.
> this ensures that if a crash occurs in the middle of extent tree updates, we
> won't leave stale blocks beyond EOF.
> 
> This patch also removes the only call to ocfs2_assure_trans_credits(), which
> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
> insufficient transaction credits").
> 
> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..91997b330d39 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> -		ret = ocfs2_assure_trans_credits(handle, credits);
> -		if (ret < 0) {
> +		handle = ocfs2_start_trans(osb, credits);
> +		if (IS_ERR(handle)) {
> +			ret = PTR_ERR(handle);
>  			mlog_errno(ret);
>  			break;

I'd rather goto unlock directly without update i_size in case error.

>  		}
> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (ret) {
> +			mlog_errno(ret);
> +			ocfs2_commit_trans(osb, handle);
> +			break;

Ditto.

> +		}
>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>  						ue->ue_cpos, 1,
>  						ue->ue_phys,
>  						meta_ac, &dealloc);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> +			ocfs2_commit_trans(osb, handle);
>  			break;

Ditto.
BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
to save the extra call in case error.

Thanks,
Joseph

>  		}
> +		ocfs2_commit_trans(osb, handle);
>  	}
>  
>  	if (end > i_size_read(inode)) {
> +		handle = ocfs2_start_trans(osb, credits);
> +		if (IS_ERR(handle)) {
> +			ret = PTR_ERR(handle);
> +			mlog_errno(ret);
> +			goto unlock;
> +		}
>  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>  		if (ret < 0)
>  			mlog_errno(ret);
> +		ocfs2_commit_trans(osb, handle);
>  	}
> -commit:
> -	ocfs2_commit_trans(osb, handle);
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

