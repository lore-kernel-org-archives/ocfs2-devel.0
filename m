Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21831BCA1C
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Mar 2026 03:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773371865; cv=none; b=HUksaFDo8eT3okh+pVHGcKuAephVRcAF+OE/jqlf2HbSKY/p3XniNfVi8FX8buNQG38mE9pzVXh9lpBH0uKqLZ+vFh5nTM709PhcNz3lig62ODPIo5Cafdv7DfxDrD12mDSlLRiUZfwjpqH/efZ7dUom7mX/S0sydRnkuVBeZWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773371865; c=relaxed/simple;
	bh=+0DgmFjdwoynKyD3IO4Yw5eHWyARF8SDTEl5yGInIJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7yhbr85hkvSIdPrNyvOmKLlD2oXykVptNos6LAWE5lu8ng5ChlkwlS43VngEtEIaeSFDyQbXi01VgSlbfAd3qcJsYFa0AvmMWxI5NarnTMWOp13OTXTeWUwybNs0emliwMwdnl4o2+2tjHHaSfxyek8xAD1GOB2G7QSwIdDTEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IGFLMYbf; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IGFLMYbf"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43a03284a08so137377f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 20:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773371862; x=1773976662; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/EU3+N/lVFOYSRjZOG5syTu7A18jFZS0SCj/GmdaFc=;
        b=IGFLMYbfVGE4yrdr6JU2wZYyTwbA0nP0w7K6v9O4VXisZU3uvVncFkp3xkNUZwcCUm
         yi8tS8DeF3ry65W3rsUjHLTFUbpufjSCm/dOvJGh1P6II3ucnkr8sihgL3Lfzi84HtwY
         1QpcD9clsnC+ddTckRVrvW1Zo69u1ABg7gtUdT8fjHVy9Z+P3Eh/wXIaUOPeX1HXxi3t
         /BIWovz7PPbG/Dcjl5rorDy3lVtW37FuvXwgPJPs4g6NBgj20jq8/jQ0OaXlPKFxYkAy
         +6KZsvjO8GucY9sbD4DnJ0qL7GbPC7IKehtSabHy4Rgz84pRtkc4TopQyG51lanKAwaU
         VJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773371862; x=1773976662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/EU3+N/lVFOYSRjZOG5syTu7A18jFZS0SCj/GmdaFc=;
        b=IkNA7Wt9MD6txWGP/FgyCQrvKeMGb0dCuYU+9gHchlHtRaRxV/aqP1YGMc7WaEyaBr
         buj4ZhExhHCchx5qZi8trU4caSW6Jfp6zvUQG7V3EG53LJmAgtLR/XojUAjZsfa3ndgg
         rj2yKpTKNF7kjuYCgCm6nTi/jqhqvVt6ER7eFVwSuiukdtNxHjpi7qcrZ5y9BxibYTHx
         X0shAJSIoVcN5Y06/18XSiu8VupDCFxFCWRJ26AFXwzoJmXeb9rKBCMJlHbqBDz6XUke
         uNj4WXKuSbK3m9yE1jGjecJ4uY18NlS+Y3rdiRprbAjOFafyjGyA/Q+rHNcW+WxmZLYB
         wjDg==
X-Gm-Message-State: AOJu0Yy9bDJlFgW8JFFxgF4waBxcThpoq5N1QrkRbtzaA/n0KvYt4YgG
	yyVUxnePC+DraMPovBYVyCnXAjHnuZ4eQn3pXPiwwrVzpV9YPjbSYfdqhPhEkyJ43p4=
X-Gm-Gg: ATEYQzxdw712/4USwEkeZefe2Mxsk/lSMMQlcpunb2fGCRmHHOP5EYSt0D3aTCoRdvj
	5iwqBOPpew/wW7THZwCywIBMrBAjZ0RzJWc5V3fGoC3d9V0sPuElBkFw3motMX3b4m71TfmmPaT
	qT4FDKZzydQxHpQ/nmGJj6pWVx9Dgj4lHr8Y+I9Hj6jkslbw5FLe2TugyiESe34oC0EjKldz9HG
	ksFGs/Cj+cwgcNDr0+TD+Dc5A1bej981NUc8EMWYpFWCeeaNyIdw49nEuhnSw+gU4o39700NUbK
	t4rmZu2phXfpJ5JwhCwGGINT5AGM6avA3A0DsfzBdkJRJfC77faU/gkDCdKkH6EUGk9blls63xy
	KyHtA951XRhLfsPYMwOPcN3djSb7QGE7IujEfLti15SBct8sqNuOSNrCXMP1gE2CjQVRy6fcmgC
	MbpL/DOlMCcQ429iBUIKQgMg==
