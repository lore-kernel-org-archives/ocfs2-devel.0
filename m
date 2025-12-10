Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D5B30CDBB
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 11:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765364435; cv=none; b=p+tC+QClnaYQ8qejrn+Y3KSKMcFikLPU0BT44hq1Rjl1XCPB5qpuUQi+HG4wJ+XwEZXd/AeZYAqHgN661u+6YaZg9dFdmeYhj9GlJqmHTTVX2KSgkPuVnxxSf6f+vuLgaWT/6ymS0HJYmotUjJLNXEsSsvdgl0NZLy4xHcQhG5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765364435; c=relaxed/simple;
	bh=TW7ptG2VGLM7MIIXlysIjpDJ1rDlw3b4192SxiYAEhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PvUKFwmo0JnVnTu3dxi8g8O+BclpTfLNngx7qjcITamDHVY4EhMu/cruvdu16OqhnrAb1lZAFf4Ou+fF5wz2+a8s54tnzF289/wrpw7CXv9xZyL/izsqQcqoHtSn9pMse4kBMHKS0pp/7Tzjoy6p/HYtYyamIENTt8AywsLj4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQw/ugKo; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQw/ugKo"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7355f6ef12so1059806666b.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 03:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765364432; x=1765969232; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JUCBAY4qDvjp9wL/tZAVGj7JAq7lGC8EJkzT657t1tQ=;
        b=LQw/ugKo7rkbiXpE4wxD2WtaflfAU+W2j3HbwrLjq8WFf1DNj/dKzpwXj9STkkBL+5
         O04hL/7vt7oqLqj2oIQTejik7RDm3xkxkacs5Ie2S2OvxOd2digW+f44HagsfyyWPPva
         4cuzhxE66GvuB177Mg0egPpdhVDq6Kqewu6unS0c9yyZRVJ8IhDSika7LVleyxPkKHqE
         Z3pUQd7aVpmOsDHj1zMSLEodPedwGbYdbofbmli58qJIDIszOAbxbqaKb7Q5D8uuhhcI
         rmE/TTP+qSlr80ohhJjfoMDcrH6WmryxAKY/4pBsbpDBWV+i1NnDFdSBG1CpcdrSv1KL
         W+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765364432; x=1765969232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUCBAY4qDvjp9wL/tZAVGj7JAq7lGC8EJkzT657t1tQ=;
        b=hZj59YnsRo8DptIeT7c5nbVu0OwQ8nzKLHs9Xittj1XG+wDN5YDahpOqsOVd48kLPZ
         9/+fs6zCdrLwJVBO48NCJymLAUr9DEkCA93p8ivLdM9dqPylLgsCQoZNMgTxTzRz2vOX
         c36hZhUDbvaChgE6CzVzfjSSyCYtf7/L4X4GTwMvzsO8/QdXQOVjVeZKMG3VIWIIfnLZ
         PrGRxp8cSmwv3hUuRfJDaHe3fzEGV/7Cad8Voubv/2WeKX6n+KCWv6AABeAllzvpGdIe
         7vmf8iPhsvXnlh2M2zspkSjDtuEigiDtHfm3fKb7hjmUWGLwj259q1tJCpTqWzQa2tnx
         QKvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVW2tOeHVnXYZMEnb/z8E0ss9UXsHd+wlRWlcDAMpcKbw7UDUamoqrCBo8uF8VArB/B5AnyAEZqstREg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwU/0DYL/DD65F165TrLo+NuIXcv6EB7GTeaJsKQszmE3ihY4zu
	zPdhivctH3D7EHi78jIaG3PEh4sAE9yuWc9IC3bO48xG+68+UacVF/0L
