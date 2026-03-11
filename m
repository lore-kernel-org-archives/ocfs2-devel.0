Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9FF2C187
	for <ocfs2-devel@lists.linux.dev>; Wed, 11 Mar 2026 05:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773207814; cv=none; b=Yzs7tSN5DrYv5S9wcOaQwSO7IKC9Y8/SKG0MhEj8RVUvF8YRFVxF5iq6wDwThfLJsE+YQTjqd6JV5BN7AYw6iCr1EP2r5vqGLXeFdbL9phczYIQOzpe0FiTG2gPirr+FLu/ypGerjael0gVAyvelis9oVm5IejF9KXjBo/NJpxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773207814; c=relaxed/simple;
	bh=qd1MybN4h1G9ePMHLZeY6ctVeJTfl3BQtmPrsrzdSn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICFQDajbUt5rnE3Yg+jIpQxz48XZHW1XPh3HZNJi/H2JKGXv9khvtJDA4iQnsRwv3Sbb8m7xXPdtGPLVK6AGD2D8+5MkY3WY3J0xRBloOC1TmNJGsXQ+ttrRH6Oy4+0L5MgcuBDFqULoh/RvEtgB2pHGB6Qu7Tz9OsjARqjBDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Om/iEO5W; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Om/iEO5W"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4853a5ffc05so6409015e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Mar 2026 22:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773207811; x=1773812611; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBkKlz74W2gpOmgKJ/EWZaEsQiCj+3juokwV2ivcA9E=;
        b=Om/iEO5W/xyWLgT8D3hW5FbreSOrVnV/HG/mDphPdVb9F2wJby0ZEi0y8dmp43wmiF
         MFFeWqfufsyqLi/n6kN4QfOVHfDqy5NzphcLZaYizRMzi+5jcz+vR3FQ0BKI0qev+csl
         i7J7qRnIMaGdh/JjuRpE0FV8jlveZpURDFfPci2TR0dpciMaSTe/9udqpEb1ei9jFZlq
         sFPVL6vIk72SB7P9VoFivHNZG9On3yPAEMcR1WOiyUoWFwWore7vA4se5latbsgzzxYl
         WdfHcQ0AjmB1Kx0D7xvUQ8ayVDuv3Fb58k9aDskfhZeKESnRSNM0FASng1g3bm35rn+y
         sJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773207811; x=1773812611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBkKlz74W2gpOmgKJ/EWZaEsQiCj+3juokwV2ivcA9E=;
        b=nJ1LQ6lW886+U7NxTLPcuifsE+e+d0IHhSPwMFFZ4bVmES3mCL7Zv4OWZYKLaMgFIW
         8YAtgS6OjLSzUi43tGh+iNtF6sMGY9p/z3CqZOHP++zNC0LtA+AHjc3bVJ6TRaBX4RBY
         BzI3mlIAoDVw82+P1F6nvEw3YeqOIW+v0vaGmtZRESzez12LRCFlajRaIsTY+JAMQkbG
         4Rbrplzx5wB+IR+HaSOCKcja+XhGzgAuCtaUvsOU8lvZgotYVjzahjCFalRwQPRyy4Vf
         ZSS9kF+1ivsPIA1ee6iDLsbAlY3pn0SdBPx3GGtaFXiaMpJloeB8YyQS8WTqJEeHSwy7
         2OpA==
X-Forwarded-Encrypted: i=1; AJvYcCVbDqQ8zshFeOtonKulr9+ITJDbOkgo2PMwEzoP3mJ7b1gt24QaNfHmuYuk8rDvXR/TOgEljF/UUFTqyQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzyl455ee8BfYnnmt4kEW8nsVSnubPjZo4gt3M30O3JHdpiPh8f
	MjuG7opU690XVmYvTrhl/LNl1pcosgodq6PLhaPQ0urtA9Bwx5iotcv7nIPiSmTL8Qg=
X-Gm-Gg: ATEYQzzWeZSFvEcaNJLmH6Yo/8sBs58yJZpfhokxY2E7KjhrebJbdV0ar+DblU9NKWZ
	2fbUv6HWmHFdQWr69WJrc3TeeybLl/itovBvz3aVEqDFniwzgmpUO3JroGII1qotg4rtiE6ZNX+
	xeNQU+2btLAcJsamxYc9Hx8dqHDsX1v8On3FK3Nym3MCbfCeNklsgBjNnX8TkBtquDJY5QdN8Bm
	YzK0UxnC0h3JphlR+zo3pfhi4YFVVQjNTylGckINQZNkhKEqqk7a9hiTREV/GJDdOB90SnMHfW7
	gG3WNSBQGH7qaaiKbvxLiIBDTpFl1TcRacV0V10bfxR/1h8i/ETxBQU7rmQFzCLJ4ykRUYSe9c7
	8FreIUDl0xZJHbM385B347qmIXRqOwpV0Nd4+MmenXzUyAiDETO1hbZo4e6j3vawTVyEEs1zDNi
	47RrJgSj3k3tAvs5j9sXCJNA==
