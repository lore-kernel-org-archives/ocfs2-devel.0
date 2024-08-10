Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E37107A0
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Aug 2024 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723319604; cv=none; b=bjz34CJqQFNdd/nmLYd7od1iYb7/7jJIbmXk1R6m7L5w1fLRME0blbgOARKg+PNphrHDAQrh152Hii0C9lDhE9NwNXPf40lpn+P2vBfXPXKpCB5A+LjK8XitUemH5UtSXTjoIsgI1qcwaH0iSwD1+k0LvyWqv+ExZP1lQXl1OEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723319604; c=relaxed/simple;
	bh=BHIU2InSC64hLrVrzlFekZ0somTwM/HyiGBUHzA7vAA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R/3pyTs/Sbpb++xIhxM+5L8rgmexjkg33tLJH6NFo/mFAvIPOsNNZBB81rjq4NBydZy7aeazPaHxJb8bkoax/c+Efh5+7bMoI6wZM1kKUOzTYnoWufOX9jAop1YZEt2JWHqaKiPOm3gHJdRaanAxoaS8rv1Gfb/Bu/Adg1pFH6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CfRC+T7C; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CfRC+T7C"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc71a8a340so1216555ad.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 10 Aug 2024 12:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723319602; x=1723924402; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RT/8SZgyxy/IdolTekKRVwjoG2TSesGN9ly9JHx/q30=;
        b=CfRC+T7CBzYHNxBMvvUES2ohZ3aqEyZVifjHzYoLfNQrfnYTNR39dHhpgCGcwMHu1b
         uj6176KwaiujsIKUDSbUbSbbf2AXWr3bAX2WQS8hzp9UT+II82jmif+LcOObxAQH1B7Z
         rOUuhWXW1plSLardgDSPfjB5MmvV6IqvoslqQQZKR+5UvPG3S1fWCoRnqFGXRwJxWSib
         dUIN+IIgNpRNqpB/7mKwyTAefvPpPfdkmCCRHK2XCute82QzVBmO1AYBfnFr3/WtH9MF
         kMmKyxPniK7w9zV5qdBzJ5rd1Vjj3qHZVJ58hTAIG6Tr11eympwrajsJDlAYZGedUxtn
         vyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723319602; x=1723924402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RT/8SZgyxy/IdolTekKRVwjoG2TSesGN9ly9JHx/q30=;
        b=CS/yPwyb6I60lq70wHkLqB/WRJsabnd7wjBnA3r8IhUVJ2qUTpSGtS8a7KiVxYzKPx
         /a/gMCe8v3Z3L3mg0l/qCRQf79qgA92Od1hUE4wLS2MjazlchuYt35Lqa4enRQuztRoO
         4WvRWqcB1O9w7ol1+xSFHelSGdf8eYc9U7qZcyu+rj3ucX2lT4Yio1gywBiNBoSD+CHQ
         qhtx8RoonzQsBOfAoW7NkxgfB8j0OHeRnW3UinfMIp1OJe7dTXk8j9OoO8+ZuBXbXjLp
         IaUzJdJv0wQKAx13MHqVOJ9wlrgb6GMC4qzuuWC4BIbgkUn6f56gXAB8NZdH1QC3n0sS
         eZuA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ5KHm8pOXnusZBMnBaXSHEfs6Ro9+HDoy1px6uGU4BFZzi5AopDRUVIFdMuB7k/sEXR6oRDUN+5YBC3fIu6hpub1FljBtveTphaw=
X-Gm-Message-State: AOJu0YxzEsgUw2+HJjkup0HIo5motNPuP19wfg72J2INzlVN7ZR8RF+L
	BtP3TLEiBNdWimgPttbtmD2wY930disDuF88XePiNF134n7czuNA28bRcQ==
X-Google-Smtp-Source: AGHT+IEyegN8ne/NBe7gxuyhDgh79XREsz5HAjvumAutY7om9XUbSM263saQc/jYpgj7FaBCSg9lHw==
X-Received: by 2002:a17:902:d491:b0:1fd:d6d8:134a with SMTP id d9443c01a7336-200ae69dc2bmr40423735ad.11.1723319601970;
        Sat, 10 Aug 2024 12:53:21 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bbb3a8desm14596535ad.281.2024.08.10.12.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 12:53:21 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: jserv@ccns.ncku.edu.tw,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH] ocfs2: Remove custom swap functions in favor of built-in sort swap
