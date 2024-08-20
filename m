Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7411E507
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 00:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198474; cv=none; b=QzZpuaF6X5isqnyCi3SwcYtUVa+go2RZNGrZmoSXYn778HH7k+imt0Wah3762AgZZVE7jU0hSmKZ6O4B1HhKXRs/TvySEcGdxp1OqrAQrkP7dE5WXpgx7wWOFLjyzIl2K71N51Lt8ZX7FbHMJN+vvn/Gv4YX8dwH4eo40TCYhZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198474; c=relaxed/simple;
	bh=6NP0d5pzDlhfKsMoiY0GMxdxnmKALz0Fx+ak5WzsELo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lugL8nHGmOqMZBzh0H8/6TdYagdUrYaKiCPRxdWfNO/e3Y9veBoMPcPApn+SL2JaF93fGTC9VFeCPlBwPh514yF6RT1EUqKYCPs3+D1AEjsR47dCTH2k3zO96uyhxbwA6VZqDsbZaaH4pT8nIOumXxW7hhuMCaCfOaUbdS1k5dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H940xaeP; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H940xaeP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724198468; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pdQnvwC2OPWvP4XcVr70GTE2wb0YbxSFUpju1heYibw=;
	b=H940xaePC0MAq7NAlTASoq3q2VJrSx72HwfykxXxurSFsV3tf9eXCB+AR4R+BLQZOyU5O3puuHAIYwKuw+sWK2kPo/GuyhuCa7bKMyUaTg8Zc5v0lqXwN0NFDLN+SS7ppeih0Xhh0/CERoUOtH/JP1aLdTqW7EkiPyOKGfC4ce8=
Received: from 30.171.230.57(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDJj8yr_1724198149)
          by smtp.aliyun-inc.com;
          Wed, 21 Aug 2024 07:55:50 +0800
Message-ID: <6b5b86fe-ffed-4cc9-b73c-ad6ee7bf68f5@linux.alibaba.com>
Date: Wed, 21 Aug 2024 07:55:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/2] ocfs2: remove unreasonable unlock
To: Lizhi Xu <lizhi.xu@windriver.com>, heming.zhao@suse.com,
 akpm <akpm@linux-foundation.org>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
 <20240820094512.2228159-1-lizhi.xu@windriver.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240820094512.2228159-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 5:45 PM, Lizhi Xu wrote:
> There was a lock release before exiting, so remove the unreasonable unlock.
> 
> Reported-and-tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/buffer_head_io.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index cdb9b9bdea1f..e62c7e1de4eb 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>  		if (bhs[i] == NULL) {
>  			bhs[i] = sb_getblk(sb, block++);
>  			if (bhs[i] == NULL) {
> -				ocfs2_metadata_cache_io_unlock(ci);
>  				status = -ENOMEM;
>  				mlog_errno(status);
>  				/* Don't forget to put previous bh! */
