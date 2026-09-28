Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CDB339847
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Sep 2026 05:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572730; cv=none; b=tE3Ylmrs10dOhU9WXt36NpNDk4UfPXEzIEPGGYmCxqpP3PyDKId+25wS3qwD98LrQUWWQZjWGVIfyATkxF47icPiK6QLDTR2qjfklPDG0rZmOcgwqGct0nXpppMu8NizFy67SV1l2JlPNYho1H2fVsSwT3bPHlm+FQLAtmtMo+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572730; c=relaxed/simple;
	bh=0U+mL4Cz0OFJUraDh13qs6pe7BCHS1EnZDU5ZEcmVnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWfPf/naITqSPwQXs1crj5Ig50byCU/WfNYPEUeWJxZxKmzc/+Pdt6AOH3hUXkeN9cR2NJ2NL8Ys7g1XMPW2z2ZGCgJxULwG4Iwtux4i4zawBdBEZ3hAfF6YrCCE8kZQCK3jYXorzxzMdub3RHpWE3FLtjfQi7riT6nyMJREEEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FkLPz9pu; arc=none smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FkLPz9pu"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac6d9a3d50so164999a12.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Sep 2026 22:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790572727; x=1791177527; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JrcsFhimSFFpvPxn7z9kfbGviN4GpU7NSPm5ovf6tpY=;
        b=FkLPz9pu0X0bZkkB+mZHlpz2g9fVQrsyVTYhfZibMyCVsTTqX6S9cNpYGG62oMWwoH
         ZA54KiKyh4oKx90HpX7eQXLo/ziGrO1Ptvnz7p6g8asTQcVwh2H7Q25Pt4FtfMj83j+x
         fQgrKMxdOFZY4XwnNaLrer41JYsjRtlCqzUZBZVJ5QPU7clSt3yQ+O94dOTSPigXCAaI
         1Hp9WF0aMtNjsoCschTz/BQg7zO39rryTaHH91S+qM6+AIKnBYI441L1f+d6u6sJjz6U
         1umBUF8r3QJQlrjzzMyO12In9+As03ZARssdL/e+Lou1cyYCiOYF9MziS1K2r1QaHA+c
         V3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572727; x=1791177527;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JrcsFhimSFFpvPxn7z9kfbGviN4GpU7NSPm5ovf6tpY=;
        b=zptjLNuKnRUmfUgNAKUq3kqq9l4NSUcy4F8cVR0cSQXKeY2mmUSCjdXJrSGWh8KLtA
         wWwcJymrlxYQQwItqt7m5f0efZ7N6XPdQsX2VEN6QtWc+VGIYK37ihn7vWXU0iBoHWIa
         IFjNxtLpSmc5EFftxuPjNZe3+RqwlPyTR1fvD4N12527xGuSpdldwqAasH10gAfd4LOW
         Y6ebdemmoY2Z2N4Pbo41K3BX1URszs1J/Xk1art/eZKBZoSqtWsvx4Nlj7CY0G3Xae/6
         xFO6bvYe+aNAinjKMM3OTC+S8Ej0wrs+s5j3CscpGd8qDZ7+EC4EcZvr5bIx0euZ7Sm7
         9Utg==
X-Forwarded-Encrypted: i=1; AKwUvByDDYpo8AGuXvlW8CCrKwv7X7gW8HUKzyNIzqpG8HUOAKPRc4/Kjqg0V7jbIX35Lf/8Opq3iRY4uL5rdg==@lists.linux.dev
X-Gm-Message-State: AFuF++kfxPPsFgAihyg2WYhohwyHae6ioIhVEWARW5E3W7jYznDH6Sgo
	ORiEgh8QmE3unzM6LbkRjtNAhl96IwzQf6QhvIBbTM2+RVu2ToQE67ZF/foRKxPgTk0=
X-Gm-Gg: AYBFou2zhw+LhMcNwOOA3x2FCK+w2d4R7Mekq66yXXGBFd7yrh6H2iK3+GVdbmPJSLk
	r943O73DV4WyY46buJ3pHAlJKexMMvT/cSIF3gT5e1Aid4747YmJWlsAS7mWwXufPNeacrmyDah
	yvkdB/bUJwDzcDCJaAVtYcr8q15raNUIDcX6eBM79rVbuDHsy4pVaxx3i4kQG4tgWTPGQnFvOnN
	Edr/vH2b+khU+I7+I9peMSjIJH78dt31NBZj+0t6lfsY+vMgwEsmtnLSXycwdgtMDnXhj/8rYR4
	zFCtYgD89tbo1ABzf1UcZwPgf4bk+F/PNw2+m1lawBchdeegOEIlmj/N0VYCnM8QLvfNN/8ZYEb
	LFWF5JL2TdeendRw6pG2eI1iTCkyjXj4C77NMsrvKEFUSYlu5LPsvC3+3+HhtmKQOT9i079WUpK
	un9cLGOA9I3ynx9f9Nm+fv2++jDHeThxwcFT2sf7/BGOwwRvalUhVOI47jvMc7iRxoE/xJ
X-Received: by 2002:a17:907:d08:b0:c25:2ded:ad36 with SMTP id a640c23a62f3a-c2ac2053cb1mr1106011066b.0.1790572727431;
        Sun, 27 Sep 2026 22:18:47 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df913fcbbfsm34936535ad.30.2026.09.27.22.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:18:46 -0700 (PDT)
Date: Mon, 28 Sep 2026 13:18:42 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, yaojiale02@163.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: validate extent list in filecheck repair
Message-ID: <arn2x2Y688K9Js4N@p15>
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

Hi Joseph,

The code logic is identical for ocfs2_validate_inode_block() and
ocfs2_filecheck_validate_inode_block(), except for their error handling style.
It seems possible to merge them into ocfs2_validate_inode_block() by adding
a bool check parameter to distinguish between the two behaviors, and then remove
ocfs2_filecheck_validate_inode_block().

The new code logic: replace ocfs2_error() with mlog(), and then "goto bail".
At the bail label, handle the two cases separately using "if (check)".

i.e.:
//adding a new parameter "check"
int ocfs2_validate_inode_block(struct super_block *sb,
			       struct buffer_head *bh, bool check)


code change from:
```
	int rc;

	... ...

	if (!OCFS2_IS_VALID_DINODE(di))
                rc = ocfs2_error(sb, "Invalid dinode #%llu: signature = %.*s\n",
		     (unsigned long long)bh->b_blocknr, 7,
                     di->i_signature);
                goto bail;
        }
```

to
```
	int rc = 0;

	... ...

	if (!OCFS2_IS_VALID_DINODE(di))
                mlog(sb, "Invalid dinode #%llu: signature = %.*s\n",
		     (unsigned long long)bh->b_blocknr, 7,
                     di->i_signature);
                goto bail;
        }

	... ...

	return rc;

bail:
	if (check) {
		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
	} else {
		rc = ocfs2_error(sb, "invalid dinode\n");
	}

	return rc;
}
```

Thanks,
Heming

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
