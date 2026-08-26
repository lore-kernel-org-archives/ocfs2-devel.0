Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923CC13D891
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Aug 2026 03:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787716015; cv=none; b=ODt/DIjn6Mp6nd7Od4VE/917fKCc/DuLEWFiSiI4qdSXt9nu9OLREAGpH7QDn5TuENky9oCUipbuKJu70NyyNlW6BBsmq1lLZgQgfz7jVUiHT/1CJGgX94oBi4uQAqFO9aSa5m8rt+f7Tut0dOR2j6a4N+CwoQKmJ2/kPaXYe3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787716015; c=relaxed/simple;
	bh=U6fVyPdmI9cduc6fSCb38oE1bFzkwg4ywh7WZBjYJbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGtOKbVYHJzMBKg55bYkaNlQ00R4gxghYkrO3KI13BNxL7PHBK6lcZv411dkfn0d24BZKH62GSI7UnmlBgJ+coMniLtCT2ihA5ZkmPDcQSifDP0aMKuVc6YKsI0C79NPIyds+yOhzMZN6L0Nzs9lLtxE0g6Sps26bG+SfBbGpbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Wr1WjbR5; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Wr1WjbR5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787716010; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rY2Bpx91xpQYUxfOrCc0HL8Eh/RpC/ZgPl126yb7n8Y=;
	b=Wr1WjbR5n3nWd43eFm3401tWDucCwZWZIrt+qdNSuMVjTw6oKrWd8P3hr65CTng//FtYUlWxUIu0cYWVCHlwrDYXBbQ+jLB4E6B6gZFLtOvF+brmh1sUoJv1vP0lV2ocpD9ruiT5g88NuWmqQFGMRo19NVpaeYkBKzkSlWZekRI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X9fn1iD_1787716008;
