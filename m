Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBEE2EDD5F
	for <ocfs2-devel@lists.linux.dev>; Wed, 12 Nov 2025 06:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930786; cv=none; b=E7XjkAXBS+EedQAHUScoiNY2q/rM3HkbMBEy9eYQZD9y/Cg0WZRe/DnCUYEtMxQex7KMeiyawYkrjKFDZkMzgRddmRne0QGsWx3bEswGOQ81qzvDJB6WB9Z52kIMNPC/PSYZs3fV7FAoG4DdLWJ9QSn+jb8asLW67+dP2AXnuYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930786; c=relaxed/simple;
	bh=nyZtONnnlVOHu7K4pPYC9VaZOxERptmNZ6w7cHqJ9eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkoufH5qCaLToYZ9ng9vI27PIokZsDVO2OL1xMaKi4VzviiZSlTFk2PF079FdHZWEAHRIjGq8kghJYDrIjnBztNlJoHf//14Z+g+aYbzfceUQK7dm7v0wxGGDyuekZAWMd4U898iV4hs9xwUCngHt4g96LEAtywSoSIe+HpjADU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U6EtTkwn; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U6EtTkwn"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4775dbde730so100135e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 22:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762930782; x=1763535582; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fzTQiJM+cXpP6/qVO6OnvYZS5jUav/J5E78kowl/WGI=;
        b=U6EtTkwny1QMk3ztW7k775e6iMe/LuPREDynn54U8cCGu+v+b0CdaiZ+X3U4942QQw
         puNUeDOJEriSeanrlolOkMilw23tcWW5Sr1juJYMGjkSKnGtBQfcDeI1sLZ2CAfDYbOa
         pIBVRzfLwDEuvvzMq9y+Qu32moz4jXLzlBdgus5aBdlMqfjW4IxVFKiIRMyNr+Ypdmb1
         GrXJcn1pXW1gKIXHdn9YxKKUrZPo7km8xUOhxFDgEt+WIzHbiB1Tx/JfnZZukyiAEtei
         pdIawJYyA6cF2a1l4EhYJgoLds6t5KivzA71yqTPOyyTL28UIAhvHrPqJcU13uU/1gLe
         bgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930782; x=1763535582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzTQiJM+cXpP6/qVO6OnvYZS5jUav/J5E78kowl/WGI=;
        b=PQxuk/aB7yUAB+TYmC01p43Hl/6yzvjsfBBe4r+vgHBpV8KhavBe1RDsGUd5swWTjN
         Lya8cAJTCAhy5aGm77wtsgUhZPr+pZt8Xyi6vUiMs2tpvHuL6ktp/ioGCCmnXnJePXk1
         YQhxRZPOMWEha6OC4xfQ7xfqWZB1yFzx6IG5PujsUbFQXVEqA8/5X5xYt/F0PEAjNmXQ
         Al79Bf7CBQMwJAEHZxVAJFqnFkSv0e4XsLpj/rrp1htmcos2wtWtl6l5ctXg3oo6mZHy
         zlcWOZKC04huqPatJLfUsTtNwOjvyLWSIC5rr0QVpXhWwAJ9nN2RjaHi2NK8bD2+fKOD
         l5Nw==
X-Gm-Message-State: AOJu0YyR4R/e2k9VAvPAzAJXeNoVG1fuSW4StpXkB+2xV5ZfGrkGegFn
	Y2BDQwYdg3NioitxD4UbvPfylYRITCdgD8Jtf/VESlxVyldVUizRtosSwLx+6QKNzKQ=
X-Gm-Gg: ASbGnctRAlSmBf5Ea7IPNdlZMBfAyZo/6EG9lQz9WiVlo/167fZurjmLV2ZsoXl/47/
	pvMB+53cwoRKAGvr5/92niybdQOoTLnJtElxmW/64/jA1WH5vTLa8Efcq87Ety/yKKi7/ZVJZWl
	ldWUMrtLOMN5spBO8bH4pzCIK4hA8mmEj+pv2w1xhAinI2vpHkRP6Sor77C0ODu+JUmcT3bvB+c
	/Ps+ixqUfKbafOQZhpOyxlUB8F4hIijPH6g0aEY7dyirb7xk+SaRd9AJrSGuno6t7SIHG9wSRoo
	7Cd+RaDmVw1K/PLURYlHFnv+ZNTr+T3FxS2TEaUV58tRhuGwLMsEo7NSDLmJm4W0cRJxln/oM9X
	9bOt17OPnZ0jnnf2xAxOwtIBgiNu6YRSdNg0i+GqPMb+rGWz7KJHUaeRs4dklWmuO8wWEgnL1tc
	E=
