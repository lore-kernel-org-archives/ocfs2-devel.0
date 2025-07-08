Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BEA7464
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Jul 2025 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751933464; cv=none; b=q1j3XvwOoEjH5Ll4MO33G95FVhvYunIzTCFPrVxG0BtvmQJ1LA1cq1V5nv2qKUfRfyH66lzOzlXZDKR+qS8j+XKcsVh5ORZ/DicOymyEAX8RL3qhMe1Wk/H70+peBAXMXvDv2WJBvBjAVwH1RIQlhLPgSYaIDdYG0FEsTGp7VcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751933464; c=relaxed/simple;
	bh=hTEgnzFsn58I7qCWXrtgfCzqxG3NFcTiCpWp5P3knE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jyutv4DChEt6sp5ZBE8BwDFS6Rn4WnLKtOGbwpK5OcBKNlRlzxQbX4UQa/xRGGIR1nAEq3i9oKSIzvAHFuIhxtCrJ/eC/m8Pvbth+q5IZybIrwKEX9ezYKpG4ffmJ4f43NrRkLSOdRfh3O5RMvdFd08wX6Lkfs6FgfnPpMTwQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgWHf9mz; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgWHf9mz"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235ef62066eso59496765ad.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 07 Jul 2025 17:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751933462; x=1752538262; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BfCZij8RJREKbVNdbJw+wlokllFTjyfrm2PqoXoq6YI=;
        b=JgWHf9mzGeGEGbAjkLyygni3E565Ean7TNa4yrrmge76p0XfvQXXgEWM8nwF07O5yE
         V5ntjP2OTw6j0WopPexAKM6mtOFBVjJ0qbRamAISr48BDWOaN5SPiDy5dSE0hTc1bYNN
         k8uFZNtMG4Bte2WbCoSkW7yZ/Ufn0taOtCz2sZdiLWwbcJ4wP+TDw6c32TQaK7L5Nw91
         PnD4UaLUP4dras9gOEW/Y+clNe8BitD+CMvyd9SJWsS3VrE9ojl90Hn6VUiKKqbmbbjN
         0yNPFUf1Jv/ASlLAIr5N6Ydy7h0o48UQ/QggN/v/eaOvJNarFt6hJGr3LFzvuU2UMShp
         A/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751933462; x=1752538262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BfCZij8RJREKbVNdbJw+wlokllFTjyfrm2PqoXoq6YI=;
        b=cIWgFNrr///6CvGXY7DO/H5D9p8wbvWnV5bul/9cDX6/zBc36igvqN1D9F/uEkdA7A
         fsQ5cWywMGRs0HfA+R6IHLKimnP5gRUpDlTkewdRY/29L6HLJKNsfNG8g29EExw+cJ4U
         Z4yFiN3/7e2JuXanZq/Z4pMXICG/b7CoSCrFmeFGRGK38+J93c3IcUoMwwf318MhwLJY
         aB0k7NNqc6AjQV1V23+rAuvIZFqRCK0dyT9h4RonkaNbsZ3np13YqWaX1Hf76W+dtQrQ
         BphvvK3MhlccTWgp3Ym8oKngV6ZfJegHyq6LLyZ2lSToi8Ydt/T4bmnp/bvagfEnwjNm
         QNiA==
X-Forwarded-Encrypted: i=1; AJvYcCUFIdsy/v6FxVk/c4dWNTUbG4uuaAMrrpQpSt+wG+uVtEZOm8f9d+9nplvaOg+9qfQurvLd2OIMJHCahg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxN1LDedNGy/arb0vyGfpj/aBh8JUuIgvEdRrF+t02he1fB2+c3
	wDt992McmSH/eme/6VytLt7SGvy2VKsaOmODSuxix0Wrx8gwKXNKce1R
X-Gm-Gg: ASbGncsDI91xmNwIb5wfY9aFVeMTfmm/znj/jquehvJGddfTDUe+o7/GcnR2mnVRbL3
	/oqenHigTV/vgBMeaqoTYBVeMD5rdcJ7C7QFCi1lurrXH30G14twVGnm7AeyY996l/rvuKeifPR
	D1UwvKfXl2YJAL4TOcxDPzCuiQYEYtFTJUfSz0Ci1vD/g95SMfDZ9rFlUKe37CtUcD+6+bqMjwx
	RewZ8ulpN+bkdVcDqY8hYo9M8LESIk2E2Ww/96YRVTC8cCmY1YWiT0HvX4bRlOxdIyv0wy0bHRc
	J5678Qg0yiWTo+0u7Xe/wpcwBg0ndQe+wL8P9FR2JmbVAwYerzPQn4sWy1Eu04js/8cd8duOH91
	4AtK3MF+cis4wqG+4qGmy2qpxVulgWHog3CZU2yY=
X-Google-Smtp-Source: AGHT+IGLVmMcadCxwlrT4ZGji6+CcJm/SC8kmOZnTvgPO526njwVB4crClOviGUc7HUtFOwFwrs4nw==
X-Received: by 2002:a17:902:ea04:b0:234:c5c1:9b84 with SMTP id d9443c01a7336-23dd1d586cfmr7340745ad.37.1751933461712;
        Mon, 07 Jul 2025 17:11:01 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:268b:48b1:88cf:6e90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c845bd366sm102928615ad.240.2025.07.07.17.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 17:11:01 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: Avoid NULL pointer dereference in dx_dir_lookup_rec()
Date: Mon,  7 Jul 2025 20:10:09 -0400
Message-ID: <20250708001009.372263-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a directory entry is not found, ocfs2_dx_dir_lookup_rec() prints an
error message that unconditionally dereferences the 'rec' pointer.
However, if 'rec' is NULL, this leads to a NULL pointer dereference and
a kernel panic.

Add an explicit check empty extent list to avoid dereferencing NULL
'rec' pointer.

Reported-by: syzbot+20282c1b2184a857ac4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67cd7e29.050a0220.e1a89.0007.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
v1 -> v2: Changed 'Closes:' tag to point to the correct bug report.
v2 -> v3: Added an explicit check for empty extent list before dereferencing 'rec'.

 fs/ocfs2/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 7799f4d16ce9..acbae902ae3a 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -798,6 +798,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has empty extent list at depth %u\n",
+				  inode->i_ino, 
+				  le16_to_cpu(el->l_tree_depth));
+		goto out;
+	}
+
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
-- 
2.45.2

