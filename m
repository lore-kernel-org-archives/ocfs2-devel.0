Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A46931BC80
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Nov 2025 07:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762846721; cv=none; b=md6secJRuayJhSEy+aZ+z3RD5HeNpaRxYYpEgt/rnwH/uGEL9SfFoi7Yi8tTvFinvzotIZpyrXsJnnmDgun7cKwmL/9ZOjg9jzciYSP9UcnLBnUOoWvW9MpHDtyk/ibXxcgN3Wve+c3yS3Jd8+/caxXiozgtYmAU5MERM/+51zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762846721; c=relaxed/simple;
	bh=HvfH3RKp5senMnbC4tfcVxY2crG3xn8LwjbA/IOPgyc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XOcwtMJc7pZGr4T18jmtjJeHJc01i8Z9xXlAVOYBbXNL7myHdeMafrjmOWcgN5LffSpTuzu1+L6wQGEpHszZCUDmtqLyfT92Y0NAVJO1s+JZMTx9vSuC4z25Pit8qcAvshpAx69pG8Huo/W2IXsWUdoAd/NP6OMLelDfTR/NQIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIiUgAJV; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIiUgAJV"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b996c8db896so3239081a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 23:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762846719; x=1763451519; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C9ndsoTPDxhr1ZIZLS05/CvMhHBG4GAQRgkdZOfuzvA=;
        b=mIiUgAJVDcBh67hxS5c7xb7ie18c+r3wpq7AXSucCenU7YvgqYdSrztMaTtDBsyxXb
         xHgeSLpB6g9i+QTKg+4KuDLX/LKjcYo2VcRRGCiAqyVVGIV9uL6+2ig6hAsOoAVluOeT
         USLJCm4wmxGL1jB7W2O/o08ugUoO7ItqSVBeC1RDhYZvyeSjF4tjOmwkDJv7Q3A0Tla2
         DjuQrjWzAa04q/c31V13MbXlFo9t+mOec3sh46iJocjjAOA8N9I0qmZ4zwO95lekfas4
         TSsiYe874lG+XPdNu6KKFDDiMpU1QFCbr0SH/+fAbVQs5wFabsVR/LfpOasjQhG474gz
         ln/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762846719; x=1763451519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9ndsoTPDxhr1ZIZLS05/CvMhHBG4GAQRgkdZOfuzvA=;
        b=XBwWWgv6FJbP6nWdgzisCniic/YQ0Juca0FXQN5uvxsIK7kKIhLhnBzBMr5te+9NCC
         A9MkY4vq+HdIdq5r/RVsE0Qgt2CZ3v67SiNCXmXMcmQI5FPbChOOZKzFgqKlsz77a5Ll
         oi3R3HpLLGO3HeOF/jFHCoYFfk4EAs9D/JHqN/i9JD38Sga2GqvYSuNspvyDV2lOWpM5
         fosQ7w+i6XB5rzdcfPzP9pWFufpz+jl9KaEE6uOe615szvFuEldTcNX1DIySA5UFDG/P
         alNeD70PaqYR2spKH7jpH/+gi+RauIMe07zi+4zk1JpVWP3p2U285rCH60Zp5S2jmrrx
         7C3g==
X-Gm-Message-State: AOJu0Yx8Vw7IOZXFeSAuuNDarxapeSqx94nEmUfsVufTVkCYcJLYu+9b
	ogFJ7anbdTJitt6XQHu6ZMOL1JpatupbtEH64qpwjarxnSbCBpYzKoFP
X-Gm-Gg: ASbGncuSG60B3cxxQi1SNC5nxannR0aWwYkY2v3iLCxkWyq3v4yCsD02cv7VbANFll0
	Ae+JaHuPiQysuOKYhTgBO4WeHqoe5rvJDUy4qGfsmkibFOYlnCxcAlUWzDhfTy4aQ5uGOSWcj5L
	DxI8pcUqgvdpS4DOUVlpmrNiOys2ClD3u81jF6gWQrrR+MFJqamORxxPQKCdfuRIRSbf+cmUY0U
	96mqWXtk21dgdj+4887jCuUXLKyFRNV1rgdc7xxuAllPxW4iVgc7evIfMMWAg90XwTxcSkhMsKQ
	4PDzulnNdG1FrFSpg2Kfs3K/3Nr0x6pY3CVWSMgSFc2NGgvI7DmTOcMvqPLT6PEGaHojL0M/kba
	Ikzii8v7iIVPAG8eK5c6WIrpZZFcPjecyPOtXX5PomJ5hdj+6xBaoGkPbHgTS3HgUWDlCxtUTcC
	kwTzGQxV6UCFJttIQY73bE+p0=
X-Google-Smtp-Source: AGHT+IHHGeaf2R5g2Vtakbv4+m13R1FK4/U22rAUMop0DbrxDVDpJHVAj4e9itb8L1DMyZ3Jt8m84A==
X-Received: by 2002:a17:903:2311:b0:295:9e4e:4092 with SMTP id d9443c01a7336-297e571bcfdmr147154685ad.56.1762846718641;
        Mon, 10 Nov 2025 23:38:38 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:a4ed:fc5:c0b5:fbfb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c94abasm173051835ad.82.2025.11.10.23.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 23:38:38 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate xattr entry count in ocfs2_xattr_list_entries
Date: Tue, 11 Nov 2025 13:08:31 +0530
Message-ID: <20251111073831.2027072-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation of xattr entry count before accessing entries to prevent
out-of-bounds array access and use-after-free bugs. A corrupted
filesystem with an invalid xh_count value can cause the loop to access
memory beyond the allocated block, potentially reaching freed memory
pages.

The validation calculates the maximum number of entries that can fit in
the available space and rejects counts that exceed this limit. This
prevents the subsequent loop from accessing invalid memory addresses.

Without this check, the code directly uses xh_count from disk in array
indexing operations like &header->xh_entries[i], which can point outside
the block when xh_count is corrupted, triggering KASAN use-after-free
detection.

Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/xattr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..2caf63c6206e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -928,8 +928,23 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	size_t result = 0;
 	int i, type, ret;
 	const char *name;
+	u16 count;
+	size_t max_entries;
+	struct super_block *sb = inode->i_sb;
+
+	count = le16_to_cpu(header->xh_count);
+	max_entries = (sb->s_blocksize - sizeof(struct ocfs2_xattr_header)) /
+		       sizeof(struct ocfs2_xattr_entry);
 
-	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
+	if (count > max_entries) {
+		ocfs2_error(sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EUCLEAN;
+	}
+
+	for (i = 0; i < count; i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 		type = ocfs2_xattr_get_type(entry);
 		name = (const char *)header +
-- 
2.43.0

