Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CDD46EF7F
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426327; cv=none; b=elXOQa08EOncNTcnadtqDGpTQQJRlbOm/caFZu7Z02azN4RiqbUesbY/1eL0fdxDjTVbYNCypPQRwd5C1Q1i5U2tbADMICAcZczZ0Iv9PMGm1wfuNiml1fa0KQ1cKBL43wH/nsOOm7/SXy9wbueADKLyoVXxl3KGUhbO2fPiGCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426327; c=relaxed/simple;
	bh=yq74qpUyYYBh+XhkRlhY9CvlmFz4Sh7DR+W9lw8EnSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNyISFQKlgsaZcLFfRJLBOCfkoUpJal9QB9zFVQMZoUb1nYbKdePC8hJEmEjP7lEX4/OXTzbXtJ0xUCC/oojkIsyn/MJoLLOFwqQ3jnI++4jXRJixWoT8evL9mpmiv+fJ7oD0HXZxXLe7JrxJTAsPHrjkW4N1OAWNEsNdhSaimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z2O8/tIf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/73vGtRQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x163C71M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bZzzsLE+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z2O8/tIf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/73vGtRQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x163C71M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bZzzsLE+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A86F31FDFD;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=z2O8/tIf4Pw87wVdS2YoZzNs4EQfI2MSF/cfZBVztrLBjsVUAZ4eqN/3yVBK4CdaiaMYUV
	lrIViQ9WfjhPk6QGEi5TVSdJCgozuJmGoO3e578nKef4Kh6jKzsPHTGLM7Lk6g4FwpWEB6
	fLLXoMQti70DSamDuCTxajAKy+GMvR4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=/73vGtRQdesM12rwOuaXY0hu89xLN3d8Mq9aXV4aCI3fGuG0OoVyQDN3T5hH4aJ6Ig9nVk
	gwXj0Np9FwVYaXAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=x163C71Mz5Y0EE6PbP2EtVJVNaUqy4bQHmH7OmrdtIsnTYwCf1T290C+TMWWEMFjsI3yCr
	kVLWyieEC6TPHR5fAVP7D+1kg9BLio4p43MbtgjYUqHchFnf41cY1vqEY9TKEY+Vaf/Nuy
	r1vsIYXqSvdwEoLVSvnfd8j3fi1YjV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQFXVOwmsBFKM/Rr5PbcSzr2KcD/BrLeJ3eCzmRkoXI=;
	b=bZzzsLE+EH/ySEZcEvCyx29JDrIeG5HDZ8BDtqV39pyqVB59okaQuJHpVbSGbVEP91iCx8
	xzKGrTVFiNt3C4Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8523C13738;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5TGBIEs4mWrETAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E4D5DA13B8; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another filesystem
Date: Thu,  3 Sep 2026 11:05:05 +0200
Message-ID: <20260903090508.1360863-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260903090053.13120-1-jack@suse.cz>
References: <20260903090053.13120-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=jack@suse.cz; h=from:subject; bh=yq74qpUyYYBh+XhkRlhY9CvlmFz4Sh7DR+W9lw8EnSI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmThF+qG3OMEVoRa35nSomc6gj9S+ECwWWTQAa k90LvBdJ7uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4RQAKCRCcnaoHP2RA 2VpeB/4vkbXQpBb/RjAWZhBXKbXv3XQRAoEPXAPWZqqvLhMt7xkVwHOvZuZsdTppQm9rx8L7vab Ad+hJE3rXaEpkBdpMG7YUQrrLx+VjprBWZm4dqdGq7HdJ4dm110v8maXi8iGBigbz1ti6RPYE2R Pk/xuUc/cbF1pDB3R5XCBUfmiMrGEFlkzlr3lTCc/S9HA5x47jOylU40JZUxn0XYmK1QA6vZ52T htCSdHJE02646W6HkTA2lch/RtdcMB7nuA6/fKGdjcH+4lpBJVHqYSgPQcEhNJlzHXAFs74XanF MzyxpPVmDeRLE2Ex70OkIc/6C7KsS7apKCAivcOQFEmyuCsD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -6.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid,berkeley.edu:email]

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using tmpfs quota format. With suitable
passed arguments this can actually succeed in enabling tmpfs quota
format on top of ext4 filesystem which leads to crashes later in
dquot_acquire().  As tmpfs quota format is intended for tmpfs
filesystems only, verify we are indeed enabling quotas there.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem_quota.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index d0b92d6da50f..a3fa4bd93e75 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/shmem_fs.h>
+#include <linux/magic.h>
 
 #include <linux/quotaops.h>
 #include <linux/quota.h>
@@ -54,6 +55,10 @@ struct quota_id {
 
 static int shmem_check_quota_file(struct super_block *sb, int type)
 {
+	/* Verify enabling happens on tmpfs superblock */
+	if (sb->s_magic != TMPFS_MAGIC)
+		return 0;
+
 	/* There is no real quota file, nothing to do */
 	return 1;
 }
-- 
2.51.0

