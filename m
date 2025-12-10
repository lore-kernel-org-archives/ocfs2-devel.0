Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BDA136351
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 19:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765395868; cv=none; b=EPsnmJFXEAjb/zXeI5K1hssHTmmxRb5E7cnsmz84Y3NwwBpZmO1FT+00orbp+ujv2tx4v4XIsM2n9z2Zrzd9DB1+8V59hnc7xTlDOGrgl7Ls7EZZFyXvjwy2lc9+RzbdA51YvrM7KvgJYaen2ddNw2afwzazv/O3H+hYQsEeo2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765395868; c=relaxed/simple;
	bh=BM5U+ur8+kuwJUHAcEm6G04NmyxtWiuOzK70jRwbkjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZTWLJNldTpMJkvhf5lnUKbpxZxtU8Oy2m+RTwP+/ZSLm18K5GRToljN/qR7az0PKOdqUN057hWj5kyLrgoqn5lNMiV/hrq5mPgF1OTDM/pKvZryHnR88+wa0/TzwCdNoaAjqawDbAeaga8xvN7mZQjWH//8k0ooCju3foFP9rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+CCu0TO; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+CCu0TO"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b728a43e410so25805766b.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 11:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765395865; x=1766000665; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AH3EyuDOOrGQUL8UyQ9msmnt00BT3pZvjBZ/byMHlXg=;
        b=K+CCu0TO/c4eCNP7MYf7WrlZ6seyMUkxVZrakl/CnWk0yoPCXVV1eOz70JGw9QXNrv
         6w8Gj0eXx1qsJIETf2+tHVH8TWgSDqQ5OFRX4MYlXsiUDCKIAoquA6Qw24UKZUafCLyR
         iUECoH5HoJYBdWvDxfamcG59HpD2xxHzk/23mFIn3fzN2eyUg41fq/0o5wY3vbSutAQj
         Iol/iWFaYGz5IogUszxc/eIpup5Jiimrf8rTcucOO8X6en3vryMD4SM2j7PDZl+aeBir
         z4r42I9pR6VgJ++YXQQbGse2QY+ndOB+eEXq9VjPj43PkX/YGGV76aCsypNu6KbqO/3b
         kgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765395865; x=1766000665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AH3EyuDOOrGQUL8UyQ9msmnt00BT3pZvjBZ/byMHlXg=;
        b=sXQDhM8y20fb9fykVuig2IHx/W3uIk8eX/bij0AwBXs8Jr2TlWdC3+qToGLvGN0nfi
         8BTlKnQd1l3ko4lY7uqGMrVEshVvPOnR8i18NBsdqjENQ/99gbgRqT0OunMzfdZTcJeH
         S75+WPMZ3S49RpAckwGn0XP8vEGJj3SuNhJmOYMJKWKIvRoHqHhXY/HTpezZ9wbdZM4W
         4Z/GRHGwl5jznUp/XzwaJvky2iaWEaWslUpr6dHse3taX4i0v/hVPoivWMmDr7CDPLpi
         ZonaKkrR8rEMHyTZ+kCVSBq3SAJvYM8wc1fW8RFeymLiyc5DfWxAg31bUF392+Kv6Nh5
         48jw==
X-Forwarded-Encrypted: i=1; AJvYcCUCqPXS5NGErGEjF7KDYL9mZpPssJujRxic+KFUMLy5vkKoPQGy2OJXsHzgP/1OzkOtmyGdFCFecQHPEw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzWQIKiN+ds+LjedY2ngac4+WNoqi5r7Fn76XrZqkfo5T3vfhV6
	FwMgipWMTGgqdUtuI8/B6x90g3Vv6xlpFyKj2YKOKJAHkyJb3ibmAYlD
X-Gm-Gg: ASbGncv9PmRyp/xuFu1v/44D7zPMyMN1S7FiYI4jVAmrtKQLQ8ggZrYyQGfMwzJYPrt
	ijawXUa3PgGcodd4amX0xTtByWEoGkTHHTW5DcAFIP/O+7r1Kwo2VqMxh3ayDsgKGvdYqxMvdPk
	NnhyAwY+QItYgRCTmO20zm+iEnbifa6ysoUroOyhdrVU2jSiX+Esa5eb1FeGjioIxtMgc4zoI3O
	js8isa3800+ipHsyGbs5DatNj2KR6lzFSIpqsLumTDq+VelY+nze3jwpu9RzAw2N0uSGfdnXCQj
	Q0RiD+460SH+h7OU9pyWs4SkvYaNmZ0Ohc5l5jSYjlyqrRUJWTXljtuwVuEb3EclHMGY15+eqgQ
	uo+KfO9OXk5gr0Aj3SteOyg/Nue97oraDMAeTtr6wugBEeFD+4fPauZV6iDkpBap9U2SALhpwta
	eBLYeVRoHNKqNrU9c1+cFdCf+eRhZH8rtXCFaG8KvzuqFUFPSrmetGV6Vmg3P3ElXI46LIKg==
X-Google-Smtp-Source: AGHT+IGGmaJskMrczwvREm0lrYOhNSY1gkqqtq5Hr2CDTE4maS/m0w6W08TOf7XoqXekv+k+DhfmTA==
X-Received: by 2002:a17:907:6e94:b0:b79:e99d:913d with SMTP id a640c23a62f3a-b7ce84a901dmr342173766b.42.1765395864453;
        Wed, 10 Dec 2025 11:44:24 -0800 (PST)
Received: from f (cst-prg-23-145.cust.vodafone.cz. [46.135.23.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa56c152sm39047466b.56.2025.12.10.11.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 11:44:23 -0800 (PST)
Date: Wed, 10 Dec 2025 20:44:08 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
Message-ID: <ff7k3zlpiueyyykotdpfcaoxn2tukceoqcbmfdwjfolndy4sen@3f5r362sg67g>
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

Justin Case suggested the following:

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
index bf0f66f0e9b9..79cc14d635b5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -626,12 +626,31 @@ EXPORT_SYMBOL(inode_permission);
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
 
+	return inode_permission(idmap, inode, mask);
+#if 0
 	if (unlikely(!(inode->i_opflags & (IOP_FASTPERM | IOP_FASTPERM_MAY_EXEC))))
 		return inode_permission(idmap, inode, mask);
 
@@ -639,6 +658,7 @@ static __always_inline int lookup_inode_permission_may_exec(struct mnt_idmap *id
 		return inode_permission(idmap, inode, mask);
 
 	return security_inode_permission(inode, mask);
+#endif
 }
 
 /**
