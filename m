Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE9F443307
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 07:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581161; cv=none; b=cGgKrSmqxKnByKjRyv0V5+8gisqNzwXVR+MG2Apql8lx+ISCPuz6XjaflkyvtgOEGne6YH0UIFHW1YGkTohO43gLA7/t9utYPvF0pk0TAn1LZGcfnlbU/LDmvaCHKQTuPp2/naHKU/SmPMyC9MDo7UvAF1mYMQ3t0FYsxwm/ccI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581161; c=relaxed/simple;
	bh=Ee1O85EU6mL4A+k6BaSrrjPcrUn1HmO7/SaFHlvVrt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hN0B42b5PzLui12m3g08ZLIVVw0LGqoDQbRnEnZPISYBjnpnaBy/JTP9eqVAtNY3bLBeNgON889VeSqjdCpAhSUUtLIP8JqdJYimmjJ7E8KAFEc8S32GnP83mmmx+NKE6n1vteZlXoltLGf/cA+liYLDlPsd8hokBjdlGcgPqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FgQcCEFC; arc=none smtp.client-ip=74.125.228.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FgQcCEFC"
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c89ebe1b7so7825266b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 00:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790581158; x=1791185958; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=poKTzHIbdYPKoKWNDbZeL46WSq1iGtUDaGIwgKIDsjM=;
        b=FgQcCEFC00EfYsnY8G+4N8QoxBSmcuPZ+ZoZn5OTSzsyUE+jCeDu5zf6fwvCosX8wR
         dQPlhl4BITz6C+C509crN1g+jmTYnG+GpQ3If+wTRo3qbPQYG/CnPpbZaBo/8lN7jl/x
         KO97OP2lgtfkVIG5pHRtqUbeu4lR2xzmuw3np8KlzrGcwyDgHuAMZoPiG4Wo/hDcAbD6
         rFuW/he9dSotJaBFMp1ydxtkIlCNGRqv1tEnlthWTD1gNtQsTcdhFsp7+G/bjPfwVBNY
         4YJx2t1PklD2qGoCD1uC68FoCVRx4TioS1W6QETddvTL3YE0OB1kVKkVdsmqbD0XGW2f
         O0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790581158; x=1791185958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=poKTzHIbdYPKoKWNDbZeL46WSq1iGtUDaGIwgKIDsjM=;
        b=jwowXOU8wEgT/bylMJvbUSeRLRhqlwEk7ImqVM/YMVnCPHkKHC99AU5To0UiBLplHE
         3ZF8DhHT4S82TgYePqeT0PEP3EpNW8xPE8a+igZ87CB6w4JNPyFIdMc8h0PgcecWEziI
         j1s8hg/77ewoBW7dNlULgvkRESKkmuMNJt9L0X5k8Zs3MYkuMKDJQR9L93H8UalVkqKY
         n3UKGQg/sYqFUQgvmkan7+vjsU9g8JUuPP3zgi7bKqlcPAu9kNSctWszoNz1pF4JGQnU
         NShBbkX6A4ePSx7ecejjSSOGNTtVSS5X97MIY7/Z74NYGtVVcuSqiT39FM8FlTajEocv
         SqFg==
X-Forwarded-Encrypted: i=1; AKwUvBzoFWPZ0LVU1ZrKzDvgsKOiBjT47OcVVIn80B2SPQHGMgYwArGX+x72D9sxgP3SKS4lUOZgSV4ituweRQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lMpIiaDLY91ot56BIq4GqFyRlB3xi+8beq1lypsjCi2qYeTjQx
	j+C8+D42WWO4FC1o8c8hWYuqO7iSeOgMNiRvKFaXSjS5hXJG8Dcw4FKyBW4x/KxSAv0=
