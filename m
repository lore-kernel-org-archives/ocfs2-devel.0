Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EE2DCF69
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764843330; cv=none; b=lZ8ipwx5pVxvzpLBWbEQUybgwViCJx94aKonraNMf2ZGADQtEsosCG0oYbH0Mbfa6wMcjo3d1udIRBikggu6THlGaedvcHrgYLHxdVIocbYqCqMQ1IzGthCUAMrvQxgCosJykJtT0FeXjdV4PeTIUNlbdcTuAURSBpAsZ1KKZ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764843330; c=relaxed/simple;
	bh=G/V5a2DM4z0s4NA1jFBIhpGM5FAP4Ci6VK98GbHxpMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6pRCzoJQAcpizMMjcwwmkDzIfSyfnkYg3XhdoNkoqZ4KxElcRLcDG2uJ78X8I1dxTu6OKQCrENySChN7kqootJW/FCIm7Xdah7JfGP/y16FnzDzg+7r8ekqycATmC7JQN2eZGkKV49roJUW01/LVf248/PBg4IUVPPQEneI0Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D3vOqOWy; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3vOqOWy"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b770f4accc0so94429066b.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Dec 2025 02:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764843327; x=1765448127; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=58j801WLI+nIYxqrnb2VGaqLqwLtuta5ZxrmeODMmzc=;
        b=D3vOqOWy4jobTRj1VzYioPIMMmCmScaro4vM1yZAH9tYOKdJFI2So7gPnigV8Exw5/
         YvmlQBWlrZMmPdzIgzITXK/xBKL8/SMpuNdPhbloqR7jHd0r3ZAViLErB97bKZHb8xpK
         lmOOHHC0Fgdvrsx7mR6uvjZhf+rS9W3UGP5kE/qU9Tz/9Gw9B/UmfCJsTsno/AS0XIAT
         e6B9lTMBYT2uKWisPsah15DBL+I+BoNrqVV3ZyO1EjbsBoOBaxnN7juonDfU3Q/NAWpp
         myt2W9VvnaVhgJUZXsZbyVfVynE8oKviH08opGSIfxhmvP1jUxMmpGHu9wJRTmdMmwyP
         gg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764843327; x=1765448127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58j801WLI+nIYxqrnb2VGaqLqwLtuta5ZxrmeODMmzc=;
        b=FO0T0ycm/WK4HMl6SzuSEBS36p5FBXV6IzDEvZqfsI1LaQWu54q0ywpe6HXwszsjDm
         W0imNGh+aox+Zv2Ap38T0Sw8zMY/1jN98WGz+o7O+OOVy39Gmj4Kd/QUUZD0v/kJiW+R
         n9GnRPH75/a8pBrAfsqu7WmeVV+Gf9Sxom+402oJ07+sK2eA0Pxv12djZaa6fb4kflA0
         ZHdbDPXmTb4iOMwYGgE8CPvC7g57xPBOP01SaiiZzVe6z2b0coAfC8aoCGaM4qcB6EpZ
         skHbeA8Z73VQ54wqFIsk+Zch548WctR5PHBW00jaGuVPsYSCM5p5Fwd8RYmLhPD3G8d0
         8A3w==
X-Forwarded-Encrypted: i=1; AJvYcCV6VxHUccZbEETTv51LwB67O02SLSnAvvzvU8TkWP0ioNJPtpIZcZ5BO702DZPpOUGK5nznUYyA+OBqbw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxTpBDhK0sjUOQtco8Mt/QNvDWeGq78x2XSlyVt5fTVRTxLOEfd
	HfMdbaoFwfJGOTDZY4SWjFaXip2xVknyQ3/+dTwfqnz0VfBtIfX1Z71HiePY2B80
X-Gm-Gg: ASbGnctjukxqQPZT0X0AnUvAzV129EzY9+zi4a12gXh9jtVd8Tm1h3qjYo+f+INOM/C
	lVUCqIS8JwVlXFLtLZIEF3ffLXny98C1IiEBwvIiookL1QAPWGujMjr64Bl8DOYznSCXCvwrAud
	1SQcabu0fCP40pqIUYxAPRsCOFeu1q8vM31xlZoW0ZdelWmEOfSukBr+muQgk3FO7SrRLwhsML6
	FLY5b6SwZb2c0evagfVYPIEppLNvCBCSifwUInTOCPFVfpDH8nNTAikBHL6gSvchG6HQjz0vj1t
	OnS3i3muVxC33lkKh3CE5MdXmaq+Wwa6+HEYweLXgIwz4UMlb2N4Ghs735dh+GPp4iObvseL52X
	W/tOwDqHwvVpAOLoEkk++LYQK79k15VDHv672x7wTbqy8nggZ9lBmO1HVJl5/MwetHbHS7WcKTq
	bBFvbImuYvsHIk7BUW9FKuPCZkumwOTKftDhQVVMg2uIRA96wHkyO3Njvy
X-Google-Smtp-Source: AGHT+IG5aE1vQvhlm3ydUo6OyEdm6Ub4STF8TNV1hee0aDAXuKoA587zP9S8T0STP6SoUCC84C0yPQ==
X-Received: by 2002:a17:907:7e9c:b0:b0e:d477:4972 with SMTP id a640c23a62f3a-b79ec486c21mr260273066b.25.1764843326518;
        Thu, 04 Dec 2025 02:15:26 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2edf71fsm956544a12.14.2025.12.04.02.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 02:15:25 -0800 (PST)
Date: Thu, 4 Dec 2025 11:15:07 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
Message-ID: <y3ucyzxisq6hcrhynzyhmb7h4vpzkyuueqesw547cx5zmzrvl4@offzqo327t4w>
References: <6930d0bf.a70a0220.2ea503.00d4.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6930d0bf.a70a0220.2ea503.00d4.GAE@google.com>

syzbot had an internal failure, so let's try again

#syz test

diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b9..87c99149a152 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1896,6 +1896,14 @@ static inline int may_lookup(struct mnt_idmap *idmap,
 {
 	int err, mask;
 
+	struct dentry *_dentry = nd->path.dentry;
+	struct inode *_inode = READ_ONCE(_dentry->d_inode);
+	if (!d_can_lookup(_dentry) || !_inode || !S_ISDIR(_inode->i_mode)) {
+		spin_lock(&_dentry->d_lock);
+		VFS_BUG_ON_INODE(d_can_lookup(_dentry) && !S_ISDIR(_dentry->d_inode->i_mode), _dentry->d_inode);
+		spin_unlock(&_dentry->d_lock);
+	}
+
 	mask = nd->flags & LOOKUP_RCU ? MAY_NOT_BLOCK : 0;
 	err = lookup_inode_permission_may_exec(idmap, nd->inode, mask);
 	if (likely(!err))
@@ -2527,6 +2535,14 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		return 0;
 	}
 
+	struct dentry *_dentry = nd->path.dentry;
+	struct inode *_inode = READ_ONCE(_dentry->d_inode);
+	if (!d_can_lookup(_dentry) || !_inode || !S_ISDIR(_inode->i_mode)) {
+		spin_lock(&_dentry->d_lock);
+		VFS_BUG_ON_INODE(d_can_lookup(_dentry) && !S_ISDIR(_dentry->d_inode->i_mode), _dentry->d_inode);
+		spin_unlock(&_dentry->d_lock);
+	}
+	
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		struct mnt_idmap *idmap;
