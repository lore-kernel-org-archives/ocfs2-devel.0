Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104B41BEF7D
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Apr 2025 06:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744610499; cv=none; b=ELa8vmIjq6+FkBDq1uZpUSCd+UBsIXhzw/VGao0GHO11FW5rn8HcYcGfEocm3TEkp0RcAyF/pToiLpJrYZGYrPlsuE37WW+CUX9/kv4Ei/Hdvsvr2IDKSdbcZLkKWTSmKrX/BLxDwC2JLBU27/mWEVLc40BHbUrZ/yJAfOIjNgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744610499; c=relaxed/simple;
	bh=AyHlGK3bnet9Kd4HcPtbDVU5JRbcUoHT5hbOQe5YL5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBvu+W/JsC4nWfi9wquMSDgRfKujRlAPFdl1S8T8aVkaHEnbI1fmvYK9qiniNcDZPYKPT8m6YeYuEmGz+oIE+xE/hYm96XaTvQLkAy4xrI+CitZoPYoIlLiLyv95Zpi5OazH6fx8Locbdv+y57us6GtK5p/zvzCRNrKt5iM2XM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dy/7KfA4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dy/7KfA4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43f106a3591so3423425e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 13 Apr 2025 23:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744610495; x=1745215295; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHkzL6ByD68BHwyJwz9RIFlyTlbarM9Ao6uMqg627CI=;
        b=Dy/7KfA4uQTT5+MSCS2TwL2RsqFmQ/iZl9pM+ehZF5T2+KwN4+/C6sbUG3ushvhs1E
         9eNWN4jRc4eurWdOf2LGiG9p44d/odc4/wirjHPrmmJPQmdOQlBiFSQ8xVI6Wp5ExgCB
         bfF4dHOhPVW5ucXvnI2Ev97V8qnm0PH8HVWEXwzkqMae3mVInJoA4bsD1d3sbEapvEk4
         YWVxc6kpFrnMyXOeTX6efvawunZeqDAP3Uznc/iKN4IdpElD18aSRvIr4SlV9IeOxBVY
         Epl2DPBEaS4jO6586gn0H2Qo7OP0kMjr5ce+BcEFCNvxTLAz/V7KTiGbCTmXMPcqW8W9
         R9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744610495; x=1745215295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHkzL6ByD68BHwyJwz9RIFlyTlbarM9Ao6uMqg627CI=;
        b=GXwSSAH139VcERMWxTWouvAH3tVZsLHU5oW6W9nDH9mBc121qW1B91yroOxicc24Ul
         dKGNDvbf95LTIYoln1UH/IauWfC7fmuYTo1yimQxn4WGOnjb+rs3FNpG8xE7LhYYWQ/I
         dkyPUtGm4fX59HDKxDbXVd0hO+grmpgb+Szc1TzO3RYK6rqkDEm1Xckc4Q+fuEa6raOG
         yVfXAyA6W7sIsyVGnfQnPQ0hqBCiolb0QkRq5wI8q8alaT8t7AmW8KPfbTm1LwFREOfv
         jbvt1/m4IWWSYjxZEPjvjTc7O3dvytxbcSmBxs8tZ66gVArLU5QP6VRhZ8OZkB8GdOjI
         Sgcw==
X-Forwarded-Encrypted: i=1; AJvYcCUvUvHSLj7FSS0LZS38eeETA5KbU6N9ApQYPf++coN6PqUqunwnn2tlqV4AqcmyC9Ls4bNCHQpe8d6BSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2yTy4nkjrGwwtM3e++JH1q9iRSCbQzZrtfJwNbn4IHy8Dd7/7
	tjDQgE/OlSVfQORdULY4YhtGGetEcK2Taq+YskV7X01SBWU51LyiYp0gH7oTH4c=
X-Gm-Gg: ASbGncsxx1hNJcJ+f2OqF4YIAXhnqwPcAcL7IjstqazmSv8kCpDPCiVP3Lmapd5Lj6S
	kTYPQ7JLfsyNc61UnxGxClHnvZ28piQt79vtz5KlfuykbzaG5+p2JgvVkVgDUhWyHJTGmglE+4i
	rT8Tq+mCcyfKI/AONUkMxpebxJTm2wmyjR6ZL0AkwMhqLBAnSG5/yciBs9fXeQS2c8yLptW0xSM
	PCs2Y5WWXi66KoEaVcLWA+b9USBZ9vMcQd75Fgt8asL9NuN+cEEJjNcedc5iL+UOjopNuAAsPLB
	j2lBEhj+2W5jc5GASkimhzk22V3tu1w1L7+7dcI0oqp2W3u5Tc48NOQSInhntJ5EMQ==
X-Google-Smtp-Source: AGHT+IHqkL/jB7bJHRSxi3RdPmce7drmHBQpR0tbDBwXoDyNFuZl8wZqXe1lybTZoPmqpmuBMCyqrw==
X-Received: by 2002:a5d:5f4e:0:b0:39c:13fa:3e0 with SMTP id ffacd0b85a97d-39ea5313da5mr2871230f8f.9.1744610495199;
        Sun, 13 Apr 2025 23:01:35 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b8c3c1sm92029555ad.60.2025.04.13.23.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Apr 2025 23:01:34 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH v2 1/1] ocfs2: fix the issue with discontiguous allocation in the global_bitmap
