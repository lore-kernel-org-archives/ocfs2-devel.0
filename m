Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12067D3F1
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jul 2024 08:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721379165; cv=none; b=aVOoKttf11YkJv5e6a396nuxcFsEK7s1yMV9gD+dgoJF8xHmvRqMBCAq2+H4sLZVzdbf7ossISjnzXPGHqpV/vqcUrUtDnnCpNIvcJP2ZtBrt09hMh1y0ZVhjPnfpzcbfw40APPdVI/7lSfXRLIpCPe/2gf0i/+v3UqoDsWWlUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721379165; c=relaxed/simple;
	bh=MoobyJUWw8sFa4NX5Cws5f5EPUVNOo+oGlQLJGy+u7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UhDclWgaNLFXyp1j6KxtyWRrRlqFnFI6cXwj9tL7GS98j2A82ri1+eMP0WobHgHWQLdByshS2s3/AmJQCTJ+zloo25ieqZuAgDyGENXXjVUvC4PyLveB0quDq+VHw2KDYXPevR2ZUWQUNhR3zpsxX0YWreyTb44up95P9xh9LFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=x6bfI6iF; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="x6bfI6iF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721379154; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dq7sMaXASOwwR44LOl7TKiHxDTxobKClMbIFVr839T0=;
	b=x6bfI6iFUrnimQGMc6OzxEw1VjtsFdEUB5rhRngF3vui5/rCjHoqtMnKi2dwVM3IhANwxY7RgIXONddLeIMu1Zx4wPg0CQ+1ijB34KepazehfuHsYnCfYDeC3JEEp/H5TtiErypTcnxty/mbR1tKEdH27AYleDsaaJAvnw5DnD8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0WArHx1l_1721379153;
Received: from 30.221.128.111(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WArHx1l_1721379153)
          by smtp.aliyun-inc.com;
          Fri, 19 Jul 2024 16:52:34 +0800
Message-ID: <dcede907-e830-4fe2-89ac-ee0d1cea7940@linux.alibaba.com>
Date: Fri, 19 Jul 2024 16:52:33 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: Heming Zhao <heming.zhao@suse.com>, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240718021842.7595-1-heming.zhao@suse.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240718021842.7595-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/18/24 10:18 AM, Heming Zhao wrote:
> This bug has existed since the initial OCFS2 code. The code logic
> in ocfs2_sync_local_to_main() is wrong, as it ignores the last
> contiguous free bits, which causes an OCFS2 volume to lose the
> LA window size space on each umount command.
> 
It only ignore the last few clusters, but not the whole la window.

Thanks,
Joseph

> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
> v1 -> v2: adjust 'if' condition to make the code logic more concise
> ---
>  fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..8ac42ea81a17 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>  		start = bit_off + 1;
>  	}
>  
> +	/* clear the contiguous bits until the end boundary */
> +	if (count) {
> +		blkno = la_start_blk +
> +			ocfs2_clusters_to_blocks(osb->sb,
> +					start - count);
> +
> +		trace_ocfs2_sync_local_to_main_free(
> +				count, start - count,
> +				(unsigned long long)la_start_blk,
> +				(unsigned long long)blkno);
> +
> +		status = ocfs2_release_clusters(handle,
> +				main_bm_inode,
> +				main_bm_bh, blkno,
> +				count);
> +		if (status < 0)
> +			mlog_errno(status);
> +	}
> +
>  bail:
>  	if (status)
>  		mlog_errno(status);
