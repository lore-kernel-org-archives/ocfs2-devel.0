Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A84719B5AE
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382757; cv=none; b=XpdKM4J3Kpb4PlvFAqCU1+mxts9Ybg2y+2AawSaW0ceReneLxbE6b3fR02gb/Z71SX/KpCU2T5w3rq2AF5P4ywIbvadhjV/Pcz7SfGM4bK4xRxsxY9VTLk4q1HBjOhBJ1gQcGgDsTJ2P0MMS/jjfRU0F0Bt1Ulf+ck9b68eVqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382757; c=relaxed/simple;
	bh=1JP+d9DTdvRLjHMvjKA/7X/zFiYpxE5Qp6pWEK6Iypg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oeCbGEcy5Mo0ThhOC9s4LnFUnSusytyQX5wDxXIP1/ekAACt6bRtrWPCNyW9YQqE9NxWG9XsB6XKp8bRJkwr6dxrEoPGyOU3U2cdnwGNffKRSUuz8pwVt5S8/opwG+pySGPMG+iEFbl1AdfDC4jhjShuQYTnk1mgi/0ZUmy6MSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=NtWiVGJR; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="NtWiVGJR"
Received: from fedora.home ([86.243.222.230])
	by smtp.orange.fr with ESMTPA
	id I9qmsh97rXS9AI9qmsrRKe; Fri, 14 Jun 2024 18:32:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1718382752;
	bh=bro9slh5+EDW+lc1vukt0zA8l5VUvTm2syfdLEd7QbY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=NtWiVGJRnX0N0vQRD/f8okKtk/cYLhfwJ1ZBBbg+NPe/J9u0xszloqPqDHZ6Y26bY
	 swjKE/40tm8cSteBDJq/gwM/zH3uZ0iHv/lyqMIarMV+zXbRQUgj3H0+6XdrjWEzY0
	 2VGQX5SjonUd663BMB6b9r4MCmKKuhLudv3WC40pQMjuvA3fFbv6EcfuNidTiBenkD
	 XkW5L8TxLrluteVX/W6gdnN5geuB6kKZYLxLZlIEbQSP1Xw1DNxCoNjXXuVyBlA1/I
	 63W/IxDzYC35goyKZICQx7QsCx5hAD3Lo1sNeALCQ5KnuQYIfNxVmGsvmzwHWHLBBR
	 jvxljyd8OZOdw==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 14 Jun 2024 18:32:32 +0200
X-ME-IP: 86.243.222.230
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: Constify struct ocfs2_lock_res_ops
Date: Fri, 14 Jun 2024 18:25:07 +0200
Message-ID: <43d3e2ae3a97d3cbe93d6ba6ce48ae5ec04d7526.1718382288.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"struct ocfs2_lock_res_ops" are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

In order to do it, "struct ocfs2_lock_res" also needs to be adjusted to
this new const qualifier.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  83038	   2632	    400	  86070	  15036	fs/ocfs2/dlmglue.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  83806	   1992	    272	  86070	  15036	fs/ocfs2/dlmglue.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/ocfs2/dlmglue.c | 28 ++++++++++++++--------------
 fs/ocfs2/ocfs2.h   |  2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index cb40cafbc062..da78a04d6f0b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -221,12 +221,12 @@ struct ocfs2_lock_res_ops {
  */
 #define LOCK_TYPE_USES_LVB		0x2
 
-static struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_rw_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
@@ -234,50 +234,50 @@ static struct ocfs2_lock_res_ops ocfs2_inode_inode_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_super_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_super_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_rename_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_rename_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_nfs_sync_lops = {
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_trim_fs_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_orphan_scan_lops = {
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
 	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_inode_open_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.get_osb	= ocfs2_get_file_osb,
 	.flags		= 0,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
 	.set_lvb	= ocfs2_set_qinfo_lvb,
 	.get_osb	= ocfs2_get_qinfo_osb,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH | LOCK_TYPE_USES_LVB,
 };
 
-static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
+static const struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
 	.check_downconvert = ocfs2_check_refcount_downconvert,
 	.downconvert_worker = ocfs2_refcount_convert_worker,
 	.flags		= 0,
@@ -510,7 +510,7 @@ static inline void ocfs2_init_start_time(struct ocfs2_mask_waiter *mw)
 static void ocfs2_lock_res_init_common(struct ocfs2_super *osb,
 				       struct ocfs2_lock_res *res,
 				       enum ocfs2_lock_type type,
-				       struct ocfs2_lock_res_ops *ops,
+				       const struct ocfs2_lock_res_ops *ops,
 				       void *priv)
 {
 	res->l_type          = type;
@@ -553,7 +553,7 @@ void ocfs2_inode_lock_res_init(struct ocfs2_lock_res *res,
 			       unsigned int generation,
 			       struct inode *inode)
 {
-	struct ocfs2_lock_res_ops *ops;
+	const struct ocfs2_lock_res_ops *ops;
 
 	switch(type) {
 		case OCFS2_LOCK_TYPE_RW:
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8fe826143d7b..51c52768132d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -154,7 +154,7 @@ struct ocfs2_lock_stats {
 
 struct ocfs2_lock_res {
 	void                    *l_priv;
-	struct ocfs2_lock_res_ops *l_ops;
+	const struct ocfs2_lock_res_ops *l_ops;
 
 
 	struct list_head         l_blocked_list;
-- 
2.45.2

