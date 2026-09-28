Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99B94DE72B
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 14:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606011; cv=none; b=MibzGVJ1S3cvvzqhwqZNO/if4VNW8ew9cj0biXmT25j832TELfK9NNd0fknVuBxfTOFrqjoOJbMo7S4GE835n9CllhY96wOCFxKBrIiDCMzDDOydjemddE6YAE8cOqQ/l6C7u0gTSEe+Dq7DVpusHZc1Y6SlvfEeCk6em8cDgn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606011; c=relaxed/simple;
	bh=0uTsabC5p675gdS8dTrQduwvANnTEuolN/gyOQnRHEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jzex08oKepl3OOQRqgZSanMkZSr2z52zJP+6K7Q1FRdlOsp5jOzcyK0FcroIPjGMyViqMhUxXHlv2ltiBFtX52SPVriOiugow9kuGzMvJDCmJ+i8io8ZHTAzh4Ahq/fX+3Qh8269uxPigD6LJWwPDveGdmpAiKjlJvdvek4Hp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PqoOOIzN; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PqoOOIzN"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c89ebe1b7so14307166b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790605995; x=1791210795; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SOYgIQeEiNoXJRbq0xUoG6vGFA32ScMPWVC4gTZudqg=;
        b=PqoOOIzNY64q4aK7To8tvfglDKTGmotJ08ck63ZjJ8TOYEuQeiu4vg9GnaThgGPrx2
         jvouR+VZNXT+PcUuQDpITStUqMsa0l/K47Eut2DjXhz9HBOabqDu0OjVCMaIm9PXS7PH
         FcAMaBzJdadD3eaD8dosr9tOoQPmXnNSjiwuSelXzWSwDib66rX87SWGcSt9vPOKkxgP
         RCXbPlQ1rqEhWttWEJx8oNhYBfEJhanAQaYnuemOe3wE1WXtujgXPQIIDH7tM6yT9++B
         yEtPK4X/hZWDHqXKKABZnBz44NWaqsF1KrSzF0yOmqkjPyazPGoIuOzFZ6sDADyiM/7q
         MNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790605995; x=1791210795;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SOYgIQeEiNoXJRbq0xUoG6vGFA32ScMPWVC4gTZudqg=;
        b=UgKI9+X/EazWiRQiaMjiy87mxhxI2z35acHP+arq43vf/7mp0ELNaua0YF6aeUAnl4
         rSTT0YS9VMQW+7lWFW2e85JOAj+dgHb0lKIiTKD0Owe5WZVNbWHNV2JHInzTfGMNSVPk
         J0FSL7WvR1LgYerRch/awILKwChvtbuIddah3u5nLi5F4KQWzJzSpr/gijHUfX6XS/d6
         VpO0QihiwjfoXFWkiHm285gPiYMky9aPa/cZJSI5jkKry1RX2KR6bR8tw6tlLkaCuqMb
         7xOVU2fduKaOct9wVaYjNK6YOObMDh3ARovCiRW9D+cyRfpZXHQBw4h4seuae5KXd+Gw
         LDow==
X-Forwarded-Encrypted: i=1; AKwUvBwNniCpPAO6+vWgFjtYH9fmJQ7bRVYEmG3GPJilziQ6/d61OZVIYcmeZ043unI30wSrl/PqOPqFyMa6Hg==@lists.linux.dev
X-Gm-Message-State: AFuF++nypB8yyWVA1L4qbAxDr9svv0iz6LdHVcpdzHXak5UeMhommX7D
	0C+Unumn+MlncbZs2+PGiogELzJOJKoJQNSnGDTe86yvnsxUt6SaLnjyulJr8IuSEro=
