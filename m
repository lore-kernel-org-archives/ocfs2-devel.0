Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4682E92D5
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 Aug 2025 11:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755171539; cv=none; b=MgUx3qDTZIQ0BThOUma8PH1DeMxO4xrf6kBcvMqAhIno39ObXGrn0LFZhyYDD7Xst14wDJKx1xcRgr/qc8JznsiWWp6ZLmdo7fH+PSbamrq9kB0GCaXkS/SJrHYuJcjpb05mfxNVzmT52suylZeshCNSrITgEEwe3YZ6RJNh2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755171539; c=relaxed/simple;
	bh=Mr4tVN0NcVDlKr0kpHP5uGJ0iQRfFOAnePwQuZH9ihM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gp/yrOgPL8PFSwKxRnA4CBBYvI2trLdzemCD2tLnaAgtM+9clOonXIk1Vp2P6Rjd7zaD41qU/JTp4nEcGaD0c2D2JIk6npdsHuAUFG6Nyvl9HEADiisIh4oSrjgOSevGGkdaOvdUXPLeEs84gsL0W0w0fabu5g5w3mqILxXc2RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pt6RWMi3; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pt6RWMi3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755171535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MrCcF57qFjn9NHu+NzVSJv+zbOcFcaKcUD/N25VmBiA=;
	b=pt6RWMi3gNMFZZG0cFcXJFFwVNrMBxdCg+9nkAULfKgIMWY6lTdZdZPU4jwK40sHrZdVxQ
	W/PmCqHgCa8FTUw17jd5SDwSrnhSsSD82X6gzYIJb6I3TOU0YshoEbim6pNg0m7lc1YlaX
	gMHSHsWTFgXEEEQUTvaUSZHtZXxidNY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ocfs2: Remove commented out mlog() statements
Date: Thu, 14 Aug 2025 13:38:10 +0200
Message-ID: <20250814113815.219064-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The mlog() statements have been commented out ever since commit
6714d8e86bf44 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem") -
remove them.

Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Remove commented out mlog() from dlmrecovery.c as suggested by Mark
- Link to v1: https://lore.kernel.org/lkml/20250813180622.209305-3-thorsten.blum@linux.dev/
---
 fs/ocfs2/dlm/dlmmaster.c   | 11 -----------
 fs/ocfs2/dlm/dlmrecovery.c |  1 -
 2 files changed, 12 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 86bb1a03bcc1..4145e06d2c08 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1477,7 +1477,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 			goto send_response;
 		} else if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN) {
 			spin_unlock(&res->spinlock);
-			// mlog(0, "node %u is the master\n", res->owner);
 			response = DLM_MASTER_RESP_NO;
 			if (mle)
 				kmem_cache_free(dlm_mle_cache, mle);
@@ -1493,7 +1492,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 			BUG();
 		}
 
-		// mlog(0, "lockres is in progress...\n");
 		spin_lock(&dlm->master_lock);
 		found = dlm_find_mle(dlm, &tmpmle, name, namelen);
 		if (!found) {
@@ -1503,8 +1501,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 		set_maybe = 1;
 		spin_lock(&tmpmle->spinlock);
 		if (tmpmle->type == DLM_MLE_BLOCK) {
-			// mlog(0, "this node is waiting for "
-			// "lockres to be mastered\n");
 			response = DLM_MASTER_RESP_NO;
 		} else if (tmpmle->type == DLM_MLE_MIGRATION) {
 			mlog(0, "node %u is master, but trying to migrate to "
@@ -1531,8 +1527,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 			} else
 				response = DLM_MASTER_RESP_NO;
 		} else {
-			// mlog(0, "this node is attempting to "
-			// "master lockres\n");
 			response = DLM_MASTER_RESP_MAYBE;
 		}
 		if (set_maybe)
@@ -1559,7 +1553,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 	found = dlm_find_mle(dlm, &tmpmle, name, namelen);
 	if (!found) {
 		/* this lockid has never been seen on this node yet */
-		// mlog(0, "no mle found\n");
 		if (!mle) {
 			spin_unlock(&dlm->master_lock);
 			spin_unlock(&dlm->spinlock);
@@ -1573,8 +1566,6 @@ int dlm_master_request_handler(struct o2net_msg *msg, u32 len, void *data,
 			goto way_up_top;
 		}
 
-		// mlog(0, "this is second time thru, already allocated, "
-		// "add the block.\n");
 		dlm_init_mle(mle, DLM_MLE_BLOCK, dlm, NULL, name, namelen);
 		set_bit(request->node_idx, mle->maybe_map);
 		__dlm_insert_mle(dlm, mle);
@@ -1897,8 +1888,6 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 		spin_unlock(&res->spinlock);
 	}
 
-	// mlog(0, "woo!  got an assert_master from node %u!\n",
-	// 	     assert->node_idx);
 	if (mle) {
 		int extra_ref = 0;
 		int nn = -1;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 00f52812dbb0..843ee02bd85f 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -464,7 +464,6 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	}
 
 	if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
-		// mlog(0, "nothing to recover!  sleeping now!\n");
 		spin_unlock(&dlm->spinlock);
 		/* return to main thread loop and sleep. */
 		return 0;
-- 
2.50.1