X-Received: by 2002:a05:600c:34d2:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-4854b0a4788mr11297385e9.1.1773207810782;
        Tue, 10 Mar 2026 22:43:30 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6eec031sm1075590b3a.41.2026.03.10.22.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 22:43:25 -0700 (PDT)
Date: Wed, 11 Mar 2026 13:43:20 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: jack@suse.cz, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ocfs2: split transactions in dio completion to avoid
 credit exhaustion
Message-ID: <2jftdgkyazhvzekghumby7ml72qsczwdqmvedb73i2rrprwvxd@rofsjquqnxqh>
References: <20260310102413.12501-1-heming.zhao@suse.com>
 <20260310102413.12501-2-heming.zhao@suse.com>
 <5be5a109-477c-4c42-919b-1de0707e7af6@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5be5a109-477c-4c42-919b-1de0707e7af6@linux.alibaba.com>

On Wed, Mar 11, 2026 at 09:48:12AM +0800, Joseph Qi wrote:
> 
> 
> On 3/10/26 6:24 PM, Heming Zhao wrote:
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
> >  fs/ocfs2/aops.c | 56 ++++++++++++++++++++-----------------------------
> >  1 file changed, 23 insertions(+), 33 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 09146b43d1f0..50b4d474b88c 100644
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
> > @@ -2326,23 +2314,18 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> > +			mlog_errno(ret);
> > +			break;
> > +		}
> > +		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> > +					      OCFS2_JOURNAL_ACCESS_WRITE);
> > +		if (ret) {
> >  			mlog_errno(ret);
> > +			ocfs2_commit_trans(osb, handle);
> >  			break;
> >  		}
> >  		ret = ocfs2_mark_extent_written(inode, &et, handle,
> > @@ -2351,19 +2334,26 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  						meta_ac, &dealloc);
> >  		if (ret < 0) {
> >  			mlog_errno(ret);
> > +			ocfs2_commit_trans(osb, handle);
> >  			break;
> >  		}
> > +		ocfs2_commit_trans(osb, handle);
> >  	}
> >  
> > -	if (end > i_size_read(inode)) {
> > -		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
> 
> dw_orphaned is only set if it allocates new clusters, see
> ocfs2_dio_get_block():
> 
> 	if (ocfs2_clusters_for_bytes(inode->i_sb, pos + total_len) >
> 	    ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode)) &&
> 	    !dwc->dw_orphaned) {
> 		...
> 		dwc->dw_orphaned = 1;
> 	}
> 
> So in case extending a file within an existing cluster, it leaves
> dwc->dw_orphaned = 0. Then i_size won't be updated here and the written
> data is lost.
> 
> Thanks,
> Joseph

The cases corresponding to the logic above are:
- 'if' (dw_orphaned:1): an extending write where (end > "inode old size")
- 'else' (dw_orphaned:0): this should cover: overwrite, sparse/hole file write.
  where the i_size doesn't need to be changed. 

Furthermore, code at the beginning of ocfs2_dio_end_io_write() checks
if (end <= i_size).  if the condition is met, the code jumps directly to the
'out' label, no opportunity to update i_size.

```ocfs2_dio_end_io_write()

        if (list_empty(&dwc->dw_zero_list) &&
            end <= i_size_read(inode) &&
            !dwc->dw_orphaned)
                goto out;
```

Heming
> 
> > +unlock:
> > +	up_write(&oi->ip_alloc_sem);
> > +
> > +	/* everything looks good, let's start the cleanup and update i_size */
> > +	if (dwc->dw_orphaned) {
> > +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> > +
> > +		end = end > i_size_read(inode) ? end : 0;
> > +
> > +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> > +				!!end, end);
> >  		if (ret < 0)
> >  			mlog_errno(ret);
> >  	}
> > -commit:
> > -	ocfs2_commit_trans(osb, handle);
> > -unlock:
> > -	up_write(&oi->ip_alloc_sem);
> >  	ocfs2_inode_unlock(inode, 1);
> >  	brelse(di_bh);
> >  out:
> 
