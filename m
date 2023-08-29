Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52210F1
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Aug 2023 08:32:36 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vqqcbs2_1693297626;
Received: from 30.221.128.242(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vqqcbs2_1693297626)
          by smtp.aliyun-inc.com;
          Tue, 29 Aug 2023 16:27:07 +0800
Message-ID: <48e57434-abf9-5e1f-c24e-46a0eb7ddc16@linux.alibaba.com>
Date: Tue, 29 Aug 2023 16:27:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] ocfs2: correct range->len in ocfs2_trim_fs()
Content-Language: en-US
To: Yuanheng Zhang <yuanhengzhang1214@gmail.com>, mark@fasheh.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20230828051741.204577-1-yuanhengzhang1214@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230828051741.204577-1-yuanhengzhang1214@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/28/23 1:17 PM, Yuanheng Zhang wrote:
> global bitmap is a cluster allocator,so after we traverse
> the global bitmap and finished the fstrim,the trimmed range
> should be 'trimmed * clustersize'.otherwise,the trimmed range
> printed by 'fstrim -v' is not as expected.
> 
> Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>

Thanks for pointing this out. It looks fine to me.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 51c93929a146..bced551240cf 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7642,7 +7642,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
>  		goto next_group;
>  	}
>  out:
> -	range->len = trimmed * sb->s_blocksize;
> +	range->len = trimmed * osb->s_clustersize;
>  	return ret;
>  }
>  
