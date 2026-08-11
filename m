Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86B2E974D
	for <ocfs2-devel@lists.linux.dev>; Tue, 11 Aug 2026 19:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477244; cv=none; b=qSjqdIzUpwxUcGoBKWP6DG1FsvWkgbdqG/YjGMN5PLvBdDA49gv/ZHnV+udyOsKgljOCzy0UgEdFQvWLLsLcHq+xZmmMAVmXNpOlY5zN1lH5M/8b66sHzSsWQpqPuO6eXiHCCFWYpFQrgSjBnnExUyrCgVjNtAnPFBry61lRG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477244; c=relaxed/simple;
	bh=BL808TLAbJXlegrSu6qlFBP+3pDDYGgdxTqdEDRZ/cg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S72iUrGHg8ugTdeQxrh0GJ9/pcWGYIUTAXm/t9jIA1+FoMEHrgjh3hH4nMdNLbGlxqoKOkGsEEtmY1je3JWy2HjwsIXyZaAgBo5Crt4TIeahEd88ZxDl9TjDUffaEfnt+KZwm3W1/gF4dyJANRJcUAHAFEpbSb16zkxcBxoB3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=XujgA+se; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="XujgA+se"
Received: from localhost.localdomain (unknown [95.54.231.191])
	by mail.ispras.ru (Postfix) with ESMTPSA id 05C09406E9BD;
	Tue, 11 Aug 2026 19:40:29 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 05C09406E9BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1786477230;
	bh=KoY4YzgHWl+H55iWJRy6ez+AYUFA0HjjC6U4505ligg=;
	h=From:To:Cc:Subject:Date:From;
	b=XujgA+se/NaZJCMlhksnvFJuf/CFz/SM+czm/cePdkfsaJ6hhKVdBuVFJckMyNS9M
	 nzcvjbM1XQA/vXyXg817BOifXQoyYpfDbjShFBW0YouZwe3Pmtgo0XniRttyAXFVuc
	 KlwniTjy1jV7LKb6t122mQKg/rC8Ev6PfKdLWz/c=
From: Dmitry Morgun <d.morgun@ispras.ru>
To: ocfs2-devel@lists.linux.dev
Cc: Dmitry Morgun <d.morgun@ispras.ru>
Subject: [PATCH] ocfs2: validate la_size before ocfs2_clear_local_alloc()
Date: Tue, 11 Aug 2026 19:39:57 +0000
Message-Id: <20260811193957.1231-1-d.morgun@ispras.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

la_size, like the dirty flag, is read from disk. If dirty != 0,
ocfs2_begin_local_alloc_recovery() is always called, which
immediately invokes ocfs2_clear_local_alloc(). At this point,
ocfs2_clear_local_alloc() uses la_size as the loop bound without
validating it first. If la_size is corrupted, the loop writes past
the end of la_bitmap and may eventually start writing into memory
that has already been freed.

BUG: KASAN: use-after-free in ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
BUG: KASAN: use-after-free in ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
CPU: 1 PID: 2386 Comm: syz.2.190 Not tainted 6.1.174-syzkaller-00520-g10c505401422 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Call Trace:
 <TASK>
 ocfs2_clear_local_alloc fs/ocfs2/localalloc.c:919 [inline]
 ocfs2_begin_local_alloc_recovery+0xb07/0xc00 fs/ocfs2/localalloc.c:515
 ocfs2_check_volume fs/ocfs2/super.c:2448 [inline]
 ocfs2_mount_volume fs/ocfs2/super.c:1819 [inline]
 ocfs2_fill_super+0x2033/0x3dc0 fs/ocfs2/super.c:1082
 mount_bdev+0x356/0x410 fs/super.c:1443
 legacy_get_tree+0x108/0x220 fs/fs_context.c:632
 vfs_get_tree+0x8e/0x300 fs/super.c:1573
 do_new_mount fs/namespace.c:3078 [inline]
 path_mount+0x6af/0x1f70 fs/namespace.c:3408
 do_mount fs/namespace.c:3421 [inline]
 __do_sys_mount fs/namespace.c:3629 [inline]
 __se_sys_mount fs/namespace.c:3606 [inline]
 __x64_sys_mount+0x283/0x300 fs/namespace.c:3606
 do_syscall_x64 arch/x86/entry/common.c:46 [inline]
 do_syscall_64+0x35/0x80 fs/namespace.c:76
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

The validation of la_size currently exists only in
ocfs2_load_local_alloc(), but that function is called after
ocfs2_clear_local_alloc(). As a result, memory corruption occurs
before the invalid value is detected and -EINVAL is returned.

Adding the same validation to ocfs2_begin_local_alloc_recovery()
before calling ocfs2_clear_local_alloc() prevents the out-of-bounds
write by failing the recovery early with -EINVAL.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ccd979bdbce9 ("OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
---
A similar issue also exists in ocfs2_complete_local_alloc_recovery().
The i_total and la_bm_off fields are also read from disk and used as
loop bounds and offsets without prior validation. With a corrupted
filesystem image, they could lead to similar out-of-bounds accesses
during the completion of local alloc recovery. Therefore, a more
complete solution would be to introduce a shared validation helper
for all relevant on-disk local alloc fields (la_size, i_total,
la_bm_off, and others) and invoke it before starting the recovery
process.

This patch fixes only the reported reproducer, triggered 
by an invalid la_size. Other fields like i_total and la_bm_off are
still unvalidated, so a similarly corrupted image could trigger 
an analogous bug elsewhere. Maintainers' input would be welcome 
on whether a shared validation helper is preferred over targeted 
per-field fixes.

 fs/ocfs2/localalloc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c4426d12a..ce03903ed 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -481,6 +481,7 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	struct buffer_head *alloc_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_dinode *alloc;
+	struct ocfs2_local_alloc *la;
 
 	trace_ocfs2_begin_local_alloc_recovery(slot_num);
 
@@ -512,6 +513,16 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	memcpy((*alloc_copy), alloc_bh->b_data, alloc_bh->b_size);
 
 	alloc = (struct ocfs2_dinode *) alloc_bh->b_data;
+	la = OCFS2_LOCAL_ALLOC(alloc);
+
+	if ((la->la_size == 0) ||
+		(le16_to_cpu(la->la_size) > ocfs2_local_alloc_size(inode->i_sb))) {
+		mlog(ML_ERROR, "Local alloc size is invalid (la_size = %u)\n",
+			le16_to_cpu(la->la_size));
+		status = -EINVAL;
+		goto bail;
+	}
+
 	ocfs2_clear_local_alloc(alloc);
 
 	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);
-- 
2.34.1

