Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9287E2F693F
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 12:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761568901; cv=none; b=NPR6qxSlrKnTxOB2nmtM6yAyd7H3jD5NgACKqcCDfi+eP0cvyoVRxwBsy+UsUcn3SRGWr7BT1/qSVhNk4LUjxHsGwgngybsc3gKqPWGTzqDOOZdMfW1qw4G8foADHrLmoaaZPWEiF5Y2EbUs+AvxRfQir4y06lihV7brjYTQ4SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761568901; c=relaxed/simple;
	bh=f/KkUu++3KmiYz5DrCSj7Frxr4e4wx4P9/+YNJ1WUh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jQjY7wWc6Az9lieAfjouVYSpXYZB54tF5gmOklzdKWl98WjLL9sZ3rPFPCT6owJyDSPvhRPBSMkJHBHJFeFbI3y8IedN1pMXjs/v3WJqKZejYq8ylxjtEwojrb+2QSxTxCFFiNnf3JP4SJC6JQ/IMZeecH70DafgtEiKLBRslmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsUrpgf7; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsUrpgf7"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27eec33b737so66300425ad.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 05:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761568899; x=1762173699; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qyI+DPCtqdRhIJ8G1CS/+OArsT7nhwtmjf5oWIejpt8=;
        b=ZsUrpgf7/dxuc6Fjjbia6bq+ygNSZxKj52dI/ev2LrWwz5lYt0AO0GkMiJZABRTfwk
         vtCt6/HgMAzL/cXQkYNEiUNu44NcUpek0vCcG8vK/R7Dcf2ZwRIbnK3HWXMDX75sYZeo
         JJcBjsUVCzCvwy+poaT69HF7jY1vEQFexgxr8gfBWrI6GmekCFYVb4YjickTTpn1NrGt
         dPkowD2TZTBL3uqUz6r2zldmR6C1K2pahFHfBWuALZ/ITE9y6OTTCKCP4LnbgFMDqRZA
         wU+i47R5azM14iGV0efQmfmnqCG/N2W1Tx8KohVusYKCm6nkn/0EWtZVFJqBDnxxbKt/
         JoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761568899; x=1762173699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qyI+DPCtqdRhIJ8G1CS/+OArsT7nhwtmjf5oWIejpt8=;
        b=RKQx3nShBQV36caWX6S3oztY8xPt1Axy56kxdpzCDx0GJOXwivc4H9Zz+U73vIFrRe
         igkxeT2yiGzMWL2Vz2gfw55+pOKWbkro/IVLsbwicoAydmiAomfafPjxR1duF/uArSwh
         ueiPOh+Ft8wxwDvhkX9HCQAsQW/Gy+uUPHWKbSv4MyBS3Z02zuz9J/3MwuUrIgvwAmky
         ey+XQu10pYY6eXMSS2DYPjBXdksMd1hnadZaI2hrM4k+tiNWqnJmNiWW798FmcFIQwFs
         jNDF/CxBqJsk1yL5Bs7eAnaZ7hKrMW56ItQnCTmuKsnv3NVxDkJIZZfQ78lK9lUJqIj+
         SCpg==
X-Gm-Message-State: AOJu0YxxgXTFDaIj0HjYxVD7YyeH29ARdwCmGW4PgVgDD7QHGHHCITgW
	kbewqzHqxzvmZJteofKOu1WmfKiBrNiJ6kfJenlx8mjAiqkx89sRJMuI
X-Gm-Gg: ASbGncvvAAsKpSgIac88pZ3w+mZ4tnbVRA/tvHemvdxtPXjn1rws/yJ5Gg9rP4JYNYR
	bSxLmcgBxdSdA2Gfot8vQ99iJe+c+GHHxgYxMvk1hS9+WuaYgJmKHp5QGloHTElsAo9+NOFdOeT
	DS1LNRQoD/GX7SxvzISt4ykGQCyWCy9RKmvpXBF4r/TeB7yBwXGza/v6V0b2fKzd6laYgq9Ri+K
	9SiQalmQSRe5olR0oYbeDBBt9mqEI53LPZvo0rB+h/EGblBT/cRGgbcFgq7iLRajTYCD0NspKXI
	jZm+axYM24Qj+YGUuffs/k/7c32WtX2jw1s/f1QK94ZTHzj6y6wbrHhn3AiTSFNZssZ16nawPX3
	3r95Lz/PMrFvah8FXvkVPK8Y+NKOMyfepHhzjEXKhQBrue8CKrvHiNDmM1P+evisc4S/dJMQIqk
	NwFsBAjZplSn9oSZuIEK3r85wHgjaa1bH/0Q==
X-Google-Smtp-Source: AGHT+IEqrgMDJfWtwihWC/Q4q/MATvDY1V66B0J6iABhpmp+mFfhJ3MbgAArMnFCcD/bsbmr2oAYLw==
X-Received: by 2002:a17:902:dad0:b0:24b:270e:56c7 with SMTP id d9443c01a7336-290c9c93b02mr497221485ad.7.1761568898580;
        Mon, 27 Oct 2025 05:41:38 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:fac6:8aa5:82e:7fef])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b7127a09a8csm7516159a12.11.2025.10.27.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 05:41:38 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
Date: Mon, 27 Oct 2025 18:11:31 +0530
Message-ID: <20251027124131.10002-1-kartikey406@gmail.com>
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
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v2:
- Moved validation from ocfs2_block_group_alloc() to ocfs2_validate_inode_block()
  as suggested by Joseph Qi to benefit all code paths
- Added OCFS2_CHAIN_FL check to only validate chain allocator inodes
- Updated commit message to reflect the new location
---
 fs/ocfs2/inode.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..1b30bf336961 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1502,7 +1502,22 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 				 le16_to_cpu(di->i_suballoc_slot));
 		goto bail;
 	}
-
+	/* Validate cl_bpc for chain allocator inodes */
+	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+		struct ocfs2_super *osb = OCFS2_SB(sb);
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+		u16 cl_bpc = le16_to_cpu(cl->cl_bpc);
+		u16 expected_bpc = 1 << (osb->s_clustersize_bits -
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
 
 bail:
-- 
2.43.0

