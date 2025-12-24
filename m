Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87B32A3DA
	for <ocfs2-devel@lists.linux.dev>; Wed, 24 Dec 2025 06:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766558299; cv=none; b=u4gHFUrXfpdFNBTiPf747Bk4M8MucTe3llw/OCNIAj1D61YeTLgns5AOKPFUHJUiZrXY/liRW1ItVEuqTMV4USxvDN2r34IP3bFtzPGb47+4HZaNrGm3Q7ShMpRuXTIt76DZ7Kn7X2fJE2NGYRnkbaEMlbqjJbreFURfFfCAi8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766558299; c=relaxed/simple;
	bh=gsrHNNbocSyGlKE7vERXRimkrvrozZZCJmIIb6a960o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfC/QkiUJGeEO4P0zLxvlxwxLCl5hS0eC2TstUroLiV0eqyzj9xwLo2B1UoFX+9mPtJGoxfGbjAQCzJie14Va5mLtaDPiP9C+YUVRhbtizt7+3wc/h4mcXriQMdYkI9/UoJrXvoLYL28DGrtfNwDoa62dKZZNBUpQlxmXAQkapE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUxDNgXa; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUxDNgXa"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7f1243792f2so3923757b3a.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Dec 2025 22:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766558297; x=1767163097; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1Anp1lY1We4/zAVuAi7e7U46WAxj4AfEwKzru4nCjs=;
        b=gUxDNgXa7BiQT+G02uGTotJe9DOM7IQlIi2B0u5dyXeet2tOh/lrI1IqPsOrcflp5P
         hayrqY0S4OK4plSgEIvi5X9oBZDu8KgtvvKt3VYiBUerVAqOQFmX3yyYp82p2RsFrKKH
         EiPwXpTPYwbgQoqDu2Gg5505k3kzdorp9VkQjtKSXaUa6GFvnW2yh0V56UZ05+ZAKAhG
         rP/B+aq341kFrEoR2bXu45OdnqDrr3BGBqBxZ0eAxmr5wxi5c+r0trqfUW7TqOil8D5r
         zHuZhex1FO61+Q2TXyzJ69XFgU/szkHGsz229ShFXKBNps7E0BgJpiQSgDxaBrAg5BD8
         ZvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766558297; x=1767163097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1Anp1lY1We4/zAVuAi7e7U46WAxj4AfEwKzru4nCjs=;
        b=Xcf4vA2uhXKMmnC+2M5mRJRa121293RNBzj7ZzolaaHJtosh5GOPQtVv2V08V5UNBY
         YK/53Rd24IcchR8Aa5lQDBp1r06FExItm+DMPRnWLGcDdvTNZbtR3UJNSrW/M5f3bXzM
         1IKcowG6VO81ZsWjrIFIJeUR2VCiQxOfcCRj0+uUkhMQ+on8mN1Htg6VHIve7Vz1hEoO
         1aWvrZuKiyExnNyUOeWJru/9A2zyxvGvrKFw1gPMX62aqENiXvrCjqcpdgp3WMC9Cpi3
         lFZMIrW6RDODlXQf11aAu913WEQ07+UIiwiHtuiMa9Sob5pSS2XNO3Xj8NbUF9NTy7nH
         mkvA==
X-Forwarded-Encrypted: i=1; AJvYcCUsaNfjcOamtNCOBxMfE6Z3wqOZqt0hfYg9DekoYFg/vF0PAlwv6EqWBdMTnXuUIbShYjgzKsqSkVdQZg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0KWYFsmEHpG7/Bq6kVTPqqKhzYmV3oeGDFtMMI0nBmyXpUhE+
	c22ufngX9S6hzcv0QKTF0DBwor4+ouVZ4YxF4YWEtkv6EOu4N/4fecnl
X-Gm-Gg: AY/fxX4o1U4dWRZ8Gvw8safLY6iyXtCqAMnghudfZ5HHotdsgdK0C2B6I9uCEJhAv2f
	SBffCundoX8gdA8Q5jbooTEFMQpWx5ypJTilHIibQXGb9W6nSRH9G7NXcitsUKs30eNUTOtsrF+
	1mcwjJgPhUPMkhTgINCvlJqSu1WW8Va8G9iotUhHtCC1dVcf3pwUDqhaCX0Z7na3RFUfn6EqjsG
	owcbFr8CMXFBGHCNSu8J2GyGSUP2i6Kahva4CmVjDnqLQVPCAxyrTR7PhXS0bcXqmAhbiTp3kaD
	zqW/JyO8tRkp5jBSFfS+c8sg9YtxrPZ0Cy8L+dalnzqajSczYr7/W4ye6S+bSZpt6XzFBf7Fwnk
	RBpVk1pMdXoL4XJ/Qwrp84WMABkrNWI8wXFbQNVqIWo3EIgjUCgng3oe+02+fXEfOqpVRQ0nnnE
	PiUuQPR2+JmCc=
