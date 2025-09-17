Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1321C84DE
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Sep 2025 07:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758092882; cv=none; b=ji+ES2X7PoJFpuACvbRloI1agZvQnvUlxByu/QR0AZbUyDbrYfLgAaEFr74FPSCFYTxxaa9g3S1er9c9jtePl0JhNl7zD5tCqY+QhEDprfSV4izs+2oGPjUaGK4FwJ64L7zFD8IBnR78sZ9qQhbynGgmCq0wf9YBCDKq0Y6yBG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758092882; c=relaxed/simple;
	bh=0s+eg4taMh+xD4d1XMFxo2JDPWT7hxHLIiWaeGlKjKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZjfdaewfwA3a3Zpl9niMaGEFpnajVF5zHQOVgdBHZFimV4MZMzlCkBLTI1+Ve4ss7D2d/jJ8RNVMN8nU/8smEQw2mzTqk4EKscqjB9ebPWENZpgD/wjVhafjW2cwj3slhyzUeEyuWMmXeTjNKA4uKoqB13SWVgbKG5JIAqlUhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q4ae3/65; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q4ae3/65"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758092870; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gQUI+R8vKG6GF4KVfElrQiYzAStOPzMA1jboR+Aw5Gk=;
	b=q4ae3/65Fyuk3XBaO7TPawlieA1Pa75DzZHko8M0Ba/JsTeyENSZR89sqljsoDukA5kPzPHzFUeOUhxqS64zvmMYIHpMNiUU7vdXM46fygl/KrfC2sUYcME0lomlyua4e2DvNFYFotMzLUO5BeL7FZezARs+HwlGr2cKwrKsvJw=
Received: from 30.221.144.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WoBXWN7_1758092868 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Sep 2025 15:07:49 +0800
Message-ID: <aa3b4281-9f1d-4bb7-b635-18584af41f2b@linux.alibaba.com>
Date: Wed, 17 Sep 2025 15:07:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: avoid extra calls to strlen() after
 ocfs2_sprintf_system_inode_name()
To: Dmitry Antipov <dmantipov@yandex.ru>, akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev
References: <bd9f690a-19e6-4373-b0c2-e9622b7bd37b@linux.alibaba.com>
 <20250917060229.1854335-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250917060229.1854335-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/9/17 14:02, Dmitry Antipov wrote:
> Since 'ocfs2_sprintf_system_inode_name()' uses 'snprintf()' and returns
> the number of characters emitted, callers of the former are better to
> use that return value instead of an explicit calls to 'strlen()'.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2: adjust 'ocfs2_find_victim_alloc_group()' to
>     not (mis)use loop counter for length (Joseph)
> ---
>  fs/ocfs2/ioctl.c        | 18 +++++++-----------
>  fs/ocfs2/move_extents.c |  8 ++++----
>  fs/ocfs2/sysfile.c      | 12 ++++++------
>  3 files changed, 17 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index db14c92302a1..b6864602814c 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -358,13 +358,11 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
>  				goto bail;
>  			}
>  		} else {
> -			ocfs2_sprintf_system_inode_name(namebuf,
> -							sizeof(namebuf),
> -							type, i);
> +			int len = ocfs2_sprintf_system_inode_name(namebuf,
> +								  sizeof(namebuf),
> +								  type, i);
>  			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -							    namebuf,
> -							    strlen(namebuf),
> -							    &blkno);
> +							    namebuf, len, &blkno);
>  			if (status < 0) {
>  				status = -ENOENT;
>  				goto bail;
> @@ -651,12 +649,10 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
>  			goto bail;
>  		}
>  	} else {
> -		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
> -						OCFS2_INVALID_SLOT);
> +		int len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
> +							  type, OCFS2_INVALID_SLOT);
>  		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -						    namebuf,
> -						    strlen(namebuf),
> -						    &blkno);
> +						    namebuf, len, &blkno);
>  		if (status < 0) {
>  			status = -ENOENT;
>  			goto bail;
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index cbe2f8ed8897..86f2631e6360 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -364,7 +364,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  					 int *vict_bit,
>  					 struct buffer_head **ret_bh)
>  {
> -	int ret, i, bits_per_unit = 0;
> +	int ret, i, len, bits_per_unit = 0;
>  	u64 blkno;
>  	char namebuf[40];
>  
> @@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  	struct ocfs2_dinode *ac_dinode;
>  	struct ocfs2_group_desc *bg;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> -	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					 strlen(namebuf), &blkno);
> +	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> +	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, len, &blkno);
> +
>  	if (ret) {
>  		ret = -ENOENT;
>  		goto out;
> diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
> index 53a945da873b..d53a6cc866be 100644
> --- a/fs/ocfs2/sysfile.c
> +++ b/fs/ocfs2/sysfile.c
> @@ -127,14 +127,14 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>  	char namebuf[40];
>  	struct inode *inode = NULL;
>  	u64 blkno;
> -	int status = 0;
> +	int len, status = 0;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf,
> -					sizeof(namebuf),
> -					type, slot);
> +	len = ocfs2_sprintf_system_inode_name(namebuf,
> +					      sizeof(namebuf),
> +					      type, slot);
>  
> -	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					    strlen(namebuf), &blkno);
> +	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> +					    namebuf, len, &blkno);
>  	if (status < 0) {
>  		goto bail;
>  	}

