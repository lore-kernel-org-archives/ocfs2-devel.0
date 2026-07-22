Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDD229A9E9
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724585; cv=none; b=NgBI128JSegGUTdazSd9x91bx0BKYh4tMGSHYga1Kl67m4evCSOKxjqh+5p0EG/skPPKfR8GWDHBsBPdj+9lSbG6WQFcH0FvZ59O/g+/yBNVjS95kfZUHeV4n66BoFZ42RjpFSNhFalFMdbWEsgAZJlZytc8OJF/iuk1wUZedkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724585; c=relaxed/simple;
	bh=n+6V8MZEYNuMTfZWJYrG5/uWwDugg2aHPFbVBzCQOiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R46oCd2KwsRzBqJtGui5Cp0gye7ATPQ1elW7cvimqpnZ4BXMW8HorznzF69KoVtbXNJxuDJfy/PwewmuDaMMbpkJxH9Ie00EQTzK6l2GeqJD/MSdDiyGxaEo8nnATQ5KQDjVyPWU6+xz8Q2+wqhv46GmK8DN+DcvYLEyuX1fQio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=D5a4Axsl; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="D5a4Axsl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784724575; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=TlQBqXEKz2cBa162EBIUo9/YwhoWB5RUudVNVJH4xag=;
	b=D5a4AxslEehvtqrTKPZiIUfrf78QJlUw+F+tMuNunEAMHse/Rn4eE9iumWC1My7XwQJCNSF77RJzXpZIRQghuUzxKmA3148Nq6SYigpnKxxYr20Wj5m0ID1OLc0nv2GO72pIEy+yD+wBcT9bjV2KKeAP+Qg6V3D9UZpcWqVUagU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7dOckD_1784724574;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7dOckD_1784724574 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 20:49:34 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] ocfs2: cluster: don't sleep while holding o2hb_live_lock in o2hb_region_pin()
Date: Wed, 22 Jul 2026 20:49:31 +0800
Message-Id: <20260722124933.430554-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
References: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

o2hb_region_pin() is always called with the o2hb_live_lock spinlock held
(from o2hb_region_inc_user() and o2hb_heartbeat_group_drop_item()), but it
calls o2nm_depend_item() -> configfs_depend_item(), which sleeps: it pins
the configfs filesystem and takes the configfs root inode rwsem. Under
CONFIG_DEBUG_ATOMIC_SLEEP this triggers:

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c
  in_atomic(): 1, ... name: mount.ocfs2
    down_write
    configfs_depend_item
    o2hb_region_pin
    o2hb_region_inc_user
    o2hb_register_callback
    dlm_register_domain_handlers
    ...
    ocfs2_dlm_init
    ocfs2_mount_volume
    ocfs2_fill_super

Rework o2hb_region_pin() to pin one region at a time with the lock
dropped across the sleeping call: under o2hb_live_lock find the next
eligible region and take a config_item reference to keep it alive, drop
the lock, call o2nm_depend_item(), then retake the lock and record the
pin. The config_item_put() is done with the lock released as well, since
o2hb_region_release() also acquires o2hb_live_lock and can sleep. The
region list may change while unlocked, so the scan restarts from the
top after each pin. Local heartbeat still pins only the matching region;
global heartbeat pins all eligible regions.

The unpin path is unaffected: configfs_undepend_item() only takes a
spinlock and does not sleep.

Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 126 ++++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 29542edbc992c..5ca1d9c0c6575 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -43,6 +43,14 @@ static DECLARE_RWSEM(o2hb_callback_sem);
  * whenever any of the threads sees activity from the node in its region.
  */
 static DEFINE_SPINLOCK(o2hb_live_lock);
+/*
+ * Serializes region pin/unpin dependency management (o2hb_dependent_users
+ * and the o2nm_depend_item()/o2nm_undepend_item() calls). o2hb_region_pin()
+ * has to drop o2hb_live_lock across the sleeping o2nm_depend_item(), so the
+ * spinlock alone can no longer keep pin and unpin mutually exclusive; this
+ * mutex, taken outside o2hb_live_lock, does.
+ */
+static DEFINE_MUTEX(o2hb_dependency_mutex);
 static struct list_head o2hb_live_slots[O2NM_MAX_NODES];
 static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 static LIST_HEAD(o2hb_node_events);
