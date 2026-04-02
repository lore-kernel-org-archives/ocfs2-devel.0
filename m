Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF16389446
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 07:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775116451; cv=none; b=fBJJM+Sp4/3jELEzLD/AOLVHv/d49pBSUYOApVGdgwOlZEfLbsKKzsAzqdsOKvR+wyNl14qVukekeVhQMeg9a1Rz+F+KGYU0lvGGyGFRFq73/ch6t/Wyv9Ls5V0wUkVagwrP+qJ8PjO+/UZyv03rtVby/TV7hnrqEQpq26KrKsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775116451; c=relaxed/simple;
	bh=ZtcmRdqRWrCJfMIQ/AFZsGptGyY1eFq36C8xnxIp5xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAJU35llQnxO/i4ZNe3BtJ0FsC5X77i/3S7mukCwGqdaxUPRUbLyTXvUmaArWs03tVojG8jYmgiWQyuBo3VjXc5TuEM6CEdDv8NQJ0NC49KYoQllPTDGimep7xKp8mkWGTt4XJPh3ad7B9kvkBRnMZ5ijv0h18O5Xsn5V1uWMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bXRtPe2y; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bXRtPe2y"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4853a5ffc05so1361995e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775116445; x=1775721245; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjXxAho0nYq0mhpeWNuBpylvs/0eG52BRxjzxjJX8sk=;
        b=bXRtPe2y0C2ZJ1Itzlb3vQqusrGBlRbQ8zP+Z/KEd7t/jcjyHsdvEwQP+ECH2DiA5N
         LZ9L/8lLxdEJ2mK9fvcenjFBaobR1UxiMgQPgrilk9AiEV+zMM8V75JFeWQJlMsH+0VY
         ml6CkkMEg6gRwmKTXyhIqGbwC0QeqDlHzIrz1RxncsmBqLzK8D9BF35Ccf1YVBq2pLO0
         wwWIEew/DBB9oB8nruktnSBr2hu0uGxS0e56b5p/fwWvb7pVcvWJjAyN89+GXqQh/GeZ
         ywXGAco8mXfGue1ctrNN1OnuhjAvoI/1F3jpc2r1E+C1gw4j950DWji3tGOD0gRzI9er
         XwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775116445; x=1775721245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AjXxAho0nYq0mhpeWNuBpylvs/0eG52BRxjzxjJX8sk=;
        b=kOyfVW4rL4Thhqq+eFxjwewlwtj+Jp9Z5PenDQW6n2YaX8JMuupkAa5H2IEZ3aGBWF
         WR6ZRLmTyo/nBJPSJSAOcFL4ZQF0/8gKVhEm/YMpG0flz80zfsb1863ZG9nfoniAPqcB
         84lf5yNq3dJtubcTTLe9jpUkyGLgCEIlHFA4kMetHsGtG/4EmIrBI8911Yk4hPQgP2Tj
         VmKNXvfqlWRRW3HsfCPnimNRwz3fgFQcrEditudZpgZWyovjka60bYzDIenLdxenmZb/
         3AOmiMMnDi4UNgzgV0l/6eWiYCDBs80Ql42P+cPHDhRm4VGVIevmrkMCriX2tZ0jCyt2
         RK8A==
X-Gm-Message-State: AOJu0Yx6z7CAEEtmCWIw03q+29RUzpOgJvCP4GM7GAlDRD8dpo4Dqo2z
	qUyWzJg2H29Rd9vgotqbDB+IWGrWEXza+y48WW/aKAN0b/SVtAFuKvHP6K5DAFFKhB8=
