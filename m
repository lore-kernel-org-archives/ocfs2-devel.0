Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E840282F3C
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 01:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775094583; cv=none; b=SFm9TwzboEYi9+X9A+FdDqe9y4asHz6nnOPqd3VFZOdLAyW3QMa286pcoQwoGhKxDn+8qURHFgaNV+SWnMLZ0t7bYyNzNpqHh3YTl93yceYDvRh10fKFeWaTH48txpdHxBXdyvfa+Lcs09rfMyN8YEB2+jWpLyWKVSzNRf4XbQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775094583; c=relaxed/simple;
	bh=9wbodgnaSMA1LMXx6t8QAQbrE1kvbo4XSBTT8JJgf64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpFZJRS3J9Ux8X//trt6Iw6n4yE057G7EewxD490h09ouSaqzgMdVUsApYA6FJs+KUFvYla3KlGBJHdS82qsZFue50JvMxxYxZL6otd5DrUIQgxGeOncqhpK6iecHMigLtkxpUtrJbdA71u40cSUeBe1muXuZaGAwNlj88Xx+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yx/w4GxR; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yx/w4GxR"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483ad568d68so370335e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 18:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775094580; x=1775699380; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YwbFKl9TYDdrLNDO/bdGZgB54AJM1zqSwDL4bFeBRT8=;
        b=Yx/w4GxRcOESbh7v23grStIJFzcstH4r6gO87f0RO7bZnnIDZXkOc0rCX4hA1TAnZH
         sVD9xFGwBG5K19Y0S8hkhObQ8LIUW5X6A+7EtUER7LHI2qnFw7ft691S/to5mqUEfG1T
         usmXrKLRjeqbOx71WTrmNtDbJ3Qo2KJFcpC4yYuLZ98q1Np3M/nvHUhKYaVTSB4ZcjPN
         B8xgN6EfFlBbaeQIFje6gfY4KwJ7QVLNYZ/XGa33TPTLNISxPDe4gpPPJDg5l0eRpPd2
         nOdUBhYhWPeiqxSekgLmUOxHes4Skk7b2K86DZScA+GaBD1/igstv6qNd7K17hwhQNa8
         wrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775094580; x=1775699380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YwbFKl9TYDdrLNDO/bdGZgB54AJM1zqSwDL4bFeBRT8=;
        b=qa/qPDCKMxgTFWSXaVcPq/zKILZSnT9i4WETda+Hi6/JOAtg0Z6mCQGoQ99+D+iF6f
         A34NbYhq3LhCHbCs27TTHtRzDliYP8kmikfFqExZWGUP8W0Sjrc/c7WpZ1sP+KCs55HA
         uw0d67d4A7siUBoH5+6izbmwBqWF7aj/WQpMT8KtyDZ71IV/PFboit/4NO3Bfyc4yqFG
         Coh2LBasFFd7juWYCEehZIeWVm2sbwl+Dea31qv8zmrUaftQir7jaB8ioNlrPHnt17at
         EhpS6ibht5hSo62YPNH08iNRHrWAQasySPlQYwiLUa+dPx2uBqX4HLs5aiWCHG6G4SMQ
         4jvw==
X-Gm-Message-State: AOJu0YzCJTKInpv1glhGh2N6CY4dasiNCDsGCn8T0LjJdrz6p9skxZYE
	zBGToB4BLg4qnoBkOVeyogc+TLr8xNJJltenTDOg56Z0skuqJN6P3aOAAbWQWJRKyBs=
X-Gm-Gg: ATEYQzxkIEGE4HbMrLZ22nJMIoffGQLyxTxajZudr9sjhg5zRhZuI71Q/+Gi0MHJJ/F
	bqbi/rJldqreZKbutDapKjwFFgluN+I+ImRm/3lCrLXqLdgPRh+BAkPRpsZ/XixjPu35Yrsl7lF
	+EdymhHJzDMQPFqMExe+oGN5B4OMIezNYx9lhLoaTLfqNOYfF+b05HCviNzFD7Nwa6c886w/+Zl
	eIstXK3GC8rwF8DnN1J4+tX+X6zJpv9B9sxMo2wcMeVxx0amdYoQzddRH7V52vG9maAmFwxS5Ef
	OTBkY6sJkQzkzfEzQfQ5/m4A/q4TQz12q7rJAfBYFrnxn+w/PG9s211mTXN1N3Sv1ZI6DfDMHDL
	mdpjXk30SWz0aBrJVLoIoc3TWsmZxo5cAFTLVmhawwlOHF06eWkPeqtWhU8SoAi+Wl9hOspnBGT
	pLOztSi1ugAZR0hG5gkOB1MQ==
X-Received: by 2002:a05:6000:1612:b0:43c:ff6f:d5c with SMTP id ffacd0b85a97d-43d15057e36mr3837748f8f.2.1775094579586;
        Wed, 01 Apr 2026 18:49:39 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a348esm10527865ad.57.2026.04.01.18.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 18:49:38 -0700 (PDT)
Date: Thu, 2 Apr 2026 09:49:35 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	glass.su@suse.com, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/1] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <eg2jlfhjjw2zgw2tlcb5eb4y6wkplzwvqvi7izubnysboywa6k@rdk7q65u3dbs>
References: <20260327063626.10225-1-heming.zhao@suse.com>
 <20260327063626.10225-2-heming.zhao@suse.com>
 <2501759b-1a26-4ea8-b17d-d2f4b8c96ac9@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2501759b-1a26-4ea8-b17d-d2f4b8c96ac9@linux.alibaba.com>

On Wed, Apr 01, 2026 at 05:46:56PM +0800, Joseph Qi wrote:
> 
> 
> On 3/27/26 2:36 PM, Heming Zhao wrote:
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
> >  fs/ocfs2/aops.c | 63 +++++++++++++++++++++++++++----------------------
> >  1 file changed, 35 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 09146b43d1f0..a542cd0a6f75 100644
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
> > @@ -2351,7 +2342,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
> > @@ -2360,10 +2357,20 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >  		if (ret < 0)
> >  			mlog_errno(ret);
> >  	}
> > +
> >  commit:
> >  	ocfs2_commit_trans(osb, handle);
> 
> We have to check 'handle' here to prevent NULL pointer dereference. e.g.
> rightly after OCFS2_DIO_MARK_EXTENT_BATCH round.
Good catch.

> 
> And you've missed ocfs2_start_trans() and ocfs2_journal_access_di()
> before ocfs2_set_inode_size().

Only the ocfs2_start_trans() call was missing; as access() is started in
ocfs2_set_inode_size() via ocfs2_mark_inode_dirty().
I will submit v6 reflecting above changes.

- Heming

> 
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
