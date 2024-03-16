Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325B24C6D
	for <ocfs2-devel@lists.linux.dev>; Sat, 16 Mar 2024 03:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710560709; cv=none; b=VTgzqDjiGOTdror8JtqHK7pPIvyCPH/B/1Xd6gzTlLb10kR46ecOE7wrm8GwT5zXEUAfHiJWVjSTx6xyS2U0rusRfOEcN8V9WPtcQxGKLl28ZHeTyktR6j733E4P7RALjYn+hPOY8rFxbhZ4wB4UIohYg41yDkBZa8GYPxVkmUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710560709; c=relaxed/simple;
	bh=4KD3eWbwToGIavtJZo+Taa7a7N9bhjVLakwBYewmT3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BBFUyRt9Zu2Vb8mBdVMIoyi9IOEhK/oL4EfikaLR+8EUz3dvHgNwfCtMXrnxeE2iANM0es7GX/7nT38f2zxwPAIp0tmm1/zIOHH/PfABWvuYGWSxtdj+04Smnkve/B4oHmlE+x6T5PUesCED/HU+7H9AqUWeHpyLQpymhAkuz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UccukONz; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UccukONz"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d4698f4936so36762141fa.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 Mar 2024 20:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710560704; x=1711165504; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MH22RUV0Vin1EnYdriWxu3esrt/fmlothsuIa+uFAhw=;
        b=UccukONzoGcdD4RRdy84WM2A5VeXVbXFmQEQl9KlqCUGVu18JpcH9yxwKOlyBDqQj2
         7I/HeMNKYCGqcNv/Rud6LLJ3LamLpGBk4Ko3rYxOIy1lm6ORspARINdNO+tx0BNtnjGL
         ugPkHb+xBYzyffAgGbVypkJcWoSmu0Jsijm4LqEvBHIZ3x4wJkeRQ00R9LkchhKU6JY2
         zM4SvjnWU8+MMi939GphsR3xa5icFoztcSBJ6FozjMKZBPLNRUrT2p2ccIQ0OiPb5hen
         mQZ7DsbWVV15iHvWsinektp/4RRJJIeiNWKSD3gtAmE1nYw8ebvgmqzeVrgO9N+iAiCg
         nNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710560704; x=1711165504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MH22RUV0Vin1EnYdriWxu3esrt/fmlothsuIa+uFAhw=;
        b=qNe8eJxCpmrFs7afeo3neSu9FOlB2Qnb5AI2bzSONPARwyyX652X38igE6IJl9hlgL
         dzYz3wykWQfnGy3JKSMVJeB9biYggkmnpkxqw+tpmNNkxUKtjr8urPfD1JN2b8+UeSHH
         jz8xIr/6vDqeZ1rjPJx94DZfi8BHqCsPObT3avnc/yY1XCNUgtZo9ZlierSc2MoT8Aj4
         1ubpX8+7DGkbuGY+H25Aers9i4AdXcWGkpLVf+fBco3T6kPz14SqP9mNB1SJntKrVQBx
         01nYkLz++PGZYqseur8uQiCpADMexEUcZgqxU+GtdoWqi0JWwsg1dSJm8tKd8phHADxq
         PmwA==
X-Forwarded-Encrypted: i=1; AJvYcCVWa5zgQ1MzMYsBFgGEq466QxrXObiKOkrTi4L1vI1dsM2GZCgw4VZvQ/fblcyPSpdZILooO8OcpIdoXtgQounrWrfVln9o6bW2Kfo=
X-Gm-Message-State: AOJu0Yzz9h4cJx+cFCDpYHH6wkKjcD0VeokQw/GjfP7Io31Pw81Im9cF
	8jESi0cgI+1NbMu9SC/CTiYGYFimjnhloaReWQ83yIrLmQrlulgj86WvfbRrSCE=
