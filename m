Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275124;
	b=siqd9gQPSNHeCvelo1TxJ+ogs6Pu9TsPhAHaFm9HO91wKXkZtmv5VJo31tJ23bFxcjHj
	 rxdvYAUjHkdXih1qC9XzTufXtWl274pnqsilljd+Vk2HIvTUHngKmXBTLMtlHscqwy2G+
	 09lXDTCDIpOWgvZhaxnBBKr2zUtzN7kWnUE8t9rZ1AX3UGf1+C1TgqvtvY6VidqyDkyWL
	 tA74sOyULxzSZlhnq8r3Y5O9okwEwlj6PTA5oYJhSZw5eRmtDLhAijrCEyQWzQErBAKvu
	 MBqnA0C2Gefglv6QrBD+qACSSQyYlqsjiEVnqI+GT63e8siexFYVaDRNRlk5Zl5wHVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275124;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IFcFWQpilaX79mXWQN69ZR7nna2ky8RvcPu19ICh9h4=;
	b=lH0TZm1x2YtTdf8QffqI11g03vYkuBzSK+XpQPFJMzuyT0XRhyHnWLriOmygaOTA+cRk
	 gyAO5al+57AJ6mhMN8aeNgv0/b7qxsH8GTcRnv31eY89lgZ6NrkK572+Y3kO4A+0kfKEI
	 T3J5NZujueeifPkA0QpHokngrj4E39oQXs+PIEnqIo7W7lzkqV8ysU8/sZffhoE9W+RjD
	 aHZY/8nasb78NaF853ayqtJ9JIy1PsUF7naXiDOkGgWB5hI3i3vTg/QQe0muRzmAZLs67
	 0OKjlmm9kA7hheSf05xU3+doy4Uh3TBH8SpwW6FTG2GePd9dySK5PUgYPk7I4huIAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="CaJllgu/";
	arc=none smtp.remote-ip=162.62.57.49
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A8606A31C
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 01:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C3A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=CaJllgu/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794275118; bh=IFcFWQpilaX79mXWQN69ZR7nna2ky8RvcPu19ICh9h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaJllgu/2aZKoHkij5hp5h0jDyTjPFM7le4JBQERwSSKAYsq+RaBRteX07EM0EP6n
	 Gg0/FHFqRdWWCYR7dt5n+TmSuSr5eDqltEic2Lf00fQQO3zccPcX43NqnF0ekmu/o/
	 87aAVboxKXo5nLVmM0sFOtxVIGnpWR+JU7YTDnQQ=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id B463E6A4; Tue, 10 Nov 2026 09:45:06 +0800
X-QQ-mid: xmsmtpt1794275106tyno8fqh8
Message-ID: <tencent_DEBEB3490E975A2C62C2D7DD573A9A254F05@qq.com>
X-QQ-XMAILINFO: OTR3aNS6beOJRZnjRpXpOTQ8Uc0v/jdvoZSa0LcNiG2ceT0653kt4/fwtiXsLW
	 tUTNfwfLbOUUEDbBX/fJ/jgnHBdDQsEYdjEcVoZjZ1kOcjs1QNKlYiTiBzgZok/f4YjbzZeIiMZy
	 buYZEFNV+VRa1euUk9gIA7jLyu0kIou3GbK4t8XuvlTvPtta93CBbgEZw2gLE2kIUjBsKGa8WKEX
	 W8OyOaZgX8q4z6LKBe/LuoXNv9EcLaN98Op/eaihSa01jPodWpb5W+t9kfUdKNRE35dy+XuxyPqU
	 I/g9iljmop1qoa/ZUvw5sf/NmovOMPe/A9sOBDz6ckLJr7FuSY7dB8iOkH/LfRZj3DRQf4Frxd9V
	 k8kh6cMFqY+lrAvIDIEDT7Vq98AY4YbWgV6y/Pn0aM2+xU8cbDx8i2F1GCOYsN3SDIRIYIMsQSTr
	 krMvGBtVdlASEreyQ1OtudM50MmRB/pvF3r8b6889p3dqspOKsbu4eLtCmBbYxFayI/Jq9Sjj8xV
	 0r4V7m1Cw/mF4Gm8+B7ACyd+xKjOw7bOWjsDiTn48kYY5pTfqKIOGYi8xmMes/jPoorNjbvomKab
	 4hYuMwm2i1M1bO+INYOfNnaTGbgpbwWrkN+CzFpQ3bKs10mkomWoeCeoQtkZr4gKHZzieNM22xl4
	 rROwUA706PoMdJNGludx+gZGIrN72YIkWPrZYnh/RtUv1RQWa2L9Fy4eXIGJhAeah7jMnxdpP/8x
	 VJ8xVqHxtgVnItEVVSsKENEPDqrOBZ99VDVBTSpUwuIAJcSzjZIYVnEdv6TalwKEH5dZhiZT8km7
	 pGXCCl9IZF96wJ/a4d3dDcK7L1sCUXRqSBgyDRb5f7iakqo9CAFkjvBmE3xKe9miIfXC7nfR9dkw
	 /4FVeohT5CtvSdUXZx6zmjkX3tHvduiTGnu1LKVMGUd1ZuyjUm5bw6BaUXZF9SXhvwid41rrw5ZY
	 iVlzWU7pkmy3kzWV9sDBx65rmj5u8Inr7LaJ6HpQ+b2IfOYGnlQx3w1TXR+RsSllOL4iuUlIKUWh
	 9u5zDbangHZ4DSczbyVsrwAmDmgKiDXcZhw36OzU/x1GHTNTAAYEWC2j7pdfJb3hdPBYFjBw==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Shuai Liu <847807867@qq.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	a.p.zijlstra@chello.nl,
	syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com,
	linux-kernel@vger.kernel.org,
	Shuai Liu <847807867@qq.com>
