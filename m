Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733AE3EFD04
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Jul 2026 09:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782897384; cv=none; b=gnarR3sBlu7HeXV45kbtt7Z701WiRiiFBnT2QcftQ32keeQ4Um5+cbJXBVUh5jHVAmjXcYdx+z7nTn98+OHTj0SoPV5m5Km+l1ft6ntnmHgEIVv9U4JlEEeeTVa4LS9XCnZic3HzyLXIaTgPfUPX+6OvSw1c0TURdCYhPt9tKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782897384; c=relaxed/simple;
	bh=yprpUvdFEY/+h+aruRnF7kK0pxzCzrhZDe+AdS/ujXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuI6hAkK9FkRYt/2Vm+OdlHW4NT9jR66IYg4l3HL3HrhMv2E9kcAPJ/QW0m2QIWqIP8hj79xcjbJMEogPkYK3HhHKt/botwN0XWK+E8vWsmraWdaV3gAtz1slB3sRs30l+4U+Gp4WiuKm6UEHO/3P9PHa5Xu1IhJPXUYKL+8+PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCPo+wzX; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCPo+wzX"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ca7aaa4b85so2245625ad.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Jul 2026 02:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782897382; x=1783502182; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wo5Tlo2sCLraoPGeiQYr9vFDTM2pEDEskjKH8yXg0rI=;
        b=RCPo+wzXwMZSIMoWO2A6H9ITVIGV5wrIZ/lI1/L/UiJf0hJeOYYJo+UlZh2gjaB4e2
         tlHbrQXwnoTVZeoP0fsrKz7BTqloBHHU/TgqHPjO07gvgWq9pTRPIBvKYnoZQ2igMSRV
         WZXs7jweLwEEqAdxAoFXNORfFxdi2pG/0R0wEdV2riQJoM7F5SrGBssw5MyGJWe1LsRs
         8HjXDLtChU+ZmM6fjREFpNE/mEKlDf6Rp7kDLA8blnsYRQD7QWWYXG/J9zx9apuU/QRc
         IAfM9Xw06USah1KNCPb3u7MJyVVekRzJBuEUjdim9T7AJ4lb2EY6g9GnDUZaim/2V9B8
         cs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782897382; x=1783502182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wo5Tlo2sCLraoPGeiQYr9vFDTM2pEDEskjKH8yXg0rI=;
        b=M21Wagdlnr7UVX8BDOjR9AzDNR9G9k2RoxJMN9nClYJBFU5Wkw56i5RMipf/L0rRXq
         2WXGinhV2JhcsGtUKFJ9wLA++J6Bg+KfjFhblvFHbo5Lg8DSnlnQqlIY52pjywYOBMzu
         O3Q3l2thUOPp/M4S0pFJb4VH+c/IYMqfQNUTxUUs1UQekDipvLYxsgyeAwee5BRTN9Hd
         IrFommjLEB+I5z/Kg53Czv7PLxDnw6vz61eOhtzS3fOC96t9UXsFSC3GtwUGMVWxWQyc
         ++NKRMUYNiZFS+YBt7x6o2y7bRVkniGL2O0M+O6hJzk3gI063vdKELeAb1oTjr6tte+v
         xQ3w==
X-Forwarded-Encrypted: i=1; AHgh+RrweTWNfIbczRqi/FZFMmfytvLxvS+laOPKjj2+7smve3ICrzduF35dBMvZkilzTQJlKqbWjRCqstLuYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWbe83+8Env6uRAU1y2jjLQQhR+JZyRRqrOefOpR5exUDiabVr
	RN066ACeN034prvqcaELHugWzmpq3bRY2OIqTdB+IGMwYqYB0vT+fYBL
