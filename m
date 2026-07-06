Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13DF449EB0
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jul 2026 06:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783319090; cv=none; b=brv2PE1hUCZvJHFYz7XLLvLMFNVxIuZ1KNG8nwcI2OMyfcLkojxd37QuanxvBVxRyRHD/yIU49v+cTGFiKgfhH1zMx9zlZVgulZYzqS7UjCc/7EMWGrWvWnCvQBGDXF9XFJLYNCmX7f3qcYBiOfGjaoPqocobxKNZhWs+FzSN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783319090; c=relaxed/simple;
	bh=dsDLfpAJZojcjHnlwhCbyHLoh/cpSSllNldUO+vn8dw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWx8A92rIaP0PfACf91JhtZpfBUvOHZ46oeY8hi/sjwjEbLLAmJoz2QKymu21u8ioU6VDW0teidRF3P1jqvG2aXVw57Rvqi9acJ+MHLEGW7g6+9tDibCLP4fY8H5Vum6eXpnTZYKG9H7ckXr4rCsHnzVmPgrd1tBv/nVo8cMSCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CMmxddyN; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CMmxddyN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783319075; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=G+tHIJCPobKWzMYsN62CNWojPqT5+1B4ZYUpGptJKP4=;
	b=CMmxddyNvmTdovGMkUXN+QO5IQnQgxpgOb23oraOjs/5Lh5B96LMCBBZL2HsqqHbsd3Dnl++h+blR2qx6Z2xuMsEA7bJbpi6B2duAsNcTM7JDqt3oawFJigHn10eQKQIKOhFmWHg9CWrP1lk7h6WvFn9CR9gzvSx3HPVWHQXQtQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6QX-YU_1783319074;
Received: from 30.221.144.246(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6QX-YU_1783319074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 14:24:34 +0800
Message-ID: <d97f819f-82ea-412f-869b-aeab4b484853@linux.alibaba.com>
Date: Mon, 6 Jul 2026 14:24:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] ocfs2: validate external xattr entries when
 reading metadata
To: Cen Zhang <zzzccc427@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260705025311.3429854-1-zzzccc427@gmail.com>
 <20260705025311.3429854-3-zzzccc427@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260705025311.3429854-3-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/5/26 10:53 AM, Cen Zhang wrote:
> ocfs2_validate_xattr_block() checks the xattr block header before the
> block reaches higher-level xattr users, but it does not verify that a
> non-indexed block's xh_count and entry offsets fit inside the block.
> Indexed buckets likewise reach list/get consumers after ECC without an
> entry-bounds check.
> 
> Use the flat xattr entry validator for non-indexed external xattr
> blocks, and use a bucket-specific validator for indexed buckets at
> metadata read time. The bucket validator keeps the entry array bounded
> by the first bucket block while checking name/value offsets against the
> bucket block they target.
> 
> Reject corrupted external xattr metadata before listxattr() or
> getxattr() can walk out-of-range entry arrays or name/value offsets.
> 
> Validation reproduced this kernel report:
> BUG: KASAN: use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
> Read of size 1 at addr ffff88810a654007 by task ocfs2_xattr_lis/630
> Call Trace:
>   dump_stack_lvl+0x66/0xa0
>   print_report+0xce/0x630
>   kasan_report+0xe0/0x110
>   ocfs2_xattr_list_entries+0xd7/0x190
>   ocfs2_listxattr+0x3f6/0x610
>   listxattr+0x90/0xe0
>   path_listxattrat+0xed/0x220
>   do_syscall_64+0x115/0x6a0
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
> Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers of EAs")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index ca76441625db..d23364c30e1a 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -390,6 +390,12 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  	return rc;
>  }
>  
> +static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
> +					     struct ocfs2_xattr_header *xh,
> +					     size_t region_size);
> +static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
> +				       u64 blkno);
> +
>  /* Read the xattr bucket at xb_blkno */
>  static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  				   u64 xb_blkno)
> @@ -408,6 +414,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
>  		if (rc)
>  			mlog_errno(rc);
> +		else
> +			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
>  	}
>  
>  	if (rc)
> @@ -509,6 +517,22 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
>  				   le32_to_cpu(xb->xb_fs_generation));
>  	}
>  
> +	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
> +		size_t region_offset =
> +			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
> +
> +		if (bh->b_size < region_offset)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr block %llu: block size %zu is too small\n",
> +					   (unsigned long long)bh->b_blocknr,
> +					   bh->b_size);
> +
> +		return ocfs2_validate_xattr_entries_flat(sb, bh->b_blocknr,
> +							 &xb->xb_attrs.xb_header,
> +							 bh->b_size -
> +							 region_offset);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1068,6 +1092,79 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
>  	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
>  }
>  
> +static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
> +				       u64 blkno)
> +{
> +	struct super_block *sb = bucket->bu_inode->i_sb;
> +	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
> +	u16 xattr_count = le16_to_cpu(xh->xh_count);
> +	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
> +	size_t entries_limit = sb->s_blocksize;
> +	size_t nv_limit = sb->s_blocksize;
> +	size_t max_entries;
> +	int i;
> +
> +	if (region_size < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr bucket %llu: region size %zu is too small\n",
> +				   (unsigned long long)blkno, region_size);
> +
> +	if (entries_limit < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr bucket %llu: entries limit %zu is too small\n",
> +				   (unsigned long long)blkno,
> +				   entries_limit);
> +
> +	max_entries = (entries_limit - sizeof(*xh)) /
> +		      sizeof(struct ocfs2_xattr_entry);
> +
> +	if (xattr_count > max_entries)
> +		return ocfs2_error(sb,
> +				   "Invalid xattr bucket %llu: entry count %u exceeds maximum %zu\n",
> +				   (unsigned long long)blkno,
> +				   xattr_count, max_entries);
> +
> +	for (i = 0; i < xattr_count; i++) {
> +		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
> +		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
> +		size_t block_off = name_offset >> sb->s_blocksize_bits;
> +		size_t block_offset = name_offset % nv_limit;
> +		size_t value_offset;
> +
> +		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr bucket %llu: entry %d name is out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +
> +		if (xe->xe_name_len > nv_limit - block_offset)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr bucket %llu: entry %d name crosses block boundary\n",
> +					   (unsigned long long)blkno, i);
> +
> +		value_offset = block_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
> +		if (value_offset > nv_limit)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr bucket %llu: entry %d value starts out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +
> +		if (ocfs2_xattr_is_local(xe)) {
> +			if (le64_to_cpu(xe->xe_value_size) >
> +			    nv_limit - value_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +		} else if (sizeof(struct ocfs2_xattr_value_root) >
> +			   nv_limit - value_offset) {
> +			return ocfs2_error(sb,
> +					   "Invalid xattr bucket %llu: entry %d value root is out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
>  					   struct ocfs2_dinode *di,
>  					   struct ocfs2_xattr_header **header)

