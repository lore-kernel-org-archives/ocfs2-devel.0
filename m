Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F2341D205
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825926; cv=none; b=S6A399UoE7g2VFj/UobNe4S71TW9F6dCb6lBRLzArhjbLvIVjwf3MVgR548YYMnz0/2HymudeuKcaHrIk3k8k2n9ilEohAG9WaUksJkVavKAcR4NeJluucYNGTgxnkq4yOlFRDZn+jPVKFEarLeqQ6o1hbdew+squaIOc1agTpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825926; c=relaxed/simple;
	bh=CP/QiDGE1eTcMdAzoQy/MuB8aGnZqOPRGI3EmSy9FvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XYXtcWjzYCyMulKPlEq+pbSBZOFMblWpsM6m413YrQKHmsmyJB/WAgsqiksyvGghniERqqiO3RlAx4CrSQyEAN5wc4JPzFMkxhonU08tPmU1BLp80c0op7v6OK6IsEMk7OqzRzdRVgxvgILoK/BE6dUTF1HOtFPt9R+yvyxreTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MC4W6b78; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MC4W6b78"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so482442a91.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 03 Aug 2026 23:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785825923; x=1786430723; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AH3vppyjD/gVbDWLVTc33GyNBGQ7brJNCu8pjSkSL2g=;
        b=MC4W6b789FXn2U2RyU74YIPG+OGp7BplSE6EuOLA1t/PlV1BzShu10aOt7HsL8MKx6
         MNNqAMiaFiemUP4P5bDfchFUr375KaM25AjzldEuCppHkB5ccd1h20lGuC4RtRjb36pG
         FucFJFe7x/08kmKmb9pdA8H1jRrHSB/td+DRHmmOz6VBEpwnLKtOL/RYbppQ8ekhOM5w
         I63QZdmRk908t5G32YUvjf6li8+BEogFS52hp6BfKtRSjowyLx3k9ZXs/3yk98rm7N9V
         zAE+B5nyS+QFf7GoVMd6EYm3AQvRU7lO6i8pQ0luUAujb24JF1p4yEr8elzh7JpkQ0cX
         d4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785825923; x=1786430723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AH3vppyjD/gVbDWLVTc33GyNBGQ7brJNCu8pjSkSL2g=;
        b=f4dnbAMEYX5EFvpAkxmhJuiw3tgw+Wzkllv4K7KUTdLflF0wNpfgTXrTfZ08uM3TR5
         GYMjx5sUtXm+LDoLj+srQWxK6axTUnO1EtDaFUqHXDyw4fFf8ywbEoHS+6dQzJjSM8bB
         7D8x7BGHFfCZXBosl62xWYQFFxzNPSm6zsEo3YxyrZjnoregxMsFUDXsXrcsZPJV9ZRl
         NLcbtzGbeUDDE2Xb4B5dnrUp8xJBo84S34clI1y0xFDi00vdXrElZOsYUsD7B0vENXli
         QcVlWhjpgJXEFpUj9GoYmgx4a2RDeZKj8aGMhkYlNrHzexNxJwECx2/WceQcXRatfcDb
         BY+w==
X-Gm-Message-State: AOJu0Yyprg9ixFHEWgLltdmFcMWXbPgXqky09+2iCvAerVc2RRlGVIS5
	CLVIHKP8/ffGdjlijYRST5ZtW8fMbcE7bpslQ5WJXb6+YLialwpqT3qw