X-Gm-Gg: AfdE7cnTyBU3R5i648p926CO4slL4ohZvwbURw43JH/E4lV99MZqQFMqBo5QCD6aOk3
	ltmJEZfziHnpD8yufIswlawVkI06wT0UT24AiPg4BU39UnIEwP43I37tZ5YAiIcIODgL/Yo10gA
	I5KHVcHIDCXUqtIUzR8i3MQb032lhk7ErNTkXuXZMlIeMye5ldHvdKIodK8DAGtUmeBq43xqu3T
	fahs+l7n8qPpHmqRKO9dbFZWXFislgIObSWkSkW7I50jXQv5VYmPh6ZJZzlESyluC+A/6EGF8Hu
	PsnGksASkZXh9EPAN3OKitQhQqG1Upmd9VijP/8Hx+VEn8Mg9lEDvwjsbJvd8WbrHYAjST5VBt7
	oMUZo+5LoH8+5TlhDKVIM+BKKOngCWRnBMhbkKxT8qUwAMoLwChgbCJk+7dqhOOH9JXxn1pxUSq
	O+hX4lEcX7ub41DnzLz2T7isOD
X-Received: by 2002:a17:902:cf0a:b0:2c1:ee75:56bb with SMTP id d9443c01a7336-2ca7e7000ffmr8856355ad.20.1782897382272;
        Wed, 01 Jul 2026 02:16:22 -0700 (PDT)
Received: from ustb520lab-MS-7E07.. ([123.124.147.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c87bb8sm28970185ad.30.2026.07.01.02.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 02:16:21 -0700 (PDT)
From: Jiaming Zhang <r772577952@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: r772577952@gmail.com,
	linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller@googlegroups.com
Subject: [PATCH] ocfs2: fix hung task in orphan recovery
Date: Wed,  1 Jul 2026 17:16:13 +0800
Message-ID: <20260701091613.1008755-1-r772577952@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com>
References: <CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crafted OCFS2 image with corrupted orphan-directory extent metadata can make
umount hang.

During unmount, ocfs2_recovery_disable() waits for the ocfs2_complete_recovery
work item to finish. The worker scans the orphan directory through
ocfs2_queue_orphans() and ocfs2_dir_foreach(). If ocfs2_read_dir_block() fails
on a corrupted directory block, ocfs2_dir_foreach_blk_el() skips the block and
continues walking. On a badly corrupted directory this can keep orphan recovery
busy for a long time, leaving umount blocked while flushing osb->ocfs2_wq.

Return the read error immediately for full directory scans and propagate the
error from ocfs2_dir_foreach(). When ocfs2_empty_dir() receives such an error,
report the directory as non-empty so unlink/rmdir does not proceed on an
unreadable directory.

Closes: https://lore.kernel.org/lkml/CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com/
Assisted-by: Codex:gpt-5.5-xhigh
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/ocfs2/dir.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b03238327..9bebf28f4b77 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 	int stored = 0;
+	int ret = 0;
 
 	bh = NULL;
 
@@ -1873,9 +1874,13 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 
 	while (ctx->pos < i_size_read(inode)) {
 		blk = ctx->pos >> sb->s_blocksize_bits;
-		if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
+		ret = ocfs2_read_dir_block(inode, blk, &bh, 0);
+		if (ret) {
+			if (persist)
+				return ret;
 			/* Skip the corrupt dirblock and keep trying */
 			ctx->pos += sb->s_blocksize - offset;
+			offset = 0;
 			continue;
 		}
 
@@ -1950,7 +1955,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		if (!persist && stored)
 			break;
 	}
-	return 0;
+	return ret;
 }
 
 static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
@@ -1969,8 +1974,7 @@ static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
 	u64 version = inode_query_iversion(inode);
-	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
-	return 0;
+	return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 }
 
 /*
@@ -2189,8 +2193,10 @@ int ocfs2_empty_dir(struct inode *inode)
 	}
 
 	ret = ocfs2_dir_foreach(inode, &priv.ctx);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		return 0;
+	}
 
 	if (!priv.seen_dot || !priv.seen_dot_dot) {
 		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
-- 
2.43.0

