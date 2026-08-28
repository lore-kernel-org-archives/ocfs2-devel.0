Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553D3E3160
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 08:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905087; cv=none; b=qvGiO3BJ6ajDVBoz2Oh5CjqYh0+6sxfPsw1FWpKzg/BeaF45YJ5Lz2vmOiQK+0UuWkuyMlLjRTRk8c9kVgUUD9n9j33ylc4SEZ8RlEnB1jmZrtxY5LBPWMUEJhFSoylUr93cGm9xoccKsWaq7WzRa2C+K4J/3mCzwAuA15oMEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905087; c=relaxed/simple;
	bh=E3uh5dMSl5lB8wa1w3SfYQF+zxHKT7iF0fPmyAKdw5s=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=rk3aIVH6Jd2Ea2cATqDak8X2O9bai2V4he9tdKfjpZyoEhByCPB8fvOckXNnG73pHNZStQvNsGX7XaElayJooWuQazQGFkVSEZZjwl59a30GuxKScjRO6NA5ZW2uItFUE3DQTDswYNWjs+CDOnIvGE5vYizX4d+/rDBdVXXGoGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iqg/IkxR; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iqg/IkxR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787905076; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=Hl/xWp7o0V5c9DhHxf8+TpCNwaALGvLpkx6fF+2bN8s=;
	b=iqg/IkxRzSGxXOYgAq9sqv+8FDrhnm5Wla60KNXuM9E2tnhVQvJpww0aQtZQK1cravTa8YhLWwvyhuUvPCylFHedZH5P7fRfoxLNDCKtE/W3dGJQEjISdRGHZCx9LUW0qMYufb854raw1Uw9pqkZYujYwrfsNc5TICf7JM2+WqM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9lrTvy_1787905075;
Received: from 30.221.129.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9lrTvy_1787905075 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 16:17:55 +0800
Message-ID: <abac1aed-17bc-48c2-9912-9dbc8af44302@linux.alibaba.com>
Date: Fri, 28 Aug 2026 16:17:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: exit recovery thread on mount error path
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260828071553.262254-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20260828071553.262254-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/28/26 3:15 PM, Joseph Qi wrote:
> When a mount fails after the cluster connection has been established,
> e.g. in ocfs2_mount_volume(), ocfs2_fill_super() unwinds via
> out_debugfs/out_super and frees the osb without disabling recovery.
> 
> A node failure event can concurrently launch the recovery thread, which
> blocks in __ocfs2_wait_on_mount() waiting for the volume state to
> become VOLUME_MOUNTED or VOLUME_DISABLED.  As the mount error path
> neither sets VOLUME_DISABLED nor wakes osb_mount_event, the thread can
> never make progress: the kthread leaks and stays blocked on the wait
> queue embedded in the freed osb, which may then be accessed as freed
> memory.
> 
> Fix it by setting VOLUME_DISABLED and waking osb_mount_event on this
> path so the thread bails out, and replace the plain
> kfree(osb->recovery_map) with ocfs2_recovery_exit(), which waits for a
> running recovery thread to exit before the recovery map is freed.
> 
> Fixes: f1e75d128b46 ("ocfs2: rewrite error handling of ocfs2_fill_super")
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/super.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c62e389d4dd6..f785c39d1fb8 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1169,8 +1169,17 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  out_debugfs:
>  	debugfs_remove_recursive(osb->osb_debug_root);
>  out_super:
> +	/*
> +	 * A recovery thread launched by a node failure event may still be
> +	 * waiting for the volume to be mounted.  Set VOLUME_DISABLED and
> +	 * wake it up, then wait for it to exit before osb is freed,
> +	 * otherwise the kthread would leak and stay blocked on the wait
> +	 * queue embedded in the freed osb.
> +	 */
> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> +	wake_up(&osb->osb_mount_event);
>  	ocfs2_release_system_inodes(osb);
> -	kfree(osb->recovery_map);
> +	ocfs2_recovery_exit(osb);
>  	ocfs2_delete_osb(osb);
>  	kfree(osb);
>  out:

Sashiko has found 2 more issues:
https://sashiko.dev/#/patchset/20260828071553.262254-1-joseph.qi@linux.alibaba.com?part=1

But both are pre-existing issues, so I'd rather fix them in a separate
thread. More specifically,
1. The double free race of osb->replay_map looks real, will send a fix
later.
2. The early return on ocfs2_super_lock() failure leaks resources,
forcing teardown of cluster state would be worse than the leak, so I'd
keep as it is.

Thanks,
Joseph


