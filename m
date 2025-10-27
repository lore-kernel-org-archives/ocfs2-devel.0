Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26FB1FBEB9
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Oct 2025 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761569841; cv=none; b=HSogQJSFh+wn0TWY4jbyGRLRuet9Bf/iXW8wDdEkBg8riroy4f5+Cf2/XiwfJxZE6gV6PNRQBa/j1Qgt+Xyz0fkanTvc2IAH/MtRKgO+7Axae+r832xQmKPD111wY1hcv5rAtb7k0KjkOLTq+o3hmrHX/v5QDiCVlifz7Pi9a+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761569841; c=relaxed/simple;
	bh=3I2FEVKCORYoeqgAcUqlW6a36nBUpnPrFqZfoprpfo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jawfik9KAtPPOyxlhb9q5tOJIS6ffa5+N+ikC1xRLsYRaNuaiXOK882Elj5+mwd2is6++IGT9Hh5UC0/cYMxrtKtYvvZIWXcUUZhO0wP+m8EB9E/U++CoUWljVFfMcxtpOwTgcyMDsENCwYlVMG5nfwABkUc9Pjgmij7ArO3hN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=r/wBjxxL; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="r/wBjxxL"
Received: from mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2dcb:0:640:715b:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id 0B01EC01EE;
	Mon, 27 Oct 2025 15:57:10 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 8vboQt4LpSw0-5tv794pR;
	Mon, 27 Oct 2025 15:57:09 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761569829; bh=Yx0th47Z8Ei+itNnP0K/pjx7l9mMopPj+CnrbEFLrag=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=r/wBjxxLDYCTx12AXorW6FuEWpJmRwQ4Bc5KB1U86jTcJafyHPFzEOfBG9c6da5Xa
	 auI+AeogafqGORR+huyVFucSeLR6BP7rIhPX0EqjWZdVR48XVUaLIyBMi8JDnTF0sr
	 qaXf+PvrT7+4VyP2+w0+xjEKaF8JEjiWJIfKGNFI=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
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
Subject: [RESEND PATCH v2] ocfs2: introduce chain list sanity check with ocfs2_check_chain_list()
Date: Mon, 27 Oct 2025 15:56:54 +0300
Message-ID: <20251027125654.312153-1-dmantipov@yandex.ru>
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
note: resend to ensure that it's reviewed and hopefully good enough for
      mm-nonmm-unstable of -mm
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

