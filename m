Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793069638;
	b=zbpakeU/+1Bx220aB20biB3Yar4SsEpQPNWzJy2RBftxD4JgZX1Ymo+d9i73awDQdl6t
	 g1YuqMY2Jlym3eNz0zZ1lRxSmr77dkRGOnkhexcc4mn6p36GsJ7oHzk5NT8rSJUv9fqxF
	 3/u2YTtRzxCI0vWU18J6HUUs4IdB8saa/PKfFsoS8165pbCTkyF2iLnToriR7DaFrHKMG
	 GJAYzwGwJXfbFUSMkeHf1dR6NI1Kt7nVaDoT7yjTu8hQ0pQUmqSSksLJVVhjdDbK1VzJH
	 t454ESM6NZDTzOfg/J9foo6SDklhukImfcpNdgfXkbAB+uvx+AIIcAX8dYhLkT+nSVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793069638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zXjVpleUX/UUgVHHA3+E1ewAvZlUSAbbu6EQ+dmYP8E=;
	b=AuiFKZAaGZI8fZCm85F1Ifp7iugUHxtbNochEFu4dCVDHAJwsLvX0zYfWfr772edgpfA
	 jkiAh1SvDi47fN+0+79LaJ57xzV96REU03YBi8MIPTlOpSobCD1zg2xTAs9RXWDU4RYuF
	 On/yKMNd4k07BOzh3C+RcHdwB5BnbK/7HtGOizQbaaGbhW+UfOtbsUZ8kmkPyXGvUasD0
	 cM9B03zfcDrmhbPJ0mbYzaoWZwvyad0GxyYxlMin5iCYVIra9YsEJ/y8jM7V8jP2yyXNX
	 dlgg2er+V76jUIhhKwi7g+WXOnzc2Rv1aI/i+b1cIPmagvPlHMUnCmYw3mqitrUWbsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kZ8FwsWt;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCA4606A31A
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Oct 2026 02:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BCA4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kZ8FwsWt
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e942864693so19171675ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 19:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793069636; x=1793674436; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zXjVpleUX/UUgVHHA3+E1ewAvZlUSAbbu6EQ+dmYP8E=;
        b=kZ8FwsWtruJ3zsI/6Wx9jlUzh8Hws6BYmFoo2zgNnXjFUXe5Dwi5YFODbHmWMwfQXb
         oO7KuIpJl6sNE8I1PyEfoDt6BUFWgfTuGhj805rrJL95OscQBVGPRh6b82HTbhrtDIKI
         pAPOctGiZENZ5cPAE9ZiFkRF67rNDJoevXFK4Uzb9/ubvSQiXOgsmmfbBM/DUtDxFgW5
         P2sS+t4tX6tVjIiv+1qNGLbYLiwp9U47lvntyTTl4qKGsUVBLv0IZQ+mMNHj8ll4KXAx
         i7rIm+eTAUjDhpyqY9+890IvCvDlZXys10MpAe8ZI1BM19yHbeLyFKhkmtSFUrhyi5tV
         La6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069636; x=1793674436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zXjVpleUX/UUgVHHA3+E1ewAvZlUSAbbu6EQ+dmYP8E=;
        b=1c1KRP+A6Mna+q1leAiNa7RDuk0slAJTezISENHjW547Ve3Mipy50qhkQ2zjChwGFL
         z1/CNSHg0DBdmj1h4wzH38RdzZE1AzoufU4aA24bhKN3EgN7LmAQo5zLl+raarW7BKvR
         F545wT6i4L993Q0I2wzdw1fo+No0hDfI0Hf6my8LAbVLw1YXA98q5moSLespuw0LGH9z
         3M7viUws5bfYaXGBZktNs5pHPdpzhBo9wH2qqrd19PJZmYsa5UxaypUnJnZQN7oSsEqO
         H565DfZrklU2rKzqfag+/lUYLYntRxddPhGv+KFFs2gvPvrUGe4PlL6UmR9phg2y3qO7
         bNrg==
X-Forwarded-Encrypted: i=1; AKwUvBz7Gu05Lke2BGcGIfDW+14JwVyTjweroZ7ysL23N8RIVc3wx3n6y1Thx7de9SbRVhbH916lNzJSESlILA==@lists.linux.dev
X-Gm-Message-State: AFq9FYI0uVcreNMHNjbHX9nvbnUqcbT3nWw3WIHTwYv2GK9KOdItylRG
	6Mg4Ewi8IS5P/gCblGwDINUy4aWuUo86BY4e+p+HoDcji24zz9Y7hCgt