Date: Mon, 14 Apr 2025 14:01:23 +0800
Message-ID: <20250414060125.19938-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250414060125.19938-1-heming.zhao@suse.com>
References: <20250414060125.19938-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
fragmentation is high") introduced another regression.

The following ocfs2-test case can trigger this issue:
> discontig_runner.sh => activate_discontig_bg.sh => resv_unwritten:
> ${RESV_UNWRITTEN_BIN} -f ${WORK_PLACE}/large_testfile -s 0 -l \
> $((${FILE_MAJOR_SIZE_M}*1024*1024))

In my env, test disk size (by "fdisk -l <dev>"):
> 53687091200 bytes, 104857600 sectors.

Above command is:
> /usr/local/ocfs2-test/bin/resv_unwritten -f \
> /mnt/ocfs2/ocfs2-activate-discontig-bg-dir/large_testfile -s 0 -l \
> 53187969024

Error log:
> [*] Reserve 50724M space for a LARGE file, reserve 200M space for future test.
> ioctl error 28: "No space left on device"
> resv allocation failed Unknown error -1
> reserve unwritten region from 0 to 53187969024.

Call flow:
__ocfs2_change_file_space //by ioctl OCFS2_IOC_RESVSP64
 ocfs2_allocate_unwritten_extents //start:0 len:53187969024
  while()
   + ocfs2_get_clusters //cpos:0, alloc_size:1623168 (cluster number)
   + ocfs2_extend_allocation
     + ocfs2_lock_allocators
     |  + choose OCFS2_AC_USE_MAIN & ocfs2_cluster_group_search
     |
     + ocfs2_add_inode_data
        ocfs2_add_clusters_in_btree
         __ocfs2_claim_clusters
          ocfs2_claim_suballoc_bits
          + During the allocation of the final part of the large file
	    (after ~47GB), no chain had the required contiguous
            bits_wanted. Consequently, the allocation failed.

How to fix:
When OCFS2 is encountering fragmented allocation, the file system should
stop attempting bits_wanted contiguous allocation and instead provide the
largest available contiguous free bits from the cluster groups.

Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
---
 fs/ocfs2/suballoc.c | 38 ++++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h |  1 +
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..6ac4dcd54588 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 
 	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
 					       ac, cl);
-	if (PTR_ERR(bg_bh) == -ENOSPC)
+	if (PTR_ERR(bg_bh) == -ENOSPC) {
+		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
 		bg_bh = ocfs2_block_group_alloc_discontig(handle,
 							  alloc_inode,
 							  ac, cl);
+	}
 	if (IS_ERR(bg_bh)) {
 		status = PTR_ERR(bg_bh);
 		bg_bh = NULL;
@@ -1794,6 +1796,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 {
 	int status;
 	u16 chain;
+	u32 contig_bits;
 	u64 next_group;
 	struct inode *alloc_inode = ac->ac_inode;
 	struct buffer_head *group_bh = NULL;
@@ -1819,10 +1822,21 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 	status = -ENOSPC;
 	/* for now, the chain search is a bit simplistic. We just use
 	 * the 1st group with any empty bits. */
-	while ((status = ac->ac_group_search(alloc_inode, group_bh,
-					     bits_wanted, min_bits,
-					     ac->ac_max_block,
-					     res)) == -ENOSPC) {
+	while (1) {
+		if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG) {
+			contig_bits = le16_to_cpu(bg->bg_contig_free_bits);
+			if (!contig_bits)
+				contig_bits = ocfs2_find_max_contig_free_bits(bg->bg_bitmap,
+						le16_to_cpu(bg->bg_bits), 0);
+			if (bits_wanted > contig_bits && contig_bits >= min_bits)
+				bits_wanted = contig_bits;
+		}
+
+		status = ac->ac_group_search(alloc_inode, group_bh,
+				bits_wanted, min_bits,
+				ac->ac_max_block, res);
+		if (status != -ENOSPC)
+			break;
 		if (!bg->bg_next_group)
 			break;
 
@@ -1982,6 +1996,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
 
+search:
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
 	if (!status) {
@@ -2022,6 +2037,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 		}
 	}
 
+	/* Chains can't supply the bits_wanted contiguous space.
+	 * We should switch to using every single bit when allocating
+	 * from the global bitmap. */
+	if (i == le16_to_cpu(cl->cl_next_free_rec) &&
+	    status == -ENOSPC && ac->ac_which == OCFS2_AC_USE_MAIN) {
+		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
+		ac->ac_chain = victim;
+		goto search;
+	}
+
 set_hint:
 	if (status != -ENOSPC) {
 		/* If the next search of this group is not likely to
@@ -2365,7 +2390,8 @@ int __ocfs2_claim_clusters(handle_t *handle,
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
-	       && ac->ac_which != OCFS2_AC_USE_MAIN);
+	       && ac->ac_which != OCFS2_AC_USE_MAIN
+	       && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
 
 	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
 		WARN_ON(min_clusters > 1);
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index b481b834857d..bcf2ed4a8631 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
 #define OCFS2_AC_USE_MAIN  2
 #define OCFS2_AC_USE_INODE 3
 #define OCFS2_AC_USE_META  4
+#define OCFS2_AC_USE_MAIN_DISCONTIG  5
 	u32    ac_which;
 
 	/* these are used by the chain search */
-- 
2.43.0