X-Gm-Gg: ATEYQzyfprUWLYpvmyzm8pvoerVvZi5dIjtoS/+556DMKvR4SY+trcX14qBurLVGDWq
	uqx9cA/kUroub/mHGgIX81BtyFmpbDMqcJZJzx8Afl1C4z7DJZULNswBdAUGPbAbeMwueJ/viAZ
	zr8OnwoyMkTvtePyRnyIrgrPjdVfs9V45Ba+6bTkP2bZz/jhdbiJ7MmM24pj5Cz3suFgNZOylAC
	zJBJxtddW+fQBgFLDl0A97Lprsh+SAVTtblFrftFItE2+FBW8+0eUsVwrQFLZkuj1vXRNJHitjK
	g6BEq22o7OkzcN62edMMebAXdyA/BTcIbhBM48fmuqKWqbSu+OlWtt0dC+dgzB4XYmRWS+P8O8F
	xi+bp7+6JTkC5lOcBJqo97ofR7fF2b9l32t3kvv4B4HdVjSjpo2uHbPvnAUk/wBQrnZFmc04Lh0
	z8pyBRZi4a37uycmPBy/bsrQ==
X-Received: by 2002:a05:600c:6298:b0:477:9c9e:ec7e with SMTP id 5b1f17b1804b1-48883596fbdmr61021835e9.6.1775116444607;
        Thu, 02 Apr 2026 00:54:04 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497c117sm18416105ad.40.2026.04.02.00.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:54:03 -0700 (PDT)
Date: Thu, 2 Apr 2026 15:54:00 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <2za3r3teyfzeul5ioudznorvc7zfrpfhjxe5ajtm5m3obewgnr@rqx6s4hxbwgy>
References: <20260402022655.19714-1-heming.zhao@suse.com>
 <20260402022655.19714-2-heming.zhao@suse.com>
 <a2fc77e1-3790-44fe-b146-78b1275fd953@linux.alibaba.com>
 <c3ejq4wbe5cti6ytkd7snpggrtjwhbg24sc4tyspktdw6uuiku@34b57p35etps>
 <17a5365e-df27-427e-bf7b-cee95306b00a@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17a5365e-df27-427e-bf7b-cee95306b00a@linux.alibaba.com>

