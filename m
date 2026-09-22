Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0C32110E
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 06:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056862; cv=none; b=lS1cBFdO/Y2gJgmtNaRFaHXRQDWpIvlqf6mh5ls372s8NxOsvy75kUUp/R20Riz8nraQujb2M//7MxH8qqbPwyEML2X8/W0dJTUgvo3Pf9RVuknPEZScOEanwcqHuAFcFEnqsFneGfdG3a2DMAjqT/QYZAull2lY9Utlggms0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056862; c=relaxed/simple;
	bh=jwRMV2lzKqCP4gBEUdEB/8pqORMqENAic+GrSVlSju4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S6AqVzGlkhaY300LraQSGDWFylzjtLt5odsKInJjurB8yn8w+6gkIqACrLpY/jcYlJCuh8RqhanOJeAcREJoaOWzSNRRNnqK9WDoT1jncrecqmMAiTVUL/t4idOhobLOhE3PpktN4Bjyp3KibaYGGFqtllzenHTc+trcyyqPcd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7PYHVC9; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7PYHVC9"
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc74520b20bso536843a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Sep 2026 23:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790056860; x=1790661660; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zD1+CNlJQSHstEQSAiUKt4lsgldAJyFYDs7AdpQW/fI=;
        b=h7PYHVC9h7kJ+N4dVHFXeKOLolaf2JmMUkbs35aD7rgV2Z6KwUn+tq3yfQHuVFCxMF
         sd9QVgi1kIgRo4pkDeUclDgvkCN0Ws580pLOE78MjG/9oFQmimf2kh76RkwgUZmt3xGk
         9mU7tQdIOeYve9BjxoDUlcP20Y6mPZ5ZrTtTGxF0TtqOEA3pbVk0YJtsRpppBEkZF3CO
         yrrlSNxZU6qxKJCxCm4b1HIa3tTpTN7A0zqGpZDn+zvk2iGUH66KznXFQ/sm78M83PoW
         HVHe8j+q59WZObHw4ijgvNxx+/y8BejnUk7K/h7B/po9f18uDQedb6UFHHBogOI4EO0f
         YU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790056860; x=1790661660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zD1+CNlJQSHstEQSAiUKt4lsgldAJyFYDs7AdpQW/fI=;
        b=XxaE+kb1W3n3xczejSM7cmPgnogfx4CCE+11/ZU1PKkDMVuCVu4NTHSlFVpUu0KemV
         Wegojmd3JNC40xdM+PknIeuw/iCQNPWZsyOHcJymWUWmqTWk/4qsYfWSueuDGC7Ys27S
         We6vhQJegyhL1quXUVCrL5TW/A9C98Osr1FoNco36yf1HGdL2FYPhvd4NXPgDYEeAuVR
         8GJ3MmIbFnagQePuSxZCE4Q7x3qVIerVAwoVC+P1GCDwC7pUOVr+R0ia+pBkjlCZ32FE
         kPHPnW8qoNoKtsdlpnjyfNJ24lk9LVCVj2/1Z607AkZ/8gpF6z7WCFNyLXMBhop5vA0t
         q6pQ==
X-Gm-Message-State: AFuF++ngnw/rHURJTi1GkbrdEs/AayyBzh7M/yYOvK8ou9f2B+Fa/wdC
	b8cv9p7VOqpdpHiaBLn9JU6IELK+eqUoJJI3gQtqFRZu0PbXeO6UvqRenMD7W1UN
X-Gm-Gg: AYBFou21o8RcfcNeqtaVhVuWDy4fAJV+Tk9kAVhB3Hur/ZfGUB3RVsrKNXkzuLP89l/
	nR+2l82trIb2J7sj4t+HKozjlmrH7uqpQgpXr05tVY/OD50OSbbIT6Xxonpf7L0G3IZIQEut9h3
	WzgGGyjR8BTRvvwtKU29t8XjTzcERybh0xv9lf8OBXPJ8FPhBhRLNKAnowL36NLA04x7/vI1M8u
	ziNpRD+hfOnijhPsdhzaXihMG8wx8ICar6fnGoM/RBii+GSfkt1fkyRsBOwWJbBACq13qHKZyY+
	iPl6G86frK63EEmOeXshPfa+A+8lyFWy7MdgWbOKVNudxADKRw2dmZn04RF5SVHN/7ALmea9Z46
	8AlyYPeKHBoTRid5mg239sfasUGf1tLncHtDwUUlcQnrhuVcD+kX8LDN6a5XPrQWP/BrV06ydb7
	YvyZQHcGblD2uS/NduZN0Q+Xk4ecT1fLlUMYmgr0h6OA6ZH69WP560dX0tmkCQA5lCb2YISNUQW
	AD/1BV3OboUUHXmpMqyYRc3ZB08aipUTg==
X-Received: by 2002:a17:90a:d2cf:b0:39d:feca:f48d with SMTP id 98e67ed59e1d1-3a0735e2284mr40422a91.3.1790056859956;
        Mon, 21 Sep 2026 23:00:59 -0700 (PDT)
Received: from localhost.localdomain ([202.189.109.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06dfd6705sm1423138a91.0.2026.09.21.23.00.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 23:00:59 -0700 (PDT)
From: Ginger Li <ginger.jzllee@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
Date: Tue, 22 Sep 2026 14:00:48 +0800
Message-ID: <20260922060048.13158-1-ginger.jzllee@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My static analyzer identified a potential issue in 'fs/ocfs2/localalloc.c':
osb->local_alloc_state is documented as protected by osb->osb_lock in
struct ocfs2_super, and most of the code follows that rule:
ocfs2_local_alloc_seen_free_bits(), ocfs2_la_enable_worker() and
ocfs2_recalc_la_window() all update the field with the lock held.

ocfs2_load_local_alloc() and ocfs2_shutdown_local_alloc() update
local_alloc_state, and local_alloc_bh next to it, without taking osb_lock, so
those stores can race with the reads and writes done by the local alloc
reserve path.  Those two writers predate the locking convention and were
never converted.

Take osb->osb_lock when updating both fields.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
---
 fs/ocfs2/localalloc.c | 6 ++++++
 1 file changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -342,8 +342,10 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		goto bail;
 	}
 
+	spin_lock(&osb->osb_lock);
 	osb->local_alloc_bh = alloc_bh;
 	osb->local_alloc_state = OCFS2_LA_ENABLED;
+	spin_unlock(&osb->osb_lock);
 
 bail:
 	if (status < 0)
@@ -392,7 +394,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
 		goto out;
 	}
 
+	spin_lock(&osb->osb_lock);
 	osb->local_alloc_state = OCFS2_LA_DISABLED;
+	spin_unlock(&osb->osb_lock);
 
 	ocfs2_resmap_uninit(&osb->osb_la_resmap);
 
@@ -441,8 +445,10 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *os
 	ocfs2_journal_dirty(handle, bh);
 
 	brelse(bh);
+	spin_lock(&osb->osb_lock);
 	osb->local_alloc_bh = NULL;
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
+	spin_unlock(&osb->osb_lock);
 
 	status = ocfs2_sync_local_to_main(osb, handle, alloc_copy,
 					  main_bm_inode, main_bm_bh);
-- 
2.43.0
