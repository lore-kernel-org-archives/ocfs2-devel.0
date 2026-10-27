Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793075557;
	b=SXhzVTW/EXSpXpmwqol1igkPVaTLRbKLTC/Ah8HlPLudlx8vRXwT8m0Q0QNPMBGbXzn/
	 JRNy8TvQ6LSejXCqpgHT/Cwk8/R1JWQt3O4VdjYgcffy61yq3eD8vdPKGpF2G/qvzxz7M
	 NZZPz7LKsORNuA2lDkeblO2mxX+aMocmA9sjkfox8WjQxBtpdpmhi14vh6lLEaapgkW8C
	 6afUZzxDtjrt3mHCOiGqMcEhdgYIAWp6nrh/OhBgB6zEusS0zS3bjjg5DPzgtvCHlHhSr
	 EwkpWguHoGK8z7Pz0iyU8m5y238zp9UOzbVz12qaZhkH9F+YEaov+mHHHw53kgDZaqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793075557;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=beH3LIXHCpnBC80V4Y086Pbi9jHjOQOYfz6A2+Xry6Q=;
	b=IgKajZ5Hhv5G/P0Bs0THuG657639/v4NlGQcVfRPYuVgrJvEhFyQ6LKv0kWl6hsX/lXl
	 1JBmUMnoMBYhGZC1Bep7yWk5GYTBUulGYbaJuPcF0orktNUz20zh035ZfF5rqcSe7U/db
	 +mwhbniCvJBidjxL/WjnxGm0yRKgvmCySmmPyzGmJjcQn8f/6ahKnkrqeHy7UMAUu8e29
	 Mh0qBA3gDfNvnocR80oRB47nUiEAJnznJz1IK8RkiEPcFNnRLhzzK4UnkMqx8LFlTRYoA
	 ggRO9jNWTobnZpaqBbbQHKwvuXho7orYAlzBW95qkKu9R8yENjMgXOPqwcphWDyoMfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GPG5qyFI;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87677606A323
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Oct 2026 04:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87677606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GPG5qyFI
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a058315c79so1444628b3a.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 21:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793075557; x=1793680357; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=beH3LIXHCpnBC80V4Y086Pbi9jHjOQOYfz6A2+Xry6Q=;
        b=GPG5qyFIcDdHxr4X/iGklcxjZWxADZD7GuRanG3ITiuDbu6EOPlL0oMka6+SkxKQwI
         C7khIfyJUsmS1kTdWAkfYHVAa3Jj8y2/Wdo2/LSNqg/blkl/4uWSrYc1iRWd7Uwz4RoZ
         hS/2PfyFyn3c/u53/A/JCPB0bTDhMMaFE7jN0UZYgoglPuZtoMrVh5oTY0Ze8nz8lG0I
         1nkhswrHtCX3+smmz7w7b1tyd5D4s+yuAIa3nncth1ojYYM+t6VxgQ9SfV3Kd+Is9Xid
         zy3WlrwJ1ZCCbeRVzREkRSHtP4MK3jkHhnU4zhyPStgBoYn8wAXJWEGzaf/URS6NLe85
         ykHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793075557; x=1793680357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=beH3LIXHCpnBC80V4Y086Pbi9jHjOQOYfz6A2+Xry6Q=;
        b=SCiXaDLTk7J3BrGBTXsiE1E9Vx65tLgIKjuTvg0rp+Qa6SLLxp6Ad4WM/uGnK8eC29
         aOkReWDmDdOAoEe5CoBvAI6e0yKi2T6ZIzXBkRM9yWqDLDYkewQhuonLGXpP2wmVKccK
         gwMKL+fqT1SY9Rel8qEjvz3XHx2P2nFmqcOKAM428m8x+RCLsbhMJoyLoirwtLbkno5v
         ikSTQgav411giGIfH4xapdfxOXlreVV7TBtLqCXUuoAQQvBaPyxxzBAyW12e+JM8v8vm
         S7zDnJNykZf6NAqm0XbkvPoGy8cjSkEgASUGSAtZ6V0JI0qHhThYFMBwEzmMnpdb4xP/
         DhCg==
X-Forwarded-Encrypted: i=1; AKwUvBxfDh0x2HIsiplHiLJGJ4NC0EzeRyW4Le+WT96nJnuhTpznm2LF7aIgl7wahkIrq7yw0sB+OHKlFrVXgQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJXg7cSAKqcXMIMmiXY8S0coWMzu5w60zxd1ImQTJkmUZd1UoYc
	B5kMxP6aQiAcZYK5ckoZk5TABBLUP3yS3Eb2rOudrRojGOU2Wt1UdIio
