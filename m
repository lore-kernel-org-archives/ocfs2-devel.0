Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F16186A
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Sep 2024 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727141652; cv=none; b=gxSbaTinAtVp+mTyS6HCNEK+Xz2hnXAM5kzSvcUVfRLxi2ZZirTfq8wcyXwCV/aAkPsc69iB5w4AktKnk5MOwCGLvhVEd5obtrrKz7XI8cfWJDghmxgH77EJuvH32Z+CxkbJclgGuv9CW4SC/yzwZO/LKBBu1AMmQi/rHCs0jXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727141652; c=relaxed/simple;
	bh=yJD0zsN4IxxFpPSK0ulQhgwMOGJv7TGdJe1DmKmeOqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8TPk+eAc1Y38GBlVhAScYPW06qZJV6/ws2URkaNTZBYDK/PJzIidu7V6MlytCeqWQPoijygnV1EWEIimGvtbSWP2DlH087Q43OeUaKBZhj1ggfiCkApjNxvn+5hhA9NXn3w7AP2rTFdI7rheERh8ABBBcrTZtPAtr40RjGcXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gTR3sp2h; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gTR3sp2h"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1727141648; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6UjjrfXK1WYlhJ+HrX1vB4ucv1aD7phgPcBAQ5tWEtw=;
	b=gTR3sp2hr04p+uRf+ipHKVp3UYaag1v75GGza6OeqMVoRskJoVScDWzZ0AdYJviV4fij+NAGar6Lme+thEmr9zo5ZqaC92imYcqjrAO+DZakwgAGh30W9yiBns0YIqSO9LD4fgmYg60A4Ig4+MOaDoO2ZcbECmLi+MG6ZhULkfk=
Received: from 30.221.128.243(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WFdsVUM_1727141647)
          by smtp.aliyun-inc.com;
          Tue, 24 Sep 2024 09:34:08 +0800
Message-ID: <10da0c50-f796-4ea3-8a7f-eceb127923f9@linux.alibaba.com>
Date: Tue, 24 Sep 2024 09:34:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: Fix deadlock in ocfs2_get_system_file_inode
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
References: <20240923132854.13936-1-pvmohammedanees2003@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240923132854.13936-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/24 9:28 PM, Mohammed Anees wrote:
> syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].
> 
> The scenario is depicted here,
> 
> 	CPU0					CPU1
> lock(&ocfs2_file_ip_alloc_sem_key);
>                                lock(&osb->system_file_mutex);
>                                lock(&ocfs2_file_ip_alloc_sem_key);
> lock(&osb->system_file_mutex);
> 
> The function calls which could lead to this are:
> 
> CPU0
> ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
> .
> .
> .
> ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);
> 
> CPU1 -
> ocfs2_file_super - lock(&osb->system_file_mutex);
> .
> .
> .
> ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);
> 
> This issue can be resolved by making the down_read -> down_read_try
> in the ocfs2_read_virt_blocks.
> 
> [1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
> 
> Reported-and-tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> ---
> v2:
> - Remove retries when doing down_read_trylock() and fail directly
> ---
>  fs/ocfs2/extent_map.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 70a768b62..48919464a 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -973,7 +973,12 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>  	}
>  
>  	while (done < nr) {
> -		down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem))
> +			rc = -EAGAIN;
> +		if (rc) {
> +			mlog(ML_ERROR, "Resource is temporarily unavailable\n");
> +			break;
> +		}

Or could be simplified to:

if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
	rc = -EAGAIN;
	mlog(ML_ERROR, "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
	break;
}

Thanks,
Joseph

>  		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
>  						 &p_block, &p_count, NULL);
>  		up_read(&OCFS2_I(inode)->ip_alloc_sem);

