Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6A2146A72
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502329; cv=none; b=DI7IyBtvt1KpRX+6Ejyg8gM/+WKz+LrrmFTgkAGy4zI+c55wfiPsJFoMH/2xlWscim3qyrIHIu37N9/QfNs6QgKDtJaYj1p1Bs8KxvpqotFYo37QyBWKJv8P9dwoiL4as9EVUi2X9fQxLb93WFXnUunxyMrMcelucX9T1EcfYMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502329; c=relaxed/simple;
	bh=0aLwnfgK0kN+GUDMinm5yr0FOv7hGRPfXcLguK9Bnzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVQpxDcxMXXuiJ5Ku+y9p6wrQR/Dg7JXT9kcKJtCP5A33TBPEEhWRx1m2152w85KAPSHwIRJfxnhW/qM0w/+da92hMgLKPOmwh2GvENl/9mSCm/YUEcJvbgNIw1sbrngPVKxy/dMU2sP7xyfaz0chWBxwhWaTN+l25MVzyRUfb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kBSZZCpG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9ypa80VC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kBSZZCpG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9ypa80VC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kBSZZCpG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9ypa80VC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kBSZZCpG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9ypa80VC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CFAC51F445;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FJng+Udk5OZPdotyz5ATNYr8zmKWe9SJiapvCGmujY=;
	b=kBSZZCpG1LQDbm771ikl1i2v24c7nJ4Mds3X+w2hp3bxFgzArQz9ZwSPAsfa1/iU8qyEjy
	JwLZssUWJbv4xA1/+CI8vz/gKObZ3qjnK8VYg9FVfQW80Svz5dhZufyR5OkH+EF4upxG0e
	mWnu00uPXnQ8Nrs31k1oiG3rFkeDXlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FJng+Udk5OZPdotyz5ATNYr8zmKWe9SJiapvCGmujY=;
	b=9ypa80VCFwNtZTA83DvdL1a2FSFgmWTlkd2V2p8nTSSKPOlMzs3DM2sxNsp6dONsmMUiv0
	pt+9Oseff2G+7bDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kBSZZCpG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ypa80VC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FJng+Udk5OZPdotyz5ATNYr8zmKWe9SJiapvCGmujY=;
	b=kBSZZCpG1LQDbm771ikl1i2v24c7nJ4Mds3X+w2hp3bxFgzArQz9ZwSPAsfa1/iU8qyEjy
	JwLZssUWJbv4xA1/+CI8vz/gKObZ3qjnK8VYg9FVfQW80Svz5dhZufyR5OkH+EF4upxG0e
	mWnu00uPXnQ8Nrs31k1oiG3rFkeDXlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FJng+Udk5OZPdotyz5ATNYr8zmKWe9SJiapvCGmujY=;
	b=9ypa80VCFwNtZTA83DvdL1a2FSFgmWTlkd2V2p8nTSSKPOlMzs3DM2sxNsp6dONsmMUiv0
	pt+9Oseff2G+7bDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B11C213A3D;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YSZGK29ACmjYZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Apr 2025 13:45:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 653DDA0734; Thu, 24 Apr 2025 15:45:19 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 1/3] ocfs2: Switch osb->disable_recovery to enum
Date: Thu, 24 Apr 2025 15:45:11 +0200
Message-ID: <20250424134515.18933-4-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424134301.1392-1-jack@suse.cz>
References: <20250424134301.1392-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2882; i=jack@suse.cz; h=from:subject; bh=0aLwnfgK0kN+GUDMinm5yr0FOv7hGRPfXcLguK9Bnzo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoCkBrz2HKHYHHTktY0EgNAjNd+MOlkaYr6l9r1Gco mWIoydGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaApAawAKCRCcnaoHP2RA2bStCA CR7aXQ92iqP6otczNtEjEpkBmL4lH45PFnIF9nsgg+URZNkFsC/vZ3p/13M0mDP59bP5mBhLVxNbzc gErzdxPZzJdswXzE2wYRzntm8WDNJ3V8TZEcB/jUoIP+xhVjOsYFTkpYDgMbMsDQ2Qu3JIfOdJZf8Y Cfc1V34IMKd/RAE9M+knFDtqEZmYpG9tWDG+fZUT1XgOWYR065hIQ+GKcdsza+uIilK1HyQqwqCPnT 87YtJNychlYnZJcnZR+a4mOYlxpBPdL05SSZKO7JYrxwCBaE8j5IKbPnZFDoG+nADQzfiTotpIulpC lSLPBIV9m/oK8QXFRpIWmvmm3D3wuu
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFAC51F445
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid,suse.cz:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

We will need more recovery states than just pure enable / disable to fix
deadlocks with quota recovery. Switch osb->disable_recovery to enum.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c | 14 ++++++++------
 fs/ocfs2/ocfs2.h   |  7 ++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f1b4b3e611cb..8986e813ab2c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -174,7 +174,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
 	struct ocfs2_recovery_map *rm;
 
 	mutex_init(&osb->recovery_lock);
-	osb->disable_recovery = 0;
+	osb->recovery_state = OCFS2_REC_ENABLED;
 	osb->recovery_thread_task = NULL;
 	init_waitqueue_head(&osb->recovery_event);
 
@@ -206,7 +206,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* disable any new recovery threads and wait for any currently
 	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->disable_recovery = 1;
+	osb->recovery_state = OCFS2_REC_DISABLED;
 	mutex_unlock(&osb->recovery_lock);
 	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
@@ -1582,14 +1582,16 @@ static int __ocfs2_recovery_thread(void *arg)
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 {
+	int was_set = -1;
+
 	mutex_lock(&osb->recovery_lock);
+	if (osb->recovery_state < OCFS2_REC_DISABLED)
+		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
-		osb->disable_recovery, osb->recovery_thread_task,
-		osb->disable_recovery ?
-		-1 : ocfs2_recovery_map_set(osb, node_num));
+		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->disable_recovery)
+	if (osb->recovery_state == OCFS2_REC_DISABLED)
 		goto out;
 
 	if (osb->recovery_thread_task)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 51c52768132d..e713361939f0 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -308,6 +308,11 @@ enum ocfs2_journal_trigger_type {
 void ocfs2_initialize_journal_triggers(struct super_block *sb,
 				       struct ocfs2_triggers triggers[]);
 
+enum ocfs2_recovery_state {
+	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_DISABLED,
+};
+
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
@@ -370,7 +375,7 @@ struct ocfs2_super
 	struct ocfs2_recovery_map *recovery_map;
 	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
-	int disable_recovery;
+	enum ocfs2_recovery_state recovery_state;
 	wait_queue_head_t checkpoint_event;
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
-- 
2.43.0

