Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB742AF00
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Feb 2026 05:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772255589; cv=none; b=lRZZYvq6jszKdoY6DmtVysGYwS5krsrgN/Z6HdwfDMYgBpGExL4jMsmTjG86OT91t3gA41Ij0oJwhjhLhN7ZxHqMPnZl5HjJ9D8xD2UQxyv9fdc1wAlPXoXnweS7/NJqbxr9V9DkxrY5nycZAYblHWs+BCV0piJZT6sCgNEQW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772255589; c=relaxed/simple;
	bh=+c9IQ/uNTRg49+9wa/kh4QHB8MPQKVPgUmsSr5njBPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvXJcGoR//9fW347ojxx4/M/0H35GogLzoan0hJXWmPyx0k2ZvnRvFA6yQMbItP2V1euK7+FKgZyGYfQFl2zoJIyUh9J/0TgGPCcl6AXtpq9vZ76BB+jdtIHO6uVynJ4u/KNcuKIa2jaKZAIp8UB1FhtHfekw101egkNCtqMo5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcJEjXgk; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcJEjXgk"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2adec255754so18410565ad.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 27 Feb 2026 21:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772255588; x=1772860388; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=femWzuUVK1P2mPU+Nw7t3r4CPyjg2W4tlblzeF3oME4=;
        b=mcJEjXgkqmmilWWv42Y5iFwFyVbdZqHhDHBb7jw7o12Fh4DUDtLCmTwogrhlxkpDlH
         Jmtzes0lq7K9Ck+xGUYBTg1nt40fiCb4YpvDbC7pa0Op3fqgYQI4PGQSUydKLUotO2lf
         tCLfSLRQdetUxt/lZCwKvLJgrQ8dJga7K05cGtpB2YNs0vqmkhoVEXYAqGUd4UHhkq5k
         OevBMegUubHfNI4pzRmV7QsfQwM5ZnAZW7IeCNnMbvaUXzclQdjWDm9VI3ZqcfF42BPO
         WvBClCEavkDJ6LoRjgv9FcdWEHoHECZF4QQHbiGGeGBU/u/Ehz7IloJETS1QO/PALg/q
         cz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772255588; x=1772860388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=femWzuUVK1P2mPU+Nw7t3r4CPyjg2W4tlblzeF3oME4=;
        b=QHp4nzkBSvvxnvYC+Cr9wpdVax98EqhT47YP+fWQp1m3LuSkODvSdsDVFpUrcf1hKl
         WfSBNyCv9lTF09PNzlkR7tqvaaHmV0KJBDjSbppAQXHMO1mFBG9R+rIpW3zshKDk8upT
         5SaO97wp/XHPSzhUgwvqnmg8kLFLa8GRYBG4Ssqx7l6RB2LYAYXQ05ht9jTC4shFreea
         UD55nn8SnE+1ZTcwNdFZibzJPuTjqQv7alpAyRr+W4kVONt7664ey9yFv9uLEYBalDeQ
         Eb+2dAEV4dgVjJSfUhmribKWjVgDMccINFLjQrnwZ1KutkpWTkdHQhVNoYQeAWJgknYj
         sK2w==
X-Forwarded-Encrypted: i=1; AJvYcCVpu22IWnTJ1fRtf+34pjKGFf3ormCTPkD3/H/nbJAn2COaJQZ+bOkjKvOcuttJscIaWfcIvGTD9RkJ7w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsXQ3UNjzm3jsRNi+qU6YAmfCWTu2emslqT6K53pakomcsEd0/
	j+xKleFK7EzyFCw4XxiiLxk+63mVnCvt/hoh4pLcw/nkISuRGW5SyzgQ
