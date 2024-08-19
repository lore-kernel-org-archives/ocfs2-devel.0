Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520A16B3A3
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 13:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073089; cv=none; b=a407cTHE+TY9bbNpx7lgbqyjyicOZE8r1GLMloLTeZ/26eFTzlJvtuAZa1gS6DH/x3iSgdVjvk2MbvOEuJYdgapNoAj/pBDvg3HlDYbxYJUIEpxKo/KX/yHtvyd6OdFqlyfns3QIhzr0R0wig910j6VkMBY1fhl27lC6SGB7wBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073089; c=relaxed/simple;
	bh=suzaPYG/weqSOyhLJ0L0JtHHz91FJ7ZXmaT1QE7YYnk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TZWwsazyfikljymqj0tLFxq88cynSxDHBm7/j0PO1igQUpUVBu2cLJuklfLg5FVBIPPEyWH45kD1pqGJ9AA4NUQxjqZSZoKVpnZRnZZYlp49lUIezWWkktk8c8MH2gPGuYKcZKmq7h/I6pIOVAOGMPFax97pgUCf7AEipmQExvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNLb4Wkx; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNLb4Wkx"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-713eeb4e4a9so788120b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 06:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724073087; x=1724677887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBV7TCWuwtomXpd5sanZarCcoUUz2ISjrDZTysH76E8=;
        b=lNLb4WkxOUsTDY9j0F6vcPeB4+/LF270bZ+1bNck3cXsSxHBI36mDSCYaLg3trRXCS
         1gmzjbIayaqaQyGrWSDWI+nE1CVNHFH0oSfvrd5i6Rm9xfPe5m6teRzVxEleuGkUY+BO
         VWYOnYhYWrbTo9gE0jgvYKbOQrXqb4X+eCjO31biiw0Nso3WXtRIm85Ndsi4CB1pejl0
         c5g+CVNRlC21LU38LzffOBXuMVsi/jphx+0ewqdkzJ8ealqw7X4L/9ota0fCSqonXrV7
         gkWgDv+Am/TCVZtbyYJwlpeWlb8IBAnDeek/Ln80zxY0bNxubgai0SRGMPqCRv/6nKxL
         u+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724073087; x=1724677887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBV7TCWuwtomXpd5sanZarCcoUUz2ISjrDZTysH76E8=;
        b=LjxnwwN5epzaxZPIseV2gGr2Yv+JXDd0ogDdSQrvQbo+8XFmuCEDqhjjRm4UyY1BF7
         P92cXo9MEaQDgFfzfMQS3S38k74TINMwhQETIgETaWCvloCeNqqQTPyZxXLlKaf5Ep8l
         dDqkg6dCxXmcDGn2UGi5UNB9A5pki2/cCL9s8uQ1DkUfj5XnbufVJAWL8Uddx0c9gUmS
         aJP7tRWPFOU0YLzNioupJUC7JMmk5zfkGg8mXSLGAf7RGd+DYmYKK6ubKnEYzk8CpGH/
         BBpDCK4o9SSdJ8yoTo4vLzX8raOwPUNJ0GuRZ+jvK9Py8Gmxqj9vdsjAiN5MOZQtKFwg
         HhDg==
X-Gm-Message-State: AOJu0YwozNuLfq53ZF6pDoz+BrfUSvn+Cd11iou5pzjNCDMSNauCWqYA
	PKclO3obO9aqVBGQiGxf3Oz0hZ/mGPStuFGOvxBNTDOP87W3U03qLLcaq+FP
X-Google-Smtp-Source: AGHT+IEXBbKX/k0hjnYmgZLAkYCHe9VDb0i/5hX632wKof0WnfLcnszEDG1yJnkAgEshkVWIPLCDfQ==
X-Received: by 2002:a05:6a00:10c3:b0:704:1c78:4f8a with SMTP id d2e1a72fcca58-713d7ce86aemr9433356b3a.21.1724073086986;
        Mon, 19 Aug 2024 06:11:26 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af2b942sm6571518b3a.183.2024.08.19.06.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 06:11:26 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix null-ptr-deref when journal load failed.
Date: Mon, 19 Aug 2024 21:11:20 +0800
Message-Id: <20240819131120.746077-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During the mounting process, if the jbd2_journal_load()
call fails, it will internally invoke journal_reset()
->journal_fail_superblock(), which sets journal->j_sb_buffer
to NULL. Subsequently, ocfs2_journal_shutdown() calls
jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
__jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
->lock_buffer(journal->j_sb_buffer), resulting in a
null-pointer dereference error.

To resolve this issue, a new state OCFS2_JOURNAL_INITED
has been introduced to replace the previous functionality
of OCFS2_JOURNAL_LOADED, the original OCFS2_JOURNAL_LOADED
is only set when ocfs2_journal_load() is successful.
The jbd2_journal_flush() function is allowed to be called
only when this flag is set. The logic here is that if the
journal has even not been successfully loaded, there is
no need to flush the journal.

Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/journal.c | 9 ++++++---
 fs/ocfs2/journal.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 530fba34f6d3..6f837296048f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -968,7 +968,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 
 	ocfs2_set_journal_params(osb);
 
-	journal->j_state = OCFS2_JOURNAL_LOADED;
+	journal->j_state = OCFS2_JOURNAL_INITED;
 
 	status = 0;
 done:
@@ -1039,6 +1039,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	int status = 0;
 	struct inode *inode = NULL;
 	int num_running_trans = 0;
+	enum ocfs2_journal_state state;
 
 	BUG_ON(!osb);
 
@@ -1047,8 +1048,9 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 		goto done;
 
 	inode = journal->j_inode;
+	state = journal->j_state;
 
-	if (journal->j_state != OCFS2_JOURNAL_LOADED)
+	if (state != OCFS2_JOURNAL_INITED)
 		goto done;
 
 	/* need to inc inode use count - jbd2_journal_destroy will iput. */
@@ -1076,7 +1078,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) && state == OCFS2_JOURNAL_LOADED) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);
@@ -1174,6 +1176,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 		}
 	} else
 		osb->commit_task = NULL;
+	journal->j_state = OCFS2_JOURNAL_LOADED;
 
 done:
 	return status;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index e3c3a35dc5e0..a80f76a8fa0e 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -15,6 +15,7 @@
 
 enum ocfs2_journal_state {
 	OCFS2_JOURNAL_FREE = 0,
+	OCFS2_JOURNAL_INITED,
 	OCFS2_JOURNAL_LOADED,
 	OCFS2_JOURNAL_IN_SHUTDOWN,
 };
-- 
2.39.2

