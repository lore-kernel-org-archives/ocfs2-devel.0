Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1BD282F22
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775792559; cv=none; b=n8J251qqwQGUnU7x0ncGPon1lpFHnj1L2l8HjcMgGQEim9RZx73MZmErTo2X/l5+sMqEXUYhnSxRNfOHEKSRd6C008F3FzB/8cFYfb4/qoJ5ViEQA6YETxcjiAhs5Dh6RTFsorrpoyEb+8T1x0k0E7t1cEl2QCtijSNPRlP/FMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775792559; c=relaxed/simple;
	bh=vOmolxgnRPkdtUJhQdO+bE/862+kcsqBFsf4bD/Oqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JEmnU4QrJ6ThNxm/yoMB3y66v+7ODW/vxQGJ8YLCqZxzeqLGr5pvfwAeLiLHen9b8MFoSVdfJ32DoAQbwtcq5KlH3mKquA10BaayzPssqafaQkwZizk05rUAelQLFf1SqMCBUrJ/anxziS3MBQUzkw+VoR7y0xKVv/d9oezydUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQQe+xvz; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQQe+xvz"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82ce09b61beso776003b3a.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 20:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775792557; x=1776397357; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nmono6Lc90LMGK6WwMTdfcyRYLVposTEQlZ1VkUaDkE=;
        b=YQQe+xvz3t0SnV9+ww+w9XOcfszLDqgdhWsZKegU+rP0nT1H+IUrpKvwZuiZlINNsO
         gBCf9AHWEobBptE9YOhDQtKRJE1rQuC2EIBZHj1Q72fFcyA8G+UIDDWLR/wVybWaZ68+
         BY4Eeb1mFUJr5mgevvtPwZ6jrQo3iIBdk5gnD3Wmv7nT4nKMpz+0LiH1VqIvEdukkYch
         p2SoyU3VaOuWZEcjn7Ypo+SrdZlKi52FlZ2OFmez+eR4mqGCKgu7r39w9aaBsbMJndoI
         WDE+BEQEgPaKxXs6XXAE19i8spZATJNerHMD2d3o1MmzyNb0DdaNq4vb9KjloNl+wV/f
         3d5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775792557; x=1776397357;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nmono6Lc90LMGK6WwMTdfcyRYLVposTEQlZ1VkUaDkE=;
        b=Q7w3mzWdt8Z28isImHA3z2MH+LBlWPeTIgb7mjPWW1tuZl+TVt8u0eP9RqTri44m2l
         DDhWmPZaMC6wufmZ+NJ+IfytA/DecuksLarUH3jATFxOYzqWm3LbSt62WrGfxgXTmVeW
         VFh/5j15gFkQKeaY5I1usgqLgHwOau4KweMiT+2Mk9rK6pLJpFV4b0RAy86/UAu+RxPF
         IBAs2Ti99QToZBgB65Q7/Js+ew/y2BUb/UFs3Dkmh4spTXPgfRexGxcNx+hmFE5OF6tf
         jUL8VukW87k1/5O+yAEJZC/bxSmGnPxK6P/v4Q2K99Wdgs6X5dPYyvWAbV4iHso18R7E
         YV/A==
X-Gm-Message-State: AOJu0YzE/msgGCOwILjY2U4Bva4iQLcLkEjoemiXVBdSb6yDYHu3zlD7
	8hPzI6hhjdzCMFI0RfAyaDuCHTt8mBnKujEpsnFmd2Vb+qRQ43Ac1KdR
X-Gm-Gg: AeBDieu+i6DsYf0Jw79Gzp9oTa8hB/antnXVEdxktI5szUFsyr6rgTw0Ewg58MbZVLC
	RLknM2eTJtx6T+Gbf+6W5Wvwh8NX/zu0IU3R/xsm5axec1B+H0zUSQ9DLsfPHiNq2xYT75j+N28
	t1aqbNQltmt6NO5FAjw1xQeMNLNDrgRm1Xs3VgoAIXMjhRifEBRr/LM9PLn5Qik6K/Xb8dlvsCx
	Zkec3BdqMcq8ZDXb458L3FZdMXp4m34wF22izSmo75GeFcUYkp/39Dj1L+T7+IfXw65u3Zbxwx8
	nmInuvHhAk1py+e0SGcR4WTxy3OsROALypmUgknQ+YeTohNGKiRXp7N3q4Mv9QBxxS967S52GrG
	uOvR8IAFRUTazetLWcL2kwZOCKIznzqZ7w9y3fp9RiFWK5d2ADas7r7efJB4ZCIzIRqaL/KsoLA
	278QxzIE3wncuncIzo2zCutvYgnpS18McnlqCiyWE6GZz+fWQ6rUy9Pha8e/4sYyCFDrWgww==