X-Google-Smtp-Source: AGHT+IE8MKYy/wGDzLdHjW6wLEMrlfbtUQICOCajvofDyYSR+tCtyYMKYhilGc4tFEHpLcHeZAm91Q==
X-Received: by 2002:a2e:8944:0:b0:2d4:7663:ab08 with SMTP id b4-20020a2e8944000000b002d47663ab08mr4991428ljk.0.1710560704230;
        Fri, 15 Mar 2024 20:45:04 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id k8-20020a170902c40800b001defa2df4efsm1505855plk.155.2024.03.15.20.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 20:45:03 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v2] ocfs2: improve write IO performance when fragmentation is high
Date: Sat, 16 Mar 2024 11:44:57 +0800
Message-Id: <20240316034457.16893-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The group_search function ocfs2_cluster_group_search() should
bypass groups with insufficient space to avoid unnecessary
searches.

This patch is particularly useful when ocfs2 is handling huge
number small files, and volume fragmentation is very high.
In this case, ocfs2 is busy with looking up available la window
from //global_bitmap.

This patch introduces a new member in the Group Description (gd)
struct called 'bg_contig_free_bits', representing the max
contigous free bits in this gd. When ocfs2 allocates a new
la window from //global_bitmap, 'bg_contig_free_bits' helps
expedite the search process.

Let's image below path.

1. la state (->local_alloc_state) is set THROTTLED or DISABLED.

2. when user delete a large file and trigger
   ocfs2_local_alloc_seen_free_bits set osb->local_alloc_state
   unconditionally.

3. a write IOs thread run and trigger the worst performance path

```
ocfs2_reserve_clusters_with_limit
 ocfs2_reserve_local_alloc_bits
  ocfs2_local_alloc_slide_window //[1]
   + ocfs2_local_alloc_reserve_for_window //[2]
   + ocfs2_local_alloc_new_window //[3]
      ocfs2_recalc_la_window
```

[1]:
will be called when la window bits used up.

[2]:
under la state is ENABLED, and this func only check global_bitmap
free bits, it will succeed in general.

[3]:
will use the default la window size to search clusters then fail.
ocfs2_recalc_la_window attempts other la window sizes.
the timing complexity is O(n^4), resulting in a significant time
cost for scanning global bitmap. This leads to a dramatic slowdown
in write I/Os (e.g., user space 'dd').

i.e.
an ocfs2 partition size: 1.45TB, cluster size: 4KB,
la window default size: 106MB.
The partition is fragmentation by creating & deleting huge mount of
small files.

before this patch, the timing of [3] should be
(the number got from real world):
- la window size change order (size: MB):
  106, 53, 26.5, 13, 6.5, 3.25, 1.6, 0.8
  only 0.8MB succeed, 0.8MB also triggers la window to disable.
  ocfs2_local_alloc_new_window retries 8 times, first 7 times totally
  runs in worst case.
- group chain number: 242
  ocfs2_claim_suballoc_bits calls for-loop 242 times
- each chain has 49 block group
  ocfs2_search_chain calls while-loop 49 times
- each bg has 32256 blocks
  ocfs2_block_group_find_clear_bits calls while-loop for 32256 bits.
  for ocfs2_find_next_zero_bit uses ffz() to find zero bit, let's use
  (32256/64) (this is not worst value) for timing calucation.

the loop times: 7*242*49*(32256/64) = 41835024 (~42 million times)

In the worst case, user space writes 1MB data will trigger 42M scanning
times.

under this patch, the timing is '7*242*49 = 83006', reduced by three
orders of magnitude.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v2:
1. fix wrong length converting from cpu_to_le16() to cpu_to_le32()
   for setting bg->bg_contig_free_bits.
2. change ocfs2_find_max_contig_free_bits return type from 'void' to
   'unsigned int'.
3. restore ocfs2_block_group_set_bits() input parameters style, change
   parameter 'failure_path' to 'fastpath'.
