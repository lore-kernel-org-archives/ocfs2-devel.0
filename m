Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F5827CCD3
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325723; cv=none; b=OLvbOGGkP+iLOJV1EuJlMBdZdRKg5aMbhxlRufL519QlnuElz7Hzm34OxQEXoIXRLyKI2lhM29hB4C4FVeRsi1eYTGbJj4a9zCvAsi50HoCibDbC7SwFy7zqv2GKuK5EBapV7xoV6EGusm4Gy9naSZ57tT/Twc00qYvssD2l3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325723; c=relaxed/simple;
	bh=LpRlAAtunFynu/RgV2vm2bA3x4CvO/fBpDG1QkdoKis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2gUMpooTQdctkQ6T+gbyLh6DBOk4McyLKnpK/Z9rcVIDULnXrxayNsdRQlMSv9oP6ON7ayV4zndwbAEqXqrYfF8+cKIAg5GRhl6+3X/lghiuJuag+YBWM+XMSE8xlvE3vWJwuA1CuYoDB3bKyky0OkL7YKfScr0qVhhmQe4eBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a3Wj9Js0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GYpgYAht; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a3Wj9Js0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GYpgYAht; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a3Wj9Js0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GYpgYAht";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a3Wj9Js0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GYpgYAht"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2EDC211E5;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5N8SQAmKvEqyVCJsPX1d2/g4UiEYgy0OUfCbjwClkA=;
	b=a3Wj9Js0xluEcWp8aNDbL3CcB4+N4VFp9coa7oqNhxx5q2rvxevArYL/7R9oLwRihb1v6W
	NfTWsngArJiBaLwFoZqhLmWV3dJWQjz0kBKwkmqI5XdFLiNTH2D4xmDDmC8hiy/JvnH29w
	u9ADSNs18rOYgSoFC+IGGsPdHbFCC8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5N8SQAmKvEqyVCJsPX1d2/g4UiEYgy0OUfCbjwClkA=;
	b=GYpgYAht8fT6wVQCu7OvwYKLnQpPdCozGltL4KWU1U2LL2S1hcr4TN2+KzjPY826YHjcDl
	ZmleHDq3mHw2CXBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5N8SQAmKvEqyVCJsPX1d2/g4UiEYgy0OUfCbjwClkA=;
	b=a3Wj9Js0xluEcWp8aNDbL3CcB4+N4VFp9coa7oqNhxx5q2rvxevArYL/7R9oLwRihb1v6W
	NfTWsngArJiBaLwFoZqhLmWV3dJWQjz0kBKwkmqI5XdFLiNTH2D4xmDDmC8hiy/JvnH29w
	u9ADSNs18rOYgSoFC+IGGsPdHbFCC8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5N8SQAmKvEqyVCJsPX1d2/g4UiEYgy0OUfCbjwClkA=;
	b=GYpgYAht8fT6wVQCu7OvwYKLnQpPdCozGltL4KWU1U2LL2S1hcr4TN2+KzjPY826YHjcDl
	ZmleHDq3mHw2CXBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF1FE13ABB;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9+PKYmOB2i6KAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Apr 2025 12:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42DEBA0870; Tue, 22 Apr 2025 14:41:45 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 2/3] ocfs2: Implement handshaking with ocfs2 recovery thread
