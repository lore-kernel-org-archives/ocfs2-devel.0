Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958CB46C84B
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426323; cv=none; b=C3oOYqBfILL55TpAV3aB3emaw04zYL+KrgGWeQQZMjeVJ2x3UHCvSifC1lwr5nfefO2iR8VqYltK+bt64KO2TYWyEcIyyuqRouv+ybTHg1lBTAu9wNvZXvCVBQZ28c59UOYTLAiZW0Gvzb0nhFkUZcYBUtlTt02YmjFUvU6rzVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426323; c=relaxed/simple;
	bh=3JBfHEUmQEeir0ZG+UiiHyOtOKEAxaWjeNMa7kJX3+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw4DHNV5dJpfDJdVMik5lciXSWpYtx05Q+SPacK4XDzNladw7EdtoC8a3PVJckYwKAmXzFVQdWYDPzB2mQz3pfQ5bgakFeuL9GzJSRNZSVLtRfl1OerepIs0yrz20ufYhYtoydd8S378U2tDCHCaa9cfdoqC4QRE/yGXbYG0awA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=E7+9IUPX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IxO8S6L0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="E7+9IUPX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IxO8S6L0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 854B81FE0F;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsQyZMa+a6GTeNgszTa4JkkgsOwEiJ5IGoTKayGkFxo=;
	b=E7+9IUPXgsXjhG8C9EVGTJYzFboyZ/ZhXYg0QjiFFeIkrcvcaVDEoBbSJhcjBgfVPx65tD
	c3S5hJkxUZV4fam/ttAtlq90xnGVtTUSpNm0OU6t0X75wjuCe2DUOvq0e6AxqbqaLWEEBP
	kl15cDDfHGV3Ug040edWP6Qi1ClCzH4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsQyZMa+a6GTeNgszTa4JkkgsOwEiJ5IGoTKayGkFxo=;
	b=IxO8S6L03zlA1aCbkz4Qc6/Imcxhs2wpP48AtLSTqglqHtZklczBJHdsMXIiT6Wlc5l+Hq
	p6HeRHtnLoAzIrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65BE913736;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AqTQGEs4mWrCTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DEB52A06F7; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
Date: Thu,  3 Sep 2026 11:05:04 +0200
Message-ID: <20260903090508.1360863-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260903090053.13120-1-jack@suse.cz>
References: <20260903090053.13120-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=jack@suse.cz; h=from:subject; bh=3JBfHEUmQEeir0ZG+UiiHyOtOKEAxaWjeNMa7kJX3+k=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmThEFmm6om3WsRZLTl/+C0uVUKHZ1z7egOZZA trFRd0xQqSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4RAAKCRCcnaoHP2RA 2eivB/4n++1IPW1VQWFADRVpNtb3Hvf6wN+mg9r9TT7CbmTValtrtGUS1ZAIrGKKfqAvjFxESXJ YWxusz+sb/C1wNJNsbEADwqnIdnh7Nddy8RWR6W4HtIVSaert8xH3BfJwWogzQanYxk19JsUXZB I9rrlb+x849KYmkUkD2Ejp2AjjlX0jZdy5COuyib7evecpSbZ5Vwbt0LlXzq3FGf7OoJdQEvXcd 4tbnmrtYXGLP2R0ndmx2mnaBiQnhZeDA6rKPajG+oMAvZ9EVeC8kshYaqpGfEMwl4e+g6N1MWUx FeKs/1EZbijzQYDDh976hDxe32avwAuqBEY2+P5+H8iiiV4v
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 854B81FE0F
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using ocfs2 quota format. With suitable
passed arguments this can get upto ocfs2_local_check_quota_file() where
the passed superblock is from the ext4 filesystem and that can cause all
sorts of interesting things, most likely crashes. As ocfs2 quotas are
specific to ocfs2 filesystem, verify we are indeed enabling quotas
there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index f55810c59b1b..a2b276bcd0a8 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 	struct ocfs2_disk_dqheader *dqhead;
 	int status, ret = 0;
 
+	/* OCFS2 quota format is supported only for OCFS2 filesystems */
+	if (sb->s_magic != OCFS2_SUPER_MAGIC)
+		goto out_err;
+
 	/* First check whether we understand local quota file */
 	status = ocfs2_read_quota_block(linode, 0, &bh);
 	if (status) {
-- 
2.51.0

