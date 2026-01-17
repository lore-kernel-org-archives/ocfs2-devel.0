Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12661F1932
	for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768666571; cv=none; b=lr2jWGLhjdCGTe8k5oln7UXGMixmjdSC4+6wIR9DY8ejVgqomTsSC2TCJ0pJRxouY2mhUAeMJ/zLABeu1XVXEAsERTNwjo1cuWZikyjDyQGLQEbAvL5JDxD22qFQlwPKKh2pIRUIX/GHpZYaaBQsti8oeHODMIWATZDgs9lUDpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768666571; c=relaxed/simple;
	bh=kqsWGBi7aFaKn4j7ZKU2sOBmJ/v+V/IyBmmnUMb69YU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d1n5y65ofstQPgs3HGZLvKY/IBRd6KAnXOtRRtM54zPsbAEdhgSZ6Rz1X3C+822e8+7TfFIiT2+a2VNHbE89Ryjj4QCGwhrVBAMEx91Xyzc3d53jsKq9D/Hgn0QxA6/sH0AXhJM79uBIehbL6NLg2sa3I5Cc6TvUrWPcftlcvUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWoMvLUH; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWoMvLUH"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45c93313721so1659463b6e.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 17 Jan 2026 08:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768666569; x=1769271369; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GWYOEspW5ofWF4XAspbiJ5804SDbjjJLvHgQw815IaY=;
        b=mWoMvLUH8Ts6VKKylf1cGmPv8b2y0ATDH4ctTdkRMD63IXsHtxYsJDkQYW1MQxT3Mo
         gcYU9H+yPy4rGgIllLRWESK/j8hGQbnfK0mfYkub6cMKT0UwB/XQnVxLdmIe801ycCVU
         foYcpwS6CzWGQZQtGCJ3jPwZt0/cxwzC7R1Wt/dC5X9cplwj3lT/hyWeRXj26TzB42Eb
         yg4hBMeplu7J2uvrZIZl+k2VrtWdzkPYeZfTpp8fjtgJzO1haTRfCluwXrkmRUr3E+Za
         SvahQLG3w9WwHmE9Y6UaxOX6pKtz2v9TuPHxcOhlVCqouwa+fclArNdQopD7Fsz66dOt
         8Gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768666569; x=1769271369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWYOEspW5ofWF4XAspbiJ5804SDbjjJLvHgQw815IaY=;
        b=dF8aHZDbHaUqQCNf+T+0qgeII6n2B/rHn7flp4ki60Nrkix2ZIcCeFYAduQakChAqu
         +gbsG4PIKdk6IIvQQlX8AEzSStiq7TYZR2kcQGHd8u+exe0e37djKIjdrxKISv6ge7C4
         bZ2fQ/P4UAw7fZOn7H37l4eP7RPM9twKHQ/s7yrjc6S9btZXzFjGKUbss0Mfk/FAQuXS
         F8lfYpkeZWGebt9dDX24HC4zVBN5gHbE8pwDu2VzAs+JpeZTmPxFYOx90X+a1lYuFFtG
         zlmgSesDv447kOSv3udiTu93DeXFWS79/Y5Zup3pMxN6UemzJKJuwg8fSndFRd2VdeFQ
         yPdA==
X-Gm-Message-State: AOJu0YwyqdK2n3xjF0d9/bkQUaFXnyiT3Bf+M1HiVEewKuos0ANeZWo/
	Edr/4xhtXZU1T4udhyuvHIUMRZfHysPU625dR79m/zbGKB8jxTPSQHLp
X-Gm-Gg: AY/fxX5k6sAsa8cQAEZyhx1aLRk6QvqPO/Ip5N+p2Mk1E+AZaIESYrlGDgqb6e4PyIE
	BS4isc8/3elk+hmkGUJWlIMTD5MCXPWrnb+bUaBqSyL66PxT9iqrQ6sDgnIl7mO2lsLBpwJ8zZ3
	zy6cbm6FChpgGHGqiFMLGV12tBUov5kMf9AejakDkzbJDylt7xXWI+AL96+/mgUBh0symkWVIMN
	dkfQt3fJ4mCquewqDyXKAJUo1ws15HcH7oz9Xqq0XS/KXwXwzVKRd3r3tztuz0AswHXMNtwvkF7
	VzWR9gn3vxCquXHr3rWKyoeLvgSqfeAhNAshvkzgOJplRmC/q/xDLR0olqi3aA72CgSRbGTLn6H
	evD1p/4o8FJyVe9ws3ehw65g/avEPgWpWP6fqQrJN7RY2Atzh0CIk9988lct+THGyV5UnatFhiN
	NUrJPKBx0MJL0aQDm7j1OR5fnASoMF2q8m
X-Received: by 2002:a05:6808:5398:b0:450:d120:fe4e with SMTP id 5614622812f47-45c9bf7abacmr2747719b6e.27.1768666568696;
        Sat, 17 Jan 2026 08:16:08 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9e03e817sm2994610b6e.16.2026.01.17.08.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 08:16:07 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] ocfs2: fix NULL pointer dereference in ocfs2_get_refcount_rec
Date: Sat, 17 Jan 2026 16:16:05 +0000
Message-Id: <20260117161605.30291-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_get_refcount_rec(), the 'rec' pointer is initialized to NULL.
If the extent list is empty (el->l_next_free_rec == 0), the loop skips
assignment, leaving 'rec' as NULL and 'found' as 0.

Currently, the code skips the 'if (found)' block but proceeds directly to
dereference 'rec' at line 767 (le64_to_cpu(rec->e_blkno)), causing a
NULL pointer dereference panic.

This patch adds an 'else' branch to the 'if (found)' check. If no valid
record is found, it reports a filesystem error and exits, preventing
the invalid memory access.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 fs/ocfs2/refcounttree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c92e0ea85bca..464bdd6e0a8e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1122,6 +1122,11 @@ static int ocfs2_get_refcount_rec(struct ocfs2_caching_info *ci,
 
 		if (cpos_end < low_cpos + len)
 			len = cpos_end - low_cpos;
+	} else {
+		ret = ocfs2_error(sb, "Refcount tree %llu has no extent record covering cpos %u\n",
+				  (unsigned long long)ocfs2_metadata_cache_owner(ci),
+				  low_cpos);
+		goto out;
 	}
 
 	ret = ocfs2_read_refcount_block(ci, le64_to_cpu(rec->e_blkno),
-- 
2.25.1

