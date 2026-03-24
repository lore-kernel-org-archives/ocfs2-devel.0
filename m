Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DB3C3C06
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Mar 2026 07:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774336753; cv=none; b=erIlXuIEO54UDDGQ026f7E5/S7lknOBXGdJ4Nt5PJS9wAs/AgP0Zs5dlm2pr2nC7ubl0irqkzFvpdnFhILWOEUaYbF+BWs+dKgg6MCxNgxUYiEht5PM+dsKe6IlZm/R+FJgNNyjy2QLTazWV7cWchDVLtp99v13uAlIB6XH1Xj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774336753; c=relaxed/simple;
	bh=NWvw5/ClmO5ScRjBYdEj4DHpPHCxitCpDf5mGSFZBHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rs1G4Nb4oJMsxcgkZzYD3eCW1cKYYeLLIbFF+fdZgD8qSijoCnCq1THSjfVDPNAQZEIcypfzSP0M34O6G/TdHl35U4mdKhFfQvDc1QifwCTNQ3El+CmjoLleUjMeMsEBlc0aAJsW6BDwfBXxD9bmZ1pUfNyKO0DjFWVizEWFFDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g3BwfDDM; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g3BwfDDM"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-483ad568d68so7095085e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Mar 2026 00:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774336742; x=1774941542; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C513bjvIajggVoBYujaXRwmVtgpXvNf3vF4QTkToet4=;
        b=g3BwfDDMa0klTLi3BPwTWAL2TVdlyanDHwaCK2yPCfHvismpqB/ejNMLLHBeUu6e8c
         crr9UamtfD1r2IrAWqpCyi/U1sw9aY+D3T83pT4PgHS3LCKZmQl190m55mGgJpUSDwAx
         xt8NTYywZGFJFHDgAo1p4DbcfxLbAQoRjvDTMVjV5smT3VvxAQWYH3lVFMz8SxR4oMGX
         DOFT9I8WmTDOaYKRt7Mytl859h1BBir1aj2X85NeafTps6hvBmGke1900YmJFG4nYbyh
         FI/WSVJmlEgNSSbr05QOfWBqn3s0fzD84176Nlod5Zs08nrM5AeQKiiH7old56zlpF8x
         hXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774336742; x=1774941542;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C513bjvIajggVoBYujaXRwmVtgpXvNf3vF4QTkToet4=;
        b=sjdvWa/O0bTDsIr+m3fQl1Ea0oirtZzucOj7c7NyGIbMNw5mwvHwT9mnZ7dxgpcpTH
         5YVUJ18/xavWTNdT3Rw+qe0+0ncix7KHCH7/mBSVWsKIhILawd2G5Fd6OzLR2iAS7PVS
         8O2Kf60WRezN+gnast61tP6RcDn3UobMOPmzl0TAxVaSQW34dZ7RjV2gx1vsiA+xNmc1
         OJnbpHksYaULwrn+JSCEgTX2j8eaONGLzb4l9njWaSMlicfTkqcUz9oniR7t275lWp5n
         Zo0Ycqxdnurdc8VatMm0LIt/q/uGNF0BlNbC2xdxzWGgPsauISEd/x3OKfkof9FmmW3g
         mRsA==
X-Gm-Message-State: AOJu0Yw4areFSATieKUGPwuhxTb6TRC8El9mfPxwJfsy6N5DOjNVgtXX
	05+6C8sO95Zg5X1P1g36PDrcJ9Q+e4390BPZMBBZgq8fOHW/mxoll8xFfGmC1Fb+aOJ6c/uj89o
	yGz4R
X-Gm-Gg: ATEYQzzggNE0Jx1p7Z9vsNRTZKUvGfkQMnA+YIcMEzu3ZW2t1aRig5LoFc8L5uhMPbk
	wDLTM1UCPMdDiK6kCRLEstHNzOQiCsIutYHJANz4R/S99lcazUknaq04SOaJylSbZw5lMqZAgUJ
	0qF2gG3o64qK36S30YEXlKnImXuyiQxBBfbuj8/nu64IlOwGpGF1hkRRG40Erz9WfwmyVlQi8pn
	qUjI2xcSLCOAjXImQkMim/gXQg1AIZXvj83OtMcmFD+VHArGm4SHjbG5JY0r74dyeSimuChqk4w
	oMMz+37T27Tqfe3fdODEdPpimBGdv47IDzHPy+vOzUiljbqokoCVPkDrJiejNgSxut4sDoLBoF6
	VvnTxSfoRWH4sbFZqcwfW154HpAB5C7qbMovGDclyITJilOc7QtQfUxK1m8y3+ctFzQF4cj42fC
	INwPULT13V4Hh1OiuVvV4SWA==
