Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE02329E4B
	for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774963912; cv=none; b=RQ3WSnF9Fc1RHmcoh6R03eV7s/qnEMEQTt6HtITBjhwZp/CfI0b/LyyBBAvSwWo0xXM0whzlaUggtGlT3dWWLM9DVyDKVzWWTWFxUK0ww2rbEtkFE/XbtuySLY8jG9uk6M1ojmehcKKOudkgvfpC50ij9sJ/L4Gd8gmRkye7sYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774963912; c=relaxed/simple;
	bh=m5CBGrM+6+LszPbi68nNgQBYQZANFLsWy/WMD5SOrbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l54/xYzKFUiWEaptu0ReniBLHOctJjjX67yciMZAeH3/9NBbgqjHp0N2xKm/9KSW5LXTWfJB2JWpx+nbSXSzGvy5tKWq9y/Uf9+qzSatA6OwuaTmkbqqqkBK69fX+pKMbMAi+IJHsjfnaP9X1uEe0jfZKACCFzREktZSWSuEIPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aDwZss8h; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aDwZss8h"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-358ed696623so2560396a91.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 06:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774963911; x=1775568711; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EOrhnZnCh2rpQmJ1V2h/7OPGGw+8zSWT5Qa5xYP2Wzc=;
        b=aDwZss8htfEoMyMer9Pu9XEM3iWXDpDy8RiruvnzQXWzzMw1Es8ZPwpyo1oPZrfpkn
         S+jzH00SNp0+hXR4ZBNbVuC779AJWyhdWpWZHZhO+Q+bcBIjy0u9TaASi7na5a98aBxd
         FXqRCuq4UQOpMVLyA0sOsvv1JmcOnJ5+p+HlnKEUdXm6M7rYMQOqDw5ahvdPb2ZNfqHy
         qIsKCYevCkMfY8qZ8v4smalT1V0C1MeNfmaxecgcAXSqTZrQjyd9RbidbRgWRkR7xKZ4
         0euEP/a333vk3euJpQ5A4g7HfgHCTUziMeTJT1tKfR+uY8Da47pxhkChJxCpEnO3eATe
         WUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774963911; x=1775568711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOrhnZnCh2rpQmJ1V2h/7OPGGw+8zSWT5Qa5xYP2Wzc=;
        b=YK8UNPo7jpZhhRCQSe+oJOfiIXYUxwSHORzSoLzqDNNKkG79R8PWux6Je6gPRal0zX
         QVtdWMJh4YeLv1F2AJ/Kz1F4U+Ctr/Gi3k2+yRqYIfYyqDJXXV2N9AxDEF8deH0j3h7q
         C4BV7dUxk78vQwYYpIs7dp47NIK1AGFd7YywkpSSUKSW2ZwrJc+P8+kfNGdb7qvstFoe
         4EDVZPzUwBB/Nfq4YtLJWwi3iK1oXxzYUG0RUS9C7KBlJyHutb5cZIxaCmoiWVXk8ut2
         uNlLLzEHNU1g/IC0iYRl5AzZ17U1SCeyiYXf1w4AG09YDROfCgcIXmH8KGFbqvGEuDyG
         HLNA==
X-Gm-Message-State: AOJu0Yy+UdKr7ZtIShgfFBwmQL3F0ppHPTFygkLowWWo19E5v31AILRx
	9oNjkUfIzVQaFzVfxfj9VAAEqtIUNARxbucesk+eKu6ebWf8YobOD5Q4
X-Gm-Gg: ATEYQzzge6vditBh0aDrhFZLqUxOBBNNrh/ulYVgEzQmxoCwRn1lfTKY8LmRW/WG9al
	m3IJ6dq90y4/HuRfluznLyVUXCsR6iNUrpoeBIcJMyziWYQIHwbfD643hO+y3GPSKYdJFOSXm7M
	uXsqEYB2iWRLf/nhyxclkbnZEu+cgt7YaV7RRf3tyLyaUxGEzW6VA2A8Zf+8GZrGNPbGH1WDRYL
	qPcgtbSr+q0gMxMIg1ta3xBlRPBifgb7IXFgvTEfQbk4jSt6uflmlh4Hv8lcJVrrWK2VkkZwxD4
	iRSG+gwKT847csAEbgvwjgcvGnx+in6ruot6rnBfFrJN+HNUMgynoro7Q4Q7AqikTwrEAtGdSXB
	c9zF0AZCWeNB+d/nBEmdlIb4ZUWJelylbWEeGdDwc+vgEumlR1xdFYTO5Fl8TOyXYuOkarpwAjO
	SAwNZK8UT8gkxmZEDNZCNJl398twb+Mhm6Hpd0a9QyZFWZu+HrRbhVuP+XDvDRkRKwx84TSC0=
X-Received: by 2002:a17:90b:4c52:b0:35d:a2aa:3b05 with SMTP id 98e67ed59e1d1-35da2aa3d37mr9160415a91.5.1774963908946;
        Tue, 31 Mar 2026 06:31:48 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dba5d9529sm757088a91.3.2026.03.31.06.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 06:31:48 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate bg_list.l_next_free_rec in discontig group descriptor
Date: Tue, 31 Mar 2026 21:31:33 +0800
Message-ID: <20260331133134.1842372-1-gality369@gmail.com>
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
 <TASK>
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
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
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
Fix this by adding a bounds check in ocfs2_validate_gd_self(), which
is called for every group descriptor read via ocfs2_read_group_descriptor().
Use ocfs2_gd_is_discontig() to restrict the check to discontiguous
block groups, and ocfs2_extent_recs_per_gd(sb) as the physical upper
bound (rather than trusting the on-disk l_count, which could also be
corrupted). This follows the same do_error() pattern used by the
existing field sanity checks in ocfs2_validate_gd_self().

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/suballoc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..6dcf45fda457 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -196,6 +196,22 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 			 8 * le16_to_cpu(gd->bg_size));
 	}
 
+	/*
+	 * For discontiguous block groups, validate that bg_list.l_next_free_rec
+	 * does not exceed the maximum number of extent records that can physically
+	 * fit in a single block.
+	 */
+	if (ocfs2_gd_is_discontig(gd)) {
+		u16 max_recs = ocfs2_extent_recs_per_gd(sb);
+
+		if (le16_to_cpu(gd->bg_list.l_next_free_rec) > max_recs) {
+			do_error("Group descriptor #%llu bad discontig l_next_free_rec %u max %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(gd->bg_list.l_next_free_rec),
+				 max_recs);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.43.0

