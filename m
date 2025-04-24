Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AC12DF68
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745456725; cv=none; b=I7cq+hNqWCmRIwextqRK1Fu9jgaB00nb+c8qdFcTtRm+C8siuknsCjWgbVzJ8jQKy5HroWGSRy4z+UtWNnqsFOYyaXa7IxgA1o6bk1dA3cIO2SYnLTdFQejjzGKjseN6MEoqd+cc74pyZRB36U/RBC/5FC0qqAy+TOoULyIlqVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745456725; c=relaxed/simple;
	bh=r3R5/1tr1Pyve3xQhNOYMeyioNFHuNE/dmGDWCslzkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7HaOK47LTM/3iVgkDO6Xsp2R6LqbwQpUV32ypeYrqcqo5lQ/NYP4jN4sjUP5JYzAm8i7xCriXgGxNj+StNnXOwj67wrkU/GTkmIX8sk/Mni/nhG0N5Q2iYlsRdD/bzCe46JrS8sII7lqeUyNM4KRGJzWO8mv61jrGb8Avips9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yRdWiskC; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yRdWiskC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1745456718; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=womNuJqVm5D11UkFYrveSxxzTIS/lRcVYwoiOBQwFnU=;
	b=yRdWiskCwNjqDIL0FHNE6lg8le1DTnk77yMBRFXr+3swMjOrs8/+LO3+FtPkR6KR7rJhf+vqcKgdZD1UKjm5MMsU7x460KVOiZm4gwxLAXbWT/Xzr7oGatwHVrtWeFScTSE+/aazlONQGOwGlLLGVz0TZ6DPS8L4B9itY5SkglY=
