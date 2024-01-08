Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB510EB
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Jan 2024 02:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W-5ZuTg_1704680512;
Received: from 30.221.64.204(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W-5ZuTg_1704680512)
          by smtp.aliyun-inc.com;
          Mon, 08 Jan 2024 10:21:55 +0800
Message-ID: <1df6c4b6-e9b2-45f3-8b78-8fe980d8e804@linux.alibaba.com>
Date: Mon, 8 Jan 2024 10:21:52 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: Spelling fix
Content-Language: en-US
To: Yongzhen Zhang <zhangyongzhen@kylinos.cn>,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev
References: <64d54843-4e25-4777-b324-dff105da705b@linux.alibaba.com>
 <20240108015604.38377-1-zhangyongzhen@kylinos.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240108015604.38377-1-zhangyongzhen@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/24 9:56 AM, Yongzhen Zhang wrote:
> Modify reques to request in the comment
> 
> Signed-off-by: Yongzhen Zhang <zhangyongzhen@kylinos.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/dlmglue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 64a6ef638495..cb40cafbc062 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1615,7 +1615,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>  unlock:
>  	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
>  
> -	/* ocfs2_unblock_lock reques on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
> +	/* ocfs2_unblock_lock request on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
>  	kick_dc = (lockres->l_flags & OCFS2_LOCK_BLOCKED);
>  
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