X-Gm-Gg: AYBFou3Rgv1+UgCosAClyVSJ9dFu2OA7D2Y99iiV+5S014ID7+wI3u770++wCb3jKy+
	9wpTOVEfRmf0eIAdx1d8WLoNlhzK5AgXFJuV+4j2xzSAjEPvzfrdZRvx964woyINuVv5HXx2gYZ
	Lx6qNl6x4lsMmD6hP+uXkuxIG04sCyIbnUHh3iLmADZqc3ux81VyCOWK4JuXa3nnd2g9ZxPqmxx
	ZRyp/7b49FWh5ZKNZ42K2OKZa/Vary0qNlBTDyhMYdQYImGO9C4uLFHtv/3LJkf5CoQTOVNI/Ls
	9ojLu5zWHjVb2JHLurNN4JsuTl9duU1YpWyL0IHVZH2jYoTQnN7hafNsARK0uSe9qH2e/UNLeGD
	KP9Cu7n27UhBzpzf8UJMKFRSi+5Bk+zhHtVv+Vc3T+ozTbojUlaqjuHEcKTrgkxSoaaukqxOrs+
	5tB/LNVEKbvEqVH+6DlcaJ2nREs9xhn1SXERi6arvZp1mOhrgXpPJJOA1XWkN1KEIA5H1v
X-Received: by 2002:a17:907:9719:b0:c2d:e6a7:81d5 with SMTP id a640c23a62f3a-c2de6a7d020mr58347466b.1.1790581158165;
        Mon, 28 Sep 2026 00:39:18 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea19030bsm3742545b3a.11.2026.09.28.00.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 00:39:17 -0700 (PDT)
Date: Mon, 28 Sep 2026 15:39:14 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, yaojiale02@163.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: validate extent list in filecheck repair
Message-ID: <aroZaYiB-DUxFyLs@p15>
References: <20260926131848.3379842-1-yaojiale02@163.com>
 <744a70bd-5455-421f-a37d-1c0a63f54b60@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744a70bd-5455-421f-a37d-1c0a63f54b60@linux.alibaba.com>

On Mon, Sep 28, 2026 at 09:33:12AM +0800, Joseph Qi wrote:
> 
> 
> On 9/26/26 9:18 PM, Jiale Yao wrote:
> > ocfs2_filecheck_validate_inode_block() does not validate the embedded
> > extent list, while ocfs2_filecheck_repair_inode_block() only clamps
> > l_next_free_rec to l_count.  The normal inode read path requires l_count
> > to be non-zero, limits it to the number of extent records that fit in the
> > inode, and requires l_next_free_rec not to exceed l_count.
> > 
> > Without the same checks, filecheck can report SUCCESS while leaving an
> > invalid extent list on disk.  A later read through the normal inode
> > validation path rejects the inode and makes the filesystem read-only.
> > 
> > Add a shared helper for the filecheck paths to check these invariants.
> > The filecheck validator now rejects all three cases.  The repair path
> > still clamps l_next_free_rec, but refuses to repair zero or oversized
> > l_count values.
> > 
> > Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
> 
> I'd like make this as a new ability rather than a bug fix.

Agree

In my experience, users run online file checks only when inode data is corrupted,
or when fsck/debugfs has already reported an inode issue prior to the check.

The Fixes tag should only be used for the patch that fixes the unintended panic
and read-only issue introduced by commit d56a8f32e4c6.

- Heming

