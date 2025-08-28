Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A651DF254
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Aug 2025 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756343029; cv=none; b=JjiCggx6A0Wab9TUXsMeFxV2ltFFrtNJv/20iJ0PA5AWGN9f+3t8HLmvOi7Dm6kQZTAD9M8RqJJH5UEyekNM7XioFSpzHG9nRxLUyW6lGieHFeRcpmU3aVvlT46Yq21dFagpuLdMJkPm7NCmToFIl+XVuG8V5HdqbIpwFTHEdvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756343029; c=relaxed/simple;
	bh=tKcnvLLBsvKSv5OWx1mabZbZWfL28xHnYbqqqyxXyW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0m9oZ2Ev+AAZlgc31usZ1LvSowF7AFuzaPuNhsEVsqBlGDfW8eKOBmXdjhZYY1xYOuJNQo8EvE8xKUcivQcjPRf3h8rYuFTSTe6rqRLxXjgMZmqz7UTyzmEqmO/vk6KIaLHM0L65Vrdcfvjo6I/8hhNiv/cpjygsicvbit502k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kpak/VjX; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kpak/VjX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756343018; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DwQVbUGKQ9bT1yKqfpUYBYb78nastbbRLboAJD8/Wqw=;
	b=kpak/VjXI7aekqXUwGqUD0gMRJo+6ye7Aoei74/4Lsnv+oXhfNIkjscmL9EZhBVGTzQMnBWBEqNDBIQU01GYdJffdN1DEHwij5NNBZuF6w7JD2Tq3lDCi46TIJgbFZwPMiEX5USxlotHPd2EUg6FlkI+QNidE4c9/9YdMF8HZhk=
Received: from 30.221.144.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wmkryrg_1756343016 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 09:03:37 +0800
Message-ID: <9ef8124b-224d-42b9-9dc7-15a10f3821e6@linux.alibaba.com>
Date: Thu, 28 Aug 2025 09:03:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add suballoc slot check in
 ocfs2_validate_inode_block()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev,
 syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
References: <20250826095106.666980-1-dmantipov@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250826095106.666980-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/8/26 17:51, Dmitry Antipov wrote:
> In 'ocfs2_validate_inode_block()', add suballoc slot check
> similar to one in 'ocfs2_get_suballoc_slot_bit()', thus
> preventing an out-of-bounds accesses for 'local_system_inodes'
> in 'get_local_system_inode()'.
> 
> Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Looks fine.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> Most likely this fixes https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..07cd3b4aa9cb 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1492,6 +1492,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
> +	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
> +		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_suballoc_slot));
> +		goto bail;
> +	}
> +
>  	rc = 0;
>  
>  bail:

