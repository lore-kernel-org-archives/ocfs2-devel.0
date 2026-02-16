Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382F21F2B88
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Feb 2026 04:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771215429; cv=none; b=J8afdS1WMNd3R4gKXRybt3ctkpKpLL0bN8PGP1Txa7PEOkSezly5imgLvkMMZFLLhavv1EqmkFqwNmB5quKhpTkHErrA1+UZBBKrduyRHijwt0KdbkX6jV94sZpl3n2npQzeVYtI6Pe0xOBX4yBi/dkmLMRO6fMTgfqTE7YzOyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771215429; c=relaxed/simple;
	bh=MyTl4PFX3mRfdVM6cxgi5l2WTjlSXSbGDQbx09kyBSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsdoWYP7Z71bwc94UeZBNQZA24a/GfTwvmgV2aezKgtopAkzROzJp6yvfYM1jMuVxgaz5XjPgpYCT4qjcX8OOGvlFyKXZ+rZd2+H0fldx3rVjcDBlSozxFigIygXivhQbiJgNxJsIRnXLq+wzTjIoKQCOUUOzpuOT3zA5lGJ1cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngoReh0x; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngoReh0x"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ad21f437eeso9907475ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Feb 2026 20:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771215427; x=1771820227; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=87a60IrPsZEkv8dm8fdH6Kik8z1oUurYwvGZt/o8UEs=;
        b=ngoReh0x7kSgOVvoxSff0A40zsayjtadb7ql0DEBMdtNSqBFYk2ArekVXJiCL1gN9s
         tfrBxmrguX5J8exeX48DRDvRZ+EzTvKOU+ZBriGmM46t+aOLLbE9HeDZEFWye+27MMTu
         luVsuQANwQGKRRP3MfnDFjTd0Ct/KBlYSa4SlyYeJmAx2UGNv96XwgAt/Fi/6b363ZZM
         0ukcNJ+GSqAjGw8EDFCJ3zD59aoN4e7WP8rmeENJjYlwsd3wW8IkkIjf6hfNrgvrRUtM
         sISsAXDvBTuyZRhz+IMSvndjgyWko6Rf4NBdaChtkPZ25r3S/paimgoMJfWOA2w4rZKr
         A5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771215427; x=1771820227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87a60IrPsZEkv8dm8fdH6Kik8z1oUurYwvGZt/o8UEs=;
        b=Bcws+ZXosEwa2l+SWUSUIVTuGz237poYtT/2Xe8mOO60ov5/G1GwpDKcaNJXsGgHYh
         R7NnCxHv+Dwo9adwKPdnkLfJCrsi+EVrG0OjSPFFQvNLaFqD7xkCXg2GoHJiO1THNL/g
         b0FaxS9bSahHY1Ebr1an8iqvCv4goX5h/R9f06Tu2vqXeBHnDIIXT4MT49bxTIqsNrSj
         c4H7K6HUfVOdMDhJBNwteJp+/zsfJpzA6i8QI0WMptZGLx4JNM7V0JC6LtFHsY4BU3UW
         hlPZIQPlIb7Q4dU8YCifJIFmrxLRP7XfYcVEIoqmHHBi4FoXEnJcx6zNlGmARcIHCoXn
         o9eA==
X-Forwarded-Encrypted: i=1; AJvYcCWlGVWjEg1EVC8+8pmDMLKq7AsVxdl3FhIIkLTRNKIUOrm6sFRh9Gw/oxSTYcTWw+DnHvh4FvxgmoF7lQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwpFZtxwMcUstmKZ5iM3i8p50ss1IDLs+7NkUTfbKofGfUrs0Q1
	4/EJZMTYWUGd0bDQi6MKuFUInW9+pMJDAQCpNEPn1P25TtKwS0JwwpQ2aK8YSJVF
X-Gm-Gg: AZuq6aLnh/+ZmPRk6hr2MiwEettylD2D6ey60nxq+dPKz/WAIdG/OERAH4W4+WhrpGP
	OCGZw8Mcj3I3O3PPHbYZkuLip19/L3amgvHNt39Xo/3BO57ckoruZGapZiGzA4Gidy3GEhtEeYX
	C3IWVb7wGZ8xNWGQlbJejLBbORFpStcIQxy/FeNtTBvvxAcPQc8heDayPzDZqkhGn0ZkCTRn3Mg
	DVB1Feu3T8qikB7ZbQqcv7Yyl5qqlB5QHqvsHQMcwRDC5vju8ALiR247OctZgBZEQPwaod9czTy
	aE9iaoOM0WzhT65Iocl5sYr6FagpT0PENz2FLMrR5L1lqGz3PVmWA9UZlKsxmtsWIqGD78TmryS
	fqm8xtEfvPJmjRB2fCrIRA2zask39gbwYrrnsdLIqzL955iqliycZy/IMeh11t9ITZGDe2yGln7
	2P/NGV9FsVbZeZhK4+d1IeuFcVqM6+vZQ=
X-Received: by 2002:a17:902:ef44:b0:2aa:e47d:e3b with SMTP id d9443c01a7336-2ac93edf6b2mr83476105ad.0.1771215427466;
        Sun, 15 Feb 2026 20:17:07 -0800 (PST)
Received: from inspiron ([114.79.136.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6f9df1sm50515445ad.10.2026.02.15.20.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 20:17:07 -0800 (PST)
Date: Mon, 16 Feb 2026 09:46:59 +0530
From: Prithvi <activprithvi@gmail.com>
To: willy@infradead.org, joseph.qi@linux.alibaba.com
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org
Subject: Re: [PATCH] ocfs2: Fix circular locking dependency in
 ocfs2_del_inode_from_orphan()
Message-ID: <20260216041659.plgrj5tiseeqwbkl@inspiron>
References: <20260106125100.327980-1-activprithvi@gmail.com>
 <94b4189d-dfb6-4443-a336-abbae89d36ad@linux.alibaba.com>
 <20260108183652.ro4xueuj6itfaph3@inspiron>
 <20260115031809.w7ksrj2ostwyxa54@inspiron>
 <aWhxfLwUvHDswsIY@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWhxfLwUvHDswsIY@casper.infradead.org>

On Thu, Jan 15, 2026 at 04:47:56AM +0000, Matthew Wilcox wrote:
> On Thu, Jan 15, 2026 at 08:48:09AM +0530, Prithvi wrote:
> > On Fri, Jan 09, 2026 at 12:07:00AM +0530, Prithvi wrote:
> > > IIUC that would be the case when ocfs2_dio_end_io_write() operates on normal
> > > files. However, according to the report of the bug, ocfs2_dio_end_io_write()
> > > is holding &ocfs2_quota_ip_alloc_sem_key so I think due to random fuzzing by 
> > > syzkaller, the function is curently operating on a quota file.
> 
> So the right fix is probably to disallow DIO to a quota file, wouldn't
> you say?

Hello all,

Firstly I apologize for the delay...I was trying to understand the bug in
detail and few strange things I noticed. I have now confirmed the bug is
due to uninitialized locks during slab reuse. Here are the deatils:

According to earlier observations, we knew that a file with a quota lock
was trying to enter DIO path which is not permitted. I observed that
that in spite of adding checks like IS_NOQUOTA(inode) since I observed:

else if (fe->i_flags & cpu_to_le32(OCFS2_QUOTA_FL)) {
        inode->i_flags |= S_NOQUOTA;
}

in ocfs2_populate_inode(). However with this change also the issue didn't
seem to get resolved.

I found that it was some inode numbered 16979 which was entering DIO.
However, upon investigation I noticed that inode 16979 passed through
ocfs2_populate_inode() only when create_ino = 1. Upon adding a few printk
statements in __ocfs2_mknod_locked() I found that the inode 16979 strangely
held ocfs2_quota_ip_allc_sem lock at the mknod stage. I suspected it to be
a lock cleanup issue in the slab object when inodes are returned to the slab.

I found that in one mount session, an inode was mounted as a quota file,
with a very small number (mostly <50) then later on in another mount session
that same slab object is reused for the inode with number 16979 which
immediately causes the lockdep warning to occur since it still holds the
quota_ip_alloc_sem lock.

IIUC, I did not find any way the semaphore is cleaned when an inode is
evicted. Hence I think to add init_rwsem() to the ocfs2_clear_inode() to
stop the warning, since now that inode held ip_alloc_sem lock only, thus
no quota lock acquired during DIO and the issue never occurs, even if same
slab object is used which retains the lock identity. In addition, a check
can be added to block DIO on quota files.

Thus, I think the following change should work:

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 76c86f1c2b1c..372c198afa25 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2420,7 +2420,13 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
        struct inode *inode = file->f_mapping->host;
        struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
        get_block_t *get_block;
-
+
+       if(IS_NOQUOTA(inode)) {
+               mlog(ML_ERROR, "Direct IO is not allowed for Quota inode %lu\n",
+                    inode->i_ino);
+               return -ENOTSUP;
+       }
+
        /*
         * Fallback to buffered I/O if we see an inode without
         * extents.
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b5fcc2725a29..3e36da2ca5d0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1268,7 +1268,8 @@ static void ocfs2_clear_inode(struct inode *inode)
                        "Clear inode of %llu, alloc_sem is locked\n",
                        (unsigned long long)oi->ip_blkno);
        up_write(&oi->ip_alloc_sem);
-
+       init_rwsem(&oi->ip_alloc_sem);
+
        mlog_bug_on_msg(oi->ip_open_count,
                        "Clear inode of %llu has open count %d\n",
                        (unsigned long long)oi->ip_blkno, oi->ip_open_count);

What do you think?

Thank you and best regards,
Prithvi
