Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00A1657
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Oct 2023 01:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VtyLKrJ_1697073085;
Received: from 30.221.128.69(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VtyLKrJ_1697073085)
          by smtp.aliyun-inc.com;
          Thu, 12 Oct 2023 09:11:26 +0800
Message-ID: <6378684c-08a4-778c-e13b-7162cc26e31d@linux.alibaba.com>
Date: Thu, 12 Oct 2023 09:11:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] ocfs2: fix a typo in a comment
Content-Language: en-US
To: Yuanheng Zhang <yuanhengzhang1214@gmail.com>, mark@fasheh.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20231011163216.29446-1-yuanhengzhang1214@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20231011163216.29446-1-yuanhengzhang1214@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/23 12:32 AM, Yuanheng Zhang wrote:
> Fix spelling typo in comment.
> 
> Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 196638a22b48..6cb919f60011 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -158,7 +158,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
>  			if (new_bh && bh) {
>  				/* If middle bh fails, let previous bh
>  				 * finish its read and then put it to
> -				 * aovoid bh leak
> +				 * avoid bh leak
>  				 */
>  				if (!buffer_jbd(bh))
>  					wait_on_buffer(bh);
