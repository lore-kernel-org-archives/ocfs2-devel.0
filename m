Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B828C864
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764574848; cv=none; b=FlSNEZFPlUFrd25ur2sFnSGHCRaoKDhK3DUqj4S8GJR+tz3AFk1fiyYSYun189E2VlujtxsX4vulU6Bmdqs4kguDKxGtgFCyiWtIfEqyuf9eA58fU6FdGSjpDSfPkPEEhuw2HpxjJt2jGH/4sz+ALVzmJkiKGqkKvrUiRCQnTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764574848; c=relaxed/simple;
	bh=3ccHrysIv3jYMhbeefMwCk3CNCS5TkRm+nh1IPDruCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u53sHUEWaumO8stLMJO3dypxHdB2AmOYOuaJKufnKfbeCse4nTS+8ZpuM59nKmIS82Njyvl/1nv3G1EDI5wvPF6y16Ra27D2SE3/2dxGOgkqnM+G9W4dsmYFYGlgyGJNssuxamNMe2SkrxDdI22oeNJvtD98pIzqoIaXyvOMFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RYcf7PdZ; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RYcf7PdZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764574838; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IZSrXa3dt2BVsCNnZ1f5Tr5gPEhn2Qk++WJL+oEbhOY=;
	b=RYcf7PdZgpBg+EfMVZ2nibhOmKL0ArGsQ5LjBr1hKgbPUm8kipTCo26lDXFF/aJARhUSYMW2vpQU70DOPQ203qxBk/9GxTOF0B4Bd6DeJym6duE0dgxqpkDt50JmrTUUGb4oTw6f68zIgb0PmlvYqUFSYX3318XrMQ5pDMh77NE=
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtnmdg-_1764574836 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Dec 2025 15:40:37 +0800
Message-ID: <46be391e-da73-4eee-a30b-e404653a76c2@linux.alibaba.com>
Date: Mon, 1 Dec 2025 15:40:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Syzbot test for v2 for fs: ocfs2: fix kernel BUG in
 ocfs2_find_victim_chain
To: Prithvi Tambewagh <activprithvi@gmail.com>, jlbec@evilplan.org,
 mark@fasheh.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
References: <000000000000560ff106204134d2@google.com>
 <20251201073538.47128-1-activprithvi@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251201073538.47128-1-activprithvi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/1 15:35, Prithvi Tambewagh wrote:
> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3
> 
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..f4e4ef08e0f9 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>  	}
>  
>  	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
> +	if (!le16_to_cpu(cl->cl_next_free_rec) ||
> +		le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
	    ^
Prefer to align here.

BTW, the prefix for patch title can be "ocfs2: " only.

Joseph

> +		status = ocfs2_error(ac->ac_inode->i_sb,
> +				     "Chain allocator dinode %llu has 0 chains\n",
> +				     (unsigned long long)le64_to_cpu(fe->i_blkno));
> +		goto bail;
> +	}
>  
>  	victim = ocfs2_find_victim_chain(cl);
>  	ac->ac_chain = victim;
> 
> base-commit: 939f15e640f193616691d3bcde0089760e75b0d3

