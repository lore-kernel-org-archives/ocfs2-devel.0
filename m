Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B886228F0
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jul 2024 01:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721092229; cv=none; b=iDIi28PrCM3yNwK0JVcBApQorcuV7ERq5QUDHFWp0LrmP76Xmi8RzH6IQAKY9ZlvNJA8vRyy0mMKzLBwvJSz37VdrkkKtXp7XNe47y6AnS0tpNaN9EKPVR3vi7kQy2M/Gg/zJNSffGCJSGGedwmzpA3vYjIAM78FNIXZrpBsqbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721092229; c=relaxed/simple;
	bh=x4ienU8575CT/oh9h/ruLYvvXKSyslfJoy+Cou03kmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RddzLxVrIo8b9ZFz57ERYjJ0MjY1ZXJtsp3yvr/autZoRgQ+1J7B7//K9khTLCPL7JoSetyWRrQPy7Y8TT8E+/2VxUCc0qvwPwTcA2K5Bh1+8ZEibtm0RbqDhQLTuhHFXXfWlk2P/0DqTkV44ME52i0pohwQuyv/4KqmsjL36oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nqEHI2vk; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nqEHI2vk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1721092220; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=podFBawq3qUWxC6GJyKeZzxgJkUfZhMQQKmWCfiivqg=;
	b=nqEHI2vkVBuYAvbxa3AzffFCgL7kfHvH8JiuCfz3wSwkTMaJyPsN+GByvpEa7792I47WF7hKgwQLiParuIwAAxwPv7cbt+nb7HKY+G9COnZhiSmwrFRUKVl09BsPH33qmrThHXUMlagDtKBkY2IMvyqkvUPbXEb3dWOqF6kA/RI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032014031;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0WAfKy4l_1721092218;
Received: from 30.221.128.129(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WAfKy4l_1721092218)
          by smtp.aliyun-inc.com;
          Tue, 16 Jul 2024 09:10:19 +0800
Message-ID: <afca4e22-7edd-494f-9a43-66d1098a3ec4@linux.alibaba.com>
Date: Tue, 16 Jul 2024 09:10:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] quota: avoid missing put_quota_format when
 DQUOT_SUSPENDED is passed
To: Kemeng Shi <shikemeng@huaweicloud.com>, jack@suse.com
Cc: mark@fasheh.com, jlbec@evilplan.org, hughd@google.com,
 akpm@linux-foundation.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
 <20240715130534.2112678-2-shikemeng@huaweicloud.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240715130534.2112678-2-shikemeng@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/15/24 9:05 PM, Kemeng Shi wrote:
> Avoid missing put_quota_format when DQUOT_SUSPENDED is passed to
> dquot_load_quota_sb.
> 

It seems worth a 'Fixes' tag:
Fixes: d44c57663723 ("quota: Remove BUG_ON in dquot_load_quota_sb()")

Other looks good to me. So with the above addressed, feel free to add:
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  fs/quota/dquot.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 627eb2f72ef3..23fcf9e9d6c5 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2408,7 +2408,7 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
>  int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
>  	unsigned int flags)
>  {
> -	struct quota_format_type *fmt = find_quota_format(format_id);
> +	struct quota_format_type *fmt;
>  	struct quota_info *dqopt = sb_dqopt(sb);
>  	int error;
>  
> @@ -2418,6 +2418,7 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
>  	if (WARN_ON_ONCE(flags & DQUOT_SUSPENDED))
>  		return -EINVAL;
>  
> +	fmt = find_quota_format(format_id);
>  	if (!fmt)
>  		return -ESRCH;
>  	if (!sb->dq_op || !sb->s_qcop ||