Subject: [PATCH] ocfs2: fix lockdep class of newly created directories
Date: Tue, 10 Nov 2026 09:45:06 +0800
X-OQ-MSGID: <20261110014506.561567-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a791c94.01d0871a.3a0d52.009a.GAE@google.com>
References: <6a791c94.01d0871a.3a0d52.009a.GAE@google.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Directories and regular files use different lockdep classes for
i_rwsem (i_mutex_dir_key vs i_mutex_key) so that lockdep can verify
the documented locking order "parent[2] -> child -> normal" without
spurious class-level cycles: e.g. cross-directory rename takes
I_MUTEX_CHILD on the source directory followed by an unclassed
I_MUTEX_NORMAL on the target inode, while other paths take
I_MUTEX_NORMAL on a file before touching a child-class inode.

Since commit 14358e6ddaed ("lockdep: annotate dir vs file i_mutex"),
this split is applied in unlock_new_inode(), which relies on the
inode being created with I_NEW set.  ocfs2 creates inodes through
new_inode() (no I_NEW) and instantiates them with a plain
d_instantiate(), so lockdep_annotate_inode_mutex_key() never runs on
this path.  Every directory created after mount therefore keeps the
plain i_mutex_key class for its whole lifetime, breaking the
dir/file class separation that the VFS locking order relies on.

With such a directory the class-level chain

  i_mutex_key/I_MUTEX_NORMAL -> i_mutex_key/I_MUTEX_CHILD

recorded by the reflink path (ocfs2_vfs_reflink() locks the source
inode, then __ocfs2_reflink() takes I_MUTEX_CHILD on the orphan
inode) collides with the chain

  i_mutex_key/I_MUTEX_CHILD -> i_mutex_key

recorded by vfs_rename() when renaming a directory onto an existing
file, and lockdep reports a "possible deadlock in vfs_rename":

  syz-executor105/5623 is trying to acquire lock:
  ffff8880767009a0 (&sb->s_type->i_mutex_key#18){+.+.}-{4:4}, at: vfs_rename+0x6e3
  but task is already holding lock:
  ffff8880764ff9a0 (&sb->s_type->i_mutex_key#18/2){+.+.}-{4:4}, at: vfs_rename+0x64d

  Chain exists of:
    &sb->s_type->i_mutex_key#18 --> &oi->ip_alloc_sem --> &sb->s_type->i_mutex_key#18/2

Fix it by calling lockdep_annotate_inode_mutex_key() in
ocfs2_get_init_inode() right after the final mode is established,
before the inode can be found or locked by anyone else.  This is the
same treatment shmem got (commit b45d71fb89ab8adf, "mm: shmem.c:
Correctly annotate new inodes for lockdep"), following the hugetlbfs
pattern of annotating right after new inode creation.  Freshly
created ocfs2 directories are now properly separated from files in
lockdep and the rename vs reflink cycle disappears.

The C reproducer from syzbot (mount ocfs2 image, OCFS2_IOC_REFLINK,
mkdir two directories, rename a directory onto the reflinked file)
hits the lockdep warning on every run without the fix and runs
cleanly with it.

Reported-by: syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c73ff6790f3d6c635abc
Fixes: 14358e6ddaed ("lockdep: annotate dir vs file i_mutex")
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 fs/ocfs2/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index d8759605786c4..f3ec348eb709d 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -203,6 +203,13 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 		set_nlink(inode, 2);
 	mode = mode_strip_sgid(&nop_mnt_idmap, dir, mode);
 	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
+	/*
+	 * This inode never goes through unlock_new_inode() (there is no
+	 * I_NEW state on this path), so the directory vs file lockdep
+	 * class split for i_rwsem has to be done here, before the inode
+	 * becomes visible to anybody else.
+	 */
+	lockdep_annotate_inode_mutex_key(inode);
 	status = dquot_initialize(inode);
 	if (status) {
 		iput(inode);
-- 
2.43.0

