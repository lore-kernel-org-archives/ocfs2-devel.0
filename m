Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8062701BA
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 01:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745456424; cv=none; b=nIkiyVIdDOBpDOPW3l1XMauzI+C+3+BDCD81wU7P986qcUpk6giLKAfA+YdVHYmZKfxLWEfJlL7kdfsRWtakar2OX9rChh1VQi9mO+/kVlY+bOfHDsE/wts7WpJg8aa8PwO3Uipsl6dlWQeb5QNYKjKxnyBliIJcI8VAzcU+1Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745456424; c=relaxed/simple;
	bh=Wo+HMsG0G2FWjTPA6ELY77N3l3FSFHJ6OWo4dfJ9HCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IcfGc6HB8rkRB2xSXduR48GXT+BL5bJzKF+6kY4VVWPuyoZ0I19XJOEdKbbs57mTcKmJWpBRSo2scdDu8HpAajgkhW5S+iwCNiPTOCJltQbjmHQpw7lD09YobDcET9oZeHTRIaoAjam+UAHNWMZ+jdaQCm9IAYh1B/o5lROPIJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nQeB7/Co; arc=none smtp.client-ip=47.90.199.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nQeB7/Co"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1745456400; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VqkgaRoEFxTdW3mBpXwbbny1m92bl5ju/hCZOURE94U=;
	b=nQeB7/CoRmIaSyQW30rsMVbKegPMhIX5Am26O5+RwmU+fP17hIpsjw2VfmwXKmT7oJ9mvGHjEMkxiYTBN3Ekzr91t4qYq7+ETXpRxj9xgrKlXPr+HEdocz/5fdHpXTWuiTRKwahYPZAd49OwN8sgf7vMjZnPIBtQWV3S7r191gw=
Received: from 30.221.144.173(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WXwDF3r_1745456399 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Apr 2025 08:59:59 +0800
Message-ID: <0b4d7927-e8cd-46c8-b751-ac6bc7fc82c2@linux.alibaba.com>
Date: Thu, 24 Apr 2025 08:59:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] ocfs2: Switch osb->disable_recovery to enum
To: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
 Murad Masimov <m.masimov@mt-integration.ru>,
 Shichangkuo <shi.changkuo@h3c.com>
References: <20250422123709.15078-1-jack@suse.cz>
 <20250422124138.26027-4-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250422124138.26027-4-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/22 20:41, Jan Kara wrote:
> We will need more recovery states than just pure enable / disable to fix
> deadlocks with quota recovery. Switch osb->disable_recovery to enum.
> 
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> Tested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c | 14 ++++++++------
>  fs/ocfs2/ocfs2.h   |  7 ++++++-
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f1b4b3e611cb..8986e813ab2c 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -174,7 +174,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>  	struct ocfs2_recovery_map *rm;
>  
>  	mutex_init(&osb->recovery_lock);
> -	osb->disable_recovery = 0;
> +	osb->recovery_state = OCFS2_REC_ENABLED;
>  	osb->recovery_thread_task = NULL;
>  	init_waitqueue_head(&osb->recovery_event);
>  
> @@ -206,7 +206,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  	/* disable any new recovery threads and wait for any currently
>  	 * running ones to exit. Do this before setting the vol_state. */
>  	mutex_lock(&osb->recovery_lock);
> -	osb->disable_recovery = 1;
> +	osb->recovery_state = OCFS2_REC_DISABLED;
>  	mutex_unlock(&osb->recovery_lock);
>  	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
>  
> @@ -1582,14 +1582,16 @@ static int __ocfs2_recovery_thread(void *arg)
>  
>  void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>  {
> +	int was_set = -1;
> +
>  	mutex_lock(&osb->recovery_lock);
> +	if (osb->recovery_state < OCFS2_REC_DISABLED)
> +		was_set = ocfs2_recovery_map_set(osb, node_num);
>  
>  	trace_ocfs2_recovery_thread(node_num, osb->node_num,
> -		osb->disable_recovery, osb->recovery_thread_task,
> -		osb->disable_recovery ?
> -		-1 : ocfs2_recovery_map_set(osb, node_num));
> +		osb->recovery_state, osb->recovery_thread_task, was_set);
>  
> -	if (osb->disable_recovery)
> +	if (osb->recovery_state == OCFS2_REC_DISABLED)
>  		goto out;
>  
>  	if (osb->recovery_thread_task)
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 51c52768132d..e713361939f0 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -308,6 +308,11 @@ enum ocfs2_journal_trigger_type {
>  void ocfs2_initialize_journal_triggers(struct super_block *sb,
>  				       struct ocfs2_triggers triggers[]);
>  
> +enum ocfs2_recovery_state {
> +	OCFS2_REC_ENABLED = 0,
> +	OCFS2_REC_DISABLED,
> +};
> +
>  struct ocfs2_journal;
>  struct ocfs2_slot_info;
>  struct ocfs2_recovery_map;
> @@ -370,7 +375,7 @@ struct ocfs2_super
>  	struct ocfs2_recovery_map *recovery_map;
>  	struct ocfs2_replay_map *replay_map;
>  	struct task_struct *recovery_thread_task;
> -	int disable_recovery;
> +	enum ocfs2_recovery_state recovery_state;
>  	wait_queue_head_t checkpoint_event;
>  	struct ocfs2_journal *journal;
>  	unsigned long osb_commit_interval;

