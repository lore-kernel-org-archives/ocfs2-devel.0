Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9F41F7C3
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Aug 2026 11:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787916520; cv=none; b=B9B2yv5ZPLvSGeQ6DdoK2mVsOx8C6pNgCWBAnVcynauGl7HkJnVjtzrrJrUrrvzVlIoTnXqFwhnZ6hpu46E/5PDuhbAbtARZn/GUuCbhKkz0dzcOWcvjRqJ1Dm95fAj6AIaCdUd2xiM/NRE3xhHJGUinMmR6c9tdzOvR9LeDWCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787916520; c=relaxed/simple;
	bh=/gbHNmSgNtdIkDrciN2lrqMW46sgKlW++Y8k09AhWXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O3HLo5gKQLu9e2kM6HDxnLSj63hSoo956iV+ysM2Ot7MsHllOK3Qo+G1txzaeBcX/rreai8vg9/kpBEthb8pzhej4keUbwJxUno1Vs6wSCeihB8tHFauWwWzhb9ydyhHIwOQOYKlj/lqLgQ9vrQlh/qwHfxXb7AX8El1E8w3A4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=w2OoyLWp; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="w2OoyLWp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787916508; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=KJGFtURAmGWFRlSvSJgxs80wZh9Z33BZIa4VmJay+WE=;
	b=w2OoyLWpAuknzUY55Cvu8b8pIwcqW6PRDoCrCBkiTWQnYR7XzPRu5HvQp6h0mLcgutXvTpVI9/ms+3JA42JCwd+IrRzc0G2UZpELpXmfkz9KpjbLBWU6loma2okubAU33HSZuwCWQIiRMn0EEY5e0Of+mRwF2ljm9qHm/ucqpCA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X9mHega_1787916506;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9mHega_1787916506 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 19:28:27 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Li Zetao <lizetao1@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Fri, 28 Aug 2026 19:28:24 +0800
Message-Id: <20260828112825.666097-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260828112825.666097-1-joseph.qi@linux.alibaba.com>
References: <20260828112825.666097-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
added ocfs2_free_replay_slots() calls to the mount error paths
out_dismount and out_check_volume to fix a leak of osb->replay_map.
However these calls are unlocked while the bail path of the recovery
thread, which is woken up by out_dismount right before the call, also
frees the replay slots under osb->recovery_lock.  Both sides can thus
observe a non-NULL osb->replay_map and trigger a double free.

Fix this by moving ocfs2_free_replay_slots() into ocfs2_recovery_exit()
after ocfs2_recovery_disable(), which waits for a running recovery
thread to exit under osb->recovery_lock, and drop the unlocked call
sites.  Both ocfs2_dismount_volume() and the out_super path of
ocfs2_fill_super() call ocfs2_recovery_exit(), so the replay slots are
freed on every path.  Since super.c no longer references it, make
ocfs2_free_replay_slots() static again.

Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/journal.c | 3 ++-
 fs/ocfs2/journal.h | 1 -
 fs/ocfs2/super.c   | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d8afbc1a76bb..a3938a03e93b 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -156,7 +156,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index f8b3b2a3d630..19fc920d26b1 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -151,7 +151,6 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb);
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
-void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f785c39d1fb8..6a8092b65bb5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1162,7 +1162,6 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1776,14 +1775,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_check_volume;
+		goto out_system_inodes;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
-out_check_volume:
-	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
-- 
2.39.3