Date: Tue, 22 Apr 2025 14:41:33 +0200
Message-ID: <20250422124138.26027-5-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250422123709.15078-1-jack@suse.cz>
References: <20250422123709.15078-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4205; i=jack@suse.cz; h=from:subject; bh=LpRlAAtunFynu/RgV2vm2bA3x4CvO/fBpDG1QkdoKis=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoB46DKixWFALmdnYJyX1XxEHUOWG5Z3SPnpvweaJQ 6UWEIySJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaAeOgwAKCRCcnaoHP2RA2XOuCA CJiWEuCnsMvFRPB9PlTuFsDHagcQ4HsvlOXHaBJOtbdw5oLK+0X2NrxDYf2FqU0Hrmp3WtkWC3qY+Y N93+c/m8mclxeLgyZLxvRHFq2cMvPs4e6j/pKrf9di6q0z+X48cf6apW9FbRmqQpWeXzQP2pkKrXej u6oZXn2MNl3S5jde7+h9rmHmdXQCTCkJKM2LD57kk3h9grtN8HDoCbBI3mOf+RvOzDH7HdpO4igpRY CHeGtHBUl/6Yh00+BchPXDxB+YtniSPbuiJi0FAxehNqz7joIfuUSQsbZ9/9baIs4oU2e3EHDmuzMe urjk+cO+eXXoVYCxnVtU1mEum/tYOg
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Level: 

We will need ocfs2 recovery thread to acknowledge transitions of
recovery_state when disabling particular types of recovery. This is
similar to what currently happens when disabling recovery completely,
just more general. Implement the handshake and use it for exit from
recovery.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
 fs/ocfs2/ocfs2.h   |  4 ++++
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 8986e813ab2c..7511db5a46cd 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
 	return 0;
 }
 
-/* we can't grab the goofy sem lock from inside wait_event, so we use
- * memory barriers to make sure that we'll see the null task before
- * being woken up */
 static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
 {
-	mb();
 	return osb->recovery_thread_task != NULL;
 }
 
-void ocfs2_recovery_exit(struct ocfs2_super *osb)
+static void ocfs2_recovery_disable(struct ocfs2_super *osb,
+				   enum ocfs2_recovery_state state)
 {
-	struct ocfs2_recovery_map *rm;
-
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->recovery_state = OCFS2_REC_DISABLED;
+	/*
+	 * If recovery thread is not running, we can directly transition to
+	 * final state.
+	 */
+	if (!ocfs2_recovery_thread_running(osb)) {
+		osb->recovery_state = state + 1;
+		goto out_lock;
+	}
+	osb->recovery_state = state;
+	/* Wait for recovery thread to acknowledge state transition */
+	wait_event_cmd(osb->recovery_event,
+		       !ocfs2_recovery_thread_running(osb) ||
+				osb->recovery_state >= state + 1,
+		       mutex_unlock(&osb->recovery_lock),
+		       mutex_lock(&osb->recovery_lock));
+out_lock:
 	mutex_unlock(&osb->recovery_lock);
-	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
-	/* At this point, we know that no more recovery threads can be
-	 * launched, so wait for any recovery completion work to
-	 * complete. */
+	/*
+	 * At this point we know that no more recovery work can be queued so
+	 * wait for any recovery completion work to complete.
+	 */
 	if (osb->ocfs2_wq)
 		flush_workqueue(osb->ocfs2_wq);
+}
+
+void ocfs2_recovery_exit(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_map *rm;
+
+	/* disable any new recovery threads and wait for any currently
+	 * running ones to exit. Do this before setting the vol_state. */
+	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
@@ -1569,7 +1586,8 @@ static int __ocfs2_recovery_thread(void *arg)
 
 	ocfs2_free_replay_slots(osb);
 	osb->recovery_thread_task = NULL;
-	mb(); /* sync with ocfs2_recovery_thread_running */
+	if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
+		osb->recovery_state = OCFS2_REC_DISABLED;
 	wake_up(&osb->recovery_event);
 
 	mutex_unlock(&osb->recovery_lock);
@@ -1585,13 +1603,13 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 	int was_set = -1;
 
 	mutex_lock(&osb->recovery_lock);
-	if (osb->recovery_state < OCFS2_REC_DISABLED)
+	if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
 		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
 		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->recovery_state == OCFS2_REC_DISABLED)
+	if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
 		goto out;
 
 	if (osb->recovery_thread_task)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e713361939f0..70b2d5c8c228 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -310,6 +310,10 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
+	 */
 	OCFS2_REC_DISABLED,
 };
 
-- 
2.43.0