X-Gm-Gg: ATEYQzyTt37ABBvfC7Et7dCosrQWaiKAnrkGLT+reYSEOEBvQLVAanDnLXeoQL7t1CN
	+VaW2ix+FRUiVJnJtdE2N/sBzlqDiI+k7KlB4MwfxIg18M/CRqdFE1b47KE0wXCQljOFx4ZUS+Q
	KRGpZW0xk2SVcIo9RZ0BVL+2cSyh3Yxd038aOowiSGlaRZagVNT8qGVEDCln8KB/l8eD51g16pv
	PhgZJcJa9UfTgDc6Sp/lumj0Tyr7SsnGc98KqGm7xGD7/RTwwom+0E2sRQozeQzLZfdIqNZEFO0
	VSQaWlrEeSMaqPje9dC10SwfdVNIvNwabnqZlG7P1tHHSWua0Q1PkhWw00QzRBfq1Q3vLit25Bl
	H9mh7CK7tNldPS5L/gGbd/yqJUqF1PHeOwcMf9xBLaRR4RpIGDt/mfonHkCrSWyULRj1kp2+IgB
	NzwSEEZ9NExI6woCMgzNHNdxA=
X-Received: by 2002:a17:902:ebc6:b0:2aa:fc73:98ac with SMTP id d9443c01a7336-2ae2e4d6aa2mr51885275ad.49.1772255587764;
        Fri, 27 Feb 2026 21:13:07 -0800 (PST)
