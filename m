Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16413D8A0
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Aug 2024 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724401918; cv=none; b=lQSBU9oi0DI//J7Z1QTfuoCY20CEbcBH1kfE4GiyhT1h1/WLhTqKn7s8clpJTklhwWOLcbx4Vxtt7LXR2M2HKUCUUUS4+PThNw4rtiEj2wu7oSe71uqMaKmVcMu3RNq5s2hNVBn5LNYCVDLkhdg5pWJcFgpFII5OitHtnA2K2xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724401918; c=relaxed/simple;
	bh=9nOzkYzQUr//E1JMfMCkSnyWhHsrloSkL1UYhQXiJSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Cq9ep1+hEJEtKP/Ye/ziU7PjE0ZQSvV4LQedN7iSKOXOSiHNVKPM1AHkH+gSMjOsCxzCi/5A+/kz1faEWLgTBPCax0LW32KbGdmgzHbAaFFyqL6qQwjFRAljvXtXoPPEBFA6WdcshoP+xNMvFbumaKTlOxgQnDcN7zZx9UhqplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MNP5jCKn; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNP5jCKn"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2020ac89cabso16306715ad.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 23 Aug 2024 01:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724401916; x=1725006716; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2qPNPadQfVCJ1jEEmS0p5QIFRISgM9AkrOKzZ2bBq7k=;
        b=MNP5jCKncSGBTLUed9OuS8szpyug5+cQXYb4m89Jt4uzxtns/llL+ind/m/f58cP88
         rsTLCVvGPkIuTujamKwNdHDZYl1NkYXUChQnPyihf/8leEXq9gz+ft4rGIOqHOpsMwqv
         GvC+fTCg6CwUjsC1l1Ioy0CvdXdxHRBnbWF7GVPsccgLu+i969PWr461H3uHm48LWZ/A
         fDNyZg6cGGOKGysMQ5cjyzCSS6X87GAMPMv6eSdOBZztSlnkQfMOB+cd6zXdmkmLJl93
         1x9jXfGb8X3/UufBxpT6FkXOks8D3qyvjCNK07y1FHLCHFvnNBe1f5Tf6gDStliOF93L
         /zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724401916; x=1725006716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qPNPadQfVCJ1jEEmS0p5QIFRISgM9AkrOKzZ2bBq7k=;
        b=RqlqR/rzE9j+jM4oHbgHBA6p3rQfQDnDHfsF1Zk3l3+hKHyM0T+L65piSuIBr1Tu5p
         MyLjTVJP4QRGPvXj1GBpf1vlNa9sPlbqhgPfqjIQz9D6d4NNQQSmJAyhUTqjWuAqZtiz
         NqcTcxJibyCydwQN7erVAe8gNiD2Sf2xXU/EUgSGskWUhLmjDUWpsZsSOW8pFw8W6Dy0
         CAB3z9/da9lNecvQ3xGB+OZhxEAvS1EWxykZ+X3DW1osujOwsaRmGfD6kBYnmmZgvK5J
         ljZUXbLdT/180P0j4nxy3QRCp588HVRZLQ5qzRDnUZfm2gRj7iDe/n0bQeEaI0bKGhtV
         yZTA==
X-Gm-Message-State: AOJu0Yw6/yckmlOe87LeVs0DkdevrwY0bdlEmOqb+YQ7BuHQN+/pZhvE
	kUtLhQLVohqtxngSFcP1iQDnUNwaHoEZhQojNdANIkzcfuT9jvhZ0JxPiOy8Ye0=
X-Google-Smtp-Source: AGHT+IHHtNwxcf/hqkCT55+pnFPf6lNr6DFeXTW7SAvaVbOl7V/19u9pgX+0R6xVOwdHw/y2wqzJfQ==
X-Received: by 2002:a17:903:41d2:b0:202:4042:8520 with SMTP id d9443c01a7336-2039e4c6652mr16360775ad.37.1724401915552;
        Fri, 23 Aug 2024 01:31:55 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385566479sm23807965ad.58.2024.08.23.01.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 01:31:55 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	lbec@evilplan.org,
	mark@fasheh.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: fix null-ptr-deref when journal load failed.
Date: Fri, 23 Aug 2024 16:31:50 +0800
Message-Id: <20240823083150.17590-1-sunjunchao2870@gmail.com>
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
index 530fba34f6d3..da0ffcc5de0a 100644
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
+	if (state != OCFS2_JOURNAL_INITED && state != OCFS2_JOURNAL_LOADED)
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

