Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9CE2857CA
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Aug 2025 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755108440; cv=none; b=W3o5Fs4Ui+hLLKg9D3LhDsZDVXy5MFd0gYSmCFLCT4m272OIH+q1xd9Qh2raQINx6b8BQRkHvQu5gt27h7Dw+viecHGb43IQp4L1g1FJoFEmJ6UqkBGMBq3R9tiKrZGy0sDUP0dnur7fa5bFI33jNTITZIba5/NdG0bujVUmrDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755108440; c=relaxed/simple;
	bh=HfcGolfkFJMZjdqIUoPopkVtOqDdwcM7w81IDDcJQxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tnjHw+WnRI14x/0mnjreActNA1A9mwD5qCY4Drlv0HTSjitGQVWoTsLhBSG4tVeObXGDh4FeJwrN1zzxUEPXnP+j3omYmgbSRZmDmF0MSDco8QJotwKB/wWnrn9vamLzyW1Lqv9c8e9n22flEYhCxtdouNUCcqaSJfJNFH/c+gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mpGX/o2I; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mpGX/o2I"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755108434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mZBQ0Uqep9wyuNlF72Lp7pmuoTgyNsomwyrLmYN62cg=;
	b=mpGX/o2IpGvpKMKdAwbxBfpRluhXzjCH5fUpaaclA72LRD+BYtshdmib34slqv9Bm6LGEE
	Jlw6QWJJPcQc337wR+zrCHssQVSBe5NOXM8PHKgxpT2HYnvrPatc6+Laawz2Qk2tR3/yda
	ClACt7aMN1pXtFVlAAoGCFOK6inPzXo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Remove commented out mlog() statements
Date: Wed, 13 Aug 2025 20:06:21 +0200
Message-ID: <20250813180622.209305-3-thorsten.blum@linux.dev>
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

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/dlm/dlmmaster.c | 11 -----------
 1 file changed, 11 deletions(-)

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
-- 
2.50.1

