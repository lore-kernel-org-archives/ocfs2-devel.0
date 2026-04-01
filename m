Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858311D7E5C
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 04:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018083; cv=none; b=iujwCYMu6TXLSTv1HiiS2RqZYVyx3LkIiZLsm2duZ1ocEMb5WbSS5Km+0qbskBhpRJPv7zMGdKOvcbEUtUI0Zgh9g3b25O7TGcORXjrQzABmUoolwvKuukUOx9gQiZM7gkc4OFmbGNz5gBlhVVJ8ocoXd7e10Sz/Buelb28eVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018083; c=relaxed/simple;
	bh=/Sq5vcYkpALTv/Lr9CR7V9VyGukitqQjSJ3mloGOtbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bm8oc5DhuuNCDyUGQpkeym4m9wbT7+yPmpmORDdxURTTikn1laVS7g8re0zl7R6uitWUVD1XfKDn7wt351XF+mEmfMBCL3j0NF0UAUn3a/GP9Ncx24O3dyobUwMqgdyYh/TxtwJX9bIqGESLhowRxhqrjsaOBw+iTDf8mr/T2h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SglwP9ek; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SglwP9ek"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4887c4f3011so1362245e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 21:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775018080; x=1775622880; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=skYhRKCHb3Lbzv7+aL1BTI+YxZ1+ZQ3yslG2LAwRJtY=;
        b=SglwP9ekZLqT2sGIInENIFXK3a7mRHfcjhd4/EL69lvOeTkqtQSFAEBZj60UxZR9St
         OgET0trZMKESK4ElqRyANl6D+vZ6cpUUAjIpwTNF1kgMtAfry25XkMJVLW3zUgGnYd9/
         m7pXgww0Vm6AU5+sMehKF4IIa+0FT1FAAH1KMv7uaDHd4Wb4HV5yyn3OYQ3MhoqvJN/c
         cWARZGHgmJ43lL29hFUFOpHCt09Srlo8XZc7bcE2kGsVzB38h822k3oUAwg09c4Dqayh
         o2pAA2+Rhcg8dW64t9Khl5O1LZ65SWnkzUaLvnA5Cp7AJ4V/3icxkTP2jSp2PrHtSrmI
         aUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775018080; x=1775622880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skYhRKCHb3Lbzv7+aL1BTI+YxZ1+ZQ3yslG2LAwRJtY=;
        b=PT3lDRauuFpJ4uvHRdcgDuKyz1RIdfVFP03S+xDD/N0bDnpAzAQcbU2XVIgidy8b01
         JdmsonICW0OP/DSDE7UAbmNhwaRBw61ZrwSfA/RrTHdgF1+b1K4BRLyAOSoyHQjpRUVN
         gJSUE80hTLRWzqZSbXMnnYJuHGSe5uwxagEFaAoSaU7uTugZ1vOxuKH+lOwDKkZ2GeFC
         STwk6fIs0M5SzSImkZg/JPRhMBo9/5V/F5QCE5yA6jgz7oYIW0nyEygQUwt7QG1yJL6O
         U4s9m4QXE1ICWPg1gNhST2Db6WNzVudlFuAVRTkBm8W4zk+1PM6kZGx+podbFzEaZAIj
         /6DQ==
X-Gm-Message-State: AOJu0YzVuVlAjDCrFAVq3daH/zkm6WDMxwtlQLjcbpGkUAF2HJggIsY6
	zjEwTOYiOiLb/028aZfsTLMcLNoC+CXUB6V0Zwwoi5Zbw3f5ZfUZ5/M58MSZYYD2Eyo=
X-Gm-Gg: ATEYQzzh3XT/Q/z4LvK54kEVByvSWjiGuo4KBX/vgGGAQyPPiQeiCqHWZHbZv8wTEuQ
	fEZ9ilLkt2AuBemA43RKRdlpaf980lpI/iPq6JQ4ImLYJvLiWvoCYK6oicn71qjOINQ6NfIqdqd
	0mmZQLJmNyAYuKzCNvRSInBjfB3gKxCq67kvoyPXN63LVbFykCqrMSi4EWYcQOUdLW684h65xM3
	4of9+uhHdFMd6EzIbDRenhwJJqMnZtJ5VbOzLaCIH99dAUrQOl+MKNwRiTGJMarmiE2iKIOuy1P
	rCHOnqzbRmJ9YypbZgAWfAYJ5MhSNYG7jNGxVdFr4jBjzWaN6LOjSrGVAz2v08lZMf8fs21atSD
	H/jp+6Onrgw4YYe6zAtAZ/fwxo9fnz6b8imqKrKHXD4BYbW4qZKoypMhr+N5p1mAOMv9fTtpmvR
	0DOVflfFWMzv2k3J6NX92qGw==
X-Received: by 2002:a05:600c:3b27:b0:485:39a1:bcb3 with SMTP id 5b1f17b1804b1-48883597d44mr18052045e9.6.1775018079810;
        Tue, 31 Mar 2026 21:34:39 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264287csm126686035ad.3.2026.03.31.21.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 21:34:38 -0700 (PDT)
Date: Wed, 1 Apr 2026 12:34:36 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com, jack@suse.cz
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com
Subject: Re: [PATCH v5 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <shebhri5uhbl7mog63jhf4jacajfru34hhtdsacmjk3sv7lw6q@6urd4k3b3t7c>
References: <20260327063626.10225-1-heming.zhao@suse.com>
 <20260327063626.10225-2-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327063626.10225-2-heming.zhao@suse.com>

Hi Joseph,

ping.
Does this patch lack your 'reviewed-by', or is Jan's 'reviewed-by' enough?

- Heming
On Fri, Mar 27, 2026 at 02:36:25PM +0800, Heming Zhao wrote:
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
>  fs/ocfs2/aops.c | 63 +++++++++++++++++++++++++++----------------------
>  1 file changed, 35 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..a542cd0a6f75 100644
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
> @@ -2351,7 +2342,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> @@ -2360,10 +2357,20 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  		if (ret < 0)
>  			mlog_errno(ret);
>  	}
> +
>  commit:
>  	ocfs2_commit_trans(osb, handle);
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
> -- 
> 2.43.0
> 