Received: from 30.221.144.173(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WXw5vZG_1745456717 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Apr 2025 09:05:17 +0800
Message-ID: <88c01528-0817-4baa-842a-22ee24e836f0@linux.alibaba.com>
Date: Thu, 24 Apr 2025 09:05:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ocfs2: Stop quota recovery before disabling quotas
To: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
 Murad Masimov <m.masimov@mt-integration.ru>,
 Shichangkuo <shi.changkuo@h3c.com>
References: <20250422123709.15078-1-jack@suse.cz>
 <20250422124138.26027-6-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250422124138.26027-6-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/4/22 20:41, Jan Kara wrote:
> Currently quota recovery is synchronized with unmount using sb->s_umount
> semaphore. That is however prone to deadlocks because
> flush_workqueue(osb->ocfs2_wq) called from umount code can wait for
> quota recovery to complete while ocfs2_finish_quota_recovery() waits
> for sb->s_umount semaphore.
> 
> Grabbing of sb->s_umount semaphore in ocfs2_finish_quota_recovery() is
> only needed to protect that function from disabling of quotas from
> ocfs2_dismount_volume(). Handle this problem by disabling quota recovery
> early during unmount in ocfs2_dismount_volume() instead so that we can
> drop acquisition of sb->s_umount from ocfs2_finish_quota_recovery().
> 
> Reported-by: Shichangkuo <shi.changkuo@h3c.com>
> Reported-by: Murad Masimov <m.masimov@mt-integration.ru>
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> Tested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c     | 20 ++++++++++++++++++--
>  fs/ocfs2/journal.h     |  1 +
>  fs/ocfs2/ocfs2.h       |  6 ++++++
>  fs/ocfs2/quota_local.c |  9 ++-------
>  fs/ocfs2/super.c       |  3 +++
>  5 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 7511db5a46cd..f37831d5f95a 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -225,6 +225,11 @@ static void ocfs2_recovery_disable(struct ocfs2_super *osb,
>  		flush_workqueue(osb->ocfs2_wq);
>  }
>  
> +void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
> +{
> +	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
> +}
> +
>  void ocfs2_recovery_exit(struct ocfs2_super *osb)
>  {
>  	struct ocfs2_recovery_map *rm;
> @@ -1489,6 +1494,18 @@ static int __ocfs2_recovery_thread(void *arg)
>  		}
>  	}
>  restart:
> +	if (quota_enabled) {
> +		mutex_lock(&osb->recovery_lock);
> +		/* Confirm that recovery thread will no longer recover quotas */
> +		if (osb->recovery_state == OCFS2_REC_QUOTA_WANT_DISABLE) {
> +			osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
> +			wake_up(&osb->recovery_event);
> +		}
> +		if (osb->recovery_state >= OCFS2_REC_QUOTA_DISABLED)
> +			quota_enabled = 0;
> +		mutex_unlock(&osb->recovery_lock);
> +	}
> +
>  	status = ocfs2_super_lock(osb, 1);
>  	if (status < 0) {
>  		mlog_errno(status);
> @@ -1592,8 +1609,7 @@ static int __ocfs2_recovery_thread(void *arg)
>  
>  	mutex_unlock(&osb->recovery_lock);
>  
> -	if (quota_enabled)
> -		kfree(rm_quota);
> +	kfree(rm_quota);
>  
>  	return status;
>  }
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index e3c3a35dc5e0..6397170f302f 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -148,6 +148,7 @@ void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
>  
>  int ocfs2_recovery_init(struct ocfs2_super *osb);
>  void ocfs2_recovery_exit(struct ocfs2_super *osb);
> +void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
>  
>  int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
>  void ocfs2_free_replay_slots(struct ocfs2_super *osb);
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 70b2d5c8c228..6aaa94c554c1 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -310,6 +310,12 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
>  
>  enum ocfs2_recovery_state {
>  	OCFS2_REC_ENABLED = 0,
> +	OCFS2_REC_QUOTA_WANT_DISABLE,
> +	/*
> +	 * Must be OCFS2_REC_QUOTA_WANT_DISABLE + 1 for
> +	 * ocfs2_recovery_disable_quota() to work.
> +	 */
> +	OCFS2_REC_QUOTA_DISABLED,
>  	OCFS2_REC_WANT_DISABLE,
>  	/*
>  	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 2956d888c131..e272429da3db 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -453,8 +453,7 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
>  
>  /* Sync changes in local quota file into global quota file and
>   * reinitialize local quota file.
> - * The function expects local quota file to be already locked and
> - * s_umount locked in shared mode. */
> + * The function expects local quota file to be already locked. */
>  static int ocfs2_recover_local_quota_file(struct inode *lqinode,
>  					  int type,
>  					  struct ocfs2_quota_recovery *rec)
> @@ -588,7 +587,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  {
>  	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
>  					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
> -	struct super_block *sb = osb->sb;
>  	struct ocfs2_local_disk_dqinfo *ldinfo;
>  	struct buffer_head *bh;
>  	handle_t *handle;
> @@ -600,7 +598,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
>  	       "slot %u\n", osb->dev_str, slot_num);
>  
> -	down_read(&sb->s_umount);
>  	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
>  		if (list_empty(&(rec->r_list[type])))
>  			continue;
> @@ -677,7 +674,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  			break;
>  	}
>  out:
> -	up_read(&sb->s_umount);
>  	kfree(rec);
>  	return status;
>  }
> @@ -843,8 +839,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
>  	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
>  
>  	/*
> -	 * s_umount held in exclusive mode protects us against racing with
> -	 * recovery thread...
> +	 * ocfs2_dismount_volume() has already aborted quota recovery...
>  	 */
>  	if (oinfo->dqi_rec) {
>  		ocfs2_free_quota_recovery(oinfo->dqi_rec);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8bb5022f3082..3d2533950bae 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1812,6 +1812,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>  	/* Orphan scan should be stopped as early as possible */
>  	ocfs2_orphan_scan_stop(osb);
>  
> +	/* Stop quota recovery so that we can disable quotas */
> +	ocfs2_recovery_disable_quota(osb);
> +
>  	ocfs2_disable_quotas(osb);
>  
>  	/* All dquots should be freed by now */

