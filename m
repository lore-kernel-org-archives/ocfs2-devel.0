Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B32681E
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 00:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198931; cv=none; b=aiZlCFmw9AMWNcSrhALB4In1PZRd1eTzagb6XXsKPJ75WfKQrXmY76cBcofe44QgnE2FoYbEDh//OpCNptyxoIo62WbGdlPj2kU+2OxVDi7+kuayE9xBkpYmgQq2iX31dkH5TmsqXG39juNFfdKoQ5upCTYqTguA/tBWgejmJyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198931; c=relaxed/simple;
	bh=p3dA9/En9kfVb7bw9vF09rEAf/8yLOR+1r+RhSE3TTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHadagHpMj7UF137p/nNbiuxYPs5oFMIYDUvZia/iEV3ZEF9JHDTeGNKCiSrsorXTUnUWLURWlfZ6sW27hQZEWmYrTmTxIIDm7mZfzxMZLJjJ5/H6zfBS8LBFD1x5kV/ToOCjRr7VGtl5kLOCJxTqUS14mfe7Ga8fAB1X7XbGmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qnPTU+EF; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qnPTU+EF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724198925; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GcAXD9iBBfjMXq2km1UKv5nnHqGtH92Htt5r1IL/qZ8=;
	b=qnPTU+EFn1vBJ1YBAuJjK546eO4Kd6wVz+NM8tjRdYEN+ICI12ywWqyY04SrcW1DMyK1c/2GsHKe/vsNQJZVSVdaCo4tm16xOSVHqxAQd9+yHThuiInXYU8yBYQEy+bwTj4cndm6I0zE5y/YOYjgNqlz9jAmjIwIOLPppiW2C38=
Received: from 30.171.230.57(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDJpstE_1724198924)
          by smtp.aliyun-inc.com;
          Wed, 21 Aug 2024 08:08:45 +0800
Message-ID: <7da687ce-ffb7-44e3-bddc-d5c2f4f48c95@linux.alibaba.com>
Date: Wed, 21 Aug 2024 08:08:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
To: Lizhi Xu <lizhi.xu@windriver.com>, heming.zhao@suse.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
 <20240820094512.2228159-1-lizhi.xu@windriver.com>
 <20240820094512.2228159-2-lizhi.xu@windriver.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240820094512.2228159-2-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 5:45 PM, Lizhi Xu wrote:
> In the for-loop after the 'read_failure' label, the condition
> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
> When this contidion is true, this for-loop will call ocfs2_set_buffer
> _uptodate(ci, bh), which then triggers a NULL pointer access error.
> 

Or it may simplified as the following:

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

> Changes from V2:
> * Make the code more concise
> 

This is not the right place for changelog.

Thanks,
Joseph

> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index e62c7e1de4eb..8f714406528d 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  		/* Always set the buffer in the cache, even if it was
>  		 * a forced read, or read-ahead which hasn't yet
>  		 * completed. */
> -		ocfs2_set_buffer_uptodate(ci, bh);
> +		if (bh)
> +			ocfs2_set_buffer_uptodate(ci, bh);
>  	}
>  	ocfs2_metadata_cache_io_unlock(ci);
>  
