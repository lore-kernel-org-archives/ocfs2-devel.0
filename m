Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E2D381EA1
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 02:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489483; cv=none; b=bEHs5C5f8PYb4j4kpxLDP8I8xyr1Hxa6S825MxGibzJ+atzyzNHGKdDYUhRpyt51W7zax5qsKcWIe4IXVcajkS3WuER1Ocvo4P62HPmF/8Tv5ZhnqoSJlEqgXOAcXyjhHQioKuYFDHtb7DPUNzQe2STNy2tArVO5npmocGs/16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489483; c=relaxed/simple;
	bh=0f8hK5jE64IWnlrs/Jyho0v03gVX9wPqlBg7+Qm4Vac=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kXVw4Ijpy7yVkCD/LPPfYnLtw15Vj7o6C6zvROrdzf+TUad9ooi2+DzdWJNmNE9DLH+wv8zoOKxyDB0vGXLAVpYgHVITi9KGC20EP0kjBGzfD0pIm2ZmBiMQJJYwkaC1HnVY9uOWYrOkOzfWiNGcPG6QrPF6lyNfZYGtKoDQ9UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WdNzudaB; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WdNzudaB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788489472; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1ObqJlUXAAiPrJ56eo1dbrNhehF63niXmtq5E8ON7Ek=;
	b=WdNzudaBF4rMuZ/yBo4oY6cBK3Q76a/pXQsNyqF5zRYiLxxuuHbqhhQL0S0X1nXB5QiBklWoI3EbNUkEmFgdre61PwxzgXkYZlcH8tieI9zvIt+mP+FRvj55SdlqyvXM8m69jDasHAvANCC4GGpuQv63VT9XbbnqJZa/S04kX2k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAHLNOS_1788489471;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAHLNOS_1788489471 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 10:37:51 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: make ocfs2_calc_xattr_init() return void
Date: Fri,  4 Sep 2026 10:37:51 +0800
Message-Id: <20260904023751.3703334-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_calc_xattr_init() used to read the default ACL off the parent
inode itself, so it could return an error from ocfs2_xattr_get_nolock().
Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
ocfs2_init_acl()") moved that lookup before the transaction starts and
deleted the error path, but left the now vestigial 'int ret = 0'
declaration and both 'return ret' statements behind, along with an
unreachable error branch in ocfs2_mknod().

Drop the leftover variable and convert the return type to void, so the
callee states that it always succeeds and the caller no longer carries
a check that can never trigger.

No functional change.

Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/namei.c |  9 ++-------
 fs/ocfs2/xattr.c | 13 +++++--------
 fs/ocfs2/xattr.h |  8 ++++----
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index fea889b9f577..ef03f90e7265 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -335,13 +335,8 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		goto leave;
 
 	/* calculate meta data/clusters for setting security and acl xattr */
-	status = ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters,
-				       &xattr_credits, &want_meta,
-				       &acl_state);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters, &xattr_credits,
+			      &want_meta, &acl_state);
 
 	/* Reserve a cluster if creating an extent based directory. */
 	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f30faabf601b..f2b7a53ed969 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -682,13 +682,12 @@ int ocfs2_calc_security_init(struct inode *dir,
 	return ret;
 }
 
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state)
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state)
 {
 	int i;
-	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
@@ -713,7 +712,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -781,8 +780,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			}
 		}
 	}
-
-	return ret;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 70a6a9dab71e..1dd08f979e3c 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -65,10 +65,10 @@ int ocfs2_calc_security_init(struct inode *,
 			     int *, int *, struct ocfs2_alloc_context **);
 
 struct ocfs2_acl_state;
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state);
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state);
 
 /*
  * xattrs can live inside an inode, as part of an external xattr block,
-- 
2.39.3

