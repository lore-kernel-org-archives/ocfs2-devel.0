Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064EB8634F
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761179685; cv=none; b=g5MfElUkJFqgbiGvHmbgKWbcd80POmQopm0gwTbCqNFFwn/7aQKd9ihkha+NJuPOGbiTNDp+03JNr4Be0hprmGJs7gFoavjr3Dqpjq6caadSaYa09gTZjEmOLSnEkwEo9yU8iclLLPZDeBicZVVu7HirDyN79z/UWX9XObYZnhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761179685; c=relaxed/simple;
	bh=VbP8hKIgE+Rh8j5M/iC9r6egtTdfEePGsvnfpyuKSl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JSWHHCK2E9OovkP9pAVTMs6UWwTBj2CCzV5W57XpF70tiATT1jcCDYYwtMumUC5XAcWIqktFzqkdl/qR+5KYh8pKmqvBBA+5nTGK8eI7jvY9NwDHZjjxZz1JyhxxUruIsYVn311poPo1iWzL0FOQ5MUBMfYWxr9ZsBEWEnmkhXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mxM4jHcV; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mxM4jHcV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761179673; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qaRdQ14OHL0WfmsOQPkRYZ8UjJCfwwEcnSEpRGwSVQA=;
	b=mxM4jHcVCsN6+hICE4/GFX3kPk0TKfAiANV2KJTCBuZyvYjJUrPmJzKTJJ2n2rnGWanesfkXCOtlyj+56p+nc0pYKsI0wh9teso2Y0aB6VXUEQeAEtXSvODF9KcdzRWIv6iI0tsO59jKA2gj0Ir8DT2r38lAKqfwu1ldDIBbsRY=
Received: from 30.221.128.75(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WqoRGfY_1761179672 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 08:34:32 +0800
Message-ID: <0573c9f8-5f72-448f-8abc-fb5b67626c9a@linux.alibaba.com>
Date: Thu, 23 Oct 2025 08:34:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFT PATCH] ocfs2: Invalidate inode if i_mode is zero after
 block read
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251022222752.46758-2-eraykrdg1@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251022222752.46758-2-eraykrdg1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/23 06:27, Ahmet Eray Karadag wrote:
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
> Prevent this by adding an explicit check for i_mode == 0 within
> ocfs2_validate_inode_block. If i_mode is zero, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> ---
> [RFC]:
> The current fix handles i_mode=0 corruption detected during inode read
> by returning -EFSCORRUPTED from ocfs2_validate_inode_block, which leads to
> make_bad_inode() being called, preventing the corrupted inode from
> entering the cache. This approach avoids immediately forcing the entire
> filesystem read-only, assuming the corruption might be localized to
> this inode.
> 
> Is this less aggressive error handling strategy appropriate for i_mode=0
> corruption? Or is this condition considered severe enough that we *should*
> explicitly call ocfs2_error() within the validation function to guarantee
> the filesystem is marked read-only immediately upon detection?
> Feedback and testing on the correct severity assessment and error
> handling for this type of corruption would be appreciated.
> ---
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> ---
>  fs/ocfs2/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..d4142ff9ce65 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1456,6 +1456,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (unlikely(le16_to_cpu(di->i_mode) == 0)) {

It seems the buggy image is carefully crafted so that it can pass the
OCFS2_VALID_FL check.
Checking i_mode here looks wried. Could we check i_links_count instead?

Thanks,
Joseph

> +		mlog(ML_ERROR, "Invalid dinode #%llu: i_mode is zero!\n",
> +                           (unsigned long long)bh->b_blocknr);
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */

