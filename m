Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A249728382
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 04:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745294747; cv=none; b=Gd3wCgCKgQEMLyaxCFVJ5Qd5uwLWMpvj9k/RspWR0kKlcRaGYxrMfYFlYy92P2XB0aT/6+i4C5BlKafiRdsQYMx55ujV+6EC9MMTbmC44Jvk3y4IOmm+cqlCPeHCNnsr0Uj0QclkRCKaJSQyhcT87EtxkkScax/hAgcp3XS1kgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745294747; c=relaxed/simple;
	bh=I0BER7p2A+ycPH54D3gEXivihm1E68f05c8x2z0Qp2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjENZ0FloV+ID5B1gWu4rkSd6ximYLqjM+9LctiwPOEdQI6A5iYPxSjkrwZtrov0SBT+a3DjNaTqeeijIO9Y7khUqbvhjBrMoxglQ6Ac7gQYbUp6uDnUWIwYmtjB4r1h8zmsu2U4mAzKuJbBOx+GpJfl8TGCUgEaKkLDY08nbSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gEX9bfW6; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gEX9bfW6"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3913290f754so604741f8f.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Apr 2025 21:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745294743; x=1745899543; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qtk/8lFUuwWwvYU88HlLqVpM/8s8wlHjcBQbjAX43DM=;
        b=gEX9bfW6mTDiVRN9u5MOZ5T2XJwL6skoE8o27XIeLVqa4eHX1Z3sp5dTMXboRxelu1
         QLjIEVM8padBLx6VdWdgjqnnmtmmzC/z9dggwASJDw7++XoLPsFsHJPYCd5UbmyEVBQp
         7GfzWaDOyw4oON373PaAa3OlhcU8jaSnVN+o9IG+c7rk4rDs0EtWAIHaJDA0wew1exHd
         Urp2nKtJPmxz+I6dvEXlVJrzxZgr2D8Eg2KJx5HbqP3KPy+N51klKtxuEcMsTRzXXXRw
         HSZ2DFAY0vfN5IM72Z7PCbTXVeEkY/eYkFSfKp48VuRZReNuOoRz8CBZ1Sn8poVLzsy8
         RxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745294743; x=1745899543;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtk/8lFUuwWwvYU88HlLqVpM/8s8wlHjcBQbjAX43DM=;
        b=MMxNkgIM20UXFmtxlqcLvT5kM/+M6AcncLVrXX+4I1VdFX20DLWBCm1vlrom+D/ITw
         IcK6/bWVCPo9NltDhhI2HuT4tNbcuon3Ev7TzYDYk/TllhN+DjN8T8vP6uuwt3MFuOjR
         rsLvkpf85yCJE9EyvPdOBpP/buKTccAlgJkOxoMOCTFWB7HRQSMH18JmU1NdHnZw3o9K
         QDEeMbc1YZfHc45BqPIGJaB0d8mq4C7wuEgc/FpV6OEOFChzbcIxTz3yT8SJ5nhxQ6W8
         G9J9Ml5qNq+yIcUJ7gpCQQmWc13QZngK7719DwqaJjDMozMcYfuDv2r3QHANkqaeAjSe
         4Gig==
X-Forwarded-Encrypted: i=1; AJvYcCVYa38hxy9Z4xXZKfbZsPWrRTjFpp2Jckb3J5Dbwb0FiXBCncdh7G448ifSNmkWHf+cYWyM1AIlliKm6A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxOnwRa6C/x/9le8c+VZH9KY7xyBeSQksdT3WJgyHBpwm5JVCyz
	+CBFwuHV2NojttMmq6C9eeL/jqlD9VnoGNVDNc7Qfl82Aux3P16hkyxUJY8nWG0=
X-Gm-Gg: ASbGncvCPnFJ6i/Cvw2h713MR6mp/1iGMc4++Kd+nCSW/LqnivoX6BLTuIeecfk8yp2
	PKPuHSDWSRGlgGkFKKm8xNC5DZSdWub+yH87cASeCA79l9XCphq67n6YiGTQURjwJ6i64gXTh4u
	+MANyMq3iWsOVcRoSdnXRDiEF35uKfem0k4Y9DkKuYTFupW0Jc0kjIPZv4oQ5uPIFM8jxbfJuVi
	HTl3vpdNgyHn0Poqs+veaTILN0wkm5Z6QhXVFXv9cG8/bnW543LyaGPH8ObYO/9EVK6ep7gFknX
	fSzAbs3SeTiVXNrZfhaomTwHAZAngxvDHQEnVDmkKO96hoc=
X-Google-Smtp-Source: AGHT+IFJuMxnx09/LKoyzpJJorHw7G0MfP+YnlGc6zJmmOTLlhbL2CTjsLSie+qkuN75r8lhYFZ0GQ==
X-Received: by 2002:a05:6000:250e:b0:39c:12ce:697 with SMTP id ffacd0b85a97d-39efba5aee6mr3700438f8f.7.1745294742866;
        Mon, 21 Apr 2025 21:05:42 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bdac20sm74415375ad.2.2025.04.21.21.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 21:05:42 -0700 (PDT)
