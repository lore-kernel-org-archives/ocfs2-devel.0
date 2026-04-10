Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAB84400
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775784042; cv=none; b=XZN+fl+c598gR8ySqpsZ5aARh+nGkW9ubtxRv3m5pRwLI13Wmzt/+QwG8U2Rxlra8ScI/4+gB0UzhDizc/Tby/nkaHl5uKdxKXPo/VABoIlbdZxYiilFkojYrgZuB7Z8heOYe2TUAYV2vMnnR9UIQXAeCJ6C6EY3bySCORPxAiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775784042; c=relaxed/simple;
	bh=O9M045n6Ki9WcIh+XeY8RCyCYdl79DvT1cTbbHc+mZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nt4dZYpUNtIsSbgTkETSL944GKnJG15uOd7L9utIunSSl8HWFKovTe9CreCSwkYowDGUVg5G2OOKH7F2x+jOUjjxyPX5LJm75Z/EEQen8Qi57CFf4Fz9DDyMi0YL/Bl26Ht/GGGYaTWvWM523Rasg73F11QzaiRjxm7JhL4cVd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BVS2FCaH; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BVS2FCaH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775784032; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ahJHQGqySMvqD8N5PlSNsMMdE7k8cezLSt1fROi1Q34=;
	b=BVS2FCaHJ7+DorrFspbeZ59WdTNnF76/vnnPnAxQm7bIpkldf/h6UfKUi1l19XJp6mY9YUstBAPSkfz9vfjJv5NWEHk3WWTinYKj78feQTDOzE6zkgZ9o3gkFGm2uFT/6i/gc6R3zEkH/tui+9FPQEGxVvO+xj0j/qNnE/Bcl4Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X0jZ8wb_1775784031;
Received: from 30.221.145.28(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0jZ8wb_1775784031 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Apr 2026 09:20:32 +0800
Message-ID: <cae7bb5a-af99-4757-999f-51a58bdf8166@linux.alibaba.com>
Date: Fri, 10 Apr 2026 09:20:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: handle system file flag mismatches gracefully
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260409105835.3474103-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260409105835.3474103-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/26 6:58 PM, ZhengYuan Huang wrote:
> [BUG]
> Mounting a crafted OCFS2 image can trip:
> 
> kernel BUG at fs/ocfs2/inode.c:609!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_read_locked_inode+0x1038/0x10c0 fs/ocfs2/inode.c:609
> Call Trace:
>  <TASK>
>  ocfs2_iget+0x7fa/0x9b0 fs/ocfs2/inode.c:157
>  _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:142 [inline]
>  ocfs2_get_system_file_inode+0x389/0x820 fs/ocfs2/sysfile.c:112
>  ocfs2_init_local_system_inodes fs/ocfs2/super.c:491 [inline]
>  ocfs2_mount_volume fs/ocfs2/super.c:1756 [inline]
>  ocfs2_fill_super+0x1330/0x3cd0 fs/ocfs2/super.c:1083
>  get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
>  get_tree_bdev+0x24/0x40 fs/super.c:1721
>  ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
>  vfs_get_tree+0x9a/0x370 fs/super.c:1758
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3642 [inline]
>  do_new_mount fs/namespace.c:3718 [inline]
>  path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
>  do_mount fs/namespace.c:4041 [inline]
>  __do_sys_mount fs/namespace.c:4229 [inline]
>  __se_sys_mount fs/namespace.c:4206 [inline]
>  __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
>  ...
> 
> [CAUSE]
> ocfs2_read_locked_inode() assumes any mismatch between
> OCFS2_FI_FLAG_SYSFILE and the dinode's OCFS2_SYSTEM_FL bit is a pure
> caller bug, so it routes the condition through mlog_bug_on_msg(). A
> crafted filesystem can violate that assumption by making a system
> directory entry point at a non-system inode that still passes generic
> dinode validation.
> 
> [FIX]
> Keep the mismatch check in ocfs2_read_locked_inode(), where the caller
> context is available, but replace the BUG assertion with an error log
> and the existing bail path. That turns crafted on-disk input into a
> failed inode read and mount failure instead of a kernel crash.
> 
> Fixes: 24c19ef40474 ("ocfs2: Remove i_generation from inode lock names")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/inode.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index fcc89856ab95..0a60de5d46fe 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -602,14 +602,17 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  	fe = (struct ocfs2_dinode *) bh->b_data;
>  
>  	/*
> -	 * This is a code bug. Right now the caller needs to
> -	 * understand whether it is asking for a system file inode or
> -	 * not so the proper lock names can be built.
> +	 * The caller has to tell us whether it expects a system file inode
> +	 * so the lock names can be built correctly. A corrupted system
> +	 * directory can violate that expectation, so fail the read instead
> +	 * of crashing.
>  	 */
> -	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
> -			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
> -			"Inode %llu: system file state is ambiguous\n",
> -			(unsigned long long)args->fi_blkno);
> +	if (!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
> +	    !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)) {
> +		mlog(ML_ERROR, "Inode %llu: system file state is ambiguous\n",
> +		     (unsigned long long)args->fi_blkno);
> +		goto bail;
> +	}
>  
>  	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
>  	    S_ISBLK(le16_to_cpu(fe->i_mode)))

