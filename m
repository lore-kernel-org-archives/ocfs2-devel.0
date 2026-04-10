Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A293E332EAC
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 08:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808297; cv=none; b=MSGZ1BNTcrqo3frPrmUJX3Mzqay5tOr5TthhNyYEwRqeKV1ExEvP1M8bAr510G6lG6qvECrCKIGarYK3vwGgdSKMN0BMK3n//GYMOzd7DxomrqRhNBRt2/yx7R1YJztDtIvsfmboAF2ReWVbud2KTL5WhBUxMnl9L+JY+uwMgRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808297; c=relaxed/simple;
	bh=2vzGcnNhpiIAONLC17Hy6GpLRRZRjPyICSrVDETbAEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DIVux2KC+hocTq8v0JioANlNXLQ99PWIMyTo1tMpD+ZNEvCQ++L05XTmJ8F/CGGmIoPj8SUBvbyhCCNeobGwqpgN29F3qnDu6B9BZlE7pYJ0dhMcP3U7tFQvPzPZ/o7loii/eM5sR+Zyx6YvLJcpRzAH6HpcFxhp2G0Ax+pFRIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S72I+TjI; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S72I+TjI"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-128bae6a35aso549272c88.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775808296; x=1776413096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cGYShwk/FAKXSlmM6Pq7ffufoxw0zBbsv7DQNDGdeZ4=;
        b=S72I+TjIv0rNqU0608K+MWMVaU3snB4efEB5d43NGShChJx+XpfPQE58nH2p+vV+pI
         ATPgVhNvlaUXjpmAHCmGjME+zx3yT7N2rKo3rRXHJG8/Di5+p+uUnTJoUC+Ic3NRDaC8
         ZbmAw3OmQwd9SeVvK4gI7Vuod7rWQA/w9OFgY3qPvFC7yn2ECt7cii8Tn7WqNCKTXnlA
         A+lBJkhKCPFVNA4oilzwm0eIH7x4E/mf82sxLeSLKtYquTgk/NoSMmxuc7hLJ5zyi8/B
         dpwhypE5wdJzZqLECN5RSzB/jdjvqLnMjrzKz8kQqZ50K0IQINz9T/Fpn6Xt+hsLeybs
         f9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808296; x=1776413096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cGYShwk/FAKXSlmM6Pq7ffufoxw0zBbsv7DQNDGdeZ4=;
        b=O0X2T6U6JggVfUHVGD3H8ii6wqvKazGYMcQj1xiY+mpXjhpDcIvP6k8u2+STvGQAVb
         zIJQfDdHG/bxuhHi9gxaHzQRq8l/xQ3IDCoHvuxnBw7HCQq3WKFkg/I7cmk4StBX+zkg
         5UKyJqlt5zcWeJ3OpTxXLxolFkbxehTQ4wNNYAb0KCmq8DWo44W0L3Gf4sFLEMzHbawQ
         dpAEFISdjh6YmZjcX0BlhSF59SjwYzRcX2joCFPSnLWKfXI/ZgbuvuoskL/qLG140b3x
         qBYvhBgyVcnp1Xd32R3U75BL5pGL2glV9ZODAH5gVf5rNEs+dWXfmu5MkAfHjnE4iTb1
         Ao1w==
X-Gm-Message-State: AOJu0YwgKlAcFvPBptutx94QtvJ5wH2OWYaBP+2VMAWhii8kCC4io937
	G15wV+/qK1TT9vtYzd5k3c3IMIxPWpuDyJOyi7txpm09VfKzK75wkgGmA/hRp+V4
