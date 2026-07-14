Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F9181334
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jul 2026 11:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028933; cv=none; b=eVGmmYSTgoiRKmi4tfa2p6sNil073H4pehcVFaIFfmliOsNqfIeJe78jygRMNRQAQioskxa/ZmpdSRBStTeeHiwBBv0NSs3i6i/YhLFru7hXZmiquD+N/k+TcTK2hgcLP2+TwYF06RyGVo2b+xswKMHgjV/RSHiEPEXTRDLb2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028933; c=relaxed/simple;
	bh=WjnUawCLeFwHSvXkapZrGBL5/JyH1weZ6fe5N5IsYV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MnfTGmP9fKI8T0jGT6nvkLxE0bPZZUYhyiKwifpKhYIdOrHFJYOR72tNgQxbkIdzTaH1d0NeJL5zea0i7PtoVSCykdKY97grb6vrPaCJDuxXtTGQjr4q6oLClBDwwml0f7uiRM1DkyZjxmuJtzoGPBfRW5uyELFT24vmnMzxojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d179Gpgs; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d179Gpgs"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2caed617615so46052145ad.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Jul 2026 04:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784028932; x=1784633732; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvrHeqvmCVB3+5coRQtr0R7Of7xWrHzHhep15z+ep+E=;
        b=d179GpgsLSBOFvl9bkT+7CupY8pnP7dMh/EGx1DRt4W3qPV+b3jv9Jkag3sRCvfDfG
         flAhPpm293gTypECAkvm+Co531Bj9lGv6KmAY6EhFW0YdPWWrjfZlnYjBHTsj1j325sL
         KYeV4FGKLvjCrManQUngTjbqZrbS6dYvAonpm0jCkDq/JV23GRAMUx6UZxErL/K38HG1
         clyVa+6NW7sQvFOf2NeYaBBRCOWwU7EvN5ljy6JijftSH536BRmzB4mjziY77MFbsymT
         /z7/eOo2w4i1YxfRh1ICtEe5QBSUKCEU/r47w4Q9LRwP9T6QBlroJzbHX9trOdNBOwR3
         AOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784028932; x=1784633732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvrHeqvmCVB3+5coRQtr0R7Of7xWrHzHhep15z+ep+E=;
        b=rXzoBfUoN69lil6DICxFBLsYVTmCtGaVnOkPEiLc/ByjZo+h3KJP2Wv2BJiDnM9AAM
         cXvPR+BPf8ABNKstbWvosbQrNpAFrljxU1a1sr+yrkrj7DQiW9K25Q/fwd8Z18RSX/lZ
         FY7YaPP5PCCdu6B448AL/sCN9F6U0YfSax2ujLoHw1yMr1Kp3wDTdws0YN6gIe7uhx6e
         Cm1s+iu94wWLnzxILJDBtpl9iGcNTIQRcJqE/Iq1A9vE3GfVoxZqFhBTNarRtVp6x4SK
         LwzohGpyeUi9Fx8XZ2n3tYPvXjFB4KqfSQb3H48iyW/LiYuRngo4d30HI3VMePArnAwZ
         atKQ==
X-Forwarded-Encrypted: i=1; AHgh+RrHyL++yzR3bcEETqyYkzvwXfHI2+wlR3UzOy7lWoahXzYl6RvQc/GdBmMhnZfiRNOTwsRLXFhMM+RdSw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2fxrjYvsTe3QJ0CNGFa4NoL5mLQLAkHqm/rHch9NVJvvetolU
	9jc6Yr9waVTOJN4u/N9XGa441BPtpnVklE8xmKk4i5aXNuAse09aKZZt
X-Gm-Gg: AfdE7cnwopT9QUeSAoP0hQs0r5qqxl+JO0TvtuWHX0q5un5gaxH29EtCoHYoJc7B60T
	Nnb/vyGnYE0CywmL8Ed6i5vSmVa4R9Bycgg5P5VFwcekVxOJ2zoQHGoJd/HcWFMFjeK8ohz983p
	AnafJObho2OhuudmfI3hrcDtYMet/Zdfrna9NTZr15iTDvypKYYC1RbPVCXuMaZiHc9Z72zL582
	U4mNZx+CkjRaQ8yAiGHliCDqUwY3ToOJp2uOUv56qb1MR02hFKtmMCAAiudbRRgwpeXRrlnr41q
	ym5bYtuVuJB8s7gxy1I33N1VTVfrac92oGRIWZvX3QALE2uI+xo+ztuMWub2aSZKNyiOnmFMPvD
	1vbmf4xpD0OChfhrYknAKVXiYi4lGQY8HAyE6JJ1ehKdoaZ5+2Z72H03WNuOHWT4VWKhRuc7ZhA
	4tLrcQIXYbcYFm
