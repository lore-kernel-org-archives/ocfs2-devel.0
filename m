Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C49538C
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Oct 2023 01:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VuS1j91_1697678536;
Received: from 30.221.128.175(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0VuS1j91_1697678536)
          by smtp.aliyun-inc.com;
          Thu, 19 Oct 2023 09:22:18 +0800
Message-ID: <7a8b2331-a252-58ef-6553-ceb73a9a63c9@linux.alibaba.com>
Date: Thu, 19 Oct 2023 09:22:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] ocfs2: replace BUG_ON() at ocfs2_num_free_extents() with
 ocfs2_error()
Content-Language: en-US
To: Jia Rui <jindui71@gmail.com>, mark@fasheh.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20231018191811.412458-1-jindui71@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20231018191811.412458-1-jindui71@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/19/23 3:18 AM, Jia Rui wrote:
> The BUG_ON() at ocfs2_num_free_extents() handles the error that
> l_tree_deepth of leaf extent block just read form disk is invalid.
> This error is mostly caused by file system metadata corruption on
> the disk. There is no need to call BUG_ON() to handle such errors.
> We can return error code, since the caller can deal with errors
> from ocfs2_num_free_extents(). Also, we should make the file
> system read-only to avoid the damage from expanding.
> 
> Therefore, BUG_ON() is removed and ocfs2_error() is called instead.
> 
> Signed-off-by: Jia Rui <jindui71@gmail.com>

Looks reasonable.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/alloc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index aef58f1395c8..d6bcf00f6843 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -967,7 +967,14 @@ int ocfs2_num_free_extents(struct ocfs2_extent_tree *et)
>  		el = &eb->h_list;
>  	}
>  
> -	BUG_ON(el->l_tree_depth != 0);
> +	if (el->l_tree_depth != 0) {
> +		retval = ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
> +				"Owner %llu has leaf extent block %llu with an invalid l_tree_depth of %u\n",
> +				(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
> +				(unsigned long long)last_eb_blk,
> +				le16_to_cpu(el->l_tree_depth));
> +		goto bail;
> +	}
>  
>  	retval = le16_to_cpu(el->l_count) - le16_to_cpu(el->l_next_free_rec);
>  bail:
