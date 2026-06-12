Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4298835E95E;
	Fri, 12 Jun 2026 11:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265022; cv=none; b=ohyD97M/K6IBcvGYlL5eghDAyhs4nAzeP2xJv6cNiiMkewGYF6ss8fxNrw8uM7WbDwiis/M8Cr9stvUW1JxpXB1cp629xoLZLUI4JDvQ3AOK+yHHdQhbFeaSYaj4YBxMow3JQjkS/lK0xiDIxMYyvEE780xVaX+gSC3msjGnMM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265022; c=relaxed/simple;
	bh=IyJ/8Wuocj3os7AXbyuDpsE1KYzMuhF88DHTMXF/jeo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XltD5W8CDRavU03RhTaTrudjP16F9Y/z301UcXPCEciCwwfXKW2hudxJ1ctqUQwkRmhw1qthPQ+0eQIXjNjQhkQWlUaqigNoPQvN0bR2mnQWIGl8A1zs3C/8r7VHEZu2XL+TsfljMiE+8bbmeYfiT6KuCd2ZXgoP8lFa4e8WE0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvwPGaCS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvwPGaCS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFB091F000E9;
	Fri, 12 Jun 2026 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781265020;
	bh=VZtxHv2TZGykBc9wLBLh/8ymFzQBhTzra9ftPwVr4mU=;
	h=From:To:Cc:Subject:Date;
	b=HvwPGaCSTF02mf0P0EITMiP38FUL9kCRLVD4iY2dFNsy3X3UTeB1E6xFU0sOtDghg
	 d00h/ZnegJyhJ1n8XzZT3GAm0HnsrJOx502rCslR1Xt4HVSgSthge2CZVe2bI7qn+x
	 6Ei6q5STljCXu2Hd3bHqCY0TkvXx259mjn0zv7VTVg80WM1UrA1PDVRmfAglvq4vX9
	 tJb5rSJasTYdVuzmTJY52Wpw2Tz/ywbXFeCotGUsuvaq0Dfpf3PZuxp0PBazoeSjaa
	 FuZnJruxrIkwtMMK1a+1OgGaCR0Rk/R77ATmKtU7KZudiBK7VFDcgvVK29rXm5XVJ6
	 K886A/qFV387w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark Fasheh" <mark@fasheh.com>, <ocfs2-devel@lists.linux.dev>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
Message-ID: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 12 Jun 2026 11:50:20 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.

1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
EXTENT_ALLOC.
3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
ocfs2_remove_inode.

Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.

WARNING: possible circular locking dependency detected
------------------------------------------------------
is trying to acquire lock:
ffff8881e78b33a0
(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

but task is already holding lock:
ffff8881e78b4fa0
(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299

the existing dependency chain (in reverse order) is:

-> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
       ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
       dio_complete+0x25b/0x790 fs/direct-io.c:281

-> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
       fs/ocfs2/suballoc.c:1078
       ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351

-> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
       down_write+0x96/0x200 kernel/locking/rwsem.c:1625
       inode_lock include/linux/fs.h:1029 [inline]
       ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
       ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
       ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
       ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299

Chain exists of:
  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
                               lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
  lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);

 *** DEADLOCK ***

Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6ec198bda..4acdbb708 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 unlock:
 	up_write(&oi->ip_alloc_sem);
 
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
 	/* everything looks good, let's start the cleanup */
 	if (!ret && dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
