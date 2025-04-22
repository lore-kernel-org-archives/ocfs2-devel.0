Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD21E3774
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325731; cv=none; b=mpKUmZYe9Tg/7255rUAt+JHepBNLv+lgFsbw77zWAula/fwBnmCFBguP4k+/sx2J+JvQJMpku4FGJ5rVfykjjtJC/JNw28FbKB9PtO08ZD3fieafzZg5lD23Cqa52O8nbhdjjtUqHGJ/q3N9ohEU4fbYaCPUnPB8g3H/trRdW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325731; c=relaxed/simple;
	bh=dsNt7BdnEx7fcKng4gduJCUH15t7IqTVRO3oNUvdJxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmOf3qi8fhR0EDLvZ6kutPXCdxvKEkw1SiCK8CBupVSc4t2/QEGlyazixQUdx5YsxRIwYYpP+MMZOQyRZLKL6S9++aat3EFQVUZQQSQAOSEwvYaXjPRNie9JIAn0npLZGUe5UowSK9W4s7IhGPSTvdGu69o+lrsBcpN1RjvuOII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nYcpQmNU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EslU8J//; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nYcpQmNU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EslU8J//; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nYcpQmNU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EslU8J//";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nYcpQmNU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EslU8J//"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6DAD211F2;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dRUwUEzrVHy8Z3I6nUjdbWDqsX83m5uzuZT8MLganM=;
	b=nYcpQmNUJLYfFRi3uevgLdGhGUn2wRNyo9rwpr5k4EeZccZMun2ateb0ITX2QDQXliPqO8
	L3iD+ha/M3d32B9G9Tm7MgsJyFfVQUeac9wKZYEPUnRKXF9bXx1gk+BcQuvoUo+CQ6AiFR
	9EwFY+WLz17UJOSUHDNSYYw+sRMnqTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dRUwUEzrVHy8Z3I6nUjdbWDqsX83m5uzuZT8MLganM=;
	b=EslU8J//3BjsVPWYrlBYKcPGLRGI/syExmFqNxYf0MWq/uFsaFXNkjHTE9PGofilvpTeL9
	lAc/3alb3u4iZIAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dRUwUEzrVHy8Z3I6nUjdbWDqsX83m5uzuZT8MLganM=;
	b=nYcpQmNUJLYfFRi3uevgLdGhGUn2wRNyo9rwpr5k4EeZccZMun2ateb0ITX2QDQXliPqO8
	L3iD+ha/M3d32B9G9Tm7MgsJyFfVQUeac9wKZYEPUnRKXF9bXx1gk+BcQuvoUo+CQ6AiFR
	9EwFY+WLz17UJOSUHDNSYYw+sRMnqTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dRUwUEzrVHy8Z3I6nUjdbWDqsX83m5uzuZT8MLganM=;
	b=EslU8J//3BjsVPWYrlBYKcPGLRGI/syExmFqNxYf0MWq/uFsaFXNkjHTE9PGofilvpTeL9
	lAc/3alb3u4iZIAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D1313ABF;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1UVVKomOB2i+KAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Apr 2025 12:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4D0DAA0921; Tue, 22 Apr 2025 14:41:45 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 3/3] ocfs2: Stop quota recovery before disabling quotas
Date: Tue, 22 Apr 2025 14:41:34 +0200
Message-ID: <20250422124138.26027-6-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250422123709.15078-1-jack@suse.cz>
References: <20250422123709.15078-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5917; i=jack@suse.cz; h=from:subject; bh=dsNt7BdnEx7fcKng4gduJCUH15t7IqTVRO3oNUvdJxM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoB46EypT3one+NBgu2ysFaJEIrGDK0EQ2K93KQdAV 0EGET5eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaAeOhAAKCRCcnaoHP2RA2ZlaCA CTOR+zVxc1+sEpdKB5UBMVDyedPvWhXR0eozVZiMp36NWhm6TOJqu6AFixAb6kioVhJDfPI5xEoTNY FwipBNnGSG4eNvDf8Trc7BV2Mi32hkMfe2cnzTpAZKyoxI/hbc/2qup699CCmVde9RsgfrIvVgt18M Q5yL6cM3jswPBzdlzFtaq/Be6cadaNbUOCPRZ/a56cXzcCchyWUlZzTS1XaTPAnd/Y7JpasVoQ66o8 fveub2YQ8SCnpC7NbSyXQGQNECAtqzWXSmUAuNQ79j2I8cXwb9C2bhfMsIPAAWfOmhJ7ZPNRmUCMOc pVb8fuT9+bV3BOZ0dn1sHlKY8f+JQR
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
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c     | 20 ++++++++++++++++++--
 fs/ocfs2/journal.h     |  1 +
 fs/ocfs2/ocfs2.h       |  6 ++++++
 fs/ocfs2/quota_local.c |  9 ++-------
 fs/ocfs2/super.c       |  3 +++
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7511db5a46cd..f37831d5f95a 100644
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

