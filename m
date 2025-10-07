Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71A21FAC4B
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Oct 2025 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759830888; cv=none; b=Zxi6feEolKAo1Q5n5VXwUlUj8BMtZoRR+MC+imAMQNYMXQs5vdD790HjF3YydD7EYhEPFxkRTOJYCQbtGAH4/Hy3Rwx+SVXB+ke9eGEtb8kqbExZCQl4rr0Yt0mWoECLZ4+IPMiAraUnKhI42Qs9uYmRHt7bz5XVL1ZlM2C1xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759830888; c=relaxed/simple;
	bh=w+tGjNNOrnirzeeboSOULAeHfCLgYDli+3SdbAaUTzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXUkp5CVieOrIgOV+YfIga//6q3PKb4WaRx1vi/e4NxPq230wBbrsunHxVSV9/Ymdf8RtMT39tWZxrD3o1akLTsQLqBdeIcpNyuKbbeqtm2FtPgZVdqnDfQeAoFeK+z3v2T+Z5pyfw3M2EFR5u2MdXhemuvoQwGhxDP8OjffSwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=IgptCBrU; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="IgptCBrU"
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
	by forward205a.mail.yandex.net (Yandex) with ESMTPS id 41F1EC6153
	for <ocfs2-devel@lists.linux.dev>; Tue, 07 Oct 2025 12:47:04 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward100a.mail.yandex.net (Yandex) with ESMTPS id E3515C007D;
	Tue, 07 Oct 2025 12:46:55 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id skhrr19LQOs0-yNqfaPLt;
	Tue, 07 Oct 2025 12:46:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1759830415; bh=kNyFgfu+mEVsqFvCWeOAj/Qz6xzvPt3AQ1lkmA6P60c=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=IgptCBrUKtct5BKrd/Us4DdIWE/JkttCA7vLvsvP9PZKaDFm6YtCH9Xkv1olWG52Y
	 5Ir19JRS46WzSalpQEcUDY2juKd2knuYVlAuk30e57SrCjJFTowEsz7+DYiArtQ7Xi
	 5A8evzFRbhoZjFnFgFbl4o4TZ1PnW0LFysqVdMFM=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()
Date: Tue,  7 Oct 2025 12:46:26 +0300
Message-ID: <20251007094626.196143-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
References: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_dx_dir_lookup_rec()', check whether an extent list length
of the directory indexing block matches the one configured via the
superblock parameters established at mount, thus preventing an
out-of-bounds accesses while iterating over the extent records below.

Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v2: move sanity check to ocfs2_dx_dir_lookup_rec() (Heming Zhao)
    and rely on the convenient ocfs2_error() to handle error
---
 fs/ocfs2/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..ece0462a5d26 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -778,6 +778,14 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_rec *rec = NULL;
 
+	if (le16_to_cpu(el->l_count) !=
+	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
+		ret = ocfs2_error(inode->i_sb,
+				  "Inode %lu has invalid extent list length %u\n",
+				  inode->i_ino, le16_to_cpu(el->l_count));
+		goto out;
+	}
+
 	if (el->l_tree_depth) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
 				      &eb_bh);
-- 
2.51.0