X-Google-Smtp-Source: AGHT+IGeF+1DNi4wBQ+citO8we8db5AW369vz0FLW8lrY82nDFCZVApz9JhjcAMfqp7ryzxlPiNF4Q==
X-Received: by 2002:a05:6a00:328f:b0:7e8:43f5:bd36 with SMTP id d2e1a72fcca58-7ff66d5f579mr15039520b3a.34.1766558297009;
        Tue, 23 Dec 2025 22:38:17 -0800 (PST)
Received: from inspiron ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e589b0csm15892605b3a.56.2025.12.23.22.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 22:38:16 -0800 (PST)
Date: Wed, 24 Dec 2025 12:08:09 +0530
From: Prithvi <activprithvi@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Add check for total number of chains in chain list
Message-ID: <20251224063809.b5zs7uiiupeexzwa@inspiron>
References: <20251220094928.134849-1-activprithvi@gmail.com>
 <dcbfbwivj2pgid24lp7xynsli5v44fw5lskyg6r6yodr223irp@alqswzjnxmmu>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcbfbwivj2pgid24lp7xynsli5v44fw5lskyg6r6yodr223irp@alqswzjnxmmu>

On Mon, Dec 22, 2025 at 11:21:11PM +0800, Heming Zhao wrote:
> On Sat, Dec 20, 2025 at 03:19:28PM +0530, Prithvi Tambewagh wrote:
> > The functions ocfs2_reserve_suballoc_bits(), ocfs2_block_group_alloc(),
> > ocfs2_block_group_alloc_contig() and ocfs2_find_smallest_chain() trust
> > the on-disk values related to the allocation chain. However, KASAN bug
> > was triggered in these functions, and the kernel panicked when accessing
> > redzoned memory. This occurred due to the corrupted value of `cl_count`
> > field of `struct ocfs2_chain_list`. Upon analysis, the value of `cl_count`
> > was observed to be overwhemingly large, due to which the code accessed
> > redzoned memory.
> > 
> > The fix introduces an if statement which validates value of `cl_count`
> > (both lower and upper bounds). Lower bound check ensures the value of
> > `cl_count` is not zero and upper bound check ensures that the value of
> > `cl_count` is in the range such that it has a value less than the total
> > size of struct ocfs2_chain_list and maximum number of chains that can be
> > present, so as to fill one block.
> > 
> > Reported-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
> > Tested-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > ---
> >  fs/ocfs2/suballoc.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > index f7b483f0de2a..7ea63e9cc4f8 100644
> > --- a/fs/ocfs2/suballoc.c
> > +++ b/fs/ocfs2/suballoc.c
> > @@ -671,6 +671,21 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
> >  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
> >  
> >  	cl = &fe->id2.i_chain;
> > +	unsigned int block_size = osb->sb->s_blocksize;
> > +	unsigned int max_cl_count =
> > +	(block_size - offsetof(struct ocfs2_chain_list, cl_recs)) /
> > +	sizeof(struct ocfs2_chain_rec);
> > +
> > +	if (!le16_to_cpu(cl->cl_count) ||
> > +	    le16_to_cpu(cl->cl_count) > max_cl_count) {
> > +		ocfs2_error(osb->sb,
> > +			    "Invalid chain list: cl_count %u "
> > +			    "exceeds max %u",
> > +			    le16_to_cpu(cl->cl_count), max_cl_count);
> > +		status = -EIO;
> > +		goto bail;
> > +	}
> > +
> >  	status = ocfs2_reserve_clusters_with_limit(osb,
> >  						   le16_to_cpu(cl->cl_cpg),
> >  						   max_block, flags, &ac);
> > 
> > base-commit: 36c254515dc6592c44db77b84908358979dd6b50
> > -- 
> > 2.34.1
> > 
> 
> Since 'fe' is read by ocfs2_read_inode_block(), the validation function
> ocfs2_validate_inode_block() is the appropriate place to perform this sanity
> check.
> 
> Please follow the pattern in commit e1c70505ee81 ("ocfs2: add extra consistency
> checks for chain allocator dinodes") when adding your code.
> 
> btw, I am a little bit confused, it seems commit e1c70505ee81 is enough to fix
> this syzbot issue.
> 
> Thanks,
> Heming

Hello Heming,

Thanks or the clarification. I applied the commit e1c70505ee81 ("ocfs2: add 
extra consistency checks for chain allocator dinodes") above the commit on 
which syzbot reported the bug : 36c254515dc6 ("Merge tag 'powerpc-6.12-4' 
of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux") and 
verified that it fixes this KASAN bug. 

You are right that commit e1c70505ee81 is enough to fix this bug, and my 
patch is redundant in this case.

Thanks for the review and guidance!

Best Regards, 
Prithvi
