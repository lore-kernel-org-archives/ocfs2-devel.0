Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2A524DE
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614596; cv=none; b=nBub4OlWfcbWRr43CZ1dX/su8mcdG9eb6p//VcU8/QcGsCnFwuix5vdwRmuoRI0iPO+q9aX2ICWiG3DMtf37qkkUwIPW6q3cPuUeD+qcnNpnrE9N/MZA/DI8SMnwUoA9EJq8hpW+kA0SdU+4W16Ngz2gy7K0h5Z8D1nb0k3+D0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614596; c=relaxed/simple;
	bh=6+LuQo0F6yCRZtVeMu9+zuM0kuk83tQ7/f/CreyJQFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EHTniaj22z+PYDM4TmKZCP/2DSp7GGmJ6E3q7jeR5WJ7HBb9WFZqxg6mn2NV+avf8w9UQjHcAvfYwN7wDtHlV6eFIn2SUNCC6/kwoulxyq8QHBQQutNeWQ2N/2L9x1eWc1eD4s8NADw9K+vT8+U2x8ViiNORia/lJuvOhY/qsTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FQVzuXyo; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FQVzuXyo"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d6a1af9c07so6670271fa.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 01:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711614592; x=1712219392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0vtrTawclMZTZfpCATwkLPmBXwrf2rayXty9KQLCHw=;
        b=FQVzuXyoauhyPUljvgZMD7gEZjbNPtZif7XD8pFu6LFD+IaMD4esVkoeaarxjEsWVW
         JVjsXf4TX2cVFgDLqqb6MKNo5efbZ59JUtoHTK2sBl0gz9FXt3j1XS0kSS+fHLZf4G/v
         yzZ3ZdxD527sAkIID0c24A+SMtmCX60yNgitVuI+1lQPCOsVxT+nUMAmFRgu37AM3z1R
         vKfoeOiIf2Ybdhqqg5y0vFwj6TdSUtCJmuCTeM9R69rki6S3/pWRZ4yA/ToINbxA5Jzm
         KYffCT6KhgJJMt4aWujio8HzXqwqwgewb3nMAnklNPas6bLM4FSSIt74vbtR0+Iyaz4j
         kN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711614592; x=1712219392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0vtrTawclMZTZfpCATwkLPmBXwrf2rayXty9KQLCHw=;
        b=St2mzpQys9W3lA7hwy77G7ZXfKykR4xjsOA9tPEUvTp2e96Bj/2TEVanm2s0sb0S6K
         EfL0uoSU7FkMpkXVYqwUl9gQBtRfjm2vnzvK+VxT5/XadLF3k/lNhnLyzJw9ztYPsBtA
         2+1/4/Pj09t0T7u4zskRTu8vImo6MsMNDOsejdgjsXOI+zvr4zLKMXzMPauV8Ba5ePHd
         EFm+MMijsndIUNkwyesDzlDBYeQyV3Ods9T+238+mD8cNfVfH6LK3lzFPem6QdJVI20a
         lT/pPERyKLA77YqdJBJkep7LpSboviTmVZSfTk8ozeU7ChRwzpja61R/4DF+VvbZvCdd
         +dKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSQxFub5fxmXAklPQiNIGkfw0+xV+WyMDyTk5ZhAfMGXiECZaS848BEVce4VxgxjtswUgW2HpOkZOph/8bp2yPI/DI1/u0WMGD4SU=
X-Gm-Message-State: AOJu0Yzc2gFqtizoCJaHPrx6R7yMuvrsEuZ5B39HIhYHcBSSrHUz9Dyb
	LKrZZs/85dBUAxqOIlXCI3E9bA9VN8rSn25jr4vxs8O4B73KfspBStQibL7FP0HA9alwtFP0jvF
	g
X-Google-Smtp-Source: AGHT+IEu0DJ2eYBdvt/CIKdSNC5UbeSNHfNAN4Sy/p8fy1sF1uuXpLZe3KaBNKSXtD4jbLYC3hQeJQ==
X-Received: by 2002:a05:651c:212a:b0:2d6:c94d:d700 with SMTP id a42-20020a05651c212a00b002d6c94dd700mr1714001ljq.14.1711614591809;
        Thu, 28 Mar 2024 01:29:51 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b001e014627baasm955120plk.79.2024.03.28.01.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 01:29:51 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v5 1/4] ocfs2: improve write IO performance when fragmentation is high
