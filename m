Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCBF1B6D0B
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084571; cv=none; b=UIBap+xD7C4PDm827Xqb6RdvjY7RsM1m5Cky6CkP1vZsQSI8u+gnbU8LfFSWaON0l1lDVmWuTjB5etE80CnpWJFYZfdArnR8Lg58EBWrXy3UJoiQKFckx0S7LKpcS1FIwBwE4jUQgtRzzIuol3qI0FQE6IfsWtFMeLfIsCCGB8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084571; c=relaxed/simple;
	bh=iaDAbwrPmDGRPnheYeU8uuut3mA3jdQDZUuDHWtDWKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=teUac8F8AwDu3KXb0jeSSsSMTwnpDWBMxs+0plNP2RjjgI5BDoBOdbRQ7jqo+mRY8DIK8bxDEn/m0dSr2ZbcZ9VF3GM/WDAJC0WtMn7yZftWk6nJwBsbG3kSyMQV2Y6gFihRKMqS6u0jya043vYcEeEdaIBAQQZUz3pBgSIZ6nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Q+kvnsdm; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Q+kvnsdm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734084563; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=g/5yxSldhprT7Tl5A9HoAftj5KWV1zOYfWRvSZizeEU=;
	b=Q+kvnsdmn7LP6r34mB3z9yX5ixZRK9QYqzMy7M7o9v/uAR65SYibk3Gtekac3GzCKgQsHSjJhfPXDvz340eHRuOE88676wcwW5kAwkd8N3VUEYXeeCMSrK9hZxikPBo7uu+dGOuvZ2KB4qXNYQriiHgmhkepIV8gp6uLuyqAaZk=
Received: from 30.221.145.112(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLOq7PO_1734084558 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Dec 2024 18:09:19 +0800
Message-ID: <67115400-0e6d-4ef6-82ae-d776c6617033@linux.alibaba.com>
Date: Fri, 13 Dec 2024 18:09:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: avoid extra calls to strlen()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev
References: <20241210163723.20137-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241210163723.20137-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/11 00:37, Dmitry Antipov wrote:
> Since 'ocfs2_sprintf_system_inode_name()' returns the
> number of characters emitted, avoid extra calls to
> 'strlen()' where appropriate. Compile tested only.
> 

Ummm... It seems this is not an equivalent replace. 
snprintf() returns the number of characters which would be generated,
while strlen() returns the actually written characters.

Thanks,
Joseph

> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ocfs2/ioctl.c        | 21 +++++++++------------
>  fs/ocfs2/move_extents.c |  9 +++++----
>  fs/ocfs2/sysfile.c      | 12 ++++++------
>  3 files changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 71beef7f8a60..cec70bf4e478 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -329,7 +329,7 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
>  	u32 i;
>  	u64 blkno = -1;
>  	char namebuf[40];
> -	int status, type = INODE_ALLOC_SYSTEM_INODE;
> +	int len, status, type = INODE_ALLOC_SYSTEM_INODE;
>  	struct ocfs2_info_freeinode *oifi = NULL;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  	struct inode *inode_alloc = NULL;
> @@ -358,12 +358,11 @@ static int ocfs2_info_handle_freeinode(struct inode *inode,
>  				goto bail;
>  			}
>  		} else {
> -			ocfs2_sprintf_system_inode_name(namebuf,
> -							sizeof(namebuf),
> -							type, i);
> +			len = ocfs2_sprintf_system_inode_name(namebuf,
> +							      sizeof(namebuf),
> +							      type, i);
>  			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -							    namebuf,
> -							    strlen(namebuf),
> +							    namebuf, len,
>  							    &blkno);
>  			if (status < 0) {
>  				status = -ENOENT;
> @@ -616,7 +615,7 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
>  {
>  	u64 blkno = -1;
>  	char namebuf[40];
> -	int status, type = GLOBAL_BITMAP_SYSTEM_INODE;
> +	int len, status, type = GLOBAL_BITMAP_SYSTEM_INODE;
>  
>  	struct ocfs2_info_freefrag *oiff;
>  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> @@ -651,12 +650,10 @@ static int ocfs2_info_handle_freefrag(struct inode *inode,
>  			goto bail;
>  		}
>  	} else {
> -		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
> -						OCFS2_INVALID_SLOT);
> +		len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
> +						      type, OCFS2_INVALID_SLOT);
>  		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> -						    namebuf,
> -						    strlen(namebuf),
> -						    &blkno);
> +						    namebuf, len, &blkno);
>  		if (status < 0) {
>  			status = -ENOENT;
>  			goto bail;
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index f9d6a4f9ca92..c1b7c6cee95d 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -364,7 +364,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  					 int *vict_bit,
>  					 struct buffer_head **ret_bh)
>  {
> -	int ret, i, bits_per_unit = 0;
> +	int len, ret, i, bits_per_unit = 0;
>  	u64 blkno;
>  	char namebuf[40];
>  
> @@ -375,9 +375,10 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
>  	struct ocfs2_dinode *ac_dinode;
>  	struct ocfs2_group_desc *bg;
>  
> -	ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type, slot);
> -	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
> -					 strlen(namebuf), &blkno);
> +	len = ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf),
> +					      type, slot);
> +	ret = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
> +					 namebuf, len, &blkno);
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

