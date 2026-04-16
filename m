Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC284326D45
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 08:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776327679; cv=none; b=T6vkVMAt2zBpnxHS+uVtOzw5fFeu8PX2VMcrixSK6TrzKk7n1ElXm7gAxNZO8FPkB9fX7z0sViUsJ7uRmEGG47Qyut9BbHzmvKGlZPs6NfXwFjUDvZr81kh6xT8iQiQJkSfbW/t93vpgmgOyY4EdwdDtCxmp0AdxtF/kfyeapB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776327679; c=relaxed/simple;
	bh=rXZgWhf6RU6t2TQ8pUUk0XEOqGcsFxBwtq/oN0feW/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDkfTBqlOBu+GQMY4KrXad79WpTZtlZlMuZcdJ9CfmwxqsCz5n6gAaFiZUapYZ3hiSsUck5U9DUspQWThxF0M2NvAAo43gvml7I3+m9rAzfvWpXXsmcx/xCjfcylo55eF2J1D13sO9zRAPJ5mfHUf6W6xvxuMgpjixEa44vUc8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uq0r/fjt; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uq0r/fjt"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c766a95a72dso4937791a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 01:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776327677; x=1776932477; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jDZnjSVKHLSnbqxqD+kJoFN/wG42/6FEZwqR7tAgE1c=;
        b=Uq0r/fjtCcnf/lGYpN5mdLWZ/QEkSdGQTKrRzgBLlsIfo7c7C1d+giN2k4BAYRY/LV
         8oOHsqud+5WFZ33KLcqcliXXNrVDCnMEmNr1zfY5ELiquZWFm+SNNf2YSkNv9pFXzG3d
         Bi4/ov08daiC3MEtPsK4ny3bx01rOdUtbSVQAHjoaUA5eZuEjY+q99kmaEci2bgq5AQ/
         Kl9hTE511BckTUbk8jCWuxabjtIULv3hR905nUTL2Y65WdFVpm6AyTMM9wqiTbtdil9o
         znSCq6rkNLO/xyuCwBp/G/R2xf7yT4fSo2Iz0TgTQ2LZ7vM7wzLw3LLGkE1tqPuZ7ZQb
         cZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776327677; x=1776932477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDZnjSVKHLSnbqxqD+kJoFN/wG42/6FEZwqR7tAgE1c=;
        b=ojjO7Nr0ViIna5SJ2NM4K7MoTNtB1/iuyLwhgZmOG9ifrWX8yqrSnfHCIZf40H5Md/
         JxrAASRIikZtHJXVmzHoyGQo63uAomTyJ+yzGPGYJODZBEPJkQlCDkeIVJhZSvXvDziW
         oWGWtbuYlvKd18tqeud8z85mZ5sR2U3i2PnSjCwfFU0VXIzUFdGpxov8gytK9PTHT+L8
         w1p6zO7faMDKDwvhWxPHj5jbqmB41UbFScv6+4r87hkR39HSnvPAfU086l9qD4E7XfWu
         13UzFekkiIbinaSul3cKEf/3wWL7Q2olFsrlCnKmEbOn0nXXXnDbOchDjX8jcSxFKiEs
         7eYQ==
X-Gm-Message-State: AOJu0Yy4HgkL0txG7IsH2PDgEkK6kPYw3Fu5kiiQdKUbsmp2EA3AaceO
	v0Dp/TQMD2XTW++/cJo0tEM7odAyYDfbC9qvVKgZVPjjPwYbpaJHS6Ag
X-Gm-Gg: AeBDieuFBRJSY9YWWRGjmCkrGlcCbNzk6Sh+VpO5Y1eGuekO3PoNZy4VQhoKhfRLfGT
	udcTDNVjy3TR52KzzwenvEEBI8f69Mb4Ril3h/oZwCgYhLIi4I70RgXpJXEA/XZp6YEXAHxmMIy
	ZFu7Yvy0I0yf4+TdDB0m398WdB8i62xbH0HUR3cN+09PkEXFxjyuZEhtq5uLTeO36ToQgDut5mf
	vHr/A4nDxVLp7CjiirqivpH2lQVw70Q4OHSwTKuapLXGm9/WEwHiQg39egbldXd9snweeNxSPt3
	ai3Sd/yAhi8BZeDAKIWFILCt5jz1ZACChZsFYYnumuAwmq2Ai9g2zZ8zB+Ky4/4902j9Ii326Y9
	u4ntaYcLiTTAyduvMqPcM7Osn6rWpp5Alh4aQke4P5kLt991JZwn4yLP3pujbcZaMappjuP6tNo
	rck6ok0sXn09UM0TDMMLsI6RH/Rm5k3R0CavvkswWRxlkQ7KhC9XuIohktdt+bXrxD1AqU/Bo=
