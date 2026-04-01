Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E855D3148BF
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 02:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775009803; cv=none; b=XRcfkk4ufHoZGtm7UfX+8ZOVSED3VbLLY4FRC1+e2TxIXdx9TYQakBXcIyP/sNapNo2UDgFGXvfWf0I6a0vkr/RDs0F1YLhNAADmkVX/SXyRbcOgXghRuOWpR5xI/EP9i6t8L9GV/NmaqN0o7dMGJ9gLPRyeqpb2emrBmBCU6c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775009803; c=relaxed/simple;
	bh=N8kMqBOJX93r+Vs28NGISdGP2MWTao8jJDmtRqhpOuY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gHS7oVxl7ZRPcQkbape9fu+oxTv+WqW071gFiN+LkpwY0N+GDb0SSqrytU3xiiRqVnYbhhTq2yJ4AZS6FNmksFhgUhrln67MonHY9jvyPjw4gXqqn8H5PWYaWCq1XWC9GjLnzMxTrMFyRTmmOGO6zGrksUcN7puKpbW8caxqVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8nM/n9q; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8nM/n9q"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b2589c26e3so22116255ad.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 19:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775009801; x=1775614601; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pkBv6FP2deV5lgxpjjtrzHLtwb/A6rKJwAEu5tfKaVs=;
        b=h8nM/n9qZrguTb05eWH0bX9h0+b0O8M2oLDvIwJkqPP9wj/R1SqKlFvFYKfZ/Ldlqd
         QyLssxTCxbVIaTnXogQitjoDYFMFh1oGi3KcubgepnyozVLEEINoOjzCqeI4p1j/MxcZ
         JtRqJXx8zN2XXFnBSmtdgy7e/BAapApU1gRkKDexQCF3eb3qUultOwOxdCnAUCCnXUYZ
         VzVcQpZt/9SRWm8GdgKEqiU/DQv7cm/9bRX1JAByphJR7axg+Mo9SlTfNH/TIGRBgC/e
         j3Ji0fz/Si1JydGTd0mipfQMNJ7z5Mj0XumPqV4JONtBFSY5Iq+/H6Gov1cHpYjA92Nj
         E2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775009801; x=1775614601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkBv6FP2deV5lgxpjjtrzHLtwb/A6rKJwAEu5tfKaVs=;
        b=govl3XJnn56ICkYWgnH8N9Eb1q4jJCtYzHR90EnzZsAW1HJsHcGxyB060/s6qJVKRT
         dHO0KzCFUQEV4B4ukCdY2cJUfldgkj6uFhuZI6ZehobJF83kM4bBt2G2/1Ox/DU6esTk
         FKlbFUBqmpglGlLLNzw7YZOnfB7D4314jgLg0OVJA7/sgB33D4CMoMJfNWe6Qvt7BIVR
         hiqw8pKX1ZeEf7ekdGTWo9+whyQY6WIeKS7tP1YyAujm06th59pDnofmQNepSIWjGUQg
         MgIhRuu+zu/KkjtiLQGhDysR5OR5BWkfrcdNIvqgIAn53+cMPT6nYwaVHQftjiqYj78Z
         GgBw==
X-Gm-Message-State: AOJu0YxyM5Mdl6sASyzHRYmTimWobBUqDhpFtfvV/m0AQUSnvRKsg4V8
	QEXCS7katLoqMJkKYiUvpqf7B+I4yPLECt1w837k3bFj6BuwpdK9iVUqjl3O/G1vYtYQRA==
X-Gm-Gg: ATEYQzw9+PhNRjayWdxeU6A7eNMq90tcEMtvkQTqS8QZHJbZZfxwQMxvf1WmFrW1ML/
	4QG9HgcpanmXdGGUE4kca9RBGKITsB1rlj0Teda9FRp8HOJRVZSHCo8CcmxSQGQvres2M74G4CA
	qIwZeIjlvVGzPOFs7IQpnMtlRQYVAY5J9q58/7nufckfPu8J2v4QUK4ygOiwU+cM1QvSLozI3Hu
	/77QtC27tGJ1k9DVMtQ6+hMY7571U7Ubc+tcx/G9oQUPrva/Wk5y3sKyKlPELPMQOqmJDe39HdT
	zOss3wCBhdcJObwmncDcuE2zikwfTWaqqmrgmX4yy0ifoRwJIUD1mMjfWCyp3pXKCYk7I+9rPJ3
	DhTTza085qFqOGvPyPwgHFqF8XL1+7nTJEtU+cM33hFxRFWvQFgXIotfxtNeFYMuz1xH40FD2ho
	6lLn6OysgngqP5HQVIR5tgN37spGutaZEdDk4wa89i9L6b06a58aTAmjHP7zTpSoncNzBjoDw=
