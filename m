Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FC629D288
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775197835; cv=none; b=BMJGg44udjgc8JPS7XsieJxmjeTeF75MhZeTppOlILwJ31R1jf0Of/hKSZTbbZ6hhUjT+nu7ylgv+2wtI+WsjPZHDlPCtX4TcQbDRAPYSKrVHycMRoke/ua49+g5iPHn19KVHE/paicscoYuKPsL4E7chKctBiAH3X6vJw2QqJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775197835; c=relaxed/simple;
	bh=wflK+Q0rdwZILUEehzxtt+ZmI9qWCqp2RSyvZDs2OvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSfiM0ymrtOCg9glfgC0NPKX+omeOU9C8Q3PfSG1pkfBghfHL0v1xA0q6gkrVSBt5uvEpV9VFes5daFXj+4zQ1p5tWTsFeMjxa6ylj1JsVXQEzGAuwb2WDSlgt2s8Q3Fuwon9DwDvytHuQWfsdfgF6RZMKEPUhYV2DgsQxxAi50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7Y019mX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7Y019mX"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82d029fd52eso768251b3a.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 23:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775197831; x=1775802631; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNcCckldB93xLM/JDGzLlnsXuLvNw7uNddJEgP2ONrY=;
        b=Z7Y019mXQhD+khwFXZqpG9Ny63mtGuVvRHZAlSUk4ZPYjQoBjImaW0yMBeGzYoI6nz
         FHZPD6OcqLVtb3yxfoafWQDHTPsVuVpV8ue3xvbmesmvheK/ZhVN6JlNux7kREsB1MXW
         zAGPZoru3OwRepoQmlYTpvYS02tKRaT/0gCyySHpqwTwLjy7GUE6yTAYWchGivBvsHNM
         +FOCF869Ai737yDQgrrxiWuqri/wp61L94+A62WkijNYqM5Hnuy/Wvm+QELKG6J8HapF
         cIipWSe/LTdkLfJkvYuxlDYw13yPub1qd1TJV1WSMZQGTDRJ7A0HKl6cHdELfYk5k6XG
         d/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775197831; x=1775802631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zNcCckldB93xLM/JDGzLlnsXuLvNw7uNddJEgP2ONrY=;
        b=eZbyvG7AMVqWFlJJTOAzVvOLMaZpmaBd+rbRf4ocLQgoVCAJfARKqhbntgerPbPcX0
         phKSHmLTVanSyNAhm7Ixtxotl+iVePRw4CtcNoll5wEvSOHXEnCJECRw4vePLu0DeA7+
         D7CG3/Kzjhj0ztszmkqR78wB72ap8rPWi9nbm+vQfFBsHQvECazCNt95c23ItlgigYz9
         n2/w20a2ovNxXfpD3p2dFeqr5kUnpCx7ZZKw53u6gVzcnPeRr0U9K0UEsfdTul6GAtW2
         WbfZHxDyBa6BZr8xrTfNAzWB4kEYtLm5xou9+/XlwgAH7dlEjJAtGZ83N8fLAFAUQ4Ea
         HOgA==
X-Gm-Message-State: AOJu0YwpOHEjakXHiYr085yaf2J7SK/3E69y9slqzGVu/zBUoEQdvcnd
	5tvewBQHNgTuuJKND200HKa8Yc8EepMTkUIt27O0m/TIBKWovKljlp2r
X-Gm-Gg: AeBDietUpxxGb49uszFC9JokE4xYESss0uubRiQfO30p2gmyeSBS9l8/gZzzGLUKyFx
	ci3A+HuRv3XXvxnAn5lv1DJFfZU3ZUA/Q5R0Bwq0I54eOESvu6rLBOAmFQvBi5xCviDMK4Nnf09
	DH0DGsoPdlxI3zq0YhLV/Wpxz13f0KDHmSxrADyiwCGE/pcRIKJLFP3vcyZQC0bi4IrJtt4HFX3
	huTmaujfZWrnN0gh/ASn9rww+ZFqEBf2/CKhtt8lQKUKqikwtObsgBhF8z76Vpxlvo2rUQWNKAb
	cGbFhdCrs7bxt958OlNqi11bfEAyDzVqbFKqve90NKSETsQdMNhCPDR6jHTXgNv6Di5FzqPUhwW
	1CB+Ey1ynz8wRH49lHYV3rpVjhZvGLNNIVtUcqvcmzVX0HO2HxSiHLlX8io1i/XScxt+a/a0Nxh
	eM749HUO1kJz0MmwE3/PdjKl68XVXXsFBCWYMnaXLvO03TQj2oO0lDL6tZ/TaIMwp27nNGgtw=
