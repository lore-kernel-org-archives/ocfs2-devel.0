Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4C30DEAC
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776337361; cv=none; b=UxdP4e4a7s/WaCJ488tZuNdP+H/aeQYXKSGw/+AKFiLA+fln8hfB9VsiA1C8O0JhQlFjptVYqDSq5aJe9aGRqGn9k1QXGI3z2ISyfx0vc3x3iO+d05bFIh60uPbJcGnsXhATT42As1z79JmaC60wdRNbGq0bzJSnC6/CHa941QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776337361; c=relaxed/simple;
	bh=KFBXTi63vI6zjnGMRurOQ/GmieCYA7Zu6u4+QOdudWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svqCm6Y4q6IfnSOXOdBjCyNd9kg/NwnWHZDmLA9UbqhlRHHewn1dWjyiqXB+HYAyQjZXNbTXFlRURpqufaNfE+sgT4Jvtu2ICz0merB7C7dWDuymB4es62YuvVkdzCW829pKOmG+IpX1dDuiOsjy7uLB1SnVy2YSf61qXhII0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntfsFmUp; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntfsFmUp"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so2520896a91.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 04:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776337359; x=1776942159; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9xOMrsgK3rt7IdOfytfuUmtL+vnDHQ+MNaOsl8Gd7Is=;
        b=ntfsFmUp+JlX8lCsAAZzHpbr2hic77R5vz0beglpX0Ev1OQyp1zEZgxJ13FGhOg7sb
         j/Sx6QY+3dpw2qZpRbz5pzVqLbakfgMOnZIvI8AS8KmfW9Xj/xE4yH8zwDHb1AxTFZcp
         W8hdTyunnBUNAW1HvzRDG5tnutY2dT0o0AtSurQBT8FMXxS6NczgkCT//OxmnJSCx3+4
         2s6q6FPpZLwEWaFesg2ygyiG5rVQxwjNk2TywM+vlsU3Jhc1tREeFau+/u3suS77pUzM
         biUHdEqceNRCFVtieH/7zDPj5bhaORquuWZ55g1OpR0W/lETelDfhOufF323WCHg5Lc/
         0PDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776337359; x=1776942159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xOMrsgK3rt7IdOfytfuUmtL+vnDHQ+MNaOsl8Gd7Is=;
        b=ioa7B6/lds6g3jw8RRnR9DrKzELuhRz7T0PdmO1Hd+VksluqOIe4Zu3hTfKz38J1TN
         sYbr4LO1rx97PbPnX4hSQxAgUw9tHGY9E69rEgnAZ+8biA8Rlt5eQsAbSUvAnkTodsCr
         3ynEQzaZnEaCnUUeHL0XoGfZeRaVHqbooHQ/QX5zwdWTt9zyOMLYadATZMK3LUIp/B3J
         k/pNpPmwTGm1+fN129Bt2pyHow/ErwY94yC64do5auHK7SjWdl4KWSI3x2wN7ZJGALTo
         Vh+WsRG9qsby49WmmiKK6rAMzOqjUrvZhF93pVPwiW9Y8Z8J2dQelYHPSwiOP/b6kOnf
         L71A==
X-Gm-Message-State: AOJu0Ywd8aHe1Tm0LtAr914Hf5zNRyPiPqxvSGbc2petdrjFJA9lFvY+
	/j/CjxU+amCtDy72zbVZ+eCo3romuMxcPZH3ZGXf489NiEpzjARL27keHaY/X1xS
X-Gm-Gg: AeBDieuxPmWQUHRj931hh/7HHosyuXziWsT/MMe9ctgH00YtWxtHE6MfVS+t7C48N8s
	PkDcqxAoQ17N++c4igI/M9yzg7AgYXr9IJ7e5BIdZYZ0/E8RoGDk31B70pXNQUMNWnv2xAqQTtV
	fZ8b2quy8qH2BRS08hevWJbyz1bp9hdENNVo/qlvSzfOAlIELt3IqYhXXjXG8B53Av5zjhY4RCy
	IbPq+wWb85oc3nSFlIZ+JXWn21rIq5xZ/dGzpvn2eptfinzmD5+cfKlPBBnJYxoN4St2SDJHlim
	nkNuWfriNYSbnMjlRZRs/S1LnfgY2GKk7LfBb5LT0y/CtWjT4xEKOcDkMlHPjyc9OQC+Yl3ItaX
	hPccBR/lQHKYqf9fHrjGjHVPmuLLbzlIzn+B17sV6f1B+uG+9zEsdEeBw8frrnQGq6TrVS6eWoR
	vqVPAs287vxcL4/7LBHWNMw1UAbt165EhYAHan9HDXfvaZpgbjEbZqrch2sAdZMgBQjRdHTGs=
X-Received: by 2002:a17:90a:ec86:b0:35a:cf:64a6 with SMTP id 98e67ed59e1d1-35e42874998mr24558448a91.23.1776337359207;
        Thu, 16 Apr 2026 04:02:39 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fce7d792csm2765203a91.1.2026.04.16.04.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 04:02:38 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate root extent tree depth during inode read
Date: Thu, 16 Apr 2026 19:02:29 +0800
Message-ID: <20260416110229.3283682-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt dinode can carry an extent root whose l_tree_depth exceeds
OCFS2_MAX_PATH_DEPTH. When truncate builds a path from that root, OCFS2
hits the internal BUG_ON() in ocfs2_new_path():

kernel BUG at fs/ocfs2/alloc.c:686!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_new_path+0x1d5/0x240 fs/ocfs2/alloc.c:686
Call Trace:
 ocfs2_commit_truncate+0x29f/0x1aa0 fs/ocfs2/alloc.c:7253
 ocfs2_truncate_file+0xcdd/0x13c0 fs/ocfs2/file.c:509
 ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x260f/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
Extent blocks and __ocfs2_find_path() already treat oversized
l_tree_depth values as on-disk corruption, but the dinode root extent
list is never checked when the inode is read.

That lets a corrupt root extent list reach ocfs2_new_path(), which
stores the tree depth in a fixed-size struct ocfs2_path and therefore
expects the root metadata to have been validated already.

[FIX]
Validate the dinode root extent tree depth in ocfs2_validate_inode_block(),
which is the same cold metadata-read boundary where OCFS2 already checks
other on-disk geometry fields.

Also report this condition as unsupported from online filecheck so the
checker does not try to invent a replacement tree depth for a corrupt
extent tree root.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
No Fixes tag is included because this is a missing metadata validation
check at inode-read time, not a regression that can be cleanly tied to a
single introducing commit.
---
 fs/ocfs2/inode.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..b3456e627689 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1525,6 +1525,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_tree_depth) >= OCFS2_MAX_PATH_DEPTH) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode %llu: extent list tree depth %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->id2.i_list.l_tree_depth));
+		goto bail;
+	}
+
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
 		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
@@ -1626,6 +1635,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_tree_depth) >= OCFS2_MAX_PATH_DEPTH) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: extent list tree depth %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_tree_depth));
+		rc = -OCFS2_FILECHECK_ERR_UNSUPPORTED;
+	}
+
 bail:
 	return rc;
 }
@@ -1633,11 +1651,14 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 					      struct buffer_head *bh)
 {
-	int changed = 0;
+	int changed = 0, rc;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
-	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (!rc)
 		return 0;
+	if (rc == -OCFS2_FILECHECK_ERR_UNSUPPORTED)
+		return rc;
 
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
-- 
2.49.0
