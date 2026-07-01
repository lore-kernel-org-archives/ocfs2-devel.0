Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8B3E716F
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Jul 2026 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894773; cv=none; b=PaxItmzLOkktzn87NjP5SLlKIzTeL6EYou8c1x+eHlN/BO1B0LhV9418Uth3sud8b3/a7EjxmLEQ+Z/KpfhyE5uHfOgzNd34H64lSHLU5MgUUU6YUeMAO54KIvSeZBNTSrLkHjgz27XGyrBT8+bYwkwFMDSpsVRpKuQoQ0VNNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894773; c=relaxed/simple;
	bh=DfHQE9+BinNW9Jjajj8mHInoL30ySWTdUC4sSmKRQUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXgI2zijU0DCPRSalAmr9tDJGPhoe8y8fDOgwZSYD3p9tGqv80MQDSdMNgsccDRZfSSLkD6Z/dcTBSxgyHRZDbf5Qn8cVShPK8jp9rhdR1sOriRCWUwdh2G/nW6qiIBjvBMeumSoHNPg2x4ddoSiqe+LSemEqySKYxlZcjGyI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=w0W9gjzK; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="w0W9gjzK"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782894760; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8C6WYupsEkT9Z4dMPumqtDl4SNMV3YK3qzsRJQEPLy4=;
	b=w0W9gjzKWt5nbUD02MZ4Pu1eCxGoVmD9Si77QbsgBYb2B9bySYUiZ2BUVqXAPKe1pg02ZfLvtMS/J6SyKMehlJgnzccdTmQXj8+iEbAqC0jLwdjT2/iGhbf5uSQ35TqmRQp5Q9vAe3hFDw/K4kFVSMlBp98dLMLPVNtasxEZktI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X66Mz7E_1782894757;
Received: from 30.221.145.49(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X66Mz7E_1782894757 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 16:32:38 +0800
Message-ID: <8ae91036-3485-4410-a924-5316da12fd78@linux.alibaba.com>
Date: Wed, 1 Jul 2026 16:32:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] ocfs2: validate inline xattrs during inode block
 validation
To: Cen Zhang <zzzccc427@gmail.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260625091303.234624-1-zzzccc427@gmail.com>
 <20260625091303.234624-2-zzzccc427@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260625091303.234624-2-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 5:13 PM, Cen Zhang wrote:
> ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
> metadata from it, but inline xattr metadata is still checked only in
> operation-specific consumers.  The existing ibody lookup helper validates
> inline header placement and entry count, but inode block validation does
> not reject entry name/value bounds.
> 
> Add a shared xattr entry validator and call it from inode block
> validation for inline xattrs.  Keep the operation paths on their existing
> header/count lookup checks; the full entry bounds check now runs when the
> inode block is validated at read time.
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
>  fs/ocfs2/xattr.c | 169 +++++++++++++++++++++++++++++++++++++++++++----
>  fs/ocfs2/xattr.h |   2 +
>  3 files changed, 162 insertions(+), 13 deletions(-)
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
> index fcddd3c13acd..b6f00926849d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -68,6 +68,12 @@ struct ocfs2_xattr_bucket {
>  	int bu_blocks;
>  };
>  
> +enum ocfs2_xattr_entry_type {
> +	OCFS2_XATTR_IBODY,
> +	OCFS2_XATTR_BLOCK,
> +	OCFS2_XATTR_BUCKET,
> +};
> +
>  struct ocfs2_xattr_set_ctxt {
>  	handle_t *handle;
>  	struct ocfs2_alloc_context *meta_ac;
> @@ -950,41 +956,178 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	return result;
>  }
>  
> -static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> -					   struct ocfs2_dinode *di,
> -					   struct ocfs2_xattr_header **header)
> +static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
> +					struct ocfs2_xattr_header *xh,
> +					enum ocfs2_xattr_entry_type type,
> +					size_t storage_size)

Here 'storage_size' and 'entry_storage_size' looks confused.

IMO, there are 3 concepts here:
  size_t region_size;      /* whole xh region: entries + name/value */
  size_t entries_limit;    /* xh_entries[] must fit within this */
  size_t nv_limit;         /* per-entry name+value must fit within this */

And the IBODY/BLOCK paths are byte-for-byte identical (flat, single
region). Only BUCKET is different (table in block 0, name+value bounded
per block,  offsets can exceed one block). So could we split this into:
  ocfs2_validate_xattr_entries_flat(), for IBODY/BLOCK;
  ocfs2_validate_xattr_entries_bucket(), for BUCKET.