X-Received: by 2002:a05:6300:8a05:b0:398:ac0d:9a0b with SMTP id adf61e73a8af0-39fe4057490mr21298837637.50.1776327676866;
        Thu, 16 Apr 2026 01:21:16 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8066a240sm435563b3a.20.2026.04.16.01.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 01:21:16 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate dx entry list counts on read
Date: Thu, 16 Apr 2026 16:21:05 +0800
Message-ID: <20260416082105.1295887-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt indexed directory block can carry de_num_used larger than
de_count. When create() needs to rebalance the directory index, that
corrupt count reaches ocfs2_dx_dir_transfer_leaf() and trips fortify:

kernel BUG at lib/string_helpers.c:1043!
RIP: 0010:__fortify_panic+0x24/0x30 lib/string_helpers.c:1043
Call Trace:
 fortify_memset_chk include/linux/fortify-string.h:497 [inline]
 ocfs2_dx_dir_transfer_leaf fs/ocfs2/dir.c:3677 [inline]
 ocfs2_dx_dir_rebalance.isra.0+0x231a/0x24c0 fs/ocfs2/dir.c:3873
 ocfs2_find_dir_space_dx.isra.0+0x32c/0x5f0 fs/ocfs2/dir.c:3950
 ocfs2_prepare_dx_dir_for_insert.isra.0+0x750/0xf20 fs/ocfs2/dir.c:4207
 ocfs2_prepare_dir_for_insert+0xe79/0x1630 fs/ocfs2/dir.c:4288
 ocfs2_mknod+0x81c/0x2400 fs/ocfs2/namei.c:297
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
DX leaf and inline dx root blocks validate signatures and ECC, but they
do not validate the geometry of struct ocfs2_dx_entry_list. Corrupt
de_count/de_num_used values therefore survive block read and are later
used as traversal bounds and memset lengths in lookup, delete and
rebalance paths.

[FIX]
Validate dx entry-list geometry in the metadata read callbacks. de_count
must match the block layout for the current superblock, and de_num_used
must not exceed de_count. Do this for both dx leaves and inline dx
roots so corrupted metadata is rejected before any caller walks or
rewrites de_entries[].

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
No Fixes tag is included because this is a missing metadata validation
check, not a regression attributable to a single introducing commit.
---
fs/ocfs2/dir.c | 40 ++++++++++++++++++++++++++++++++++++++--
1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b03238327..a89634e20b32 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -578,6 +578,29 @@ static int ocfs2_read_dir_block_direct(struct inode *dir, u64 phys,
 	return ret;
 }
 
+static int ocfs2_validate_dx_entry_list(struct super_block *sb, u64 blkno,
+					struct ocfs2_dx_entry_list *entry_list,
+					unsigned int expected,
+					const char *owner)
+{
+	unsigned int count = le16_to_cpu(entry_list->de_count);
+	unsigned int num_used = le16_to_cpu(entry_list->de_num_used);
+
+	if (count != expected)
+		return ocfs2_error(sb,
+				   "%s # %llu has invalid de_count %u (expected %u)\n",
+				   owner, (unsigned long long)blkno, count,
+				   expected);
+
+	if (num_used > count)
+		return ocfs2_error(sb,
+				   "%s # %llu has invalid de_num_used %u (de_count %u)\n",
+				   owner, (unsigned long long)blkno, num_used,
+				   count);
+
+	return 0;
+}
+
 static int ocfs2_validate_dx_root(struct super_block *sb,
 				  struct buffer_head *bh)
 {
@@ -604,7 +625,14 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
-	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
+	if (dx_root->dr_flags & OCFS2_DX_FLAG_INLINE) {
+		ret = ocfs2_validate_dx_entry_list(sb, bh->b_blocknr,
+						   &dx_root->dr_entries,
+						   ocfs2_dx_entries_per_root(sb),
+						   "Dir Index Root");
+		if (ret)
+			goto bail;
+	} else {
 		struct ocfs2_extent_list *el = &dx_root->dr_list;
 
 		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
@@ -660,13 +688,21 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 		mlog(ML_ERROR,
 		     "Checksum failed for dir index leaf block %llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		return ret;
+		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
 		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
 				  7, dx_leaf->dl_signature);
+		goto bail;
 	}
 
+	ret = ocfs2_validate_dx_entry_list(sb, bh->b_blocknr,
+					   &dx_leaf->dl_list,
+					   ocfs2_dx_entries_per_leaf(sb),
+					   "Dir Index Leaf");
+
+bail:
+
 	return ret;
 }
-- 
2.43.0
