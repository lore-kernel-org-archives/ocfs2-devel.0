Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD7E38AC73
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 07:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775115794; cv=none; b=ec1YSRVjIWhHEYHY7rtgbcuMo/DybxP35+7uq7PxV/PRFDs7D9ZcHsEnE8hZwGo48c7KJn5i9vvW38JkpHdjM87pHGdTZDponWxlmRJZrJ/s1kkoUJ+NXEkfn5DcRU1L2AmCrs5MSN3XdqS5JIlekC+f+O8iHRsNjWUHaJsogd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775115794; c=relaxed/simple;
	bh=2F4cAVaplgfBfp4oa8yTDB4ZYe4v5pwGjFL+2DwVeDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t38fG3KWA3/UHX6IS57BIJR5keRcpu2nCrYJYESikl7OxOAqaNak2BXOI0mS64qzR4MZoTwwJ0rSaSrB2N3hTB2Jv/+7vvwmAME0Ur7/k+ACwCTg/433/l1jkube4i4934eqJrwxF/LsD5FW5fBVZtc5UwcEzNNH7XbJ/Tw6u9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eUtinMgS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eUtinMgS"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483ad568d68so700115e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 00:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775115791; x=1775720591; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6NEXtaIUnovsgeppWtSAzpIo/1Yj1vs7So626HncXT4=;
        b=eUtinMgSIKezAojWl4dYQ7rBzMWV6eDOzPLCxALeCWCDDVOfjeuHe5UDTYByN17xg7
         b6/ZErT95a83onLNvZfe7dCRgsnmvj1MfELV6vNlQk6F+2MemXDZjOrJoESobKGMD1lb
         JPnXoYkUB63FoKUS5qAgWhyPgF+KcIZiXODNHY88/ZbQZxIgWXFsxZRfC5zB0v6zC0zr
         mz83n+f51Gk+q8bOICtapKRqEP7qUMActqjrIj1dzy0WEVotRDCcRp9ONdm5vMSy1K41
         ihFgfqLe4ZXqrgZLPrbvBXaR+nfnFOeaGMHnuF131FAuAnvK1Q2iLqzMsGmNNaFq767h
         ELlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775115791; x=1775720591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6NEXtaIUnovsgeppWtSAzpIo/1Yj1vs7So626HncXT4=;
        b=ADT4FCnj3Zww9KXXqtldEAw/t7zg+pL7+nQIuyO4B3kmu/Rv7O8XyP4hUVQ4GnKDAi
         S0eQVa0ov0Ji9mf3UBsDxacpBO66RBFhpqjkBUfF+ndN4EldvwiNE+v9uAACzXCO2fsO
         3rKa6q6b2MzVHIUD0uio86TMjSJyRYRx+AqQoeXajC5w86PKNUMzs8vIJsI1zTOgQTsw
         URXbx0lfBXEMRl1wLCKYsriQl17lTQovm6XvWFYsmknxzLvZrC4knTYLGX7d++3bRXHm
         Pj9k/8cAD+j/wV+wA/9z8kToR40/GrHGwGM7v8UGZP23d0TYvzpVuLHnZAt85YGOp5fG
         d9Gw==
X-Gm-Message-State: AOJu0YznoAArHZGxVohuadwyPA/qiaLOtV7JvcYOXc1dcAsSMANyGf4L
	UU5e85eiuSnm6XT1AlrmsCLn8wnzZ6o70dwnnuWMdQakK9shvKwihguBNJOadRimIOM=
X-Gm-Gg: ATEYQzyQwyBGiNjtaB9OEIyB8hOfs1btWo8O+jugxe2l9yANA3SHTbZQDrn0WqsaOGQ
	kZDqNcXgvSJeZ2y6PP9JaBNsGfxGm9PsnlUIRPB0GSXt4PEXnwvXI/lr4tLb2MQMf5lM0F8B1zW
	hIOpYyfjwhm1tsf7HVlNFV+Ye7Rze6dBKxvY1AnaBrvgcRQGeWpnuqfRxKDrv0c0wX4NjWdhVCr
	GqelIhcDTuOWelNmWp3520klEXgAuqfAJChYeY7E42JpcTx9+P1LScOk6p7teY9HF1zuYnrRfVn
	b9j0cK+/EJi/z9oPpQIICdEXBVIgcMu2kvczzXKlDjZ6hAPFbStPiAjyjDdEBHa540fO5TrL+zb
	/QjsAElK3meCxeJak+09nlPTIpXej0NJxeHz2nwoUpuz7w+jMFbvx327hLUz15EB15/nqtarF4x
	DdwQ5vgQiejAuraLD25rHJziCed+2h9bls
