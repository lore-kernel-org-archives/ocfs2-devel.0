Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20C3190686
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 09:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718618153; cv=none; b=MF+jWcSRHArCDgs6tua9KGDLBaqufzRNDb3zlWXmzUHoytQDIb/w7J5ZAviTcWe0ByuhwqN67bE8CtpjG1fkaCTeEDAMghD6qHc+ScXli+hmUAbS2EgXcM4n5itkqONvFxxZbfzvMpOs/ujs9Q6jKAd6EWyhpt06VkI6O4LuKV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718618153; c=relaxed/simple;
	bh=PYy5OtlAhgNWDPwAzNUP4FYuIXSyme5rRcw7FpEKuUs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N64qvlMppteH9zEQ2h/AsVesicg6m7N5WlX0y2GUEo7t7DNLp6N8viXqmdeIcoofEaIBFTzx+nV7n6NlyIf7T2G9MdphPf64RWQd7FA/ppxGvKSYAHdxKiLprgVaQeBBHmbNhhp7GSDBCs5memenfjrW2Irx5C5adNUADkdmJDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YzMf7lmV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O2RMb57/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hwCst1gz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aMqxHT0X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YzMf7lmV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O2RMb57/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hwCst1gz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aMqxHT0X"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAB8F5FE4A;
	Mon, 17 Jun 2024 09:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718618150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yKI1zAE/e4vAUF7ub7lB3ryPe5jg5fPUnvMFQRTHxf4=;
	b=YzMf7lmV+bTFjwsainlchjxCMZfr+gryD3GGnnM15HDigIS6gC7OTIjenwHLhIrrwTnL2p
	Haf7zt6ar2yfE8kVxfr8AgNsc8JU2dx7M9n+6nlaVp6K3x+pL+Zek1dUwhm1u9yFki25wl
	mK15AvhSxBkWDGNZP1u6bPDVw/KM0yU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718618150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yKI1zAE/e4vAUF7ub7lB3ryPe5jg5fPUnvMFQRTHxf4=;
	b=O2RMb57/s2TSt5lLd6isl7+G15owUnKpWsn5tHTF5G2QH5ztjA7P6zt9ORVeNd3p/jvE4H
	APSVuCpPK6I2FuDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hwCst1gz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aMqxHT0X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718618149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yKI1zAE/e4vAUF7ub7lB3ryPe5jg5fPUnvMFQRTHxf4=;
	b=hwCst1gzM03BhdGQCCNxPbU5uU0kYbMbeAc5s5dG479I+WNZpCin0qtqrzb0j8pEkMugqo
	vT1furwPDfC/r19CozzJSVlBe3vGuYlS19VmkkWJUGad61anv3wIafYt1T+N9S2aZl7VYO
	hBfz4WAjBq9EW7mZyR5FiHSOqacFtAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718618149;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yKI1zAE/e4vAUF7ub7lB3ryPe5jg5fPUnvMFQRTHxf4=;
	b=aMqxHT0Xh0cZ/ImiP/tDgA0tH6z3nZsUXtV5IrrQ2tWUOy2m2q3ptsDIkNH6Y+ibwIRLr4
	/r7Uz3YKz7ZtimCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B73F4139AB;
	Mon, 17 Jun 2024 09:55:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hBR0LCUIcGabfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Jun 2024 09:55:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5822CA0887; Mon, 17 Jun 2024 11:55:45 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH v2] ocfs2: Fix DIO failure due to insufficient transaction credits