Received: from inspiron ([111.125.231.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae3e4e34fesm4088615ad.28.2026.02.27.21.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 21:13:07 -0800 (PST)
Date: Sat, 28 Feb 2026 10:42:59 +0530
From: Prithvi <activprithvi@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: willy@infradead.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
	jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <20260228051259.67dyp4l2iuy7jpuq@inspiron>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
 <aWhxfLwUvHDswsIY@casper.infradead.org>
 <20260216041659.plgrj5tiseeqwbkl@inspiron>
 <20260223050540.2g44esrm32kpcega@inspiron>
 <y2vzekvugtr22z4ndnjtktecwcjhtutztwyz6mrjpmrvteqljh@2esklij5l5mx>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y2vzekvugtr22z4ndnjtktecwcjhtutztwyz6mrjpmrvteqljh@2esklij5l5mx>

On Tue, Feb 24, 2026 at 04:54:02PM +0800, Heming Zhao wrote:
> On Mon, Feb 23, 2026 at 10:35:40AM +0530, Prithvi wrote:
> > On Mon, Feb 16, 2026 at 09:47:08AM +0530, Prithvi wrote:
> > > On Thu, Jan 15, 2026 at 04:47:56AM +0000, Matthew Wilcox wrote:
> > > > On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> > > > > On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > > > > > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > > > > > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > > > > > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > > > > > syzkaller, the function is curently operating on a quota file.
> > > > 
> > > > So the right fix is probably to disallow DIO to a quota file, wouldn't
> > > > you say?
> > > 
> > > Hello all,
> > > 
> > > Firstly I apologize for the delay...I was trying to understand the bug in
> > > detail and few strange things I noticed. I have now confirmed the bug is
> > > due to uninitialized locks during slab reuse. Here are the deatils:
> > > 
> > > According to earlier observations, we knew that a file with a quota lock
> > > was trying to enter DIO path which is not permitted. I observed that
> > > that in spite of adding checks like IS_NOQUOTA(inode) since I observed:
> > > 
> > > else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
> > >         inode->i_flags |= S_NOQUOTA;
> > > }
> > > 
> > > in ocfs2_populate_inode(). However with this change also the issue didn't
> > > seem to get resolved.
> > > 
> > > I found that it was some inode numbered 16979 which was entering DIO.
> > > However, upon investigation I noticed that inode 16979 passed through
> > > ocfs2_populate_inode() only when create_ino = 1. Upon adding a few printk
> > > statements in __ocfs2_mknod_locked() I found that the inode 16979 strangely
> > > held ocfs2_quota_ip_allc_sem lock at the mknod stage. I suspected it to be
> > > a lock cleanup issue in the slab object when inodes are returned to the slab.
> > > 
> > > I found that in one mount session, an inode was mounted as a quota file,
> > > with a very small number (mostly <50) then later on in another mount session
> > > that same slab object is reused for the inode with number 16979 which
> > > immediately causes the lockdep warning to occur since it still holds the
> > > quota_ip_alloc_sem lock.
> > > 
> > > IIUC, I did not find any way the semaphore is cleaned when an inode is
> > > evicted. Hence I think to add init_rwsem() to the ocfs2_clear_inode() to
> > > stop the warning, since now that inode held ip_alloc_sem lock only, thus
> > > no quota lock acquired during DIO and the issue never occurs, even if same
> > > slab object is used which retains the lock identity. In addition, a check
> > > can be added to block DIO on quota files.
> > > 
> > > Thus, I think the following change should work:
> > > 
> > > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > > index 76c86f1c2b1c..372c198afa25 100644
> > > --- a/fs/ocfs2/aops.c
> > > +++ b/fs/ocfs2/aops.c
> > > @@ -2420,7 +2420,13 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
> > >         struct inode *inode = file->f_mapping->host;
> > >         struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> > >         get_block_t *get_block;
> > > -
> > > +
> > > +       if(IS_NOQUOTA(inode)) {
> > > +               mlog(ML_ERROR, "Direct IO is not allowed for Quota inode %lu\n",
> > > +                    inode->i_ino);
> > > +               return -ENOTSUP;
> > > +       }
> > > +
> > >         /*
> > >          * Fallback to buffered I/O if we see an inode without
> > >          * extents.
> > > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > > index b5fcc2725a29..3e36da2ca5d0 100644
> > > --- a/fs/ocfs2/inode.c
> > > +++ b/fs/ocfs2/inode.c
> > > @@ -1268,7 +1268,8 @@ static void ocfs2_clear_inode(struct inode *inode)
> > >                         "Clear inode of %llu, alloc_sem is locked\n",
> > >                         (unsigned long long)oi->ip_blkno);
> > >         up_write(&oi->ip_alloc_sem);
> > > -
> > > +       init_rwsem(&oi->ip_alloc_sem);
> > > +
> > >         mlog_bug_on_msg(oi->ip_open_count,
> > >                         "Clear inode of %llu has open count %d\n",
> > >                         (unsigned long long)oi->ip_blkno, oi->ip_open_count);
> > > 
> > > What do you think?
> > > 
> > > Thank you and best regards,
> > > Prithvi
> > 
> > Hello everyone,
> > 
> > Just a gentle ping on this thread...I wanted to seek feedback regarding the
> > analysis of uninitialized locks during slab reuse. If the proposed fix is 
> > correct, I can go ahead and send a v2 patch for the same.
> > 
> > In addition, I also realised using -EPERM in the if condition in 
> > ocfs2_direct_IO() might be more relevant so I tested a patch with that change 
> > and it doesn't trigger any issue with the testing with reproducer program as 
> > tested here :
> > https://lore.kernel.org/all/66fdfef3.050a0220.9ec68.0031.GAE@google.com/T/#m00f39888c9cfdb78b2c5eff8d1e2cba82e4fd9cc
> > 
> > Thanks,
> > Prithvi
> 
> Hi Prithvi,
> 
> This patch disables DIO on quota files, which will lead to a performance
> regression. Other filesystems (such as ext4 and gfs2) do not forbid DIO on quota
> files. Therefore, I NAK this patch.
> 
> I have sent an alternative patch[1] to address this issue. Please take a look.
> 
> [1]:
> https://lore.kernel.org/ocfs2-devel/20260224084909.28361-1-heming.zhao@suse.com/T/#u
> 
> Thanks,
> Heming

Hello Heming, 

Thanks for your feedback! I see your point about performance regression and 
agree that your approach using down_write_trylock is a much more robust way 
to fix this issue.

Thanks, 
Prithvi
