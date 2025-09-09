Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6610328D82A
	for <ocfs2-devel@lists.linux.dev>; Tue,  9 Sep 2025 09:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409267; cv=none; b=JB3RCR/knJNvrRun1uBhzhTogp7KYTokh+deANOK6X0QJs4hu3ZazBfnc+BKXKwfskeX+KksaixgemaYsDzN6OLOSqHO3Wsw+seJxqo8sk1FJOoj0Dck6b6Q+LzyDoClWLdd5LgKNUK9M6jk5c8PqWmZtwDtto9TrIcQq+Gvb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409267; c=relaxed/simple;
	bh=yPAQgvf69HeHuHpAroxlVxtZBxPIMT9A8QM9ZG6Y9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUu+cgggIAVR7XP2nhA+KnwiU9EZAkMX7skmhL/8eEnxyVUVCPB0c0p/woW+waEt7SE+/t2L9WIsEgLlBAzuJrxyRbiJLgkzh3trvacumVD6Z4c/AN/LfOYTt2OjTPCUCM1lJNk9T7Jdo7/TxBI9PlBFmwc9IIKq8QdWajoh9No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EawENTFL; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EawENTFL"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45de6490e74so17973065e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Sep 2025 02:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409264; x=1758014064; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPWaEeGmiR1jD0YeutpHA3nvEpV9+sv5w9Xmw28cyr4=;
        b=EawENTFLKf5D7DVzllW3E/w3lZw/+REpael87/dQX6tpRZs2dfvi4lrlXl0N6zykhQ
         jXwZ5belzof6gc9SYcuePgbf2gDK6dOOFjiYDfg/PRerF5amzW1r9Hb/XNGD4KcF2WpN
         f6uGC+B8MX1At259efps85Xgw3H3IJwLBS+ceMEWZXKhMLmh/XnNhsEi8JBNVfY4aOoh
         oDVml4LiKBD7WPRGlYOJCE04zTJQeEnoTwBKlfNVFrHyfEGzR583btzt01xvf6zGxLbJ
         wPYBPXi8BwAnKyhcu6ffAcp9zEdZxRixBqB/QAK+dAECrEwbEFv55sb+UqyW/xjsSKsU
         MaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409264; x=1758014064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPWaEeGmiR1jD0YeutpHA3nvEpV9+sv5w9Xmw28cyr4=;
        b=RkhhGddz8IM0XQmQxxjHjy8VR5dZ9TM2mQzPtUu9/lxgqXEuybB3EGAy1bkAO5luNr
         aKY21D/JI6UJSMpPo6RLEAZTUaZTuWYyxRqOH/0YPyz3OxDbFGymJJqvw4U02H6wm16C
         JJSYipF83RrgbanwDWcms2rfgMdLcfQuaDKKPRHosJ34YIh6gJC1wxf9gVNjDu/rnnyJ
         JM9dh5pGuMaUHlv2dkXypT/H1XUJcHuwaww2OcsvVusXqWp49imAWzpdtXBmrzFeV+Xv
         aFtO3AnrvgM3FXankpB8q3AS3vrZimNAdOe4KzM/vk+BPTOOTDBWqFlxEjaVjGRb7iKl
         dqvw==
X-Forwarded-Encrypted: i=1; AJvYcCUaXvKd5GF0upoM1u84K9/POmlUf1/bkgl2aW9JIJHT+ZsEgukFIK1+0Z63p3Mx7+4UApSkayDj4Hq5tQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxCljXXvneEjAldoZK+hR5nlYoI5zvKiKyrJQmkcPv5NVSVfsWA
	XtuZEWuZoSSKqTf+M7TS/Wf7g2jCr0isYLqBTBi8rpDd5HRo3SeUEOD9
X-Gm-Gg: ASbGncujYn5ZA26Vx2lNnZjMAyz8UcPlF/Ku005GKxWdpABODa7D4c5OE8ojSzYwTdP
	IEXiUMNJWx6P2iNPH94wlXbQeNgDKsYIfNabhOCM8fv9ILB+wq3cyTtY2/UnThyu52gv2Xcwf+6
	vC8oxdsz/C5AGHQK9k91jTukqtd9DbbogqGDhF3gwv3IiOPln5Q3xS/Ic0BY1myjuM2BNzQn6Ug
	Eic+6uq4PgCv0TJldy/GX+BDykNQ5pSNXjJ20ImqsHJmOKlKAqP41S5eqpnW8oLV/cTK76RHdmS
	5Mxxx1heencTBgJgufxD26Fv0dUqakYXcehynz6eLgoT3+/D3d9GTgailOJX/qhXVjS6Bqhd8fg
	uvkAa3BHCPiDyglEMXMn67vygdgzaud7zKAr8Ikw2Jg9F3ePi+BE=