X-Received: by 2002:a05:6a00:4b43:b0:820:2f9b:fe31 with SMTP id d2e1a72fcca58-82f0c221ac1mr2007721b3a.30.1775792557394;
        Thu, 09 Apr 2026 20:42:37 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c32e744sm1156784b3a.13.2026.04.09.20.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 20:42:36 -0700 (PDT)
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
Subject: [PATCH v5] ocfs2: validate bg_bits during freefrag scan
Date: Fri, 10 Apr 2026 11:42:20 +0800
Message-ID: <20260410034220.3825769-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted filesystem can trigger an out-of-bounds bitmap walk when
OCFS2_IOC_INFO is issued with OCFS2_INFO_FL_NON_COHERENT.

BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: use-after-free in test_bit_le include/asm-generic/bitops/le.h:21 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
BUG: KASAN: use-after-free in ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
BUG: KASAN: use-after-free in ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
Read of size 8 at addr ffff888031bce000 by task syz.0.636/1435
Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
 __kasan_check_read+0x11/0x20 mm/kasan/shadow.c:31
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 test_bit_le include/asm-generic/bitops/le.h:21 [inline]
 ocfs2_info_freefrag_scan_chain fs/ocfs2/ioctl.c:495 [inline]
 ocfs2_info_freefrag_scan_bitmap fs/ocfs2/ioctl.c:588 [inline]
 ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c:662 [inline]
 ocfs2_info_handle_request+0x1c66/0x3370 fs/ocfs2/ioctl.c:754
 ocfs2_info_handle+0x18d/0x2a0 fs/ocfs2/ioctl.c:828
 ocfs2_ioctl+0x632/0x6e0 fs/ocfs2/ioctl.c:913
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

[CAUSE]
ocfs2_info_freefrag_scan_chain() uses on-disk bg_bits directly as the
bitmap scan limit. The coherent path reads group descriptors through
ocfs2_read_group_descriptor(), which validates the descriptor before
use. The non-coherent path uses ocfs2_read_blocks_sync() instead and
skips that validation, so an impossible bg_bits value can drive the
bitmap walk past the end of the block.

[FIX]
Compute the bitmap capacity from the filesystem format with
ocfs2_group_bitmap_size(), report descriptors whose bg_bits exceeds
that limit, and clamp the scan to the computed capacity. This keeps the
freefrag report going while avoiding reads beyond the buffer.

Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v5:
- move max_bitmap_bits computation out of the group loop
- restore the untouched blank line after assigning bg

v4:
- add the freefrag introduction commit as a Fixes tag
- use cluster allocator bitmap sizing with ocfs2_group_bitmap_size(..., 0, ...)
- drop the unnecessary 8U suffix and tighten the mlog() formatting

v3:
- restore the empty-group fast path before computing bitmap limits
- move the bg_bits clamp below bg_free_bits_count to skip extra work
  for empty groups

v2:
- use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
- clamp bg_bits to the computed bitmap capacity and continue scanning
---
 fs/ocfs2/ioctl.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b6864602814c..10f573a8b6b6 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -441,13 +441,16 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
 	if (!le32_to_cpu(rec->c_free))
 		goto bail;
 
+	max_bitmap_bits = 8 * ocfs2_group_bitmap_size(osb->sb, 0,
+					      osb->s_feature_incompat);
+
 	do {
 		if (!bg)
 			blkno = le64_to_cpu(rec->c_blkno);
@@ -479,6 +482,19 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 			continue;
 
 		max_bits = le16_to_cpu(bg->bg_bits);
+
+		/*
+		 * Non-coherent scans read raw blocks and do not get the
+		 * bg_bits validation from
+		 * ocfs2_read_group_descriptor().
+		 */
+		if (max_bits > max_bitmap_bits) {
+			mlog(ML_ERROR,
+			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
+			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
+			max_bits = max_bitmap_bits;
+		}
+
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
-- 
2.43.0