X-Gm-Gg: AYBFou2+G4z8URSOXmThaqtrLmfjZk/uZd3tNh5hWAZLdfOQ+1JmCeVxKyyLPXwfACb
	nCEbYQ8VJk7jHE+x4/Ll6WF8ou8ohQTWM31vBEhGmeEFcLmhZtH7Hr70zOuo9qVW6e9tnxoVLUf
	JzLTJJkRWTMRQrOBz88OLJWCMC3qMU0LPqkNjD2kcSlLFOVA1jelIGN3X1hiUJ2VbNqxtP0wJeD
	YqlHlBOjIiEa/RTGvSeSDSaXLYsw3Apqxla75ga1DkZWZwRh7JrZXGW+qCuAdQXX4UDlvjx/M1/
	s9sIKrVaWxyUhksgoDMlmrKpoj8Dt8NgNWXF4Gw5JQuUzwfXBA0qLIx7ONlhgLMvQM3MYpe0ec+
	uyu3CbZbPGq0vYPgEMU3vX69MzTkeaPH1oONFNkWwUvjI1Xw6H4sG6kmzoLL7UkiMNPKRQ56wjL
	iKRJZfMkw5yhyO6JCVEqsZ5OfPct2f+s1nFLmU6fa8CrquvXp3hdVSLEH0zPTh2DBkIKFx
X-Received: by 2002:a17:907:3f17:b0:c16:604a:b2bd with SMTP id a640c23a62f3a-c2ac234ac2cmr1156189366b.3.1790605995252;
        Mon, 28 Sep 2026 07:33:15 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78794f224sm4832371a12.25.2026.09.28.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 07:33:14 -0700 (PDT)
Date: Mon, 28 Sep 2026 22:33:11 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: yaojiale02@163.com, Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: validate extent list in filecheck repair
Message-ID: <arp6FkHBlWtzVa64@p15>
References: <20260926131848.3379842-1-yaojiale02@163.com>
 <744a70bd-5455-421f-a37d-1c0a63f54b60@linux.alibaba.com>
 <arn2x2Y688K9Js4N@p15>
 <08d85624-7da8-4d6e-9899-765d1af2e9f4@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08d85624-7da8-4d6e-9899-765d1af2e9f4@linux.alibaba.com>

