Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECED1487E1
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502323; cv=none; b=nVSithz4rIX09L+OpIWTMYt+OKONCckU+uAKTyuOeyVbu6PBzizqYcQHwF46v1AjkH+VnPIWcP1aM5tM0w4Wz+lL/NyK/O+RAlY/QSj5jeHwyLbNfoGy39gvpWTBSPieGqVW2BPfFVIVA0hjQp+SKwvpU3PQ5YxZ6IqpC44eDvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502323; c=relaxed/simple;
	bh=naXsNi/F5uYYLRaKvltc2KJSWD1rPmGuSOP9NoIZ/Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qtpcd3/2z0kkNEZpnoGCfog3qVA+AohYBHpTpea9YnrKKw4NicUpzwKM6F/VaeW+55PCWE5XqnUGkHmOvQEeIYqkb08Nf246XaS1HcKgDXG6AVSQ3Wr4Wcq9Y0GRLIO2z4R9oOTMnG4DvQFNVDmpJ6l1kdlhpVJ/eXqDgPp6Lh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BTkndJ8e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8YhLgixp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BTkndJ8e; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8YhLgixp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BTkndJ8e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8YhLgixp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BTkndJ8e";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8YhLgixp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B04742117F;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3EE0G+v1EvEvrhSyBxFbD0gsMRW6UZ9oCeY483xgUDA=;
	b=BTkndJ8eAmG5wiJsXIO+xIz/VSB9VUmXV0nclKKEPZDPkv52LkNKa4hL8nn9iN4WuMyciu
	UJkabbE0mFi/YfUkQLuhIT+0Mj3JNHMPT5etQOwccEh9I9OlT2JF5aCo09EBfirqmVqFRr
	hf6Ga7FwEPkolYcZno8KAiHrWZBYURQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3EE0G+v1EvEvrhSyBxFbD0gsMRW6UZ9oCeY483xgUDA=;
	b=8YhLgixp0FJU4miu3J01bTuptOJ0XitGToz6ALrVN9OLL721/Z54KH6/2VyJ5CFmCi3Cpw
	mdtLh+h6Y3zLujCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BTkndJ8e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8YhLgixp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3EE0G+v1EvEvrhSyBxFbD0gsMRW6UZ9oCeY483xgUDA=;
	b=BTkndJ8eAmG5wiJsXIO+xIz/VSB9VUmXV0nclKKEPZDPkv52LkNKa4hL8nn9iN4WuMyciu
	UJkabbE0mFi/YfUkQLuhIT+0Mj3JNHMPT5etQOwccEh9I9OlT2JF5aCo09EBfirqmVqFRr
	hf6Ga7FwEPkolYcZno8KAiHrWZBYURQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3EE0G+v1EvEvrhSyBxFbD0gsMRW6UZ9oCeY483xgUDA=;
	b=8YhLgixp0FJU4miu3J01bTuptOJ0XitGToz6ALrVN9OLL721/Z54KH6/2VyJ5CFmCi3Cpw
	mdtLh+h6Y3zLujCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A52761393C;
	Thu, 24 Apr 2025 13:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O/xPKG9ACmjXZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Apr 2025 13:45:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F8B6A0921; Thu, 24 Apr 2025 15:45:19 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 0/3] ocfs2: Fix deadlocks in quota recovery
Date: Thu, 24 Apr 2025 15:45:10 +0200
Message-ID: <20250424134301.1392-1-jack@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=687; i=jack@suse.cz; h=from:subject:message-id; bh=naXsNi/F5uYYLRaKvltc2KJSWD1rPmGuSOP9NoIZ/Gw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBoCkBlGWCv5I/fH7kNTVLgqE41MZ+VI7aTzIe2xFNm 3AyRb6KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaApAZQAKCRCcnaoHP2RA2cwxCA DAuN6VGf6oNel2qQ1NG368PmcPEuD6bGZBGt0G2gBkbf8O+lcQ1LSXHq/4MBijkNtzTU7E44ZEc9h6 ZIOuQ8XyJnhzzxcdTsvLqrMVitdEWgSDz+fTTN+RU5BF1Aw4uDpPglmU4sxIY35+dzMJVbO9PcRJhd 4bcfVoZ+ZrHSIfw8JBjfsNIMmoOVqZEMiUIQK4bfi2STFwsVG3e3gU/z6e4N3gek0EajjeymUWJ+rK abkvy9zW5IpLeTp4577eGq4U4dlSFQxNmCACd2X5wKZgRRsCVOHzUDPuw6oBUmPOzjiSQAQjSbHN8S W+tWFGpGanASl0FtmU/AaWZGxfDX11
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B04742117F
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

Hello,

this implements another approach to fixing quota recovery deadlocks. We avoid
grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
stop quota recovery early in ocfs2_dismount_volume(). Andrew, patches seem
to be ready. Can you please merge them? Thanks!

Changes since v2:
* Added Acked-by, Reviewed-by, Tested-by tags

Changes since v1:
* added Hemming's Reviewed-by and Tested-by tags
* fixed __ocfs2_recovery_thread() state transition spotted by Hemming

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20250403112908.13750-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20250422123709.15078-1-jack@suse.cz # v2
