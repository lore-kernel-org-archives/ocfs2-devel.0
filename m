Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EA61FA859
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 May 2026 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780232009; cv=none; b=AE+ngox79xaMlj65OHwUXEozAzkvsKMX3duIT+Bn01/uMH1MBc7BDbynGjdLRmN52XsH7DdpvOpg8+f7N5ozj64xRSfFZxKqRglXdaNxw/SUuk/yzcmSSqyQiLg1jEKjjPIlMA6lzgBJp2QZ6JrXXV/VEqeMkppEou8nEE+fWiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780232009; c=relaxed/simple;
	bh=S70Aki8YnMUrWhzpACtDSNANkNVHB3ygWb7BZt4WM/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=umFPYlMA2nVwVOFO4Zk8mbTtpKU+DASVZ5MXjhX1IX6wwZPhhvv0NBTwyG1QfTv72aIADkYqpRAGdDoyVATOZ42BdHS7xmDuwj0hvN09ZAfgffyMZoh6ZypQxgiKNZHNHHmqwFpX2+TNUmRJ9EdoqN0E1oC1e1SvlM3ovqqzBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rl4fiDSt; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rl4fiDSt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780231999; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WbHXSlwpuPTBS5NTavTQFObotEBS3tbA+YF/2zELX4M=;
	b=rl4fiDStjr2vpIPR232QZIXDeWXIelhguJtYQYHzlkhWcNNfU+Rg0B/opWj7HkHcvjUYnhWtaUkW5JY2vzIwoGV1LU0OHgtDuO5afw0vbwwmMp3bvfpYhfe3l9VMAvHPN5UL5gBSy558gwIuyEYRUE3NpNEADKWoHCwUmNTzKRw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X3tm2q9_1780231997;
Received: from 30.134.110.188(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3tm2q9_1780231997 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 31 May 2026 20:53:18 +0800
Message-ID: <b167252d-888f-48a1-aa88-d8e3001a9742@linux.alibaba.com>
Date: Sun, 31 May 2026 20:53:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: validate fast symlink target during inode read
To: Zhang Cen <rollkingzzc@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 zerocling0077@gmail.com, 2045gemini@gmail.com, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260528151230.361127-1-rollkingzzc@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260528151230.361127-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/28/26 11:12 PM, Zhang Cen wrote:
> ocfs2_validate_inode_block() already rejects several inconsistent
> self-contained dinodes before they are exposed to the rest of the
> filesystem. Fast symlinks need the same treatment.
> 
> A zero-cluster symlink is treated as a fast symlink and later read
> through page_get_link() and ocfs2_fast_symlink_read_folio(). That path
> uses strnlen() on the inline payload and then copies len + 1 bytes into
> the folio. If a corrupt dinode stores an i_size that does not fit the
> inline area or omits the terminating NUL at i_size, that copy reads past
> the end of the inode block buffer.
> 
> Reject zero-cluster symlink dinodes whose i_size exceeds the inline
> fast-symlink capacity or whose inline payload is not NUL-terminated
> exactly at i_size when the inode block is validated. This keeps
> malformed fast symlinks from reaching the read path.
> 
> Validation reproduced this kernel report:
> KASAN use-after-free in ocfs2_fast_symlink_read_folio+0x12c/0x1f0
> RIP: 0033:0x7f5c6d859aa7
> Read of size 3905
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xce/0x630 (?:?)
>   ocfs2_fast_symlink_read_folio+0x12c/0x1f0 (fs/ocfs2/inode.c:?)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x19f/0x330 (?:?)
>   kasan_report+0xe0/0x110 (?:?)
>   kasan_check_range+0x105/0x1b0 (?:?)
>   __asan_memcpy+0x23/0x60 (?:?)
>   filemap_read_folio+0x27/0xe0 (?:?)
>   filemap_read_folio+0x35/0xe0 (?:?)
>   do_read_cache_folio+0x138/0x230 (?:?)
>   __page_get_link+0x26/0x110 (?:?)
>   page_get_link+0x2e/0x70 (?:?)
>   vfs_readlink+0x15e/0x250 (?:?)
>   touch_atime+0x4d/0x370 (?:?)
>   do_readlinkat+0x186/0x200 (?:?)
>   do_user_addr_fault+0x65a/0x890 (?:?)
>   __x64_sys_readlink+0x46/0x60 (?:?)
>   do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
> 
> Fixes: ea022dfb3c2a ("ocfs: simplify symlink handling")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index a510a0eb1adc..e54a320f35f1 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1525,6 +1525,29 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		}
>  	}
>  
> +	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
> +	    !le32_to_cpu(di->i_clusters)) {
> +		int max_inline = ocfs2_fast_symlink_chars(sb);
> +		u64 i_size = le64_to_cpu(di->i_size);
> +
> +		if (i_size >= max_inline) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)i_size,
> +					 max_inline - 1);
> +			goto bail;
> +		}
> +
> +		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 (unsigned long long)i_size);
> +			goto bail;
> +		}
> +	}
> +
>  	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
>  		struct ocfs2_chain_list *cl = &di->id2.i_chain;
>  		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
> @@ -1812,4 +1835,3 @@ const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
>  	.co_io_lock		= ocfs2_inode_cache_io_lock,
>  	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
>  };
> -

