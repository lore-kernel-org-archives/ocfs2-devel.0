Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1A21F584C
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 07:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765523628; cv=none; b=BxG9GBDmpaeoXeidaim9hlh1mYAZCIszx2Yd0w7p4ptv4Q/ilRfpbo7CiAYujIXUb52rLSCAuV8SauWMyswwpIop2q72MPqQyfh+GNfMLCVnEzqzGshYhfSYsz7cwsjKJlQ6khHsTAaxa6pqLMEoHE6XbGHD40xROPxR/BtZYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765523628; c=relaxed/simple;
	bh=K8MtrBOFrG554Tq0/LtGtmG91BQEYMn2dz5/yj+JJCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=te7fC5ffsOoPjb0iL6ugJy+KSO9GzWZiPVXyKLOghBkf/gIjSnVwVqxOesdOs020P+ASGNdBm2izsog1WxfkO40IkaLDswfIyah2IvZxNK48ihX8ojmRTJD56A7V7VukSwx1GILjjUYzKpwrd2OOIWBon9+6zEHrNlbvkhIX1hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=d7KsMruO; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="d7KsMruO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765523621; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=L2y8fQcX6a79m4xMCeLeaa2YHm7bV3+qA1r3yVsF+Ic=;
	b=d7KsMruOsWEKfm5Bl0eQAPm6amWildsxNltmkDfhXkoGxyQGRr2Rccr911LxJIY7vXVaDALhnjAaMqhhw1+r5O+ga928kbTKd6VH616y/Jo/+8VuyTc4Fv+CuJQ4vW6HT3z0T2fHZ/4WARN5f1kHzJV6RAJFJumKf67YmOoUiOA=
Received: from 30.221.145.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WudIePH_1765523619 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 15:13:40 +0800
Message-ID: <ebb36e6e-7b41-4ec6-b4ac-42b7c0da16e6@linux.alibaba.com>
Date: Fri, 12 Dec 2025 15:13:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: validate i_refcount_loc when refcount flag is
 set
To: Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, heming.zhao@suse.com, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
References: <20251212055826.20929-1-kartikey406@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251212055826.20929-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/12 13:58, Deepanshu Kartikey wrote:
> Add validation in ocfs2_validate_inode_block() to check that if an
> inode has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid
> i_refcount_loc. A corrupted filesystem image can have this inconsistent
> state, which later triggers a BUG_ON in ocfs2_remove_refcount_tree()
> when the inode is being wiped during unlink.
> 
> Catch this corruption early during inode validation to fail gracefully
> instead of crashing the kernel.
> 
> Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
> Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20251208084407.3021466-1-kartikey406@gmail.com/T/ [v1]
> Link: https://lore.kernel.org/all/20251212045646.9988-1-kartikey406@gmail.com/T/ [v2]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v3: Use le16_to_cpu() for consistency with other checks (Joseph Qi)
> v2: Shortened error message to fix line length (Heming Zhao)
> ---
>  fs/ocfs2/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 78f81950c9ee..1019ca80760c 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
> +	    !di->i_refcount_loc) {
> +		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
> +				(unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	}
> +
>  	rc = 0;
>  
>  bail:

