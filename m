Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AFE46C4D1
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426327; cv=none; b=PmD6Ti2xhBb+4iykUcyt1sj4WtPoStzg+B4E1EYFIndVHsDTDSKD0oiNfHhxgUiywqc+NunhcKHfPSBqq4xCzXryfewvFZV7mEzgeLniThwbRbDHBaPWKluBtQbbEmtSZ+t2YsOLAR0zVZeZMkzDrLjXUfcKfee3aFo/hmqX2/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426327; c=relaxed/simple;
	bh=nmbFlumIvFt8cCksagegtdhPcrgXqvGgK6oycSl8LHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YZxpxfEdihKerCwOFfhAA6GaUMKYg/vG0m2Px/R2WrPc0a5RLzsXdv0K1KA063yyQwZERgjJUlpkFZBLitb8CP3XZJBBViBArxdt4th41HE+I6Ha7JfMsfHVE6PzHOatftFNtAX+3Q/EAqV6lnmnd9GErDk/96hTtYKKVB+tl1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pOImHT7t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fhO1Au+O; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MVHN7d5d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fsExBAMe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pOImHT7t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fhO1Au+O";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MVHN7d5d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fsExBAMe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72B1121AB9;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=pOImHT7t1wS9lsRDZaMkOAa4TWFaw6XhATPeICdDNcLAnIcU3epzvjm3wTjaieaBfacTjF
	b60TvVfoZjV37gv+1lx2swLC7JWzy09HE6xUEhPfUb+36GKqqQvK9n8EuD8dRDd6CApb44
	c9fLSKozwriUJYHdLOH9imWMCokXDGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426319;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=fhO1Au+OpJl58qPnVCD25j2GKOZ/gOTS5DTpXoDGOBukD7r7w61Ta/AyUGeWmzmTSrdelr
	P4LorXuBfFAJyQBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788426315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=MVHN7d5dUCz77742lskdzC1eJ7yRHNvczWdzgd/eDjMCT9f1m0DNgj+/Dw1OwCsHeTfk+U
	Bt6V96HiYZJOc5ijCk2ufi6sZK3wxT8YHKsvxRODghdGY/lRSGli80y4P7McH/0Mkbrl81
	Nd44EGrfLY3DU5Mqrx8uyZ+6oUhv4ow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788426315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6Lq1QyCS2pwB45xAjaigLwdvoXYKOAHiBjoA3F+oARo=;
	b=fsExBAMe+agrEi70YIpparLvjnfy/d996k2Jlbldl++V3bm0fb+xQnjuRCyq5xTnhzbCRC
	Z/uRiWgFaHssDoAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D48C136E6;
	Thu,  3 Sep 2026 09:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yaPaEks4mWq/TAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 09:05:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB83AA0867; Thu, 03 Sep 2026 11:05:14 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/2] quota: Verify special quota formats match sb type
Date: Thu,  3 Sep 2026 11:05:03 +0200
Message-ID: <20260903090053.13120-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=jack@suse.cz; h=from:subject:message-id; bh=nmbFlumIvFt8cCksagegtdhPcrgXqvGgK6oycSl8LHk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmTg+QxytiwmIb8NKJnEByIzbyS55nQjAfkavF dzNt9qHp5eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapk4PgAKCRCcnaoHP2RA 2XoXB/9eZkpdjWsEivOpKLA29bTh2ynB34PS/VrbR6ZUPdLhPzxT+c8ozFt3w7m32M712EJV3l7 Pu6opTUeTkSgAPowQhYCPjW/JRA0z++LWjzLEbuS3y1bW5kZEx8McjUVfAQvZapLpUV7lpLxMpO 8BxmA2EBvO43neqvjLxD+5L/7w55QDy+bysJJizB6HCnHn8iFGdIVdPB0kzaD5QAwuRJJsVWGra A27lNVyr1R6ATfUr2ZiQVZlcIyXRcFb7QBViOPiL8QWffRgNQfWTmmedR3knJyrrWxphgE+H1Fb qbfore8scvpfKxB8tdKIVqDKNKDsaAbMki0yrq6UMUt3qV84
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo]

Hello,

here is v2 of the patches for fix quota crashes when quota format doesn't match
filesystem type. I'm now using s_magic instead of s_type for superblock type
checking as Hugh pointed out (thus I also didn't pick up OCFS2 guys' R-b tags
because the patch is different now). Once reviewed, I can merge these patches
through my tree as they are only quota related and very unlikely to clash with
anything.

Changes since v1:
* Use s_magic instead of s_type for superblock type checking

Original cover letter:

There are certain quota formats that are created only for particular
filesystems - ocfs2 and tmpfs quota formats in particular. Make sure these
formats are indeed being enabled only for filesystem of appropriate type.
Otherwise quota format operations can easily crash as was spotted by fuzz
testing. 


								Honza

Previous versions:
Link: http://lore.kernel.org/r/20260902132458.23590-1-jack@suse.cz # v1