Date: Mon, 17 Jun 2024 11:55:43 +0200
Message-Id: <20240617095543.6971-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4211; i=jack@suse.cz; h=from:subject; bh=PYy5OtlAhgNWDPwAzNUP4FYuIXSyme5rRcw7FpEKuUs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBmcAgQ1BV6gZQcjvr+SzTJ/bnDYtjRduYdVqGY5lPV 9CDrDHqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZnAIEAAKCRCcnaoHP2RA2fttCA CKw78V2ew+Kyu8xOD2y5y1Aui2js3Fd5D+lOIpjOJW1qy4cH9HnYxu7Ynhfd5uWJNVQBi8/srGGPKR Vyg3EqgkmQdLz1ZAPwbs0LekcH+wjwVBMNlB9MHEBMl1VXZmBqyPNLBdK7qQgg86x1L8KkFDi5SCGi vtxTw44vAQTjdAa2zlKjVipptIFfcCL8KD+qddhKawCEjCpqo/7ABYgsfBj6EGi6v3LqacmKXTj9gN 107TfXI1JrUf6OdwvJLeNsX6Pdl0udr+MpDdvoWNm0ASg/oxaH1fhqsSb1GFrd0XM6AQ++2B/mvbR/ +ZKdEfrEWHliCP1yQpSE1EZx8An9Mw
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CAB8F5FE4A
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The code in ocfs2_dio_end_io_write() estimates number of necessary
transaction credits using ocfs2_calc_extend_credits(). This however does
not take into account that the IO could be arbitrarily large and can
contain arbitrary number of extents. Extent tree manipulations do often
extend the current transaction but not in all of the cases. For example
if we have only single block extents in the tree,
ocfs2_mark_extent_written() will end up calling
ocfs2_replace_extent_rec() all the time and we will never extend the
current transaction and eventually exhaust all the transaction credits
if the IO contains many single block extents. Once that happens
a WARN_ON(jbd2_handle_buffer_credits(handle) <= 0) is triggered in
jbd2_journal_dirty_metadata() and subsequently OCFS2 aborts in response
to this error. This was actually triggered by one of our customers on
a heavily fragmented OCFS2 filesystem.

To fix the issue make sure the transaction always has enough credits for
one extent insert before each call of ocfs2_mark_extent_written().

CC: stable@vger.kernel.org
Fixes: c15471f79506 ("ocfs2: fix sparse file & data ordering issue in direct io")
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c        |  5 +++++
 fs/ocfs2/journal.c     | 17 +++++++++++++++++
 fs/ocfs2/journal.h     |  2 ++
 fs/ocfs2/ocfs2_trace.h |  2 ++
 4 files changed, 26 insertions(+)

Changes since v1:
* Added Reviewed-by tags, Fixes tag, CC stable
* Updated changelog to describe better the observed issues

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b82185075de7..469143110f31 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2368,6 +2368,11 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	}
 
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		ret = ocfs2_assure_trans_credits(handle, credits);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
 						ue->ue_phys,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 604fea3a26ff..4866d7d3ac57 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -445,6 +445,23 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 	return status;
 }
 
+/*
+ * Make sure handle has at least 'nblocks' credits available. If it does not
+ * have that many credits available, we will try to extend the handle to have
+ * enough credits. If that fails, we will restart transaction to have enough
+ * credits. Similar notes regarding data consistency and locking implications
+ * as for ocfs2_extend_trans() apply here.
+ */
+int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
+{
+	int old_nblks = jbd2_handle_buffer_credits(handle);
+
+	trace_ocfs2_assure_trans_credits(old_nblks);
+	if (old_nblks >= nblocks)
+		return 0;
+	return ocfs2_extend_trans(handle, nblocks - old_nblks);
+}
+
 /*
  * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
  * If that fails, restart the transaction & regain write access for the
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 41c9fe7e62f9..e3c3a35dc5e0 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -243,6 +243,8 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
 int			     ocfs2_commit_trans(struct ocfs2_super *osb,
 						handle_t *handle);
 int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
+int			     ocfs2_assure_trans_credits(handle_t *handle,
+						int nblocks);
 int			     ocfs2_allocate_extend_trans(handle_t *handle,
 						int thresh);
 
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 9898c11bdfa1..d194d202413d 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2577,6 +2577,8 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
 
+DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
+
 DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
-- 
2.35.3

