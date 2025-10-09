Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E719E967
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 11:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008342; cv=none; b=BJuLHKc6C8KRQKKb5RlJ99Hk2vurEd6IYVp/lwI5cNiPsw6tPgjn+21Bt0K0cpnR7sBJ73H6ceFVggAe7orrDMCe65cJso4kkQmDPN2Fco4ArXrg2lpU25iaLiYkcWMsbnMUZp9mPYc9mSryaWoqvLDWw3UQekatQJio0CRKV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008342; c=relaxed/simple;
	bh=LcuZym48RCrq3uUgD7v5vgjBGX8/+R1FydsrmRR07Xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWZRT4pn3uz0aSSb9yPmFrdwDPKIYR4UICc9exgxKAwW6xmO/OTw/58Jhwk+IOGmoJszRvAW/m8F3QF4kDQrhgZVcDzIol5xCSSLaVHEEkY3wftLfn8bL9PrArwBuv/HeX+9bGC3NNtU7LWgYdSkm4ybSNQS0ne13reae0Tg8VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W5yNs7MF; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W5yNs7MF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760008337; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1U6+1uCwhGJ8Prq9FHG5UBPXdIcRKmDcWGe83a09gDk=;
	b=W5yNs7MFrAy4Ot5ORzp4o9ykGs3ZZ1xBLoiTR3iiX1FZPKEi+4Q2EWLClIayL4NPMjTshFtem1uZDSbMgfXPjHLzuL3fflFjwxEZOHyDui0b4vMI6VHcnUuDaUuiKIufvBaIHLPMk3oyJrxHNjLVdDKsyI+AU7rgTS2dZIfAONQ=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpmiyAq_1760008335 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 19:12:15 +0800
Message-ID: <aecb2ef1-ea56-42d9-8bee-a2760de66de1@linux.alibaba.com>
Date: Thu, 9 Oct 2025 19:12:15 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: relax BUG() to ocfs2_error() in
 __ocfs2_move_extent()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
References: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
 <20251009102349.181126-1-dmantipov@yandex.ru>
 <20251009102349.181126-2-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251009102349.181126-2-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/10/9 18:23, Dmitry Antipov wrote:
> In '__ocfs2_move_extent()', relax 'BUG()' to 'ocfs2_error()' just
> to avoid crashing the whole kernel due to a filesystem corruption.
> 
> Reported-by: syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=727d161855d11d81e411
> Fixes: 8f603e567aa7 ("Ocfs2/move_extents: move a range of extent.")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/move_extents.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index e038c009cdef..ba4952b41602 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t *handle,
>  
>  	rec = &el->l_recs[index];
>  
> -	BUG_ON(ext_flags != rec->e_flags);
> +	if (ext_flags != rec->e_flags) {
> +		ret = ocfs2_error(inode->i_sb,
> +				  "Inode %llu has corrupted extent %d with flags 0x%x at cpos %u\n",
> +				  (unsigned long long)ino, index, rec->e_flags, cpos);
> +		goto out;
> +	}
> +
>  	/*
>  	 * after moving/defraging to new location, the extent is not going
>  	 * to be refcounted anymore.

