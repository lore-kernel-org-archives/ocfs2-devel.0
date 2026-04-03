Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3333B6DC
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 03:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775188429; cv=none; b=WMV+ziGJ82esyzwgUST/jOmSIZ2se80XESZIrat/fizD+nsa1cmnG7/UmQfbkH0FOU6IFC2EZ4i7jL5qi3YOE+XYGOH10X0f4geGuFt7QS8FxOYGpEeGG8fMNQznjFuyFgByk/Z0nr8b/rUvLWwpMyTSgYnOvpo2QU1docJTVq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775188429; c=relaxed/simple;
	bh=Kq6u8Iu3bu0n+bBK07KN2oI6tH3HoOhAkahw7ULZs0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmjC1dlW6ZjtAbU4dwfuV6T3Sd/7i6k4wJGphQfsTobABk+6ybG3kNv2g3n1OvSgkZis87CcFuncgINHNBCQppt3a4ghlV8tKPQ8B/8NIOrq1SC8js5kpMe71lLE7821hIFjYe2V8nS0JVuJcZcuXoKmSdwBzH4lc+6TNhswsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HZfgB0Sr; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZfgB0Sr"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2bd801b40dbso145826eec.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 20:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775188426; x=1775793226; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+LnRELhx4WGvfyiMv9TNoo2v4m61WEl0oLbVEZ8jYJI=;
        b=HZfgB0SrrpZHi0CYhz51ezeazHHh4MIOd8NUQUZSLT2m0MGuiuW7amEv1UGdfUYD6Q
         eeLRQU8I/45rW6lAL/wE5+HL+tME45QzbccdBqoUks4tQTyVZ0+j3AZddQAB66N37ci+
         ipV7UG51oqDSvLleitOptKF/rng/Lta5QLhRRI/Sby+T60q6+qZgedBYOK9auXhns0oV
         fCiEkrc+8G37DGo3b2doytLe38nchX0A0HuBl+dmS5WyCtlz22aee93oQZCpXISE0cjO
         pIuwr7x2RrNP4wfdy5x4jJbUOplCFSu+wA6sz+hY95khaamHAPImXz8H27pj9p/s/ju8
         iBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775188426; x=1775793226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LnRELhx4WGvfyiMv9TNoo2v4m61WEl0oLbVEZ8jYJI=;
        b=ontrvg8+uxIvTAgasdjaJE5beh+6UXKMQYzLIqxn8xPkbTw6YbUDfyX3vvh0apZKQ+
         T7+wF5ta6m+LwC+Clf7pD6bIruySke+RnM8VI6BTlIXxNx9B5Of1lTr0anHtGkNQ9e6F
         BwjKQq/SekL8ep/tcXa2Em+TwoGZG5Bo30E+CrRoGmdlX1i+srXsGk17ubcljGPq2q/U
         1YnUIXVCuuzPyJ2NnbpflxnaSDaraGzlQ/q9dK2rJImmIM2asu292q0dlCaig77rGVmH
         ahurOHEsPOccdkSlnsYMxnBuO5TFbcrfe78w4QH5H3MiosJ41PK1GxR1jfyRPmST1+Jg
         TH3w==
X-Gm-Message-State: AOJu0YxVSvPd++qDJ076yzqWM+qcmMyPO1vMHje6OuEwrJjYNFHsXh4U
	swxGW0Nu+cphvGeF2kKvba6YwlIbc58VNH/wreDCEoVF8rtFPCUse5hI5YmkF2a9Itc=
X-Gm-Gg: AeBDieuBnd+oEbbmtrKLWS8a27QfKbP23fWGlYpVb1Qrdu2ZGs2eQuMFG4PLKf6NvCi
	sgSCnQkVBYVSMq3tQEVxaLfHObRvOWh+k6nJxO6VPGbHUnAI00YtYeai14h+liY15qzoZXBBgi+
	MbylxnML4MR2xYscvT4onR+3f0haXzxT8DEUCYFGAL3ujNlYaJe+V0CKzoYHgVPTqygu5XdOw9L
	wQnSu//A4d6N7L+UqCKSkT+P2XwGgXDlnBddV14tRku6cYp3DhMUcWn+6ebG4vnlcoebb5hyfp8
	vkm+k2citS2P8KrfJWZ3GcmrRpyRetkaqFfU0fOD69WLJidevFAeKgSB3jJjbj3piUIObit4fK0
	L1XPGapE9xJK2txk5VwvkMPzFkRLSPmVE2zXo496of67YH10Mj2GeZKvu/fM4Zu+dQGxBI8C0ng
	Wn/oprgfeks4rkgazfqg==
X-Received: by 2002:a05:7300:4347:b0:2c0:c961:4b98 with SMTP id 5a478bee46e88-2cbfc85e0eemr354507eec.7.1775188425702;
        Thu, 02 Apr 2026 20:53:45 -0700 (PDT)
Received: from macbookair ([2600:8802:2a09:a700::c877])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7caeb83dsm6587414eec.22.2026.04.02.20.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:53:45 -0700 (PDT)
From: Tejas Bharambe <thbharam@gmail.com>
X-Google-Original-From: Tejas Bharambe <tejas.bharambe@outlook.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	Tejas Bharambe <tejas.bharambe@outlook.com>,
	stable@vger.kernel.org
Subject: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
Date: Thu,  2 Apr 2026 20:53:33 -0700
Message-ID: <20260403035333.136824-1-tejas.bharambe@outlook.com>
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

