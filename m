Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2D33F59B
	for <ocfs2-devel@lists.linux.dev>; Sat,  9 May 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778334749; cv=none; b=kDVrYZjuBxfnqHQ8vveSU/oZXjKB+HLfA0Q1lHM6dyHwVcmMoPHkVBI8OnwtQcByAAnByttr/xS+8fPJh+UxBQAwVNQufP8HuUjHA2Vp9gDz+xZa9wDt8ysoz4N+HMIIFP2y16DO1HyDsUAHou0dyGllb+0XNAl1NsZya51ONaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778334749; c=relaxed/simple;
	bh=oKRklzu7CojU6UODEU9exFXJjCYlGIaJSGsyUtJ0HHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bOnp/7wIkAtP/unypXPM3if0XYeMP/rZfuEul5uhePnlCAzsZ5RqcfXuYPamInjlAGNANf4OhdqdrNoE673ZHKo16vP4ITgOq0sTzyEl/AZpfRuknSZo/2DRSv26r/Q8cruGGtTHuzRvL4eikw33BILg7/OSPKXap1y1b3P3bbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTeTSWyo; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTeTSWyo"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b4583f0a1aso18679205ad.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 09 May 2026 06:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778334747; x=1778939547; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kl6NZgNZ6AlicvShMnbTTKr3+jpscQfAAJQfVfcgMiI=;
        b=gTeTSWyoYXGPNCUHYdLYQNqPav+DHaYmkq6OBzeEB1fqxUQNzDPIa/1C9OiM4TsZvC
         40jKpUdu3ZeJOJhHuOWnwe1CopXTKOmv/00GWy1p5NHGOy8efQddO9dtVw9tvCQQaDuV
         Us5NUs9IR1zd/kqmy/+KVtXiHNeAzLWirKpprPLO8Fz7g53DClFxxfrX5oacifYCZmN4
         605JiLjZMbt0paiwwZyCjuoF6DFajZTYWk3yFo3o0ppEUUoNpA+MrOzlXYxnCUQnUu62
         O9THCvP0I+4+F6vRkX4llUZ9P69EeRoo5J+Z9jXmPm1elRqEldJJ8f+OGfR+1ZidryGP
         ZTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778334747; x=1778939547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kl6NZgNZ6AlicvShMnbTTKr3+jpscQfAAJQfVfcgMiI=;
        b=K/suv5HSKDnaiZtGy5897zp8jt/ks7/o+ioigeCOwRPXHNEIhWVuvfL3/TeVmrfXod
         aSrIlSaGI79uZigRzXirni/elgkrTHy3KY/kzZ3ghepnGYSH7IPLCrWkuktew62siCYH
         RKDObvAjG/5R16ijDkKb9mAYfa+PgBd9AVhvPQ1Bptmky5X2t/dmCfic00ClQucldBYO
         S6NZgBIF/Cpf2oMduNT2pzy/7CZBrgUPcG0y9AI7eQdmvdOS4p2dTXC8hptiLAvvbqz5
         49+Xme3iGHF0wSrNq0Ed4NXFaMjJhiL4UrCLn5QxMjNnVy+6LXRyftRYEG+HL1/YYxzO
         DnUw==
X-Gm-Message-State: AOJu0YxF4c6kKK2W0M4fGuCkFraCBGuAdFffL12j6NLbQBeenTvGNA0A
	aeeJRuIevnC2RqmMDOJE6CJMaFztqv5Ly+6Ecq5mEiel3FfnnQX+fom8
X-Gm-Gg: Acq92OHOSE++2jih4ANm7NW8ps/8FBTo7NJz/2mOqLqUj+BaV+reN9OTmZjxp5MOxes
	EgmI9Eg6VjZTS4LStgwINVSroM+2a9gQ2MmBwS6HKVYUWeuSjkmULAufXrD5QmVPvX1aAwNhYUo
	7uoVXnAE3FSEbgO6BvZz9tDEroBgA7Xb9RztdarSsUOQv3+6qpn3Efh6vKYXCnYMbpEh2nqMUUO
	QJHY1jPZodOEgo5Mk8kQEfT9E8wVZMjD8vxMFtISFkj2S0pvs113reGKYj3hq3opL50931URrj7
	KBjkhRyJ2SrNOOBV3Ce+frGhT2l81oEt4tW4u9Qo+NvBw5mLppK3tgq5LfkSSsEjetUcZdy9Z5j
	cLMiVpvL/k0+GX+Q2PsgMv0yjZOvAPla+SaMHLR05twumk1rs6dtRcfxu87EkSPk4KH15ML5Vvs
	WwLQLb/GSP0v80vkBcwkfmnTEUiP6A+wbiTeEEqQyq/zEaAXtjrbVUkWP6w+ofQi+C8A==
X-Received: by 2002:a17:903:1ab0:b0:2b2:a267:784a with SMTP id d9443c01a7336-2bc7aa20417mr26349575ad.24.1778334747044;
        Sat, 09 May 2026 06:52:27 -0700 (PDT)
Received: from gmail.com ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35632sm55534265ad.53.2026.05.09.06.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 06:52:26 -0700 (PDT)
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
Subject: [PATCH] ocfs2: revalidate the journal dinode before toggling dirty
Date: Sat,  9 May 2026 21:52:13 +0800
Message-ID: <20260509135213.925551-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A fuzzed OCFS2 image can corrupt the current slot journal dinode while
mount is still in progress. The mount path first reports the invalid
journal block and then crashes in shutdown:

kernel BUG at fs/ocfs2/journal.c:1034!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
Call Trace:
 ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
 ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
 ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
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
ocfs2_journal_toggle_dirty() assumes journal->j_bh still contains the
same validated dinode that ocfs2_journal_init() locked earlier, and it
uses BUG_ON() when the buffer no longer looks like a dinode. That
assumption is too strong. The mount path can force the same current-slot
journal inode block back in from disk through
ocfs2_read_journal_inode(..., OCFS2_BH_IGNORE_CACHE) while
ocfs2_mark_dead_nodes() scans the journal slots. If that reread finds
corrupted metadata, mount unwinds through ocfs2_journal_shutdown(),
which reuses journal->j_bh and turns the metadata corruption into a
kernel BUG.

[FIX]
Revalidate journal->j_bh with ocfs2_validate_inode_block() before
updating the dirty flag. If the cached journal dinode has become
invalid, return the corruption error and keep the failure on OCFS2's
normal read-only/error path instead of crashing the kernel. This
revalidation happens in the cold path of mount, so the performance
impact should be negligible.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/journal.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9bf3bac085d..c9a972a1304e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1021,12 +1021,15 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	struct buffer_head *bh = journal->j_bh;
 	struct ocfs2_dinode *fe;
 
-	fe = (struct ocfs2_dinode *)bh->b_data;
+	/* The journal inode block can be forced back in from disk while the
+	 * mount path is still running, so validate the cached bh again before
+	 * updating the journal state on disk.
+	 */
+	status = ocfs2_validate_inode_block(osb->sb, bh);
+	if (status < 0)
+		return status;
 
-	/* The journal bh on the osb always comes from ocfs2_journal_init()
-	 * and was validated there inside ocfs2_inode_lock_full().  It's a
-	 * code bug if we mess it up. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	fe = (struct ocfs2_dinode *)bh->b_data;
 
 	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
 	if (dirty)
-- 
2.49.0
