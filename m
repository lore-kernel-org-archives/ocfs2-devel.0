Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B77441021
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543749; cv=none; b=pnQEEzl3E3r3vVkq1T0gdsB1rgZ8LMCK+hkB+MvNIwC3VU4+oJGLTvfO3QaL9AggVzj8X0diph4JxGw6FD25fuFR/fxk1gjVUBk3UembI22WJ6vbBTgt22rX3deKVX5Uy8jV3XXTVp/RJ+ckikkPAiTviKJg49/b7Q7eyDq+FbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543749; c=relaxed/simple;
	bh=bD+1BEN14Zfz9PtRYhPjV4uNln7fue27sWtaoGyg800=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N7+uqc9VdP9M6YRfK22Uzsu9QFWsMSZTkQ+qe8jcd5PLnlJTGYN7s2V2CPjjDhZk0n7bxkMmzA24OPj7OVG4ve4UpLJE3+eUkRIQ2/ZCImsGYpwvGOArJq3+dqp5rYSADHamruQJrgurKaYYIXfm19/74va861jK3m8S1EGWhpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bgRBZoEa; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bgRBZoEa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789543730; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3jMX0BUSZ/FKeDyfr7EEqcDjLQ6vZzNotskJA56k2d4=;
	b=bgRBZoEaTTxUrtjw4fIXbbE0cOmuVcjgIKMGuaTCwLS4Di025IVEDvIo4t+/wqDK8C6rLhkwfYEE5ODjVowQnKfkdbUtu0o3VyAFVs8FfMtWGXJnWX4JVXDqFlZQ/OwigYiuTUIQ0/FMMNLebar4hVfScwrZM0tl5tCOm2ytz30=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XB4E-Gt_1789543728;
Received: from 30.221.129.239(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XB4E-Gt_1789543728 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 15:28:49 +0800
Message-ID: <4eba77a2-a66f-438d-a769-40398564304f@linux.alibaba.com>
Date: Wed, 16 Sep 2026 15:28:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
To: Daniel Borkmann <daniel@iogearbox.net>, alexei.starovoitov@gmail.com
Cc: brauner@kernel.org, dwindsor@gmail.com, john.fastabend@gmail.com,
 memxor@gmail.com, kpsingh@kernel.org, matt@bobrowski.net,
 bpf@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>,
 ocfs2-devel@lists.linux.dev
References: <20260915150739.284189-1-daniel@iogearbox.net>
 <20260915150739.284189-2-daniel@iogearbox.net>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260915150739.284189-2-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
I have reworked security xattrs in local, which addresses a review
comments from sashiko.

The fix will allocate an array in ocfs2_initxattrs(), copy the names
and values, account for all of them in the credit calculations, and
write each one in ocfs2_init_security_set().

It seems if with it, your patch is no longer needed. I'll send out
later.

Thanks,
Joseph

On 9/15/26 11:07 PM, Daniel Borkmann wrote:
> ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
> through a struct ocfs2_security_xattr_info, so that they can size the
> transaction before setting it. ocfs2_initxattrs() duplicates the value
> since the array security_inode_init_security() hands is freed on return,
> but keeps the name pointer as-is, given so far every LSM stored a string
> constant there. bpf_inode_init_xattr() places the name in the same
> allocation as the value, which security_inode_init_security() frees on
> its way out. Copy the name alongside the value and free both together.
> This is the only special case wrt xattrs in the bpf_inode_init_xattr()
> context.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@lists.linux.dev
> ---
>  fs/ocfs2/namei.c | 2 ++
>  fs/ocfs2/xattr.c | 5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index e9c7774ccf91..e24f0e337a56 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -480,6 +480,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> +	kfree(si.name);
>  	kfree(si.value);
>  
>  	ocfs2_acl_init_release(&acl_state);
> @@ -2068,6 +2069,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> +	kfree(si.name);
>  	kfree(si.value);
>  	ocfs2_free_dir_lookup_result(&lookup);
>  	if (inode_ac)
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..d83840b6bed9 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7524,8 +7524,9 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
>  				    GFP_KERNEL);
>  		if (!si->value)
>  			return -ENOMEM;
> -
> -		si->name = xattr_array->name;
> +		si->name = kstrdup(xattr_array->name, GFP_KERNEL);
> +		if (!si->name)
> +			return -ENOMEM;
>  		si->value_len = xattr_array->value_len;
>  		return 0;
>  	}