X-Google-Smtp-Source: AGHT+IGlezVpQs3jxZ10NkBjnORVb8zYogF3MpAou+pO/oIjm0w7IG3Wqh0lbj2Tma2JDDJ0ukTl/A==
X-Received: by 2002:a05:600c:1f8c:b0:46e:36f9:c57e with SMTP id 5b1f17b1804b1-477871f41e5mr7815605e9.5.1762930782029;
        Tue, 11 Nov 2025 22:59:42 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dbf097esm19033955ad.32.2025.11.11.22.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:59:41 -0800 (PST)
Date: Wed, 12 Nov 2025 14:59:38 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] ocfs2: give ocfs2 the ability to reclaim suballoc
 free bg
Message-ID: <6bt4hapd3fij4nlekl5dj2g2bxgcmfujuxfzb37lpjfypbzda6@ahgdnhjablpi>
References: <20240908140705.19169-1-heming.zhao@suse.com>
 <20240908140705.19169-2-heming.zhao@suse.com>
 <c87729aa-79ca-47ca-97b5-4af7c3829e12@linux.alibaba.com>
 <7c8e2f25-6263-441d-b299-cc81109875b9@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8e2f25-6263-441d-b299-cc81109875b9@suse.com>

Hi Joseph,

Sorry for waking up this thread. Please see my comments below.