Date: Sun, 11 Aug 2024 03:53:16 +0800
Message-Id: <20240810195316.186504-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The custom swap functions used in ocfs2 do not perform any special
operations and can be replaced with the built-in swap function of sort.
This change not only reduces code size but also improves efficiency,
especially in scenarios where CONFIG_RETPOLINE is enabled, as it makes
indirect function calls more expensive.

By using the built-in swap, we avoid these costly indirect function
calls, leading to better performance.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
Note: Build test only.

 fs/ocfs2/dir.c          | 12 +-----------
 fs/ocfs2/refcounttree.c | 13 +++----------
 fs/ocfs2/xattr.c        | 15 +++------------
 3 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f0beb173dbba..fa5d0819a997 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3511,16 +3511,6 @@ static int dx_leaf_sort_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static void dx_leaf_sort_swap(void *a, void *b, int size)
-{
-	struct ocfs2_dx_entry *entry1 = a;
-	struct ocfs2_dx_entry *entry2 = b;
-
-	BUG_ON(size != sizeof(*entry1));
-
-	swap(*entry1, *entry2);
-}
-
 static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
 {
 	struct ocfs2_dx_entry_list *dl_list = &dx_leaf->dl_list;
@@ -3781,7 +3771,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 	 */
 	sort(dx_leaf->dl_list.de_entries, num_used,
 	     sizeof(struct ocfs2_dx_entry), dx_leaf_sort_cmp,
-	     dx_leaf_sort_swap);
+	     NULL);
 
 	ocfs2_journal_dirty(handle, dx_leaf_bh);
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1f303b1adf1a..4f85508538fc 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1392,13 +1392,6 @@ static int cmp_refcount_rec_by_cpos(const void *a, const void *b)
 	return 0;
 }
 
-static void swap_refcount_rec(void *a, void *b, int size)
-{
-	struct ocfs2_refcount_rec *l = a, *r = b;
-
-	swap(*l, *r);
-}
-
 /*
  * The refcount cpos are ordered by their 64bit cpos,
  * But we will use the low 32 bit to be the e_cpos in the b-tree.
@@ -1474,7 +1467,7 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 	 */
 	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_low_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_low_cpos, NULL);
 
 	ret = ocfs2_find_refcount_split_pos(rl, &cpos, &split_index);
 	if (ret) {
@@ -1499,11 +1492,11 @@ static int ocfs2_divide_leaf_refcount_block(struct buffer_head *ref_leaf_bh,
 
 	sort(&rl->rl_recs, le16_to_cpu(rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_cpos, NULL);
 
 	sort(&new_rl->rl_recs, le16_to_cpu(new_rl->rl_used),
 	     sizeof(struct ocfs2_refcount_rec),
-	     cmp_refcount_rec_by_cpos, swap_refcount_rec);
+	     cmp_refcount_rec_by_cpos, NULL);
 
 	*split_cpos = cpos;
 	return 0;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 35c0cc2a51af..0e58a5ce539e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4167,15 +4167,6 @@ static int cmp_xe(const void *a, const void *b)
 	return 0;
 }
 
-static void swap_xe(void *a, void *b, int size)
-{
-	struct ocfs2_xattr_entry *l = a, *r = b, tmp;
-
-	tmp = *l;
-	memcpy(l, r, sizeof(struct ocfs2_xattr_entry));
-	memcpy(r, &tmp, sizeof(struct ocfs2_xattr_entry));
-}
-
 /*
  * When the ocfs2_xattr_block is filled up, new bucket will be created
  * and all the xattr entries will be moved to the new bucket.
@@ -4241,7 +4232,7 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	trace_ocfs2_cp_xattr_block_to_bucket_end(offset, size, off_change);
 
 	sort(target + offset, count, sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe, swap_xe);
+	     cmp_xe, NULL);
 }
 
 /*
@@ -4436,7 +4427,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	 */
 	sort(entries, le16_to_cpu(xh->xh_count),
 	     sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe_offset, swap_xe);
+	     cmp_xe_offset, NULL);
 
 	/* Move all name/values to the end of the bucket. */
 	xe = xh->xh_entries;
@@ -4478,7 +4469,7 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	/* sort the entries by their name_hash. */
 	sort(entries, le16_to_cpu(xh->xh_count),
 	     sizeof(struct ocfs2_xattr_entry),
-	     cmp_xe, swap_xe);
+	     cmp_xe, NULL);
 
 	buf = bucket_buf;
 	for (i = 0; i < bucket->bu_blocks; i++, buf += blocksize)
-- 
2.34.1

