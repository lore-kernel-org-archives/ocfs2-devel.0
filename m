Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C9837CD2B
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Apr 2026 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776064765; cv=none; b=Y05uHI5aNaHclkVxsejMFD3AJjuKId+T9GR/2mHs64UeWnW3Cz98bHQfKf8hMw9n6FLJYi104wAqGW8mYXqCdHkTNiFjjiABaRRKZG8O625POq/z2eNCnRzUuEGsRQLShHkJ/OG15wAayVryzQmUHvLxvdnqmONd34vyXIEYRXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776064765; c=relaxed/simple;
	bh=rn+QrDk+SlMMRt5usRluguB9OFmxaLPSMxHosOg4imk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BimW+dv4vZfpSO0iNJa684YMyVS2JjZvB16hs16hWtrqx9PV79ew8Sq9PCmJDsclYmLhx6ivFOHMGHqeuF62Q54WxefS4VkQwQ25UjbIQybaO2paAKcjykLhN0WqgLMqwjfFxqU0eNU100InqutCLKofoWK4PQvT0aG2AyE/juI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WckDTLWE; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WckDTLWE"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so6073395e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 13 Apr 2026 00:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776064762; x=1776669562; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hlmRcWICZMZ9c9tKI2BKT6X6tbLrcnl1JUkccfCc8cs=;
        b=WckDTLWE3VsrB98oL8LPHWEeKTuEPGaLgIBnkA9jP3p1sbcoVpsridU7yXJSMKVIpC
         rRhUoqTAuBDb0E2Akx0T/l8YSnJkA4gMPqcltoqQDZWzkjgko+G9gBb4QmIHC/02/TC5
         zdvqSysYsoTiY2D+POADeSyWYQ0SyHYdJGB2yNoU2VZImMT2E2fsPPA/pTVMp49uDFy7
         dQ3dRo1jCMZKf+Hz3XI9Vm1PmPIt8eGMsQjA4Sqk/cpqJGncG9vrdH0nsjySgxOcMyeT
         Kpji3h/F9kFo81UNEgyERrwTKrtUZ8R7km9bM6jpvq82KaH5RAt+j6paOVt5Z1OJwRoN
         H3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776064762; x=1776669562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hlmRcWICZMZ9c9tKI2BKT6X6tbLrcnl1JUkccfCc8cs=;
        b=arctvnbcnsZnu3PtNL+8C5LWtCgO6+996XuMfG+l3hxwE0Ia3ytlkYVQqSQO+AH+Xm
         luWUeiUdCui3gncf+ERWqgHIrp5zCjt6ZPI34mV29r7qbVqjg+Fuaj+vQF1dWBz7gNeL
         f2Ua2c80RGWSH2Iiv19UCLHei4SdAxGbUmgK7QrbTzxHuu18NG9dRctHhhwyKuTv8jIy
         vkiQTwGQWmNgHHjsG6TYcGPojU2yxzc2FXGo9aFLcNUFcpwt6U5FriJUF8/pvtD2cfJ+
         gNtv08T7Ewm+XeF7GrkaAsOWonEzsF5oLMmbIV3KI/Rmp78BadEnWD7CycCFYwE/qRy9
         npig==
X-Forwarded-Encrypted: i=1; AFNElJ9BFnbzsb7abFnjtQfugZMXm6+VaXBo8MTMaXJrHrTu7uEGYa1tJlCJcdIjiEZcHBs02NJygFDmLpvNUQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYPZY2hNzFGNxvMEwYjuK4Pou1ZQ1NW7sZ0OrrH0ntJiaW7W6x
	XNXjOavHZ2jhTy4ccQu36eHFQJtf4G7Kap6rZgQhdjARlWd44IPYc8zRt2eK24BC1cs=
X-Gm-Gg: AeBDietPyF2ttBJgGZpS2slkXWurJhu1NdsgwW6coqUvPQKeu80GDkkskBg3f3M6MT2
	zG5E4gd4Zf5VC6w3LOCj5DYHk3ZqBe2//FeBUOcFuUtfq0lAkbdCsSTfQfeCeji7UC1EYnRlhHw
	5HSK4hrNmy1uHnYQPk7zJP77WeRTX3bnqWvRMWy+8JRzysua104CKqDVevMmWRl/0osgj5D4bUQ
	8YBArO1oQk6pPq/QlLYp+xv77/e1lI1BTBKC+mCqj7dr4hOmTc2jeU7hxlp5+g/+gwIlO5xJtw7
	vyLmKAn+vh4bmEqjB9ES6kiw3tKWRZaDQS/1Lo1r3r6c+q5JOi8t1QaqLKajJssIlja+UQxDGKG
	kvf/2WkYQ4PqFwrl04fnGnTPvjQJgjF8ms/tCqWV87kPMAE9E49qG79/9jFIfEviroe2otB295I
	VKjIFvA1i/EA6ji4jKQATXPA==
X-Received: by 2002:a05:600c:4506:b0:486:fc61:541d with SMTP id 5b1f17b1804b1-488d7eac0c1mr97748655e9.2.1776064762358;
        Mon, 13 Apr 2026 00:19:22 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c377318sm9828665b3a.26.2026.04.13.00.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:19:21 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:19:17 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, 
	r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2] ocfs2: validate inline dir size during inode reads
