Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4C426D24
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 May 2026 06:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778565969; cv=none; b=Nvy4W/uQGxn8r2k4D2o/U02UlNgS2bxi12jMK9H0K/JYYzlkkNXeR1Pfht59779pQLGhwsKfjnd5AzPjV+1vCsAaTQGdSQp78xXU3ao4m0tqBBJXrYfiiflkxi9GwJumkmhhtq6v5YUx/LScr6qxOGas0vtKzZgGcPfxIwL+YuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778565969; c=relaxed/simple;
	bh=3oB0PzZe3o/36G7aKNI6jU5IOq990EB+Fik76ttcf4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pbiHOig9gvNNCmMGGA291ihsTtb8Cd/MX3EPaqiCJTvrZ4pkuoQ43ajvFWfHxJd7NEYVUwLbb+HC39kyAj49g6w2OWwJxqpZXiH9iEcmZbqUyHgrYSjCk2ZMswCzk91Pik4Cilf/q8RL5/aOw8JwXL9tYSpX9He5D776T0gqWOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vHRMtTBv; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vHRMtTBv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778565947; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wt/bMoK2CCqqjpF9Xxrpj9q3mkJq5v63m3/5gPPotB4=;
	b=vHRMtTBvxnw7QkLEKiNJef4T49uph6MQdTIh6ZNdArLpeeSutZCsibNhbzCM8Xar7ccaoVI/TVDZaxsZT1/ycegaHGWsM1NJrO3v3pkvJJ0Geb9C9gx0gpbjegeeaOpL82zfJDrei5bgHRWJCGlTujVSMIVtKpfCI6OJbbxmWbs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2pR5gq_1778565945;
Received: from 30.221.129.93(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X2pR5gq_1778565945 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 14:05:46 +0800
Message-ID: <ae7d61d2-2aca-426a-8bc1-5a7e2135e265@linux.alibaba.com>
Date: Tue, 12 May 2026 14:05:45 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: don't BUG_ON an invalid journal dinode
To: ZhengYuan Huang <gality369@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
References: <20260512024115.4036371-1-gality369@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260512024115.4036371-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/12/26 10:41 AM, ZhengYuan Huang wrote:
> [BUG]
> A fuzzed OCFS2 image can corrupt the current slot journal dinode while
> mount is still in progress. The mount path first reports the invalid
> journal block and then crashes in shutdown:
> 
> kernel BUG at fs/ocfs2/journal.c:1034!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
> Call Trace:
>  ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
>  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
>  ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
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
> ocfs2_journal_toggle_dirty() used to return -EIO when journal->j_bh no
> longer contained a valid dinode, because the startup and shutdown paths
> already handled that failure. Commit 10995aa2451a
> ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.") changed
> the check to a BUG_ON() under the assumption that the journal dinode had
> already been validated. That turns an unexpected invalid journal dinode
> during mount teardown into a kernel crash instead of a normal mount
> failure.
> 
> [FIX]
> Replace the BUG_ON() with WARN_ON() and return -EIO. This keeps the
> invariant warning for debugging, but restores the original behavior of
> failing startup or shutdown cleanly instead of panicking the kernel.
> 
> Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

The 'Fixes' tag may not needed. Other looks fine to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> v2:
> - Drop the full dinode revalidation and use WARN_ON plus -EIO instead
> - Rework the rationale around the historical BUG_ON conversion
> - Add a Fixes tag for the commit that replaced the old error return
> ---
>  fs/ocfs2/journal.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f9bf3bac085d..fc54cc798ce3 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1022,11 +1022,8 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
>  	struct ocfs2_dinode *fe;
>  
>  	fe = (struct ocfs2_dinode *)bh->b_data;
> -
> -	/* The journal bh on the osb always comes from ocfs2_journal_init()
> -	 * and was validated there inside ocfs2_inode_lock_full().  It's a
> -	 * code bug if we mess it up. */
> -	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
> +	if (WARN_ON(!OCFS2_IS_VALID_DINODE(fe)))
> +		return -EIO;
>  
>  	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
>  	if (dirty)

