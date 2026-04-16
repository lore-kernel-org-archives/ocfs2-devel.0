Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781102494D8
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 02:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776308111; cv=none; b=Hh1uBoZozZyVCI0OI8k3ZQtIEDbIQj6PiQdcLCFfWGFSNoRLA9nP/n3shDPMSlC/bYLxtCJ293qou3h35PPGeOTdl5tG5bUhRnlFlzk2E7Z0YxR9eLLYAvsrBv7J0GiRUE+t02YZSuSK5b4UdmRaniohpNwL4mfn0iOTI2Ch7aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776308111; c=relaxed/simple;
	bh=6S7KMazqhoVy+obkuqbNC9p0hOG+SegOff4nzVs5fcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jmTw2S6+LNvr2od+UHzi39WV04EwtQQAwN3nRqy+zYh4nU/YpU31pQAbmemkN1Xb7X0hTjRnyUtjEEsomm+zNz8ddLYFqJcDNRkeVrWS2l2OyXYBZHk3pk6R+A/yHWLJlhZx/WsNVeZ1vnEucPMCFdLMWJGSbtJE0/BGxFIxDJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jARDRvFf; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jARDRvFf"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2bda3b4318dso308900eec.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Apr 2026 19:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776308110; x=1776912910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QE/BJl1ZObFBbMpGLrFvgyiHLdE0hg+6Ibwj1dVcmZc=;
        b=jARDRvFfpaVAXFUlxW90lDdhGz2ASsr/h1YtJeqM8hkbgrK8r/eD1dZ6SsOE3sk/RP
         nSil5luX1R47iV5UlB5YIjzw8NBPEmE/WtgR48Sw5gf/Z7wLUs6sKmAig8UBiy9MRwxr
         6bjjUIo4TQI3Ngbf8B8O4aeD6b5t3aOze1bpWMkjJk935AoQXt/HWvBmmZxMytPdXbvg
         iwZZ5O9YwUwERhsDZq412+Up8Dq4SyRl44YGNN1sXbHr8PxZsidIQ6yOE9Gt45tB7C8k
         imVQWq+T8DaPJ+mjrvP3yQ3DnSaPgVWqK/eCzM2Ru+2xoEEEPuJ//ii9YkRybZcgxiNS
         cvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776308110; x=1776912910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QE/BJl1ZObFBbMpGLrFvgyiHLdE0hg+6Ibwj1dVcmZc=;
        b=KQ7ejWm8HtFiYbxPJ9gk4Ec2ZSsuVHDgqhhUtb7sW6WNEw4+QdiLZinL6qhjs5sQPx
         JxA+IujDXAYWOQoroMqo/Ml+CpnUVvWh3D+vOQUrlCiRxJBfa9bQCOsp11e4hX+KXoQ5
         ta9ZlkC0fzNwyFsLI1cC/i15bqnLwtabUX6GI+rytri7hVQ89YS6xbZPkPxvIupEabN3
         hB9T2VJg6ooPNkCZmsPOPbRqTkRVKYQQmAHF5U87BazNxVAnVtpZLvUOdqCZSCQwvpab
         amzNZMEg5kQp1jbjj+vJkjX/a1DqEcBOl972TOZuYwkFep7cpxcMO6Sf46cyHd+e3S8l
         6mOg==
X-Gm-Message-State: AOJu0YzYlzG4oImssppuahFTUT/huL4FpFkpuPj+HWzBNBazfmtNAGi6
	whxgmzxjxbgXdggQTZ7fxpl26YfqfcBN4Vbyt1DtPD43i8JbMp8Gl1nl8fBlFjxN
X-Gm-Gg: AeBDieutWHUYZ9NjlEYtJwpWHPvPk1MQZZFW8P9xZpc8ooO3BKBxUbDQZXztPnOaCAl
	9tXldncry4cHtMRpJbr1Smp5q9XHZtt91wo7Qcz+XPUVr7kYxxfZowhXScENrWM1dAuoaC7WrYS
	0tvZAAn+D+9/oxQbSdlvX73IZHO4I4xz3JPyh0ztCoSlO3gUfGB27aTjT5dExn7K+DjPtlcRRvg
	S/zLVvOBfN+S+4TG+OD/zazjPP6+xhmijN8RkdooIuKwCaHK8YBpRxKqj10+0ziHdgXQMY5PUWf
	fXaaD8G+8tTitYKuYob1fElg1E4xetdVxio5Zft3RFMa5ZGG5+sFHVeyDmMqn8fgUItEujoF+Mx
	x/6e9Iqawx0hg9yRuPbjDgvIZl0RyrI76orNNaUnYnwwZsyXukhE4zyrf+HRwiocUGpYuVKFXq5
	C3sP+4anqTr6b1CGiuzCXOS7ekQLA=
X-Received: by 2002:a05:7300:134a:b0:2d9:94b4:a1bc with SMTP id 5a478bee46e88-2de7d021ec5mr1092602eec.8.1776308109369;
        Wed, 15 Apr 2026 19:55:09 -0700 (PDT)
Received: from macbookair ([2600:8802:2a09:a700::4e5e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2de8f65f9bcsm6577527eec.22.2026.04.15.19.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 19:55:08 -0700 (PDT)
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
Subject: [PATCH v7] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Wed, 15 Apr 2026 19:55:01 -0700
Message-ID: <20260416025501.67593-1-tejas.bharambe@outlook.com>
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
Fixes: 614a9e849ca6 ("ocfs2: Remove FILE_IO from masklog.")
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

