Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505372571C0
	for <ocfs2-devel@lists.linux.dev>; Sun, 19 Apr 2026 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776603692; cv=none; b=CQ+C1NwvVtEHbRE+oRoGv5I6zvu/MwgbjVJjG/5AicOM81S/IvzSYz63jzkXNbjVuVtdEmS6t5rmcjUv1EtTCIoiuOxX000eo2dfdpMQfTB59e96jEfCDZgOuusXzPkqo2cSVD0pYgrDhpzqMVwZp+Cu5jEVapLtmY6fotgzIMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776603692; c=relaxed/simple;
	bh=/kHM3juF8cyif13WOyGDt67aq+JPUiCk9cfw8cgGzwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ARFDsNm5U7RdjXH1LDfXoXFKsB2/ghTnnGXS+Uk9jstcbGsLc2Hq74q1NxzvZiyuUHLvUe4kPdFVdILxe5Hg/nfKnQmn5CUGh+Wuko/qHT0AeIcJGAW9Mn6sO8z0IzsM+NtZF2PWh3Ct/BwIqW3Yt9yNDBC9UQsF/7VAe/WjkFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Ofo/gC2Y; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Ofo/gC2Y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776603680; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kopE+bNza5kWMFBiqrVy+41NYpdUqWmGznTpaR6z/SQ=;
	b=Ofo/gC2YBof7ukr6WuBcDZU9JtAPjC5YJ2beHnwKG9eI+VrKXz39ah6pCsXtK+OBSeFvZbpYTevzJnTcS9kvPeleZrOIaPqNO4tGk0tot7j0DUqEInXyQ2bk4rn4ZmEFV1E8VrDNYfltryTJ1FWv2mq98ijT/DfjpwbhkRhH2BA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X1Fm0kx_1776603678;
Received: from 30.41.171.241(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X1Fm0kx_1776603678 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 19 Apr 2026 21:01:18 +0800
Message-ID: <6a1f6815-d081-48a0-bc85-1e1ccb59bb5c@linux.alibaba.com>
Date: Sun, 19 Apr 2026 21:01:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: use kzalloc for quota recovery bitmap allocation
To: Tristan Madani <tristmd@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260418131048.1052507-1-tristmd@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260418131048.1052507-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/18/26 9:10 PM, Tristan Madani wrote:
> From: Tristan Madani <tristan@talencesecurity.com>
> 
> ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does
> not fully initialize it. This can lead to use of uninitialized bits
> during quota recovery from a corrupted filesystem image.
> 
> Use kzalloc instead to ensure the bitmap is zero-initialized.
> 
> Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/quota_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 12cbb4fccda0d..f55810c59b1b1 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(struct super_block *sb,
>  	if (!rc)
>  		return -ENOMEM;
>  	rc->rc_chunk = chunk;
> -	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
> +	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
>  	if (!rc->rc_bitmap) {
>  		kfree(rc);
>  		return -ENOMEM;