@@ -2172,6 +2180,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 	 * If global heartbeat active and there are dependent users,
 	 * pin all regions if quorum region count <= CUT_OFF
 	 */
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	if (!o2hb_dependent_users)
@@ -2183,6 +2192,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 }
 
 static ssize_t o2hb_heartbeat_group_dead_threshold_show(struct config_item *item,
@@ -2322,46 +2332,108 @@ EXPORT_SYMBOL_GPL(o2hb_setup_callback);
  */
 static int o2hb_region_pin(const char *region_uuid)
 {
-	int ret = 0, found = 0;
-	struct o2hb_region *reg;
+	int ret = 0, found;
+	struct o2hb_region *reg, *pinned;
 	char *uuid;
 
 	assert_spin_locked(&o2hb_live_lock);
 
-	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
-		if (reg->hr_item_dropped)
-			continue;
+	do {
+		found = 0;
+		pinned = NULL;
 
-		uuid = config_item_name(&reg->hr_item);
+		list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+			if (reg->hr_item_dropped)
+				continue;
 
-		/* local heartbeat */
-		if (region_uuid) {
-			if (strcmp(region_uuid, uuid))
+			uuid = config_item_name(&reg->hr_item);
+
+			/* local heartbeat */
+			if (region_uuid) {
+				if (strcmp(region_uuid, uuid))
+					continue;
+				found = 1;
+			}
+
+			if (reg->hr_item_pinned || reg->hr_item_dropped) {
+				if (found)
+					break;
 				continue;
-			found = 1;
+			}
+
+			/*
+			 * Found a region that needs pinning. Take a reference
+			 * so it stays alive while we drop the lock below.
+			 */
+			pinned = reg;
+			config_item_get(&reg->hr_item);
+			break;
 		}
 
-		if (reg->hr_item_pinned || reg->hr_item_dropped)
-			goto skip_pin;
+		if (!pinned)
+			break;
+
+		uuid = config_item_name(&pinned->hr_item);
+
+		/*
+		 * o2nm_depend_item() -> configfs_depend_item() can sleep (it
+		 * takes the configfs root inode rwsem), so it must not run
+		 * under o2hb_live_lock. Drop the lock across it; @pinned is
+		 * kept alive by the reference taken above. The region list may
+		 * change while unlocked, so we rescan from the top afterwards.
+		 */
+		spin_unlock(&o2hb_live_lock);
 
 		/* Ignore ENOENT only for local hb (userdlm domain) */
-		ret = o2nm_depend_item(&reg->hr_item);
+		ret = o2nm_depend_item(&pinned->hr_item);
+
+		spin_lock(&o2hb_live_lock);
 		if (!ret) {
-			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
-			reg->hr_item_pinned = 1;
-		} else {
-			if (ret == -ENOENT && found)
-				ret = 0;
-			else {
-				mlog(ML_ERROR, "Pin region %s fails with %d\n",
-				     uuid, ret);
+			/*
+			 * o2hb_live_lock was dropped across o2nm_depend_item().
+			 * o2hb_set_quorum_device() runs in the heartbeat thread
+			 * without o2hb_dependency_mutex, so for global heartbeat
+			 * it may have crossed O2HB_PIN_CUT_OFF and unpinned the
+			 * regions while we slept. If that happened this pin is
+			 * no longer wanted; undo it and stop rather than
+			 * resurrecting it on the rescan below.
+			 */
+			if (!region_uuid &&
+			    bitmap_weight(o2hb_quorum_region_bitmap,
+					  O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF) {
+				o2nm_undepend_item(&pinned->hr_item);
+				spin_unlock(&o2hb_live_lock);
+				config_item_put(&pinned->hr_item);
+				spin_lock(&o2hb_live_lock);
 				break;
 			}
+			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
+			pinned->hr_item_pinned = 1;
+		} else if (ret == -ENOENT && (found || !region_uuid)) {
+			/*
+			 * For local hb (found): ignore ENOENT from userdlm
+			 * domains as before.  For global hb (!region_uuid):
+			 * the region may have been detached from configfs
+			 * while the lock was dropped — skip it and continue
+			 * pinning the remaining regions.
+			 */
+			ret = 0;
+		} else {
+			mlog(ML_ERROR, "Pin region %s fails with %d\n",
+			     uuid, ret);
 		}
-skip_pin:
-		if (found)
-			break;
-	}
+
+		/*
+		 * config_item_put() may drop the last reference and run
+		 * o2hb_region_release(), which also grabs o2hb_live_lock and
+		 * can sleep, so it must happen with the lock released.
+		 */
+		spin_unlock(&o2hb_live_lock);
+		config_item_put(&pinned->hr_item);
+		spin_lock(&o2hb_live_lock);
+
+		/* local hb pins a single matching region */
+	} while (!ret && !region_uuid);
 
 	return ret;
 }
@@ -2406,6 +2478,7 @@ static int o2hb_region_inc_user(const char *region_uuid)
 {
 	int ret = 0;
 
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	/* local heartbeat */
@@ -2428,11 +2501,13 @@ static int o2hb_region_inc_user(const char *region_uuid)
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 	return ret;
 }
 
 static void o2hb_region_dec_user(const char *region_uuid)
 {
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	/* local heartbeat */
@@ -2451,6 +2526,7 @@ static void o2hb_region_dec_user(const char *region_uuid)
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 }
 
 int o2hb_register_callback(const char *region_uuid,
-- 
2.39.3

