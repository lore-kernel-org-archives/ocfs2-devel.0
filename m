Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A872D2F8E82
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jun 2026 02:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664119; cv=none; b=rtjohRkbzuL3UOp3dvagVt/X4yir4q9ObTW8ZzlQygmv0PmpllboFaeZ/9nua2GbQG+ZLoIKXAJAxO4r17dIPPnK1r18u2ViucNCqxRE760713OtEBjh0dvQhTCinm7Joi7M4607UGgr/HzReTq9ZKkutUv0L7dMeelCqWdcXqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664119; c=relaxed/simple;
	bh=Lz55FVw/FiFzvvV1pJpJBW6xjuc9f4yAbDkp9gtshZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+YgxSZ16UTS1EtF4p60jFODhrBOWKWw8vLR/WU7FgWXeJj8CN9mOgJQLKIYMXZtZThT96Hllqpot70ZUh+/oqBVgW15xEniPImUMHwGhPu3rOFblRZ/2X5DghSjqnUaqa873yoWbBVP86/BAJICm9JBYv7up98gpTvDFvcFhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AMFXRYcc; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AMFXRYcc"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68d22a95815so940638a12.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 19:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781664116; x=1782268916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vA+ON9BWXCgajXFSiirszaYnsVqaL1L7Vrh58zTSnCg=;
        b=AMFXRYccI98WBkIwdXEnSC2x4UEDnk6Xi8gzdJ0YB7a2s5ef35obyIQwYeyTEqRMdC
         u/cCEnic5somz7hftE2v09mlSKkzNzRQ2d8YxOT9SmGJLVfZWhL//HxS4A53QYDjY9Md
         9IZOE1rS945aS5wuNZfINWOP21BELYJScL6yOug74oB7NxdsHkLa460Gk2JXo6nPDrTu
         ycKN3K/8du2e8k6TkYMS/kgXiPxondM6jM5SCd43aOkSL2P7BNx4/53EZoikyuAxLGPz
         LoP4m+3Up/VoYi7bZ/tV2mGuQA8DpF7yQTGZA/caCZBUGSx6yUf6fdD2bU6DOmDmv2iK
         uBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781664116; x=1782268916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vA+ON9BWXCgajXFSiirszaYnsVqaL1L7Vrh58zTSnCg=;
        b=hiTciY42Rllr/SZUWnwHEqgISwE1chNtqxlan5dRQQPI9pl8lp+UKWWRnL32LfsW+t
         iwTGK86sKVihxDdmdsVw4AebN9tN5wfCxukUi1ZevMbtdlv/IzZYAlAhOASW0cTOamCz
         b2h9yXp7fAFhFL8BeZN1sQ5cbSpK+mdCEV4aRdDqNq2UULIBvr7dbvC2TuWVXwV1CuXG
         wTWu48otTHNeFlgFKmzanjSrtmRZeTPTd0mlaa+bMcKXLIFhc7xZFfo/LExtqZMEJ4/Q
         h8O/oWAGH+nK/fsNltHFRguxBc+qgG6US7EAbU9RkskXw1Uo+8eXZBP7o3l/OQ8wzlkj
         qGqA==
X-Forwarded-Encrypted: i=1; AFNElJ+QdOe0Tijvv2KS3yUY3VqO4ramMCE+ymsF7Geh4tWOR6CfDJAK5A50cfsiLJGdvxEERFoYFVlCkR2bUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxsYhdIsbDK8VCM7BJP9cHOpsAOXdF/sybaMgleHmJjwiSZ8HW+
	PmUBOmjeUkuAjrTEjt52Xp75UDn74fc2nP21ViXT3j2QqNzZ4j6bNKdq0W9ces1EE1d/kOxcAeb
	tmlP9pzY=
X-Gm-Gg: Acq92OHWVRZ1QYqo2oRI5UqaDTXvYDj+Z9h1YKcH1GeqHV6wWPTinyAXcs3YWcjrl5D
	hsSjLuqMzXIVq4c5LnQulHhUoKCsIJQC2Xn85Qr+ESTNA3urGNhT00CBom0AdW6J15GoNwFQHsK
	+t3SEg/F8pQ0BEKjG+c+9wjr0DHODr3oXYMIycZ0BcNJAdl+0PyXGYB/VfTizwPtjljQNnhNHT5
	ZfDY1keTHgsxXtyA1tlNEyf2vusgvg6Xob5ad5gUHGX0NbwSTDyjwKSVyCNrGKC8YcFnW7uWGe+
	hAusydM3IAnXK4VfPtYa8rgzv6mNeMybTeBv70QjG5lJPIXYhmr8YT2TAzhcU1FdQWbgXs13WDo
	DcORxEFIuACzid7XfCDO6G+MOaCvd8HY5iyK2W1SmLncERpAam6h0MgfnttMKg7/pUsqJcmOSOO
	hz8dPLuudiRiA=
