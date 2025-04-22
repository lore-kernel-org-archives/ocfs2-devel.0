Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBB420C490
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325717; cv=none; b=OD2KPHlPFvuek96D+S59PmTTyul7UrstN1AMG2Bm9rdpJ1tcq8uXlDS3bit+Tw6lQ2l0itn7DInXNuWYC6VWxKIh0avaMuzczz+u7oKyMLP9kJHQnO2mUfE14Ku7uIuFkL3rY5YrxHRS+uKozk7vA2TUNNyqj1kVrMlvSnkxzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325717; c=relaxed/simple;
	bh=1JtBFXFRyLocfSJ6FRyNYXmAVJ/wiCEMDsCllr43MVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCyVzFnnXh8uaabbCdcBxh9/COyo0jPsyIwyP3Uy+zLvQbxJOx19veCsOoW6SZAJpFpR642E+tVYWPeFKnV/Mfn989yHGG719D2syssm4GRp4oXMPx4y7j4rLf7Z/HITxNiN9xCCkOzACPT3nQrD5dhMDBrFMdu4kb5h/PbjnbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BL5BsntF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bHnWUBww; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BL5BsntF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bHnWUBww; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BL5BsntF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bHnWUBww";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BL5BsntF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bHnWUBww"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C08DD2119D;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di94CWju6cXfufdAFtmf/udVFwcyKSuOo4Q39QYPxDI=;
	b=BL5BsntF6Y2m7xWef3kgeSdEa+nw5ams6pzHRLLZE7oeECsenkhDzpXUQNFOkeyBOo24Nu
	Iq94KUaNKaYoXiZ1Rx09SKFiThNb3axrN6nGIIqIuskhAlZs4+AfMtixW11BKZWlSGzKeB
	7av5IgNnLwjwBHW5z2fv+WyDPMqYZAc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di94CWju6cXfufdAFtmf/udVFwcyKSuOo4Q39QYPxDI=;
	b=bHnWUBwwRM/jTIRMmSWWJoOPs6DusD8cGGDZLKZs6Q3vXJAp6lfdDVX1/EK5TMqJMVttVo
	Pgu2SOlQke5ZrJBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di94CWju6cXfufdAFtmf/udVFwcyKSuOo4Q39QYPxDI=;
	b=BL5BsntF6Y2m7xWef3kgeSdEa+nw5ams6pzHRLLZE7oeECsenkhDzpXUQNFOkeyBOo24Nu
	Iq94KUaNKaYoXiZ1Rx09SKFiThNb3axrN6nGIIqIuskhAlZs4+AfMtixW11BKZWlSGzKeB
	7av5IgNnLwjwBHW5z2fv+WyDPMqYZAc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=di94CWju6cXfufdAFtmf/udVFwcyKSuOo4Q39QYPxDI=;
	b=bHnWUBwwRM/jTIRMmSWWJoOPs6DusD8cGGDZLKZs6Q3vXJAp6lfdDVX1/EK5TMqJMVttVo
	Pgu2SOlQke5ZrJBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACAFC13AB9;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kTeFKYmOB2i3KAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Apr 2025 12:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 39826A0726; Tue, 22 Apr 2025 14:41:45 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/3] ocfs2: Switch osb->disable_recovery to enum
Date: Tue, 22 Apr 2025 14:41:32 +0200
Message-ID: <20250422124138.26027-4-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250422123709.15078-1-jack@suse.cz>
References: <20250422123709.15078-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2831; i=jack@suse.cz; h=from:subject; bh=1JtBFXFRyLocfSJ6FRyNYXmAVJ/wiCEMDsCllr43MVE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoB46CzyAYItHVo9Zi1JQFPVSM2wEjSNARgjZZR1I0 u2QW9G6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaAeOggAKCRCcnaoHP2RA2cavCA CpwsWPwFaweYb1heUsnteg3xSptB4SPvZuqk3YlIodjguKAhbZX/g9tYSQJzdE4OwmQl2LhwEH5t+V 0zcxDjnSAfaDI8CixuFtTXldYc+UEnqFnp/78ZFRe1xfvCWpHqM4cTlas0SrUH54g+XuGtddp9qwcl emH06A66VpABynvq2zQiEpABgihtscyArrEdOd//nZbE4hkhmhgbQZGoir3wxMLurHtT9N6Id0VvAC AS12HlTVcJ6k/xEctgVPoSKudd9BzfDCgUqoZHPAr06zAf4ur+DGqvNGYy6Q2ZjnKuYm2QPHoROi8U eegU5JXp81vTPClqsxYaDXLnd0FJVZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,suse.com:email]
X-Spam-Score: -6.80
X-Spam-Flag: NO

We will need more recovery states than just pure enable / disable to fix
deadlocks with quota recovery. Switch osb->disable_recovery to enum.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
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

