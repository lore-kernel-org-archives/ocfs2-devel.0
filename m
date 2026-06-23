Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DAF2D77F5
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Jun 2026 08:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205057; cv=none; b=mCQdrcGfIGfnQuMxmPNdtcszpSKg7mvp+YXrkBQIkYSIiseSojIKK77T+7Akcya+sPYy1OeEq2SPkkqhiwtQdFtr1NyquKArj4U0IpMeKsLW/TjzmmATUEFBIn1pssO+EkdBNx1dFFiaw2Cy3RSvGWom0XtEnEeB938Mgbk3vWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205057; c=relaxed/simple;
	bh=UDgovk8e0uvfUNzd7Y9viDwFr0Szfk/YvlVeNh1R/4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAcPP3A46c9p3uu4JYEnTtw6Gx2tvoaxv9Uf0E9dnvMZhOv0cjo7MQ5dubb4MdxgA7LCsq99m+mxBu6s/OuDBTYmf9G+Fy5PPOAC7nmgVXY4wCLszXMi9iU7uLuTByZIiAtl4oz/CYYpy09vclkuPEVLDRd0Ptb2eyt8oVWl3D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gAFC5TNy; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gAFC5TNy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782205052; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lXOl1PXjk1xBX6PxoU446UPkEmAK2EQp1O9MOld5tu0=;
	b=gAFC5TNyGBdlhfC0+LnDeXR8lHtK9g8ix4Ca7sUjrMiHbcsJaOXU3NAVPaSqs41xzexp6BSiZBBVkZaf/pIHeDQtokLYWdY5uNr6Ev5zhkYcyrNa2yTMIHdDNGrG3fspw8DuGND/XkgILC14tBpjFlAqLX2AxN4vC+mM+F7/4s4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X5TeSg-_1782205050;
Received: from 30.221.145.127(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X5TeSg-_1782205050 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 16:57:31 +0800
Message-ID: <d05e492c-303a-4903-966e-53e6aacc54b4@linux.alibaba.com>
Date: Tue, 23 Jun 2026 16:57:30 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] ocfs2: validate inline xattrs during inode block
 validation
To: Cen Zhang <zzzccc427@gmail.com>, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260622130332.2094018-1-zzzccc427@gmail.com>
 <20260622130332.2094018-2-zzzccc427@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260622130332.2094018-2-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/22/26 9:03 PM, Cen Zhang wrote:
> ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
> metadata from it, but inline xattr metadata is still checked only in
> some consumers. The current ibody helper validates the inline header
> placement and entry count before deriving the header from
> i_xattr_inline_size, but it does not reject entry name/value bounds from
> inode block validation.
> 
> Extend the shared ibody helper with name/value bounds checks and call it
> from ocfs2_validate_inode_block(). Keep the get/list paths using the same
> helper before they derive pointers from i_xattr_inline_size so callers
> with an already-loaded dinode still get the same corruption check.
> 
> Reject corrupted inline xattr metadata before ocfs2_xattr_ibody_get() or
> listxattr() can walk past the inline storage.
> 
> Validation reproduced this kernel report:
> BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170
> Read of size 2 at addr ffff8881242a2000 by task python3/529
> Call Trace:
>   dump_stack_lvl+0x66/0xa0
>   print_report+0xce/0x630
>   kasan_report+0xe0/0x110
>   ocfs2_xattr_find_entry+0x5a/0x170
>   ocfs2_xattr_get_nolock+0x20a/0x820
>   ocfs2_xattr_get+0x10c/0x1e0
>   __vfs_getxattr+0xe2/0x130
>   vfs_getxattr+0x185/0x1b0
> 
> Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/ocfs2/inode.c |   4 ++
>  fs/ocfs2/xattr.c | 112 +++++++++++++++++++++++++++++++++++++----------
>  fs/ocfs2/xattr.h |   2 +
>  3 files changed, 95 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 662dbc845b8b..815bf3f659da 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1608,6 +1608,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	rc = ocfs2_validate_inode_xattr(sb, bh->b_blocknr, di);
> +	if (rc)
> +		goto bail;
> +
>  	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
>  		struct ocfs2_inline_data *data = &di->id2.i_data;
>  
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index fcddd3c13acd..00900e65634d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -950,39 +950,105 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	return result;
>  }
>  
> -static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> -					   struct ocfs2_dinode *di,
> -					   struct ocfs2_xattr_header **header)
> +static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
> +					struct ocfs2_xattr_header *xh,
> +					size_t storage_size,
> +					const char *where)

Seems we can define a ocfs2_xattr_entry_type and pass in, then compute
the size inside ocfs2_validate_xattr_entries().
e.g.

enum ocfs2_xattr_entry_type {
	OCFS2_XATTR_IBODY,
	OCFS2_XATTR_BLOCK,
	OCFS2_XATTR_BUCKET
};