Date: Thu, 28 Mar 2024 16:29:40 +0800
Message-Id: <20240328082943.20251-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240328082943.20251-1-heming.zhao@suse.com>
References: <20240328082943.20251-1-heming.zhao@suse.com>
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
v5:
fix sparse warning for _ocfs2_free_suballoc_bits(), v4 fix is wrong.

v4:
fix sparse warning:
-  in ocfs2_update_last_group_and_inode(), change
   'old_bg_contig_free_bits' type from 'u16' to '__le16'.
-  in _ocfs2_free_suballoc_bits(), do le16_to_cpu convert
   for assigning 'old_bg_contig_free_bits'.

v3:
1. Fix wrong var length for 'struct ocfs2_group_desc'
   .bg_contig_free_bits, change from '__le32' to '__le16'.
2. change all related code to use '__le16' instead of '__le32'.
   Please note: change ocfs2_find_max_contig_free_bits() input
   parameters and return type to 'u16'.

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
 fs/ocfs2/move_extents.c |   2 +-
 fs/ocfs2/ocfs2_fs.h     |   3 +-
 fs/ocfs2/resize.c       |   8 ++++
 fs/ocfs2/suballoc.c     | 100 ++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/suballoc.h     |   6 ++-
 5 files changed, 108 insertions(+), 11 deletions(-)

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
index 7aebdbf5cc0a..c93689b568fe 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -883,7 +883,8 @@ struct ocfs2_group_desc
 	__le16	bg_free_bits_count;     /* Free bits count */
 	__le16   bg_chain;               /* What chain I am in. */
 /*10*/	__le32   bg_generation;
-	__le32	bg_reserved1;
+	__le16   bg_contig_free_bits;   /* max contig free bits length */
+	__le16   bg_reserved1;
 	__le64   bg_next_group;          /* Next group in my list, in
 					   blocks */
 /*20*/	__le64   bg_parent_dinode;       /* dinode which owns me, in
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d65d43c61857..c4a4016d3866 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -91,6 +91,8 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 	u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
 	u16 cl_cpg = le16_to_cpu(cl->cl_cpg);
 	u16 old_bg_clusters;
+	u16 contig_bits;
+	__le16 old_bg_contig_free_bits;
 
 	trace_ocfs2_update_last_group_and_inode(new_clusters,
 						first_new_cluster);
@@ -122,6 +124,11 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
 
+	contig_bits = ocfs2_find_max_contig_free_bits(group->bg_bitmap,
+					le16_to_cpu(group->bg_bits), 0);
+	old_bg_contig_free_bits = group->bg_contig_free_bits;
+	group->bg_contig_free_bits = cpu_to_le16(contig_bits);
+
 	ocfs2_journal_dirty(handle, group_bh);
 
 	/* update the inode accordingly. */
@@ -160,6 +167,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * num_bits);
+		group->bg_contig_free_bits = old_bg_contig_free_bits;
 	}
 out:
 	if (ret)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..1a7b53fd468d 100644
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
 
+u16 ocfs2_find_max_contig_free_bits(void *bitmap,
+			 u16 total_bits, u16 start)
+{
+	u16 offset, free_bits;
+	u16 contig_bits = 0;
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
+	u16 contig_bits;
 
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
+		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
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
+		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
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
+	u16 contig_bits;
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
+		bg->bg_contig_free_bits = cpu_to_le16(max_contig_bits);
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
+	__le16 old_bg_contig_free_bits = 0;
 
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
@@ -2496,7 +2579,8 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	if (status < 0) {
 		mlog_errno(status);
 		ocfs2_block_group_set_bits(handle, alloc_inode, group, group_bh,
-				start_bit, count);
+				start_bit, count,
+				le16_to_cpu(old_bg_contig_free_bits), 1);
 		goto bail;
 	}
 
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 9c74eace3adc..b481b834857d 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -79,12 +79,16 @@ void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
+u16 ocfs2_find_max_contig_free_bits(void *bitmap,
+			 u16 total_bits, u16 start);
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