X-Received: by 2002:a05:600c:83c5:b0:485:2fe9:33a7 with SMTP id 5b1f17b1804b1-4855670529bmr12944705e9.3.1773371862139;
        Thu, 12 Mar 2026 20:17:42 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a15b44f61sm1593975b3a.7.2026.03.12.20.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 20:17:41 -0700 (PDT)
Date: Fri, 13 Mar 2026 11:17:37 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>

On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
> Almost looks fine, minor updates below.
> 
> On 3/13/26 12:27 AM, Heming Zhao wrote:
> > During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> > ocfs2_dio_end_io_write
> >  ocfs2_mark_extent_written
> >   ocfs2_change_extent_flag
> >    ocfs2_split_extent
> >     ocfs2_try_to_merge_extent
> >      ocfs2_extend_rotate_transaction
> >       ocfs2_extend_trans
> >        jbd2__journal_restart
> >         start_this_handle
> >          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> > 
> > To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> > handle each extent in a separate transaction.
> > 
> > Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> > only be removed from the orphan list after the extent tree update is complete.
> > this ensures that if a crash occurs in the middle of extent tree updates, we
> > won't leave stale blocks beyond EOF.
> > 
> > This patch also removes the only call to ocfs2_assure_trans_credits(), which
> > was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
> > insufficient transaction credits").
> > 
> > Finally, thanks to Jans for providing the bug fix prototype and suggestions.
> > 
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
> >  1 file changed, 29 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 09146b43d1f0..91997b330d39 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  		goto out;
> >  	}
> >  
> > -	/* Delete orphan before acquire i_rwsem. */
> > -	if (dwc->dw_orphaned) {
> > -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> > -
> > -		end = end > i_size_read(inode) ? end : 0;
> > -
> > -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> > -				!!end, end);
> > -		if (ret < 0)
> > -			mlog_errno(ret);
> > -	}
> > -
> >  	down_write(&oi->ip_alloc_sem);
> >  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >  
> > @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  
> >  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> >  
> > -	handle = ocfs2_start_trans(osb, credits);
> > -	if (IS_ERR(handle)) {
> > -		ret = PTR_ERR(handle);
> > -		mlog_errno(ret);
> > -		goto unlock;
> > -	}
> > -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> > -				      OCFS2_JOURNAL_ACCESS_WRITE);
> > -	if (ret) {
> > -		mlog_errno(ret);
> > -		goto commit;
> > -	}
> > -
> >  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> > -		ret = ocfs2_assure_trans_credits(handle, credits);
> > -		if (ret < 0) {
> > +		handle = ocfs2_start_trans(osb, credits);
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> >  			mlog_errno(ret);
> >  			break;
> 
> I'd rather goto unlock directly without update i_size in case error.

agree
> 
> >  		}
> > +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> > +					      OCFS2_JOURNAL_ACCESS_WRITE);
> > +		if (ret) {
> > +			mlog_errno(ret);
> > +			ocfs2_commit_trans(osb, handle);
> > +			break;
> 
> Ditto.

agree
> 
> > +		}
> >  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >  						ue->ue_cpos, 1,
> >  						ue->ue_phys,
> >  						meta_ac, &dealloc);
> >  		if (ret < 0) {
> >  			mlog_errno(ret);
> > +			ocfs2_commit_trans(osb, handle);
> >  			break;
> 
> Ditto.

The existing code still updates i_size even if ocfs2_mark_extent_written()
returns an error. I am not certain whether updating i_size in this case is
correct, but I prefer to maintain the original logic for now.
Does that seem reasonable to you?

> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
> to save the extra call in case error.

agree
> 
> Thanks,
> Joseph
> 

I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
is about 12107 ~ 12457.
Regarding the transaction splitting in the unwritten handling loop: this patch
introduces a minor performance regression. I would like to merge some of the
transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
What do you think of this approach?

Heming
> >  		}
> > +		ocfs2_commit_trans(osb, handle);
> >  	}
> >  
> >  	if (end > i_size_read(inode)) {
> > +		handle = ocfs2_start_trans(osb, credits);
> > +		if (IS_ERR(handle)) {
> > +			ret = PTR_ERR(handle);
> > +			mlog_errno(ret);
> > +			goto unlock;
> > +		}
> >  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
> >  		if (ret < 0)
> >  			mlog_errno(ret);
> > +		ocfs2_commit_trans(osb, handle);
> >  	}
> > -commit:
> > -	ocfs2_commit_trans(osb, handle);
> > +
> >  unlock:
> >  	up_write(&oi->ip_alloc_sem);
> > +
> > +	/* everything looks good, let's start the cleanup */
> > +	if (dwc->dw_orphaned) {
> > +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> > +
> > +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
> > +		if (ret < 0)
> > +			mlog_errno(ret);
> > +	}
> >  	ocfs2_inode_unlock(inode, 1);
> >  	brelse(di_bh);
> >  out:
> 
