Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323DF17EE
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Aug 2023 06:07:54 +0000 (UTC)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RVJkf5Tsmz1L9Yk;
	Tue, 22 Aug 2023 14:06:18 +0800 (CST)
Received: from [10.174.176.34] (10.174.176.34) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 22 Aug 2023 14:07:46 +0800
Subject: Re: [PATCH -next] jbd2,ocfs2: fix wrong pointer pass to PTR_ERR()
To: Yang Yingliang <yangyingliang@huawei.com>, <ocfs2-devel@lists.linux.dev>
CC: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
	<tytso@mit.edu>, <jack@suse.cz>
References: <20230822030018.644419-1-yangyingliang@huawei.com>
From: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <9e19af43-8dcf-0481-609a-5b34ceddeb48@huawei.com>
Date: Tue, 22 Aug 2023 14:07:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230822030018.644419-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.34]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected

On 2023/8/22 11:00, Yang Yingliang wrote:
> Fix wrong pointer pass to PTR_ERR() if jbd2_journal_init_inode() fails.
> 
> Fixes: c279913275eb ("jbd2: jbd2_journal_init_{dev,inode} return proper error return value")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Ah, my mistake, thanks for the fix.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ocfs2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 90af6c47161d..ce215565d061 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -910,7 +910,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  	j_journal = jbd2_journal_init_inode(inode);
>  	if (IS_ERR(j_journal)) {
>  		mlog(ML_ERROR, "Linux journal layer error\n");
> -		status = PTR_ERR(journal);
> +		status = PTR_ERR(j_journal);
>  		goto done;
>  	}
>  
> 