On Wed, Oct 09, 2024 at 10:56:47AM +0800, Heming Zhao wrote:
> On 10/8/24 15:16, Joseph Qi wrote:
> > 
> > 
> > On 9/8/24 10:07 PM, Heming Zhao wrote:
> > > The current ocfs2 code can't reclaim suballocator block group space.
> > > This cause ocfs2 to hold onto a lot of space in some cases. for example,
> > > when creating lots of small files, the space is held/managed by
> > > '//inode_alloc'. After the user deletes all the small files, the space
> > > never returns to '//global_bitmap'. This issue prevents ocfs2 from
> > > providing the needed space even when there is enough free space in a
> > > small ocfs2 volume.
> > > This patch gives ocfs2 the ability to reclaim suballoc free space when
> > > the block group is freed. For performance reasons, this patch keeps
> > > the first suballocator block group.
> > > 
> > > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > > Reviewed-by: Su Yue <glass.su@suse.com>
> > > ---
> > >   fs/ocfs2/suballoc.c | 302 ++++++++++++++++++++++++++++++++++++++++++--
> > >   1 file changed, 292 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> > > index f7b483f0de2a..d62010166c34 100644
> > > --- a/fs/ocfs2/suballoc.c
> > > +++ b/fs/ocfs2/suballoc.c
> > > @@ -294,6 +294,68 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
> > >   	return ocfs2_validate_gd_self(sb, bh, 0);
> > >   }
> > > +/*
> > > + * hint gd may already be released in _ocfs2_free_suballoc_bits(),
> > > + * we first check gd descriptor signature, then do the
> > > + * ocfs2_read_group_descriptor() jobs.
> > > + *
> > > + * When the group descriptor is invalid, we return 'rc=0' and
> > > + * '*released=1'. The caller should handle this case. Otherwise,
> > > + * we return the real error code.
> > > + */
> > > +static int ocfs2_read_hint_group_descriptor(struct inode *inode,
> > > +			struct ocfs2_dinode *di, u64 gd_blkno,
> > > +			struct buffer_head **bh, int *released)
> > > +{
> > > +	int rc;
> > > +	struct buffer_head *tmp = *bh;
> > > +	struct ocfs2_group_desc *gd;
> > > +
> > > +	*released = 0;
> > 
> > I'd like the caller is responsible for the initialization.
> 
> OK.
> 
> > 
> > > +
> > > +	rc = ocfs2_read_block(INODE_CACHE(inode), gd_blkno, &tmp, NULL);
> > > +	if (rc)
> > > +		goto out;
> > > +
> > > +	gd = (struct ocfs2_group_desc *) tmp->b_data;
> > > +	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
> > 
> > How to distinguish the release case or a bug?
> 

I rechecked the code and withdraw my previous comments, as the release gap
doesn't exist.
The reason: ocfs2 locks alloc_inode before calling threads A and B.

Redarding the question: How to distinguish the release case or a bug?

(Hope I correctly understand your question) my answer:
ocfs2_read_hint_group_descriptor is derived from ocfs2_read_group_descriptor.
The differ is:
- ocfs2_read_group_descriptor calls ocfs2_read_block() and passes the
  'validate':ocfs2_validate_group_descriptor.
- ocfs2_read_hint_group_descriptor calls ocfs2_read_block and passes the 
  'validate':null

The job of distinguishing between a release case or a bug is similar to that of
ocfs2_read_group_descriptor. I directly call ocfs2_validate_group_descriptor
and ocfs2_validate_gd_parent after the GD signature is correct. If we
encounter a bug case, the subsequent validation functions will handle it.
Btw, in the new function _reclaim_to_main_bm(), the
memset(group, 0, sizeof(struct ocfs2_group_desc)) will clean up all group info.
Therefore, after applying this patch, the GD area is full with ZEROs after being
released.

Why can't we reuse the existing ocfs2_validate_group_descriptor()?
It calls ocfs2_validate_gd_self(), which triggers do_error() and makes the volume
read-only.

Thanks,
Heming

> Good question.
> 
> Before this patch, OCFS2 never releases suballocator space.
> The ocfs2_read_group_descriptor() doesn't need to handle the
> case of reading a bad 'struct ocfs2_group_desc'.
> 
> After this patch, there is a gap between
> _ocfs2_free_suballoc_bits() and ocfs2_read_hint_group_descriptor().
> 
> 
>      thread A                          thread B
> -------------------------------------------------------------
> ocfs2_claim_suballoc_bits
>  hint is not zero
>   ocfs2_search_one_group
>    + ocfs2_read_hint_group_descriptor
>    | + OCFS2_IS_VALID_GROUP_DESC(gd)
>    |    returns true
>    |                                _ocfs2_free_suballoc_bits
>    + ...                             + free the last bit of gd
>    |                                    + release gd
>    + ocfs2_block_group_set_bits
>       uses released gd, data corruption
> --------------------------------------------------------------
> 
> I plan to introduce a new cache_info flag 'OCFS2_CACHE_CLEAN_GD' to protect this case.
> e.g. (just demo, not tested)
> 
> 
>      thread A                          thread B
> -------------------------------------------------------------
> ocfs2_read_hint_group_descriptor()
>   ocfs2_read_block()
> 
>   //protect code begin
>   ci = INODE_CACHE(inode);
>   ocfs2_metadata_cache_io_lock(ci);
>   if (ci->ci_flags & OCFS2_CACHE_CLEAN_GD)
>       goto free_bh;
>   ocfs2_metadata_cache_io_unlock(ci);
>   //protect code end
> 
>   gd = (struct ocfs2_group_desc *) tmp->b_data;
>   if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
>      ... ...
>   }
> 
>                               _ocfs2_free_suballoc_bits()
>                                 ... ...
>                                 if (ocfs2_is_cluster_bitmap(alloc_inode) ||
>                                     (le32_to_cpu(rec->c_free) != (le32_to_cpu(rec->c_total) - 1)) ||
>                                     (le16_to_cpu(cl->cl_next_free_rec) == 1)) {
>                                         goto bail;
>                                 }
> 
>                                 //protect code begin
>                                 ci = INODE_CACHE(alloc_inode);
>                                 ocfs2_metadata_cache_io_lock(ci);
>                                 if (ci->ci_num_cached > 1) {
>                                         goto bail;
>                                 }
>                                 ci->ci_flags |= OCFS2_CACHE_CLEAN_GD;
>                                 ocfs2_metadata_cache_io_unlock(ci);
>                                 //protect code end
> 
>                                 _ocfs2_reclaim_suballoc_to_main(handle, alloc_inode, alloc_bh, group_bh);
> --------------------------------------------------------------
> 
> > 
> > > +		/*
> > > +		 * Invalid gd cache was set in ocfs2_read_block(),
> > > ... ...
> > > +/*
> > > + * Reclaim the suballocator managed space to main bitmap.
> > > + * This function first works on the suballocator then switch to the
> > > + * main bitmap.
> > > + *
> > > + * handle: The transaction handle
> > > + * alloc_inode: The suballoc inode
> > > + * alloc_bh: The buffer_head of suballoc inode
> > > + * group_bh: The group descriptor buffer_head of suballocator managed.
> > > + *           Caller should release the input group_bh.
> > > + */
> > > +static int _reclaim_to_main_bm(handle_t *handle,
> > 
> > Better to rename it to _ocfs2_reclaim_suballoc_to_main().
> 
> OK.
> > 
> > > +			struct inode *alloc_inode,
> > > +			struct buffer_head *alloc_bh,
> > > +			struct buffer_head *group_bh)
> > > +{
> > > +	int idx, status = 0;
> > > +	int i, next_free_rec, len = 0;
> > > +	__le16 old_bg_contig_free_bits = 0;
> > > ... ...
> > > +	le32_add_cpu(&rec->c_free, count);
> > >   	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
> > >   	fe->id1.bitmap1.i_used = cpu_to_le32(tmp_used - count);
> > >   	ocfs2_journal_dirty(handle, alloc_bh);
> > > +	/*
> > > +	 * Reclaim suballocator free space.
> > > +	 * Bypass: global_bitmap, not empty rec, first rec in cl_recs[]
> > 
> > s/not empty rec/non empty rec
> 
> OK.
> 
> /Heming