On Mon, Sep 28, 2026 at 05:56:27PM +0800, Joseph Qi wrote:
> 
> 
> On 9/28/26 1:18 PM, Heming Zhao wrote:
> > On Mon, Sep 28, 2026 at 09:33:12AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 9/26/26 9:18 PM, Jiale Yao wrote:
> >>> ocfs2_filecheck_validate_inode_block() does not validate the embedded
> >>> extent list, while ocfs2_filecheck_repair_inode_block() only clamps
> >>> l_next_free_rec to l_count.  The normal inode read path requires l_count
> >>> to be non-zero, limits it to the number of extent records that fit in the
> >>> inode, and requires l_next_free_rec not to exceed l_count.
> >>>
> >>> Without the same checks, filecheck can report SUCCESS while leaving an
> >>> invalid extent list on disk.  A later read through the normal inode
> >>> validation path rejects the inode and makes the filesystem read-only.
> >>>
> >>> Add a shared helper for the filecheck paths to check these invariants.
> >>> The filecheck validator now rejects all three cases.  The repair path
> >>> still clamps l_next_free_rec, but refuses to repair zero or oversized
> >>> l_count values.
> >>>
> >>> Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
> >>
> >> I'd like make this as a new ability rather than a bug fix.
> >>
> >>> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> >>> ---
> >>>  fs/ocfs2/inode.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>>  1 file changed, 71 insertions(+)
> >>>
> >>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> >>> index 180107a11046..57168ed02915 100644
> >>> --- a/fs/ocfs2/inode.c
> >>> +++ b/fs/ocfs2/inode.c
> >>> @@ -249,6 +249,41 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
> >>>  	return 1;
> >>>  }
> >>>  
> >>> +enum ocfs2_extent_list_status {
> >>> +	OCFS2_EXTENT_LIST_OK,
> >>> +	OCFS2_EXTENT_LIST_ZERO_COUNT,
> >>> +	OCFS2_EXTENT_LIST_OVERSIZED,
> >>> +	OCFS2_EXTENT_LIST_BAD_NEXT_FREE,
> >>> +};
> >>> +
> >>> +static enum ocfs2_extent_list_status
> >>> +ocfs2_check_extent_list(struct super_block *sb, struct ocfs2_dinode *di)
> >>> +{
> >>> +	struct ocfs2_extent_list *el = &di->id2.i_list;
> >>> +	u16 count;
> >>> +	u16 next_free;
> >>> +
> >>> +	if (!ocfs2_dinode_has_extents(di))
> >>> +		return OCFS2_EXTENT_LIST_OK;
> >>> +
> >>> +	count = le16_to_cpu(el->l_count);
> >>> +	next_free = le16_to_cpu(el->l_next_free_rec);
> >>> +	if (count == 0)
> >>> +		return OCFS2_EXTENT_LIST_ZERO_COUNT;
> >>> +	/*
> >>> +	 * The exact capacity depends on i_xattr_inline_size, another
> >>> +	 * unvalidated on-disk field. Inline xattrs only shrink the
> >>> +	 * list, so the no-xattr maximum is a safe upper bound that a
> >>> +	 * valid l_count never exceeds.
> >>> +	 */
> >>> +	if (count > ocfs2_extent_recs_per_inode(sb))
> >>> +		return OCFS2_EXTENT_LIST_OVERSIZED;
> >>> +	if (next_free > count)
> >>> +		return OCFS2_EXTENT_LIST_BAD_NEXT_FREE;
> >>> +
> >>> +	return OCFS2_EXTENT_LIST_OK;
> >>> +}
> >>
> >> This seems a duplicated check in ocfs2_validate_inode_block().
> >> So I sugguest just extract the helper from it instead of duplicating
> >> a new one.
> >>
> >> BTW, seems we don't have to introduce enum ocfs2_extent_list_status,
> >> to make the checks simple.
> >>
> >> Thanks,
> >> Joseph
> > 
> > Hi Joseph,
> > 
> > The code logic is identical for ocfs2_validate_inode_block() and
> > ocfs2_filecheck_validate_inode_block(), except for their error handling style.
> > It seems possible to merge them into ocfs2_validate_inode_block() by adding
> > a bool check parameter to distinguish between the two behaviors, and then remove
> > ocfs2_filecheck_validate_inode_block().
> > 
> > The new code logic: replace ocfs2_error() with mlog(), and then "goto bail".
> > At the bail label, handle the two cases separately using "if (check)".
> > 
> > i.e.:
> > //adding a new parameter "check"
> > int ocfs2_validate_inode_block(struct super_block *sb,
> > 			       struct buffer_head *bh, bool check)
> > 
> > 
> > code change from:
> > ```
> > 	int rc;
> > 
> > 	... ...
> > 
> > 	if (!OCFS2_IS_VALID_DINODE(di))
> >                 rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
> > 		     (unsigned long long)bh->b_blocknr, 7,
> >                      di->i_signature);
> >                 goto bail;
> >         }
> > ```
> > 
> > to
> > ```
> > 	int rc = 0;
> > 
> > 	... ...
> > 
> > 	if (!OCFS2_IS_VALID_DINODE(di))
> >                 mlog(sb, "Invalid dinode #%llu: signature = %.*s\n",
> > 		     (unsigned long long)bh->b_blocknr, 7,
> >                      di->i_signature);
> >                 goto bail;
> >         }
> > 
> > 	... ...
> > 
> > 	return rc;
> > 
> > bail:
> > 	if (check) {
> > 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> > 	} else {
> > 		rc = ocfs2_error(sb, "invalid dinode\n");
> > 	}
> > 
> > 	return rc;
> > }
> > ```
> 
> Ummm... This may make the code messy.
> I'd like only abtract the check condition, and let the return code and
> log message as in its own validation function.
> e.g. ocfs2_dinode_has_size_without_clusters().
> 
> Thanks,
> Joseph

Got it and agreed.

- Heming
