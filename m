Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C6B2EA75C
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761042635; cv=none; b=eW5mZYBN8l+8pewLoF+K302bYbNkwZr3byCDJY40zemv4LuowsNyrC387RwaB9vSkX75b1bks6OWUhclErqJJb36dS7taQwPfd7JIJcdhf+KyN1K3ZjWG6oXb6yNJFfZSWqtxXtuBwpn3sN1+5IYdFC6IFR55cty20teP/fUMDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761042635; c=relaxed/simple;
	bh=tBE+knlSkqochYeVk1tKLbOejSCF3NZyNuQGev6YdaM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aAwoTJbXS9z4zQHb2ts6XGnCcaw1qqVMZSbb5QJ2Oxw4GTTm8Y0L29OendopndZwy5XsplieDPKqGDe0uggEjXPv48a5IquMSsHPckKO52sPilWvEgeEoEbvtN+rF155R0kSeOPJeQd5MHW3/NGgTjwDpy7IQKvftXZb8zhFcL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=VLHMyeui; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="VLHMyeui"
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d102])
	by forward205a.mail.yandex.net (Yandex) with ESMTPS id 9ADECC5730
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 13:24:39 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:5a89:0:640:b4ed:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 40ABEC00A8;
	Tue, 21 Oct 2025 13:24:31 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id TOTviV1LniE0-zWysszkG;
	Tue, 21 Oct 2025 13:24:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761042270; bh=hpM9pqSg+C1KjYTOsnix9tLAt/TApCvY6ry248Ge+8A=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=VLHMyeuivWgAcgy49dYI6nEU7i+Y9F49reF66tzn6P5pPmpEd50dPVG4AS67OXsgG
	 Cy2BitI9kBeJOWCXJ+odrxiilHFBbXLirePej+XsIjAcGHS5QaQ4tSXcfxk8sIcCA2
	 E2yLf2WEW9H4OwwXv2jvDYsLgHpc2sJze3xBr4LI=
Authentication-Results: mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
Subject: [PATCH v2] ocfs2: introduce chain list sanity check with ocfs2_check_chain_list()
Date: Tue, 21 Oct 2025 13:24:29 +0300
Message-ID: <20251021102429.108786-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
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
v2: bail on cl->cl_next_free_rec > cl->cl_count (the name is misleading,
    cl_next_free_rec is a member count (and so can be equal to array
    size) rather than member index)
---
 fs/ocfs2/suballoc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..9969a041ab18 100644
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
+	if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count))
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

