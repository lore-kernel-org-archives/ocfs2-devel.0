Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1457E24BBF5
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 11:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679987; cv=none; b=iMORXDhWaw0ZV2SgAGB2eDKRV3ZE4djrBiHgHtGvkFKZPsoj6/rgsUwvxfkJ9CxGpoWyeRAhsjzGZkxePxlqAWR14BrheXxDao66ai9fVWAZLNMOmFxZtoIg5mDQPAvthiGFJyCPO0nuHdV5JAf6lYAy3BZ7HrC93dCuVCp8aFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679987; c=relaxed/simple;
	bh=E8a9zWFSDkzX+oyTcxqIaoIrva4qoVhyQajkeojKJak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4vV/LcMB5iFMEctAE9fR+hXZQdS51m8LpLzB5nWrcOxHPutk2gv7AfAo71CMjecxCm8MVQNpVjlUNeE0j5NwjFiTD9PtCma5FFOwgrppVzhSkCsNimKtrwO36XaGA3gWdJtLa7wCKOnC0OpLroo4A566HHTxIkbi9RCSzQoFA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aGwzOFiZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MwB5aYlG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aGwzOFiZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MwB5aYlG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 894CF211CB;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SqUsgUuOIa3tkOd1WI4oSB7Hh4Hl21gOpiB/XZzhaKk=;
	b=aGwzOFiZmBKWPB+WJWr0b9BWJM8bvwkhqYZKVEVDmEF3sFIgtWZzsEa5sHy8Duazbz/Wu1
	i4ZB0E3kYVUJ6cIfn9/x4PmlUTL/Sj7ZefmEwHmJNXsqlvtbql7MFNOzz56Aq7DEOTfH7t
	yIENhKT04Z+JoI2uEr7/YobRDS0jYV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SqUsgUuOIa3tkOd1WI4oSB7Hh4Hl21gOpiB/XZzhaKk=;
	b=MwB5aYlGFXXztbNQUP8d2uIbATxOM/i7ya6VxByvLa6Hb97Cr60G1r6i1qO/HiMtvNVTNq
	ld/UzWZHBqJQtKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E7E013A2C;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BFrcHulx7mcPGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Apr 2025 11:32:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 31B09A0924; Thu,  3 Apr 2025 13:32:57 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>,
	ocfs2-devel@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ocfs2: Implement handshaking with ocfs2 recovery thread
Date: Thu,  3 Apr 2025 13:32:46 +0200
Message-ID: <20250403113250.20572-5-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250403112908.13750-1-jack@suse.cz>
References: <20250403112908.13750-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4211; i=jack@suse.cz; h=from:subject; bh=E8a9zWFSDkzX+oyTcxqIaoIrva4qoVhyQajkeojKJak=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBn7nHjm0M2uLaSgEfdTfBVUkVWe3h+vOhXTpeNBUjb 3MxKpwuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZ+5x4wAKCRCcnaoHP2RA2SyJB/ wIQLvz9ehW3Rz9wt58MvhnqT1qkHAjMeZz7orlBIEfeLTBESRd976bCdrfVAHcb2sccERKNJVyhJ+t d3IBp/3G0B9LdkIGuDpkQLBdN0V0+KVapptW5l9xhMVyL2GahOM/UJHpYrxxTFfbZ9bv7KPdXwZk8a BSJ3xWBHIa/ub89bLp723MlhhpmhyJe4IxP79V0p7Oblawi4+1YGTfc5qv3qDFjINpoQ4L/qOl1rMl AO8Ftwga+KJHNa8tAR4GqJyMLaclxsWGytHiUq3qOdvGm/mxF0h/6G4nCneHR/AUUqVdaO5XUg5qb1 vxpBb+bQv5LrqGT1jBIFOzRDOGZelP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 894CF211CB
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

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
index 8986e813ab2c..bed57687cc60 100644
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
+		osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
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

