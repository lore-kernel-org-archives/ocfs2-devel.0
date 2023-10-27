Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F312168D6
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Oct 2023 09:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vv-c.Z0_1698398805;
Received: from 30.221.128.176(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vv-c.Z0_1698398805)
          by smtp.aliyun-inc.com;
          Fri, 27 Oct 2023 17:26:46 +0800
Message-ID: <1095973e-3577-40bf-23da-725f936a11ad@linux.alibaba.com>
Date: Fri, 27 Oct 2023 17:26:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] ocfs2: Fix a spelling typo in comment
Content-Language: en-US
To: Kunwu Chan <chentao@kylinos.cn>, jlbec@evilplan.org, mark@fasheh.com,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 kunwu.chan@hotmail.com
References: <20231025072906.14285-1-chentao@kylinos.cn>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20231025072906.14285-1-chentao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/23 3:29 PM, Kunwu Chan wrote:
> fix a spelling typo in comment.
> 
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 6cb919f60011..cdb9b9bdea1f 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -345,7 +345,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  				if (new_bh && bh) {
>  					/* If middle bh fails, let previous bh
>  					 * finish its read and then put it to
> -					 * aovoid bh leak
> +					 * avoid bh leak
>  					 */
>  					if (!buffer_jbd(bh))
>  						wait_on_buffer(bh);
