Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF67B34D916
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Jun 2026 23:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781997153; cv=none; b=S6aAKFGg4N4WAxdU+lAKglvwKKm96H+UeJgrtaknHUM9ADYw9/aNcMJ2LcEnftiBCQONERXWFqpWMQVgmMsZ4SWQNey4KOHAxx9Ilx7HtP8Qgt6ng/S/0bJpdF812xjEMSQvrDroJdrJEve8wauyWx4Cl/d+wLvmQwZNmdQ7GWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781997153; c=relaxed/simple;
	bh=7JKBQscbADx9XJYjyDEXNS6QpIOsMcu5IlMdsQMS4Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LkAkKz38zJQr1CbeXZwrP8eqGB9EEmB2OuCajHL2MjuthUJe9ql/8SAWvInzAyzf+yyeuhQbxyQyWgzljiHoPerEvIIGzU3r1tRDVHjUVlqrcl5xR5VlYgg9wDX1L2xT0tw6/c2QvymlOI9BJfGMYsTwY8xEjmcGygrgFk8zy0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mL3j0EMi; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mL3j0EMi"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-36b9ec98144so2259313a91.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 20 Jun 2026 16:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781997151; x=1782601951; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X+O4XSY8U1nMvC56zi8qaEb9yuRuuISaoBUDpIJeGlA=;
        b=mL3j0EMivtuN3DqRLMEu8MkG00pQlqGCcV/HtwBR2YWMzAp5WWePrIf4SqVDgoQ1Tf
         NOUszsBz25L3UNkdocdp+ki/lDNtRm8lcjXGCQW/ZjgDpWEqWWm2iXTNcgtCcZBzIdhD
         PoJ+kiCjkIGM+HsoHDaBXVR5DVQV0k44wsDmjfcId0KUxt6Rx3VzPt2lNsxc9YqnT/cx
         l7tuwyQn2NYmBwYMw+BBpHYWvzDjWPYw+SKG/leb5F3651jNFEiXxqRURBDOd88bx/7Q
         ge2r7rjXUXpfS8JUEbXIs7zy8OwdHWXp+vl1EprwoxAwCzHczkGRc3uAt8hgoxkSS5lr
         b1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781997151; x=1782601951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+O4XSY8U1nMvC56zi8qaEb9yuRuuISaoBUDpIJeGlA=;
        b=GumtrzBjGZjKfNrTz4gb6+5EsKucIM/eLv5hqzFfPVnbMyJg2FR9winDlKnGZFwivY
         dVUfEBobcyIu0JmA24VsA7iTfD+jsSE4aPrmcCZj5h397U68eacZ0l2hYJtKjWhd4Dgy
         y2qBZXtiqcaagWQI5HwBMojGCdRDxephtnt0RrGejEeZGkAmz5/6y/AsN1IUcqqkCJfe
         uwRxYfjLr9c7vGKJ5sWRzhEezbjSkVIcdjXBrgZgvxCHRWtz5nAnaktLao+SQ5AGM7Qe
         C2FdV6mjoh0zCAyHMgJprcGGHjQITkItLteNqb8Kl9JmZnDtG+Wub1tvlxcGtSsQ8o7F
         Exhw==
X-Gm-Message-State: AOJu0Yxdtj6tNFlM93/aBOL97cjfoCnntTJiOEwa46VLnljLpJfxAkP7
	xJdwRQ1RPzsElIADR9G3u61zF8TCbSqGw8PZWiynu2NWwq3xPQwxHotI
X-Gm-Gg: AfdE7clGavsdNTcZOpC61vm8H0MKZFgYYIAStpfAumacLLa+WqqFpOogZDYQ2Zgrmxk
	mH6UTeodq1FP789pUjbcBrUpmd51Fa8i/9LIgiGTapGIua5n9BW9wdHhE1vLIMEBX6Sd0OE0MzZ
	O09JQ1HwOkWmtA9HXe8o8mAuMMraPmdSQquhxJbxW5RxNRM0h/VmehAvBmy+IImlyfz/v5VRL2M
	HLEyOGKSGTGsebL2WCOdA/DUCUhmy8PwOdtGoYemuyAh3mt71yg2AeVgv/i1l2g1wO/fNyhhRT8
	OvFQt49wHlbLnFv8f52b/O/MYaIMGGVuxWV8nStQBj1IKfNNE7YuFS/tkf1uiZNN99I2czviPxh
	EonXfGp89sY8nNL/OtO1pjM9Ph9SEjnftebCSZnSgQXk1nS7e5/HhQCL3czWlPBfOIjOy8SXqSQ
	BlW1ioY4o9wQC3zCAChnMqJn8UMyP5SxpJyHzRvlOPenqeMSMqgsICiqB9/HSdcEC8zLFQ
X-Received: by 2002:a17:90b:5746:b0:368:b01c:85a0 with SMTP id 98e67ed59e1d1-37d4e438c1amr4335263a91.14.1781997151088;
        Sat, 20 Jun 2026 16:12:31 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:6622:5068:7fd9:7931])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f2d2919sm2982012a91.9.2026.06.20.16.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 16:12:30 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	willy@infradead.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: use inode_lock_nested() for orphan dir locking
Date: Sun, 21 Jun 2026 04:42:23 +0530
Message-ID: <20260620231223.46588-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PREEMPT_RT's rtmutex PI chain walker warns about a lock dependency
cycle when inode_lock(orphan_dir_inode) is called while holding
inode_lock(file_inode):

  ocfs2_file_write_iter()
    inode_lock(file_inode)               [class 0]
      ocfs2_dio_end_io_write()
        ocfs2_del_inode_from_orphan()
          inode_lock(orphan_dir_inode)   [class 0] <- warning!

However this is a false positive. write_iter() is never called on a
directory, and orphan_dir is always a directory, so these two locks
can never actually conflict in practice.

Fix by using inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2) in
all three places where orphan_dir_inode is locked in namei.c, placing
it in a separate lock class so the rtmutex PI chain walker understands
these locks have distinct roles and does not warn about their ordering.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Reported-by: syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ce129763ce7d7e914739
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
Changes in v2:
- Replaced inode_lock() with inode_lock_nested(orphan_dir_inode,
  I_MUTEX_NONDIR2) in all three call sites in namei.c
- Dropped incorrect v1 changes to aops.c and namei.c that
  restructured lock ordering, as the deadlock was a false positive
- Approach suggested by Matthew Wilcox
---
 fs/ocfs2/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1277666c77cd..4cfd7b3d3e1a 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2126,7 +2126,7 @@ static int ocfs2_lookup_lock_orphan_dir(struct ocfs2_super *osb,
 		return ret;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 
 	ret = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (ret < 0) {
@@ -2725,7 +2725,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
 		inode_unlock(orphan_dir_inode);
@@ -2838,7 +2838,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 		goto leave;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 
 	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
-- 
2.43.0

