Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38FE1DDC3F
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Dec 2024 10:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734432277; cv=none; b=nE5rKuEZNkgwU4ME/3TrkIDV+3/+hXhmL8ifzulqmcFtfen/RT8PB9GJlMT10arsdJnrzRrSXFWZRmmiA/isId5XlCZoWjiIsxxBPiCqzCDpodQwAs3ytpfb6S0qNYNww5f1EUfaymPm47e81FnURH2ovzcdUtG/wKb20o7LbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734432277; c=relaxed/simple;
	bh=8C0/0INpS+2jFXAyQCtZl+L1xNZWxLVWvD84gscX6cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IH8QBm1AxV1/Y4onlo8c/kzJ92YOOgqUrHQRoqFVyFL0PdWyktCH/USYZAr/SfK1dORwkY0vQFKTp7hCocB2zvEurMwRHhzrRFaAqXJjZoxovKrydL/3BuIZB+pFIELgCk4H9Qw21UsaXKvBLrOzHGE0R8B4L3mL4sLWNK7rGOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=FkDckJ5U; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="FkDckJ5U"
Received: from mail-nwsmtp-smtp-production-main-10.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-10.sas.yp-c.yandex.net [IPv6:2a02:6b8:c10:2222:0:640:c513:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id 0D61160D19;
	Tue, 17 Dec 2024 13:44:26 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-10.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id NiNGRlCOmGk0-mjC7fnO3;
	Tue, 17 Dec 2024 13:44:25 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1734432265; bh=5FetM0ib2kXs6sXpK+ytKZOfLLGjYdaOi/1la2kBbOg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=FkDckJ5U9a+u/WfJ09YdcmaiwxISDVq14Ton5I1K71P18Zh1m/2Q7c2gOZd5EIdsL
	 ToJez1wM2GOF5oCS01ViSp/VVg0aQ7vGkfAStt/raSYaF6UuQ5oJA79YROWIkoq6lk
	 jZn1NnpIo1OIQou7AFb7vplDk+XmY0axbKXmtfqo=
Authentication-Results: mail-nwsmtp-smtp-production-main-10.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add extent record check in ocfs2_commit_truncate()
Date: Tue, 17 Dec 2024 13:43:45 +0300
Message-ID: <20241217104345.358461-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot has reported the following BUG():

Kernel BUG at fs/ocfs2/alloc.c:686!
...
RIP: 0010:ocfs2_new_path fs/ocfs2/alloc.c:686 [inline]
RIP: 0010:ocfs2_commit_truncate+0x2547/0x2550 fs/ocfs2/alloc.c:7234
Call Trace:
 <TASK>
 ocfs2_truncate_for_delete fs/ocfs2/inode.c:623 [inline]
 ocfs2_wipe_inode fs/ocfs2/inode.c:790 [inline]
 ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
 ocfs2_evict_inode+0x1c46/0x4630 fs/ocfs2/inode.c:1216
 evict+0x4e8/0x9a0 fs/inode.c:796
 d_delete_notify include/linux/fsnotify.h:332 [inline]
 vfs_rmdir+0x3d7/0x510 fs/namei.c:4407
 do_rmdir+0x3b5/0x580 fs/namei.c:4453
 __do_sys_rmdir fs/namei.c:4472 [inline]
 __se_sys_rmdir fs/namei.c:4470 [inline]
 __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 ...
 </TASK>

In 'ocfs2_commit_truncate()', add an extra extent tree depth check
to refuse further operations on (presumably) corrupted on-disk inode.

Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c16daba279a1161acfb0
Fixes: 78f94673d7fa ("Ocfs2: Optimize ocfs2 truncate to use ocfs2_remove_btree_range() instead.")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 395e23920632..040aa2694f53 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7219,12 +7219,20 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
 	struct ocfs2_extent_rec *rec;
 	struct ocfs2_path *path = NULL;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	u16 tree_depth = le16_to_cpu(di->id2.i_list.l_tree_depth);
 	struct ocfs2_extent_list *root_el = &(di->id2.i_list);
 	u64 refcount_loc = le64_to_cpu(di->i_refcount_loc);
 	struct ocfs2_extent_tree et;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 
+	if (unlikely(tree_depth >= OCFS2_MAX_PATH_DEPTH)) {
+		ocfs2_error(inode->i_sb,
+			    "dinode %llu has invalid extent record depth %u\n",
+			    (u64)di_bh->b_blocknr, tree_depth);
+		return -EINVAL;
+	}
+
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
-- 
2.47.1