> 
> > Signed-off-by: Jiale Yao <yaojiale02@163.com>
> > ---
> >  fs/ocfs2/inode.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> > 
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index 180107a11046..57168ed02915 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -249,6 +249,41 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
> >  	return 1;
> >  }
> >  
> > +enum ocfs2_extent_list_status {
> > +	OCFS2_EXTENT_LIST_OK,
> > +	OCFS2_EXTENT_LIST_ZERO_COUNT,
> > +	OCFS2_EXTENT_LIST_OVERSIZED,
> > +	OCFS2_EXTENT_LIST_BAD_NEXT_FREE,
> > +};
> > +
> > +static enum ocfs2_extent_list_status
> > +ocfs2_check_extent_list(struct super_block *sb, struct ocfs2_dinode *di)
> > +{
> > +	struct ocfs2_extent_list *el = &di->id2.i_list;
> > +	u16 count;
> > +	u16 next_free;
> > +
> > +	if (!ocfs2_dinode_has_extents(di))
> > +		return OCFS2_EXTENT_LIST_OK;
> > +
> > +	count = le16_to_cpu(el->l_count);
> > +	next_free = le16_to_cpu(el->l_next_free_rec);
> > +	if (count == 0)
> > +		return OCFS2_EXTENT_LIST_ZERO_COUNT;
> > +	/*
> > +	 * The exact capacity depends on i_xattr_inline_size, another
> > +	 * unvalidated on-disk field. Inline xattrs only shrink the
> > +	 * list, so the no-xattr maximum is a safe upper bound that a
> > +	 * valid l_count never exceeds.
> > +	 */
> > +	if (count > ocfs2_extent_recs_per_inode(sb))
> > +		return OCFS2_EXTENT_LIST_OVERSIZED;
> > +	if (next_free > count)
> > +		return OCFS2_EXTENT_LIST_BAD_NEXT_FREE;
> > +
> > +	return OCFS2_EXTENT_LIST_OK;
> > +}
> 
> This seems a duplicated check in ocfs2_validate_inode_block().
> So I sugguest just extract the helper from it instead of duplicating
> a new one.
> 
> BTW, seems we don't have to introduce enum ocfs2_extent_list_status,
> to make the checks simple.
> 
> Thanks,
> Joseph
> 
> > +
> >  /*
> >   * here's how inodes get read from disk:
> >   * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
> > @@ -1835,6 +1870,33 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
> >  		goto bail;
> >  	}
> >  
> > +	switch (ocfs2_check_extent_list(sb, di)) {
> > +	case OCFS2_EXTENT_LIST_OK:
> > +		break;
> > +	case OCFS2_EXTENT_LIST_ZERO_COUNT:
> > +		mlog(ML_ERROR,
> > +		     "Filecheck: invalid dinode #%llu: extent list l_count is zero\n",
> > +		     (unsigned long long)bh->b_blocknr);
> > +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> > +		goto bail;
> > +	case OCFS2_EXTENT_LIST_OVERSIZED:
> > +		mlog(ML_ERROR,
> > +		     "Filecheck: invalid dinode #%llu: extent list l_count %u exceeds max %u\n",
> > +		     (unsigned long long)bh->b_blocknr,
> > +		     le16_to_cpu(di->id2.i_list.l_count),
> > +		     ocfs2_extent_recs_per_inode(sb));
> > +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> > +		goto bail;
> > +	case OCFS2_EXTENT_LIST_BAD_NEXT_FREE:
> > +		mlog(ML_ERROR,
> > +		     "Filecheck: invalid dinode #%llu: extent list l_next_free_rec %u exceeds l_count %u\n",
> > +		     (unsigned long long)bh->b_blocknr,
> > +		     le16_to_cpu(di->id2.i_list.l_next_free_rec),
> > +		     le16_to_cpu(di->id2.i_list.l_count));
> > +		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
> > +		goto bail;
> > +	}
> > +
> >  	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
> >  		if (S_ISDIR(le16_to_cpu(di->i_mode)))
> >  			mlog(ML_ERROR,
> > @@ -1893,6 +1955,15 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
> >  		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
> >  	}
> >  
> > +	switch (ocfs2_check_extent_list(sb, di)) {
> > +	case OCFS2_EXTENT_LIST_OK:
> > +	case OCFS2_EXTENT_LIST_BAD_NEXT_FREE:
> > +		break;
> > +	case OCFS2_EXTENT_LIST_ZERO_COUNT:
> > +	case OCFS2_EXTENT_LIST_OVERSIZED:
> > +		return -OCFS2_FILECHECK_ERR_INVALIDINO;
> > +	}
> > +
> >  	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
> >  		di->i_blkno = cpu_to_le64(bh->b_blocknr);
> >  		changed = 1;
> 
