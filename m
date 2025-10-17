Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FDC29BDA5
	for <ocfs2-devel@lists.linux.dev>; Fri, 17 Oct 2025 11:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700877; cv=none; b=QHZKIdr7ZrujGlNznKG07NylEGvQZmkBYAJ2Cx89EWkS7Q0nEeu9FN/FnhDvHjJG/YuHLTwHls64Dzpgz+twcH75BxV1T5t4Y7Aq3UrNhsMiiHeHlDL3Z/QNDCOjeGr+DpKv8gju30AddVmDv1U50/uBEcricku5S1Y/BG4t76M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700877; c=relaxed/simple;
	bh=CeMSk3J6YXhZ1ke19KulahyWLN+XoAaFQEoZAhkt+W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WphnZhtkAUufX9oBcJ+bmqVrxV7N+qfBoJXz3rnzeYTnXIIgQN5ZZXK6qaZ8vA9/aVNdrr8VaspLKzwdfOyg2+IgtamipmIY+Aaa2lOhgswtNr23ZCq1aBFj2Jcvlyr1IasJ1ICR1fTxfoRV3JQwd5Y4+LaT3aXQJwp2JJvH6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=iZgKqDyw; arc=none smtp.client-ip=178.154.239.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="iZgKqDyw"
Received: from mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:84a0:0:640:dfd2:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 11DE3C0079;
	Fri, 17 Oct 2025 14:34:25 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id NYQBOIALuGk0-Cm45Kv56;
	Fri, 17 Oct 2025 14:34:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760700864; bh=gH+BdzY99H//FYyBAylOEcSbhqySTk1AQ8t4QcJjeSQ=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=iZgKqDywv9k3Js9OM/0rYmGKvWovR9QSep4bPZlaWiVhrV+sDvOzGtMIZ+pB0te8+
	 PbN1XSc8ucv2Jx7NNyqySDgnLSXMLXq5xGzQG7BRHsCUUP/SE2n5JBEgoJepXR3Z52
	 lAieUjuCLTEibiIvZZNMKxE833dg/QzBbxdwhyiE=
Authentication-Results: mail-nwsmtp-smtp-production-main-88.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+77026564530dbc29b854@syzkaller.appspotmail.com,
	syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: introduce chain list sanity check with ocfs2_check_chain_list()
Date: Fri, 17 Oct 2025 14:34:22 +0300
Message-ID: <20251017113422.243762-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <ed6e60dc-6639-44d7-80b1-35e87cf4d409@suse.com>
References: <ed6e60dc-6639-44d7-80b1-35e87cf4d409@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce 'ocfs2_check_chain_list()' to check whether a) the maximum
amount of chain records in 'struct ocfs2_chain_list' matches the value
calculated based on the filesystem block size, and b) the next free slot
index is within the valid range, and use the aforementioned function
in 'ocfs2_block_group_alloc()' and 'ocfs2_claim_suballoc_bits()'.

Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
Reported-by: syzbot+5054473a31f78f735416@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5054473a31f78f735416
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
note: this patch supersedes "ocfs2: add chain list sanity check to
ocfs2_block_group_alloc()" because it fixes two similar syzbot
reports at once.
---
 fs/ocfs2/suballoc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..d383063629dc 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -649,6 +649,16 @@ ocfs2_block_group_alloc_discontig(handle_t *handle,
 	return status ? ERR_PTR(status) : bg_bh;
 }
 
+static int ocfs2_check_chain_list(struct ocfs2_chain_list *cl,
+				  struct super_block *sb)
+{
+	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb))
+		return -EINVAL;
+	if (le16_to_cpu(cl->cl_next_free_rec) >= le16_to_cpu(cl->cl_count))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * We expect the block group allocator to already be locked.
  */
@@ -671,6 +681,10 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	status = ocfs2_check_chain_list(cl, alloc_inode->i_sb);
+	if (status)
+		goto bail;
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
@@ -1992,6 +2006,9 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	status = ocfs2_check_chain_list(cl, ac->ac_inode->i_sb);
+	if (status)
+		goto bail;
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
-- 
2.51.0