Message-ID: <7080c846-5545-4428-af8b-ff6b0ba9f100@suse.com>
Date: Tue, 22 Apr 2025 12:05:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ocfs2: Stop quota recovery before disabling quotas
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev,
 Shichangkuo <shi.changkuo@h3c.com>
References: <20250403112908.13750-1-jack@suse.cz>
 <20250403113250.20572-6-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250403113250.20572-6-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 19:32, Jan Kara wrote:
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
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/journal.c     | 20 ++++++++++++++++++--
>   fs/ocfs2/journal.h     |  1 +
>   fs/ocfs2/ocfs2.h       |  6 ++++++
>   fs/ocfs2/quota_local.c |  9 ++-------
>   fs/ocfs2/super.c       |  3 +++
>   5 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index bed57687cc60..9e41d0f9b757 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -225,6 +225,11 @@ static void ocfs2_recovery_disable(struct ocfs2_super *osb,
>   		flush_workqueue(osb->ocfs2_wq);
>   }
>   
> +void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
> +{
> +	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
> +}
> +
>   void ocfs2_recovery_exit(struct ocfs2_super *osb)
>   {
>   	struct ocfs2_recovery_map *rm;
> @@ -1489,6 +1494,18 @@ static int __ocfs2_recovery_thread(void *arg)
>   		}
>   	}
>   restart:
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
>   	status = ocfs2_super_lock(osb, 1);
>   	if (status < 0) {
>   		mlog_errno(status);
> @@ -1592,8 +1609,7 @@ static int __ocfs2_recovery_thread(void *arg)
>   
>   	mutex_unlock(&osb->recovery_lock);
>   
> -	if (quota_enabled)
> -		kfree(rm_quota);
> +	kfree(rm_quota);
>   
>   	return status;
>   }
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index e3c3a35dc5e0..6397170f302f 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -148,6 +148,7 @@ void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
>   
>   int ocfs2_recovery_init(struct ocfs2_super *osb);
>   void ocfs2_recovery_exit(struct ocfs2_super *osb);
> +void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
>   
>   int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
>   void ocfs2_free_replay_slots(struct ocfs2_super *osb);
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 70b2d5c8c228..6aaa94c554c1 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -310,6 +310,12 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
>   
>   enum ocfs2_recovery_state {
>   	OCFS2_REC_ENABLED = 0,
> +	OCFS2_REC_QUOTA_WANT_DISABLE,
> +	/*
> +	 * Must be OCFS2_REC_QUOTA_WANT_DISABLE + 1 for
> +	 * ocfs2_recovery_disable_quota() to work.
> +	 */
> +	OCFS2_REC_QUOTA_DISABLED,
>   	OCFS2_REC_WANT_DISABLE,
>   	/*
>   	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 2956d888c131..e272429da3db 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -453,8 +453,7 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
>   
>   /* Sync changes in local quota file into global quota file and
>    * reinitialize local quota file.
> - * The function expects local quota file to be already locked and
> - * s_umount locked in shared mode. */
> + * The function expects local quota file to be already locked. */
>   static int ocfs2_recover_local_quota_file(struct inode *lqinode,
>   					  int type,
>   					  struct ocfs2_quota_recovery *rec)
> @@ -588,7 +587,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>   {
>   	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
>   					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
> -	struct super_block *sb = osb->sb;
>   	struct ocfs2_local_disk_dqinfo *ldinfo;
>   	struct buffer_head *bh;
>   	handle_t *handle;
> @@ -600,7 +598,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>   	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
>   	       "slot %u\n", osb->dev_str, slot_num);
>   
> -	down_read(&sb->s_umount);
>   	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
>   		if (list_empty(&(rec->r_list[type])))
>   			continue;
> @@ -677,7 +674,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>   			break;
>   	}
>   out:
> -	up_read(&sb->s_umount);
>   	kfree(rec);
>   	return status;
>   }
> @@ -843,8 +839,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
>   	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
>   
>   	/*
> -	 * s_umount held in exclusive mode protects us against racing with
> -	 * recovery thread...
> +	 * ocfs2_dismount_volume() has already aborted quota recovery...
>   	 */
>   	if (oinfo->dqi_rec) {
>   		ocfs2_free_quota_recovery(oinfo->dqi_rec);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 8bb5022f3082..3d2533950bae 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1812,6 +1812,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
>   	/* Orphan scan should be stopped as early as possible */
>   	ocfs2_orphan_scan_stop(osb);
>   
> +	/* Stop quota recovery so that we can disable quotas */
> +	ocfs2_recovery_disable_quota(osb);
> +
>   	ocfs2_disable_quotas(osb);
>   
>   	/* All dquots should be freed by now */

