Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDFD36922F
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Feb 2026 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771923249; cv=none; b=ikb7nT2ZaEpRMWv5CkJJIUUyHonwVGs8X45f8iLDxM3cR+Uq/QWDu8cL5Y3N6wsx8Z3ZOKXU4pFqmmHYsuSjiv6s5vBhbmExNMrESBit+oHZIB8vWIHFNx1UeluL7wxn+D0xtCvDO2Uz3pP2n1w5DtpDisxmEI1JhZlwdosYDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771923249; c=relaxed/simple;
	bh=6uMfxk+ewtlHqXkuBaLLWgULDjBQPejtTz45PCOy7GA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZM8iyO6E49x2U7UMdeXvfaqDkNPQF5spAxkKWh2I1PrUt0oM3IWTTzt5D50vIeIw9abT3s9xFWHvfpMKhmCUr4wwfLQciyZNTLEx/epyyYcHmzQc+asSwepvTMXDO2B/4RNy/YZzDQnp2a3BftlDW1DPjERYG48Lb6638EhX2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ViXhY0g/; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ViXhY0g/"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so6077905e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Feb 2026 00:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771923246; x=1772528046; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQ3ekI9RD+XtB0oTIG5Ul0FD5UjseqCdlIUae0rfNTc=;
        b=ViXhY0g/vbO3EdPLwK/66YR+sAp4QqT8A2Ns7bVEJ1XSpGc8QltV4QUkAmCQxj2NYK
         Maf68GhP9kCA5s8okoLD/SajA4oeFoz15+kvDr0bBARVti1+moBbATwLSq4nlsEXcj9G
         wdqF5kHeg21qpseaD8RvSbrrHVMFTCh1/HPj6a6nhxcepODpdlyf7+b84fldieB4CGJS
         ehyMVOhP2VBamzlDskh4Z9K8kLSZVzsBHbT5A8WtkPFF+WxHSIQMe3SiH1pr/cqhu2Uw
         EwdCpjuKCrmIYHav2E7ozt09SHB44vpd0lJMht3xMs6CiKp/7ObT54xqSEWpDuLC84XB
         oOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771923246; x=1772528046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQ3ekI9RD+XtB0oTIG5Ul0FD5UjseqCdlIUae0rfNTc=;
        b=b+KMnZa56pCiTiIU++CwI7+VrOrgBkrHkWjzdiX6pBMa3O3V+Ja/pFh6UVAR/Ggjiu
         z3tnLhUZYftiZ2kGc6abQwyEKWpvSX+SytFTKVvjp2yVhmda/ahr4zpKaykUeWAiIbqe
         T2iGuayBhdCmuUNty+GUdtDRHBLMyMMraN3eP6OGSvfOZszD81qoxZECKrL6aO8NC2CC
         gZqgH5sLXgu00hegpHwQ66ZWEY3Lr0jRHat0KduO0WSHNyu5GJ2TB4rB7/hB13l/qf+y
         1bIlK2jsmLLT8lAlu0PtdeOvaOoIi2HlbW9TrRGgZ80zA23OsGGRzhHs4plQ/IPw9Fcw
         ctEA==
X-Forwarded-Encrypted: i=1; AJvYcCV+xLy7Em4GsHkJW9DrLwtt+6rLwUQG41dhdwqKWNE5Mjpev60EkBe1apQsopkiIzCJRNaIOC9IcgforQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyeItTWvtvYD2/MJZkVmP/xPq5DPviR6Aw1pg0MgS7pK1OoV4oV
	T8Y9pP8aVtPy8hvO9nj/HXFTp3tbRHjxIdK9vhi1Y5G4Gm3P7DanRwy80iBUPpw8wLo=
X-Gm-Gg: AZuq6aJ+YjMhyhfoYm+0A/B9dZxkM012wZlovMlmo/8ybP0MlwmqGQw1D5tCrXwAqUZ
	y0X22NfypkHa/b+lE5GmQkEO2r0N8wdngziUjet6WNQjfmL35YVHkX1qNOBsrzCJOp3Uzk4ZaSG
	6BGaWgQt/OjEO3eNRB2XGUNYGerklt4Bfy1ijVaFUWGNVw51Lfe33wM+e2z3S/4AL1vM1sfDr2a
	oTjsRkqRF7jW2mA+CINef4ItXq85VIN0r0F0B0bQdF+wIfzOjcVvePGKZZq5/+Ai46Gf0NNCDy8
	A63tuAei/fnMR5Z+PRw4qBDhZZe1pBMZb8o6JwyFM95pm+iMQgB3WkaR1AKmBJoJz1ExBj0386t
	n4JqijIUYu8DAySEdyu+R5qbAkERCHzcuUMJiqpBAdqagEf9kE8Fnrl5KKpvy5v0TcLtwTiOBV2
	sKs8+pkgIx40TJIu82pzMkE+Y0OJSxgRsm
X-Received: by 2002:a05:600c:c171:b0:483:a26d:127f with SMTP id 5b1f17b1804b1-483a962f8e1mr108231225e9.3.1771923245898;
        Tue, 24 Feb 2026 00:54:05 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74f5dcb4sm100341885ad.27.2026.02.24.00.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 00:54:05 -0800 (PST)