X-Gm-Gg: AYBFou0BsiVRn+mDhe4I15jViBAvMvYYiLcki7kyO0lvMX8e/MuEp8oQPofcd7LFFix
	Em/nAJT7PDZtUVsy7VV3qlWk/LUI0R7aDGHRl3VBxa3XP1HekWhNJmWwMAWqpF3MK8NtqEODW9G
	Bg9Xp1tA/utqyUgcbMteoRvq1lkFhJyDA3YqncUWWfmI2cwgrzIqC+msbX8fPEC8S8kmvBdu78k
	MLzUFwj0tJ4Puay7pq2z4BxaUww2XJVYlKmpJG3MMTM0AjfYmWKo2qFAVZcxzHFYMrCSg21xNZf
	lR2zM7Hl5Nv1EM9B8If7oZy0OBiJQdKinEA4Lpi3e/kK87ARKO9RyG5bK0Tin4D9SuVRey03pMC
	aGAwrS0X80P5Hbm/AHx/VDy2VpOc5/mD2i4TFuksQ45+H0uooVurfYVmAx6QpzY6mcntXmSh9mV
	OLD2yVpIUURRAoO8eIZwbA295vvGSZ/ka4n1HgVb7igc0/cuwQF1EHWpwuTdoY+Jd2pbpsGR3Q0
	Ayk9KxD3hPfwT32y3zvHb+uZpENiH8Npc8r3Qp/FYKBsqmhBURkxrb9hOtnugrXRYbJpsAzTDoH
	zsQ/oBOKZ/nKgVGXrasRmown
X-Received: by 2002:a05:6a00:ad02:b0:881:cbb0:6a90 with SMTP id d2e1a72fcca58-8a36772bf53mr6311975b3a.58.1793075556731;
        Mon, 26 Oct 2026 21:32:36 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36bb2a7e8sm1735435b3a.39.2026.10.26.21.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:32:36 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2/dlm: serialize migration MLE cleanup on failure
Date: Tue, 27 Oct 2026 12:32:30 +0800
Message-Id: <pm-ocfs2-objects-candidate-0038-v6-44416f9847751914bacc@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A migration MLE has a base reference for the mastering answer and an
in-use reference held by dlm_migrate_lockres(). The finishing assertion
consumes the base reference, but migration failure drops it again
without checking whether the assertion already consumed it.

The target queues its migration worker before it acknowledges the
ALL_DONE packet, so its finishing assertion can arrive while the sender
still waits for the status, or after dlm_send_one_lockres() has
returned a connection error for that very packet:

  Old-master sender                  Finishing assertion
  -----------------                  -------------------
  publish MLE; take in-use reference
  send ALL_DONE; wait for status
                                     take lookup reference
                                     unlink MLE
                                     put lookup and base references
  send returns a connection error
  put base reference again; free MLE
  put in-use reference; access freed MLE

dlm_assert_master_handler() holds dlm->spinlock from the MLE lookup to
the final puts, and it takes dlm->master_lock around the unlink and the
puts. Decide under the same locks: if the MLE is already unhashed, the
assertion consumed the base reference, so drop only the sender's in-use
reference. Otherwise unlink it before consuming the base reference so a
later assertion no longer finds it.

An assertion that got there first has also made the target the owner
and cleared DLM_LOCK_RES_MIGRATING. Treating the attempt as failed at
that point would leave the lockres owned by the target while this node
still holds the other nodes' locks, so it could neither be purged nor
migrated again and would be misread by recovery. Complete our side the
way a successful migration does instead, unless recovery has taken the
lockres over in the meantime.

For a send that failed with a connection error, wait for the target to
die before deciding, while the MLE is still published. The target may
have received the packet and may still assert; an assertion that finds
no MLE for a lockres we still own is fatal in the handler. The wait is
bounded as before, and an assertion that arrives even later meets that
check as it did before this change.

Use the same cleanup for the pre-send failure, the send failure and the
target-death failure paths. The sender's in-use reference keeps the MLE
alive until its final put outside the nested locks. Successful
migration retains its existing in-use-only put.

KASAN report, only the relevant frames are kept:

BUG: KASAN: slab-use-after-free in dlm_put_mle_inuse+0xce/0xe0
Read of size 8 at addr ffff8881190e3c20 by task umount/593

Call Trace:
 <TASK>
 dlm_put_mle_inuse+0xce/0xe0
 dlm_migrate_lockres+0x16af/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940
 generic_shutdown_super+0x15f/0x490
 kill_block_super+0x40/0xa0
 deactivate_locked_super+0xae/0x120
 deactivate_super+0xa2/0xc0
 cleanup_mnt+0x217/0x450
 task_work_run+0x144/0x230
 </TASK>

Allocated by task 593:
 kmem_cache_alloc_noprof+0x20b/0x5c0
 dlm_migrate_lockres+0x20e/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940

Freed by task 593:
 kmem_cache_free+0x242/0x580
 __dlm_put_mle+0x4b2/0x660
 dlm_migrate_lockres+0x1690/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440

