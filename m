Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1A0B665
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575101; cv=none; b=hF+3C0wbrJtA7uUDfMubm7wZ6VaW5dT/yRpKypBgF8NaVTvXMsm7veSKTe5eX2lrT9tDzPskVVVb7rD+XK7mOSy1tW5FZgBP0fHsNj8JFkr+coT56+PY9VxaYim0Wlw4jikc+lx/z2n1aPnyvAUMNM8xeyR399IKRqmDfzKVrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575101; c=relaxed/simple;
	bh=ZbArbbV3yorjTKFyb36xndw6Gkgc1uZVkmF/s99xooM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQAKpfdJEPG4Z8b7PigDQbgZ0IbJHV/irjPPFLBBm8KhzSNX5YN0FAbL9otOyO1/bZclIiz5IZz9BlDGelY2/Ri1HggHFjHeebexshNDP0jufarqQPQXLXa8c1xyzInYTVBy0wWncfQsi2C2wOvkDExSi2oK5+S8/TnO7EzQIy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=N/55xl1V; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="N/55xl1V"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734575096; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ck4ON6qKb1rZXZEhZ7LwxnXEdLKblYXLYD8/jclut8c=;
	b=N/55xl1VhvEVRsxRA6epMe+lif226R8db4WEG7VSxyb9CRvnAI/sCFElA+dAS+UBWp760yLxxKXnA138pQUbE9s9GwbQcAVUb7CTg8id43beRkZoo+HFt4xuKj46dzaPMmLLsm3E7Pc4agZ4fR4iEtiAaHVYPHRaFNwkkbdr/mA=
Received: from 30.221.145.61(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WLoZtHq_1734575093 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Dec 2024 10:24:54 +0800
Message-ID: <f61955e5-9cfe-41af-aece-283b811817a8@linux.alibaba.com>
Date: Thu, 19 Dec 2024 10:24:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix slab-use-after-free due to dangling pointer
 dqi_priv
To: Dennis Lam <dennis.lamerice@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
References: <20241218023924.22821-2-dennis.lamerice@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20241218023924.22821-2-dennis.lamerice@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/18 10:39, Dennis Lam wrote:
> When mounting ocfs2 and then remounting it as read-only, a
> slab-use-after-free occurs after the user uses a syscall to
> quota_getnextquota. Specifically, sb_dqinfo(sb, type)->dqi_priv is the
> dangling pointer.
> 
> During the remounting process, the pointer dqi_priv is freed but is
> never set as null leaving it to to be accessed. Additionally, the
> read-only option for remounting sets the DQUOT_SUSPENDED flag instead of
> setting the DQUOT_USAGE_ENABLED flags. Moreover, later in the process of
> getting the next quota, the function ocfs2_get_next_id is called and
> only checks the quota usage flags and not the quota suspended flags.
> 
> To fix this, I set dqi_priv to null when it is freed after remounting
> with read-only and put a check for DQUOT_SUSPENDED in ocfs2_get_next_id.
> 
> Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
> Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
> Tested-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6731d26f.050a0220.1fb99c.014b.GAE@google.com/T/

Fixes: 8f9e8f5fcc05 ("ocfs2: Fix Q_GETNEXTQUOTA for filesystem without quotas")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changes in v2:
> - replaced dquot suspended check with !sb_has_quota_active instead
> - link to v1: https://lore.kernel.org/lkml/20241215035828.106936-2-dennis.lamerice@gmail.com/
> 
>  fs/ocfs2/quota_global.c | 2 +-
>  fs/ocfs2/quota_local.c  | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 2b0daced98eb..096b799d60a0 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -893,7 +893,7 @@ static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
>  	int status = 0;
>  
>  	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
> -	if (!sb_has_quota_loaded(sb, type)) {
> +	if (!sb_has_quota_active(sb, type)){
>  		status = -ESRCH;
>  		goto out;
>  	}
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 73d3367c533b..2956d888c131 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -867,6 +867,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
>  	brelse(oinfo->dqi_libh);
>  	brelse(oinfo->dqi_lqi_bh);
>  	kfree(oinfo);
> +	info->dqi_priv = NULL;
>  	return status;
>  }
>  

