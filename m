Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D108393DF1
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135004; cv=none; b=jG5gLsh/QDk8td5jSFpzS7+FuDK8YaiNxDmsHv8BkxkzTfYWVDKZczZ48DReDwqCUCbSF6M0RXpWF72vtq+f7wZfXISVEdyTg59aJvApEQZbeBXRPbBviLgZzivyITQ8tWM52P/ysnwlk6m4osRGJPh15lDWMELYApgawByOsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135004; c=relaxed/simple;
	bh=a04pYfbZqd0lXys4w3VawU4fdSwU3o61Wki8NbjOhAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ND5GKTs2zPNQfrWMXHShVxHWHJqSvurCk82aXDs9rgGyDg8gvIiG70DB7loUDeLj1ECk5OAsQBVpeQaDa1qeNNUbJmSy/AcBADH3dDOScDd7XbAiGXx0KB3bIIslSr1cKJR4hRfbhOyY7ZLr1w3oyP8zjXVrq5UNb8MuQkHG2b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qki9ZHsF; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qki9ZHsF"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad21f437eeso4711785ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 06:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775134998; x=1775739798; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dvnDWWlOS4am01De6pA0Yu2X2d4RML5xtAQLWQpwi0A=;
        b=Qki9ZHsFVg2pEAzHOkU7o5rAVyTctPm0Y+BegttRKGHoLcgIgmereRQQcGrdm2A9bh
         tlWjxP9+D5pDGwwLHj5UAovWGihlxq4sl2yFDScm8nV6O/DwWGqEUL3C+ltvW4HRQAil
         xhAbboZcZ35R0OBy4c8eb9x72Uiczt4VM/FpC/mTQHGkrcy8I6bU3gYelN4Npcp/SXQr
         62cvz4UdshJwar2XCZCdU7BTMAPXDFyA2J2ZAoYfxrw2bSGNTjDeuNEQrQsFSP/XmZQJ
         7HJyLDGRUj1RStH9mtR+ci9HTSqeBjb6wl9aZPF99aIVwCfaMgFIz5cHfRkbe6GAxEvK
         jngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775134998; x=1775739798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvnDWWlOS4am01De6pA0Yu2X2d4RML5xtAQLWQpwi0A=;
        b=pI87mGadyKvFSHbA+o9h8XD4Fe2hYuUv/eRQcpybJUSYpFrew++S+IswzVSHfFEFUv
         4QIsXzbmRinJkEtPikvzLD5HYOAWEGCoMb5eeQr7vxT0nwBbuIU7SU/kL3AYu62eoMHr
         eL8fN7Rh0VYRtF68rErFlk8XEruMlufVCHaPa74UoVOT1VQThmVA79ULKMcJYQtf1PxH
         tSEC6WpvKCSvCblqMDEeEKL4mtUK5av/80q3JTRnBcY5y0vvaxgzgdNnJqwhCsuQ65V7
         dpNaxTwfS5dhtoDUm4hk8b3dMSxa7BA00UBo+DAN4JBgs8bAWZu5xg+uFRMkgeBRVH0Q
         t8ew==
X-Gm-Message-State: AOJu0YwWPHTMREgOvJzNd0GLrfdlwYlOnz5KWfSCo7rPC1OUuuhoVWs0
	HJAY5+VuawEjIKeBEBGDQAUgMPgyyy5VuD+uRaFaf+bplU6JuXvhKtKq
