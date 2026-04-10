Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E826A0D5
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775790024; cv=none; b=VVeKMkz5c4Is8pmvl0KGfu5c/maI7stwzfTA7mLvaa9Zly3fXGSuOHP6T30pclYEbpWXxekmdsYg1bR4v3FA7Pj1TKBgEF4x+yqnAdPpEJFVRaMbV7M+nc3zSKjiDfIPgYBf8YkbORs4yFZBe6f1FL6G0HRZ/F/BZZS2ZPmb/58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775790024; c=relaxed/simple;
	bh=m/iPRgB9bezi6PT6s24wAHLazWSQAGQfg//X8mkDWXM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q4iSnAkHU1FKCD40UZ1/bhVh7Ab7ldlRQa9Ww77T+/9V014sQJUQEXDBFnshlFzWfkonfAxQsQEH4/slol+xj+mgtGup3/HzgWsh0P5xODk86INqf9D1JUlzaEXwoxGcdgmHgI25Ez/aYDtLVnGIQzYqkUANA2kq7z/qZlEZ3Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PH930a4n; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PH930a4n"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aae146b604so11421655ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 20:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775790023; x=1776394823; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ogpPCftS9ckT29qofzN7QoXacRnOE+mS3/dqVOtLBEk=;
        b=PH930a4nXAkBaKTaFv/d4LCIUaxTuYIUfCgHCRdbEzWXWuWxu/R1gtDxwBdCVTa9Iq
         /r4osMiesDMUCtpYMbY+ALzzsvlyQScx8gcc51F3W7Acz55R+s4e7kIy/2pd9zWf5afP
         uuVVAIuxp5lJZeFfS1x2UR31Ne81P8oE/DIzHpA8UYqgEgHtw78GeKnmYrVthdqgaXUE
         d9ZJZRM+crgV+Iju3kCKXp65BqnRW0G363ZyYjo1jU3ktx4No4JKUVYMx00iRFD4IFul
         l1tni8GYwzq6fT+qwHyWksImD4F6dphaQq9U6MyA1n+D3HG5oRlvOP62K+X5QQWOC/iX
         MS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775790023; x=1776394823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogpPCftS9ckT29qofzN7QoXacRnOE+mS3/dqVOtLBEk=;
        b=iTb/J3bVX97JM+nCu4VVwFl7kbyK9+aAfqDa/G0HCtzCs4uw7sR2tfw8MHxJkCtNux
         oVfGQnPwdPCYqT/4K/WoHCuBk8XE0EG/+NT+7xOMlhltFQnR5Z8w3LzYEcsW8SVqi+KE
         xgwWZ++jcDhcndY486AmKd4XHFAAXbfbA7j7TKRo2Czy2ieeUlYQr8y3lOljOJHycpva
         a3Jt+wo+vf19nBWyUKi43Jd9fbmRWUdKLfF9OqMZ49e1C8VRLQdgQ7lYv4cT4FRIhLt6
         P7PZ2Gexf5TSHY1JLi/WF+3h0eIlJ1ROK3j1+ZE7uCcr7YMRszuZHvygAMx30sg7xrWn
         jJ3w==
X-Gm-Message-State: AOJu0YwGuOYvJu+mBvFhJG8G2sQd1vrVg4RLIOSosjkGHTdd5iiVBkIy
	dUH1D2wPGP4gc2WxIVQ/7GaKjdjW+UTtEy7bGnVQKsixsl9FkWEd1BV2
X-Gm-Gg: AeBDievPqSew905ivjSRsDjBIvpstY2Q2VjsAOZIx96kW1fqlszLTQmr4HjUw1fBy3+
	sThfMIYc0xOJgB1FBAvM1Q4HycmnzIKgdduqHOuoQukXZoBix84kmwaPp1q/Dx5hOyBrc/sW+Zc
	oRfbae2J4VxXObJBA7C/5zgAw4raPsS+Ti2Po5kCbh3q1PRTlGsSQK1gjRr8dCPIhPZCxyt1/Gl
	2eAEVCwAtpYt3CadFIcqgMqrAvO65Tdhl9fqxFaSjeSQFTdL33B3puJjvuvT7COFVCd9/KqvbJq
	9g7/mfkcYPdH9ywR3hcMCg94IAw35T4WdIt59VK8jHo6VnJCHtpJgWvNMRXVK/Cw++ht7dx+OWm
	SI/T3VymwOhMCXP8Bx2tzbK76gs8ApzOjtWs1bjZJ+Dv0nog5Pnis6wKiqvznRgUUkreG2HuU+D
	7VnbKena2Sp/VyknBgWnWZ9DLJlUhU7jlDAAeqmwgcDMy4uMO4Fr2z20wC96T5Nv9cCadiBA==
X-Received: by 2002:a17:903:b83:b0:2b0:c106:a402 with SMTP id d9443c01a7336-2b2d5944c5bmr16182835ad.3.1775790022471;
        Thu, 09 Apr 2026 20:00:22 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd83d5sm10249585ad.25.2026.04.09.20.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 20:00:21 -0700 (PDT)
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
Subject: [PATCH v4] ocfs2: validate bg_bits during freefrag scan
Date: Fri, 10 Apr 2026 11:00:04 +0800
Message-ID: <20260410030004.3810769-1-gality369@gmail.com>
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
 fs/ocfs2/ioctl.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b6864602814c..82d8e69dd575 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -441,7 +441,7 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
@@ -474,11 +474,26 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 		}
 
 		bg = (struct ocfs2_group_desc *)bh->b_data;
-
 		if (!le16_to_cpu(bg->bg_free_bits_count))
 			continue;
 
 		max_bits = le16_to_cpu(bg->bg_bits);
+		max_bitmap_bits = 8 *
+			ocfs2_group_bitmap_size(osb->sb, 0,
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
+			     (unsigned long long)blkno, max_bits, max_bitmap_bits);
+			max_bits = max_bitmap_bits;
+		}
+
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
-- 
2.43.0