On Thu, Apr 02, 2026 at 03:48:36PM +0800, Joseph Qi wrote:
> 
> 
> On 4/2/26 3:43 PM, Heming Zhao wrote:
> > On Thu, Apr 02, 2026 at 03:07:10PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 4/2/26 10:26 AM, Heming Zhao wrote:
> >>> During ocfs2 dio operations, JBD2 may report warnings via following
> >>> call trace:
> >>> ocfs2_dio_end_io_write
> >>>  ocfs2_mark_extent_written
> >>>   ocfs2_change_extent_flag
> >>>    ocfs2_split_extent
> >>>     ocfs2_try_to_merge_extent
> >>>      ocfs2_extend_rotate_transaction
> >>>       ocfs2_extend_trans
> >>>        jbd2__journal_restart
> >>>         start_this_handle
> >>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> >>>
> >>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> >>> handle extents in a batch of transaction.
> >>>
> >>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> >>> only be removed from the orphan list after the extent tree update is complete.
> >>> This ensures that if a crash occurs in the middle of extent tree updates, we
> >>> won't leave stale blocks beyond EOF.
> >>>
> >>> This patch also changes the logic for updating the inode size and removing
> >>> orphan, making it similar to ext4_dio_write_end_io(). Both operations are
> >>> performed only when everything looks good.
> >>>
> >>> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> >>> suggestions.
> >>>
> >>> Suggested-by: Jan Kara <jack@suse.cz>
> >>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >>> Reviewed-by: Jan Kara <jack@suse.cz>
> >>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>> ---
> >>>  fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
> >>>  1 file changed, 43 insertions(+), 28 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >>> index 09146b43d1f0..0c88f751ffd5 100644
> >>> --- a/fs/ocfs2/aops.c
> >>> +++ b/fs/ocfs2/aops.c
> >>> @@ -37,6 +37,8 @@
> >>>  #include "namei.h"
> >>>  #include "sysfile.h"
> >>>  
> >>> +#define OCFS2_DIO_MARK_EXTENT_BATCH 200
> >>> +
> >>>  static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
> >>>  				   struct buffer_head *bh_result, int create)
> >>>  {
> >>> @@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  	struct ocfs2_alloc_context *meta_ac = NULL;
> >>>  	handle_t *handle = NULL;
> >>>  	loff_t end = offset + bytes;
> >>> -	int ret = 0, credits = 0;
> >>> +	int ret = 0, credits = 0, batch = 0;
> >>>  
> >>>  	ocfs2_init_dealloc_ctxt(&dealloc);
> >>>  
> >>> @@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  		goto out;
> >>>  	}
> >>>  
> >>> -	/* Delete orphan before acquire i_rwsem. */
> >>> -	if (dwc->dw_orphaned) {
> >>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >>> -
> >>> -		end = end > i_size_read(inode) ? end : 0;
> >>> -
> >>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> >>> -				!!end, end);
> >>> -		if (ret < 0)
> >>> -			mlog_errno(ret);
> >>> -	}
> >>> -
> >>>  	down_write(&oi->ip_alloc_sem);
> >>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >>>  
> >>> @@ -2326,24 +2316,25 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  
> >>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> >>>  
> >>> -	handle = ocfs2_start_trans(osb, credits);
> >>> -	if (IS_ERR(handle)) {
> >>> -		ret = PTR_ERR(handle);
> >>> -		mlog_errno(ret);
> >>> -		goto unlock;
> >>> -	}
> >>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> >>> -	if (ret) {
> >>> -		mlog_errno(ret);
> >>> -		goto commit;
> >>> -	}
> >>> -
> >>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> >>> +		if (!handle) {
> >>> +			handle = ocfs2_start_trans(osb, credits);
> >>> +			if (IS_ERR(handle)) {
> >>> +				ret = PTR_ERR(handle);
> >>> +				mlog_errno(ret);
> >>> +				goto unlock;
> >>> +			}
> >>> +			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>> +					OCFS2_JOURNAL_ACCESS_WRITE);
> >>> +			if (ret) {
> >>> +				mlog_errno(ret);
> >>> +				goto commit;
> >>> +			}
> >>> +		}
> >>>  		ret = ocfs2_assure_trans_credits(handle, credits);
> >>>  		if (ret < 0) {
> >>>  			mlog_errno(ret);
> >>> -			break;
> >>> +			goto commit;
> >>>  		}
> >>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >>>  						ue->ue_cpos, 1,
> >>> @@ -2351,19 +2342,43 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>  						meta_ac, &dealloc);
> >>>  		if (ret < 0) {
> >>>  			mlog_errno(ret);
> >>> -			break;
> >>> +			goto commit;
> >>> +		}
> >>> +
> >>> +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> >>> +			ocfs2_commit_trans(osb, handle);
> >>> +			handle = NULL;
> >>> +			batch = 0;
> >>>  		}
> >>>  	}
> >>>  
> >>>  	if (end > i_size_read(inode)) {
> >>> +		if (!handle) {
> >>> +			handle = ocfs2_start_trans(osb, credits);
> >>> +			if (IS_ERR(handle)) {
> >>> +				ret = PTR_ERR(handle);
> >>> +				mlog_errno(ret);
> >>> +				goto unlock;
> >>> +			}
> >>> +		}
> >>>  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
> >>>  		if (ret < 0)
> >>>  			mlog_errno(ret);
> >>>  	}
> >>> +
> >>>  commit:
> >>>  	ocfs2_commit_trans(osb, handle);
> >>
> >> Seems checking 'handle' is still missing here.
> >>
> >> Joseph
> > 
> > I have a different view.
> > In the list_for_each_entry(), if it finishes because the condition
> > (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) is met, the handle will be null.
> > However, it will be initialized later within the i_size update block.
> > In my view, the handle must be non-null before entering ocfs2_commit_trans().
> > 
> 
> Ummm... inode size update is conditional, right?
> 
> Thanks,
> Joseph
> 

How stupid of me! understand your point now.

- Heming
