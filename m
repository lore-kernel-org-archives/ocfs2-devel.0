Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72B7384CF2
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 09:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711535; cv=none; b=QfjtKsiaAfFiM+QPlXV4MfZQyDbcODWWe0XO7kGGoPVRfjgLeCECHdP+bqJPChxpzP4neLqV5+fNT88GktSbLi5dkaGMkuyIj6MX4buInHXCUHo/fSYKPWZUob/aqx3XVwFcy9kyIIt1atgzeAKMYxNSHwb8emIzp+mtnhdWCS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711535; c=relaxed/simple;
	bh=xyRey8pJutA6bz3H1QdoAYJt24UmHPBc7BSHwZnKDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J0r+uVe6ICE4tEbJe4mfnVxG61+JqrAMEE8nLr/50ESCIlaGP0IFK+VinvEO3yASNf7ZOsFJNNQ4mBztz4cGMuDmMnMPzVnyHBYFRvqB/BnivdF5k95h+IT+CXNhte9yAnuo7NNpZxvStUEcP03ZhAQVgY7Y/W/TdeTalRXjjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XUNh4EDx; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUNh4EDx"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so5650531a91.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 02:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784711533; x=1785316333; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1BMRVa7z2PH8dIeiN6LIuLzoxgSG7lKiacNnhAzQbU=;
        b=XUNh4EDxKqFAW9fqAEDcxUNJZWPs/QFEKfGVQPS4gXjMHAFNR7KDSgTvM25Z2F4GX2
         4AHqu+0s2SwwKLO3rHlv2P9CfOatQJLlT28qjUVeKwP3C0kiOvpGrwEX5bxptNAe9ALe
         wDpfaIgTHJgrGDRlcenXggZaZvw618a78hvLcvzgMMWJ+sQ4v8QlCnlg7h4MMIBNQxPL
         VK6y4ZKOxU4FwW0O3zl50CHG2L3sdG7caZ75Hu+kHx4PJvz+v91YSvPsDBT+y/+jgSDi
         327sHccdRurZJu445soi581/K/cVmIQQkOi6iGxbSI26Su9cMhRJSboN0g+7q2FtjOZh
         PTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784711533; x=1785316333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1BMRVa7z2PH8dIeiN6LIuLzoxgSG7lKiacNnhAzQbU=;
        b=gFyPcAJOxgzx7XsmaO5WlaJPOScm6ayZnLC+gZV7Uyw2ZJPv3NGdBIIyNv/SYi8/AB
         JUs+JkpfhwvwjB9q/bQhVgX+Tfk80wXRPbRvsI47Yc5x+RAJ0T/K02rw6Aj/HwVHIXIR
         wmiO5Y2Lapq+q3cflCjWuo3BfnH/OmQPB2Kp1P+zW5LdOKKeBHgH6tYo33kHzk6qAlx2
         tLD6bvsmeSEDJERJ02rsW7VMKDIXPQNX8+JJmLObvBD2WvzuZkhVM8w4QrbCwTdeLl6s
         vHFaTnwxABXdtOea+kAiwKfg0gbrRv/b+X3QCD+TRvcqW7eOoBPoolhqzuLXWPDp7I68
         cPqA==
X-Gm-Message-State: AOJu0Yy5q0ETlBJE8vge24ZH76qWeP8WZNDw+T+H/CuMRaPHbzxY9Hq6
	5dCYffHFjvdtuwD/v3jc1JYS38bZKJjLA0gVoVkorOjGOR7qgmvzpt/M
X-Gm-Gg: AR+sD11ZZGWbXwoMWh1iInMFbUyrbO4+3IWYO1BolD3SgdgMiLgfjDzcI261W3rEGVO
	8AhBBEjOnxxotSxy3+z+hO+fUKIQ2MHkOwONXP98ktNNZUAaf3rMYAgS5cFQ/ze3SyggvF5vUNP
	kxMdudl5dv5h7hQnDGVO490CRJbYtd0Y8BxmYyWO8WbSyZuXQPYrW7wE7UAn53oo888AFgEmowg
	2arOvsWr/NcXGaFkfGZOoZ24GLf1ODhKircxFfoFml8QZbd+vuzaGw6s6DikWtnsawSNYUmdffs
	XZzkUqCWnCQbVTX7+KJZcUqgbyIv2qJEbmRDXPM7dy8U8pfaRoU5lqPriLo7g/9MOt9h7LqjQvo
	HFSSNIEVCknDRwHsQYgpHZ/umYpCcgHeR6rVMwxjZH7EQs5ng0L7K17HCitd1E6KjRlf8QXnO/E
	fasLoHKNzEmbM3FM4gek+NQ4hrp+Y7UAVZJnKckCa/HM4=
X-Received: by 2002:a17:90b:2c85:b0:381:28e0:6259 with SMTP id 98e67ed59e1d1-38e4b3d14cemr22448196a91.9.1784711532855;
        Wed, 22 Jul 2026 02:12:12 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e92169cebsm3031245a91.11.2026.07.22.02.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:12:12 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate truncate log dinode before caching
Date: Wed, 22 Jul 2026 17:11:57 +0800
Message-ID: <20260722091157.3141414-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted truncate log dinode can pass through mount initialization and
reach the delayed flush worker, where it triggers:

kernel BUG at fs/ocfs2/alloc.c:6019!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:__ocfs2_flush_truncate_log+0xa87/0xf10 fs/ocfs2/alloc.c:6019
Call Trace:
 ocfs2_flush_truncate_log fs/ocfs2/alloc.c:6084 [inline]
 ocfs2_truncate_log_worker+0xa9/0x180 fs/ocfs2/alloc.c:6097
 process_one_work+0x8e0/0x1980 kernel/workqueue.c:3263
 ...

[CAUSE]
ocfs2_get_truncate_log_info() assumes that ocfs2_read_inode_block()
always validates the returned dinode. However, ocfs2_read_blocks() skips
the validation callback for JBD-managed buffers. The function then reads
truncate log fields and exposes the invalid buffer to callers, allowing
ocfs2_truncate_log_init() to retain it in osb->osb_tl_bh.

[FIX]
Check the dinode signature in ocfs2_get_truncate_log_info() immediately
after the inode read. Reject an invalid dinode as filesystem corruption
before reading truncate log fields or returning the inode and buffer to
the caller. This keeps invalid state out of the long-lived truncate log
cache and preserves the validated-buffer invariant in append, flush, and
recovery paths.

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/alloc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..e36ae2e522d3 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6192,6 +6192,19 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
 	}
 
 	di = (struct ocfs2_dinode *)bh->b_data;
+	/*
+	 * A JBD-managed buffer may skip the read validation callback. Check
+	 * the signature before exposing the truncate log to callers.
+	 */
+	if (!OCFS2_IS_VALID_DINODE(di)) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid truncate log dinode #%llu\n",
+				     (unsigned long long)bh->b_blocknr);
+		iput(inode);
+		brelse(bh);
+		goto bail;
+	}
+
 	tl = &di->id2.i_dealloc;
 	tl_count = le16_to_cpu(tl->tl_count);
 	tl_used = le16_to_cpu(tl->tl_used);
-- 
2.43.0

