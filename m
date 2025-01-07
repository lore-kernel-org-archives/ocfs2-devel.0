Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917831DE894
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 09:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736241610; cv=none; b=kPswhQyh9sNRjCY5VHXiAS/x7v9aydLdVOpQTXYIWcOJRCTG+09tpfD3Yo+jqy+lHsCm8YxOA2IIATMj4QGkiLsKWtCbzgfxHFGO1EofEW85Vboc7PsNQTjeXduSFcbFf+Ji28DYqMd/v6Mfvdv9UPzEUm8BujFSHRYGEHHoPLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736241610; c=relaxed/simple;
	bh=dSc0cO6b6LONwSDvK1QK4Wkk35AroUdUCwaFejDvMKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=kptVcvu0loe3uZf0O/ecYcMe5qqHiSvIBpPMywu/XSLhnH4alHSPRGxvHW4jxViwIAqCxiEc1aMRYIRIysNu3K6K6VTVcVsaI428WjNNuXTUyuw/wSbg/pQBRJflFxyI11j32f7nHwsSktludoppfY8jemtARDWHMUQg1+53htY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xFHUVfdW; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xFHUVfdW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736241604; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yuz34nl+myP0oLtlorIdsSfYOC6pUYxHfvspQJEx3XI=;
	b=xFHUVfdWy8zwT5DvTjjzjdS7JcTsjHfU9R5HB371Je+Fjx7n3iibDYR7z5BjMI1HPKC+gdnjM23bXHKp0MgHwybJgpRnx0ARBIW8HKpMctogyIyWgDGIIUeLhcjZaSuGXS7ow+/iOiV2nJFBwXnzSIRIkMXglUuP47TH2tudbs0=
Received: from 30.221.129.26(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNAFxiw_1736241602 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 17:20:03 +0800
Message-ID: <79b438a6-545d-4c50-88c2-a08410743ace@linux.alibaba.com>
Date: Tue, 7 Jan 2025 17:20:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove parameter parent_fe_bh from
 __ocfs2_mknod_locked
To: Su Yue <glass.su@suse.com>, akpm <akpm@linux-foundation.org>
References: <20250106140634.92241-1-glass.su@suse.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250106140634.92241-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/6 22:06, Su Yue wrote:
> The parameter is not used in __ocfs2_mknod_locked(). So remove
> it.
> 
> No functional change.
> 
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/namei.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 5550f8afa438..0ec63a1a94b8 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -508,7 +508,6 @@ static int __ocfs2_mknod_locked(struct inode *dir,
>  				struct inode *inode,
>  				dev_t dev,
>  				struct buffer_head **new_fe_bh,
> -				struct buffer_head *parent_fe_bh,
>  				handle_t *handle,
>  				struct ocfs2_alloc_context *inode_ac,
>  				u64 fe_blkno, u64 suballoc_loc, u16 suballoc_bit)
> @@ -641,8 +640,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
>  	}
>  
>  	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
> -				    parent_fe_bh, handle, inode_ac,
> -				    fe_blkno, suballoc_loc, suballoc_bit);
> +				    handle, inode_ac, fe_blkno,
> +				    suballoc_loc, suballoc_bit);
>  }
>  
>  static int ocfs2_mkdir(struct mnt_idmap *idmap,
> @@ -2576,7 +2575,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>  	clear_nlink(inode);
>  	/* do the real work now. */
>  	status = __ocfs2_mknod_locked(dir, inode,
> -				      0, &new_di_bh, parent_di_bh, handle,
> +				      0, &new_di_bh, handle,
>  				      inode_ac, di_blkno, suballoc_loc,
>  				      suballoc_bit);
>  	if (status < 0) {

