Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9BB2620E5
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Mar 2026 01:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773193700; cv=none; b=fmdUbwfjo8qOSk6mZrxhpadLUhcF4ajgjBlasfk3NxYfvvLRt0aBSKTwYB+jkdzV7/+eP6HI7kz9/aQ/vtSfc6AH1PHM/IzMLvpaTGXeCgyQx7T/Uj9CgBLTlHTLnaiGONzXHPtzqVJh81DAGKAHpxLwWBjm898Dh4pEY3YzO70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773193700; c=relaxed/simple;
	bh=Gn+YAgtVLhkFc0gYhYBcz0+URWnat5PVoNNkGYKPqlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pVcanlMEExoA3/cQX+/En2Xv5NaaLUrGtpl56O9ZRTzDRG5zn42dF8UAfYNXgIE6pI34umFGTDXP8bmLqiqlEkBGO7uWpWJSII2cXwj9+EAu3u/AXPYa6AGvnYOeVy67ugtzcr/NVCCoPX/nrhVHtK7l/PvX40MMVuNswuL1lhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ySWrLslL; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ySWrLslL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773193695; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=smdLqkl2HSZYhkrXx9UvwdAqMfclTz/SvLIp5MEgURM=;
	b=ySWrLslLXX/mPxP3lvpxJM8bg5OPhkhqcDjoCUHzHb23fD/Am/59wnmOx7uo4fz1B374LgkDrhM7PNQxlzvAybH2vQSnWoL5AqQdgWMqFSsRRdR1B21nDiYCvBILFySKMmKmtBIYPn97KDHhSBrQE+ailVlJvW3G49+JM+wDU3w=
Received: from 30.221.129.71(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-i3bO3_1773193693 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 09:48:14 +0800
Message-ID: <5be5a109-477c-4c42-919b-1de0707e7af6@linux.alibaba.com>
Date: Wed, 11 Mar 2026 09:48:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] ocfs2: split transactions in dio completion to avoid
 credit exhaustion
To: Heming Zhao <heming.zhao@suse.com>, jack@suse.cz
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260310102413.12501-1-heming.zhao@suse.com>
 <20260310102413.12501-2-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260310102413.12501-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/10/26 6:24 PM, Heming Zhao wrote:
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
>  fs/ocfs2/aops.c | 56 ++++++++++++++++++++-----------------------------
>  1 file changed, 23 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..50b4d474b88c 100644
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
> @@ -2326,23 +2314,18 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> +			mlog_errno(ret);
> +			break;
> +		}
> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> +		if (ret) {
>  			mlog_errno(ret);
> +			ocfs2_commit_trans(osb, handle);
>  			break;
>  		}
>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> @@ -2351,19 +2334,26 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  						meta_ac, &dealloc);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> +			ocfs2_commit_trans(osb, handle);
>  			break;
>  		}
> +		ocfs2_commit_trans(osb, handle);
>  	}
>  
> -	if (end > i_size_read(inode)) {
> -		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);

dw_orphaned is only set if it allocates new clusters, see
ocfs2_dio_get_block():

	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
	    !dwc->dw_orphaned) {
		...
		dwc->dw_orphaned = 1;
	}

So in case extending a file within an existing cluster, it leaves
dwc->dw_orphaned = 0. Then i_size won't be updated here and the written
data is lost.

Thanks,
Joseph

> +unlock:
> +	up_write(&oi->ip_alloc_sem);
> +
> +	/* everything looks good, let's start the cleanup and update i_size */
> +	if (dwc->dw_orphaned) {
> +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> +
> +		end = end > i_size_read(inode) ? end : 0;
> +
> +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> +				!!end, end);
>  		if (ret < 0)
>  			mlog_errno(ret);
>  	}
> -commit:
> -	ocfs2_commit_trans(osb, handle);
> -unlock:
> -	up_write(&oi->ip_alloc_sem);
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:

