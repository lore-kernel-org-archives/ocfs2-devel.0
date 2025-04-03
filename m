Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936D5D738
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Apr 2025 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679982; cv=none; b=EINzKnIjMDYleVMw4mUAnNMSu5TAYyoq/IPnDf7yh7wj/oDHmXLdBMts7WNRAMZNIZRIb3s9u8LGVVZsK+RXTRYv+8oVRM9svuHcO1rErM6qU5D02OojUu5QIkYck/wIJL0jTBGXIWx5cKtyieMS7f56lpWdopA75j6dg6th1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679982; c=relaxed/simple;
	bh=IVZE2B9qiW3uCS7Xpme0/TgQTe+yFifsjz+pCGhhnnc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nJWphRpsbHKz5eYceUtHlgL6uPsUeph6iAlL9162WKHn4wlJRsZPyoVphHGRe4/OiXcWb3lnRJ+uVfRPaNS6rsV/9LQTIsb4RWvC94r59AOthMv5vQtCCxEcaIlqgCZhf/61cRljYojVTl8vC05bwmT7trtGDFTvVLr8eC3jTFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N5zxkdpo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=76f6k44X; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N5zxkdpo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=76f6k44X; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N5zxkdpo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="76f6k44X";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N5zxkdpo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="76f6k44X"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9AFF81F385;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E82LMX6DPgDmg6IFK1AU02dyqgylB2vh9XXA6/nF1H0=;
	b=N5zxkdpouYfIGjKXY72vpCkgpu2UDS2qeROLPxJFZk7K59kPogg+TRvRe1pchBrV3IvoF+
	XDFqtnpXiQoqylVMgTyVL5rZU98YMYvUGJRhGZJ8QCfNU7b8v3H5Rih/EGZvDzRkgkH9KK
	kF/Pl+aMVoIIsDHdxfsyj7BRn1N7BAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E82LMX6DPgDmg6IFK1AU02dyqgylB2vh9XXA6/nF1H0=;
	b=76f6k44XyCozpZA23rF7Xdl19RvlE+2WGGS5NwuCS4iHf4UBtaSyWROsQOdQQoLL9buYZc
	SaScCb9NNm6+vbDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743679977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E82LMX6DPgDmg6IFK1AU02dyqgylB2vh9XXA6/nF1H0=;
	b=N5zxkdpouYfIGjKXY72vpCkgpu2UDS2qeROLPxJFZk7K59kPogg+TRvRe1pchBrV3IvoF+
	XDFqtnpXiQoqylVMgTyVL5rZU98YMYvUGJRhGZJ8QCfNU7b8v3H5Rih/EGZvDzRkgkH9KK
	kF/Pl+aMVoIIsDHdxfsyj7BRn1N7BAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743679977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=E82LMX6DPgDmg6IFK1AU02dyqgylB2vh9XXA6/nF1H0=;
	b=76f6k44XyCozpZA23rF7Xdl19RvlE+2WGGS5NwuCS4iHf4UBtaSyWROsQOdQQoLL9buYZc
	SaScCb9NNm6+vbDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B7D013AB8;
	Thu,  3 Apr 2025 11:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cdO7Ielx7mcSGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Apr 2025 11:32:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2416BA07E6; Thu,  3 Apr 2025 13:32:57 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>,
	ocfs2-devel@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] ocfs2: Fix deadlocks in quota recovery
Date: Thu,  3 Apr 2025 13:32:44 +0200
Message-ID: <20250403112908.13750-1-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=362; i=jack@suse.cz; h=from:subject:message-id; bh=IVZE2B9qiW3uCS7Xpme0/TgQTe+yFifsjz+pCGhhnnc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBn7nHb9kNVlUoyNTEQowchuU2+FXH6Abp/F/j4E1AS Q2Bjd36JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZ+5x2wAKCRCcnaoHP2RA2dMiCA CqBEIr8yelHxhbzwdm1IOAz1pmflf90C706GKquN6RuuP9xKzUMd54GpbY0MSLzaT0hMvV6m8CxFNy iAdznXC07ZrGe5JRpl9Fiaswfin3VtDspWyQFHfva8sSLh/wdN2EzV/Ncff6oivKBD5ce66Uf0yIcc CEs4Gp3UtqJZ+TPLxCSeoR/pi+m20jEZ8TgmY+8LsMJxnPatkZk3ZFehFoN88xKNvzPWryeg500dCl p48XRuXnFg1wIeR7EjnzHpQqj2wWhNSEztmB/2ILdODqR1GIi+8A02dJ7r5OAMCmVlvcqCJ9KjWA8v CRFssZyikSl3BpMALo7CfbbzxTwRbN
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-2.99)[99.96%];
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
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.79
X-Spam-Flag: NO

Hello,

this implements another approach to fixing quota recovery deadlocks. We avoid
grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
stop quota recovery early in ocfs2_dismount_volume(). Please review and test,
the series has been only lightly tested in local mode as I don't have
proper OCFS2 test setup.

								Honza
