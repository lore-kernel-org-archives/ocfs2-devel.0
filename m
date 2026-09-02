Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE7B480335
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788356246; cv=none; b=mbCOfuq/iScClGLJv6BYKVvJeECPIks0TQWaPGScDyKhrUwBTeODa32qL9Hwo7PtbyGH45GykuKu9nf+WqB1lQWxcUX0Jhigqg05S4wCjkOcxC1gYCTuEpO1C2RrS/l1DhVBiCrsH+rkarg1ML/Gi5I8eZ6aJ2rkqSK+CE+K38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788356246; c=relaxed/simple;
	bh=rhIIYZj1gDRfV0Zzn4IWd+CiaRTCYW8nS183KX0IZFk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmpFA6KHw8iA4IYgoUNzaCyFrJ+7vvcWVW/sgGqx6xzH6AuvHhunPn9sSmvtx6baaDBJzay404oZXgK/8cYxRYyAY34Y5Jka/bx6ddbAUelG6vni4z7C+wKs2F2IyuxRwJp11MrJ5ETVVjmMzrk8b6fojsQ1D+LxTyvRe8x6cgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kFeJI7Fa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wEgnbpYw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=igvW0iwd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PwtNXQkN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kFeJI7Fa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wEgnbpYw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="igvW0iwd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PwtNXQkN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 791981F7F9;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=kFeJI7Fa3DhbCAVEHKHilo19tMTpdMJkRx6xn2UT7/LP9xp7WOxdBFJ+9Rg9HACBuK0HL9
	5fMLIO1/4H3/OKQCp8GtkrWak0dYeiEHJGNnKCL46H+sbyHQWAC0pmHPgdQ2u9MExiURcC
	QThkqQX9sBHq0hwgyWH86sspj5k4r70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=wEgnbpYw5Lxg1SPixxID+ZWVZlB/UljwKlgMMrKFy4EP3m1MOfozgDxVcNic2nTfnPwXdB
	xTgdAifV1oi63vBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=igvW0iwdrxCnf6k+H+Bmt4wWEuRIFsatDloZb39czqxS21A0ZXeqcbfRxjAw8I7fVlZhV5
	yfi/JeScBaspSVbs6Yey/4ygM2K1dCM6DKQvwjqtmPlZKpqZ7B4ddHOd14XewZbaceaLFk
	cvxUMelMN3EVLoruBzXJsESiFtUPWv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=sDedlMCOvuW3EuoVUGCGcUVQWdalOVctmMo52iR6yfA=;
	b=PwtNXQkN4GvkX2GYghSltfo1a1JrvNYni0Da+xfbpeh/51iZSSQotlc5zj9l3eUz2KL2zH
	oYrfebUy1JxiyJDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45FB813736;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /rQDEYkmmGrAYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BA25FA13B5; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] quota: Verify special quota formats match sb type
Date: Wed,  2 Sep 2026 15:36:58 +0200
Message-ID: <20260902132458.23590-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=jack@suse.cz; h=from:subject:message-id; bh=rhIIYZj1gDRfV0Zzn4IWd+CiaRTCYW8nS183KX0IZFk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqmCZ5ZBNRLRaTvLmR1BJv3UcV7BS6owiHdQlkN TOgWyUOkyqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCapgmeQAKCRCcnaoHP2RA 2YidCACr/oac7mhnqq7jMWaceCGKrOqWSpp5PIRyDM61jGoSKjN+YvfTWvh+a0HlOO8ND3J6JBa 4+N0GjFjudQRqsOtzqr2zdGRvyJXZBOBM4YfLkjEufpbxLwawOMPfI2f4aET5Af3zixP1pX8p8p MHELEEb5x/bJ71wTmc4CPkT5lpzGRxAjHE/MRMhf9alxRSnMPnlHhvTZIu+VUO59N/Yh0URPVCW 7Of1ssp4OJKYqK6ZmD7+50M+paALliTCS0jZmF/ko+2SzbIAn1qFgBd63DDCs5IrB1pgGudROwb ZhWcIYaZdiHX3jwedReBvFFqwBYMAkoSWqoa6ZAB5I05kQJY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid]
X-Spam-Flag: NO

Hello,

there are certain quota formats that are created only for particular
filesystems - ocfs2 and tmpfs quota formats in particular. Make sure these
formats are indeed being enabled only for filesystem of appropriate type.
Otherwise quota format operations can easily crash as was spotted by fuzz
testing. The only gripe I have with this solution is the recognition of
filesystem type based on sb->s_type->name looks a bit hacky. Another way to do
this would be to directly compare against e.g. shmem_fs_type but that is a bit
cumbersome since struct file_system_type is generally declared in a relatively
narrow scope (not available where quota ops are implemented) so the filesystem
would need to provide a helper to compare against it. Let me know what people
prefer.

Once reviewed, I can merge these patches through my tree as they are only quota
related and very unlikely to clash with anything.

								Honza
