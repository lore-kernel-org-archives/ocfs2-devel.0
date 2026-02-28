Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26967271A9A
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Feb 2026 07:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772262406; cv=none; b=rfA4vnbTQWgwI36bVmeSszy4G10yYk4Kgr2FaInzvsdvQUf0bCglRk7Z08z1dkViwmctwPhdiOq+npDVKfR6UHDAeOTLzuba7kV66I/4WZ90rSMaS6aUDT/8NiMaJpCkE/fO+l5vI+2jTjDaYwXf5Has0YWgwAK6Yx/DQm0cH4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772262406; c=relaxed/simple;
	bh=Na9xCfHSFJBtXJ0qvbd2PXKcasKPAiQHxxzoFg1ls/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXYt/WHmSEXN2i5savqetOCJ63ee+MALeKU+9XcFzV4INdjG4fWdYeqLE/fzfmyh9OXTcSIaNwNnwex//uP3TkxM2y8ISp23OUUIQLybmLk8y1rDSdmKaU7pEkNZ9XHoS+bvKD7aP2DhNQm8kcCNp/+BNMjEiaG94dpVsbRCrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TMrXswl7; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TMrXswl7"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439962ecfb5so277772f8f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 27 Feb 2026 23:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772262401; x=1772867201; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/uv4lr/zY2Q5kfOzEF9RcU1pR24oVWeXLIQJjcC86xk=;
        b=TMrXswl7aErYzirbQ3zEmZK+Rl0qHCEwuxEOvhOpNG7qMM5o7C+J/xnsSmi752quZI
         n2UDtGprOCmqMd69tuN5bgDKRziwSm6mYlLMYUdEmGa9CB81vR2sPOhNdhIbvNQI/6V1
         DU1tL1FIkB1AR/Isaf63G9hwI26TwBCNE7wuSFsSRNNcyQxK5zAnnUF3IGMK3AhqthOB
         Q1M6l5Kw6eXb5CcYtVBzLs9Nhgnzej6chCPlHoeA/NU02R5TAphfN5a9YNz8J0c0pC5j
         vjfNqzhSEAutH8qBYO4qH8/PE75F6cJVcM0gBq52dktyP7tB5WHBNMB3Bt7RBEWKeM/5
         KBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772262401; x=1772867201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/uv4lr/zY2Q5kfOzEF9RcU1pR24oVWeXLIQJjcC86xk=;
        b=OycXWOVjhZp8aT5Swdak/oVO6RbMHHgcfbjFST3v+E/ZEviqcwQpoBILn5J0Cfb+ms
         AYqxHdyQNzvudW79bgBc58F6latiHpzQDlZugzRU6MIqeYTVfLSB7ALF/3Kk/DdVbwos
         HHD9J+sJykDgRVFsgIBQq+FQr6VMbMrOZLcvJ2mtqM6GZz537nDfbzqQv9o029HVrgq5
         iUFr3cIF8OUoUcrKFlZcAb4vcBu4EUiWCCyrz441lm1cq0vzbG313zC5idTfneTA6Q4Y
         O/kd9LoeTTXJLEBNgrmCxzOinXgHTGtWLv++Ul3nnPMPOHEdSgeZAN/PQ0Pd7ZTVsH5c
         1Diw==
X-Gm-Message-State: AOJu0YzB5Xc10w8hmzHvk3f83hO+r93bvS2eRSwEGlmsi6CFViL2GA6R
	LcWXRvDRPyYg76rfqDUmS3eh9dvAHexvfunVzOVPBEs1d/00hKP7/sknWKCxFG1Kmgk=
X-Gm-Gg: ATEYQzwLFBCcyR9/uR50W+UNkuX8d93df2fn0r8nPD0DSp0MvovryebHmmqqtW1HgEr
	ZHvSn424D/L7hahpRPnfU+OStYRPsJuPnFlcJxmiZMZjSY2EYU9Uyo3QOebpTl6+4NTZZksd+Fm
	3qynUKhV12ZeNB9scQqOxO9HKH6oJeTTTMQy4cbop9VlcNwvVNhUzeEciqv5WbpsQNcc/SnXEzg
	xs4QE7IyXgQszlNIRopDTR7LN/mFoz9SirQ+/ATCF11eXqyv814KAC9umbq8YwPgpCZ3BywlwkD
	+fNUDu13m22yGyNOx94p7MdiUm+9n/8L+604AJ64/bKR41eWndwTDfvpPVGE8xwMdhmUxh/avqZ
	RKhCqKn6kHt0A/TFHL3PAYTRtpQpZKqHcT1p3vZSH2pDuUhd4jTkp+RUE+5RJ/LmlMygsNZ4mwH
	JSBl/F54SdTjzO+mRMJ1JSqA==
X-Received: by 2002:a05:600c:6388:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-483c9c0b02cmr46649315e9.8.1772262401323;
        Fri, 27 Feb 2026 23:06:41 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d4d826sm7036982b3a.10.2026.02.27.23.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 23:06:40 -0800 (PST)
