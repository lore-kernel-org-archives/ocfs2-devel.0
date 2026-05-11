Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403132C026C
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 06:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481321; cv=none; b=tKwYSFRuxbJXC+HxlKlnIz/W2ys8Rme+E4GIs/xGM5QYrqmsfh9kC0W79hxPK3njbats17gxtcfbcB0skjUrHZFzYYSMiwvFga0yD5FU/RQDwweLuFK0jwPXcI1Pcj3ZINRkawdLnEGS0rdWG6L5VKQD/dO+VNJjzXjDRNflxdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481321; c=relaxed/simple;
	bh=mU1XylTnoeHDxGnbeYLBDGSCSn5AhxE/GhPdOsLomUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jTFj3WEfGKp+zTJhX5g+lsl6krtyw8p1rWIqF/JwD1ph1RggIZsXvcYdfouVpHiWVBebh/La7Gz37+qGX95sR8iS/xRlPkQJtXc0/y5kxawqAFmyFE8jqzHAMkjSaIgapcQ3yYHNN0+q3QPbPXxFUH1G3HAAIBYRADO+Sxl2BO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kx/VMuPB; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kx/VMuPB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778481317; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W/PAQXC9/BCY94TtStMxwj+vRgOriNwcHuR5KXxUj8M=;
	b=kx/VMuPBDUJgBcNoN5J5VX9XDf7w8JFyR/c/IDPj1UapdnmMYmVv9PPybPDB5/NYy+Q+pht6HRcSaL+blgD6NX10ANdGJKehz7gTh87NCK04hifPrrqzyLQKC99y+4elx5f58Xi46lkzoTctu5NxhkATNPZ8kOuoNK4EJGSapPA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2fqQTr_1778481316;
Received: from 30.221.128.206(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2fqQTr_1778481316 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 14:35:16 +0800
Message-ID: <a39ce9f5-a091-4f1c-8718-3ecbea1d3be2@linux.alibaba.com>
Date: Mon, 11 May 2026 14:35:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] ocfs2: validate inline xattr header before reflinking
 inline xattrs
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260508085914.61647-1-gality369@gmail.com>
 <20260508085914.61647-6-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260508085914.61647-6-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/8/26 4:59 PM, ZhengYuan Huang wrote:
> [BUG]
> A corrupt inline xattr header can make ocfs2_reflink_xattr_inline() lock,
> copy, and reflink xattr state from an unchecked ibody xattr header.
> 
> [CAUSE]
> The inline reflink path still trusted di->i_xattr_inline_size to compute
> header_off, xh, and new_xh before handing the source header to the reflink
> allocator and copy logic.
> 
> [FIX]
> Validate the source inode's inline xattr header with the shared helper
> first, then derive the reflink copy offsets from the validated inline
> size/header. This keeps the reflink path from traversing corrupt ibody
> xattr geometry.
> 
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/xattr.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 4877406a83ce..fcddd3c13acd 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -6511,12 +6511,10 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
>  	handle_t *handle;
>  	struct ocfs2_super *osb = OCFS2_SB(args->old_inode->i_sb);
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)args->old_bh->b_data;
> -	int inline_size = le16_to_cpu(di->i_xattr_inline_size);
> -	int header_off = osb->sb->s_blocksize - inline_size;
> -	struct ocfs2_xattr_header *xh = (struct ocfs2_xattr_header *)
> -					(args->old_bh->b_data + header_off);
> -	struct ocfs2_xattr_header *new_xh = (struct ocfs2_xattr_header *)
> -					(args->new_bh->b_data + header_off);
> +	int inline_size;
> +	int header_off;
> +	struct ocfs2_xattr_header *xh;
> +	struct ocfs2_xattr_header *new_xh;
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	struct ocfs2_inode_info *new_oi;
>  	struct ocfs2_dinode *new_di;
> @@ -6525,6 +6523,15 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
>  		.vb_access = ocfs2_journal_access_di,
>  	};
>  
> +	ret = ocfs2_xattr_ibody_lookup_header(args->old_inode, di, &xh);
> +	if (ret)
> +		goto out;
> +
> +	inline_size = le16_to_cpu(di->i_xattr_inline_size);
> +	header_off = osb->sb->s_blocksize - inline_size;
> +	new_xh = (struct ocfs2_xattr_header *)
> +		(args->new_bh->b_data + header_off);
> +
>  	ret = ocfs2_reflink_lock_xattr_allocators(osb, xh, args->ref_root_bh,
>  						  &credits, &meta_ac);
>  	if (ret) {