4. after <3>, add new parameter 'unsigned int max_contig_bits'. 
5. after <3>, restore define 'struct ocfs2_suballoc_result' from
   'suballoc.h' to 'suballoc.c'.
6. modify some code indent error.

---
 fs/ocfs2/move_extents.c |  2 +-
 fs/ocfs2/ocfs2_fs.h     |  4 +-
 fs/ocfs2/resize.c       |  7 +++
 fs/ocfs2/suballoc.c     | 99 +++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/suballoc.h     |  6 ++-
 5 files changed, 106 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 1f9ed117e78b..f9d6a4f9ca92 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -685,7 +685,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	}
 
 	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
-					 goal_bit, len);
+					 goal_bit, len, 0, 0);
 	if (ret) {
 		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
 					       le16_to_cpu(gd->bg_chain));
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7aebdbf5cc0a..eae18d772e93 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -883,14 +883,14 @@ struct ocfs2_group_desc
 	__le16	bg_free_bits_count;     /* Free bits count */
 	__le16   bg_chain;               /* What chain I am in. */
 /*10*/	__le32   bg_generation;
-	__le32	bg_reserved1;
+	__le32   bg_contig_free_bits;  /* max contig free bits length */
 	__le64   bg_next_group;          /* Next group in my list, in
 					   blocks */
 /*20*/	__le64   bg_parent_dinode;       /* dinode which owns me, in
 					   blocks */
 	__le64   bg_blkno;               /* Offset on disk, in blocks */
 /*30*/	struct ocfs2_block_check bg_check;	/* Error checking */
-	__le64   bg_reserved2;
+	__le64   bg_reserved1;
 /*40*/	union {
 		DECLARE_FLEX_ARRAY(__u8, bg_bitmap);
 		struct {
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d65d43c61857..2cf3772dd175 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -91,6 +91,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
 	u16 old_bg_clusters;
+	u32 contig_bits, old_bg_contig_free_bits;
 
 	trace_ocfs2_update_last_group_and_inode(new_clusters,
 						first_new_cluster);
@@ -122,6 +123,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
 
+	contig_bits = ocfs2_find_max_contig_free_bits(group->bg_bitmap,
+					group->bg_bits, 0);
+	old_bg_contig_free_bits = group->bg_contig_free_bits;
+	group->bg_contig_free_bits = cpu_to_le32(contig_bits);
+
 	ocfs2_journal_dirty(handle, group_bh);
 
 	/* update the inode accordingly. */
@@ -160,6 +166,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
+		group->bg_contig_free_bits = old_bg_contig_free_bits;
 	}
 out:
 	if (ret)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..2af63124065c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -50,6 +50,10 @@ struct ocfs2_suballoc_result {
 	u64		sr_blkno;	/* The first allocated block */
 	unsigned int	sr_bit_offset;	/* The bit in the bg */
 	unsigned int	sr_bits;	/* How many bits we claimed */
+	unsigned int	sr_max_contig_bits; /* The length for contiguous
+					     * free bits, only available
+					     * for cluster group
+					     */
 };
 
 static u64 ocfs2_group_from_res(struct ocfs2_suballoc_result *res)
@@ -1272,6 +1276,26 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	return ret;
 }
 
+int ocfs2_find_max_contig_free_bits(void *bitmap,
+			 unsigned int total_bits, int start)
+{
+	int offset, free_bits;
+	unsigned int contig_bits = 0;
+
+	while (start < total_bits) {
+		offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start);
+		if (offset == total_bits)
+			break;
+
+		start = ocfs2_find_next_bit(bitmap, total_bits, offset);
+		free_bits = start - offset;
+		if (contig_bits < free_bits)
+			contig_bits = free_bits;
+	}
+
+	return contig_bits;
+}
+
 static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 					     struct buffer_head *bg_bh,
 					     unsigned int bits_wanted,
