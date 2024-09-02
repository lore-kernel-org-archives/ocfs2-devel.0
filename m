Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500D179C0
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 03:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246531; cv=none; b=T8JAAOH9uPbiqb393IXxT3gH7CQGOXdBy6P4QMXQ71uTJxusVVlVx8AgkEvnseBYJyp3udLfJ8UvybraZF1TnT/fJ8lXozlS1gqiDDySnfk4HOJvBuqWY5mQidCcJ4dwLFMOPj0AO3LT8VzALrwJEcRTEpOPgrntLuiNmgBr3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246531; c=relaxed/simple;
	bh=QgygUHAKHCBT8wUNzgm06cGt7KGNO6oTMgxf+I6ny8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CWnlj5nlohDQyRRtBTwL+yI8wSu3gvlqLRPxQr9E/83YNjAr9xDAMMGr2MTXPXkoTs5ly7Sot2kr6oVJruBQyBy/IilL/DepJYnFJFe9xgT+y91qKXh01k5cF/nARzo/bCuFRjIUa2uQi2LrMee1QYdcFWnErTXI1j7+/i/c1l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bve+m7Vm; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bve+m7Vm"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d8a4bad409so751996a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 01 Sep 2024 20:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725246529; x=1725851329; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nxrJTJ8Dz7d7J+Arq3ApPH4BCk3UJuJHb1WQaif1NjY=;
        b=Bve+m7VmkRFjBe1Hqs+mVDxzA2wAHgq/MN76mQIP7qmMMiPfRhtyluEzHhtNnd2zlD
         FRzp9zxElAcG+tzWbLuZccK7gE64in2jkW8yZsrJdKwf0k+M+vp1lcUMTgpl9ZkbvHcV
         s5mdU8y9V9BokxeMHh/2u59NO8KSs7QSaTNmKJG7jcXaLmWI/VIkxcx/h/1gMHl0MUjz
         mIgltIP2UtgqYnIx71p9lPNG8qxiGc8GV9ukaJRDCaenZ4QGZwgSfKNSpZqfZEhu/Adg
         YhE5U3eWif669Tn47CTrYVR2VO1vAKRBhssbQmBkk9Qm6hnJrBxodOVe6EH1GzuPPgOa
         cdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725246529; x=1725851329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxrJTJ8Dz7d7J+Arq3ApPH4BCk3UJuJHb1WQaif1NjY=;
        b=fdOmCDSJRMs1NIYWe4ycCdwqwmWYis6+Hi8JCakPdPnS1Vs7dTO1MIJ2xfdHXKtH5k
         WnJE1WE1/KJENW7rWb1HTSl7HdTsBtyHsQVM7traieLa0C7JjKcXWWkgzxkTZlMdcXs4
         cF/IOWPyLZYKOO4lzyD0GYioXokWU8sYDFpXUN2YTFQFD21FhavMJvY8Lo7J4VjOGzl5
         SyPZlcrNlxJosnnthPPz/K0MN7k4AXRFS4BLyOazttqOysBz/de12mHblfnQraUUHJxo
         W9VmDk6WR0mDN2nFyd/iPNYYaSs1i348PhJrgy+XhiZmWE7JP7IpyGnN6s/NzDKZKnIV
         4/wg==
X-Gm-Message-State: AOJu0YzK5pjaJ5zV8jqzkAH0GA8nV7QDhudqcrkUr94rgr5xBQiUWTfF
	0f71o+MShoDmrO8qaOf1eTyWx/vpxkbwDhhKFOyY8zVwsgGX6qO4aRwV+A==
X-Google-Smtp-Source: AGHT+IFgwtPiVXWqJBw/Z9Qf9omq+0X2R6nqRTPviBxiK64p+EOy8c9IhQMGKNFuLMy+jRj2eUOgnw==
X-Received: by 2002:a17:90a:df11:b0:2d6:1c0f:fea6 with SMTP id 98e67ed59e1d1-2d893492f8emr4642349a91.11.1725246528877;
        Sun, 01 Sep 2024 20:08:48 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d22e7814f1sm5522571a12.48.2024.09.01.20.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 20:08:48 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Subject: [PATCH v4] ocfs2: fix null-ptr-deref when journal load failed.
Date: Mon,  2 Sep 2024 11:08:44 +0800
Message-Id: <20240902030844.422725-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the mounting process, if journal_reset() fails
because of too short journal, then lead to
jbd2_journal_load() fails with NULL j_sb_buffer.
Subsequently, ocfs2_journal_shutdown() calls
jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
__jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
->lock_buffer(journal->j_sb_buffer), resulting in a
null-pointer dereference error.

To resolve this issue, we should check the JBD2_LOADED flag to
ensure the journal was properly loaded. Additionally, use journal
instead of osb->journal directly to simplify the code.

Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/journal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 530fba34f6d3..1bf188b6866a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1055,7 +1055,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) &&
+	    (journal->j_journal->j_flags & JBD2_LOADED)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);
-- 
2.39.2