X-Received: by 2002:a05:600c:609b:b0:488:8d97:9982 with SMTP id 5b1f17b1804b1-4888d979adfmr13538295e9.1.1775115790551;
        Thu, 02 Apr 2026 00:43:10 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b23c6asm2947538b3a.10.2026.04.02.00.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:43:09 -0700 (PDT)
Date: Thu, 2 Apr 2026 15:43:06 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <c3ejq4wbe5cti6ytkd7snpggrtjwhbg24sc4tyspktdw6uuiku@34b57p35etps>
References: <20260402022655.19714-1-heming.zhao@suse.com>
 <20260402022655.19714-2-heming.zhao@suse.com>
 <a2fc77e1-3790-44fe-b146-78b1275fd953@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2fc77e1-3790-44fe-b146-78b1275fd953@linux.alibaba.com>

On Thu, Apr 02, 2026 at 03:07:10PM +0800, Joseph Qi wrote:
> 
> 
> On 4/2/26 10:26 AM, Heming Zhao wrote:
> > During ocfs2 dio operations, JBD2 may report warnings via following
> > call trace:
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
> > handle extents in a batch of transaction.
> > 
> > Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> > only be removed from the orphan list after the extent tree update is complete.
> > This ensures that if a crash occurs in the middle of extent tree updates, we
> > won't leave stale blocks beyond EOF.
> > 
> > This patch also changes the logic for updating the inode size and removing
> > orphan, making it similar to ext4_dio_write_end_io(). Both operations are
> > performed only when everything looks good.
> > 
> > Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> > suggestions.
> > 
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 43 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 09146b43d1f0..0c88f751ffd5 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -37,6 +37,8 @@
> >  #include "namei.h"
> >  #include "sysfile.h"
> >  
> > +#define OCFS2_DIO_MARK_EXTENT_BATCH 200
> > +
> >  static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
> >  				   struct buffer_head *bh_result, int create)
> >  {
> > @@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  	struct ocfs2_alloc_context *meta_ac = NULL;
> >  	handle_t *handle = NULL;
> >  	loff_t end = offset + bytes;
> > -	int ret = 0, credits = 0;
> > +	int ret = 0, credits = 0, batch = 0;
> >  
> >  	ocfs2_init_dealloc_ctxt(&dealloc);
> >  
> > @@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> > @@ -2326,24 +2316,25 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> > +		if (!handle) {
> > +			handle = ocfs2_start_trans(osb, credits);
> > +			if (IS_ERR(handle)) {
> > +				ret = PTR_ERR(handle);
> > +				mlog_errno(ret);
> > +				goto unlock;
> > +			}
> > +			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> > +					OCFS2_JOURNAL_ACCESS_WRITE);
> > +			if (ret) {
> > +				mlog_errno(ret);
> > +				goto commit;
> > +			}
> > +		}
> >  		ret = ocfs2_assure_trans_credits(handle, credits);
> >  		if (ret < 0) {
> >  			mlog_errno(ret);
> > -			break;
> > +			goto commit;
> >  		}
> >  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >  						ue->ue_cpos, 1,
> > @@ -2351,19 +2342,43 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  						meta_ac, &dealloc);
> >  		if (ret < 0) {
> >  			mlog_errno(ret);
> > -			break;
> > +			goto commit;
> > +		}
> > +
> > +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> > +			ocfs2_commit_trans(osb, handle);
> > +			handle = NULL;
> > +			batch = 0;
> >  		}
> >  	}
> >  
> >  	if (end > i_size_read(inode)) {
> > +		if (!handle) {
> > +			handle = ocfs2_start_trans(osb, credits);
> > +			if (IS_ERR(handle)) {
> > +				ret = PTR_ERR(handle);
> > +				mlog_errno(ret);
> > +				goto unlock;
> > +			}
> > +		}
> >  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
> >  		if (ret < 0)
> >  			mlog_errno(ret);
> >  	}
> > +
> >  commit:
> >  	ocfs2_commit_trans(osb, handle);
> 
> Seems checking 'handle' is still missing here.
> 
> Joseph

I have a different view.
In the list_for_each_entry(), if it finishes because the condition
(++batch == OCFS2_DIO_MARK_EXTENT_BATCH) is met, the handle will be null.
However, it will be initialized later within the i_size update block.
In my view, the handle must be non-null before entering ocfs2_commit_trans().

- Heming
> 
> >  unlock:
> >  	up_write(&oi->ip_alloc_sem);
> > +
> > +	/* everything looks good, let's start the cleanup */
> > +	if (!ret && dwc->dw_orphaned) {
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
