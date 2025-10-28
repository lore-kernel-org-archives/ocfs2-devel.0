Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91AC189906
	for <ocfs2-devel@lists.linux.dev>; Tue, 28 Oct 2025 04:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761625771; cv=none; b=AifAzQKIKkJmQaslWflUttR1cQrq7PnJpKszA/x2Q4YB2kPsRdX1h0CV0dHnAs72aLOXerWuyo9kms9dTHUAizb/cd4JxbxPJEwOD3ZEGTABxPKRzq/zEbagjbGg5zse3gCWdM+7Xd3Otl7XjYU+NnhP4OeX75sw1CMRBwvXFO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761625771; c=relaxed/simple;
	bh=jSuLjpIYhO7/IkvgC28j6mVk4V73Q3ZkJbdO0xq9eN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P23PyLrBWh/97b0kXk3PNkYeAHCtc48M/WblK8qoroIePRARIFjwDctHqecK4lKNgBIQdCeywZ75Ep2d/TC0dSax6ryX1b9/ydzzyy81r4QTvDAzrXnJIzILlu2oojXfcCtEYD7KJk6jXmtjxg5f7xLp1/w7C7q+kH9kqtgO3zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPrNjF7r; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPrNjF7r"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-292322d10feso46096645ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 21:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761625769; x=1762230569; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QxA31IVIvTLZC4PP61dBLgzgrOSxNFppcMG4DfzN72M=;
        b=BPrNjF7rcoBWuPeZ5fIT3kjrJScVlerxobvlv0r4Sfepx3Ipgu+eO4mZ3dkIE5SAQj
         syW17cSVSmKqY+O0IImpSEX5m6ulwvggB0L1WKwlhiLzlHkxfmjGvScd3PkkyR/Pk8Ba
         iCuJdKJwFwqx988JwAfNmOmwrGCCYzLPVmAyfiGACWW0AzYFT0FgYbnD48JlF/BH74fE
         OyveuOyBRqQNCuKQ4cX9CK6tUgV5IaRoJdvnUKXt4Lw/IHw+MaKw244T0GMcxq4RqSHk
         NsosJoN589iNT2dq2wXphuj9pQ+rPPA4Ry7shNbq+LnyfmuFxJkj6ZR0GsNO1W+L/eD3
         hi2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761625769; x=1762230569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QxA31IVIvTLZC4PP61dBLgzgrOSxNFppcMG4DfzN72M=;
        b=CRC3DJaY9eBNnMupJSH8/21jCcrq5R+G9DyGR16oyrR7JfAn621DIc+dR49MtZkKFJ
         j5698qMkL0+v/K9/GGKRzlNp19xQ9vpzlG1/Y1wJaPeUfbuHsdWcZMrJzyTOVVnZfHXk
         lsXqcT91bjizA57yxsJnRo/PRdCdXVQpldbjV6RSe7UWHCkUfIXuBpctjVB77HWKa9kX
         I8ZOnMTDCq9bXUpaYqsad9cnglrkvqdjdH3PVVw6wjpC6kc8Kh63sZ7kI+lgm9XuTeck
         LeYtaRVxarVpop9K0HPJSJCeB0xfcAXf3nnYK+aeWSG/8DyIeyeXxFxHtzSFpbnzCgth
         iERQ==
X-Gm-Message-State: AOJu0YxsqHABPjGb/k6puFbqHcxPU2H43vHi/lwmaVLvVsUJbmp/DW07
	U7WynA8YD1SiV8g2c5LThKmyB6mAYkUobPAGa9Zc8JzF66sfbkncp+Xw
X-Gm-Gg: ASbGncvudGbLHmVlPNpEfIKiRKwB5aVU+eYu27J0J4ug+yKOxDTScpi75+SXcB4HeC+
	TVx13vOzxuzVS4W1rp71nIM3lt7V4h0YSi00Ja+ekJE4CNjLOJdC6Pa68qMb7efU+FEoWVy15yd
	z85s1LR1NAJcEbN+PrTF8/7CVfBFuW9Cb2C3QF2aZXwEkQp8usRIEmrEpK+HF1OUxFfjMYQ9gMB
	DEwewLpYobR6n+cbqQI/VsJDJSoZZfUbdH8ohTNGNkV3xF0TIdkBM2cZBzRXn6WIUfDArC9NDkQ
	yQ5RUsdDVRvqIX9oPrFLRWappRRYPWfgSGgQGyRQAQ+9K8xvmQmNZZRcOyvGqp3YwaJ6s7fZB+5
	BB2pWsan6IixdePJsGUtaAtAOHmwtTs5ucCftw9hQsKiaiacBjr2Nitdh1fsdwWuqMH+SscqA5i
	WHmj+7r1/ZXCzENK+SOi6WQtc=
X-Google-Smtp-Source: AGHT+IHUDQvAl3K6K64cGNJY7H9vtzlOFAov98Eo06hOpppdBvKNX8zUxmC9Yvv7oQQaZhNxOM98rw==
X-Received: by 2002:a17:902:db06:b0:25c:43f7:7e40 with SMTP id d9443c01a7336-294cc6e8d6emr24561295ad.10.1761625769017;
        Mon, 27 Oct 2025 21:29:29 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:aa38:46c1:6cd:acc2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e3d2aasm102431035ad.88.2025.10.27.21.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 21:29:28 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
Date: Tue, 28 Oct 2025 09:59:19 +0530
Message-ID: <20251028042919.18704-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The chain allocator field cl_bpc (blocks per cluster) is read from disk
and used in division operations without validation. A corrupted filesystem
image with cl_bpc=0 causes a divide-by-zero crash in the kernel:

  divide error: 0000 [#1] PREEMPT SMP KASAN
  RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
  RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
  Call Trace:
   ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
   ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
   ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
   ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306

This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
matches the expected value calculated from the superblock's cluster size
and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).

Moving the validation to inode validation time (rather than allocation time)
has several benefits:
- Validates once when the inode is read, rather than on every allocation
- Protects all code paths that use cl_bpc (allocation, resize, etc.)
- Follows the existing pattern of inode validation in OCFS2
- Centralizes validation logic

The validation catches both:
- Zero values that cause divide-by-zero crashes
- Non-zero but incorrect values indicating filesystem corruption or
  mismatched filesystem geometry

With this fix, mounting a corrupted filesystem produces:
  OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
         has corrupted cl_bpc: ondisk=0 expected=16

Instead of a kernel crash.

Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v3:
- Removed unnecessary local osb variable as suggested by Joseph Qi
- Added blank line before rc = 0 for better readability

Changes in v2:
- Moved validation from ocfs2_block_group_alloc() to ocfs2_validate_inode_block()
  as suggested by Joseph Qi to benefit all code paths
- Added OCFS2_CHAIN_FL check to only validate chain allocator inodes
- Updated commit message to reflect the new location
---
 fs/ocfs2/inode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..dbbfe72b1dc7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1502,6 +1502,21 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 				 le16_to_cpu(di->i_suballoc_slot));
 		goto bail;
 	}
+	/* Validate cl_bpc for chain allocator inodes */
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+		u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
+		u16 expected_bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
+					 sb->s_blocksize_bits);
+
+		if (cl_bpc != expected_bpc) {
+			rc = ocfs2_error(sb,
+				"Inode %llu has corrupted cl_bpc: ondisk=%u expected=%u\n",
+				(unsigned long long)bh->b_blocknr,
+				cl_bpc, expected_bpc);
+			goto bail;
+		}
+	}
 
 	rc = 0;
 
-- 
2.43.0

