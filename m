Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7FBE65
	for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376773; cv=none; b=BFy1wmfMBnpiGfRQtEiymo2iFKATB/dC1I2YZvPYememVbCbDA/MUu/SMgN7C/3YSUGHw66P7KzFUL8VhPtOA87D5NnaD3kLQyPB6zojlrNd0TtIX11NVbVuk0L8XQptYkCplPtaVoHzMti3CK0pHR+tSIK3hyRAk5JrGQ17jaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376773; c=relaxed/simple;
	bh=i0Zkd4dxr01n9KEulZra0IMqDVNzk9TB2/lt/t5T28c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RRO9Mw0XWTtRIPyUN7Ig7McaPuGpDIjeIYGGOiAJmFBao7RG+EUoysEiuphUB47pmeQmEsWNH1XsspDzoGTPv4x8ULnoQ2hpbjdSDsKfj4e255nbYBggagDFMpDbQnZHDOkP3miPFswgHzBVBJ5HtnW0GPFlP9gVdJiSjO8ztHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X9hyM8UD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EsOFrRNN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X9hyM8UD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EsOFrRNN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X9hyM8UD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EsOFrRNN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X9hyM8UD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EsOFrRNN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D4FE338E3;
	Fri, 14 Jun 2024 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718376769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sCR2cvTamjq3THoTILB4I/0wUv+vwvMPfHIpURCjFnU=;
	b=X9hyM8UDnFgUTX5xG0KYgXP7s9L2V6dZvBzzCm7GqixBLVDTKcQy3Ddtk9tYOMnO5Iuq7q
	ep7O9l8CZYKlL1AFg+JCZ3bt282tgq1yrQxC5NpXGIiNmXd7aWZ4JkZ5K5zZOS1YE20FWM
	9EsUy536DoAOAYiRZ6YB7q2roXsqm44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718376769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sCR2cvTamjq3THoTILB4I/0wUv+vwvMPfHIpURCjFnU=;
	b=EsOFrRNNyr2LTjiG3nAm3kQ/nrE3pWgLGxsEcyW+wdT1S4U5ZJQbpDYvDjYZ+yQ5QJ8nAr
	5r1gwROSVPTgW8Bw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718376769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sCR2cvTamjq3THoTILB4I/0wUv+vwvMPfHIpURCjFnU=;
	b=X9hyM8UDnFgUTX5xG0KYgXP7s9L2V6dZvBzzCm7GqixBLVDTKcQy3Ddtk9tYOMnO5Iuq7q
	ep7O9l8CZYKlL1AFg+JCZ3bt282tgq1yrQxC5NpXGIiNmXd7aWZ4JkZ5K5zZOS1YE20FWM
	9EsUy536DoAOAYiRZ6YB7q2roXsqm44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718376769;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sCR2cvTamjq3THoTILB4I/0wUv+vwvMPfHIpURCjFnU=;
	b=EsOFrRNNyr2LTjiG3nAm3kQ/nrE3pWgLGxsEcyW+wdT1S4U5ZJQbpDYvDjYZ+yQ5QJ8nAr
	5r1gwROSVPTgW8Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3054913AB1;
	Fri, 14 Jun 2024 14:52:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uh7JC0FZbGYsVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 14 Jun 2024 14:52:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B725CA087B; Fri, 14 Jun 2024 16:52:48 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction credits
Date: Fri, 14 Jun 2024 16:52:43 +0200
Message-Id: <20240614145243.8837-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3579; i=jack@suse.cz; h=from:subject; bh=i0Zkd4dxr01n9KEulZra0IMqDVNzk9TB2/lt/t5T28c=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGNJyIjU+X5+94dSbjuqlCyTX9X/KTNWYLbzyRQ/nV5Vi274f LU0anYzGLAyMHAyyYoosqyMval+bZ9S1NVRDBmYQKxPIFAYuTgGYyIRE9n/abVY/q4V1F2y4csDtbo SzopjdR0M7tukbbORrPs+v8OzyTVHKcGiK2Z/xJVilLkUg5rULi8JFXqOvRTerRM7v6D1bb1IjZ9/m n/BNfNbKmJpr7l8FT35nmeoxYQvDX9PYqIe3o1iibC/ECRzr0cp49yq20XxWzH4O9diqlEvSe/sYlf 7n3VxeqLqvd/HtBQavMqzuZExgW/7axL3wEV9U6JItiw/wLXLXj71VPXt3WHKgzKknXSXOzz0Sl0Ry zk/l2Nd4Ki4hRdIl1tU8VvTy3o/F1mz++2qEp8Zlrr8fo3vSrE1my4pLLkw9S9mfK7NUxj9Unvf48v z83X1ybCe+aXJ+mXRTVsCD5z0rAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

The code in ocfs2_dio_end_io_write() estimates number of necessary
transaction credits using ocfs2_calc_extend_credits(). This however does
not take into account that the IO could be arbitrarily large and can
contain arbitrary number of extents. Extent tree manipulations do often
extend the current transaction but not in all of the cases. For example
if we have only single block extents in the tree,
ocfs2_mark_extent_written() will end up calling
ocfs2_replace_extent_rec() all the time and we will never extend the
current transaction and eventually exhaust all the transaction credits
if the IO contains many single block extents. Make sure the transaction
always has enough credits for one extent insert before each call of
ocfs2_mark_extent_written().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c        |  5 +++++
 fs/ocfs2/journal.c     | 17 +++++++++++++++++
 fs/ocfs2/journal.h     |  2 ++
 fs/ocfs2/ocfs2_trace.h |  2 ++
 4 files changed, 26 insertions(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ba790219d528..f4d7c0675651 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2371,6 +2371,11 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
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
index ac4fd1d5b128..6c3f4d7df7d6 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2579,6 +2579,8 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
 
+DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
+
 DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
 
 DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
-- 
2.35.3

