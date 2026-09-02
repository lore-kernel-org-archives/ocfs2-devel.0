Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596A548A2C2
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788356246; cv=none; b=Nl2LEIYkvlKuZHsChHoTvyiGS62TaUxA9kg503ymO2EpPhSq/fLyVSKB2DfxGwjiqi6Z30GPhqmxBF99901jfuxTImZoazfKX6vgQk/Zk61g29tZbnOzG/d4YzYtP7fdKwvzr2COp/HLtAsHU8CoKY4Sz7s1Wl8uXBANhECSzaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788356246; c=relaxed/simple;
	bh=eXTdW3jlEgvo3+fRkqFJjMu0ZDxZwxAjzXoYPvG1T7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXG/CMzB0mebG7efHhPoJBbLTTy7mz1V1HArF1jSt0Po1ZfaRv5MIQ2nwflhOe3LcIXc3aEL0kuhQJrd5NYo8AfbE3YfjSDVmmTWN/3ZBUqKLzqizBJsAc3NJntdamHH+1yIYJXcfWZ/aNPyG4bsxzckOhd6zxIjIh7KtgmL96k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qes4nSDh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PaBkU7UX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AUMI1Rv+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dHID/5p+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qes4nSDh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PaBkU7UX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AUMI1Rv+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dHID/5p+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A5A111F812;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=Qes4nSDhi4/dx18qt3AzuZ5PGjpqZCEPpSygx9STBmo/n6gzEVMcsBtOuRArBB0dZ0yaWA
	KWzFgVCoP4aml3FELHOlVZW85gIzvsohnBL7ZnqQDiYyzgwoKz6p90Y36XWiwh1IICLyNt
	wc4tRBv0m+f0baP2cnXeOFZpYRr2r2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=PaBkU7UXikcmdgoAM00pkcVWN6VDuODksj8653GHtQVg631jOHu5ZHmaitN8T2HUKuowP/
	qeMNX9PKd9kLFgAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=AUMI1Rv+nMkeEtleUUW7GBFMnM7qoojm8BrRwoNRyTiLkyuyLqXxVosomuY+SfKI0HDzc7
	QJ1oIMFXzme0TDJTf3g94ZloHVs41L5q1nojDBJBidU9E9DpvoQ0TTFRk23Cl8+T5+I/l/
	TVigrSrd3NGLi9MY2BnYDXhlHC4JqiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAYIXq2aizFaeJHiAqTkWiPxmY4fp23xo/LzkEA4iAA=;
	b=dHID/5p+rTjM6PZzoKEBRakN3cve5wq9jOjijj63XdesT0FeqGHuNONDTQPDXVcmWHwsDL
	ZALOCitqPbtFErAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D82713738;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V07oEokmmGrBYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BEE48A1315; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
Date: Wed,  2 Sep 2026 15:36:59 +0200
Message-ID: <20260902133702.1313635-3-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260902132458.23590-1-jack@suse.cz>
References: <20260902132458.23590-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1149; i=jack@suse.cz; h=from:subject; bh=eXTdW3jlEgvo3+fRkqFJjMu0ZDxZwxAjzXoYPvG1T7M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmCZ+FzI04LF+pOrfTGNavGesx/qjDrqPtxMsB RhMY5Cka/CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapgmfgAKCRCcnaoHP2RA 2TeIB/4uXjrpYBo3JbyvmS+RnmkgSX8EW5LfRWVxuJDr87VFxl40ALxmgrt1V60e/hJ4o8Tg/E4 XanwRM9nZEjC2e4f9KY4a1gqUFO63L3t0euRzfTgana469tJX7a+RWlZ4pK0tjLSpmCaD7O3frm Virpy8R2LQ9IXjc3W7e2zZxYd2KA5lP57AXMCjJaXVu6V0ahP2kXahkxZAqegOjfyse6TQ8hSzc j8Rra2XDzz6rGJaOxSIB8hYy+OO5zFSuwQtc4pyL4VqzGZ/Pqmy37AoPPMZd/vvThorCOpnSrG0 7a2gceKaf7MdUP3Jz0Fu1L9cBVNGfbSMWRmtvfDTA7yXd66T
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

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
index f55810c59b1b..97dee8ee6096 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -171,6 +171,10 @@ static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 	struct ocfs2_disk_dqheader *dqhead;
 	int status, ret = 0;
 
+	/* OCFS2 quota format is supported only for OCFS2 filesystems */
+	if (strcmp(sb->s_type->name, "ocfs2"))
+		goto out_err;
+
 	/* First check whether we understand local quota file */
 	status = ocfs2_read_quota_block(linode, 0, &bh);
 	if (status) {
-- 
2.51.0

