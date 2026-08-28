Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A613DA5A0
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915997; cv=none; b=HLU6kSyWcyqHm/6Z1Lr80+F+OcdoDlChShPCwfOBapaOkID66IBGct2W9h6RTUyNgIDsV8P1TGRpmQq4zL9AichZjbDN4uoUuYkMYMczyxb/2lEV0ho/fgCdXttKeatpZoDdh50LBUazMSbs3dSthKy2uxKPPRtXZxMudcncWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915997; c=relaxed/simple;
	bh=cF3HWeih9mizQlhC0lAduMfJmoJV7rRyfj5WKrFSU5E=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EGoxj8k5J4mNAqRr6ULlN/Vx4Rz47HAhsNReD+TFN5ho3s9h6U9jPra6VrcD4Rr504jcYSb/yJgTE7VFVFQf5qjq03yL85eFyYtoy6B7s5NIakef5UHx7roOrX3tbnMThw6wFvuxcVSNSHjQ5dodraRLUAXSiPOoOKclOOW1Cv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xhVEicbA; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xhVEicbA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787915991; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=IAQkJiwpeJjLw8BqNQqw/tgT0NrjBIcarZuenlfD0CE=;
	b=xhVEicbAzkGF8RAfGvs54NVAG+Ky8zIzbuGW7RrVkAU8+WhsFAJYJKNZ/CWwiDX+BD2ww34GIL2idF13n8MvcJC+wRfZED6uevuv4t89U0Xn7JSwB0nPcDu6YQ3JoYxClvah/2deIbMZomp3r0J0Mt0us9fJ0hI6QJoDWpNUReA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X9mEGS6_1787915990;
Received: from 30.221.129.54(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9mEGS6_1787915990 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 19:19:50 +0800
Message-ID: <5994ae88-8e0e-4bf4-a543-2b5201848138@linux.alibaba.com>
Date: Fri, 28 Aug 2026 19:19:49 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: free replay slots in ocfs2_recovery_exit()
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>, Li Zetao <lizetao1@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260828100114.530941-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20260828100114.530941-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/28/26 6:01 PM, Joseph Qi wrote:
> Commit ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
> added ocfs2_free_replay_slots() calls to the mount error paths
> out_dismount and out_check_volume to fix a leak of osb->replay_map.
> However these calls are unlocked while the bail path of the recovery
> thread, which is woken up by out_dismount right before the call, also
> frees the replay slots under osb->recovery_lock.  Both sides can thus
> observe a non-NULL osb->replay_map and trigger a double free.
> 
> Fix this by moving ocfs2_free_replay_slots() into ocfs2_recovery_exit()
> after ocfs2_recovery_disable(), which waits for a running recovery
> thread to exit under osb->recovery_lock, and drop the unlocked call
> sites.  Both ocfs2_dismount_volume() and the out_super path of
> ocfs2_fill_super() call ocfs2_recovery_exit(), so the replay slots are
> freed on every path.  Since super.c no longer references it, make
> ocfs2_free_replay_slots() static again.
> 

Sashiko has review comments:
https://sashiko.dev/#/patchset/20260828100114.530941-1-joseph.qi@linux.alibaba.com?part=1

This is because it is base on patch:
  "ocfs2: exit recovery thread on mount error path"

I'll resend them as a series.

Thanks,
Joseph

> Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c | 3 ++-
>  fs/ocfs2/journal.h | 1 -
>  fs/ocfs2/super.c   | 5 +----
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index d8afbc1a76bb..a3938a03e93b 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -156,7 +156,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
>  	replay_map->rm_state = REPLAY_DONE;
>  }
>  
> -void ocfs2_free_replay_slots(struct ocfs2_super *osb)
> +static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
>  {
>  	struct ocfs2_replay_map *replay_map = osb->replay_map;
>  
> @@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  	/* XXX: Should we bug if there are dirty entries? */
>  
>  	kfree(rm);
> +	ocfs2_free_replay_slots(osb);
>  }
>  
>  static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index f8b3b2a3d630..19fc920d26b1 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -151,7 +151,6 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb);
>  void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
>  
>  int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
> -void ocfs2_free_replay_slots(struct ocfs2_super *osb);
>  /*
>   *  Journal Control:
>   *  Initialize, Load, Shutdown, Wipe a journal.
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index f785c39d1fb8..6a8092b65bb5 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1162,7 +1162,6 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  out_dismount:
>  	atomic_set(&osb->vol_state, VOLUME_DISABLED);
>  	wake_up(&osb->osb_mount_event);
> -	ocfs2_free_replay_slots(osb);
>  	ocfs2_dismount_volume(sb, 1);
>  	goto out;
>  
> @@ -1776,14 +1775,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  	status = ocfs2_truncate_log_init(osb);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto out_check_volume;
> +		goto out_system_inodes;
>  	}
>  
>  	ocfs2_super_unlock(osb, 1);
>  	return 0;
>  
> -out_check_volume:
> -	ocfs2_free_replay_slots(osb);
>  out_system_inodes:
>  	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>  		ocfs2_shutdown_local_alloc(osb);

