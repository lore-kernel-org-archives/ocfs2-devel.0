Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290A8A933
	for <ocfs2-devel@lists.linux.dev>; Wed, 20 Nov 2024 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732067350; cv=none; b=rolD2o4x4b0tTt7CWsqJlok6izApQ9RFlsih8inWq1rDS9UEw9dMtJV6AD2kUCBmjpJglk7p1r+VPbO+qz9u2ZQ1CbizpQ3oBajTh/btNJsDJVHk0qek0rPkAKrvDm4lo8zzFMrJsQf1wJD3ZOVyCzCoOsfj5KeVIoilEGbYYEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732067350; c=relaxed/simple;
	bh=JGjqoq7putKpKO4oHle35t78CiwTx9TIeAmZM20cr9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=sR7q7QoPl44shwbtH/QW8O/0w2Gr8qEScUJSHsxIT4SXjTtq7DAMbtiYJ/OAB40c+uBTqn/WGNJghTaF+20VzJ6bzvdH5QEzjDWPOitOQixD05IhJ+lDe3yS9eN5ce7nb3lCAX8bOnO1ls6vURjWg41UXX38sIM4i55ZZS9aqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Qzyk2hCb; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Qzyk2hCb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1732067340; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TDgLpNIIqRrgBM1H/50gv0zqqcduw7kzbrJ9htOJVOc=;
	b=Qzyk2hCbBwMCe+4vLerMvCTiVCr7Sgn2AsbF+gEfahydamg0oWCic15AvjjmG+F89FTf8Wa/xBSKPMuc4Aa7XMtGwZjFbsiOJ+XCsQqiAdotRQPYv44G7nwUTyAVTrTSn5X037j3xE9nEoSkf4m08g8x+9i0n4OWMkTpZUykBqg=
Received: from 30.221.128.194(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WJq2fPZ_1732067338 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Nov 2024 09:48:59 +0800
Message-ID: <05c35e8d-4d79-4b65-9bcb-cab70e7d8536@linux.alibaba.com>
Date: Wed, 20 Nov 2024 09:48:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: update seq_file index in ocfs2_dlm_seq_next V2
To: Wengang Wang <wen.gang.wang@oracle.com>, akpm <akpm@linux-foundation.org>
References: <20241119174500.9198-1-wen.gang.wang@oracle.com>
Content-Language: en-US
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241119174500.9198-1-wen.gang.wang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/20/24 1:45 AM, Wengang Wang wrote:
> The following INFO level message was seen:
> 
> seq_file: buggy .next function ocfs2_dlm_seq_next [ocfs2] did not
> update position index
> 
> Fix:
> Update *pos (so m->index) to make seq_read_iter happy though the index its
> self makes no sense to ocfs2_dlm_seq_next.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmglue.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 60df52e4c1f8..764ecbd5ad41 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3110,6 +3110,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  	struct ocfs2_lock_res *iter = v;
>  	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
>  
> +	(*pos)++;
>  	spin_lock(&ocfs2_dlm_tracking_lock);
>  	iter = ocfs2_dlm_next_res(iter, priv);
>  	list_del_init(&dummy->l_debug_list);

