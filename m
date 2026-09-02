Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13E61B3925
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788356246; cv=none; b=PuBxb/k0cVLNCa0PmDGNWIO0yh5pNBLhxUis2ALqLUjWTDRwlqxJ1RVaTHYwNr1Wnfc0RVCr2NLYRRPiTJzFwxHHi4XIEsRz9TzSKKBLVagWWYgwskYJItCjBtaAxfK1v6yxQi6YW5W4+aUc8AqrpSUDK3fp+HS7gU4dwU+Gsio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788356246; c=relaxed/simple;
	bh=lhNs9a+Xa+x9bTBoSWZLJQRDRMwvKbNZuBDt48fbKGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ7PuWYbKYzn4cNSBuIzW2NkJWtlLJjnN3ZeMmv+1tHgNR1zItht5DMAihQ8ygRcWxdBdYvAKgJWRNs4SBqG3baFE8wkmZLJFlDSWIMr4Nb14gEvlrrUmSQhFsyYKtwMJftY0nqnDs8mvlEIHyjHLhL4AeGp5pChRnvJEkVI4Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XacPRPfM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A6cqz0jd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v057JiWg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2bwc/O8I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XacPRPfM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A6cqz0jd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v057JiWg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2bwc/O8I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C85951F8B3;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=XacPRPfMISNdW/DwDnP65BRYx5Xmq8RZlTIr9plSAyO1+Fw5VjC2ZP+JlrMREGTwHMz28c
	st8M5CpKnVYzMM02ZzrREcRsFwf/KecyzjXJgCRti9T3syl2CJ/ANrLPmPXkFTVQ9jyR2E
	8Ofa1bNvUTM/4VPQhH/AsmZbpDIYW2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356237;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=A6cqz0jd23QVqkF9IRkukb0PDhutZoFLJk1k5sVj5sVTQL+8F6rK1XBYcd6LlkU6Sp6vnI
	F+aCkqUT4njCS4AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788356233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=v057JiWgfFpRq8HZnNifUh1M4NDEJLwaWcCzjf0qS4psBCkmKtZC7OsAtB46+J38ivinFH
	ZyKGSXPboY24JwRj9z4A4HEZdIp4026i5xsW7EbkZ4r4pxLyd5uPVY1h0EiLosJW7C/3JL
	GHI+l07WDQZbyvN4guah9k3VECLP39s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788356233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvI9OUn/GHaXEU/gvf/0EtYqhPQbjO59qKoI8EtYKMU=;
	b=2bwc/O8IBFmZ4QW8mtJuMqT8HuVx1X+vEPtftsyNSk8z6dLJxLfLvfsrnv8yXXMRLfM8U5
	DLDrySE/XPFZqGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7736913869;
	Wed,  2 Sep 2026 13:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LlYZHYkmmGrGYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 13:37:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1D50A13B8; Wed, 02 Sep 2026 15:37:08 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	ocfs2-devel@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another filesystem
Date: Wed,  2 Sep 2026 15:37:00 +0200
Message-ID: <20260902133702.1313635-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260902132458.23590-1-jack@suse.cz>
References: <20260902132458.23590-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1014; i=jack@suse.cz; h=from:subject; bh=lhNs9a+Xa+x9bTBoSWZLJQRDRMwvKbNZuBDt48fbKGQ=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLJmqNVH3jSX0W7v3R+obHRb8JL4w47A9Cpl5U3pd9NrY vi+NDl2MhqzMDByMMiKKbKsjryofW2eUdfWUA0ZmEGsTCBTGLg4BWAiLfM5GLbvu3ZuosXp3GgP y49Z82I3xB7Rt1q1/E+U+s0enRmTU7eXxP7S6A9zso3/Os25wFZydpSD1bWjbAwBW924VKdPDK9 65lSVHNxT9ymjOtKg3ti77YKua7Hu/h7GvcabijlfcrUYZt0MlDrYs+fzi3eqnza5qTUUfWY4sf Df0sVMc68UsHOILXaRTlya3fr6k3TXgxPWcubbfqlEt1822PHx3ror8TFW3icPLNnmd3/bYsU1B tfeXNmx93F1XfcFjtVtzoay56UqYkxOV72rtw9aof76BvNZZTemBOYdkavk8vMV39ilvHAUfZdu W5eT9ebnMq7UWcFLTnW21d2rXKT3+lmydcQVhtfMeVHRAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -6.80
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid]

It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
requesting to enable quota using tmpfs quota format. With suitable
passed arguments this can actually succeed in enabling tmpfs quota
format on top of ext4 filesystem which leads to crashes later in
dquot_acquire().  As tmpfs quota format is intended for tmpfs
filesystems only, verify we are indeed enabling quotas there.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/shmem_quota.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index d0b92d6da50f..6e0b43cbded3 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -54,6 +54,10 @@ struct quota_id {
 
 static int shmem_check_quota_file(struct super_block *sb, int type)
 {
+	/* Verify enabling happens on tmpfs superblock */
+	if (strcmp(sb->s_type->name, "tmpfs"))
+		return 0;
+
 	/* There is no real quota file, nothing to do */
 	return 1;
 }
-- 
2.51.0