X-Received: by 2002:a05:6402:3214:b0:68b:6b71:4114 with SMTP id 4fb4d7f45d1cf-69547443c00mr396857a12.6.1781664116104;
        Tue, 16 Jun 2026 19:41:56 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accac96sm15635254b3a.14.2026.06.16.19.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 19:41:55 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:41:52 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot <syzbot@kernel.org>, Aleksandr Nogikh <nogikh@google.com>, 
	syzkaller-bugs@googlegroups.com, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_dio_end_io_write
Message-ID: <ajIIwKsnlN5yPawm@p15>
References: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>
 <ai-qJbXLuniGv-mr@p15>
 <6f95cc40-3014-4628-9739-28f47bec825b@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f95cc40-3014-4628-9739-28f47bec825b@linux.alibaba.com>

On Tue, Jun 16, 2026 at 02:00:40PM +0800, Joseph Qi wrote:
> 
> 
> On 6/15/26 3:32 PM, Heming Zhao wrote:
> > On Fri, Jun 12, 2026 at 11:50:20AM +0000, syzbot wrote:
> >> From: Aleksandr Nogikh <nogikh@google.com>
> >>
> >> A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
> >> EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.
> >>
> >> 1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
> >> 2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
> >> then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
> >> EXTENT_ALLOC.
> >> 3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
> >> ocfs2_remove_inode.
> >>
> >> Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
> >> contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.
> >>
> >> WARNING: possible circular locking dependency detected
> >> ------------------------------------------------------
> >> is trying to acquire lock:
> >> ffff8881e78b33a0
> >> (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
> >> ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> but task is already holding lock:
> >> ffff8881e78b4fa0
> >> (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
> >> ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> the existing dependency chain (in reverse order) is:
> >>
> >> -> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
> >>        ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
> >>        dio_complete+0x25b/0x790 fs/direct-io.c:281
> >>
> >> -> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
> >>        ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
> >>        fs/ocfs2/suballoc.c:1078
> >>        ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
> >>
> >> -> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
> >>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
> >>        down_write+0x96/0x200 kernel/locking/rwsem.c:1625
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
> >>        ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
> >>        ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
> >>        ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> Chain exists of:
> >>   &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
> >>   &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
> >>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]
> >>
> >>  Possible unsafe locking scenario:
> >>
> >>        CPU0                    CPU1
> >>        ----                    ----
> >>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> >>                                lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> >>                                lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> >>   lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
> >>
> >>  *** DEADLOCK ***
> >>
> 
> Better to describe the solution here.
> 
> >> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
> >> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> >> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> >> Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
> >> Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
> >> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > 
> > LGTM.
> > After d647c5b2fbf8, ocfs2_dio_end_io_write() spends a significant amount of time
> > looping through the unwritten extent list before it finally acquires the
> > ORPHAN_DIR lock. This gives other functions (such as ocfs2_wipe_inode() mentioned
> > in this patch) a chance to preemptively grab the ORPHAN_DIR lock, thereby
> > triggering the circular locking.
> > What d647c5b2fbf8 actually did was widen the race window, turning a pre-existing,
> > low-probability issue into an easily reproducible one.
> > 
> 
> Ummm... before d647c5b2fbf8, ocfs2_del_inode_from_orphan() is called
> before down_write(&ip_alloc_sem) and ocfs2_lock_allocators().
> So I think the 'Fixes' tag looks reasonable.
> 
> Thanks,
> Joseph

Thanks for the info, your got the key.

- Heming
> 
> > Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> >>
> >> ---
> >> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >> index 6ec198bda..4acdbb708 100644
> >> --- a/fs/ocfs2/aops.c
> >> +++ b/fs/ocfs2/aops.c
> >> @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>  unlock:
> >>  	up_write(&oi->ip_alloc_sem);
> >>  
> >> +	if (data_ac) {
> >> +		ocfs2_free_alloc_context(data_ac);
> >> +		data_ac = NULL;
> >> +	}
> >> +	if (meta_ac) {
> >> +		ocfs2_free_alloc_context(meta_ac);
> >> +		meta_ac = NULL;
> >> +	}
> >> +
> >>  	/* everything looks good, let's start the cleanup */
> >>  	if (!ret && dwc->dw_orphaned) {
> >>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >> @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>  	ocfs2_inode_unlock(inode, 1);
> >>  	brelse(di_bh);
> >>  out:
> >> -	if (data_ac)
> >> -		ocfs2_free_alloc_context(data_ac);
> >> -	if (meta_ac)
> >> -		ocfs2_free_alloc_context(meta_ac);
> >>  	ocfs2_run_deallocs(osb, &dealloc);
> >>  	ocfs2_dio_free_write_ctx(inode, dwc);
> >>  
> >>
> >>
> >> base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
> >> -- 
> >> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> >> You can comment on the patch as usual, syzbot will try to address
> >> the comments and send a new version of the patch if necessary.
> >> syzbot engineers can be reached at syzkaller@googlegroups.com.
> >>
> 