The buggy address belongs to the object at ffff8881190e3c00
 which belongs to the cache o2dlm_mle of size 480
The buggy address is located 32 bytes inside of
 freed 480-byte region [ffff8881190e3c00, ffff8881190e3de0)

Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
Changes in v2:
- Complete the migration instead of failing it when the finishing assert has
  already switched the owner, so the lockres is not left owned by the target
  with the other nodes' locks still held here (Sashiko review).
- On a connection error from the send, wait for the target's death before
  the MLE is dropped, so a late assert finds the MLE instead of hitting the
  handler's check (Sashiko review).

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0038-v5-5e414ac0c701d2ccd4b3@gmail.com

 fs/ocfs2/dlm/dlmmaster.c | 82 ++++++++++++++++++++++++++++++++++------
 1 file changed, 70 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 612969867ff9..a96060b87b9f 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2525,6 +2525,52 @@ static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
  */
 
 
+/*
+ * Drop the sender's references on a migration MLE after the attempt has
+ * failed. The finishing assert from the target may already have unlinked
+ * the MLE and consumed its base reference; decide under the locks the
+ * assert handler holds, and only drop the base reference while the MLE is
+ * still hashed. Returns true when the assert got there first: the target
+ * has become the master, so the caller must complete the migration.
+ */
+static bool dlm_put_migration_mle(struct dlm_ctxt *dlm,
+				  struct dlm_master_list_entry *mle)
+{
+	bool asserted;
+
+	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->master_lock);
+	__dlm_mle_detach_hb_events(dlm, mle);
+	asserted = hlist_unhashed(&mle->master_hash_node);
+	if (!asserted) {
+		__dlm_unlink_mle(dlm, mle);
+		__dlm_put_mle(mle);
+	}
+	spin_unlock(&dlm->master_lock);
+	spin_unlock(&dlm->spinlock);
+
+	dlm_put_mle_inuse(mle);
+	return asserted;
+}
+
+/*
+ * The finishing assert switched the owner to the target and cleared
+ * DLM_LOCK_RES_MIGRATING while the attempt was failing. Complete our side
+ * as a successful migration does, unless recovery has taken the lockres
+ * over since.
+ */
+static void dlm_migrate_lockres_asserted(struct dlm_ctxt *dlm,
+					 struct dlm_lock_resource *res,
+					 u8 target)
+{
+	spin_lock(&res->spinlock);
+	if (res->owner == target)
+		dlm_remove_nonlocal_locks(dlm, res);
+	spin_unlock(&res->spinlock);
+
+	dlm_lockres_calc_usage(dlm, res);
+}
+
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 target)
 {
@@ -2609,9 +2655,10 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	if (ret < 0) {
 		if (mle_added) {
-			dlm_mle_detach_hb_events(dlm, mle);
-			dlm_put_mle(mle);
-			dlm_put_mle_inuse(mle);
+			if (dlm_put_migration_mle(dlm, mle)) {
+				dlm_migrate_lockres_asserted(dlm, res, target);
+				ret = 0;
+			}
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2639,17 +2686,25 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 	if (ret < 0) {
 		mlog(0, "migration to node %u failed with %d\n",
 		     target, ret);
+		/*
+		 * The target may still have received everything and may
+		 * finish the migration. Give it the chance to assert, or
+		 * to die, while the MLE is still published, so that a late
+		 * assert finds the MLE instead of a lockres we still own.
+		 */
+		if (dlm_is_host_down(ret))
+			dlm_wait_for_node_death(dlm, target,
+						DLM_NODE_DEATH_WAIT_MAX);
 		/* migration failed, detach and clean up mle */
-		dlm_mle_detach_hb_events(dlm, mle);
-		dlm_put_mle(mle);
-		dlm_put_mle_inuse(mle);
+		if (dlm_put_migration_mle(dlm, mle)) {
+			dlm_migrate_lockres_asserted(dlm, res, target);
+			ret = 0;
+			goto leave;
+		}
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_MIGRATING;
 		wake = 1;
 		spin_unlock(&res->spinlock);
-		if (dlm_is_host_down(ret))
-			dlm_wait_for_node_death(dlm, target,
-						DLM_NODE_DEATH_WAIT_MAX);
 		goto leave;
 	}
 
@@ -2686,9 +2741,12 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 				     res->lockname.name, target);
 				ret = -EINVAL;
 				/* migration failed, detach and clean up mle */
-				dlm_mle_detach_hb_events(dlm, mle);
-				dlm_put_mle(mle);
-				dlm_put_mle_inuse(mle);
+				if (dlm_put_migration_mle(dlm, mle)) {
+					dlm_migrate_lockres_asserted(dlm, res,
+								     target);
+					ret = 0;
+					goto leave;
+				}
 				spin_lock(&res->spinlock);
 				res->state &= ~DLM_LOCK_RES_MIGRATING;
 				wake = 1;