X-Received: by 2002:a17:903:240c:b0:2c9:da58:17dd with SMTP id d9443c01a7336-2ce9f050e8emr116205925ad.34.1784028931848;
        Tue, 14 Jul 2026 04:35:31 -0700 (PDT)
Received: from lgs.. ([101.36.106.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3bbaesm114482675ad.57.2026.07.14.04.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 04:35:31 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Tristan Ye <tristan.ye@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v2] ocfs2: free unused clusters on defrag move errors
Date: Tue, 14 Jul 2026 19:35:17 +0800
Message-ID: <20260714113517.1381604-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_defrag_extent() claims new clusters before calling
__ocfs2_move_extent(). If the move fails before the extent tree update
is attempted, the claimed clusters are not referenced by the inode and
must be released.

The current error path only logs the error and continues to
ocfs2_cow_sync_writeback(), which can overwrite the original error with
zero. The claimed clusters are also left allocated.

Not every __ocfs2_move_extent() error can free the new clusters,
however. Once ocfs2_split_extent() has been called, the extent tree may
already reference them even if a later operation fails. Freeing them in
that case would leave the extent tree pointing to clusters marked free.

Track whether the extent split has been started. On errors before that
point, report that the new clusters remain unused so the defrag caller
can release them. Once the split has started, leave the clusters
allocated. Return all move errors through the transaction cleanup path
without allowing writeback to overwrite them.

Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
v2:
  - Do not free the new clusters after the extent-tree update has
    started, as pointed out by Joseph Qi.
  - Track whether the new clusters remain unused on error.
  - Preserve __ocfs2_move_extent() errors instead of allowing the
    subsequent writeback call to overwrite them.

 fs/ocfs2/move_extents.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..138c65d21668 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -49,9 +49,10 @@ struct ocfs2_move_extents_context {
 static int __ocfs2_move_extent(handle_t *handle,
 			       struct ocfs2_move_extents_context *context,
 			       u32 cpos, u32 len, u32 p_cpos, u32 new_p_cpos,
-			       int ext_flags)
+			       int ext_flags, bool *new_clusters_unused)
 {
 	int ret = 0, index;
+	bool split_started = false;
 	struct inode *inode = context->inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_rec *rec, replace_rec;
@@ -59,6 +60,10 @@ static int __ocfs2_move_extent(handle_t *handle,
 	struct ocfs2_extent_list *el;
 	u64 ino = ocfs2_metadata_cache_owner(context->et.et_ci);
 	u64 old_blkno = ocfs2_clusters_to_blocks(inode->i_sb, p_cpos);
+	bool split_started = false;
+
+	if (new_clusters_unused)
+		*new_clusters_unused = false;
 
 	ret = ocfs2_duplicate_clusters_by_page(handle, inode, cpos,
 					       p_cpos, new_p_cpos, len);
@@ -111,6 +116,7 @@ static int __ocfs2_move_extent(handle_t *handle,
 	 */
 	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
 
+	split_started = true;
 	ret = ocfs2_split_extent(handle, &context->et, path, index,
 				 &replace_rec, context->meta_ac,
 				 &context->dealloc);
@@ -138,6 +144,9 @@ static int __ocfs2_move_extent(handle_t *handle,
 
 	ocfs2_update_inode_fsync_trans(handle, inode, 0);
 out:
+	if (ret && !split_started && new_clusters_unused)
+		*new_clusters_unused = true;
+
 	ocfs2_free_path(path);
 	return ret;
 }
@@ -209,6 +218,7 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 	u32 new_phys_cpos, new_len;
 	u64 phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, phys_cpos);
+	bool new_clusters_unused;
 	int need_free = 0;
 
 	if ((ext_flags & OCFS2_EXT_REFCOUNTED) && *len) {
@@ -309,9 +319,14 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 	     phys_cpos, new_phys_cpos);
 
 	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
-				  new_phys_cpos, ext_flags);
-	if (ret)
+				  new_phys_cpos, ext_flags,
+				  &new_clusters_unused);
+	if (ret) {
 		mlog_errno(ret);
+		if (new_clusters_unused)
+			need_free = 1;
+		goto out_commit;
+	}
 
 	if (partial && (new_len != *len))
 		*len = new_len;
@@ -684,7 +699,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	}
 
 	ret = __ocfs2_move_extent(handle, context, cpos, len, phys_cpos,
-				  *new_phys_cpos, ext_flags);
+				  *new_phys_cpos, ext_flags, NULL);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
-- 
2.43.0