X-Gm-Gg: AYBFou3QwTwGqifA2JiqSjc3H9VMeemxwItwTvgxCUfthR9yk3t3YVjmSPJilyhpXka
	Z4hXiHHQtH0sGH47gOsK8l68ydMcEWq8CjpNkbb7wzAG7IKRhv3GeU80hsY2pRGNNgM+/fnvB+/
	HeNBNIVCPZSjVzx5f/T3dacXjEhGzpuGclsmySOZHoIcZfwQRxGbk68Jx1wiaJyPEdJWnRQgpI5
	A1nVg/quFbk1KMCXYF3hMZOOaM9I1t/zkd2C2+MPVw34L1KQMnQM/F5VM4kWOM+UZDUJRL8JtX9
	qNORo4v+i9IMI9mhD5waInjRyrVQUvXxddyopaTQ6qomcxHyDTvf8klAj6xhS3vE6Tsx5Cq8pf/
	SDZOhqmuf6nfcbLN5zIi9KQ/iRvIAGh7OX3slLgu4IKew59u0M2HF73ln4MnNOsRCjMc5cEVYGf
	+rt8HyJUJTJgrVtGK/wu4XtcLgJwPhzL027PO7joh3Zhufv+iFQOU/VfUVvft/IH4vvTC2WHz8Q
	66/GkToD+4ApBl86JoQSCHSarZWlT0rZX5iI3rBxa5czCUhxJx6X0pNw0AsVE7BzbeQO23t
X-Received: by 2002:a17:902:f647:b0:2dd:ad74:ac1d with SMTP id d9443c01a7336-2ea9c7cedfemr76904225ad.24.1793069636290;
        Mon, 26 Oct 2026 19:53:56 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6bef7d1sm2153635ad.39.2026.10.26.19.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 19:53:55 -0700 (PDT)
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
Subject: [PATCH] ocfs2/dlm: serialize migration MLE cleanup on failure
Date: Tue, 27 Oct 2026 10:53:50 +0800
Message-Id: <pm-ocfs2-objects-candidate-0038-v5-5e414ac0c701d2ccd4b3@gmail.com>
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

Use the same cleanup helper for the pre-send failure, the send failure
and the target-death failure paths. The sender's in-use reference keeps
the MLE alive until its final put outside the nested locks. Successful
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
 fs/ocfs2/dlm/dlmmaster.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 612969867ff9..57119b195cc1 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2525,6 +2525,27 @@ static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
  */
 
 
+/*
+ * The finishing assert may already have unlinked the MLE and dropped its
+ * base reference. Decide under the locks the assert handler holds, and only
+ * drop the base reference here while the MLE is still hashed.
+ */
+static void dlm_put_migration_mle(struct dlm_ctxt *dlm,
+				  struct dlm_master_list_entry *mle)
+{
+	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->master_lock);
+	__dlm_mle_detach_hb_events(dlm, mle);
+	if (!hlist_unhashed(&mle->master_hash_node)) {
+		__dlm_unlink_mle(dlm, mle);
+		__dlm_put_mle(mle);
+	}
+	spin_unlock(&dlm->master_lock);
+	spin_unlock(&dlm->spinlock);
+
+	dlm_put_mle_inuse(mle);
+}
+
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 target)
 {
@@ -2609,9 +2630,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	if (ret < 0) {
 		if (mle_added) {
-			dlm_mle_detach_hb_events(dlm, mle);
-			dlm_put_mle(mle);
-			dlm_put_mle_inuse(mle);
+			dlm_put_migration_mle(dlm, mle);
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2640,9 +2659,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		mlog(0, "migration to node %u failed with %d\n",
 		     target, ret);
 		/* migration failed, detach and clean up mle */
-		dlm_mle_detach_hb_events(dlm, mle);
-		dlm_put_mle(mle);
-		dlm_put_mle_inuse(mle);
+		dlm_put_migration_mle(dlm, mle);
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_MIGRATING;
 		wake = 1;
@@ -2686,9 +2703,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 				     res->lockname.name, target);
 				ret = -EINVAL;
 				/* migration failed, detach and clean up mle */
-				dlm_mle_detach_hb_events(dlm, mle);
-				dlm_put_mle(mle);
-				dlm_put_mle_inuse(mle);
+				dlm_put_migration_mle(dlm, mle);
 				spin_lock(&res->spinlock);
 				res->state &= ~DLM_LOCK_RES_MIGRATING;
 				wake = 1;
