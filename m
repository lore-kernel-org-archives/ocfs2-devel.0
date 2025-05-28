Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA76279789
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 May 2025 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748435747; cv=none; b=rzEv1uSy4YSdLEE9ke7givFHByp+/9H1UR6bvrOAA610L7wdDyyFdpUMN2l3ljsQt3jQsGABhzvQhFVq4NmaRUKe2naxeE071Z2rPVEr8cyEifYVmfS25WVv23BGR9dNIwaDgnOmMAXB5cxUEj8dVI3qp0VzaGRWwMK7QIip6pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748435747; c=relaxed/simple;
	bh=LYwqlBRi8ID882TZWjXAGZR8tgMQwuR55sVHt5Q57Jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e6iHaYJkl08w6m50bzuuQalu29EsBaWaTDpUWriRdtdMa6GyfhzXKXFoaSZpchHW/JJcK9PD5WG0M+RzXDojV3wVXemTimw0HEtPw83H1TDsV7WJG0SlnTcfTTgC8FSuafHvQhrRquOErr1h/UHPZbWhOBZjdGQMs5fC1Zx/RuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YPR4P/Zc; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YPR4P/Zc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1748435735; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=54GRYqlSUhKavKBqRRsmmEctJpORh0vvFiJujpYJZXc=;
	b=YPR4P/ZcdtSOJmHgDyIeIqEeYZUUPDarvb0rNWM9ERT0Q0wb1WBV14LS97BvChkztTtVvQMS6iWY8qGpzC1j8V2zYfmxcJDOGgagykTLYMz7W+anVVvQeruDxlCgkUtzk/8/ITL4d+fsFkuSQ+B65cuBdWu6VSc3AnzM3k0CEuo=
Received: from 30.221.144.174(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WcDTszd_1748435734 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 May 2025 20:35:34 +0800
Message-ID: <878ab848-c57c-422b-9694-264d43af7f7d@linux.alibaba.com>
Date: Wed, 28 May 2025 20:35:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Replace simple_strtol with kstrtol
To: Su Hui <suhui@nfschina.com>, mark@fasheh.com, jlbec@evilplan.org,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <20250527092333.1917391-1-suhui@nfschina.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250527092333.1917391-1-suhui@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/5/27 17:23, Su Hui wrote:
> kstrtol() is better because simple_strtol() ignores overflow. And using
> kstrtol() is more concise.
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/stack_user.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 77edcd70f72c..0f045e45fa0c 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -360,7 +360,6 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
>  					struct ocfs2_control_message_setn *msg)
>  {
>  	long nodenum;
> -	char *ptr = NULL;
>  	struct ocfs2_control_private *p = file->private_data;
>  
>  	if (ocfs2_control_get_handshake_state(file) !=
> @@ -375,8 +374,7 @@ static int ocfs2_control_do_setnode_msg(struct file *file,
>  		return -EINVAL;
>  	msg->space = msg->newline = '\0';
>  
> -	nodenum = simple_strtol(msg->nodestr, &ptr, 16);
> -	if (!ptr || *ptr)
> +	if (kstrtol(msg->nodestr, 16, &nodenum))
>  		return -EINVAL;
>  
>  	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||
> @@ -391,7 +389,6 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
>  					   struct ocfs2_control_message_setv *msg)
>  {
>  	long major, minor;
> -	char *ptr = NULL;
>  	struct ocfs2_control_private *p = file->private_data;
>  	struct ocfs2_protocol_version *max =
>  		&ocfs2_user_plugin.sp_max_proto;
> @@ -409,11 +406,9 @@ static int ocfs2_control_do_setversion_msg(struct file *file,
>  		return -EINVAL;
>  	msg->space1 = msg->space2 = msg->newline = '\0';
>  
> -	major = simple_strtol(msg->major, &ptr, 16);
> -	if (!ptr || *ptr)
> +	if (kstrtol(msg->major, 16, &major))
>  		return -EINVAL;
> -	minor = simple_strtol(msg->minor, &ptr, 16);
> -	if (!ptr || *ptr)
> +	if (kstrtol(msg->minor, 16, &minor))
>  		return -EINVAL;
>  
>  	/*
> @@ -441,7 +436,6 @@ static int ocfs2_control_do_down_msg(struct file *file,
>  				     struct ocfs2_control_message_down *msg)
>  {
>  	long nodenum;
> -	char *p = NULL;
>  
>  	if (ocfs2_control_get_handshake_state(file) !=
>  	    OCFS2_CONTROL_HANDSHAKE_VALID)
> @@ -456,8 +450,7 @@ static int ocfs2_control_do_down_msg(struct file *file,
>  		return -EINVAL;
>  	msg->space1 = msg->space2 = msg->newline = '\0';
>  
> -	nodenum = simple_strtol(msg->nodestr, &p, 16);
> -	if (!p || *p)
> +	if (kstrtol(msg->nodestr, 16, &nodenum))
>  		return -EINVAL;
>  
>  	if ((nodenum == LONG_MIN) || (nodenum == LONG_MAX) ||