Message-ID: <57ej3tjpgtx7myqagtuxj6js7nbnaa6wpdko26jo2wuw6ci5au@rpa7hwij2gri>
References: <20260410113229.4092277-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410113229.4092277-1-gality369@gmail.com>

On Fri, Apr 10, 2026 at 07:32:29PM +0800, ZhengYuan Huang wrote:
> [BUG]
> A crafted inline-data directory can store i_size larger than id_count.
> Once such a dinode is instantiated, readdir walks past data->id_data
> and KASAN reports:
> 
> BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
> Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
> Call Trace:
>  ...
>  ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
>  ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
>  ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
>  ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
>  wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
>  shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
>  iterate_dir+0x276/0x9e0 fs/readdir.c:108
>  __do_sys_getdents64 fs/readdir.c:410 [inline]
>  __se_sys_getdents64 fs/readdir.c:396 [inline]
>  __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
>  ...
> 
> [CAUSE]
> The inline-dir invariant i_size <= id_count is never validated when a
> dinode is read. ocfs2_validate_inode_block() accepts the corrupted
> metadata, then ocfs2_populate_inode() or ocfs2_refresh_inode() copies
> that unchecked on-disk i_size into inode->i_size.
> 
> JBD2-managed buffers can also bypass ocfs2_validate_inode_block(), so
> the same unchecked size can still reach ocfs2_populate_inode() and
> ocfs2_refresh_inode() through those read paths.
> 
> [FIX]
> Introduce a shared helper that validates inline directory i_size
> against id_count. Call it from ocfs2_validate_inode_block() so corrupt
> inline-dir dinodes are rejected in the cold metadata-read path, and add
> matching guards in ocfs2_read_locked_inode() and ocfs2_inode_lock_update()
> for the JBD2-managed buffer paths that skip the validator.
> 
> This blocks the corrupted metadata before it reaches VFS inode state
> and keeps the hot readdir path unchanged.
> 
> Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> v2:
> - Move the validation from ocfs2_dir_foreach_blk_id() to inode read paths
> - Add JBD2-managed buffer guards in ocfs2_read_locked_inode() and ocfs2_inode_lock_update()
> - Reword the changelog to describe unchecked on-disk i_size rather than corrupted in-memory state

ocfs2_validate_inode_block() already has the logic to check inline-data size.
You can find it by searching for:
"if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {"

- Heming

> ---
>  fs/ocfs2/dlmglue.c |  5 +++++
>  fs/ocfs2/inode.c   | 29 +++++++++++++++++++++++++++++
>  fs/ocfs2/inode.h   |  2 ++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 92a6149da9c1..69aaceeb76bc 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -2363,6 +2363,11 @@ static int ocfs2_inode_lock_update(struct inode *inode,
>  			goto bail_refresh;
>  		}
>  
> +		/* JBD2-managed buffers can bypass ocfs2_validate_inode_block(). */
> +		status = ocfs2_validate_inline_dir(inode->i_sb, oi->ip_blkno, fe);
> +		if (status)
> +			goto bail_refresh;
> +
>  		/* This is a good chance to make sure we're not
>  		 * locking an invalid object.  ocfs2_read_inode_block()
>  		 * already checked that the inode block is sane.
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..3c8a9b592d25 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -66,6 +66,26 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
>  static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
>  					      struct buffer_head *bh);
>  
> +/* Inline directories must never advertise more data than id_count can hold. */
> +int ocfs2_validate_inline_dir(struct super_block *sb, u64 blkno,
> +			      struct ocfs2_dinode *di)
> +{
> +	struct ocfs2_inline_data *data = &di->id2.i_data;
> +
> +	if (!S_ISDIR(le16_to_cpu(di->i_mode)) ||
> +	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL))
> +		return 0;
> +
> +	if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count))
> +		return ocfs2_error(sb,
> +				   "Invalid dinode #%llu: inline dir i_size %llu exceeds id_count %u\n",
> +				   (unsigned long long)blkno,
> +				   (unsigned long long)le64_to_cpu(di->i_size),
> +				   le16_to_cpu(data->id_count));
> +
> +	return 0;
> +}
> +
>  void ocfs2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = OCFS2_I(inode)->ip_attr;
> @@ -611,6 +631,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  			"Inode %llu: system file state is ambiguous\n",
>  			(unsigned long long)args->fi_blkno);
>  
> +	/* JBD2-managed buffers can bypass ocfs2_validate_inode_block(). */
> +	status = ocfs2_validate_inline_dir(inode->i_sb, args->fi_blkno, fe);
> +	if (status)
> +		goto bail;
> +
>  	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
>  	    S_ISBLK(le16_to_cpu(fe->i_mode)))
>  		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
> @@ -1503,6 +1528,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	rc = ocfs2_validate_inline_dir(sb, bh->b_blocknr, di);
> +	if (rc)
> +		goto bail;
> +
>  	rc = 0;
>  
>  bail:
> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> index accf03d4765e..1d71648c1294 100644
> --- a/fs/ocfs2/inode.h
> +++ b/fs/ocfs2/inode.h
> @@ -139,6 +139,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
>  
>  void ocfs2_set_inode_flags(struct inode *inode);
>  void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi);
> +int ocfs2_validate_inline_dir(struct super_block *sb, u64 blkno,
> +			      struct ocfs2_dinode *di);
>  
>  static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
>  {
> -- 
> 2.49.0
> 
