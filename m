Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4911CCB4E
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Nov 2024 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732036167; cv=none; b=JILR4rX+nDB9iCLB+HSFqDY1BdOK/r5AhwIxA5uru9lVa/OLJRWLu0eXguDJIi6WKyCGT1wc1GqOlQ08x+JlrWIRE4LCUfZ08YdAtcbmQr2wTrUxMFr/BZ66o/Rj/mbEFAh12Mq4ebN5w+JN4BrCGTCNErt2ipcpoNEvaesStb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732036167; c=relaxed/simple;
	bh=C5op0QE/7YogOAHEV6xAQUSzu4Nievv4AeTlWU0HJ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sgfwhPFZf+LY4DhLY2B5ilXcifoNgiYP0JzTn6S3EaeuJScrsKHlcgf9aVBwNgt2VQjExWDFXcyhKFI8M5SW6G89LfJVf0WqLfM/Z4HM8ksgU5Q7hJcBAgGe9RcydD+9CYwXLPyhIEYty2K68XSRgAFnd2WoslWATBebgObOFws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=gcpQCsAW; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="gcpQCsAW"
Received: from mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net [IPv6:2a02:6b8:c10:2d9f:0:640:f6ce:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id A7C0D60AD7;
	Tue, 19 Nov 2024 20:09:14 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id C9VDlYsOoeA0-WnhBRwl2;
	Tue, 19 Nov 2024 20:09:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1732036154; bh=TyETjPIuJnvhBN8WgRNz8gBjKwoT96okhMUQl2WaFJI=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=gcpQCsAWSLRYZmr3cvxw8ncSA1tAVPo9NUjOCcH5QnckFkSAhQ+5lL2ZQpjoeSlUk
	 UerhxZQtoFwVSbGnLzO8yLa+CGsOn7cWy/K1TtY6qGxKMyfS7iXNR33c0EL8dFqP8E
	 ltsCmbjAnE/OITRfQjUt1FiI4feUP6hOBL/kxqdQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix directory entry check in ocfs2_search_dirblock()
Date: Tue, 19 Nov 2024 20:07:45 +0300
Message-ID: <20241119170745.464799-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot has reported the following KASAN splat:

BUG: KASAN: slab-use-after-free in ocfs2_search_dirblock+0x26b/0x830
Read of size 1 at addr ffff888012009982 by task repro/5388
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x241/0x360
 ? __pfx_dump_stack_lvl+0x10/0x10
 ? __pfx__printk+0x10/0x10
 ? _printk+0xd5/0x120
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 print_report+0x169/0x550
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x45f/0x530
 ? __phys_addr+0xba/0x170
 ? ocfs2_search_dirblock+0x26b/0x830
 kasan_report+0x143/0x180
 ? ocfs2_search_dirblock+0x26b/0x830
 ocfs2_search_dirblock+0x26b/0x830
 ? ocfs2_read_inode_block+0x14c/0x1e0
 ? __pfx_ocfs2_search_dirblock+0x10/0x10
 ? validate_chain+0x11e/0x5900
 ocfs2_find_entry+0x1169/0x2780
 ? mark_lock+0x9a/0x350
 ? __lock_acquire+0x137a/0x2040
 ? __pfx_ocfs2_find_entry+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? ocfs2_inode_lock_full_nested+0x17b/0x1c10
 ? __pfx_lock_release+0x10/0x10
 ? do_raw_spin_lock+0x14f/0x370
 ? do_raw_spin_unlock+0x58/0x8b0
 ? _raw_spin_unlock+0x28/0x50
 ? ocfs2_inode_lock_full_nested+0xb2f/0x1c10
 ? __pfx_ocfs2_inode_lock_full_nested+0x10/0x10
 ocfs2_find_files_on_disk+0xff/0x360
 ocfs2_lookup_ino_from_name+0xb1/0x1e0
 ? __pfx_ocfs2_lookup_ino_from_name+0x10/0x10
 ocfs2_lookup+0x292/0xa60
 ? __pfx_ocfs2_lookup+0x10/0x10
 ? from_kgid+0x1a7/0x730
 ? make_vfsgid+0x46/0x90
 ? HAS_UNMAPPED_ID+0xf9/0x150
 ? inode_permission+0xff/0x460
 ? __pfx_ocfs2_permission+0x10/0x10
 ? bpf_lsm_inode_create+0x9/0x10
 ? security_inode_create+0xc2/0x110
 ? __pfx_ocfs2_lookup+0x10/0x10
 path_openat+0x11ce/0x3470
 ? __pfx_path_openat+0x10/0x10
 do_filp_open+0x235/0x490
 ? __pfx_do_filp_open+0x10/0x10
 ? _raw_spin_unlock+0x28/0x50
 ? alloc_fd+0x5a1/0x640
 do_sys_openat2+0x13e/0x1d0
 ? mntput_no_expire+0xc2/0x850
 ? __pfx_do_sys_openat2+0x10/0x10
 ? __pfx_mntput_no_expire+0x10/0x10
 __x64_sys_openat+0x247/0x2a0
 ? __pfx___x64_sys_openat+0x10/0x10
 ? do_syscall_64+0x100/0x230
 ? do_syscall_64+0xb6/0x230
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

This happens when 'ocfs2_search_dirblock()' makes an attempt to
jump over (presumably invalid) on-disk directory entry which size
exceeds 'sizeof(struct ocfs2_dir_entry)', thus touching memory
used by others (including the previously freed one). So just
bail out if such a directory entry is found.

Reported-by: syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b9704899e166798d57c9
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 213206ebdd58..7a8040a47e82 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -378,7 +378,7 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 
 		/* prevent looping on a bad block */
 		de_len = le16_to_cpu(de->rec_len);
-		if (de_len <= 0) {
+		if (de_len <= 0 || de_len > sizeof(*de)) {
 			ret = -1;
 			goto bail;
 		}
-- 
2.47.0

