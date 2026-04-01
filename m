Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B031E7C03
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775007566; cv=none; b=jQlAYfWNXE/Ejdmbztawvjc1Y/+fgu1vw0QhSj0falcj5NZvsuc6850Rp4eDXVE49Ph16Iu6s1Gu73C/Utw9Yqw8K2SGysZbCa3V1Lf/UJb2o7j1Mk11F7h6wd0sgAwMMjJfL1Ly9W0TdMm+eq+/d8leuxdkRic39kPXBAPEnwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775007566; c=relaxed/simple;
	bh=1K5YNg6goourLvYf+5GyXSZzC8Xg639aEmLb5t7/504=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F51OgpuJF9RBaPzIHyH/TOX3TXSvwH3QFhqJA6uDe0IzX5AvjyDdYHroZEA6GSo0Ahngz9/5yXSuRj0VTegv5ZrujEZdeLmkfClhbKJMiURyxZoKiSnO0YnOI+M8Mimf/i1dcAHcWbKQLn2ZI+7t6QJNhYepTFsR8Vqyrv8qmus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oUDNHARe; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oUDNHARe"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad617d5b80so43704385ad.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 18:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775007564; x=1775612364; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r8r8/bpiXzZ96Llz4sHkNmoXHZp4csIr6fCQclwBPYM=;
        b=oUDNHAReFiYUhVTv5vofFcBEqBVicVvSMbWPDRnpqM/vKV88ZhiYWYtSZ6dFJAAwTj
         HzIL7gdwx73kU7YJKhp0VUJth4sG4ZRHnk6Sfc83PbwSAox+eBCpthMZTujfohxpZO6I
         UBVvAbc9h7nUEmG8FxSIZOlMP5dGXJ5htNrmI0KuMiuaXva/0TzMx9WkqpCyAqAwztWg
         LrdIJuia7cM5OT4dAY+aIDdV1A0QgkxCs5yX3gOkO4wA3pEuUqyF/GcV0XUex+UGdqdE
         oE0Z9R1QcUDn6NZjLgAqo2NoMlQofQYZWclP8ITyD0ZNJZlk/HmvdB7BQPhIXv5gUqsz
         MRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775007564; x=1775612364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8r8/bpiXzZ96Llz4sHkNmoXHZp4csIr6fCQclwBPYM=;
        b=K+vlPcQ1UNHN7xtkGZUEIadlhgSmv5DD4Ut7i3Uv5esgparb1gA5ZY4HWfScBKHdHo
         rI3XB57bVLGZrnJtIhHrqsSRnoOEM0uxWbSojah2y0mRws+ucKJvcPbIJ7Jvi95nXZEj
         uvvQum7rdaE99+W40FoDiVNs9ldwst7gRUbCzGwBZiIAD4wtLryDx0KElJmjMmDI7db4
         jayD5qgabpM1J7cgR4S9irSOJbYo4AvQsZjElM2+jxA2WPLYZBattSRol9CBu4twWdKm
         8JG9jD07BJ+7F9swDNf9BXU/+YteetD6gULRoe9KtiazfufYjLthRzDfCF60H7No1GPc
         LxTA==
X-Gm-Message-State: AOJu0YxEThKYEuYBLDQ7BAw9rZeAe1Hl+nmw/1TsqOe0wwPQIfzWiuX/
	1ktUhfsIAFTN4YkWwd5llP0G5vO688wcSiWGWVx9Jp5AXKuVq9zSelMg
X-Gm-Gg: ATEYQzx0TpAnyn24eklZ2oPydqC+S2awL+y7VOTqm1Cfj47btSwoZcGFyYJLUzbMWm5
	wDvXW9SPmPj6fmOrssCc2gpQO978kK+uZW0Vo+7l0QNpop8BB63RsDMCHGDaQeB3GGbT+diP18z
	ZaCqRJToYqYLSQBB3B49QGkMeemGhAbvtt6JkPFXouM6AckBXSNEZ508gYZXXtfYVsfsQXx/Tsm
	rRqWq1QAuD3qMCln77A23vsPaVjQ03N+k4KH41Dh5v8TJ6f985iCOM5AlTIsyJLVC2/US5r5bQm
	CLICLqdzEVXQ1nhIaUlsI4Q/rIHXh5g/bP5FI6ZkDkmqys8CYpIOvnrOWi7w0WDjvKvoaDmvzzj
	BvOtDHN9MJdrfUnuRmWGD/Qdw1+iW04sjCHrL+u1WwOgrGt5xcDq7efDKSFGkSTbLFiqIzIPa9A
	4mZjlAS34QlYf0E4ngv3TdRRDOk+Or9NGNBT/eYZa3p4FuRwykHT0VibGBCNzpjLkh1ndUyXU=
