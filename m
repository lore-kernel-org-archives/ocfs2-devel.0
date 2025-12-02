Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9A22A1D5
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643469; cv=none; b=ElR24V+nKGHMYuWXngqHY42sgEWcNS7Z7jDHk4MpSfVjq3MgpOt7IfJpk+E46CURxAlsUnUxQC8joBMd+HEx/uaB1FzBd9FrVoHmGa00oykCgP9wbx+QbUOJodkCduFnRGhKAlEo49o2wITzYxxMqFja60Wq8S+bW7ZTYz2ixJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643469; c=relaxed/simple;
	bh=Y+lDkBQKhf8AcqA6IB6fRXOkcTDphlTFH3shFbcemOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Re1KgYxaPCI0Aw/bOWC0YOnawFhjGs54TYB319kaQQlK4y8t6eXtZmJflPaOu7YFh8lfPcfZKRcy8uwNOy4tOoC5vr/GvKV8JHTzWJYEOyxBZHJzzJX0BWgSggCVWkhm7Qsd6HECBgH4+rA7l/JaBYh21pj3hstaYJjM9x0+X4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m1dqznwu; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m1dqznwu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764643463; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tm/FdjxSd9aF1a1xENueqL6aA+v+Zrvjbdq0I6wLjzA=;
	b=m1dqznwuAj/qeQh+e3NLM4Y9f7tUUBL41HBpy2a5eU/5yBSKdIC0j34zWxvrQGIenq5I7mE6asms1argf2fp1txhaqSAET/ldgMg3U24VRbv2pjF2NFE3cJQ6pEhylsPX24J82GU8uux87FCl7VHNUYmw66YpYOCzt3KOcsN+Uc=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtuWmZc_1764643461 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 10:44:22 +0800
Message-ID: <5d9b1739-2337-41ad-8c92-38828c8f5c32@linux.alibaba.com>
Date: Tue, 2 Dec 2025 10:44:21 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ocfs2: Invalidate inode if i_mode is zero after block
 read
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251202003209.188987-2-eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251202003209.188987-2-eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 08:32, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
> v2:
>  - Only checking either i_links_count == 0 or i_mode == 0
>  - Not performing le16_to_cpu() anymore
>  - Tested with ocfs2-test
> ---
> v3:
>  - Add checking both high and low bits of i_links_count
> ---
> v4:
>  - Reading i_links_count hi and low bits without helper function
>   to save few cpu cycles
> ---
>  fs/ocfs2/inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..34c2882273ae 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1455,7 +1455,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		     (unsigned long long)bh->b_blocknr);
>  		goto bail;
>  	}
> -
> +	if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode) {

"(di->i_links_count | di->i_links_count_hi)" looks meaningless.
So if we don't want to introduce the endian coversion here, how about:

if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
	...
}

Heming, what's your opinion?

> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink=0 or mode=0,) detected!\n",

Better to log the actual i_nlink/i_mode. e.g.

"corrupted i_nlink %u or i_mode %u\n"
...

Joseph

> +		        (unsigned long long)bh->b_blocknr);
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */

