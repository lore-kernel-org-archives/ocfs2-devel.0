Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793081373;
	b=0PeVxANMC34XR6Y6F3XM1tAlmd9GOmYrqwcQJeRokzbDMkaQ2G9Dv1fEy9R68RrT5yex
	 p23w1MFS7EanQDnPBacAMOqGHpIDOW4PikPowzCh3JqG13T0Kf8bSSVhR5nXWN5l24ORD
	 6B5UFwGFCUM0ZCExx+CJ0Kc5bUzsoouubEbqRQTF6CTAyo/A57XZhKEtbpwew71tV4eSb
	 f+xy0YoiYlDYrBKu5v9SN56ci+Q9lruHuXQ4gslNYLOBMJAesWD1ayTXEShK4uoRa0HPC
	 PDD99H54B5uKLy34mJcaM1tNLLkAX+1HzMPzI+6auZYMjnI3+NqaA25eYPujZGKhJrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793081373;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fB6Whtak24taZDZv6ZtTz72XfGauaIchm99YUmKfUiw=;
	b=TAKirdJ62cqcR2Sr1OyNe/FI8X0GaVjViYHiG3MleAIaNFPTuRr4AfJgWDnjrhS/0kgA
	 HS+KXM2WRU7ay2B4Tz11gc92i/d980wfCxGMAUC5HnVV3fKfsz1GIe1AK2j5N2G/AcbBl
	 2+qIfhisPl9luYQwF9HHCPdbmndN3k4hnIYiB+vsd+q9yuxhmLiQpWXDVws3GfxTlI33I
	 fgw/tR33NphnK5+ixTWfLxsYoPET+vbCuVsFEuh9JQM62+URJzjeTV3Y5EDNwsxuw9CP5
	 9I0zTUdXz6MXQNSlyNRXlipylSc73VPlQOxTX3dnDkyClmgf8lQ3LiU0qgusLIWEeZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hahAfBza;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62C606A31A
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Oct 2026 06:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB62C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hahAfBza
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so1610089a91.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 26 Oct 2026 23:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793081372; x=1793686172; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fB6Whtak24taZDZv6ZtTz72XfGauaIchm99YUmKfUiw=;
        b=hahAfBzalbZDs6OccELZLxiSB6AKjJtWIzTfQtEtJDylcyWHnRRwQCrdfFnTwpP0zk
         I6OHU60fVOPQvsjZphco98TEiVI22BmXD1AFFi3AXSYQyy/MGCw8TG9Bpd2uoZPyBtcb
         /aWKKg0B9w72ihY8smMhHXie4t3jDuxVVniGj1GGI50D3VwhV4S3hJx+l+wMDuYXeBqj
         zWRQsE4wEe86n9/2eDYKyQyotK2Vo7RU/h9OjIP3K76ARNS1hWfYBW+BTkz7Fk0D3P/n
         JMHTVYFbHlz8m7b/2Ky/VRlfYwxzUszQ+rfa7Af7aKnjWnKNW08qVduqLBjFLNrPZ564
         vEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793081372; x=1793686172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fB6Whtak24taZDZv6ZtTz72XfGauaIchm99YUmKfUiw=;
        b=feO/4XUaipQwdYC/ffr+ouypR7hPS9yhWHBRvJ065OLvShSRop8pvYAvvkAYYBhH9T
         ZJeeTTCI5KwolGg+wX4dQHHMpEtA4iIJksjm0WV73WW8VG/9kNWToCp60je7cuVBXzge
         4ZutdqoTKzIiSOTMxxo0F1aUxh8GrkUbYRSkypErQbbHEjBA2JMY/zFPWD+qwXIX35sO
         ZgPZNzVhSl+IaBaQTDnwCbMSfHBF3xxkMFbemh7CBLZnGpNw4vLYlWSTguHcsRcVxtC8
         dZ5KWBTFPnQNUIDG5VOOHjP3sQVFJgaPOuD6E13dEshGNXmk059UoESnAghFcIu1SO3v
         wL4A==
X-Forwarded-Encrypted: i=1; AKwUvBx1kNogaj3jy6ZyGRSOG7cpcBDuMEzvkvquvjvIeI7hRZeXU2RgLss5vVft8+mRgj8UTaJhWDKWun4UZw==@lists.linux.dev
X-Gm-Message-State: AFq9FYK7tsFem9usavC9ZBNX9nMOq3wYbX1d8jqeTXZ7luizCSJZEubh
	CjJpHHQoievW9tXUF9UKQPr5+Kd9K4MLFtLLZKfM48YpGGgCqrcrUnM1RM8gkDo1VnAMNg==
X-Gm-Gg: AYBFou0C4kIrTAZIxC1atp4P8suPzNMz52ojJ2a1Bs5UwXm4DuGl5+QyWRf0J81rRxZ
	ABrTLnOmXmJmZ27v7sR6xemHW5VnOKsaWm+6h0eaQ39eHf9pp+xfmSfumd9W1ZQABJU6mg9jVHB
	La2e7z0ZXzuwtxSpvaPlm6vV2/UzR2plG2f55xZO2NvCGIYUrvFB0Zec67JoLuzhc5C/Y/r0qzP
	NCJlDaLLP1kuzBrFwJu5VUZS5vruxQBneVhrdSHYqh61TGizvHG0U2XBqNZ/NuN6az2gns39G35
	KE61unDEYjz3M5NqY598yp0IJ9Gd0qiycQWq4d555MgfAFWjR/IITZMs6DCbCBvK0pRkUMn8i45
	0sNuWGhVR0KnPShxBZFCS5varONcEwvrhrsoUlGnM7sgGGZLt+yt3PepW2kMZTDnI2zOhKrnAYF
	VaRf2Jd+/AA6UFzJtcHXEGil3u49Y4Wv2cWrDsvTvO3HacOXfKk1jhdPtFyg0q8S7LQbJAPnuRY
	WoqtYe9Gt/HmDgOYrG0yi2lBxns5o05+VbHcvGeP0amZPBehQTetN1WIAPjC35uuDzp7gUOGPlx
	fYwhlof/j2LKWGFVQhSPU/Es96wKEDkcDmWFgjonWswHMg==
X-Received: by 2002:a17:90b:1d09:b0:3ac:8dfe:8ec9 with SMTP id 98e67ed59e1d1-3adeb0fbe41mr6633907a91.47.1793081371921;
        Mon, 26 Oct 2026 23:09:31 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4041fafcsm2798694a91.0.2026.10.26.23.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 23:09:31 -0700 (PDT)
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
Subject: [PATCH v3] ocfs2/dlm: serialize migration MLE cleanup on failure
Date: Tue, 27 Oct 2026 14:09:23 +0800
Message-Id: <pm-ocfs2-objects-candidate-0038-v7-7a0bd8f07ba98784f6b7@gmail.com>
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

An assertion that got there first has also made the target the owner.
Treating the attempt as failed at that point would leave the lockres
owned by the target while this node still holds the other nodes' locks
and refmap bits, so it could neither be purged nor migrated again, and
recovery of the target would send those locks to its recovery master.
The same half handed-over state exists for a moment in the normal
completion, where the handler switches the owner and the sender drops
the locks later under a second spinlock section.

Hand the lockres over in one res->spinlock section instead: the handler
drops the other nodes' locks and refmap bits together with the owner
switch, and the sender only does the same if the handler has not reached
that point yet. Recovery takes res->spinlock before it looks at the
owner, so it sees either the old master with every lock or the new
master with only our own locks. An attempt that failed after the
assertion then has nothing left to do but recalculate the usage.

Ignore a finishing assertion from a node that is no longer in the domain
map. Recovery has already cleaned the lockres up with this node as the
owner, and the sender fails the attempt once it sees the death; handing
the lockres over to a dead node would leave it unowned forever.

For a send that failed with a connection error, wait for the target to
die before deciding, while the MLE is still published. The target may
have received the packet and may still assert; an assertion that finds
no MLE for a lockres we still own is fatal in the handler. The wait is
bounded as before, and an assertion that arrives even later meets that
check as it did before this change.

Use the same cleanup for the pre-send failure, the send failure and the
target-death failure paths. The sender's in-use reference keeps the MLE
alive until its final put outside the nested locks.

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
Changes in v3:
- Hand the lockres over in one res->spinlock section:
  dlm_assert_master_handler() drops the other nodes' locks and refmap bits
  together with the owner switch, and the sender only does the same if the
  handler has not reached that point; the failed-but-asserted paths just
  recalculate usage. This removes the window in which recovery of the target
  saw a lockres it owned with other nodes' locks still attached (Sashiko
  review).
- Ignore a finishing assert from a node that is no longer in the domain map,
  so a late assert from a dead target cannot hand the lockres over after
  recovery has cleaned it up (Sashiko review).

Changes in v2:
- Complete the migration instead of failing it when the finishing assert has
  already switched the owner, so the lockres is not left owned by the target
  with the other nodes' locks still held here (Sashiko review).
