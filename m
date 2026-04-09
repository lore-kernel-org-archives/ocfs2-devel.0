Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE71D33F591
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 07:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775718419; cv=none; b=e+e9ePR65K3s7bJjicfOilsfxg7DTvI669E4iAy/BS02HPGBhWC9wcb/5SjXOa9KFEnAjt3HI4QHW7tM/+nh/CO29y/AWq8WbtPLO16aE6XrlpfHKAOOQnkgScK6zgAE4VIsM6NlCPg+YDJm17o5RFsfwbJ76vJAtHOKRDpWfjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775718419; c=relaxed/simple;
	bh=HqDHRNm9BlO10tBUdSahIpJVMdUXQ+Kkwot9S1XzJoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oFhuWZ+IezmJmDCa3fxp5RZ3sLFbkKxXSkgJe4oaQm5ceg9mTuBXg/eLsSx4e1yl7FQp5EJ1JrfyZJUZUD9kjRu75hyaG3lcy0/ml6WBWeka3EEhrsnVZNi/RjRDRrMKhvjLQ+WRPBKxK5/CLxcxq+q/MISQ5A5IhjCww6m9j+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHKWb3CQ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHKWb3CQ"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b2503753efso5097785ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 00:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775718417; x=1776323217; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AbcoiDxqvm3yVuuY+3FJXoEqdX3dggqK0L2trSGSZKo=;
        b=IHKWb3CQfob6YZGNHcNDQPF0+wadRDM1LqHfZiKD/d/Wh4LIFj979rQV3eOVj6f2sX
         6431qRB6Hnhgv9FlNtyU/LQGSbjmblWp9T0SMZecOGnqs7VZKGg/vuXfUkNc4PYaCJpC
         WOzrdxXUlI7Q/qbgCipHlwji16cxRJR6lc+g0wV3bmH3T9/6nOk6Gb0Txmp1Dk1Vfknb
         lR5WwdqaIgMLDp2OrSm63DG+Gx/mg6dD2zy3b2xQQaGoK7CkdXNmXdsKwd4WTQ7FkZpf
         sG+ieFmTdf+rNKllu9CZtrCaAxyEElFkVtdv75z7ZqyJNfFuwwhqWYgbgJC3d/1WZQDJ
         kbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775718417; x=1776323217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AbcoiDxqvm3yVuuY+3FJXoEqdX3dggqK0L2trSGSZKo=;
        b=MG5xwdvL+LRBu/iULt5+o+SSTn5WvsggzQrL4U40xeM9sHSiYiI1bhcNUx2+CJ3uVC
         atycRXfr9im6G0ckBw1B//sYp/4v8B+SXkjSQILu4AN4osBSqnmDNwxUJc6wjBZxv1US
         dhwdTpC/6OWjxdhyg3v4bnyLzPm95p7jZuHPnZ0fcSezGeCuIy0XWo2KVbYce0QITrTp
         HIT3wxog/0Rd6GAB0kGaXlTO04AOzKamnhtLm/g1wevVWPD5IQXgp0QEYp+F0HIneIYY
         pirT3z03UUHHNG1VenEiYHhEnVTMm1OO1Jr8akdZnz88rMZymqScAlWUXf4ZIk8WOir1
         JlaA==
X-Gm-Message-State: AOJu0YxU67sKNURhTPnmCmoDtidefJyfSvzy/02qF4ZrmtP4Y1wDZFYS
	oGfP5Ncjv8yWMGDqaWUo03LqaBeKd0c9j7GfQcy2sM6yo4ZriO/c+KCS
X-Gm-Gg: AeBDieuMHxdXU04kimdYYulEVZypfeOnfH2i4iqof+Z/5o9acQmvZuhncWnFQLKhzsO
	5lup97aWWlhJgjC+WlJUOpOAlVPgU1/HH1vaIUi6dECwG+Mw60Wl49e4B1QVXL+aMWcuhoh4SM7
	1QE3lQ5zdVzgVDsCLuqCCYlq++8RsrobCusEDmTqYy7YIX+0OyEBUPK2/k8Rob/0HVBWFAXhVo4
	DdQGOV6N+4bVkSd96xBXcNH8N0LVrDJRhRnaL3gDvQmwJNbq3jTjyDgL7p8JCvrTnBBTiq/6lu/
	VNLpw0A7c19w35LkKnX5GtDm8AGLegOOu39k/r/QjtEE+jzfwTjfZnYtb+UNF2QvNO3kL7q6Mih
	NAP6pgaXT+Wpd2XiYMb10mlQcHV/gD2ctJ2UPwsyKZZHdvlOJiAG1A2KNAy1QrlGwzRQsMTCR5s
	N+dMEcmkUneuD0m9xLMeB0Qm1z+01WzRrIcCZCfdFfMjNy5yB1ykrWI6kQIf4cDgu6k8P3f89kL
	50rHdrU
X-Received: by 2002:a17:903:3205:b0:2b2:4eec:9806 with SMTP id d9443c01a7336-2b28182ca4cmr282342715ad.8.1775718417185;
        Thu, 09 Apr 2026 00:06:57 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d55fsm297666265ad.11.2026.04.09.00.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 00:06:56 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate bg_bits during freefrag scan
Date: Thu,  9 Apr 2026 15:06:24 +0800
Message-ID: <20260409070624.3357378-1-gality369@gmail.com>
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

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Use ocfs2_group_bitmap_size() instead of the on-disk bg_size field
- Clamp bg_bits to the computed bitmap capacity and continue scanning
---
 fs/ocfs2/ioctl.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b6864602814c..fa0ca014c6d5 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -441,7 +441,7 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
@@ -474,11 +474,28 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 		}
 
 		bg = (struct ocfs2_group_desc *)bh->b_data;
+		max_bits = le16_to_cpu(bg->bg_bits);
+		max_bitmap_bits = 8U *
+			ocfs2_group_bitmap_size(osb->sb, 1,
+						osb->s_feature_incompat);
+
+		/*
+		 * Non-coherent scans read raw blocks and do not get the
+		 * bg_bits validation from
+		 * ocfs2_read_group_descriptor().
+		 */
+		if (max_bits > max_bitmap_bits) {
+			mlog(ML_ERROR,
+			     "Group desc #%llu has %u bits, max bitmap bits %u\n",
+			     (unsigned long long)blkno,
+			     max_bits,
+			     max_bitmap_bits);
+			max_bits = max_bitmap_bits;
+		}
 
 		if (!le16_to_cpu(bg->bg_free_bits_count))
 			continue;
 
-		max_bits = le16_to_cpu(bg->bg_bits);
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
-- 
2.43.0