X-Received: by 2002:a05:6a00:909a:b0:82c:77cd:50e8 with SMTP id d2e1a72fcca58-82d0db7e890mr2033087b3a.27.1775197831231;
        Thu, 02 Apr 2026 23:30:31 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41b8dsm4572258b3a.34.2026.04.02.23.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 23:30:30 -0700 (PDT)
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
Subject: [PATCH 1/3] ocfs2: handle invalid dinode in reserve_suballoc_bits
Date: Fri,  3 Apr 2026 14:30:14 +0800
Message-ID: <20260403063016.438287-2-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260403063016.438287-1-gality369@gmail.com>
References: <20260403063016.438287-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted filesystem can feed an invalid dinode into
ocfs2_reserve_suballoc_bits() and trip:

kernel BUG at fs/ocfs2/suballoc.c:806!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_reserve_suballoc_bits+0xccd/0x3e00 fs/ocfs2/suballoc.c:806
Code: c0fe488b 9d58ffff ff4885db 740de8fa
Call Trace:
 <TASK>
 ocfs2_reserve_cluster_bitmap_bits+0xe5/0x1c0 fs/ocfs2/suballoc.c:1134
 ocfs2_local_alloc_reserve_for_window fs/ocfs2/localalloc.c:1108 [inline]
 ocfs2_local_alloc_slide_window+0x2cb/0x1570 fs/ocfs2/localalloc.c:1244
 ocfs2_reserve_local_alloc_bits+0x654/0xa10 fs/ocfs2/localalloc.c:669
 ocfs2_reserve_clusters_with_limit+0x785/0xe40 fs/ocfs2/suballoc.c:1168
 ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1229 [inline]
 ocfs2_lock_allocators+0x319/0x520 fs/ocfs2/suballoc.c:2772
 ocfs2_write_begin_nolock+0x256a/0x5f30 fs/ocfs2/aops.c:1719
 ocfs2_write_begin+0x1b6/0x2e0 fs/ocfs2/aops.c:1884
 generic_perform_write+0x409/0x8c0 mm/filemap.c:4255
 __generic_file_write_iter+0x1bb/0x200 mm/filemap.c:4372
 ocfs2_file_write_iter+0xa87/0x1e10 fs/ocfs2/file.c:2469
 do_iter_readv_writev+0x61d/0x850 fs/read_write.c:827
 vfs_writev+0x323/0xca0 fs/read_write.c:1057
 do_pwritev+0x193/0x250 fs/read_write.c:1153
 __do_sys_pwritev2 fs/read_write.c:1211 [inline]
 __se_sys_pwritev2 fs/read_write.c:1202 [inline]
 __x64_sys_pwritev2+0xe8/0x160 fs/read_write.c:1202
 ...

[CAUSE]
ocfs2_reserve_suballoc_bits() assumes ocfs2_inode_lock() always returns
an already validated dinode buffer. commit 10995aa2451a ("ocfs2: Morph
the haphazard OCFS2_IS_VALID_DINODE() checks.") replaced the old
corruption handling with BUG_ON() under that assumption. However,
JBD-managed buffers can still bypass inode validation in the read path,
so corrupted dinode data can reach this function.

[FIX]
Treat an invalid dinode as filesystem corruption and return through the
existing bail-out path instead of BUG()ing. This matches the nearby
OCFS2_CHAIN_FL handling and keeps allocator cleanup unchanged.

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
 fs/ocfs2/suballoc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..12ac2bb3f10b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -801,9 +801,13 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
-	/* The bh was validated by the inode read inside
-	 * ocfs2_inode_lock().  Any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass inode validation. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Invalid dinode #%llu\n",
+				     (unsigned long long)OCFS2_I(alloc_inode)->ip_blkno);
+		goto bail;
+	}
 
 	if (!(fe->i_flags & cpu_to_le32(OCFS2_CHAIN_FL))) {
 		status = ocfs2_error(alloc_inode->i_sb,
-- 
2.43.0

