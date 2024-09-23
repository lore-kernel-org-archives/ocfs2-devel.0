Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F325F1103
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727059933; cv=none; b=HNGTbFA8XN9gZ9sLLlPc/I0zVdI20owL/rXuSIM/X6+jI+PFFkhjys0SQ4JEFLC5qpbNOvF/j8GF+VVwfn/oaNQ7nGOThKHcWZpGtaMTzfACf0yqWY/kmBOTZVm1QLLxPKoI0uXeoBOgk6K493/aE4REiYEBkvae4OGV7qg0ZZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727059933; c=relaxed/simple;
	bh=T95bhtE4ahzeAXj9o+UbB8jJyiaq+V9Y+k+RIg5NH3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQ3A+5GZTsuU9PggOmmD7X7GZmLpvtU4/bn2LZl82dV6xvq5K8MYh8cTgGfkj7qk2kTNuS4SQ3yeerMAc/wrjiN52peqinuPgQalUqUssjfq5kveyW6jVUpyxjeIzYmhGhQB+KLzY4Hho0QOqEVPugQzGYfqg29mMHQmIIsHgiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tZE8QoYe; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tZE8QoYe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1727059921; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=r4XJOtNI53//80tJmFNGm+o5EdJOnmpi3+8PaJ8QvK8=;
	b=tZE8QoYeoR8HWQtRYlTbKWHUKw1r5fd/a/5cxvHncDbYEXnzL877ZWokazWNmh6lGgo82BmdKlqfnI++RAU2v3ylK03nYTsp5eL4ewRfIU4lTzy6a1b/h0nOCxtHSyi6LUfcbbYElNnYkl0NepXS2Vfo9wILGg2MTlWk67CTCvE=
Received: from 30.221.132.125(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WFRyaS8_1727059919)
          by smtp.aliyun-inc.com;
          Mon, 23 Sep 2024 10:52:00 +0800
Message-ID: <e758ca0a-0ee7-4dff-8379-6d43397fddf0@linux.alibaba.com>
Date: Mon, 23 Sep 2024 10:51:58 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Fix deadlock in ocfs2_get_system_file_inode
To: Mohammed Anees <pvmohammedanees2003@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
References: <20240921175034.11222-1-pvmohammedanees2003@gmail.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240921175034.11222-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/24 1:50 AM, Mohammed Anees wrote:
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
> ocfs2_write_begin - lock(&ocfs2_file_ip_alloc_sem_key);
> .


From the report link, it's ocfs2_mknod(), but not
ocfs2_write_begin().

> .
> .
> ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);
> 
> CPU1 -
> ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

From the report link, it is in the flow of ocfs2_fill_super().
I'm not sure how it actually happens since user has to mount ocfs2
before doing any operations, e.g. create a file.
Anyway, since many flows will call ocfs2_get_system_file_inode(),
so it will theoretically happen.

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
>  fs/ocfs2/extent_map.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 70a768b62..f83d0a3b6 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -12,6 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/fiemap.h>
> +#include <linux/delay.h>
>  
>  #include <cluster/masklog.h>
>  
> @@ -961,6 +962,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>  	int rc = 0;
>  	u64 p_block, p_count;
>  	int i, count, done = 0;
> +	int retries, max_retries = 5;
> +	int retry_delay_ms = 30;
>  
>  	trace_ocfs2_read_virt_blocks(
>  	     inode, (unsigned long long)v_block, nr, bhs, flags,
> @@ -973,7 +976,18 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>  	}
>  
>  	while (done < nr) {
> -		down_read(&OCFS2_I(inode)->ip_alloc_sem);
> +		retries = 0;
> +		while (retries < max_retries) {
> +			if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem))
> +				break; // Lock acquired
> +			msleep(retry_delay_ms);
> +			retries++;
> +		}

I'd like just use down_read_trylock() and fail directly if can't.

Thanks,
Joseph

> +		if (retries == max_retries) {
> +			rc = -EAGAIN;
> +			mlog(ML_ERROR, "Cannot acquire lock\n");
> +			break;
> +		}
>  		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
>  						 &p_block, &p_count, NULL);
>  		up_read(&OCFS2_I(inode)->ip_alloc_sem);

