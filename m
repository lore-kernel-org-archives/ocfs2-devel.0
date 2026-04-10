Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1C3ACA7C
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 08:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775810310; cv=none; b=k/LoXAD0gkF2raeWCFK/F1KnGykMrRfxnQelmgjhcjdaEPsNpT+uX7OYZmP4Lq8hP59vWktJLqFn8ZmTacJBN8lqO0n8RZgS1JNij0JBkJzUfErGD2hBvbBEmAJdLiKnxd16IXU/0xBcZA/jTc9Kwb1L1rMJUJa4EreP572HKy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775810310; c=relaxed/simple;
	bh=bRFfwWqxtROOmMvA5wMfWrEhsOd7ovxN61oJJ3NRzXI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CayXxa3lWKUbCxwEvhZzJO/LBllfUIEPMm07l9nfNI+geh5lH0wOYSQUUWYXpJKZ9M1f2jK77q/OmB+2YdazCOLZPHDoTRuUPdOqmlDb6aCQZeXhO2d8K73uJbo8vIoKtfZ8+wJeDLQpJX+TKVPMAFZqkCl9xEEmkfaLN5yHKuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/rkxnJR; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/rkxnJR"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1277863a912so47203c88.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775810308; x=1776415108; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n5jFcmdCiIzOu2lLhlYUItJyQUxl4geRAsp3oIy0d64=;
        b=Y/rkxnJR/QsF4EnNUJURX8QtTV14Vruger9WIb3jedwOFv2on6Ve89AHLVKRx5hClc
         ZliL6xU4ItVBaoUY8A08wKh+M6KVJ5oBYYS+NP0zzV2Tsumwatf9/wmcHkHjEiHw154g
         0fb/KVUcLQQGHWy+CPr6LpSkxhbcv9G7bVIgGrVZ2uP2mk/QzBY45RDzzF+uxvnp/2Cg
         bVQr4dUGgWNJCt9UB7g9sRB8y6pqKPFQqzY3oGN5AtX00MFuFL73vBGN7aceQ/qqXDbY
         mSq3mErz+yy+z+rCx66KKvS8EQJkpvd7yjXs183pissJA9xLIZGmbQKMPxs4IyNGFQZE
         0f4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775810308; x=1776415108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5jFcmdCiIzOu2lLhlYUItJyQUxl4geRAsp3oIy0d64=;
        b=PtGVCmGmECU2Pn1b5q/1WjTR1z8urBKp1peu5vdf/JgK/pAH1CyttasNSjAkPBZuHY
         g+OzRae/8Sp/ClYgJvbL8np5L4yOLWC+XG8Qq2zLhBpZ4unUOkmQxuXi1d8hpALQVrvX
         LzM3YupIMSSkeQSgxmmNiNaHAXLrClx0O4e8YbmW1EtHEY4LSDieX+r9xIF7bu7igwbY
         zwxSnOGaWVBoRBZTg+tCjJwb6ygYcJtgsC6g8JDrQHSxTO1VYOeqUFK8Ni8lvgu3aY8p
         3ftVFGDNqDZjyrfl8VTm6Igu3Zu0/EoCQ+1HJjNfilqmAHmhw06gDLwaS6GX3fwbsuHg
         df6Q==
X-Gm-Message-State: AOJu0YyTMrCH2OiG2azz2YRfZJoWu3wnDvb4zecc+DADARPLes69rLyw
	cWJgaEMEE0TyyseLLt11fXlRkYwm1ddbrCwk5rBjGxWw0Wr+xl5+VGpQwZW2isRC
X-Gm-Gg: AeBDiesut/Vbs8ydE9OCRRmZUjEjwKjwjUv3/jxAeSd7rDlxDEdUqyicfCJ0Louv9ki
	g00nZPXuIHvaqRbMn54klaV3xFp9hqvHiZpzYoRyNj73cUAdBqc9h9HxsevsjqcOwkDzUI9SzKA
	hfECi70UVGvqlFand5x6pWRJtFitF/DUw46OCit/BTxA2ao/3OLR4vVRXnaBDaZ7kPYI85eeOAP
	ohWTnWLmW+/C07gWqsJjwHOIpjalWkW8c9wsBx0jjYuOEz3pgrEjHACidXfH42kSe0VfUlJkopv
	peMUjtHurz6Gfp4mhsZJ/8YChqseMZunUdzWhBVURrMO8wWM0fns3AU2p9hMbVotp2koUlnAYGp
	fnUyuGijTy1Eh6OHcNEHPS9iWeWJWnjkzCidZgNklWEw+mL3qL9UEncEFqmZ3m5gYpDUleqEykV
	4K6T9JrFiSAtsUgM1l
X-Received: by 2002:a05:7301:4089:b0:2bd:db75:c28b with SMTP id 5a478bee46e88-2d58a39c93cmr490364eec.7.1775810308293;
        Fri, 10 Apr 2026 01:38:28 -0700 (PDT)
Received: from macbookair ([2600:8802:2a09:a700::2791])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d562ac344csm3172631eec.25.2026.04.10.01.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 01:38:27 -0700 (PDT)
From: Tejas Bharambe <thbharam@gmail.com>
X-Google-Original-From: Tejas Bharambe <tejas.bharambe@outlook.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: [PATCH v6] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Fri, 10 Apr 2026 01:38:16 -0700
Message-ID: <20260410083816.34951-1-tejas.bharambe@outlook.com>
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

Fix this by saving ip_blkno as a plain integer before calling
filemap_fault(), and removing vma from the trace event. Since
ip_blkno is copied by value before the lock can be dropped, it
remains valid regardless of what happens to the vma or inode
afterward.

Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a49010a0e8fcdeea075f
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

