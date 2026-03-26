Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AA22DB78C
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534544; cv=none; b=WLgPmpd2M+t8+Fv9kh5Wl3hWzrm9x95zUvwpu4RX2SW2RyViwxhmnSRADQZOZ174OmwTdLqRsYcCTWsWlXBqLQHZjpKlvw7EQXpVlgik6Woiw+0flzvOnTZ0yzsM98+wKCxynnRITER2aIftCfdlUPkD+qgMlqnU2ICbWazTHjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534544; c=relaxed/simple;
	bh=VIZo5BN0VKU+BM1vidUrUqsmdmPrTikGoj+Pp56t/P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHceBdTcFy0CHoNOM+mRZTNF508Nag6xJdvqThgUx07MxkxP5i2lD4Tk/w8FeJ8xoryqdKg0uVHvDHQw+f/jnNw4LLtlChOGUwlHmjW7f/BbYkNwfJThQuM8/fwqLCiW1vlZCB8Ml7Q5owusnrQ0uCCfOxYtOeVbsObepwamw7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IN/gdeyf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IN/gdeyf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4853a485721so1438585e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 07:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774534534; x=1775139334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z0fq3qmtxns1l1NxCZJkfhnRXqHObFn9YbyHR4tDNqc=;
        b=IN/gdeyfZ221uSKrpZr5Ori5ObJPqeltfieda3Gc/SmxFf1PNzlncpxkSNv8PHS7xU
         LqWbEVWJFPHJ6WOXgPFJnlZRWTYwna3/BbmqqSjP+mhHdhdWuHNOR5AR2QcWM6JTuD7o
         4uRk7SVUsAbokippd8p+SjasKe9YO293/sjw+ahZ2cQ4OJ1B+7fHvjRpK6jDZshxZ6ZE
         8CtXwjBW162P3qZKZIQ//CnlkFm4/dKNJs517t5L48bzDucvGF22kRKWJBl6owR8kvX5
         gPpazkzUybq5xwl49yoFFM+qdvVrnUafyxWIb8A7cvJuQg3t80NvCk0eyuuAFAUAEpE0
         v8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774534534; x=1775139334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z0fq3qmtxns1l1NxCZJkfhnRXqHObFn9YbyHR4tDNqc=;
        b=dr7OnmZ/ZUXN8ZaMYlJbdz9MZImlvQ1qxx1xRA2Bz3HV28o/sjsprKFTQlmNVdI3ye
         RCByJPISUI2szqMdVpiaIGjP9fqZdgsWvXT7jOjrlmDeUsYIhD/ilrbJYGFILhVES2bO
         Ydq25ImiBfVTLmR/UzA2Z/DiTxrkOn8LD28r17QJJ/zskkC8B0i9vFPjQbofZrckEYoL
         YZLceDC66oOqRpzewnyASFIzjyYH5reMm+h/HnnfacjeAx0FO5EDmrvzGVwpOc8hYF5U
         JiCN6opOw7jo6GlxcAiwgpFFKDkHRIdlkq/MuYsvWOFiqh4UFMO53kc7qduKneQqJUs4
         d1LA==
X-Forwarded-Encrypted: i=1; AJvYcCUkibqB7W0tq2RS7V5lSG+SJBo2x393kzIIptPs9ZHcSaPmEkzsFE9kh9our8zUq7gtuUBVPRl4GlVEFA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6wHAnlXtBDTQ00PoRKojenp+MhTg1PSCh0li2fWjm/hr+q+I2
	zxrvTED/nFNIKe/Wt2CyabsjdeJjsjfjmVxg8OYjfweSrm2GYs4BCT1i4MPcsBr5FRs=
X-Gm-Gg: ATEYQzxoVLHTywedxbsg7jWZKnP/N4Ic9wAwxRHWrbYHPyvpaO7mLgalas31/e+hbin
	T5/SeM/+QiViyKHi4rbdP3JGNxLwuBZvp7WzDOpKaJTR/mqJJSDumGW6+XsVa+VOYdjGCujrcBS
	cRKe30v2WTb0BbsQ25OPv6jBDekTXsMM06KkKeHs/7EU9OdmvunBueS69c6JuUlA4Q8sgpyPuIA
	/chnPNcENk7lO8O7JEU+g/S67RWF3S3pgMiWRZu7PHkVuZjzYGKbfRssjIuC+E/xBXHmmtKGyLF
	SfD5+jU7Iroeo6p6eEPTDjYm+U1uLNxajQgI2R9ifYm7DxmOL5giFzEZbbq4lmx+JxMf7EoM1bw
	eofOE6GnppkEsj3BAphsEmr4lU+us6Ka1bvN+pqbkBfsRvD7kHpY+G1+Hdw512jSFvRsTCaVM7R
	LVOGGYjMtp2KgWOeNRd4TM0w==
X-Received: by 2002:a05:600c:1f95:b0:485:39a1:bcb3 with SMTP id 5b1f17b1804b1-48716084c18mr72719515e9.6.1774534533464;
        Thu, 26 Mar 2026 07:15:33 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3d5e81sm2780958b3a.51.2026.03.26.07.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 07:15:32 -0700 (PDT)
