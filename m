Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94DF3D8906
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jul 2026 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783319067; cv=none; b=AjJ//tj5u0qQS4ODiYnQneLVut2W2FsiJeTOFEa3bdGsVbZOZt9+ZS5LOy13NYlH8WXtD6z4MeEtNITpY90lLE13zZoomxrZumzDIRI6y5xECw9qM+kpbmopYfXrjO7X25E4RQJ7re5P4H2KA/X10bztdb6IBSvria+tg6JxHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783319067; c=relaxed/simple;
	bh=+tUwwTSvAwFIzbjIDTIZX4XID2dXytRAR66GwYQNG2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L3d+329HT/4YvLIIORYZFeNtwBZv/+KqF68TCy4QGB+xKq5tudRQgEEb1+gebOgFvNASIfYtCXU93ys+gQ61frRHdyv0fh+6+Ipy+0LG7FmP6CRC6eX4VD2NwvVVhiosGTahgyAUBSEBb1xTPpB1Yl49al3ocL2uvPGQ7yydjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=P7fEe1Hw; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="P7fEe1Hw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783319050; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0jg8DdlAV5i2s1vaT9c/qJHdH8r3UpybYisvyTkICX0=;
	b=P7fEe1HwhWOSG+fcwV0ZifCb9rHD8aiy4Na0iFKSm3UN3zEppU5epjUHd7DEEQALjNr/Tb8I7vl1o1eVvOwXOOun3ftE6isu5ul6UciaISQRXk3HJa66gezbxrnSB3kEuVU/OAAVXOT6nwmrTkiMgvwa+yHmBkBrNbTZR4Hdeqw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X6QMM20_1783319048;
Received: from 30.221.144.246(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X6QMM20_1783319048 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 14:24:09 +0800
Message-ID: <e6a7d9d2-1b2f-45fe-8f1c-55519a37cfbf@linux.alibaba.com>
Date: Mon, 6 Jul 2026 14:24:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] ocfs2: validate inline xattrs during inode block
 validation
To: Cen Zhang <zzzccc427@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260705025311.3429854-1-zzzccc427@gmail.com>
 <20260705025311.3429854-2-zzzccc427@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260705025311.3429854-2-zzzccc427@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/5/26 10:53 AM, Cen Zhang wrote:
> ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
> metadata from it, but inline xattr metadata is still checked only in
> operation-specific consumers. The existing ibody lookup helper validates
> inline header placement and entry count, but inode block validation does
> not reject entry name/value bounds.
> 
> Add a flat xattr entry validator and call it from inode block validation
> for inline xattrs. Keep the operation paths on their existing
> header/count lookup checks; the full entry bounds check now runs when
> the inode block is validated at read time.
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

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c |   4 ++
>  fs/ocfs2/xattr.c | 118 +++++++++++++++++++++++++++++++++++++++++------
>  fs/ocfs2/xattr.h |   2 +
>  3 files changed, 111 insertions(+), 13 deletions(-)
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
> index fcddd3c13acd..ca76441625db 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -950,41 +950,133 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
>  	return result;
>  }
>  
> -static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
> -					   struct ocfs2_dinode *di,
> -					   struct ocfs2_xattr_header **header)
> +static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
> +					     struct ocfs2_xattr_header *xh,
> +					     size_t region_size)
> +{
> +	u16 xattr_count = le16_to_cpu(xh->xh_count);
> +	size_t entries_limit = region_size;
> +	size_t nv_limit = region_size;
> +	size_t max_entries;
> +	int i;
> +
> +	if (region_size < sizeof(*xh))
> +		return ocfs2_error(sb,
> +				   "Invalid xattr in block %llu: region size %zu is too small\n",
> +				   (unsigned long long)blkno, region_size);
> +
> +	max_entries = (entries_limit - sizeof(*xh)) /
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
> +
> +		if (name_offset > nv_limit ||
> +		    xe->xe_name_len > nv_limit - name_offset)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +
> +		value_offset = name_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
> +		if (value_offset > nv_limit)
> +			return ocfs2_error(sb,
> +					   "Invalid xattr in block %llu: entry %d value starts out of bounds\n",
> +					   (unsigned long long)blkno, i);
> +
> +		if (ocfs2_xattr_is_local(xe)) {
> +			if (le64_to_cpu(xe->xe_value_size) >
> +			    nv_limit - value_offset)
> +				return ocfs2_error(sb,
> +						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
> +						   (unsigned long long)blkno,
> +						   i);
> +		} else if (sizeof(struct ocfs2_xattr_value_root) >
> +			   nv_limit - value_offset) {
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
> +	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
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

