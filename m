Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF3021B918
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760024955; cv=none; b=uHiG8b6oAiRIEWnDBp+kIXmrjhcdliTNQmpPCQLmfFuUTfp8th3LUcK5eEfYhIMYXKp/MBr8W4CXahFXeudhXxASziWyFfY4q0bvwdlLzZjvVA3bHPDp/AXcxGxeYAn/QltOORfWD0x8Ppe4yMBa2X6FB3rvTg/pxcwEXAfkcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760024955; c=relaxed/simple;
	bh=GuLLQAKATyLvjbNuey46y06cX5Vw7qz03m0TI8g/60o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OFG9BUyrybxhud6bFPQ2uXDiNYIGBAwtISg5X0gjjdE1Vh80jnAZ2iA7GOR+k9YSA6gpvf8TNLenj3wCktX+vxO1vBPdF/8yUn/pftLSLahbmyHXbaErPAFYGuNLjiP5PioxikdAvV0QmHa7iscLT7zA/ywGm/mDXdslY6UwqIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XpBK+ab2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpBK+ab2"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-330469eb750so1479833a91.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Oct 2025 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760024952; x=1760629752; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j1GcN+G00e8rgYgWddESo3aRTzLrdG6jM+98jl/EWDU=;
        b=XpBK+ab2FY55xHd/1Rs0NDS2wh/Ol5hn/iuc7taC7+uoACySsgG9ZU86UfqCRwPY4/
         j/hl2e6FWyBO5fA9fxPSj/ZtjcThxJ8RnF8+/tdNSMlwkRStQnXBY681YchzbceHuAev
         lY1Pt9bz+ZSCNzbOXLNva8eSssKxDdtey00/3bAIh5+LziHn4V08zm1EaJijHDE/86kp
         cEKCbtiNvNdanBQllGPDBYuHX24rfAZPjqzbJpZHOxzoRM8HZXwL5sq56jcdzkoP0FeL
         N+6aWWRPO9lM9h8KDBj4jV6PUCXXyjeSfdkQ9HxNuPu4LZ2SHLzfE2VWjckRQWW2xpvc
         CgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760024952; x=1760629752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1GcN+G00e8rgYgWddESo3aRTzLrdG6jM+98jl/EWDU=;
        b=nLGMvZfTU95wzyeLChJeWHUdUN1tVGqUzmeGWTSFoTTklqVTiILv0wljAhuUNFKaIh
         6+f3ajr6vu+IlTTEL34/mHk9dWAmbg2l9q4d2AaoFEwwl/om3NDMSiMt/PBQKbgc5NbX
         P9APMC00omk9TrRjXYkjKYPmjVYf0QXMhskgKDQdo7kz/+7O94NBM15ioUQYKWMhRoSz
         gqFfGTkj66nxic+82DvAy7lLQyICcRLP0HpPTFvC89RSF4852XnRrd5BIARf3M2iu8ID
         MH3IeEWEHdmC9IfMkqr8o5OfumdJ+Kudau7UY/pizV5Kyp21LFnFyNKmu5F/50jLm66Y
         CQ9Q==
X-Gm-Message-State: AOJu0YxeuWtTQFItydVE5zYxjqyra2yn1CfLlnqI108mcu3Hg/6723sF
	C86ISTImuN1ffDyBhH89Cb4YGLy4bebCwFA1S8/uSmvxq4KuPWNRvxYB
X-Gm-Gg: ASbGncv496PPgtlSEx9ud/5Po0s/zw6UnbSRZ4XuOQvS61sBEtiGPwne4p2AeOiYrD9
	LM+XIquLAPfCcAKFTEQxgAokYFkGN2pJmjtUtWNy5TXar04j55bJfM8kvryfMCgzBkoktSmqjA4
	rF0PtL4YOIxTh/5TZsU0UrBUojjyh6Hr0a4gXXlEf60WsLSO5yPdzdbVX7BN3te2zYWTvGzAGmN
	uvrXe6ru/+Aal+4QO7CmBCYTwWyzvfAPqF/ijrwzw8nHz1mI30Z4saskIkxuCMUABSNcDepjnsT
	yxTmJ39A92az2gKNrGyfAtmo+MSk7Jvq2futQXvyyt7MRRSNDXj+xvNtFxZpDwZ6UTe+zc5V/No
	9QZaYgSl7RqiJaYWLTMxggLeeAchg1X1Rs3FxRhBJTH7TL6gZhaooyRzQGBMrsCRFN1Rx+gnTur
	PCuNPXuZX5eKyVUbgER21Qmyltkgw=
X-Google-Smtp-Source: AGHT+IGPxJaBI26Q/y09qEXEoJ1IfSAYTKBwEim3r875wNzdr7XXReJ2+3sYc7blAxyeynmq02rbiw==
X-Received: by 2002:a17:90b:4a06:b0:32e:dd8c:dd2a with SMTP id 98e67ed59e1d1-33b50f2c758mr10974597a91.0.1760024951818;
        Thu, 09 Oct 2025 08:49:11 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:60a2:fbdd:54e6:8eb3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b61a3cbf2sm232811a91.8.2025.10.09.08.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 08:49:11 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: clear extent cache after moving/defragmenting extents
Date: Thu,  9 Oct 2025 21:19:03 +0530
Message-ID: <20251009154903.522339-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extent map cache can become stale when extents are moved or
defragmented, causing subsequent operations to see outdated extent
flags. This triggers a BUG_ON in ocfs2_refcount_cal_cow_clusters().

The problem occurs when:
1. copy_file_range() creates a reflinked extent with OCFS2_EXT_REFCOUNTED
2. ioctl(FITRIM) triggers ocfs2_move_extents()
3. __ocfs2_move_extents_range() reads and caches the extent (flags=0x2)
4. ocfs2_move_extent()/ocfs2_defrag_extent() calls __ocfs2_move_extent()
   which clears OCFS2_EXT_REFCOUNTED flag on disk (flags=0x0)
5. The extent map cache is not invalidated after the move
6. Later write() operations read stale cached flags (0x2) but disk has
   updated flags (0x0), causing a mismatch
7. BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) triggers

Fix by clearing the extent map cache after each extent move/defrag
operation in __ocfs2_move_extents_range(). This ensures subsequent
operations read fresh extent data from disk.

Link: https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gmail.com/T/
Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=2959889e1f6e216585ce522f7e8bc002b46ad9e7
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v2:
  - Fix moved to __ocfs2_move_extents_range() instead of ocfs2_refcount_cow()
  - The real issue is in FITRIM/move_extents code path, not COW path
  - COW path already clears cache at end of ocfs2_refcount_cow_hunk()

 fs/ocfs2/move_extents.c | 5 +++++
 1 file changed, 5 insertions(+)
---
 fs/ocfs2/move_extents.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 86f2631e6360..10923bf7c8b8 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -867,6 +867,11 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
 			mlog_errno(ret);
 			goto out;
 		}
+		/*
+		 * Invalidate extent cache after moving/defragging to prevent
+		 * stale cached data with outdated extent flags.
+		 */
+		ocfs2_extent_map_trunc(inode, cpos);
 
 		context->clusters_moved += alloc_size;
 next:
-- 
2.43.0