@@ -1280,6 +1304,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 {
 	void *bitmap;
 	u16 best_offset, best_size;
+	u16 prev_best_size = 0;
 	int offset, start, found, status = 0;
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
 
@@ -1308,6 +1333,7 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 			/* got a zero after some ones */
 			found = 1;
 			start = offset + 1;
+			prev_best_size = best_size;
 		}
 		if (found > best_size) {
 			best_size = found;
@@ -1320,6 +1346,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 		}
 	}
 
+	/* best_size will be allocated, we save prev_best_size */
+	res->sr_max_contig_bits = prev_best_size;
 	if (best_size) {
 		res->sr_bit_offset = best_offset;
 		res->sr_bits = best_size;
@@ -1337,11 +1365,15 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 					     struct ocfs2_group_desc *bg,
 					     struct buffer_head *group_bh,
 					     unsigned int bit_off,
-					     unsigned int num_bits)
+					     unsigned int num_bits,
+					     unsigned int max_contig_bits,
+					     int fastpath)
 {
 	int status;
 	void *bitmap = bg->bg_bitmap;
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
+	unsigned int start = bit_off + num_bits;
+	unsigned int contig_bits;
 
 	/* All callers get the descriptor via
 	 * ocfs2_read_group_descriptor().  Any corruption is a code bug. */
@@ -1373,6 +1405,28 @@ int ocfs2_block_group_set_bits(handle_t *handle,
 	while(num_bits--)
 		ocfs2_set_bit(bit_off++, bitmap);
 
+	/*
+	 * this is optimize path, caller set old contig value
+	 * in max_contig_bits to bypass finding action.
+	 */
+	if (fastpath) {
+		bg->bg_contig_free_bits = cpu_to_le32(max_contig_bits);
+	} else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
+		/*
+		 * Usually, the block group bitmap allocates only 1 bit
+		 * at a time, while the cluster group allocates n bits
+		 * each time. Therefore, we only save the contig bits for
+		 * the cluster group.
+		 */
+		contig_bits = ocfs2_find_max_contig_free_bits(bitmap,
+				    le16_to_cpu(bg->bg_bits), start);
+		if (contig_bits > max_contig_bits)
+			max_contig_bits = contig_bits;
+		bg->bg_contig_free_bits = cpu_to_le32(max_contig_bits);
+	} else {
+		bg->bg_contig_free_bits = 0;
+	}
+
 	ocfs2_journal_dirty(handle, group_bh);
 
 bail:
@@ -1486,7 +1540,12 @@ static int ocfs2_cluster_group_search(struct inode *inode,
 
 	BUG_ON(!ocfs2_is_cluster_bitmap(inode));
 
-	if (gd->bg_free_bits_count) {
+	if (le16_to_cpu(gd->bg_contig_free_bits) &&
+	    le16_to_cpu(gd->bg_contig_free_bits) < bits_wanted)
+		return -ENOSPC;
+
+	/* ->bg_contig_free_bits may un-initialized, so compare again */
+	if (le16_to_cpu(gd->bg_free_bits_count) >= bits_wanted) {
 		max_bits = le16_to_cpu(gd->bg_bits);
 
 		/* Tail groups in cluster bitmaps which aren't cpg
@@ -1555,7 +1614,7 @@ static int ocfs2_block_group_search(struct inode *inode,
 	BUG_ON(min_bits != 1);
 	BUG_ON(ocfs2_is_cluster_bitmap(inode));
 
-	if (bg->bg_free_bits_count) {
+	if (le16_to_cpu(bg->bg_free_bits_count) >= bits_wanted) {
 		ret = ocfs2_block_group_find_clear_bits(OCFS2_SB(inode->i_sb),
 							group_bh, bits_wanted,
 							le16_to_cpu(bg->bg_bits),
@@ -1715,7 +1774,8 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	}
 
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
-					 res->sr_bit_offset, res->sr_bits);
+					 res->sr_bit_offset, res->sr_bits,
+					 res->sr_max_contig_bits, 0);
 	if (ret < 0) {
 		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
 					       res->sr_bits,
@@ -1849,7 +1909,9 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 					    bg,
 					    group_bh,
 					    res->sr_bit_offset,
-					    res->sr_bits);
+					    res->sr_bits,
+					    res->sr_max_contig_bits,
+					    0);
 	if (status < 0) {
 		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
 					ac->ac_bh, res->sr_bits, chain);
@@ -2163,7 +2225,9 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 					 bg,
 					 bg_bh,
 					 res->sr_bit_offset,
-					 res->sr_bits);
+					 res->sr_bits,
+					 res->sr_max_contig_bits,
+					 0);
 	if (ret < 0) {
 		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
 					       ac->ac_bh, res->sr_bits, chain);
@@ -2382,11 +2446,13 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 					struct buffer_head *group_bh,
 					unsigned int bit_off,
 					unsigned int num_bits,
+					unsigned int max_contig_bits,
 					void (*undo_fn)(unsigned int bit,
 							unsigned long *bmap))
 {
 	int status;
 	unsigned int tmp;
+	unsigned int contig_bits;
 	struct ocfs2_group_desc *undo_bg = NULL;
 	struct journal_head *jh;
 
@@ -2433,6 +2499,20 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
 				   num_bits);
 	}
 
+	/*
+	 * TODO: even 'num_bits == 1' (the worst case, release 1 cluster),
+	 * we still need to rescan whole bitmap.
+	 */
+	if (ocfs2_is_cluster_bitmap(alloc_inode)) {
+		contig_bits = ocfs2_find_max_contig_free_bits(bg->bg_bitmap,
+				    le16_to_cpu(bg->bg_bits), 0);
+		if (contig_bits > max_contig_bits)
+			max_contig_bits = contig_bits;
+		bg->bg_contig_free_bits = cpu_to_le32(max_contig_bits);
+	} else {
+		bg->bg_contig_free_bits = 0;
+	}
+
 	if (undo_fn)
 		spin_unlock(&jh->b_state_lock);
 
@@ -2459,6 +2539,7 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	struct ocfs2_chain_list *cl = &fe->id2.i_chain;
 	struct buffer_head *group_bh = NULL;
 	struct ocfs2_group_desc *group;
+	u32 old_bg_contig_free_bits = 0;
 
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
@@ -2483,9 +2564,11 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 
 	BUG_ON((count + start_bit) > le16_to_cpu(group->bg_bits));
 
+	if (ocfs2_is_cluster_bitmap(alloc_inode))
+		old_bg_contig_free_bits = group->bg_contig_free_bits;
 	status = ocfs2_block_group_clear_bits(handle, alloc_inode,
 					      group, group_bh,
-					      start_bit, count, undo_fn);
+					      start_bit, count, 0, undo_fn);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2496,7 +2579,7 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	if (status < 0) {
 		mlog_errno(status);
 		ocfs2_block_group_set_bits(handle, alloc_inode, group, group_bh,
-				start_bit, count);
+				start_bit, count, old_bg_contig_free_bits, 1);
 		goto bail;
 	}
 
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 9c74eace3adc..429fa12eea11 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -79,12 +79,16 @@ void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
+int ocfs2_find_max_contig_free_bits(void *bitmap,
+			 unsigned int total_bits, int start);
 int ocfs2_block_group_set_bits(handle_t *handle,
 			 struct inode *alloc_inode,
 			 struct ocfs2_group_desc *bg,
 			 struct buffer_head *group_bh,
 			 unsigned int bit_off,
-			 unsigned int num_bits);
+			 unsigned int num_bits,
+			 unsigned int max_contig_bits,
+			 int fastpath);
 
 int ocfs2_claim_metadata(handle_t *handle,
 			 struct ocfs2_alloc_context *ac,
-- 
2.35.3