X-Gm-Gg: AeBDieujGkEkTo+2j5Ao0B884BTjsLZKlCvEahSnGD82LzXfXmaodUhmRiKzapCnqpU
	SF3XJhpcuhK4iUgZYVIhA1CyZrNFEonjIXTWz/HT0fipAZWrz96+Ju1ZfFvOjcIE1NBk0UBas3e
	UDcG1OkirlnDAehNNBSjiT1SywR3pSxE/yfpfnFTiIm/rYALsxNMFJyVXWXoxMwTjldxbESil1Z
	Y501c2qt8CBbDWUXsETROMKLQWXvHfVe28+v8gxH2lYEqrxxHAiWqkkBujlyl6ZeSOaKhGgeUDB
	0O6mWm8FZhyMqHCw1HWwzanIuHqp0iOQ6uGdYtHnuTiJT3H8GwxZgR88KIueHvHSVKhFTQrbw9g
	lotvVRBSDnxggVfeQczEoRK6QTXsNnFAVnKgCItSRQiY4mGLHQ1bbDiz5JICDrtd7Bv3XeYC9zn
	rF+4aaLmz6jVtAejgs
X-Received: by 2002:a05:7300:a984:b0:2c0:c55c:156f with SMTP id 5a478bee46e88-2d5c39f4a6bmr345876eec.4.1775808295434;
        Fri, 10 Apr 2026 01:04:55 -0700 (PDT)
Received: from macbookair ([2600:8802:2a09:a700::2791])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d55ff826dcsm3103870eec.13.2026.04.10.01.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 01:04:54 -0700 (PDT)
From: Tejas Bharambe <thbharam@gmail.com>
X-Google-Original-From: Tejas Bharambe <tejas.bharambe@outlook.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	stable@vger.kernel.org,
	Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: [PATCH v5] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Fri, 10 Apr 2026 01:04:45 -0700
Message-ID: <20260410080445.29422-1-tejas.bharambe@outlook.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tejas Bharambe <tejas.bharambe@outlook.com>

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
as documented in mm/filemap.c:

  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."

When this happens, a concurrent munmap() can call remove_vma() and free
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
dereferences it -- a use-after-free.

Fix this by saving the inode reference before calling filemap_fault(),
and removing vma from the trace event. The inode remains valid across
the lock drop since the file is still open, so the trace can fire in
all cases without dereferencing the potentially freed vma.

Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
Cc: stable@vger.kernel.org
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
---
 fs/ocfs2/mmap.c        |  7 +++----
 fs/ocfs2/ocfs2_trace.h | 10 ++++------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 50e2faf64c..6c570157ca 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -30,7 +30,8 @@
 
 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	unsigned long long ip_blkno =
+		OCFS2_I(file_inode(vmf->vma->vm_file))->ip_blkno;
 	sigset_t oldset;
 	vm_fault_t ret;
 
@@ -38,11 +39,9 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 	ret = filemap_fault(vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-			  vma, vmf->page, vmf->pgoff);
+	trace_ocfs2_fault(ip_blkno, vmf->page, vmf->pgoff);
 	return ret;
 }
-
 static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 			struct buffer_head *di_bh, struct folio *folio)
 {
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 4b32fb5658..6c2c97a980 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
 
 TRACE_EVENT(ocfs2_fault,
 	TP_PROTO(unsigned long long ino,
-		 void *area, void *page, unsigned long pgoff),
-	TP_ARGS(ino, area, page, pgoff),
+		 void *page, unsigned long pgoff),
+	TP_ARGS(ino, page, pgoff),
 	TP_STRUCT__entry(
 		__field(unsigned long long, ino)
-		__field(void *, area)
 		__field(void *, page)
 		__field(unsigned long, pgoff)
 	),
 	TP_fast_assign(
 		__entry->ino = ino;
-		__entry->area = area;
 		__entry->page = page;
 		__entry->pgoff = pgoff;
 	),
-	TP_printk("%llu %p %p %lu",
-		  __entry->ino, __entry->area, __entry->page, __entry->pgoff)
+	TP_printk("%llu %p %lu",
+		  __entry->ino, __entry->page, __entry->pgoff)
 );
 
 /* End of trace events for fs/ocfs2/mmap.c. */
-- 
2.53.0

