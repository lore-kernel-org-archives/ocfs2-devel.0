Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5511198E63
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679981; cv=none; b=ddZ5IsYXzRdPljWru7y2QJu7a75y5nz5OAPptbB+Apr1+onkLpkhUkK5/BeEjegA57je/rwNLK2/4+w5+9EBKwu+KgVkOGZI9TIr0B4Y2gPwL6osL4LsQadPB7Cs02xsqQifgpeEBIh+p8E4knwMwdGPwbfXZBOktpnZb+GcntE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679981; c=relaxed/simple;
	bh=GMdRHEPP51BDSfu8+TJptEk0bdf+E6Fmg+WS5+Bc9wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTjsRW9OwyvOpvZy8pZywOjB9P+dfZBdUeIygnQsa24Zm44nGPVE55+PRYBWtDr35b06BS0to5jhOe3hJu09NVP+vbsBc1LTdnG3ABmbT65w3jwkHDQa8IqFlzI/V638rYJhh30Zm48YOKbKTxev2u4BGfs4IqVyt1OfMiqyJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EKyY4chJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QC+wjnwx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EKyY4chJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QC+wjnwx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9709A211CD;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFBascTxy1q7UQ/3+pko+dqh62+ZTSKXuZ3URIx67Us=;
	b=EKyY4chJWDJGG/+NKqmeY/OMEKvlUrkvk52A0tuFa0vLSL0GrxIIkY1L/F5Tp5uPuMANur
	d9+BTucNLIzClNm26HkeJO+Q51PqYKdkZns3mHoZmaofmaX6N9NeDmhq/pGZAVqYoYWPD+
	d4tgJCo1VvBiFfGV6ESPVseYOkeYRo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VFBascTxy1q7UQ/3+pko+dqh62+ZTSKXuZ3URIx67Us=;
	b=QC+wjnwxQCYDUBpDARj+sqjZm5bDX1CeQHhcSXvWijsCJ6fi8KL/VS70QRnQXQHBgxLqjl
	H4J3HIzZY3AkaKBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88FE113A50;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyZvIelx7mcQGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Apr 2025 11:32:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3B34BA092F; Thu,  3 Apr 2025 13:32:57 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>,
	ocfs2-devel@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Shichangkuo <shi.changkuo@h3c.com>
Subject: [PATCH 3/3] ocfs2: Stop quota recovery before disabling quotas
Date: Thu,  3 Apr 2025 13:32:47 +0200
Message-ID: <20250403113250.20572-6-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250403112908.13750-1-jack@suse.cz>
References: <20250403112908.13750-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5821; i=jack@suse.cz; h=from:subject; bh=GMdRHEPP51BDSfu8+TJptEk0bdf+E6Fmg+WS5+Bc9wA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBn7nHkmTKySlh/KlwR7uTho7iffzdvDFeIAHBsqf3q sq8QLKqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZ+5x5AAKCRCcnaoHP2RA2bO4CA CRdc0DVQY7XrK5G9g8yLgtIpWJu4mz77F8wbBL6qskOZTQ1Zp8qMNBPX936O8+qb/pPW45lhETD2yc CbUKNtZCveejHxRxnKTmLHNdJqMAUFAU8e7Ryj4Qv5qFQn44YMVr0UbMJ8wq3B7JohJwsNuZs4frE6 zose4wNA62jribyGIbDAEaFYlFW+PfHfiNgibmfmzlYR0HvQAxXuFVnRBdZdqwJw0iiNePeDDNBZYy ynW7Rpsut2a7xOTmMZ5C3ZHJieiRA3oHwQTMAB4iYb6q8NY8m/B4E3avVTqpDyX4qhiVdDYQVw9cte NFLEI8RiZ6ITONLg6dpOB0l1Cd0mZ+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 9709A211CD
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

