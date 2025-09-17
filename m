Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EDF1FBEB6
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Sep 2025 01:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758072760; cv=none; b=DXswdQ8UwcIjpwadjMJHwpYyg/VCmClavyp2/g8wkA6yqNr4OX4AEGCkco4KRK5PDJxdupkjDBs/1/Fbnp8xxFKavO+9qKPMhXzZpNjE3K6Bk5Fh94GnmoGd8P0tGhKw3Xo8QYEeJgaasODR7YO+Wqe7PwiksHWpmZQWJg+SHVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758072760; c=relaxed/simple;
	bh=AVkB2b0Do2CiYGr7NtQ5V2Ink9j50qmuyxtaPiEbEnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZETcPiiGeJN+arr3tPy++U1uYgI7kuAjhLCCueKs60L287dui9VVk3NZTFkqgkvtGlbevcZEk080pbKxhj5L71hy/xjDhx/P1X+uWwIzq7cYB9PxuTjZZgyDDZY2p2VNy4rJboRX5nIRN0TvVUKT0cx9QWADpBOHadkp+Izgbv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WtD10q4/; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WtD10q4/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758072749; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TS3bSbZ/3ombu0hD4AssLqYxTeZSd7emSs8Kjl1EGnc=;
	b=WtD10q4/5P+6M/x0kA8/9XiwO5ly4XgtwB2fJya89lKPJQw4fw0gU3fCoiMBShzRS86lPHBhJQrsk4CuDkWsYp8jo+W+4OfWOILk+lUmcwOcr03/+je6xeK3v0RUfMfjoIhI9JDidJutHM57wmIm2pc0KSLHfAMYHDelLJJKugw=
Received: from 30.221.144.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WoAbxOE_1758072747 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Sep 2025 09:32:28 +0800
Message-ID: <bd9f690a-19e6-4373-b0c2-e9622b7bd37b@linux.alibaba.com>
Date: Wed, 17 Sep 2025 09:32:27 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: avoid extra calls to strlen() after
 ocfs2_sprintf_system_inode_name()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20250915121906.514039-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250915121906.514039-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/9/15 20:19, Dmitry Antipov wrote:
> Since 'ocfs2_sprintf_system_inode_name()' uses 'snprintf()' and returns
> the number of characters emitted, callers of the former are better to
> use that return value instead of an explicit calls to 'strlen()'.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/ioctl.c        | 18 +++++++-----------
>  fs/ocfs2/move_extents.c |  6 +++---
>  fs/ocfs2/sysfile.c      | 12 ++++++------
>  3 files changed, 16 insertions(+), 20 deletions(-)
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
> index cbe2f8ed8897..a2b4c3f2a71c 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -375,9 +375,9 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  	struct ocfs2_dinode *ac_dinode;
>  	struct ocfs2_group_desc *bg;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> -	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					 strlen(namebuf), &blkno);
> +	i = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);

I'd like define a standalone 'len' instead reusing 'i'.

Thanks,
Joseph

> +	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf, i, &blkno);
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

