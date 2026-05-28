Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BC64028E9
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981199; cv=none; b=JE4l3obz2JnYMGDZEuHVVkn6ZlnrDhGqHkFXT2Zo3GHj+c6+dd6mYdjCTvqsswHFygSlhlR/1gvXnURECavWdi+ArvIaIfkMbh7bCY4xapzHFNvRCFKSYtlPKF0e5YkVAkko6QQO9Z+h5RAiTMUHRspN0g0W+240idq8LG5C9yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981199; c=relaxed/simple;
	bh=cnrMv9pFINjlIDVxwMlibIQsjXF+MWcPnxVt7TCPaO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f79mS/0lxrMBxjcW/r+xM+rBOYh/1kP+8zhgTlO0kHZYHmETvhgQu+A6Du4S1sQv7uVhEWRQT0dvoIgEgw5+ClpfLpy6JMBZY7+5uaQ4no4m0HrRSgs2pgHeinHQkX7KY+H2yGTka7BpO1yDcQ1Esa4G0yWdxP/RWld7eaQKGQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1/jrkHj; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1/jrkHj"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c801b30188dso5687037a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 08:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779981158; x=1780585958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lKyeZOhiIPY0gsvqQF5rr0FjC/35V41zMh9J4dscFOg=;
        b=V1/jrkHjwN3AA56Yy0HmNWm0krODVNwLpR7UmeG8JdvXhfopm0DxWAwQRiMYkZdqwh
         yTVIxxnssDUVJn+aQOEVyfoXRXTpyF/V9HmG4dXqIVgRuiw6o3pV07hHtNSvKFGbamBZ
         egBAgLtfUnT0f1VQSznp8A+jT42/nhAiaY6a5CZ2uGYqid8bml9Azk0e11KVPPDQ5dar
         dr7TXPGOoTGPd8jBxrKFeaWp7touwNiV6npERFqUDryl1w7d09r7O9wG8iTEJ4KmPAu7
         kLJ73aydJH+4hAKkt07Dr244z4vHcYQcJsjlZl+646ZUGmfXH6K9p/R5bkS63xwaXdU8
         wAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779981158; x=1780585958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKyeZOhiIPY0gsvqQF5rr0FjC/35V41zMh9J4dscFOg=;
        b=MJfaSYwBZV9kbQTze2+PRN4Z0HDetQa+Z9Xo+VFe53ijG1P2YxvSDkyUPLU0kP7elk
         0l482B2XA34DCgkBJWUnhmVJmyUXWlgn4ITA2X+dPrAUD0WT/LD1859pGjzqpYPQK0A6
         6SPJCHODMTeSdxwEfVvQXplFlQZuLmsHcxufbi3O3SJr0qT1VSgNwRGRJk0iPDNI4ujo
         dQsshpaUd3cYy501R6JohssZd5CSuvAuE0DjAS3x5Q53kOC7W7g1nORisdOMEan9MgiQ
         585yX7CZFYfOl/IAdjh04qNyJIIAEBEV29Lb2vrljuK8clgFKJ9V7F5gv3m2LUpUO3BY
         2J8Q==
X-Gm-Message-State: AOJu0YyZQj0d1jNIlWgeNzv+ZuXaIrDTrv/jERVucLv1ivGsIJGqx5Ax
	MH2GpPNCariKAexTQetLlXsQ3ZA9vdhiG8BEmkfVSq/77TB8JlCMIfy1
X-Gm-Gg: Acq92OGQoLObSacvX2TgOAjKHqQhNmoOva+RpXn22GjoQHpQZRYAudo5zbcK9fmGK9P
	khzdlZc7NACm15FbQQOcZtXdVtn3ZrguU0frSject6eKpTTdthQbF2pzD8LGS+w2xwN5rVh5fcI
	k555NJMfojsHYihp0ii6SYu5NQYWA9ksIUEIObVdpWFGJ+poV9TZJPWaoKE555XOcPd0LmbAwKE
	5E8zsPgdd+ggZRuPgpTbrRSXWEYFx37CV5oDNqvnbce7c8K6EMfpI9ukyutPdaKeZEsK14iQ/Jd
	XHQmuWQEktD4pyY3o2RjZSNAa/iWAD5itqiVRmO4Fvj7EyeHhAdTkq02lyyZeLaVMXdpDyM3HCh
	cdq/RKI+EsUgVEL7SVlRpO5HpanxacMyUI6n0BgJwsb7OgaoTwfidgLPUFXlQ43mmcnU6jDSCMK
	RKJiiEUPLU8jx4vJJfFrp1HpezC+5WnPPHQ6ns3SwuMw==
X-Received: by 2002:a05:6a21:618e:b0:3b2:864a:ed74 with SMTP id adf61e73a8af0-3b3293bb68amr30607340637.43.1779981157661;
        Thu, 28 May 2026 08:12:37 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852054c8a0sm15459221a12.15.2026.05.28.08.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 08:12:37 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2: validate fast symlink target during inode read
Date: Thu, 28 May 2026 23:12:30 +0800
Message-Id: <20260528151230.361127-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_inode_block() already rejects several inconsistent
self-contained dinodes before they are exposed to the rest of the
filesystem. Fast symlinks need the same treatment.

A zero-cluster symlink is treated as a fast symlink and later read
through page_get_link() and ocfs2_fast_symlink_read_folio(). That path
uses strnlen() on the inline payload and then copies len + 1 bytes into
the folio. If a corrupt dinode stores an i_size that does not fit the
inline area or omits the terminating NUL at i_size, that copy reads past
the end of the inode block buffer.

Reject zero-cluster symlink dinodes whose i_size exceeds the inline
fast-symlink capacity or whose inline payload is not NUL-terminated
exactly at i_size when the inode block is validated. This keeps
malformed fast symlinks from reaching the read path.

Validation reproduced this kernel report:
KASAN use-after-free in ocfs2_fast_symlink_read_folio+0x12c/0x1f0
RIP: 0033:0x7f5c6d859aa7
Read of size 3905
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  ocfs2_fast_symlink_read_folio+0x12c/0x1f0 (fs/ocfs2/inode.c:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x19f/0x330 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  kasan_check_range+0x105/0x1b0 (?:?)
  __asan_memcpy+0x23/0x60 (?:?)
  filemap_read_folio+0x27/0xe0 (?:?)
  filemap_read_folio+0x35/0xe0 (?:?)
  do_read_cache_folio+0x138/0x230 (?:?)
  __page_get_link+0x26/0x110 (?:?)
  page_get_link+0x2e/0x70 (?:?)
  vfs_readlink+0x15e/0x250 (?:?)
  touch_atime+0x4d/0x370 (?:?)
  do_readlinkat+0x186/0x200 (?:?)
  do_user_addr_fault+0x65a/0x890 (?:?)
  __x64_sys_readlink+0x46/0x60 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Fixes: ea022dfb3c2a ("ocfs: simplify symlink handling")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/inode.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..e54a320f35f1 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1525,6 +1525,29 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
+	    !le32_to_cpu(di->i_clusters)) {
+		int max_inline = ocfs2_fast_symlink_chars(sb);
+		u64 i_size = le64_to_cpu(di->i_size);
+
+		if (i_size >= max_inline) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size,
+					 max_inline - 1);
+			goto bail;
+		}
+
+		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size);
+			goto bail;
+		}
+	}
+
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
 		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
@@ -1812,4 +1835,3 @@ const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
 	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
 };
-
-- 
2.43.0

