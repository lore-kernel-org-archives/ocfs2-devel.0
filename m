Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA545448D06
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931048; cv=none; b=BIAcD5XVKD0bORvRoTUb0dJYYbMzuX4/vI69toFEGLDLJCCfJ6RSgIVPHGsVG+TWBjh3dgglyfueEypzgintB6gHaSE2e26tt6AtN6P6TImJKd/aRrLIgEI09jCGwVR+CsqiNETuoN6MPbo73EYK3dQY0CFvwJb4pYckfKA44cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931048; c=relaxed/simple;
	bh=4btE81SFB3B68clJllL2qnGYI9lNf8ilu8J16k30se0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPS4BmWwWGv9nSTr/3tktS2zYtSys9WBVoLiV9Jzy2SBA7w29q8/SQsGIiqC3kOtRWqwidpIY3IgY5o6f2Juhudk9uVXuRn6/pLXzGu0EX282b6xKLcENVYHQu0KzmUkUjBp3JtDHbY3I7wnCeP+SYLhfoBUuu9KVeD+bwQZDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jlAqhzHY; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jlAqhzHY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785931037; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rSpzLh9oL6ZAuX/k/uebDpikNR0tCXbM0Qe+6i6sJlc=;
	b=jlAqhzHYShbQVCTWwvo9V1PoxAl33cZho/fv7roR6jb4Evw+9XyhtMhpd+baFrlrqXJF6L0u8ZSVATWcdNB3JZITnaFKiIyPtN3aFbaI2bUTvxK3Me27JNxUQACbL9EZkMqMVr+m2S5cVAAzZKEgG55eY4x6/dsrmojThwT2Lvg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X8RD6oh_1785931035;
Received: from 30.166.0.128(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8RD6oh_1785931035 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 05 Aug 2026 19:57:16 +0800
Message-ID: <f23fdf09-6e6a-4291-a47d-fb86705fd206@linux.alibaba.com>
Date: Wed, 5 Aug 2026 19:57:13 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: reject inconsistent local xattr entries
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com
References: <20260804112806.1219362-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260804112806.1219362-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This conflicts with the following commit in linux-next:
ocfs2: fix circular locking dependency in ocfs2_init_acl()

Thanks,
Joseph

On 8/4/26 7:28 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt OCFS2 xattr entry can set OCFS2_XATTR_ENTRY_LOCAL while
> keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE.Once
> that entry reaches namevalue_size_xe(), the filesystem trips over:
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
> namevalue_size_xe() assumes on-disk xattr entries keep the local flag
> and value size consistent, but OCFS2 does not reject an entry that
> claims local storage for a value larger than the inline limit before
> handing that entry to namevalue_size_xe().
> 
> The exact-match lookup path can return such an entry through xs->here,
> and bucket defragmentation and splitting can also walk the corrupt entry
> directly while reorganizing metadata.
> 
> [FIX]
> Add a small validator for the local/value_size invariant and call it in
> the paths that feed disk entries to namevalue_size_xe(): exact-match
> lookup, bucket lookup results, bucket defragmentation, and bucket
> splitting.
> 
> Corrupt metadata is now reported with ocfs2_error() and -EFSCORRUPTED
> instead of crashing the kernel with BUG_ON().
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> No Fixes tag was added because this is more like a defensive check
> that is long overdue, not a regression that can be clearly attributed
> to a specific introduction commit.
> ---
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 86cfd4c2adf9..63b1e55b242f 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -237,6 +237,23 @@ static int namevalue_size_xe(struct ocfs2_xattr_entry *xe)
>  	return namevalue_size(xe->xe_name_len, value_len);
>  }
>  
> +static int ocfs2_validate_xattr_entry(struct inode *inode,
> +				      struct ocfs2_xattr_entry *xe)
> +{
> +	u64 value_len = le64_to_cpu(xe->xe_value_size);
> +
> +	if (value_len > OCFS2_XATTR_INLINE_SIZE &&
> +	    ocfs2_xattr_is_local(xe)) {
> +		ocfs2_error(inode->i_sb,
> +			    "Inode %llu has corrupt xattr entry: local value_size %llu\n",
> +			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +			    value_len);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
> +}
> +
>  
>  static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
>  					     struct ocfs2_xattr_header *xh,
> @@ -1099,6 +1116,7 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  	struct ocfs2_xattr_entry *entry;
>  	size_t name_len;
>  	int i, name_offset, cmp = 1;
> +	int ret;
>  
>  	if (name == NULL)
>  		return -EINVAL;
> @@ -1121,6 +1139,11 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  				return -EFSCORRUPTED;
>  			}
>  			cmp = memcmp(name, (xs->base + name_offset), name_len);
> +			if (!cmp) {
> +				ret = ocfs2_validate_xattr_entry(inode, entry);
> +				if (ret)
> +					return ret;
> +			}
>  		}
>  		if (cmp == 0)
>  			break;
> @@ -3823,6 +3846,9 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
>  
>  		xe_name = bucket_block(bucket, block_off) + new_offset;
>  		if (!memcmp(name, xe_name, name_len)) {
> +			ret = ocfs2_validate_xattr_entry(inode, xe);
> +			if (ret)
> +				break;
>  			*xe_index = i;
>  			*found = 1;
>  			ret = 0;
> @@ -4463,6 +4489,10 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
>  	xe = xh->xh_entries;
>  	end = OCFS2_XATTR_BUCKET_SIZE;
>  	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
> +		ret = ocfs2_validate_xattr_entry(inode, xe);
> +		if (ret)
> +			goto out;
> +
>  		offset = le16_to_cpu(xe->xe_name_offset);
>  		len = namevalue_size_xe(xe);
>  
> @@ -4745,6 +4775,10 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
>  	name_value_len = 0;
>  	for (i = 0; i < start; i++) {
>  		xe = &xh->xh_entries[i];
> +		ret = ocfs2_validate_xattr_entry(inode, xe);
> +		if (ret)
> +			goto out;
> +
>  		name_value_len += namevalue_size_xe(xe);
>  		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
>  			name_offset = le16_to_cpu(xe->xe_name_offset);