Currently quota recovery is synchronized with unmount using sb->s_umount
semaphore. That is however prone to deadlocks because
flush_workqueue(osb->ocfs2_wq) called from umount code can wait for
quota recovery to complete while ocfs2_finish_quota_recovery() waits
for sb->s_umount semaphore.

Grabbing of sb->s_umount semaphore in ocfs2_finish_quota_recovery() is
only needed to protect that function from disabling of quotas from
ocfs2_dismount_volume(). Handle this problem by disabling quota recovery
early during unmount in ocfs2_dismount_volume() instead so that we can
drop acquisition of sb->s_umount from ocfs2_finish_quota_recovery().

Reported-by: Shichangkuo <shi.changkuo@h3c.com>
Reported-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c     | 20 ++++++++++++++++++--
 fs/ocfs2/journal.h     |  1 +
 fs/ocfs2/ocfs2.h       |  6 ++++++
 fs/ocfs2/quota_local.c |  9 ++-------
 fs/ocfs2/super.c       |  3 +++
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index bed57687cc60..9e41d0f9b757 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -225,6 +225,11 @@ static void ocfs2_recovery_disable(struct ocfs2_super *osb,
 		flush_workqueue(osb->ocfs2_wq);
 }
 
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
+{
+	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
+}
+
 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
@@ -1489,6 +1494,18 @@ static int __ocfs2_recovery_thread(void *arg)
 		}
 	}
 restart:
+	if (quota_enabled) {
+		mutex_lock(&osb->recovery_lock);
+		/* Confirm that recovery thread will no longer recover quotas */
+		if (osb->recovery_state == OCFS2_REC_QUOTA_WANT_DISABLE) {
+			osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
+			wake_up(&osb->recovery_event);
+		}
+		if (osb->recovery_state >= OCFS2_REC_QUOTA_DISABLED)
+			quota_enabled = 0;
+		mutex_unlock(&osb->recovery_lock);
+	}
+
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1592,8 +1609,7 @@ static int __ocfs2_recovery_thread(void *arg)
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (quota_enabled)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	return status;
 }
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index e3c3a35dc5e0..6397170f302f 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -148,6 +148,7 @@ void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
 void ocfs2_free_replay_slots(struct ocfs2_super *osb);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 70b2d5c8c228..6aaa94c554c1 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -310,6 +310,12 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_QUOTA_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_QUOTA_WANT_DISABLE + 1 for
+	 * ocfs2_recovery_disable_quota() to work.
+	 */
+	OCFS2_REC_QUOTA_DISABLED,
 	OCFS2_REC_WANT_DISABLE,
 	/*
 	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2956d888c131..e272429da3db 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -453,8 +453,7 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 
 /* Sync changes in local quota file into global quota file and
  * reinitialize local quota file.
- * The function expects local quota file to be already locked and
- * s_umount locked in shared mode. */
+ * The function expects local quota file to be already locked. */
 static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 					  int type,
 					  struct ocfs2_quota_recovery *rec)
@@ -588,7 +587,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 {
 	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
 					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
-	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct buffer_head *bh;
 	handle_t *handle;
@@ -600,7 +598,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);
 
-	down_read(&sb->s_umount);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -677,7 +674,6 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 			break;
 	}
 out:
-	up_read(&sb->s_umount);
 	kfree(rec);
 	return status;
 }
@@ -843,8 +839,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
 
 	/*
-	 * s_umount held in exclusive mode protects us against racing with
-	 * recovery thread...
+	 * ocfs2_dismount_volume() has already aborted quota recovery...
 	 */
 	if (oinfo->dqi_rec) {
 		ocfs2_free_quota_recovery(oinfo->dqi_rec);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8bb5022f3082..3d2533950bae 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1812,6 +1812,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
+	/* Stop quota recovery so that we can disable quotas */
+	ocfs2_recovery_disable_quota(osb);
+
 	ocfs2_disable_quotas(osb);
 
 	/* All dquots should be freed by now */
-- 
2.43.0