X-Gm-Gg: AeBDiesWkk5yhISCP2AYJ1KmFjxqQAAARS9m/spzvyuhCx9TQmLqDD6ZUqHBfu8x6mG
	ArYf0n+lKPcTumlgREpTw6j0LgW87K+9BWl7tmJY/s1Bq+LFmi1NUg6NSzo/JP7BcSmTQldHByU
	efjPhVkuu1D1BGurpGm0H4O5Gu8P71046bSM+O8lP+nbSYPpgKGwDBquV8efDpUHMNFnXdvQYMd
	p81YdnHJlhgAO8XdUa4M76Ig9AMJeCMprY5b6Bc0qoK0if9pC6Yfc/L6SixLQ5G76H82HJIIYxz
	+Zby179BUm71H9MiOHWs/BrcnT1Rpo4SkSWMlK5MDGR4VuvHYJXf3mSG1XW3YGKGdcemVCe8g52
	48AIpAxf9UAAtBsQ4g8otPfYjGBuzfntrmeRUPBfZ2rt0iqGS3sGQ/wBWEXEuutmvpFrYaj71mM
	udogb1Ki+lJwW4M1bN7XO+J2laqnGZlPKqCIKjAOms+bMAU7xBb7YyTOiBU3MLjufVw/libnU=
X-Received: by 2002:a17:903:2ecb:b0:2b0:aebe:259 with SMTP id d9443c01a7336-2b277e31cafmr24457825ad.19.1775134997864;
        Thu, 02 Apr 2026 06:03:17 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979500sm39920465ad.44.2026.04.02.06.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:03:17 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: reject superblock-flagged dinodes during inode reads
Date: Thu,  2 Apr 2026 21:03:01 +0800
Message-ID: <20260402130301.51388-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
kernel BUG at fs/ocfs2/inode.c:412!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_populate_inode+0x128d/0x16e0 fs/ocfs2/inode.c:412
Code: be040000 00e8f3da05 00e914fbff ffe8d94ec8
Call Trace:
 ocfs2_read_locked_inode+0x79a/0x10c0 fs/ocfs2/inode.c:618
 ocfs2_iget+0x7fa/0x9b0 fs/ocfs2/inode.c:157
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:142 [inline]
 ocfs2_get_system_file_inode+0x389/0x820 fs/ocfs2/sysfile.c:112
 ocfs2_init_local_system_inodes fs/ocfs2/super.c:491 [inline]
 ocfs2_mount_volume fs/ocfs2/super.c:1756 [inline]
 ocfs2_fill_super+0x1330/0x3cd0 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
 get_tree_bdev+0x24/0x40 fs/super.c:1721
 ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...

[CAUSE]
A crafted OCFS2 image can place OCFS2_SUPER_BLOCK_FL on a block that
still looks like a dinode to the existing validator. That lets the block
reach ocfs2_populate_inode(), which still BUG()s when the superblock
flag is present.

[FIX]
Reject that flag in ocfs2_validate_inode_block() so normal inode
reads fail before they reach ocfs2_populate_inode(). Mirror the same
check in the filecheck validator and refuse to repair such dinodes,
so online checking reports the same corruption class instead of trying
to patch up other fields around it.

Add a second guard in ocfs2_read_locked_inode() for JBD2-managed buffers,
since those paths can bypass ocfs2_validate_inode_block() and would
otherwise still fall into the BUG() in ocfs2_populate_inode().

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/inode.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..5f34f3afa3b5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -611,6 +611,18 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 			"Inode %llu: system file state is ambiguous\n",
 			(unsigned long long)args->fi_blkno);
 
+	/*
+	 * JBD2-managed buffers can skip ocfs2_validate_inode_block(). Keep
+	 * SUPER_BLOCK_FL away from ocfs2_populate_inode(), which still BUG()s
+	 * when that flag is present on a dinode.
+	 */
+	if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
+		status = ocfs2_error(inode->i_sb,
+				     "Invalid dinode #%llu: superblock flag set\n",
+				     (unsigned long long)args->fi_blkno);
+		goto bail;
+	}
+
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
 		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
@@ -1503,6 +1515,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (di->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: superblock flag set\n",
+				 (unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
@@ -1570,6 +1589,14 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
 	}
 
+	if (di->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: superblock flag set\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 bail:
 	return rc;
 }
@@ -1615,6 +1642,11 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	if (di->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
+		/* Cannot fix a dinode with the superblock flag set. */
+		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+	}
+
 	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
-- 
2.43.0

