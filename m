Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871402E401
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Jun 2025 03:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750132141; cv=none; b=EKSUryISEDZXDeOoAg9Hq21vY/y1Dsvsju15SwIte2JnOvH/CfexlaMhIfEg5/xE2QgQpHEeFGNp5mEQxZTCZlfkcLTGKFa+VRhX8LKmum6wyD1Cm7uLyqBr1xQQCmdEy3m7C0H/FXDQsUoeudxIqyb2nivOoJuxM7sGLrg/iKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750132141; c=relaxed/simple;
	bh=2M7MTiqBc4RPBfrzQfBTCx5dPT7Trs6Z9riiIjwwjXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XssCk/MiLE/B/kPCl0dckFWpQTDiM8P31TLkymKYtePr9gwC0YAERJ2Gbye96MdzpRffVaVRIk55X3Yq74wXx+03M4qVYMwLCTUU1f6qJfgYDvOVHYGXXd4+/97BmTSkmkzKzFG344+juRAotA3ZLWul0c4duI2ytbMQk+LlCpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KN3R4cTL; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KN3R4cTL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1750132129; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o7la/UTbSzxVsWfYAuDlnmN15TkymR90kAApitLbwzE=;
	b=KN3R4cTLnX2iAhBsu9WnVNNBrRWhR+rSYHL6xat7HSLbZ9NDcM1wIBSKirirSG8u04T5OXgohOOJrcq8wteFegnSGbyaHCmCzP0xUYoXDfTBnin2s0OH8qJNgiOwdDWY916IUoVgOlTWuOuKqXRUM5g3MpMD/pMOLn6On4JMMec=
Received: from 30.221.144.119(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0We7HhzO_1750132128 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Jun 2025 11:48:49 +0800
Message-ID: <7f5d23c0-2743-4f1f-9ab5-6b205643d8c4@linux.alibaba.com>
Date: Tue, 17 Jun 2025 11:48:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove redundant NULL check in rename path
To: Long Li <leo.lilong@huawei.com>, mark@fasheh.com, jlbec@evilplan.org,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, yangerkun@huawei.com, lonuxli.64@gmail.com
References: <20250617012534.3458669-1-leo.lilong@huawei.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250617012534.3458669-1-leo.lilong@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/6/17 09:25, Long Li wrote:
> The code checks newfe_bh for NULL after it has already been dereferenced
> to access b_data. This NULL check is unnecessary for two reasons:
> 
> 1. If ocfs2_inode_lock() succeeds (returns >= 0), newfe_bh is guaranteed
>    to be valid.
> 2. We've already dereferenced newfe_bh to access b_data, so it must be
>    non-NULL at this point.
> 
> Remove the redundant NULL check in the trace_ocfs2_rename_over_existing()
> call to improve code clarity.
> 

Looks reasonable.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/ocfs2/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 99278c8f0e24..26bc59c3a813 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1452,8 +1452,8 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
>  		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
>  
>  		trace_ocfs2_rename_over_existing(
> -		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
> -		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
> +		     (unsigned long long)newfe_blkno, newfe_bh,
> +		     (unsigned long long)newfe_bh->b_blocknr);
>  
>  		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
>  			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,