And here 'where' is to identify inline xattr, xattr block or bucket.
Commonly, blkno is already sufficient to uniquely identifies the corrupt
block. So I'd rather drop it for simplification.

>  {
> -	u16 xattr_count;
> +	u16 xattr_count = le16_to_cpu(xh->xh_count);
>  	size_t max_entries;
> +	int i;
> +
> +	if (storage_size < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid %s in block %llu: storage size %zu is too small\n",
> +				   where, (unsigned long long)blkno,
> +				   storage_size);
> +
> +	max_entries = (storage_size - sizeof(*xh)) /
> +		      sizeof(struct ocfs2_xattr_entry);
> +	if (xattr_count > max_entries) {
> +		return ocfs2_error(sb,
> +				   "Invalid %s in block %llu: entry count %u exceeds maximum %zu\n",
> +				   where, (unsigned long long)blkno,
> +				   xattr_count, max_entries);
> +	}
> +
> +	for (i = 0; i < xattr_count; i++) {
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
> +		size_t value_offset;
> +
> +		if (name_offset > storage_size ||
> +		    xe->xe_name_len > storage_size - name_offset)
> +			return ocfs2_error(sb,
> +					   "Invalid %s in block %llu: entry %d name is out of bounds\n",
> +					   where, (unsigned long long)blkno, i);
> +
> +		value_offset = name_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
> +		if (value_offset > storage_size)
> +			return ocfs2_error(sb,
> +					   "Invalid %s in block %llu: entry %d value starts out of bounds\n",
> +					   where, (unsigned long long)blkno, i);
> +
> +		if (ocfs2_xattr_is_local(xe)) {
> +			if (le64_to_cpu(xe->xe_value_size) >
> +			    storage_size - value_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid %s in block %llu: entry %d value is out of bounds\n",
> +						   where,
> +						   (unsigned long long)blkno,
> +						   i);
> +		} else if (sizeof(struct ocfs2_xattr_value_root) >
> +			   storage_size - value_offset) {
> +			return ocfs2_error(sb,
> +					   "Invalid %s in block %llu: entry %d value root is out of bounds\n",
> +					   where, (unsigned long long)blkno, i);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocfs2_validate_xattr_ibody_header(struct super_block *sb, u64 blkno,
> +					     struct ocfs2_dinode *di,
> +					     struct ocfs2_xattr_header **header)
> +{
> +	struct ocfs2_xattr_header *xh;
>  	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
>  
> -	if (inline_size > inode->i_sb->s_blocksize ||
> +	if (inline_size > sb->s_blocksize ||
>  	    inline_size < sizeof(struct ocfs2_xattr_header)) {
> -		ocfs2_error(inode->i_sb,
> -			    "Invalid xattr inline size %u in inode %llu\n",
> -			    inline_size,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> -		return -EFSCORRUPTED;
> +		return ocfs2_error(sb,
> +				   "Invalid inode %llu: xattr inline size %u\n",
> +				   (unsigned long long)blkno, inline_size);
>  	}
>  
> -	*header = (struct ocfs2_xattr_header *)
> -		((void *)di + inode->i_sb->s_blocksize - inline_size);
> +	xh = (struct ocfs2_xattr_header *)
> +		((void *)di + sb->s_blocksize - inline_size);
> +	if (header)
> +		*header = xh;
>  
> -	xattr_count = le16_to_cpu((*header)->xh_count);
> -	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
> -		      sizeof(struct ocfs2_xattr_entry);
> +	return ocfs2_validate_xattr_entries(sb, blkno, xh, inline_size,
> +					    "inline xattr");
> +}
>  
> -	if (xattr_count > max_entries) {
> -		ocfs2_error(inode->i_sb,
> -			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
> -			    xattr_count, max_entries,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> -		return -EFSCORRUPTED;
> -	}
> +int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
> +			       struct ocfs2_dinode *di)
> +{
> +	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
> +		return 0;
>  
> -	return 0;
> +	return ocfs2_validate_xattr_ibody_header(sb, blkno, di, NULL);
> +}
> +
> +static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> +					   struct ocfs2_dinode *di,
> +					   struct ocfs2_xattr_header **header)
> +{
> +	return ocfs2_validate_xattr_ibody_header(inode->i_sb,
> +						OCFS2_I(inode)->ip_blkno,
> +						di, header);
>  }

Since ocfs2_validate_inode_block() already validated at buffer read
time, it seems this per-operation re-check is wasted work.

Thanks,
Joseph

>  
>  int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 65e9aa743919..6b7589941315 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -43,6 +43,8 @@ int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
>  			   struct ocfs2_alloc_context *);
>  int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
>  					 struct ocfs2_dinode *di);
> +int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
> +			       struct ocfs2_dinode *di);
>  int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
>  int ocfs2_init_security_get(struct inode *, struct inode *,
>  			    const struct qstr *,