X-Google-Smtp-Source: AGHT+IFJdhaaMaOuMypuGEFJh2pVDDxn5sp6WwusH/tMuWzKs+ug4owdxuI3aGQKmhUZs1+gw1gFJQ==
X-Received: by 2002:a05:6000:4027:b0:3e7:42e5:63dd with SMTP id ffacd0b85a97d-3e742e56a53mr8650428f8f.56.1757409263541;
        Tue, 09 Sep 2025 02:14:23 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bff6esm1810784f8f.13.2025.09.09.02.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:14:23 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 08/10] ocfs2: retire ocfs2_drop_inode() and I_WILL_FREE usage
Date: Tue,  9 Sep 2025 11:13:42 +0200
Message-ID: <20250909091344.1299099-9-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909091344.1299099-1-mjguzik@gmail.com>
References: <20250909091344.1299099-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This postpones the writeout to ocfs2_evict_inode(), which I'm told is
fine (tm).

This is in preparation for I_WILL_FREE flag removal.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/ocfs2/inode.c       | 23 ++---------------------
 fs/ocfs2/inode.h       |  1 -
 fs/ocfs2/ocfs2_trace.h |  2 --
 fs/ocfs2/super.c       |  2 +-
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 02312d4fbd7b..671c2303019b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1287,6 +1287,8 @@ static void ocfs2_clear_inode(struct inode *inode)
 
 void ocfs2_evict_inode(struct inode *inode)
 {
+	write_inode_now(inode, 1);
+
 	if (!inode->i_nlink ||
 	    (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
 		ocfs2_delete_inode(inode);
@@ -1296,27 +1298,6 @@ void ocfs2_evict_inode(struct inode *inode)
 	ocfs2_clear_inode(inode);
 }
 
-/* Called under inode_lock, with no more references on the
- * struct inode, so it's safe here to check the flags field
- * and to manipulate i_nlink without any other locks. */
-int ocfs2_drop_inode(struct inode *inode)
-{
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-
-	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
-				inode->i_nlink, oi->ip_flags);
-
-	assert_spin_locked(&inode->i_lock);
-	inode_state_add(inode, I_WILL_FREE);
-	spin_unlock(&inode->i_lock);
-	write_inode_now(inode, 1);
-	spin_lock(&inode->i_lock);
-	WARN_ON(inode_state_read(inode) & I_NEW);
-	inode_state_del(inode, I_WILL_FREE);
-
-	return 1;
-}
-
 /*
  * This is called from our getattr.
  */
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index accf03d4765e..07bd838e7843 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -116,7 +116,6 @@ static inline struct ocfs2_caching_info *INODE_CACHE(struct inode *inode)
 }
 
 void ocfs2_evict_inode(struct inode *inode);
-int ocfs2_drop_inode(struct inode *inode);
 
 /* Flags for ocfs2_iget() */
 #define OCFS2_FI_FLAG_SYSFILE		0x1
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 54ed1495de9a..4b32fb5658ad 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1569,8 +1569,6 @@ DEFINE_OCFS2_ULL_ULL_UINT_EVENT(ocfs2_delete_inode);
 
 DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_clear_inode);
 
-DEFINE_OCFS2_ULL_UINT_UINT_EVENT(ocfs2_drop_inode);
-
 TRACE_EVENT(ocfs2_inode_revalidate,
 	TP_PROTO(void *inode, unsigned long long ino,
 		 unsigned int flags),
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 53daa4482406..e4b0d25f4869 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -129,7 +129,7 @@ static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.free_inode	= ocfs2_free_inode,
-	.drop_inode	= ocfs2_drop_inode,
+	.drop_inode	= generic_delete_inode,
 	.evict_inode	= ocfs2_evict_inode,
 	.sync_fs	= ocfs2_sync_fs,
 	.put_super	= ocfs2_put_super,
-- 
2.43.0