X-Received: by 2002:a17:903:90f:b0:2b0:5ec1:97c1 with SMTP id d9443c01a7336-2b269a950c8mr13744885ad.7.1775007564166;
        Tue, 31 Mar 2026 18:39:24 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427afa57sm158766785ad.71.2026.03.31.18.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 18:39:23 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: validate dx extent list bounds during lookup
Date: Wed,  1 Apr 2026 09:39:14 +0800
Message-ID: <20260401013914.3543304-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted indexed directory can trigger a KASAN use-after-free in
ocfs2_dx_dir_lookup_rec() when the dx root or leaf extent list carries
an out-of-range l_count or l_next_free_rec value.

BUG: KASAN: use-after-free in ocfs2_dx_dir_lookup_rec+0x6f7/0x880 fs/ocfs2/dir.c:813
Read of size 4 at addr ffff888043b7b0e0 by task syz.0.3467/8031

Call Trace:
 <TASK>
 ...
 ocfs2_dx_dir_lookup_rec+0x6f7/0x880 fs/ocfs2/dir.c:813
 ocfs2_dx_dir_lookup+0x100/0x5d0 fs/ocfs2/dir.c:868
 ocfs2_dx_dir_search+0x7bc/0x11c0 fs/ocfs2/dir.c:928
 ocfs2_find_entry_dx fs/ocfs2/dir.c:1042 [inline]
 ocfs2_find_entry+0x97e/0xce0 fs/ocfs2/dir.c:1079
 ocfs2_find_files_on_disk+0xa9/0x2f0 fs/ocfs2/dir.c:2002
 ocfs2_lookup_ino_from_name+0xae/0x110 fs/ocfs2/dir.c:2024
 ocfs2_lookup+0x45e/0x860 fs/ocfs2/namei.c:122
 lookup_open.isra.0+0x4a2/0x1460 fs/namei.c:3774
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x11fe/0x2ce0 fs/namei.c:4131
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
ocfs2_dx_dir_lookup_rec() only checked for an empty extent list before
iterating over the directory index records. It did not verify that the
root dx list fits within a dx root block, or that the leaf list fits
within an extent block.

Comparing l_next_free_rec only against the on-disk l_count is also not
enough because l_count itself can be corrupted.

[FIX]
Validate both the dx root list and the leaf extent list against their
physical record capacities before indexing into l_recs[]. Use
ocfs2_extent_recs_per_dx_root() for the root and
ocfs2_extent_recs_per_eb() for the leaf block so the bounds check does
not trust on-disk sizing fields.

Fixes: 9b7895efac90 ("ocfs2: Add a name indexed b-tree to directory inodes")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/dir.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b82fe4431eb1..3403c0d3810e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -790,15 +790,25 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec = NULL;
+	unsigned int max_recs;
 
-	if (le16_to_cpu(el->l_count) !=
-	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
+	max_recs = ocfs2_extent_recs_per_dx_root(inode->i_sb);
+	if (le16_to_cpu(el->l_count) != max_recs) {
 		ret = ocfs2_error(inode->i_sb,
 				  "Inode %llu has invalid extent list length %u\n",
 				  inode->i_ino, le16_to_cpu(el->l_count));
 		goto out;
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > max_recs) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %llu has invalid dx root next free %u, max %u\n",
+				  inode->i_ino,
+				  le16_to_cpu(el->l_next_free_rec),
+				  max_recs);
+		goto out;
+	}
+
 	if (el->l_tree_depth) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
 				      &eb_bh);
@@ -817,6 +827,27 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 					  (unsigned long long)eb_bh->b_blocknr);
 			goto out;
 		}
+
+		max_recs = ocfs2_extent_recs_per_eb(inode->i_sb);
+		if (le16_to_cpu(el->l_count) != max_recs) {
+			ret = ocfs2_error(inode->i_sb,
+					  "Inode %llu has invalid tree block %llu list count %u, max %u\n",
+					  inode->i_ino,
+					  (unsigned long long)eb_bh->b_blocknr,
+					  le16_to_cpu(el->l_count),
+					  max_recs);
+			goto out;
+		}
+
+		if (le16_to_cpu(el->l_next_free_rec) > max_recs) {
+			ret = ocfs2_error(inode->i_sb,
+					  "Inode %llu has invalid tree block %llu next free %u, max %u\n",
+					  inode->i_ino,
+					  (unsigned long long)eb_bh->b_blocknr,
+					  le16_to_cpu(el->l_next_free_rec),
+					  max_recs);
+			goto out;
+		}
 	}
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0) {
