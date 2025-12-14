Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BFF29A31C
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765708981; cv=none; b=XQBA+1dqtt4ror5QMzc/73uHZgo5lf97UazLmadTLJL+7bM9KI5fR9CdzcK2l5coY0S6czkWgYYRWzx1u4HCWS7/QmFj8/LOAReJp8lrJjhxTVTO63rkz3pw0VOis+j4TgV2AUAVgXfWgR4P37HaXT1nR93mt+lIr+QwtGFXbCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765708981; c=relaxed/simple;
	bh=5JooT3MpOltGwpqeZtnacQ7Nq58pEpmM2KO/VVz/wlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lU6c5X507io9qsGrfb83/RKkaQqK1EDVQwLYPbPnVRGQlQVfaFKMygUB7T4LEzlIINUcuefOniC5tS+XgRILnguVjiyE3T8jLbnfSL+3cw11F2sHb2PmfoRkp9W4IfvepuIuGXnMnfJ57bRQ8izXeNKSE+cs7iPEKiBjM0UQl88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=m1/9PSyb; arc=none smtp.client-ip=80.12.242.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="m1/9PSyb"
Received: from fedora.home ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id UjXqvpLx6SRHBUjXqvSQ3I; Sun, 14 Dec 2025 11:41:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1765708906;
	bh=pSMGFfbEMTi3vXdP/hdOHRHQpHJMksJsg2ZATHnSZFc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=m1/9PSybZ6bftV22kDPPMe8PDsxLFXpOohRYeBeN5klu1u99/bTCSVqytYHPCtKXc
	 Flbs7Yzk5q6JgXEIvyspHHx3bzf36oeBeGDXwnhiT9/C3G+0JFBG47Um8IcPdRJCoF
	 /T59FxQDPth5vT5JEBPlr0NcCv09E1nmpaKXbN3TGZrk4ldA8LyyxoWcQPD+d8dCTh
	 0axbvbXNsTq639UuClB2B2JA0FzzdC5ftYYuklL1kS28QFM88tUbVFlW/3hfZ6PCp2
	 8+BU3ZZBnL0bBQmrU9rfDH9KgsORAYXmE4W1x6PgHheBxb4+imAFUPuWvrggs8DRUe
	 seW9FSEFcrtzA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Dec 2025 11:41:46 +0100
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: Constify struct configfs_item_operations and configfs_group_operations
Date: Sun, 14 Dec 2025 11:41:35 +0100
Message-ID: <7c7c00ba328e5e514d8debee698154039e9640dd.1765708880.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct configfs_item_operations' and 'configfs_group_operations' are not
modified in this driver.

Constifying these structures moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  74011	  19312	   5280	  98603	  1812b	fs/ocfs2/cluster/heartbeat.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  74171	  19152	   5280	  98603	  1812b	fs/ocfs2/cluster/heartbeat.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

This change is possible since commits f2f36500a63b and f7f78098690d.
---
 fs/ocfs2/cluster/heartbeat.c   | 4 ++--
 fs/ocfs2/cluster/nodemanager.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 724350925aff..8e9cbc334cf4 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1942,7 +1942,7 @@ static struct configfs_attribute *o2hb_region_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations o2hb_region_item_ops = {
+static const struct configfs_item_operations o2hb_region_item_ops = {
 	.release		= o2hb_region_release,
 };
 
@@ -2193,7 +2193,7 @@ static struct configfs_attribute *o2hb_heartbeat_group_attrs[] = {
 	NULL,
 };
 
-static struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
+static const struct configfs_group_operations o2hb_heartbeat_group_group_ops = {
 	.make_item	= o2hb_heartbeat_group_make_item,
 	.drop_item	= o2hb_heartbeat_group_drop_item,
 };
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 6bc4e064ace4..c5e83c774d73 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -396,7 +396,7 @@ static struct configfs_attribute *o2nm_node_attrs[] = {
 	NULL,
 };
 
-static struct configfs_item_operations o2nm_node_item_ops = {
+static const struct configfs_item_operations o2nm_node_item_ops = {
 	.release		= o2nm_node_release,
 };
 
@@ -638,7 +638,7 @@ static void o2nm_node_group_drop_item(struct config_group *group,
 	config_item_put(item);
 }
 
-static struct configfs_group_operations o2nm_node_group_group_ops = {
+static const struct configfs_group_operations o2nm_node_group_group_ops = {
 	.make_item	= o2nm_node_group_make_item,
 	.drop_item	= o2nm_node_group_drop_item,
 };
@@ -657,7 +657,7 @@ static void o2nm_cluster_release(struct config_item *item)
 	kfree(cluster);
 }
 
-static struct configfs_item_operations o2nm_cluster_item_ops = {
+static const struct configfs_item_operations o2nm_cluster_item_ops = {
 	.release	= o2nm_cluster_release,
 };
 
@@ -741,7 +741,7 @@ static void o2nm_cluster_group_drop_item(struct config_group *group, struct conf
 	config_item_put(item);
 }
 
-static struct configfs_group_operations o2nm_cluster_group_group_ops = {
+static const struct configfs_group_operations o2nm_cluster_group_group_ops = {
 	.make_group	= o2nm_cluster_group_make_group,
 	.drop_item	= o2nm_cluster_group_drop_item,
 };
-- 
2.52.0