Date: Sat, 28 Feb 2026 15:06:37 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	activprithvi@gmail.com, syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com, 
	akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] ocfs2: fix deadlock when creating quota file
Message-ID: <2dbj3rn4xks774qkgfp6ecmjperq5xtkkayyn4vuo4i4c5of62@7pjybhlobopb>
References: <20260224084909.28361-1-heming.zhao@suse.com>
 <bd3926d7-3069-48cb-a04c-b8ab285d47e1@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3926d7-3069-48cb-a04c-b8ab285d47e1@linux.alibaba.com>

On Sat, Feb 28, 2026 at 02:01:55PM +0800, Joseph Qi wrote:
> Hi Heming,
> 
> On 2/24/26 4:48 PM, Heming Zhao wrote:
> > syzbot detected a circular locking dependency. the scenarios:
> > 
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&ocfs2_quota_ip_alloc_sem_key);
> >                                 lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
> >                                 lock(&ocfs2_quota_ip_alloc_sem_key);
> >    lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> > 
> > or:
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&ocfs2_quota_ip_alloc_sem_key);
> >                                lock(&dquot->dq_lock);
> >                                lock(&ocfs2_quota_ip_alloc_sem_key);
> >   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> > 
> > Following are the code paths for above scenarios:
> > 
> > path_openat
> >  ocfs2_create
> >   ocfs2_mknod
> >   + ocfs2_reserve_new_inode
> >   |  ocfs2_reserve_suballoc_bits
> >   |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
> >   |    //at end of this func, ocfs2_free_alloc_context(inode_ac) calls inode_unlock
> >   |
> >   + ocfs2_get_init_inode
> >      __dquot_initialize
> >       dqget
> >        ocfs2_acquire_dquot
> >        + ocfs2_lock_global_qf
> >        |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
> >        + ocfs2_create_local_dquot
> >           down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing
> > 
> > evict
> >  ocfs2_evict_inode
> >   ocfs2_delete_inode
> >    ocfs2_wipe_inode
> >     + inode_lock(orphan_dir_inode) //B0:hold
> >     + ...
> >     + ocfs2_remove_inode
> >        inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
> >         down_write(&inode->i_rwsem) //C1:grabbing
> > 
> > generic_file_direct_write
> >  ocfs2_direct_IO
> >   __blockdev_direct_IO
> >    dio_complete
> >     ocfs2_dio_end_io
> >      ocfs2_dio_end_io_write
> >      + down_write(&oi->ip_alloc_sem) //A0:hold
> >      + ocfs2_del_inode_from_orphan
> >         inode_lock(orphan_dir_inode) //B1:grabbing
> > 
> > Root cause for the circular locking:
> > 
> > DIO completion path:
> >  holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.
> > 
> > evict path:
> >  holds the orphan_dir_inode lock and is trying to acquire the
> >  inode_alloc_inode lock.
> > 
> > ocfs2_mknod path:
> >  Holds the inode_alloc_inode lock (to allocate a new quota file) and is
> >  blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().
> > 
> 
> When running into ocfs2_mknod->ocfs2_get_init_inode,
> ocfs2_reserve_new_inode is finished and INODE_ALLOC_SYSTEM_INODE gets
> unlocked in ocfs2_free_ac_resource at the end.
> So I get confused about the above deadlock sequence.
> Am I missing something?
> 
> Joseph

ocfs2_reserve_new_inode only releases 'ac' when an error occurs (note the if
condition: 'status< 0'). The normal path for releasing 'ac' is at the end of
the caller ocfs2_mknod.

Heming

> 
> > How to fix:
> > 
> > Replace down_write() with down_write_trylock() in ocfs2_acquire_dquot().
> > If acquiring oi->ip_alloc_sem fails, return -EBUSY to abort the file creation
> > routine and break the deadlock.
> > 
> > Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/quota_global.c | 5 ++++-
> >  fs/ocfs2/quota_local.c  | 5 ++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> > index e85b1ccf81be..4321d8f59402 100644
> > --- a/fs/ocfs2/quota_global.c
> > +++ b/fs/ocfs2/quota_global.c
> > @@ -311,7 +311,10 @@ int ocfs2_lock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
> >  	spin_unlock(&dq_data_lock);
> >  	if (ex) {
> >  		inode_lock(oinfo->dqi_gqinode);
> > -		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> > +		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
> > +			inode_unlock(oinfo->dqi_gqinode);
> > +			return -EBUSY;
> > +		}
> >  	} else {
> >  		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
> >  	}
> > diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> > index c4e0117d8977..e451f3d96037 100644
> > --- a/fs/ocfs2/quota_local.c
> > +++ b/fs/ocfs2/quota_local.c
> > @@ -1224,7 +1224,10 @@ int ocfs2_create_local_dquot(struct dquot *dquot)
> >  	int status;
> >  	u64 pcount;
> >  
> > -	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
> > +	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem)) {
> > +		status = -EBUSY;
> > +		goto out;
> > +	}
> >  	chunk = ocfs2_find_free_entry(sb, type, &offset);
> >  	if (!chunk) {
> >  		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
> 