Date: Thu, 26 Mar 2026 22:15:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Jan Kara <jack@suse.cz>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, glass.su@suse.com
Subject: Re: [PATCH v3 2/2] Revert "ocfs2: fix DIO failure due to
 insufficient transaction credits"
Message-ID: <s57trajykxnqjj7h7v5kuwjwqtd5b5jk53wull5yj65pdgunc7@ortij4g2kaiv>
References: <20260326065821.15156-1-heming.zhao@suse.com>
 <20260326065821.15156-3-heming.zhao@suse.com>
 <6byxycm7y3ppayqux5ylpvmoerwdldyyn6pysptsnwinm6ixsv@wgbxngzbyghd>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6byxycm7y3ppayqux5ylpvmoerwdldyyn6pysptsnwinm6ixsv@wgbxngzbyghd>

On Thu, Mar 26, 2026 at 10:38:06AM +0100, Jan Kara wrote:
> On Thu 26-03-26 14:58:18, Heming Zhao wrote:
> > This reverts commit be346c1a6eeb49d8fda827d2a9522124c2f72f36.
> > 
> > With the patch "ocfs2: split transactions in dio completion to avoid
> > credit exhaustion," the jbd2 transaction is now restarted every
> > OCFS2_DIO_MARK_EXTENT_BATCH loops. In theory, this should prevent
> > credit exhaustion issues from occurring.
> 
> I don't see why that would be the case. Look at the commit message of
> be346c1a6eeb49d8fda827d2a9522124c2f72f36. The problem is that
> ocfs2_calc_extend_credits() doesn't (and hardly can) estimate maximum
> number of credits needed for all extent tree manipulations. Some extent tree
> manipulations in ocfs2_mark_extent_written() don't reserve additional
> credits on their own. This ocfs2_assure_trans_credits() call won't be
> needed if you didn't do any batching of extent conversions into a single
> transaction. But if you do that, there's no guarantee that all conversions
> in a single batch can fit in the amount of credits reserved initially.
> Usually it will be the case but I don't see how that would be guaranteed in
> every case.
> 
> 								Honza

Thanks for your careful review. I agree with your point, and I will remove
the revert patch in the v4.

Meanwhile, I have done some tests: the case handled by ocfs2_assure_trans_credits()
is when "old_nblks < nblocks". In my env, old_nblks is a fixed value of 15
("15 < 16"). When writing a fragmented 2GB file, ~400000 loops occur in
ocfs2_dio_end_io_write(), and this condition is triggered about 5 times in total.

- Heming
> 
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/aops.c        |  5 -----
> >  fs/ocfs2/journal.c     | 17 -----------------
> >  fs/ocfs2/journal.h     |  2 --
> >  fs/ocfs2/ocfs2_trace.h |  2 --
> >  4 files changed, 26 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 60f1b607022f..e58314c6506a 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2332,11 +2332,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  				break;
> >  			}
> >  		}
> > -		ret = ocfs2_assure_trans_credits(handle, credits);
> > -		if (ret < 0) {
> > -			mlog_errno(ret);
> > -			break;
> > -		}
> >  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> >  						ue->ue_cpos, 1,
> >  						ue->ue_phys,
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 4c86a9d46870..7e7546e070fb 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -464,23 +464,6 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
> >  	return status;
> >  }
> >  
> > -/*
> > - * Make sure handle has at least 'nblocks' credits available. If it does not
> > - * have that many credits available, we will try to extend the handle to have
> > - * enough credits. If that fails, we will restart transaction to have enough
> > - * credits. Similar notes regarding data consistency and locking implications
> > - * as for ocfs2_extend_trans() apply here.
> > - */
> > -int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
> > -{
> > -	int old_nblks = jbd2_handle_buffer_credits(handle);
> > -
> > -	trace_ocfs2_assure_trans_credits(old_nblks);
> > -	if (old_nblks >= nblocks)
> > -		return 0;
> > -	return ocfs2_extend_trans(handle, nblocks - old_nblks);
> > -}
> > -
> >  /*
> >   * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
> >   * If that fails, restart the transaction & regain write access for the
> > diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> > index 6397170f302f..9d4763f758ad 100644
> > --- a/fs/ocfs2/journal.h
> > +++ b/fs/ocfs2/journal.h
> > @@ -244,8 +244,6 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
> >  int			     ocfs2_commit_trans(struct ocfs2_super *osb,
> >  						handle_t *handle);
> >  int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
> > -int			     ocfs2_assure_trans_credits(handle_t *handle,
> > -						int nblocks);
> >  int			     ocfs2_allocate_extend_trans(handle_t *handle,
> >  						int thresh);
> >  
> > diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> > index 4b32fb5658ad..74b283875e17 100644
> > --- a/fs/ocfs2/ocfs2_trace.h
> > +++ b/fs/ocfs2/ocfs2_trace.h
> > @@ -2575,8 +2575,6 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
> >  
> >  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
> >  
> > -DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
> > -
> >  DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
> >  
> >  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
> > -- 
> > 2.43.0
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