X-Gm-Gg: ASbGncu64B6c7rb1/Udx11/EjkCeIFRhGHODKanyY3sWO5XBOwR82/H3/U5yzf5v5P8
	A1pG18N1rUtb1Cinf5MgoTwtL2OAjf2DrnKckxiC7ne3Kl56W+/tWnuPh//7lVPlnd/mZhFp1st
	sG3BLqArr4zLZM3W/zVrwMUQDk2achNsqnJHjQz5fysBJ1UkjEFveTamk88HO4UTCeAbS/C+L7X
	MoIokUUk9cefXeFPbIC0tTFT1CZXjvk3pXyil5ou1OZZeceZRDnRexP2ZU3Q5UgBllZfDG5+MR+
	gIlUH0++gYBkFVhEdacWI9auhvtY6wahmTwPW9VmJ7ht18icAiQ5jCaZFX0SLce+K9MDC0GhEyV
	IT+ztWLEWaPRn15we6PA9j7lQFL3CCmZwHVLG7w3b+WCWrp9jP/1XtO58h64NjfQeOeF7UVdDti
	i+RxTrtmNPPdEClhmHvMQVpVmMeC8dfjvj3nwf0FQKCq1x1kk4jxtEiqUXiTs=
X-Google-Smtp-Source: AGHT+IHJKxYRtQRPvqRYTO6j4tJczi4RErxXKDoLUW8PEh7iqa/+cVG+9TyjyUNKbTJN95ADiumHBQ==
X-Received: by 2002:a17:906:f587:b0:b3c:3c8e:189d with SMTP id a640c23a62f3a-b7ce847786amr236110166b.32.1765364431914;
        Wed, 10 Dec 2025 03:00:31 -0800 (PST)
Received: from f (cst-prg-23-145.cust.vodafone.cz. [46.135.23.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49d24a6sm1633032666b.54.2025.12.10.03.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 03:00:31 -0800 (PST)
Date: Wed, 10 Dec 2025 12:00:22 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
Message-ID: <f2ui7rofuos4vcuj7t7pa5tcyq5m3agm44ouk7hcdl7opiwmwd@dyctf7rrsuqw>
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

the spin lock is needed because there are *two* fields being checked.
I am not adding explicit memory barriers for smething like this.

#syz test

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 0ef9bcb744dd..8e9127d4dcc1 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -207,11 +207,17 @@ void make_bad_inode(struct inode *inode)
 {
 	remove_inode_hash(inode);
 
+	/*
+	 * Taking the spinlock is a temporary hack to let lookup assert on the state,
+	 * see lookup_inode_permission_may_exec().
+	 */
+	spin_lock(&inode->i_lock);
 	inode->i_mode = S_IFREG;
 	simple_inode_init_ts(inode);
 	inode->i_op = &bad_inode_ops;	
 	inode->i_opflags &= ~IOP_XATTR;
 	inode->i_fop = &bad_file_ops;	
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(make_bad_inode);
 
diff --git a/fs/namei.c b/fs/namei.c
index bf0f66f0e9b9..f2a0f858b7d6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -626,9 +626,26 @@ EXPORT_SYMBOL(inode_permission);
 static __always_inline int lookup_inode_permission_may_exec(struct mnt_idmap *idmap,
 	struct inode *inode, int mask)
 {
-	/* Lookup already checked this to return -ENOTDIR */
-	VFS_BUG_ON_INODE(!S_ISDIR(inode->i_mode), inode);
 	VFS_BUG_ON((mask & ~MAY_NOT_BLOCK) != 0);
+#ifdef CONFIG_DEBUG_VFS
+	/*
+	 * We skip the type check on the assumption this is a directory, which was
+	 * checked for by our caller.
+	 *
+	 * However, there are bogus consumers of make_bad_inode() which can mess this up,
+	 * to be fixed soon(tm).
+	 *
+	 * In the meantime make sure we are dealing with the expected state before tripping
+	 * over. If this *is* a "bad inode", the resulting state is bug-compatible with
+	 * historical behavior. See the previous remark about sorting this out.
+	 */
+	if (!S_ISDIR(inode->i_mode)) {
+		spin_lock(&inode->i_lock);
+		if (!is_bad_inode(inode))
+			VFS_BUG_ON_INODE(!S_ISDIR(inode->i_mode), inode);
+		spin_unlock(&inode->i_lock);
+	}
+#endif
 
 	mask |= MAY_EXEC;
 