Date: Tue, 24 Feb 2026 16:54:02 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Prithvi <activprithvi@gmail.com>
Cc: willy@infradead.org, joseph.qi@linux.alibaba.com, mark@fasheh.com, 
	jlbec@evilplan.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <y2vzekvugtr22z4ndnjtktecwcjhtutztwyz6mrjpmrvteqljh@2esklij5l5mx>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
 <aWhxfLwUvHDswsIY@casper.infradead.org>
 <20260216041659.plgrj5tiseeqwbkl@inspiron>
 <20260223050540.2g44esrm32kpcega@inspiron>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223050540.2g44esrm32kpcega@inspiron>

On Mon, Feb 23, 2026 at 10:35:40AM +0530, Prithvi wrote:
> On Mon, Feb 16, 2026 at 09:47:08AM +0530, Prithvi wrote:
> > On Thu, Jan 15, 2026 at 04:47:56AM +0000, Matthew Wilcox wrote:
> > > On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> > > > On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > > > > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > > > > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > > > > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > > > > syzkaller, the function is curently operating on a quota file.
> > > 
> > > So the right fix is probably to disallow DIO to a quota file, wouldn't
> > > you say?
> > 
> > Hello all,
> > 
> > Firstly I apologize for the delay...I was trying to understand the bug in
> > detail and few strange things I noticed. I have now confirmed the bug is
> > due to uninitialized locks during slab reuse. Here are the deatils:
> > 
> > According to earlier observations, we knew that a file with a quota lock
> > was trying to enter DIO path which is not permitted. I observed that
> > that in spite of adding checks like IS_NOQUOTA(inode) since I observed:
> > 
> > else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
> >         inode->i_flags |= S_NOQUOTA;
> > }
> > 
> > in ocfs2_populate_inode(). However with this change also the issue didn't
> > seem to get resolved.
> > 
> > I found that it was some inode numbered 16979 which was entering DIO.
> > However, upon investigation I noticed that inode 16979 passed through
> > ocfs2_populate_inode() only when create_ino = 1. Upon adding a few printk
> > statements in __ocfs2_mknod_locked() I found that the inode 16979 strangely
> > held ocfs2_quota_ip_allc_sem lock at the mknod stage. I suspected it to be
> > a lock cleanup issue in the slab object when inodes are returned to the slab.
> > 
> > I found that in one mount session, an inode was mounted as a quota file,
> > with a very small number (mostly <50) then later on in another mount session
> > that same slab object is reused for the inode with number 16979 which
> > immediately causes the lockdep warning to occur since it still holds the
> > quota_ip_alloc_sem lock.
> > 
> > IIUC, I did not find any way the semaphore is cleaned when an inode is
> > evicted. Hence I think to add init_rwsem() to the ocfs2_clear_inode() to
> > stop the warning, since now that inode held ip_alloc_sem lock only, thus
> > no quota lock acquired during DIO and the issue never occurs, even if same
> > slab object is used which retains the lock identity. In addition, a check
> > can be added to block DIO on quota files.
> > 
> > Thus, I think the following change should work:
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 76c86f1c2b1c..372c198afa25 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2420,7 +2420,13 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> >         struct inode *inode = file->f_mapping->host;
> >         struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> >         get_block_t *get_block;
> > -
> > +
> > +       if(IS_NOQUOTA(inode)) {
> > +               mlog(ML_ERROR, "Direct IO is not allowed for Quota inode %lu\n",
> > +                    inode->i_ino);
> > +               return -ENOTSUP;
> > +       }
> > +
> >         /*
> >          * Fallback to buffered I/O if we see an inode without
> >          * extents.
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index b5fcc2725a29..3e36da2ca5d0 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -1268,7 +1268,8 @@ static void ocfs2_clear_inode(struct inode *inode)
> >                         "Clear inode of %llu, alloc_sem is locked\n",
> >                         (unsigned long long)oi->ip_blkno);
> >         up_write(&oi->ip_alloc_sem);
> > -
> > +       init_rwsem(&oi->ip_alloc_sem);
> > +
> >         mlog_bug_on_msg(oi->ip_open_count,
> >                         "Clear inode of %llu has open count %d\n",
> >                         (unsigned long long)oi->ip_blkno, oi->ip_open_count);
> > 
> > What do you think?
> > 
> > Thank you and best regards,
> > Prithvi
> 
> Hello everyone,
> 
> Just a gentle ping on this thread...I wanted to seek feedback regarding the
> analysis of uninitialized locks during slab reuse. If the proposed fix is 
> correct, I can go ahead and send a v2 patch for the same.
> 
> In addition, I also realised using -EPERM in the if condition in 
> ocfs2_direct_IO() might be more relevant so I tested a patch with that change 
> and it doesn't trigger any issue with the testing with reproducer program as 
> tested here :
> https://lore.kernel.org/all/66fdfef3.050a0220.9ec68.0031.GAE@google.com/T/#m00f39888c9cfdb78b2c5eff8d1e2cba82e4fd9cc
> 
> Thanks,
> Prithvi

Hi Prithvi,

This patch disables DIO on quota files, which will lead to a performance
regression. Other filesystems (such as ext4 and gfs2) do not forbid DIO on quota
files. Therefore, I NAK this patch.

I have sent an alternative patch[1] to address this issue. Please take a look.

[1]:
https://lore.kernel.org/ocfs2-devel/20260224084909.28361-1-heming.zhao@suse.com/T/#u

Thanks,
Heming