Received: from 30.166.0.157(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9fn1iD_1787716008 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Aug 2026 11:46:49 +0800
Message-ID: <6ea12771-a57e-49b0-9679-6a47d9bfd395@linux.alibaba.com>
Date: Wed, 26 Aug 2026 11:46:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: reject inconsistent local xattr entries
To: ZhengYuan Huang <gality369@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org
References: <20260806085012.2650042-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260806085012.2650042-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/6/26 4:50 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt OCFS2 xattr entry can set OCFS2_XATTR_ENTRY_LOCAL while
> keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE. When that
> entry reaches namevalue_size_xe(), the filesystem hits its BUG_ON:
> 
> kernel BUG at fs/ocfs2/xattr.c:231!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:namevalue_size_xe fs/ocfs2/xattr.c:231 [inline]
> RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2e4/0x330 fs/ocfs2/xattr.c:1638
> Call Trace:
>  ocfs2_xa_wipe_namevalue fs/ocfs2/xattr.c:1470 [inline]
>  ocfs2_xa_remove_entry+0xae/0x1d0 fs/ocfs2/xattr.c:1941
>  ocfs2_xa_remove fs/ocfs2/xattr.c:2043 [inline]
>  ocfs2_xa_set+0x11a8/0x30a0 fs/ocfs2/xattr.c:2247
>  ocfs2_xattr_ibody_set+0x302/0xc50 fs/ocfs2/xattr.c:2795
>  __ocfs2_xattr_set_handle+0x7e6/0xdb0 fs/ocfs2/xattr.c:3416
>  ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
>  ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
>  __vfs_removexattr+0x14d/0x1d0 fs/xattr.c:518
>  cap_inode_killpriv+0x29/0x50 security/commoncap.c:355
>  security_inode_killpriv+0x105/0x220 security/security.c:2724
>  setattr_prepare+0x147/0x8a0 fs/attr.c:219
>  ocfs2_setattr+0x504/0x1fd0 fs/ocfs2/file.c:1148
>  notify_change+0x4b5/0x1030 fs/attr.c:546
>  do_truncate+0x1d2/0x230 fs/open.c:68
>  handle_truncate fs/namei.c:3596 [inline]
>  do_open fs/namei.c:3979 [inline]
>  path_openat+0x260f/0x2ce0 fs/namei.c:4134
>  do_filp_open+0x1f6/0x430 fs/namei.c:4161
>  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
>  ...
> 
> [CAUSE]
> namevalue_size_xe() assumes that local entries contain an inline value
> no larger than OCFS2_XATTR_INLINE_SIZE. Existing xattr metadata
> validation only checks whether the value fits the storage region, and
> cached entries can reach lookup and bucket maintenance paths without a
> semantic check. A corrupt entry can therefore be passed to
> namevalue_size_xe().
> 
> [FIX]
> Validate the local/value-size invariant in the existing flat and bucket
> metadata validators and before accepting matched entries or traversing
> bucket entries in paths that call namevalue_size_xe(). Return an OCFS2
> corruption error instead of firing the assertion.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v2:
> - Rebase onto the ACL lock-order fix in linux-next.
> - Reuse the existing xattr metadata validators.
> - Keep validation in cached lookup and bucket maintenance paths.
> ---
>  fs/ocfs2/xattr.c | 53 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..e955126e4d7d 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -237,6 +237,21 @@ static int namevalue_size_xe(struct ocfs2_xattr_entry *xe)
>  	return namevalue_size(xe->xe_name_len, value_len);
>  }
>  
> +static int ocfs2_validate_xattr_entry(struct super_block *sb, u64 blkno,
> +				      struct ocfs2_xattr_entry *xe)
> +{
> +	u64 value_len = le64_to_cpu(xe->xe_value_size);
> +
> +	if (value_len > OCFS2_XATTR_INLINE_SIZE &&
> +	    ocfs2_xattr_is_local(xe))
> +		return ocfs2_error(sb,
> +				   "Invalid local xattr in block %llu: value size %llu\n",
> +				   (unsigned long long)blkno,
> +				   (unsigned long long)value_len);
> +
> +	return 0;
> +}
> +
>  
>  static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
>  					     struct ocfs2_xattr_header *xh,
> @@ -992,7 +1007,7 @@ static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
>  	size_t entries_limit = region_size;
>  	size_t nv_limit = region_size;
>  	size_t max_entries;
> -	int i;
> +	int i, ret;
>  
>  	if (region_size < sizeof(*xh))
>  		return ocfs2_error(sb,
> @@ -1012,6 +1027,11 @@ static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
>  		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
>  		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
>  		size_t value_offset;
> +		u64 value_len = le64_to_cpu(xe->xe_value_size);
> +
> +		ret = ocfs2_validate_xattr_entry(sb, blkno, xe);
> +		if (ret)
> +			return ret;
>  
>  		if (name_offset > nv_limit ||
>  		    xe->xe_name_len > nv_limit - name_offset)
> @@ -1026,8 +1046,7 @@ static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
>  					   (unsigned long long)blkno, i);
>  
>  		if (ocfs2_xattr_is_local(xe)) {
> -			if (le64_to_cpu(xe->xe_value_size) >
> -			    nv_limit - value_offset)
> +			if (value_len > nv_limit - value_offset)
>  				return ocfs2_error(sb,
>  						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
>  						   (unsigned long long)blkno,
> @@ -1112,7 +1131,7 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  	size_t entries_limit = sb->s_blocksize;
>  	size_t nv_limit = sb->s_blocksize;
>  	size_t max_entries;
> -	int i;
> +	int i, ret;
>  
>  	if (region_size < sizeof(*xh))
>  		return ocfs2_error(sb,
> @@ -1140,6 +1159,11 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  		size_t block_off = name_offset >> sb->s_blocksize_bits;
>  		size_t block_offset = name_offset % nv_limit;
>  		size_t value_offset;
> +		u64 value_len = le64_to_cpu(xe->xe_value_size);
> +
> +		ret = ocfs2_validate_xattr_entry(sb, blkno, xe);
> +		if (ret)
> +			return ret;
>  
>  		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
>  			return ocfs2_error(sb,
> @@ -1158,8 +1182,7 @@ static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
>  					   (unsigned long long)blkno, i);
>  
>  		if (ocfs2_xattr_is_local(xe)) {
> -			if (le64_to_cpu(xe->xe_value_size) >
> -			    nv_limit - value_offset)
> +			if (value_len > nv_limit - value_offset)
>  				return ocfs2_error(sb,
>  						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
>  						   (unsigned long long)blkno,
> @@ -1307,7 +1330,7 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  {
>  	struct ocfs2_xattr_entry *entry;
>  	size_t name_len;
> -	int i, name_offset, cmp = 1;
> +	int i, name_offset, cmp = 1, ret;
>  
>  	if (name == NULL)
>  		return -EINVAL;
> @@ -1330,6 +1353,12 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  				return -EFSCORRUPTED;
>  			}
>  			cmp = memcmp(name, (xs->base + name_offset), name_len);
> +			if (!cmp) {
> +				ret = ocfs2_validate_xattr_entry(inode->i_sb,
> +								 OCFS2_I(inode)->ip_blkno, entry);
> +				if (ret)
> +					return ret;
> +			}
>  		}
>  		if (cmp == 0)
>  			break;
> @@ -4041,6 +4070,10 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
>  
>  		xe_name = bucket_block(bucket, block_off) + new_offset;
>  		if (!memcmp(name, xe_name, name_len)) {
> +			ret = ocfs2_validate_xattr_entry(inode->i_sb,
> +							 OCFS2_I(inode)->ip_blkno, xe);
> +			if (ret)
> +				break;
>  			*xe_index = i;
>  			*found = 1;
>  			ret = 0;
> @@ -4681,6 +4714,9 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>  	xe = xh->xh_entries;
>  	end = OCFS2_XATTR_BUCKET_SIZE;
>  	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
> +		ret = ocfs2_validate_xattr_entry(inode->i_sb, blkno, xe);
> +		if (ret)
> +			goto out;
>  		offset = le16_to_cpu(xe->xe_name_offset);
>  		len = namevalue_size_xe(xe);
>  
> @@ -4963,6 +4999,9 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
>  	name_value_len = 0;
>  	for (i = 0; i < start; i++) {
>  		xe = &xh->xh_entries[i];
> +		ret = ocfs2_validate_xattr_entry(inode->i_sb, blk, xe);
> +		if (ret)
> +			goto out;
>  		name_value_len += namevalue_size_xe(xe);
>  		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
>  			name_offset = le16_to_cpu(xe->xe_name_offset);

