Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00741624E9
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502323; cv=none; b=VhhenmwzG1X7LFialyLxfYgIEIsKmxeSu1v5/FUqgaL3IszUv3+8JBmKfzwNyLLU5HchhnsD1VAvPU259/k8v+J9B1kcr4EglRxvzU9qk1PBwxKDp4XxWeHmSg+y/RyS9MOCDl9xzgCBvU8d+p8b2HYvJzaqowyGkM6xSZJ/KuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502323; c=relaxed/simple;
	bh=KmOR4CRJh7QzfvWGen8Fbv5H6cLPAP/UrWxcYxNBcWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC7egnOl4j5XH8/UoByMrBNeYMDi3+kUezdMU6xotHlH7zkzC2IHkOLepf8WCwsMIc/FKz7+uQfeOwQE7ooj0mD5CyhBcn5tmH/5Z10TGW68Lw+ZPL+tPb5M+Pbtwin6weUWw6J/WHpog9Y6JpuGQ41H5Rcl0JhLdKLoy+Kr/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M7Xr26lr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0qjtOxV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M7Xr26lr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0qjtOxV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M7Xr26lr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0qjtOxV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M7Xr26lr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0qjtOxV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D6F5A1F44E;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na1lo+GB2NySVjj1UJPjnrOEY6U/VOCKJ/YDu7XyhAI=;
	b=M7Xr26lrC/eQgOnfi7Wp2aV4I88K4fJpZzBZ/leGeS4z8OnHschAX2LBxetMJwEoLh9fLA
	Ui4Rw6iai+G92iwu96MfbFHYmEjiIdmtdbmMxlJ4u1OKYqgJ2q0cPG4td+7vyHxo6aPQXM
	KhrcNVMykW8NDX7vWMCtWcTgkiWUEk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na1lo+GB2NySVjj1UJPjnrOEY6U/VOCKJ/YDu7XyhAI=;
	b=N0qjtOxVSOOybmre7Nueaht5bQ8VxlR/JY4ypxfe7v+vOKd7zzrygue0jpiX3k6Kkejd8n
	yOj8gJaDNQKqLnAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na1lo+GB2NySVjj1UJPjnrOEY6U/VOCKJ/YDu7XyhAI=;
	b=M7Xr26lrC/eQgOnfi7Wp2aV4I88K4fJpZzBZ/leGeS4z8OnHschAX2LBxetMJwEoLh9fLA
	Ui4Rw6iai+G92iwu96MfbFHYmEjiIdmtdbmMxlJ4u1OKYqgJ2q0cPG4td+7vyHxo6aPQXM
	KhrcNVMykW8NDX7vWMCtWcTgkiWUEk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na1lo+GB2NySVjj1UJPjnrOEY6U/VOCKJ/YDu7XyhAI=;
	b=N0qjtOxVSOOybmre7Nueaht5bQ8VxlR/JY4ypxfe7v+vOKd7zzrygue0jpiX3k6Kkejd8n
	yOj8gJaDNQKqLnAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA8F813A77;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hUMSMW9ACmjdZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Apr 2025 13:45:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6F22EA0949; Thu, 24 Apr 2025 15:45:19 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 2/3] ocfs2: Implement handshaking with ocfs2 recovery thread
Date: Thu, 24 Apr 2025 15:45:12 +0200
Message-ID: <20250424134515.18933-5-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424134301.1392-1-jack@suse.cz>
References: <20250424134301.1392-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4352; i=jack@suse.cz; h=from:subject; bh=KmOR4CRJh7QzfvWGen8Fbv5H6cLPAP/UrWxcYxNBcWE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoCkBsTfIgvcBjayg3CqLDZTaBOVK05+rDrlpbYwOO rVM40dCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaApAbAAKCRCcnaoHP2RA2VtdCA C6hu8VhdJxL46kmCnjwaEjZPrjVT5UZWiuHLL28FoKX5Zobh1TOl7ictb20h/+pGdcI3NzHSi4wzHe eZ8D/jA4s9RkVxe1WhUv8bg/afGwSeYNxNzlthGi2E51uTH6rvCdJuBfUe+fxGc1vrU2rjVRXrmPoS GZtQU+K5Durw3EDSfXqKojobDX/qYkPUPjo4ZB26x0ifKaRbxip98gy1Cesl1Et3R0G5adIxXau+Jv 2N43qqxoxqt+CI+RLDD/wijb7WigDZa0wLkxTTyP8VmvwpTxzWbRAYdctsZSKa1pxxChSLEs+dmjjf fz3+0DSNdKt/LMdqeIao3ZjBguMh/V
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

We will need ocfs2 recovery thread to acknowledge transitions of
recovery_state when disabling particular types of recovery. This is
similar to what currently happens when disabling recovery completely,
just more general. Implement the handshake and use it for exit from
recovery.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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