X-Received: by 2002:a17:903:946:b0:2b2:549f:7d2b with SMTP id d9443c01a7336-2b269b0d4bbmr14975385ad.11.1775009801207;
        Tue, 31 Mar 2026 19:16:41 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264292asm132156035ad.4.2026.03.31.19.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 19:16:40 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate bg_list extent bounds in discontig groups
Date: Wed,  1 Apr 2026 10:16:22 +0800
Message-ID: <20260401021622.3560952-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running ocfs2 on a corrupted image with a discontiguous block
group whose bg_list.l_next_free_rec is set to an excessively
large value triggers a KASAN use-after-free crash:

BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
BUG: KASAN: use-after-free in ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
Read of size 4 at addr ffff88801a85f000 by task syz.0.115/552

Call Trace:
 ...
 __asan_report_load4_noabort+0x14/0x30 mm/kasan/report_generic.c:380
 ocfs2_bg_discontig_fix_by_rec fs/ocfs2/suballoc.c:1678 [inline]
 ocfs2_bg_discontig_fix_result+0x4a4/0x560 fs/ocfs2/suballoc.c:1715
 ocfs2_search_one_group fs/ocfs2/suballoc.c:1752 [inline]
 ocfs2_claim_suballoc_bits+0x13c3/0x1cd0 fs/ocfs2/suballoc.c:1984
 ocfs2_claim_new_inode+0x2e7/0x8a0 fs/ocfs2/suballoc.c:2292
 ocfs2_mknod_locked.constprop.0+0x121/0x2a0 fs/ocfs2/namei.c:637
 ocfs2_mknod+0xc71/0x2400 fs/ocfs2/namei.c:384
 ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
 lookup_open.isra.0+0x10a1/0x1460 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x11fe/0x2ce0 fs/namei.c:4131
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 ...

[CAUSE]
ocfs2_bg_discontig_fix_result() iterates over bg->bg_list.l_recs[]
using l_next_free_rec as the upper bound without any sanity check:

  for (i = 0; i < le16_to_cpu(bg->bg_list.l_next_free_rec); i++) {
          rec = &bg->bg_list.l_recs[i];

l_next_free_rec is read directly from the on-disk group descriptor and
is trusted blindly. On a 4 KiB block device, bg_list.l_recs[] can hold
at most 235 entries (ocfs2_extent_recs_per_gd(sb)). A corrupted or
crafted filesystem image can set l_next_free_rec to an arbitrarily
large value, causing the loop to index past the end of the group
descriptor buffer_head data page and into an adjacent freed page.

[FIX]
Validate discontiguous bg_list.l_count against
ocfs2_extent_recs_per_gd(sb), then reject l_next_free_rec values that
exceed l_count. This keeps the on-disk extent list self-consistent and
matches how the rest of ocfs2 uses l_count as the extent-list bound.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
Changes in v2:
- Validate bg_list.l_count against ocfs2_extent_recs_per_gd(sb).
- Bound bg_list.l_next_free_rec by bg_list.l_count.
- Update the changelog text to explain the l_count validation.
---
 fs/ocfs2/suballoc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..29a8a878c2df 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -196,6 +196,31 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 8 * le16_to_cpu(gd->bg_size));
 	}
 
+	/*
+	 * For discontiguous block groups, validate the on-disk extent list
+	 * against the maximum number of extent records that can physically
+	 * fit in a single block.
+	 */
+	if (ocfs2_gd_is_discontig(gd)) {
+		u16 max_recs = ocfs2_extent_recs_per_gd(sb);
+		u16 l_count = le16_to_cpu(gd->bg_list.l_count);
+		u16 l_next_free_rec = le16_to_cpu(gd->bg_list.l_next_free_rec);
+
+		if (l_count != max_recs) {
+			do_error("Group descriptor #%llu bad discontig l_count %u expected %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 l_count,
+				 max_recs);
+		}
+
+		if (l_next_free_rec > l_count) {
+			do_error("Group descriptor #%llu bad discontig l_next_free_rec %u max %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 l_next_free_rec,
+				 l_count);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.43.0

