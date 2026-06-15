Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937483BE148
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jun 2026 07:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781508766; cv=none; b=a1kPKGz8fbVeil5ix0PZY9fYfi/8LnNgTh6O/Z+TAilRTqzp/rrJNdwO2nDbTChmQtqxSuFUEhkGktFwg+NyuHeFueeEQ4PMtVxgmKB67zy4ojTIpVH+H/jt7vJcK47+7shpf75/PIH40x/8TXGkhD48DBaS/JJXUB3PYPiVJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781508766; c=relaxed/simple;
	bh=ZnGzfuyEseRd2ZP5K74fMhOls3WDneczoAr/BXXD/KY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVhvgzAMS+lKocQLsyVslBLHcYpLnhu1ELuAjSGvsKafAegBjjwfHawGhc/GzzyPW4UXkH17R2ExQkCPYwxCtWuqT+qVkSxvNllT8IQjLaTN7l4eYhWVtuQMUZqhWuVo/T+v4luL0G7/w8X+3SiiS7c8LdWUP/qxOXCUwAu6Z90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HKu9aDeq; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HKu9aDeq"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490c737bcafso2953115e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jun 2026 00:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781508763; x=1782113563; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb3jjJ2r77wI8k5RgZUxlmRUzvui3UL+pEHdI+mwdI4=;
        b=HKu9aDeqI2E7hWrnQSUi96AYX707i95laHO61kaSVuynDuwYtbBzbW899oSbmMEyAF
         cgw55wC2k6zWaUUg0N/kp1cgn6uNcpdjskxHMASAl1GcmmAFvLGYTdia10FDEjtt8e95
         XhQ92zcrgxQZerl0+2KGGSOSvOuFFVoQcW8dHS/0P8NXNTbK67eT4tEFMdNPwd+uqVhV
         aCgVquZRg89RX9FjUqGbBkxdW2dYcf8Mntuyq5PJsFPRAdkII3mJW0O1mv0sT4Rzt9s6
         3rxjedufE+R15Tw++e7Ke+pKtmIde6SPvMz50Omc05nJKtxsEg3/wl7I42GHjj+6rtrN
         x9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781508763; x=1782113563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sb3jjJ2r77wI8k5RgZUxlmRUzvui3UL+pEHdI+mwdI4=;
        b=VoxLciJvnTstS4WDLDEKufJrc2JI26DL2WhwAVhdBRVYCGMeyohkshjDGwGDv68IsH
         LgQ9fng+C3NYn3z0yDd9pd+eV80sro2+eS77BQRQ/gV+1ta4Nh+zQVyXiTrfWjcU11dp
         U1upziFJzHytcAk1g1bW3zZz9pmI5NYXi7KkUqOaj/VbEX17hlXrEP1amN1zAeMv0uM9
         /hrUGZcDoYk929BveiCd6RiKPceBX4VXdYp/lCKJpep+b7OSRX3mlHmhU9kc542qDTfY
         4HWL1d2y8Uy6sknpCZWXxk439FnkWg/OIO1qvB26eR3wR6Jcwgn2EBdhR8lyC+gXhs4H
         srXg==
X-Forwarded-Encrypted: i=1; AFNElJ/JFqBpILh6JLZmmlEM6r6yQ6TGv9f2bRLZSVV1DpgAwNiRwu/05DADVu5axPh7RfYWM8X5OXHMe/fkSg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWAqdPVre3l7YsdfGRH9VsGFmHwSy6UvKOu2Sq4sX49iYmPMiw
	gn2uLxSVcnSlK733O8UkJuqxluRiAiNu+OPtxokqgLVcn4HAmaEvdx4RL3zS28e5vdc=
X-Gm-Gg: Acq92OGCbIYOh5xGAtE5rl/R/GET8qBY+mXcDjfWTa7oq2Snnnct1VnoXbqQ3qJCRM5
	oqWCAhcH3JnE24oqjpzExm0+sddUxvUyYX1W048gUIfm9wAQmXdRenkcQprtf2Md9fo9PaKV6Ie
	aQ2cLv/h84iCb+eRljpXQ7lMx8wi1f98Q21Y2PURlR94T2JYoMEAx65n+seiM6V9HYHnO1QHAlW
	Zr5vG4hePoMN3FDevazdSOEiCDm2NfBIxZwoAOMthbG2MuVwxinJ3eZ9SJpFMg4ahsVQd4Y1QJC
	F65+i+oJmPgsmojf33gpRA75KPvpe7xrLa2NlRKZhTW6B5TzrOnBjb+0SBcI0aBVOc4Z/wMhyvG
	c4pqzRQMhZH9YNugb0i6NpwrXtT//BvLV7xWWVhrRiwWhrmbRgv+p90gxD574toAX+JJGgtYWkb
	f/hnygQTr6lKQS5OHyX3RORA==
X-Received: by 2002:a05:600c:2ad3:b0:490:b3ee:b857 with SMTP id 5b1f17b1804b1-490ec50afaemr44846575e9.8.1781508762753;
        Mon, 15 Jun 2026 00:32:42 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e91f88bsm13987906eec.16.2026.06.15.00.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 00:32:41 -0700 (PDT)
Date: Mon, 15 Jun 2026 15:32:38 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_dio_end_io_write
Message-ID: <ai-qJbXLuniGv-mr@p15>
References: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>

On Fri, Jun 12, 2026 at 11:50:20AM +0000, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
> EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.
> 
> 1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
> 2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
> then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
> EXTENT_ALLOC.
> 3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
> ocfs2_remove_inode.
> 
> Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
> contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.
> 
> WARNING: possible circular locking dependency detected
> ------------------------------------------------------
> is trying to acquire lock:
> ffff8881e78b33a0
> (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
> ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> 
> but task is already holding lock:
> ffff8881e78b4fa0
> (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
> ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
>        ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
>        dio_complete+0x25b/0x790 fs/direct-io.c:281
> 
> -> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
>        ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
>        fs/ocfs2/suballoc.c:1078
>        ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
> 
> -> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x200 kernel/locking/rwsem.c:1625
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
>        ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
>        ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
>        ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> 
> Chain exists of:
>   &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
>   &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>                                lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
>                                lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>   lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
> 
>  *** DEADLOCK ***
> 
> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
> Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

LGTM.
After d647c5b2fbf8, ocfs2_dio_end_io_write() spends a significant amount of time
looping through the unwritten extent list before it finally acquires the
ORPHAN_DIR lock. This gives other functions (such as ocfs2_wipe_inode() mentioned
in this patch) a chance to preemptively grab the ORPHAN_DIR lock, thereby
triggering the circular locking.
What d647c5b2fbf8 actually did was widen the race window, turning a pre-existing,
low-probability issue into an easily reproducible one.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 
> ---
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6ec198bda..4acdbb708 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  unlock:
>  	up_write(&oi->ip_alloc_sem);
>  
> +	if (data_ac) {
> +		ocfs2_free_alloc_context(data_ac);
> +		data_ac = NULL;
> +	}
> +	if (meta_ac) {
> +		ocfs2_free_alloc_context(meta_ac);
> +		meta_ac = NULL;
> +	}
> +
>  	/* everything looks good, let's start the cleanup */
>  	if (!ret && dwc->dw_orphaned) {
>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:
> -	if (data_ac)
> -		ocfs2_free_alloc_context(data_ac);
> -	if (meta_ac)
> -		ocfs2_free_alloc_context(meta_ac);
>  	ocfs2_run_deallocs(osb, &dealloc);
>  	ocfs2_dio_free_write_ctx(inode, dwc);
>  
> 
> 
> base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
> -- 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