- On a connection error from the send, wait for the target's death before
  the MLE is dropped, so a late assert finds the MLE instead of hitting the
  handler's check (Sashiko review).

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0038-v5-5e414ac0c701d2ccd4b3@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0038-v6-44416f9847751914bacc@gmail.com

 fs/ocfs2/dlm/dlmmaster.c | 98 +++++++++++++++++++++++++++++++++-------
 1 file changed, 82 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 612969867ff9..94ebae4a450a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1823,6 +1823,20 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 				spin_unlock(&dlm->master_lock);
 				spin_unlock(&dlm->spinlock);
 				goto done;
+			} else if (!test_bit(assert->node_idx, dlm->domain_map)) {
+				/*
+				 * The target died after sending this. Recovery
+				 * has cleaned the lockres up with us as the
+				 * owner and the sender fails the attempt once
+				 * it sees the death; do not hand the lockres
+				 * over to a dead node.
+				 */
+				mlog(0, "%s:%.*s: finishing assert from dead node %u, ignoring\n",
+				     dlm->name, namelen, name, assert->node_idx);
+				__dlm_put_mle(mle);
+				spin_unlock(&dlm->master_lock);
+				spin_unlock(&dlm->spinlock);
+				goto done;
 			}
 		}
 	}
@@ -1924,6 +1938,13 @@ int dlm_assert_master_handler(struct o2net_msg *msg, u32 len, void *data,
 				wake = 1;
 				dlm_change_lockres_owner(dlm, res, mle->new_master);
 				BUG_ON(res->state & DLM_LOCK_RES_DIRTY);
+				/*
+				 * Hand the lockres over completely while the
+				 * spinlock is held: recovery must never find
+				 * the other nodes' locks or refmap bits on a
+				 * lockres that the target owns.
+				 */
+				dlm_remove_nonlocal_locks(dlm, res);
 			} else {
 				dlm_change_lockres_owner(dlm, res, mle->master);
 			}
@@ -2525,6 +2546,34 @@ static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
  */
 
 
+/*
+ * Drop the sender's references on a migration MLE after the attempt has
+ * failed. The finishing assert from the target may already have unlinked
+ * the MLE and consumed its base reference; decide under the locks the
+ * assert handler holds, and only drop the base reference while the MLE is
+ * still hashed. Returns true when the assert got there first: it has handed
+ * the lockres over to the target, so the attempt must not count as failed.
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
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 target)
 {
@@ -2609,9 +2658,10 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	if (ret < 0) {
 		if (mle_added) {
-			dlm_mle_detach_hb_events(dlm, mle);
-			dlm_put_mle(mle);
-			dlm_put_mle_inuse(mle);
+			if (dlm_put_migration_mle(dlm, mle)) {
+				dlm_lockres_calc_usage(dlm, res);
+				ret = 0;
+			}
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2639,17 +2689,25 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
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
+			dlm_lockres_calc_usage(dlm, res);
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
 
@@ -2686,9 +2744,11 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 				     res->lockname.name, target);
 				ret = -EINVAL;
 				/* migration failed, detach and clean up mle */
-				dlm_mle_detach_hb_events(dlm, mle);
-				dlm_put_mle(mle);
-				dlm_put_mle_inuse(mle);
+				if (dlm_put_migration_mle(dlm, mle)) {
+					dlm_lockres_calc_usage(dlm, res);
+					ret = 0;
+					goto leave;
+				}
 				spin_lock(&res->spinlock);
 				res->state &= ~DLM_LOCK_RES_MIGRATING;
 				wake = 1;
@@ -2700,11 +2760,17 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			     dlm->name, res->lockname.len, res->lockname.name);
 	}
 
-	/* all done, set the owner, clear the flag */
+	/*
+	 * All done. The finishing assert hands the lockres over under
+	 * res->spinlock; if it has not reached that point yet, do it here
+	 * in the same way, so the lockres is never left half handed over.
+	 */
 	spin_lock(&res->spinlock);
-	dlm_set_lockres_owner(dlm, res, target);
-	res->state &= ~DLM_LOCK_RES_MIGRATING;
-	dlm_remove_nonlocal_locks(dlm, res);
+	if (res->state & DLM_LOCK_RES_MIGRATING) {
+		dlm_set_lockres_owner(dlm, res, target);
+		res->state &= ~DLM_LOCK_RES_MIGRATING;
+		dlm_remove_nonlocal_locks(dlm, res);
+	}
 	spin_unlock(&res->spinlock);
 	wake_up(&res->wq);
 
