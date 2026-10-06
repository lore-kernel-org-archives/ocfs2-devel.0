Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC7D3BB689
	for <ocfs2-devel@lists.linux.dev>; Tue,  6 Oct 2026 12:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791289802; cv=none; b=gceYuksZuxpR7Ypo1AkCqMF2CHcCW3NSVnqCEoo0xC9ykTRhQDRq2uVONvnf27apmGAsRWuo9AcEeMo1X/muzoTAdzWLBdlUoyxC+5Be8Lt+Nrpya1LChhg6txJt0J1acds0052ug/nQYz2JhSsEt/u94/CyIsfLYI4eCxF7RyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791289802; c=relaxed/simple;
	bh=LR2U809jmcLqe6/1R4HYlcvGcjd9RXk3n5XV4Y5q2LU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=L0hPeQ+sLiGV8roWTDRljmZpQpuR5/V8r4lYxecSZ89RTdiNzW4Tr1m6IAzro/7qQT7++WSZP4QELW70le+ja1BFD+aobuI0Z+/owJl7YiVmaKVxnfiMJOT2lVnvxsQOP8ZoauQwF4Sx/IqAG3JjY46HnbFsFoNiJvlBiXorax8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=jQJv8aqg; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="jQJv8aqg"
Received: from ubuntu-jammy.. (unknown [91.79.139.3])
	by mail.ispras.ru (Postfix) with ESMTPSA id 998FF402837F;
	Tue,  6 Oct 2026 12:29:38 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 998FF402837F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1791289779;
	bh=BKBLXEA4pqAaaEOi5MqPw1pne2B6VSvXehQSyxAjCEY=;
	h=From:To:Cc:Subject:Date:From;
	b=jQJv8aqg5r9Go2zX0tkhQlF9D+OZdYfKG9x7cwmHtUYjPLfGjV4XlrakKpO3sYhsf
	 xQoCx+QEFmFIRvnHyDwVhHHuzip4NLtfwEeeT7Q1BTB7en6x9H/SWSDGrOdLe63Iue
	 DcymS9r+TW19fvahKP1WwTqrdFwRFm9Fvlv2RgQQ=
From: Dmitry Morgun <d.morgun@ispras.ru>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v4] ocfs2: validate la_size before ocfs2_clear_local_alloc()
Date: Tue,  6 Oct 2026 12:28:42 +0000
Message-Id: <20261006122842.1537-1-d.morgun@ispras.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

la_size, like the journal dirty flag, is read from disk. If dirty != 0,
ocfs2_begin_local_alloc_recovery() is called, which invokes
ocfs2_clear_local_alloc(). At this point, ocfs2_clear_local_alloc()
uses la_size as the loop bound without validating it first. If
la_size is oversized, the loop writes past the end of la_bitmap and
may eventually start writing into memory that has already been freed.

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

The existing la_size check in ocfs2_load_local_alloc() runs after
ocfs2_clear_local_alloc() on this recovery path. Memory corruption
can therefore occur before the invalid size is detected and
-EINVAL is returned.

Reject inodes without OCFS2_LOCAL_ALLOC_FL in
ocfs2_begin_local_alloc_recovery() before copying or clearing the
bitmap, returning -EINVAL. The recovery code interprets id2 as
i_lab, so it must not proceed when the local allocation flag is
missing.

Add la_size validation to ocfs2_validate_inode_block() for inodes
marked with OCFS2_LOCAL_ALLOC_FL. Reject zero or a size exceeding
the bitmap capacity through ocfs2_error(), which marks the
filesystem read-only and returns -EROFS. The flag check in recovery
prevents a corrupted inode from bypassing this validation by
clearing OCFS2_LOCAL_ALLOC_FL.

Keep the existing size check in ocfs2_load_local_alloc(), whose
flag check also accepts OCFS2_BITMAP_FL without OCFS2_LOCAL_ALLOC_FL.

The new checks can also return errors during node recovery. The
recovery thread leaves a failed node in the recovery map and
immediately retries it, so a persistent error prevents the loop
from completing. Release the super lock and exit through the
worker error path on failure, preserving the error status and
leaving the failed node in the recovery map.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
---
v4:
- Supersede v3, which was an unintended resend of the v1-based
  implementation.
- Move la_size validation from
  ocfs2_begin_local_alloc_recovery() to
  ocfs2_validate_inode_block() (Joseph Qi).
- Reject local allocation recovery when OCFS2_LOCAL_ALLOC_FL is
  missing, before copying or clearing the bitmap (Heming Zhao).
- Keep the existing size check in ocfs2_load_local_alloc().
- Release the super lock and exit the recovery thread on error,
  preserving the error status and the failed recovery-map entry
  instead of immediately retrying the same node.

Link to v3:
https://lore.kernel.org/ocfs2-devel/20260831143734.7243-1-d.morgun@ispras.ru/

v3:
- Unintended resend of the v1-based implementation.

v2:
- Not posted publicly.

Link to v1:
https://lore.kernel.org/all/20260810113508.8513-1-d.morgun@ispras.ru/

 fs/ocfs2/inode.c      | 13 +++++++++++++
 fs/ocfs2/journal.c    |  2 ++
 fs/ocfs2/localalloc.c |  9 ++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9a6b1af4c..cc2233268 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1477,6 +1477,19 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (le32_to_cpu(di->i_flags) & OCFS2_LOCAL_ALLOC_FL) {
+		struct ocfs2_local_alloc *la = &di->id2.i_lab;
+
+		if (la->la_size == 0 ||
+		    le16_to_cpu(la->la_size) > ocfs2_local_alloc_size(sb)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: invalid la_size %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(la->la_size));
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7f5fd16d3..46983a061 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1525,6 +1525,8 @@ static int __ocfs2_recovery_thread(void *arg)
 			     status, node_num,
 			     MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 			mlog(ML_ERROR, "Volume requires unmount.\n");
+			ocfs2_super_unlock(osb, 1);
+			goto bail;
 		}
 
 		spin_lock(&osb->osb_lock);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c4426d12a..c5c80a17b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -504,6 +504,14 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	alloc = (struct ocfs2_dinode *)alloc_bh->b_data;
+	if (!(le32_to_cpu(alloc->i_flags) & OCFS2_LOCAL_ALLOC_FL)) {
+		mlog(ML_ERROR, "Invalid local alloc inode, %llu\n",
+		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		status = -EINVAL;
+		goto bail;
+	}
+
 	*alloc_copy = kmalloc(alloc_bh->b_size, GFP_KERNEL);
 	if (!(*alloc_copy)) {
 		status = -ENOMEM;
@@ -511,7 +519,6 @@ int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 	}
 	memcpy((*alloc_copy), alloc_bh->b_data, alloc_bh->b_size);
 
-	alloc = (struct ocfs2_dinode *) alloc_bh->b_data;
 	ocfs2_clear_local_alloc(alloc);
 
 	ocfs2_compute_meta_ecc(osb->sb, alloc_bh->b_data, &alloc->i_check);
-- 
2.34.1

