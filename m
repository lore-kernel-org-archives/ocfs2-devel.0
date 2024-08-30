Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6B417C23B
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 11:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016141; cv=none; b=HuEJxLAyzy3f76lO93oEZXaiYxy5yjdiXhCeGOe3ncqfVwijMLrRgLXQqU1pee6x5yohRVugRaTUsWkKEWHbFH3WOX+vqKcmxWpLGyXQg47pHNyjrAPI23kzz/mRGERhfUPpPloYfJbAItklopcVDQSlRWTGrVkLEmzIT9hZpgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016141; c=relaxed/simple;
	bh=BXH7oQFa1BkQNEhRUmB0d+RlfKGm8jUoGBYipe+CMRI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZzC3qEXZt4LMioDAtrNeoX2OR446ikDhk+BuVtY0HsdLUiUCp+uzvDMvK99DVfW+YHm/uLQf8Tp3OYc5n3fNDxEMUjz2uyBKfvKS4AC7ITEeb2EfVXY/EevdclV0WlJNCwrWozvq740L7LNA+whQ2pEGNaJDyRpAFgfqRPYMVa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XriuAAd7; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XriuAAd7"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-715cdc7a153so1322576b3a.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Aug 2024 04:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725016138; x=1725620938; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dLHylnpFujycFzXkW0LgR9VaRhu8drA9Pb7mOyGmzoI=;
        b=XriuAAd7LnzX9kMgv/rCU0bhpppav2m90aisbM2zCECt/t9vDj5KrisAtMv42A5e0Y
         2pi/KWVMrRGn67p3RvImnAqZpty9Amxd71piPKqm9egegbqjd+AU6IKpFNAcgwpMlCfP
         YxoaJxUKmD1wefDalw/zikHCTPz/eopGyV0+SIhz0WblPAxJgDuS1Bx0pTs+z1ESUjuZ
         vpBzciwCM6cQWv9kkff0aNcDwrdnjkpCdrOrfXX3ge/75x4EisLDqfFmc5WAu54bB5Sf
         2PEn6JBsg5hV7q8ZAdfT5RmuNS7zkdLPt4mX3FMmuVqoA7Udq++BT2DNlcKmWp0Fo0q4
         1+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725016138; x=1725620938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLHylnpFujycFzXkW0LgR9VaRhu8drA9Pb7mOyGmzoI=;
        b=BwX/5fCYITVB8Ahv92JUKq78/btN8c+ECd3v/2fgL/+4ZeV/wx1u1YQ6jfJfnvU/KV
         k0Ly+uCwgoeOFuCKbeZ/BSTEWCEnY0K/eYd3HqXlNkPtLtfcwGjl3Kc5ycxi6osqN4YE
         SL9yr7C2Dm0sej2TNFWauTv0KZ7ZhVQZoTtSvtWerdY1TFiNZEOlJf6IljSS5KDiqPFb
         ldIhfyrmemgT9GNfDEJureaqdGvA5cmY2WcXBf3JmucrXzSPudgP8N3nbRD17VHOpsJp
         6ggIa2KmZiXRIfjbYdyIw1TFAQAjYmwwtgbQW27qDv5bRKHrPzvxiAeh83AoEyIlza3W
         F7SA==
X-Gm-Message-State: AOJu0YzU5YZklbSEFRa0oXAgUYkNCv0+XHf/4ERJmOoxzipEDAaHVx8Z
	jIlaRsaMwHhlBRTqo6iYdeixkhEvxNkJCa3aQSMEY73YeN39O/H+ZIZ1N2C+
X-Google-Smtp-Source: AGHT+IG6lFP+5yroOBcKg2tixKoHSo3foGxI6t+Neqo/Hx/PpiJupGyMP4nw3wtEKQH2OkREW/Zh4g==
X-Received: by 2002:a05:6a20:9145:b0:1cc:e86f:c0eb with SMTP id adf61e73a8af0-1cce86fc4b4mr6398232637.4.1725016137950;
        Fri, 30 Aug 2024 04:08:57 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e5576d7bsm2531827b3a.30.2024.08.30.04.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 04:08:57 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Cc: joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH v3] ocfs2: fix null-ptr-deref when journal load failed.
Date: Fri, 30 Aug 2024 19:08:53 +0800
Message-Id: <20240830110853.101060-1-sunjunchao2870@gmail.com>
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
ensure the journal was properly loaded. Additionly, refine
code to make it cleaner.

Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/journal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 530fba34f6d3..ff2a6538b46e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) &&
+	   (journal->j_journal->j_flags & JBD2_LOADED)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);
-- 
2.39.2