X-Gm-Gg: AR+sD13MSGVlV2jd9ncHRcqiTk0F58l8NipvFDLBtSvX0Aw/7ooFJfKh7KkoNDsGVGy
	+Qc7JIOfLzq2I+6v7bsxl6ImjzkvlRYcVj87w70zg+YF3/YbAS3hWApNtGw2+HX4Qq2JfsNZYvL
	L/DxqMu9HvzXpF+rq+G0cjbQuuWB6nAWCLPRKBv7YKNEbJ/kc+O5AKrpsKXAxrrxCjR+zL+M2zt
	dPVOkJM7UCSTJYoI0B+LKMsWwVw+ZLufn/yJzC3+a2KmFlhSkPG2pJYwZmbLnUp2T8/4B6bicWJ
	1lc1Dgv4CHFMa8yBzge3HztfAZhp55QFU1u4NKbZtPPXqWLgJSYjT/DBlhe8x6I3V1UrRa80RLO
	z4Of+y0/lGvcfYI7ESMXES6MA92aY1ZlcQaIQ6wvLP8mzzliEqe8EBoi1c4WYI0mUPxOZJylQfc
	C2dICdUDMR/zEEKVtl8CZ90p6UfkSeoiQXWQtg+B86Rbh/+bQgPXUC0Nac3QgdDPJTFSFDX24u8
	b6uJTde0oAKkpjrdEjMeEutg1+wiA==
X-Received: by 2002:a17:90b:3cc5:b0:37f:d265:18d2 with SMTP id 98e67ed59e1d1-38fec00df2emr1699403a91.7.1785825923109;
        Mon, 03 Aug 2026 23:45:23 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfdae78sm841640a91.4.2026.08.03.23.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 23:45:22 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2] ocfs2: validate global bitmap cl_bpc before resize
Date: Tue,  4 Aug 2026 14:44:45 +0800
Message-ID: <20260804064445.766072-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted global bitmap inode can make online group extension scan past
the end of a group descriptor bitmap:

BUG: KASAN: use-after-free in _find_next_bit+0xef/0x120 lib/find_bit.c:157
Read of size 8 at addr ffff888021b52000 by task syz.0.34/409
Call Trace:
 ...
 _find_next_bit+0xef/0x120 lib/find_bit.c:157
 find_next_bit include/linux/find.h:73 [inline]
 find_next_bit_le include/linux/find.h:518 [inline]
 ocfs2_find_max_contig_free_bits+0x53/0xb0 fs/ocfs2/suballoc.c:1292
 ocfs2_update_last_group_and_inode fs/ocfs2/resize.c:127 [inline]
 ocfs2_group_extend+0x83e/0x1ae0 fs/ocfs2/resize.c:350
 ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

[CAUSE]
ocfs2_group_extend() consumes the global bitmap dinode's cl_bpc value in
resize arithmetic. The existing inode validation checked cl_bpc only for
non-global chain allocators, so a corrupted global bitmap value could reach
the resize path. With cl_bpc changed from 1 to 51457, extending by seven
clusters wraps the u16 bit count and grows a 2048-bit group to 34567 bits,
exceeding its 32256-bit bitmap capacity.

[FIX]
Validate cl_bpc in ocfs2_validate_inode_block() for every chain allocator,
including the global bitmap, against the value derived from the
filesystem's cluster and block sizes. This rejects the corrupted dinode
when it is read and removes the resize-local check that incorrectly assumed
cl_bpc is always one. The resize path still uses the validated value for
its arithmetic.

Fixes: d659072f7368 ("[PATCH 1/2] ocfs2: Add group extend for online resize")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Derive the expected cl_bpc from the filesystem block and cluster sizes.
- Extend the existing inode-block validation to cover the global bitmap.
- Remove the resize-local hardcoded cl_bpc check.
---
---
 fs/ocfs2/inode.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 41db7dd39ed9..0e1f9ae0eb73 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1683,12 +1683,11 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
-		if (OCFS2_SB(sb)->bitmap_blkno &&
-		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
-		    le16_to_cpu(cl->cl_bpc) != bpc) {
-			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
+		if (le16_to_cpu(cl->cl_bpc) != bpc) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: bits per cluster %u (expected %u)\n",
 					 (unsigned long long)bh->b_blocknr,
-					 le16_to_cpu(cl->cl_bpc));
+					 le16_to_cpu(cl->cl_bpc), bpc);
 			goto bail;
 		}
 	}
-- 
2.43.0

