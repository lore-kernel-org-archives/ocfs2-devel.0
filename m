Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4392DA765
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 04:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775102565; cv=none; b=oRQs0a+6wWsK2NvwmbUka8no7sYmpyl0qt132MfqRihD2njJZid8pQcO6KKHDjaI0R6VxLk99IViosGYHQpAZWLlTUT9/TeSjSlb9tD5UeWoEhGQkWC6Elk+zjfmfbAqyKVGAlwZ5N25NNzejRuVm/3PBEvodDHw7seOhXoUtOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775102565; c=relaxed/simple;
	bh=vTlAbLy1Mk70Jbn1+QJ64phbGPYmNJ6bLMqM5nJNjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mii6fD4Q/zkRk1dUynfPMGUf+AgVfVMxRwFERKCSIhzEYFNycFb9yaGjuvEeSG+VvnlQexp4BAW4AAHx2KHiMJ+CYFpNw+3LYMkaiNCk8osDpuSJJ7RbwIn0lKZw7v+wasm3erzfFkw27EBlSyCx6jXtNOWEAYt5+dNO+Gup/WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sy/RfOvm; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sy/RfOvm"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2bd801b40dbso49229eec.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 21:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775102563; x=1775707363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3FoTxz190yE2mGB6TsBP35CTMcFrPN7xt52Vks8P14U=;
        b=sy/RfOvm+cbGiMNilBMUu3oopjbeyHHwVrGzBt+dkq4JVIrYp+UeE25yq8pXaAsL1M
         ssy8anGHaC6SiyYtIxgu4viMWjgywbX7BZYTjlRjQmAEO2YV0XgHb8J6MJSADmvL2I/T
         kVqiE9TI4qKkAeQYfVleU4nHY3naFZk3H/faxfeQy3gxN6Avgwa7etiMJqrrETqi0L72
         iBYzTJKNJLjH+0cRx19rp5gWROprILZvz6myjFs1IkiiAeXSdN9+OM8GoNoTpFAF4Vd5
         Eb6NbyGpnx+6zdRNkUcu00M0B+M06Q5U9HYbb3YuvJA2+9tGDrLskf/kDI7IviBnV/Vm
         47wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775102563; x=1775707363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FoTxz190yE2mGB6TsBP35CTMcFrPN7xt52Vks8P14U=;
        b=OQL+YOAg42baGc+WSeRwAd6CZ+H1LzGfxZ0AsKMZS6r+0PFjubq9TYrt+WV7xZ8uMH
         mpZxSe7VIkS9jKB/ei0/jFNemIjmJu4smmgxGrxqH6bubfAap8BWQjulwUVtcfY2TS0h
         +KuovvVacIgUpBdbQn959bNtdLKkWcet1iHQ3JAC7LR0euoT+3rbm+vQBaRIP5n+CrMQ
         CM77JQnww6zMeZgBjTVOT+b7aPS09TlbPlLBUI3Y+jsgr5bDx0+e4G3Fz78CgTS75+9W
         AN3QaC+FB7Zr1F9HwZuhCCOndlyhGxA63Xb9GvVXvAtiX86G/FuaEKnLF4IyYQIWwegC
         0CoA==
X-Gm-Message-State: AOJu0YwhmpYbYqrWJ8P6uCyDj7FVV2sWuHJbsGdxvUUDypaI/561dSwY
	ZXp494ih8BPf9F8s+1OCG48ZJBh3DTtj+SuUzR05QDxl4ZJsCOggmKMoYwc+/LLveVg=
X-Gm-Gg: ATEYQzyUx8YCq3tQOD8xHZmIiCmy2mqy77v8MQPMe8z2R4vOOB+fk19tFyEouySS7pM
	leF/yDhZ9gcyQLvJLihP0ZhpCFeuJwqkUEWsmYLBg1cQK80YM4dzoHA+ZIH977x2q03Dxl5cBhD
	bkolSmaeZVTXUGsQfGfuMCiC9ZtMtraFLxXrWb4IOfJBa+tKNb1lbT3G8fg1KhTvnxNPDYSdD/9
	W27et2vZdVwcQfFE2nvr703aiE9HmHJ4SJU676wRr5iiQsjzP/2WfvgmCtnWahewNeFNwx6RRYc
	H3nYVgePAexfSFhal6n8cOzA5muAkyz5JGY3+96U6MqzAw5x44wi9UvWHgorYRY7Qq/26z8vpwf
	eh5QFNQ+OFggB/kHF/TGZ4p72X0XKzt5NqfV4YtmtiZlXa+De5AMolsO9EzmuiLI4R/7oDIiZwW
	S0jWsuAAEIuWMNtJZMYA==
X-Received: by 2002:a05:7301:6895:b0:2c0:c55c:156f with SMTP id 5a478bee46e88-2c9327a4552mr1292372eec.4.1775102563262;
        Wed, 01 Apr 2026 21:02:43 -0700 (PDT)
Received: from macbookair ([2600:8802:2a09:a700::7048])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7c20c0c2sm1581909eec.17.2026.04.01.21.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 21:02:42 -0700 (PDT)
From: Tejas Bharambe <thbharam@gmail.com>
X-Google-Original-From: Tejas Bharambe <tejas.bharambe@outlook.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
	Tejas Bharambe <tejas.bharambe@outlook.com>
Subject: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Wed,  1 Apr 2026 21:02:34 -0700
Message-ID: <20260402040234.92432-1-tejas.bharambe@outlook.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
---
 fs/ocfs2/mmap.c        |  6 +++---
 fs/ocfs2/ocfs2_trace.h | 10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 50e2faf64c..41c08c5a3d 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -30,7 +30,7 @@
 
 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
 	sigset_t oldset;
 	vm_fault_t ret;
 
@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 	ret = filemap_fault(vmf);
 	ocfs2_unblock_signals(&oldset);
 
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-			  vma, vmf->page, vmf->pgoff);
+	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
+			  vmf->page, vmf->pgoff);
 	return ret;
 }
 
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

