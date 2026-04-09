Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D7A1F30A9
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 06:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775714596; cv=none; b=kpvYRXqRY0IZHtnWj2TalEfW/VZk4Xg3cKPFQmVQaSrs2pO+mBILf0w60ADxbMp/zl8O0KP8RUkecsAIsD7lc8PtrtBp2ZMbhv9YnxV9M9e6NANRDJD38IGd5b5syoqaRq0vx/XXf05+K4zTmCo3VWAXgl+LmIlezDAArRt/UEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775714596; c=relaxed/simple;
	bh=dS4TVawFWrExnqEmCepp3a6SmkFo/dyHQqphFHd35Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NxwKp2moTGeknJp6oskaYoOxvIsoyGrP5H6vON9BvSV1JXvfMqSHewM1KUeGn57VOQYONGBNOfMUytAbiHAhn9w3AFtdgX9iz1KRTjZ8m00U00+/NVENQ3HZfY3+U/gmdSqGAOONDhepNm6AXMnLFfXQrRRMdubg3hCoh2n17HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmQiTtjX; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmQiTtjX"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso226870a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 08 Apr 2026 23:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775714594; x=1776319394; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tSaOv0azjmSiOgE4UMcdS1bwbJhCj8e5gx9KHNU+W2Y=;
        b=lmQiTtjXXuHE2n8mFSPOtDon79hpkEuo+KYA6Q1q6KxSn6X0AhGOBuwyTeRRqZWDr0
         mRIV0tHowv4auQ88FSS5ckxpieiaHB2i5VIEyYna6h7ibQXOQuHTs6pkiMD40j1LKE4Q
         WluAZEdlVMpg3pvULUkj41iYaXkApPcIuzpS2ehsREgutpJFcF/C3MnPXqJqcyjJI6os
         91TqfAfPkUgnlMPG8MhbchAUyKClCekQFV6TaeDXpk1Y+3MnrTyqQ+fznddx4V3PBUZ2
         j8mPyCQKPms/zrX83Pxkfcg8qVP7vdiYbxuFlsHgK+h/KrlMzIpHD0UPN9w2kQEdhKEO
         yzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775714594; x=1776319394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSaOv0azjmSiOgE4UMcdS1bwbJhCj8e5gx9KHNU+W2Y=;
        b=EQtFJ46Rqrz8dpesp/Ntyzpa7EX5ilcYzcPN1EEdTJ6ba8mDdlGAbtPUUJ7WJIhC9G
         wqNKgk1oG5TixEccaBa83VjpGi2dFTAX7+IeorfcIyot+k5YPamOMkCviPZBYoSPgpQR
         2u4tj5f6n9cDH2+Wrti0tX7pMKIWTcdsEJOdJNAdmg6XokZG6qQrIT4qvAT3AM5VDFTA
         bGbPYYbdu4dUgJpbEi/bvjpjckRPZCZz5Z8eIoD3jtV/50l33KK9m5eh8xJhSCANm768
         +oKOWiEJPzvYKg1s3KfV7aZGVc4TSkWekIeB3Y+ZsVHcUN0D0VX0uKwAi4dnD1AJif3Y
         q0Yg==
X-Gm-Message-State: AOJu0Yxhj49vljJIUTV2cm3gfTATlOnZ+cDbW9tZ4p2ZV1KZP5svUl5p
	J9e7OVVqhqirLnMXuJSzqCwPVa5TNtC5f1uLsp2dksXuJ+2TyiM48wvp
X-Gm-Gg: AeBDietwoEGe4OvuOpskWMXh9j4ZdqUhLV7PGvMDuN8kkDvy1eSnE29ESRFAefszrCE
	q3ndVFJuA+6bX1DwFdxWSOjO6M2OzzgnGUV884V2rSB7TcKtwp1ydebUxLxhqTjgw4csmy7ZNWY
	y4JY7gk+ByzKhWZOnwuVZnYuWyK19xMTU+NC89xWsFMWAWVgBtFbdKiqC9NwTG2SvyEQ2riUXAw
	VdkCM6vnci16Rp8yOeUv0UKgFZDSei1zX3qqnlTxw4YzEJIIQq9iQAJPHwRn1ZdZJ72jJAdkBc8
	5JHiv3YUOpQFEbwjgCMKZoYgoZL82HxEfOGftIOATaT+GFkE8NYsPEGGPaYISVVn7uY3j4iNlme
	Q0pUUWvSQxpjlc7icHgmaAgFvRjXaQ4IXX60nLjoPkQDtpis+ykYUOMHm/JpMqM+7oE9HxVBq43
	scZrD0nOI+5ZpwtFK8DKiJnUYAHzkZTpXuS2VOdp7P9CkSLHLeMYTVqcruiSa47QmCT/LS8w==
X-Received: by 2002:a05:6a00:178e:b0:827:455b:86b1 with SMTP id d2e1a72fcca58-82d0db693cemr23797880b3a.28.1775714594051;
        Wed, 08 Apr 2026 23:03:14 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c68273sm27975827b3a.41.2026.04.08.23.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:03:13 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate bg_bits during freefrag scan
Date: Thu,  9 Apr 2026 14:02:41 +0800
Message-ID: <20260409060241.3344855-1-gality369@gmail.com>
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
ocfs2_read_group_descriptor(), which enforces bg_bits <= bg_size * 8.
The non-coherent path uses ocfs2_read_blocks_sync() instead and skips
that validation, so an impossible bg_bits value can drive the bitmap
walk past the end of the block.

[FIX]
Check bg_bits against the actual bitmap capacity before scanning the
group bitmap and fail the ioctl with -EIO if the descriptor is
impossible. This keeps the coherent path unchanged and gives the
non-coherent path the same bound needed to avoid walking beyond the
buffer.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/ioctl.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index b6864602814c..a341a599e440 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -441,7 +441,7 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 	struct buffer_head *bh = NULL;
 	struct ocfs2_group_desc *bg = NULL;
 
-	unsigned int max_bits, num_clusters;
+	unsigned int max_bits, max_bitmap_bits, num_clusters;
 	unsigned int offset = 0, cluster, chunk;
 	unsigned int chunk_free, last_chunksize = 0;
 
@@ -474,11 +474,27 @@ static int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
 		}
 
 		bg = (struct ocfs2_group_desc *)bh->b_data;
+		max_bits = le16_to_cpu(bg->bg_bits);
+		max_bitmap_bits = 8U * le16_to_cpu(bg->bg_size);
+
+		/*
+		 * Non-coherent scans read raw blocks and do not get the
+		 * bg_bits <= bg_size * 8 validation from
+		 * ocfs2_read_group_descriptor().
+		 */
+		if (max_bits > max_bitmap_bits) {
+			mlog(ML_ERROR,
+			     "Group desc #%llu has %u bits but bitmap holds %u\n",
+			     (unsigned long long)blkno,
+			     max_bits,
+			     max_bitmap_bits);
+			status = -EIO;
+			goto bail;
+		}
 
 		if (!le16_to_cpu(bg->bg_free_bits_count))
 			continue;
 
-		max_bits = le16_to_cpu(bg->bg_bits);
 		offset = 0;
 
 		for (chunk = 0; chunk < chunks_in_group; chunk++) {
-- 
2.43.0

