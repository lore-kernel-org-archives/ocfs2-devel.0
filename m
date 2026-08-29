Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E3FEED8
	for <ocfs2-devel@lists.linux.dev>; Sat, 29 Aug 2026 00:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787961689; cv=none; b=W1XT0joxWd2NGEPGkM37uv6hE9Xg41QJoIOEQwUxzaTdeHWsin9+937f6aIOnz6V0E5D7TAUC0VhK8It4DalzAfxwZwMyEZiISF/s8mulU7e+XhruuSO/HYiubseEGOt4QaOlNZ41p12coF1MOF4hqbg7vcEC/jWinYR/zBCtnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787961689; c=relaxed/simple;
	bh=XTtWz0UzJqkUF4/34oCqxMpiGnDoUtBqy/FaIC8xjoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyfGOe4J/ikKJyzOuiqt3T6HYgcL3gU2jeqCv2uKd/SoJe2WynSD7ygMGrHZuy9CH9U01tzz+WiNvJHGIQlDXHpjoLObr6zijhkOfPge3BnbjUPYRsxv7EPtBiv8HnPghfR/ASZG2UPh8VGSm5H8j07JMlXRcKWGHMgjzGoREeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QhwpSjb0; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QhwpSjb0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f611b3af9so183258f8f.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 17:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787961686; x=1788566486; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=78uVeNXTFjv5Imt5OX67hFUHeeD2uCgnWEQFVSHEokI=;
        b=QhwpSjb0BdNvbqVipTjL+zEHIpqoS1TZ3jha+MFzIA0mls/3pNkj7LuqgQc1ZoXF5p
         RcpZs9LpUy24Do5WAbphUt/J2y5bMf1QdJw4grs3s1AUTmrNfQNZDchoPBjXbflgr5M4
         OZdWHODnwRSCxntpS7e+KG3ZH461PHVaGjT1npPpLiiIDKxjke0ifXXZeDShRmAbckiF
         DC89Z7kjUfWfaFoftRTrzuRg5wLSuSTX23hw/PADgYcfPx0efwHadq7rP/2C+0e9fH6s
         89rjAXU1KSd1pzfr0zVX3howsD00iz/gp2VDbeZzWkPCXxhR4Xd1WzVEFv/zHYBTbBsw
         bUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787961686; x=1788566486;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=78uVeNXTFjv5Imt5OX67hFUHeeD2uCgnWEQFVSHEokI=;
        b=d5UjCrqoORwe87gZexJv8uIfsETGUqO8/nX3UseVu9agGLFkd1fOrB0p4+h6bJqRis
         SHJRvoqrKp/y9sPpfeVMtAwyqzwTcqIQGeF06GUiLitdzHihFxnp47YJkEk+hGpbJq62
         6yPDlAzfcdrD30dv8yTpBUsD0uJo3ci4pBpOOgx44dFEKe/5kgOmyzUszm5h/lva2n+3
         IFFElkFjb1vA01TlLHPz14n9nXOkhKCwYrXywMXd/9b+U++27X7J+7JeqfYpp94QeEX3
         y+cGcr+syW0s1og1UK9LwJF7FR0cHQ2wCyLaiZlH9LWkUzb5fz2/USWcRhkjgPWGMUOE
         09iQ==
X-Forwarded-Encrypted: i=1; AHgh+RqABnOT29p3utw9NypiR3sZyGJQBmgii+WGQxbq5qO3RsBmJ6yRielk5Ib5ES9CLipSze9GwYTBn+6rHA==@lists.linux.dev
X-Gm-Message-State: AFuF++nsFQ95VUy8PDqT9QfYrYp33ivLRJvJU77EyUnClTsSAyLU17j3
	b04HFgGqIkE8g1gK6Ovsr6zrV0oBh0j0Syuf2iW5F/twOwPaJ9D/40bKBKe5Io20L3E=
X-Gm-Gg: AR+sD12qYZdk/wDeONTJgCMSU+E/PjH7/nV1bR4unmtfRKFfGddpTpiUkXlKOIGqPzd
	SqD2kUj54+gUXiGfgnXA0w/5KQfESwdDs5nZOrhXoZM2jRKO/FSh/PwZRpAF0840LgXxYxsv1io
	lZ2N4xZvHvU5RoJxrFHzYYFbsVPkqXGd/nt0HfPB1xnccVbMVQ1TU3fn8cjCYtSeSqkDnXq/7qc
	UCdzkyNnA56SW7QJFuFGOizxNp27Hf9yQHiMrONoXWhp8D0jqIYzGlM0gnKvPxhwGYPCBhlW6RC
	x5UkjfDN+K6VMyQ9OsVo+obC0heOBcHxsv0Y8yGeoAT9nu6vYBLfxazD4jRq4vHwLR4czbE6J9c
	YFd3g1f61IyyF7i7u3pVW6WoCpe8DU8vAds2wBKQ2Bn8P9vw2PN4KbhFeLLvJE05UqLyR/ocuMx
	K1fWRWzXvlcxl7fokOwec8jUwQi1xreHnmn6qLnNAHwlesTn7OvgD40DyLytM=
X-Received: by 2002:a05:600c:3103:b0:499:cef6:104c with SMTP id 5b1f17b1804b1-49b91c39a77mr80523985e9.1.1787961686337;
        Fri, 28 Aug 2026 17:01:26 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8569fe78fc3sm1024562b3a.24.2026.08.28.17.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 17:01:25 -0700 (PDT)
Date: Sat, 29 Aug 2026 08:01:21 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Li Zetao <lizetao1@huawei.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ocfs2: free replay slots in ocfs2_recovery_exit()
Message-ID: <apIhL9ZVN4Hdc6Mu@p15>
References: <20260828112825.666097-1-joseph.qi@linux.alibaba.com>
 <20260828112825.666097-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828112825.666097-2-joseph.qi@linux.alibaba.com>

On Fri, Aug 28, 2026 at 07:28:24PM +0800, Joseph Qi wrote:
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
> Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
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
> -- 
> 2.39.3
> 
