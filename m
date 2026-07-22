Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F7254B03
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724589; cv=none; b=r4G5gztw9hYE2aEkX/YjoXNzj/k7ik/+4OMNAeQac8wAcAJPuY/FnSvw7J2LYNAPXLegeFVST8RAO96KKFtxXjaAOqaWCI1p1T6m2B/HQekgXU60vNKTDUQfw/Lrv97+6vFa1Jc9ed+wwpSbTgt/iF7f1jBHzfbybObx+Sua7Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724589; c=relaxed/simple;
	bh=cxHikLnOINPUdEmPCdbaVwlYo6YTatvM/crhEXy5RTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J5HIIK0yLb84BgQzCFknrig6vf7s70FLro4W7qA++Wy8zZUGl9n8DIe7GK2f6UG8PYOeY+LA8zuCaH/R0GBXc7eoC963lnB8D6joLhuu377Em44nT0DDvdWqFaAAlzageHj5uloQYxQSd6QU7b1GYuOOjg0XFxG2zx2nAOULpQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xzPTGsZR; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xzPTGsZR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784724576; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PEqRa9WNHp2UTn+NgMgPVbwjvcuLfhIBSAHM6BSit+0=;
	b=xzPTGsZRWDTgXCjPIK1l3UgAY/cDx1QdsfAovwve6FgfXs/DhHSFHZ54QlEQuu8w4rX7JYCjhTGm3IonftpsdARJ1xtsZBupy72ivhC+IyScjEMmM7HTVYmqDHhk/KHSxEbsk1ahnkMH2kEVMBHxvbE/RZA/FL7EgO0pBDYSEPI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7dMO6v_1784724575;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7dMO6v_1784724575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 20:49:35 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item
Date: Wed, 22 Jul 2026 20:49:32 +0800
Message-Id: <20260722124933.430554-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
References: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2hb_heartbeat_group_drop_item() is called from configfs rmdir with the
parent directory's inode_lock held.  It calls o2hb_region_pin() ->
o2nm_depend_item() -> configfs_depend_item(), which acquires the configfs
root inode_lock.  This creates a parent -> root inode_lock nesting that
could deadlock against paths taking root -> parent (e.g. subsystem
unregistration).

Fix this by using configfs_depend_item_unlocked() when o2hb_region_pin()
is called from a configfs callback context.  This variant skips the root
inode_lock when caller and target are in the same subsystem, which is
safe because VFS already holds a lock preventing unregistration.

Add o2nm_depend_item_unlocked() wrapper and a from_callback parameter to
o2hb_region_pin() to select the appropriate variant.

Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c   | 17 ++++++++++-------
 fs/ocfs2/cluster/nodemanager.c |  6 ++++++
 fs/ocfs2/cluster/nodemanager.h |  1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 5ca1d9c0c6575..b9395835523e2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -146,7 +146,7 @@ static unsigned int o2hb_dependent_users;
  * In global heartbeat mode, we pin/unpin all o2hb regions. This solution
  * works for both file system and userdlm domains.
  */
-static int o2hb_region_pin(const char *region_uuid);
+static int o2hb_region_pin(const char *region_uuid, bool from_callback);
 static void o2hb_region_unpin(const char *region_uuid);
 
 /* Only sets a new threshold if there are no active regions.
@@ -2188,7 +2188,7 @@ static void o2hb_heartbeat_group_drop_item(struct config_group *group,
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		o2hb_region_pin(NULL);
+		o2hb_region_pin(NULL, true);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
@@ -2330,7 +2330,7 @@ EXPORT_SYMBOL_GPL(o2hb_setup_callback);
  * In local, we only pin the matching region. In global we pin all the active
  * regions.
  */
-static int o2hb_region_pin(const char *region_uuid)
+static int o2hb_region_pin(const char *region_uuid, bool from_callback)
 {
 	int ret = 0, found;
 	struct o2hb_region *reg, *pinned;
@@ -2385,7 +2385,10 @@ static int o2hb_region_pin(const char *region_uuid)
 		spin_unlock(&o2hb_live_lock);
 
 		/* Ignore ENOENT only for local hb (userdlm domain) */
-		ret = o2nm_depend_item(&pinned->hr_item);
+		if (from_callback)
+			ret = o2nm_depend_item_unlocked(&pinned->hr_item);
+		else
+			ret = o2nm_depend_item(&pinned->hr_item);
 
 		spin_lock(&o2hb_live_lock);
 		if (!ret) {
@@ -2483,8 +2486,8 @@ static int o2hb_region_inc_user(const char *region_uuid)
 
 	/* local heartbeat */
 	if (!o2hb_global_heartbeat_active()) {
-	    ret = o2hb_region_pin(region_uuid);
-	    goto unlock;
+		ret = o2hb_region_pin(region_uuid, false);
+		goto unlock;
 	}
 
 	/*
@@ -2497,7 +2500,7 @@ static int o2hb_region_inc_user(const char *region_uuid)
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		ret = o2hb_region_pin(NULL);
+		ret = o2hb_region_pin(NULL, false);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index e1f8f577ce5d6..ebdf0bdbb8c69 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -778,6 +778,12 @@ int o2nm_depend_item(struct config_item *item)
 	return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
 }
 
+int o2nm_depend_item_unlocked(struct config_item *item)
+{
+	return configfs_depend_item_unlocked(&o2nm_cluster_group.cs_subsys,
+					     item);
+}
+
 void o2nm_undepend_item(struct config_item *item)
 {
 	configfs_undepend_item(item);
diff --git a/fs/ocfs2/cluster/nodemanager.h b/fs/ocfs2/cluster/nodemanager.h
index 39006005427b6..ca3483fb54504 100644
--- a/fs/ocfs2/cluster/nodemanager.h
+++ b/fs/ocfs2/cluster/nodemanager.h
@@ -64,6 +64,7 @@ void o2nm_node_get(struct o2nm_node *node);
 void o2nm_node_put(struct o2nm_node *node);
 
 int o2nm_depend_item(struct config_item *item);
+int o2nm_depend_item_unlocked(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
 int o2nm_depend_node(u8 node_num);
 void o2nm_undepend_node(u8 node_num);
-- 
2.39.3