> +{
> +	u16 xattr_count = le16_to_cpu(xh->xh_count);
> +	size_t entry_storage_size = storage_size;
> +	size_t max_entries;
> +	int i;
> +
> +	switch (type) {
> +	case OCFS2_XATTR_IBODY:
> +		break;
> +	case OCFS2_XATTR_BLOCK:
> +		storage_size = sb->s_blocksize -
> +			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
> +		entry_storage_size = storage_size;
> +		break;
> +	case OCFS2_XATTR_BUCKET:

This looks buggy.
e.g. When it passes OCFS2_XATTR_BUCKET with storage_size 0.

Thanks,
Joseph

> +		entry_storage_size = sb->s_blocksize;
> +		break;
> +	}
> +
> +	if (storage_size < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr in block %llu: storage size %zu is too small\n",
> +				   (unsigned long long)blkno, storage_size);
> +
> +	if (entry_storage_size < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr in block %llu: entry storage size %zu is too small\n",
> +				   (unsigned long long)blkno,
> +				   entry_storage_size);
> +
> +	max_entries = (entry_storage_size - sizeof(*xh)) /
> +		      sizeof(struct ocfs2_xattr_entry);
> +
> +	if (xattr_count > max_entries)
> +		return ocfs2_error(sb,
> +				   "Invalid xattr in block %llu: entry count %u exceeds maximum %zu\n",
> +				   (unsigned long long)blkno,
> +				   xattr_count, max_entries);
> +
> +	for (i = 0; i < xattr_count; i++) {
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
> +		size_t value_offset;
> +		size_t value_limit = storage_size;
> +
> +		if (type == OCFS2_XATTR_BUCKET) {
> +			size_t block_offset;
> +
> +			if (name_offset >= storage_size)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +
> +			block_offset = name_offset % sb->s_blocksize;
> +			if (xe->xe_name_len > sb->s_blocksize - block_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr in block %llu: entry %d name crosses block boundary\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +
> +			value_offset = block_offset +
> +				OCFS2_XATTR_SIZE(xe->xe_name_len);
> +			value_limit = sb->s_blocksize;
> +		} else {
> +			if (name_offset > storage_size ||
> +			    xe->xe_name_len > storage_size - name_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +
> +			value_offset = name_offset +
> +				OCFS2_XATTR_SIZE(xe->xe_name_len);
> +		}
> +
> +		if (value_offset > value_limit)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr in block %llu: entry %d value starts out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +
> +		if (ocfs2_xattr_is_local(xe)) {
> +			if (le64_to_cpu(xe->xe_value_size) >
> +			    value_limit - value_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +		} else if (sizeof(struct ocfs2_xattr_value_root) >
> +			   value_limit - value_offset) {
> +			return ocfs2_error(sb,
> +					   "Invalid xattr in block %llu: entry %d value root is out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocfs2_xattr_ibody_lookup_header_raw(struct super_block *sb,
> +					       u64 blkno,
> +					       struct ocfs2_dinode *di,
> +					       struct ocfs2_xattr_header **header,
> +					       u16 *inline_size_ret)
>  {
> +	struct ocfs2_xattr_header *xh;
>  	u16 xattr_count;
>  	size_t max_entries;
>  	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
>  
> -	if (inline_size > inode->i_sb->s_blocksize ||
> +	if (inline_size > sb->s_blocksize ||
>  	    inline_size < sizeof(struct ocfs2_xattr_header)) {
> -		ocfs2_error(inode->i_sb,
> -			    "Invalid xattr inline size %u in inode %llu\n",
> -			    inline_size,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +		ocfs2_error(sb,
> +			    "Invalid inode %llu: xattr inline size %u\n",
> +			    (unsigned long long)blkno, inline_size);
>  		return -EFSCORRUPTED;
>  	}
>  
> -	*header = (struct ocfs2_xattr_header *)
> -		((void *)di + inode->i_sb->s_blocksize - inline_size);
> +	xh = (struct ocfs2_xattr_header *)
> +		((void *)di + sb->s_blocksize - inline_size);
>  
> -	xattr_count = le16_to_cpu((*header)->xh_count);
> +	xattr_count = le16_to_cpu(xh->xh_count);
>  	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
>  		      sizeof(struct ocfs2_xattr_entry);
>  
>  	if (xattr_count > max_entries) {
> -		ocfs2_error(inode->i_sb,
> +		ocfs2_error(sb,
>  			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
>  			    xattr_count, max_entries,
> -			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +			    (unsigned long long)blkno);
>  		return -EFSCORRUPTED;
>  	}
>  
> +	*header = xh;
> +	if (inline_size_ret)
> +		*inline_size_ret = inline_size;
> +
>  	return 0;
>  }
>  
> +int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
> +			       struct ocfs2_dinode *di)
> +{
> +	struct ocfs2_xattr_header *xh;
> +	u16 inline_size;
> +	int ret;
> +
> +	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
> +		return 0;
> +
> +	ret = ocfs2_xattr_ibody_lookup_header_raw(sb, blkno, di, &xh,
> +						  &inline_size);
> +	if (ret)
> +		return ret;
> +
> +	return ocfs2_validate_xattr_entries(sb, blkno, xh, OCFS2_XATTR_IBODY,
> +					    inline_size);
> +}
> +
> +static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> +					   struct ocfs2_dinode *di,
> +					   struct ocfs2_xattr_header **header)
> +{
> +	return ocfs2_xattr_ibody_lookup_header_raw(inode->i_sb,
> +						   OCFS2_I(inode)->ip_blkno,
> +						   di, header, NULL);
> +}
> +
>  int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
>  					 struct ocfs2_dinode *di)
>  {
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

