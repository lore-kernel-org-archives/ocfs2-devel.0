Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8661C2324
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Apr 2025 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125806; cv=none; b=lZ/5+KWOpijjFvHnfP1iq4xZHRAB8kB5aehYtrrDXCmTpyhKTCOFZAvP5fdJ5qThih063oTlgqQp24rXMLgTDWIV6fxl2R2GIgX0xEfmg6D3pYhcjL/rhmL+lM1KlTmooSSMSkX7MTtRMiZi/NOwFTelxUx8vvOTqyUMJFMwr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125806; c=relaxed/simple;
	bh=c3ebzZgArsGyzgatMkw6+bT9Yrl9e+gUFSCdjTuBYNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ/SHAF/vARo4CgNdvsr9xbaDWBvUSvcOG9jtQizEAhSNRJI3dqHe5B1z1/ebRBNUoVUT1p/D+JRqLtPMzQzlbCXRKS0By5AmMCuvHeMMMcvxfbyfH2F2GpwCxrhGcFO3KeyYmX0w4AGVKubHo5jpSx7TbcSxnqi3dciGvZExxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d2qEZsOe; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d2qEZsOe"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3913290f754so629527f8f.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 08 Apr 2025 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744125802; x=1744730602; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zwEfz0M9syRgyVjL+64xAeyGIPn5+uO3NdMeHbCP0Y=;
        b=d2qEZsOeAxXpPLH2M1/iwI//8wUzWWk7P2VbTDaVs8HjsoTJikZKGBLdg7nPNyiT+W
         HsXSs1x7OhOp2slZoqgRcnbDTj/ja0Y18+8jp4JpByQrkxm+2R0CNYF0ZUoMlwznQNeg
         qZTUYWbhWM2Rl2pL/z3EK3W8nVCoE9y8KRSFw81eAc9L4n59LEJKebfSn38EWlWcyqIq
         TFJe4zHxqSXabTG8GgBzClNwBupwG6yzgb4k2vawlgqwYOux2Xd99x1Rp0GDVGgMR0P4
         MFG+fiP9rtZSWZhDs/CTVEz4/1ZQJLzSe75ajnel8LdvDkUCdLiGHk/SezrV1iWIgOBs
         WWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744125802; x=1744730602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zwEfz0M9syRgyVjL+64xAeyGIPn5+uO3NdMeHbCP0Y=;
        b=RRSCxPVr2fm69cLEBr0U+coWkN7vThXebADMGVh3ADLsjk7TY2N2Yuxteh2dRZpJpt
         1iTvAAk0FJvLwyV2UzqZfb6rKL8iMTP/nkUpYtWlLZ8udlA0qMtSUlnVHcMPrwG9TZsZ
         spgomTRiN0Z+h1j9iEXBdYkjn3rX2TVFIEKjgNL29iH6pFyEoRZ5J0nu2tkZyI1O/STs
         taYA3K9GXefoEhBtVeslkLYpaBmaSuxrhenc1ort3civOz3kN/qAdrapL1RzXDsVuO34
         q6a+0gjKW5Dkx2jcHVz/8pfA20D5nfWrf4LW7AfRrfe8Mczi+M0lEJ/O+yBaQGfXwkEI
         45mA==
X-Forwarded-Encrypted: i=1; AJvYcCUO4BCgdScrfh3HxdwT1w/fKL4o1l/AsxBTjJ6krFa6ZicPEwdD/ANGN6gPJQXVptOicc4gNrD6g9RSsA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxF4cPW1oWdPzSjZlxkB7YiSk2FeLQvySkCibwOcclHcWu7DmBv
	wX3BQR+H6f/mt11qD+lkayQGMNtXc1smcV+1kb0xuumIsK1VmBJWI+Q20BfFg04=
X-Gm-Gg: ASbGnctw7ZKG/m5J1eWNEk8FrqV/ihfx0gpe4yMbBymGwFLWyha6GbOhANGiid+W+wZ
	CoKXYmFJGhW1TNNLwnDkUThU+k2RegJfZanCNkeB6EznEc/s9x8IArzYSK/Pvfz8fa7lMc28N86
	hCUuiTv43/4Y+MnAnPwclWmBMmWZ0/7PLqaSe7NhLuGraHszGLgIC5n8jCf2tE5S3FgpHj4tFpq
	o+yyPD0KS3v+Ul6aCGqxR9VtqQSkZ/i+OsZsR3hXAdPaBkDgr3y13VPeBax+XJe60DxcgPP2WMT
	H9ivtc7+vO+2OT8v0nYTG3O6+AndWrYGBNPbaU4bkZ1g3w==
X-Google-Smtp-Source: AGHT+IGanaXzQIEy7PI/vaTXp0uLeqwyePzm3pTltYqzf5ygB+AndYs3nwO/6+6WbzKBl+mxL7TxmQ==
X-Received: by 2002:a05:6000:2511:b0:391:320d:95de with SMTP id ffacd0b85a97d-39cb359e2b0mr5971636f8f.4.1744125802568;
        Tue, 08 Apr 2025 08:23:22 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d9e9dc9dsm10990155b3a.96.2025.04.08.08.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:23:21 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gautham.ananthakrishna@oracle.com
Subject: [PATCH 1/1] ocfs2: fix the issue with discontiguous allocation in the global_bitmap
Date: Tue,  8 Apr 2025 23:23:05 +0800
Message-ID: <20250408152311.16196-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408152311.16196-1-heming.zhao@suse.com>
References: <20250408152311.16196-1-heming.zhao@suse.com>
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
	    (around 47GB), no chain had the required contiguous
            bits_wanted. Consequently, the allocation failed.

How to fix:
When OCFS2 is encountering fragmented allocation, the file system should
stop attempting bits_wanted contiguous allocation and instead provide the
largest available contiguous free bits from the cluster groups.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
---
 fs/ocfs2/suballoc.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index fde75f2af37a..2e1689fc6cf7 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1796,6 +1796,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 {
 	int status;
 	u16 chain;
+	u32 contig_bits;
 	u64 next_group;
 	struct inode *alloc_inode = ac->ac_inode;
 	struct buffer_head *group_bh = NULL;
@@ -1821,10 +1822,23 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
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
+			if (bits_wanted > contig_bits)
+				bits_wanted = contig_bits;
+			if (bits_wanted < min_bits)
+				bits_wanted = min_bits;
+		}
+
+		status = ac->ac_group_search(alloc_inode, group_bh,
+				bits_wanted, min_bits,
+				ac->ac_max_block, res);
+		if (status != -ENOSPC)
+			break;
 		if (!bg->bg_next_group)
 			break;
 
@@ -1984,6 +1998,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
 
+search:
 	status = ocfs2_search_chain(ac, handle, bits_wanted, min_bits,
 				    res, &bits_left);
 	if (!status) {
@@ -2024,6 +2039,16 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
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
@@ -2432,9 +2457,6 @@ int ocfs2_claim_clusters(handle_t *handle,
 {
 	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 
-	if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
-		bits_wanted = min_clusters;
-
 	return __ocfs2_claim_clusters(handle, ac, min_clusters,
 				      bits_wanted, cluster_start, num_clusters);
 }
-- 
2.43.0

