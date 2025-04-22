Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988BD1F03C9
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325709; cv=none; b=kTNn6FXvS0o515m9rcPzDdflPx6i7WsPOyMXuHVgFsTSQd3Wm70wAe+0fhpKGg4ofrI5Zhn3xZTRTa6CKBMbVFBlLbs4NxkfgSB+Cby34WTOkNkzEEpJBG3agO72VugFzwd74bd/tvvqpRs/SucbhGD2saM7rL8yDGGabPo7s7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325709; c=relaxed/simple;
	bh=8NHPxdCLvlf00/9GA2RDmbBLAfcNHGXYBg7o1D0z2eE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lSOXzJCra/LnLJtKhFwsO4QlB5y6rBcmMSTYsUKSdAojYd0M6zS5daa5k5bOx+8SZOYk5hWi/o00KJ9OgUOmQmm06sXcR0q+wt0LllNL/6cIoWCJ6xjZgnDrqnGQsua+ABqGR4F+Wj2XoxrVAcYxqaxvmjhuoKqBBYC6io/HTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NSyU1gdb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=isMDWqYa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NSyU1gdb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=isMDWqYa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NSyU1gdb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="isMDWqYa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NSyU1gdb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="isMDWqYa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C322F211EC;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mfsib0+ZUo0ylALqQtkOmQtcXcGi49vIa9/eIjxndyQ=;
	b=NSyU1gdb5+QJ8rhmn74aVYoqbB1b7YyS7TZDquh/C4OzSdOjg5PeAPblupE7EWExW6PGDK
	brwzY5KARRTsVCmai5C0DoRsDWtzCTlsl1kXtkL8sk58tyqGghWACePaJ5hG+tK9HjJcv8
	t9t3Z+RMIWmb1aHNf2fGfr06ohsfxpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mfsib0+ZUo0ylALqQtkOmQtcXcGi49vIa9/eIjxndyQ=;
	b=isMDWqYabU2leA+Gs8wMo2Qb/26rVhKNBUvctXyqJ1j9UK6a4nTSfr4ZJK6CflZYhdHGST
	uCzD5yXKBAoZBvCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745325705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mfsib0+ZUo0ylALqQtkOmQtcXcGi49vIa9/eIjxndyQ=;
	b=NSyU1gdb5+QJ8rhmn74aVYoqbB1b7YyS7TZDquh/C4OzSdOjg5PeAPblupE7EWExW6PGDK
	brwzY5KARRTsVCmai5C0DoRsDWtzCTlsl1kXtkL8sk58tyqGghWACePaJ5hG+tK9HjJcv8
	t9t3Z+RMIWmb1aHNf2fGfr06ohsfxpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745325705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mfsib0+ZUo0ylALqQtkOmQtcXcGi49vIa9/eIjxndyQ=;
	b=isMDWqYabU2leA+Gs8wMo2Qb/26rVhKNBUvctXyqJ1j9UK6a4nTSfr4ZJK6CflZYhdHGST
	uCzD5yXKBAoZBvCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA38413AB8;
	Tue, 22 Apr 2025 12:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0jh/KYmOB2i2KAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Apr 2025 12:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 341C0A0734; Tue, 22 Apr 2025 14:41:45 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Shichangkuo <shi.changkuo@h3c.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/3] ocfs2: Fix deadlocks in quota recovery
Date: Tue, 22 Apr 2025 14:41:31 +0200
Message-ID: <20250422123709.15078-1-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=477; i=jack@suse.cz; h=from:subject:message-id; bh=8NHPxdCLvlf00/9GA2RDmbBLAfcNHGXYBg7o1D0z2eE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoB456WhDQmxD7E1crHaf+LjdO3IiJGcsBT2pCfFNc UoDi8eqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaAeOegAKCRCcnaoHP2RA2aQTCA DcqjTEWwlm3ynqRL6xAztTFe4UyDiXXKwW9MHXpEwt4BRda8NwjVHasdOmO9S9+VxCfi5Wx/6rYQTF W4ZBv7vq8mu+AHXM9u/ZjS15tx7Zbacw3CJaxabFIDEyMzsqW69cYebYBZrdzCBzZ8xsj4gvClHTvU DitkDCUV37TnZe6MM5BTWXhgc665zvWD1JWbu9TlAL3gysSXcEIUK11OvVevKA8EDi6Tw2G7QU7v/x SfHt56OH5ofFjnLRtued5HNUf3yjA9W9qbZyB7oeK9+Nb1U7njtvsyB8D1T82Oo71oMPhMWRgxSpNG dW266ffG0WFelqUZrBn8sr0R/UBxe1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid]
X-Spam-Flag: NO
X-Spam-Level: 

Hello,

this implements another approach to fixing quota recovery deadlocks. We avoid
grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
stop quota recovery early in ocfs2_dismount_volume(). 

Changes since v1:
* added Hemming's Reviewed-by and Tested-by tags
* fixed __ocfs2_recovery_thread() state transition spotted by Hemming

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20250403112908.13750-1-jack@suse.cz # v1
