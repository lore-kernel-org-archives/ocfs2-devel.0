Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F7A4E
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Aug 2023 01:38:44 +0000 (UTC)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vp-Iz30_1691112186;
Received: from 30.221.128.131(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Vp-Iz30_1691112186)
          by smtp.aliyun-inc.com;
          Fri, 04 Aug 2023 09:23:07 +0800
Message-ID: <2c123597-e8bd-a0a0-cfb1-2236aa035870@linux.alibaba.com>
Date: Fri, 4 Aug 2023 09:23:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH] fs: ocfs2: namei: Check return value of ocfs2_add_entry()
Content-Language: en-US
To: Artem Chernyshev <artem.chernyshev@red-soft.ru>,
 Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>,
 akpm <akpm@linux-foundation.org>
Cc: Kurt Hackel <kurt.hackel@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230803145417.177649-1-artem.chernyshev@red-soft.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20230803145417.177649-1-artem.chernyshev@red-soft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/3/23 10:54 PM, Artem Chernyshev wrote:
> Process result of ocfs2_add_entry() in case we have an error
> value.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/namei.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 17c52225b87d..03bccfd183f3 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1535,6 +1535,10 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
>  		status = ocfs2_add_entry(handle, new_dentry, old_inode,
>  					 OCFS2_I(old_inode)->ip_blkno,
>  					 new_dir_bh, &target_insert);
> +		if (status < 0) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
>  	}
>  
>  	old_inode->i_ctime = current_time(old_inode);