X-Received: by 2002:a05:600c:630d:b0:485:385f:674d with SMTP id 5b1f17b1804b1-486ff0230d9mr137495825e9.8.1774336742072;
        Tue, 24 Mar 2026 00:19:02 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366b9aesm172099715ad.58.2026.03.24.00.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 00:19:01 -0700 (PDT)
Date: Tue, 24 Mar 2026 15:18:57 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, glass.su@suse.com
Subject: Re: [PATCH v2 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <asb2zcmotukhuk45efyv3nzpyv2uignjrs6mz2qn5qpuo2mb43@u4jbyfvv3sml>
References: <20260312162725.15523-1-heming.zhao@suse.com>
 <20260312162725.15523-2-heming.zhao@suse.com>
 <ca9c4609-210f-4426-a4e1-5ee732646411@linux.alibaba.com>
 <qziha6iel7os7c7ecgqphyiqluyf663ntlmxt65bibn5iregsl@qsxg6bi7r2ev>
 <488ccee8-f197-4326-aca4-4466003aed3e@linux.alibaba.com>
 <x7tv6dzqhiwcvld2cct4olou5oioeis5k4nlpr6oglpch2skvr@duochardclqx>
 <a108b18a-e27e-424c-80f1-c19ea2c30685@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a108b18a-e27e-424c-80f1-c19ea2c30685@linux.alibaba.com>

Sorry, I just found this mail. Please ignore my previous mail.

On Thu, Mar 19, 2026 at 09:53:16AM +0800, Joseph Qi wrote:
> 
> 
> On 3/18/26 2:40 PM, Heming Zhao wrote:
> > On Fri, Mar 13, 2026 at 12:53:32PM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 3/13/26 11:17 AM, Heming Zhao wrote:
> >>> On Fri, Mar 13, 2026 at 10:04:11AM +0800, Joseph Qi wrote:
> >>>> Almost looks fine, minor updates below.
> >>>>
> >>>> On 3/13/26 12:27 AM, Heming Zhao wrote:
> >>>>> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> >>>>> ocfs2_dio_end_io_write
> >>>>>  ocfs2_mark_extent_written
> >>>>>   ocfs2_change_extent_flag
> >>>>>    ocfs2_split_extent
> >>>>>     ocfs2_try_to_merge_extent
> >>>>>      ocfs2_extend_rotate_transaction
> >>>>>       ocfs2_extend_trans
> >>>>>        jbd2__journal_restart
> >>>>>         start_this_handle
> >>>>>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> >>>>>
> >>>>> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
> >>>>> handle each extent in a separate transaction.
> >>>>>
> >>>>> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> >>>>> only be removed from the orphan list after the extent tree update is complete.
> >>>>> this ensures that if a crash occurs in the middle of extent tree updates, we
> >>>>> won't leave stale blocks beyond EOF.
> >>>>>
> >>>>> This patch also removes the only call to ocfs2_assure_trans_credits(), which
> >>>>> was introduced by commit be346c1a6eeb ("ocfs2: fix DIO failure due to
> >>>>> insufficient transaction credits").
> >>>>>
> >>>>> Finally, thanks to Jans for providing the bug fix prototype and suggestions.
> >>>>>
> >>>>> Suggested-by: Jan Kara <jack@suse.cz>
> >>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> >>>>> ---
> >>>>>  fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
> >>>>>  1 file changed, 29 insertions(+), 29 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >>>>> index 09146b43d1f0..91997b330d39 100644
> >>>>> --- a/fs/ocfs2/aops.c
> >>>>> +++ b/fs/ocfs2/aops.c
> >>>>> @@ -2294,18 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>>>  		goto out;
> >>>>>  	}
> >>>>>  
> >>>>> -	/* Delete orphan before acquire i_rwsem. */
> >>>>> -	if (dwc->dw_orphaned) {
> >>>>> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >>>>> -
> >>>>> -		end = end > i_size_read(inode) ? end : 0;
> >>>>> -
> >>>>> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> >>>>> -				!!end, end);
> >>>>> -		if (ret < 0)
> >>>>> -			mlog_errno(ret);
> >>>>> -	}
> >>>>> -
> >>>>>  	down_write(&oi->ip_alloc_sem);
> >>>>>  	di = (struct ocfs2_dinode *)di_bh->b_data;
> >>>>>  
> >>>>> @@ -2326,44 +2314,56 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>>>>  
> >>>>>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
> >>>>>  
> >>>>> -	handle = ocfs2_start_trans(osb, credits);
> >>>>> -	if (IS_ERR(handle)) {
> >>>>> -		ret = PTR_ERR(handle);
> >>>>> -		mlog_errno(ret);
> >>>>> -		goto unlock;
> >>>>> -	}
> >>>>> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>>>> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> >>>>> -	if (ret) {
> >>>>> -		mlog_errno(ret);
> >>>>> -		goto commit;
> >>>>> -	}
> >>>>> -
> >>>>>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> >>>>> -		ret = ocfs2_assure_trans_credits(handle, credits);
> >>>>> -		if (ret < 0) {
> >>>>> +		handle = ocfs2_start_trans(osb, credits);
> >>>>> +		if (IS_ERR(handle)) {
> >>>>> +			ret = PTR_ERR(handle);
> >>>>>  			mlog_errno(ret);
> >>>>>  			break;
> >>>>
> >>>> I'd rather goto unlock directly without update i_size in case error.
> >>>
> >>> agree
> >>>>
> >>>>>  		}
> >>>>> +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> >>>>> +					      OCFS2_JOURNAL_ACCESS_WRITE);
> >>>>> +		if (ret) {
> >>>>> +			mlog_errno(ret);
> >>>>> +			ocfs2_commit_trans(osb, handle);
> >>>>> +			break;
> >>>>
> >>>> Ditto.
> >>>
> >>> agree
> >>>>
> >>>>> +		}
> >>>>>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >>>>>  						ue->ue_cpos, 1,
> >>>>>  						ue->ue_phys,
> >>>>>  						meta_ac, &dealloc);
> >>>>>  		if (ret < 0) {
> >>>>>  			mlog_errno(ret);
> >>>>> +			ocfs2_commit_trans(osb, handle);
> >>>>>  			break;
> >>>>
> >>>> Ditto.
> >>>
> >>> The existing code still updates i_size even if ocfs2_mark_extent_written()
> >>> returns an error. I am not certain whether updating i_size in this case is
> >>> correct, but I prefer to maintain the original logic for now.
> >>> Does that seem reasonable to you?
> >>>
> >>
> >> Since it returns 0 for unwritten extents, it looks fine.
> >>
> >>>> BTW, we can move ocfs2_commit_trans() rightly after ocfs2_mark_extent_written()
> >>>> to save the extra call in case error.
> >>>
> >>> agree
> >>>
> >>> I ran a DIO test using 64MB chunk size (e.g.: fio --bs=64M), the dwc->dw_zero_count
> >>> is about 12107 ~ 12457.
> >>> Regarding the transaction splitting in the unwritten handling loop: this patch
> >>> introduces a minor performance regression. I would like to merge some of the
> >>> transaction calls. e.g.: by starting a new transaction every 100 or 200 iterations.
> >>> What do you think of this approach?
> >>>
> >>
> >> Seems we can limit max credit for a single transaction here?
> >> If exceeds, restart a new one.
> >>
> >> Joseph,
> >> Thanks
> > 
> > sorry for the late reply, I spend some time running the tests.
> > I have created two different types of patches (see below) to address this issue.
> > 
> > time consumption results:
> > 
> > ocfs2-dynamic-... patch
> > real    2m9.900s
> > user    0m0.333s
> > sys     0m22.687s
> > 
> > %200 of ocfs2-split-trans-... patch
> > real    1m48.901s
> > user    0m0.306s
> > sys     0m23.019s
> > 
> > %500 of ocfs2-split-trans-... patch
> > real    1m49.350s
> > user    0m0.299s
> > sys     0m22.718s
> > 
> > As shown above, the fixed "500% mode" is faster than the dynamic style.
> > Which approach do you prefer?
> > 
> I'd prefer solution B, it looks simpler to directly set a commit batch.
> Some comments for the formal patch：
> 1. I don't think you have to use 'cnt + trans_start + mod' to control
> the batch commit, just check 'batch + handle' seems enough.
> 2. Define a macro for the batch, e.g. OCFS2_DIO_MARK_EXTENT_BATCH,
> 3. Do not update i_size in case error.
> 4. Correctly handle commit transaction in case error.
> 
> Thanks,
> Joseph
> 
> 
