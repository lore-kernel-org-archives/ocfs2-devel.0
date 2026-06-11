Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE813F0743
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781190236; cv=none; b=g15OtMQyTeoDJZOtqo2wbOohnNSWUABxYIdMKd1vQEDGchVnC8xw/y9eXQjlZVRj3sYVxpVaUQqLf7d4FfDCoY+MwlNyaK2f+cf5cIxRtxO5lxG+lPowAamqfu6ujVQgXWzuOy9Mr3n/6G6khi1N5NO8TtnsAEGo8H6/D2vEpGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781190236; c=relaxed/simple;
	bh=y5kJ3kajCoxBcBNJkGi0XXQnfZ1wt2bycaMh1e6fLdk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tD5VmUHsuPU+Kw5opVB9fTOBUdaSm8Spy4BscaG0Mxl4WblOThf8eyMWzidhHKPwT5RgQIP7bwMVV3fB4Ub+T3i1uUUgf5RGSxkZgJ9AoEWnp8l52trmMlelrQ/U0b9R8c571yYXFkGlWC6V7ApjyYRC1tP1e0otq8CXGabEgZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hokLnOXQ; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hokLnOXQ"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68d233bf9easo10647182a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 08:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781190233; x=1781795033; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6AH75jGOvlDPieViObPquY80uZlC/VLdOtypjuV705E=;
        b=hokLnOXQ23csh6PufJl6Xv+jLW4zgSr4NcxVOllt6etQK3oLy0xhB20/49Qd4tkADp
         A2QxPTW3FpzNOSk/DUCbdvHwAFfHHc3LvRvg5D62tdnOv0qcpgaYpEyao8A0WuEv4Ur+
         K+mtEKbeAkuoJ68QqM7wNB6KmHftNA5LAE969E+Upa9yGZ0tClN0Lo39MhyMl1ZXfSuq
         N5ohr+thVFa2ZV2+hy14eaKysMJoJf0Xza6mFXcvABYdkCviNtO2Ai8ZtdN+9aW3ZNLV
         FKv+kLXm6mGWq+BPy3TfhtNgifwj+7eC261k2Z9S0M3u9NNllAStIzY0TgiN9gaX3UJd
         XKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781190233; x=1781795033;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6AH75jGOvlDPieViObPquY80uZlC/VLdOtypjuV705E=;
        b=bZgoaB1WoiCi88qEXjsRG8fiUNQ+YuFIwch7pMHBh5BEnF61XVNMLKZhKCNuFLKdgG
         5RagUhyTYM+UDblxutPi+hRkEOM98m8W2vO2eCKXE3uJdUD+5kpK1KQg5Be/kS35oD5E
         yTpfXf684sqSRO69Vp+jK0Ef7pPU1KJMrm2xUJbnv3qKvcRO1mgUNZdWNrp5bU/jGw2l
         I3PUj97moKN8KtYG1nmGGOR/8NJnAVcYcg9eYB2JcKOjBRNgrdDqrvsLNUesC4Z6zb1X
         u1CwbogFvFxwxovRVSG6vMbEfozOMfVDTnTK0msNrxVdgFc9xcyug/OQp2cSjuJZi4Ae
         3LSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ckKFFW6wPyK+V9bLA9kCpgKxQosGmbdmja3EyKzRkJc7wulne1G5xSLzbTM32c8qN2S647PTOv7Zh6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzOccG4hUsA6TFpbQzAdGxIVDDSaMrm847VkwpOCAOPZxy/60Y9
	1SOSuOwANMrkVfyc6Cr+o8hf35f0PzHEGKW+mBoqSuX2GDZy+LzdhZofeJ/cuzqoyJLJwn04Orl
	HlQ==
X-Received: from edb11.prod.google.com ([2002:a05:6402:238b:b0:67c:c486:8c03])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:40d0:b0:68c:d4e:3a46
 with SMTP id 4fb4d7f45d1cf-6930e273a26mr1724640a12.8.1781190232863; Thu, 11
 Jun 2026 08:03:52 -0700 (PDT)
Date: Thu, 11 Jun 2026 17:01:50 +0200
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260611150341.3964327-1-elver@google.com>
Subject: [PATCH] ocfs2: fix orphan inode disk leak in ocfs2_dio_end_io() on
 I/O error
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

When an extending direct I/O write or a direct I/O write racing with an
unlink is initiated, ocfs2_direct_IO() places the user inode into the
system orphan directory and sets the OCFS2_DIO_ORPHANED_FL flag to
ensure defined behavior and crash consistency.

However, if the direct I/O request encounters an error or gets
asynchronous cancellation (bytes <= 0), the VFS completion hook
ocfs2_dio_end_io() bypasses ocfs2_dio_end_io_write() entirely and
executes ocfs2_dio_free_write_ctx().  This completely omits the teardown
of the orphan entry, leaking the user inode in the orphan directory and
leaving the OCFS2_DIO_ORPHANED_FL disk flag set.

Because the OCFS2_DIO_ORPHANED_FL flag remains active, subsequent VFS
final inode eviction (ocfs2_delete_inode) observes the flag, assumes a
direct I/O write is actively in progress, and refuses to wipe the inode.
This results in an irrecoverable disk storage and resource leak that can
only be reclaimed if the cluster unmounts or crashes.

Fix this by ensuring that ocfs2_dio_end_io() inspects dw_orphaned even
when an I/O error occurs, and executes ocfs2_del_inode_from_orphan() to
liberate the inode before destroying the in-memory write context.

Fixes: 5040f8df56fb ("ocfs2: free up write context when direct IO failed")
Assisted-by: Antigravity:Gemini
Signed-off-by: Marco Elver <elver@google.com>
---
 fs/ocfs2/aops.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..ad3f2057e26e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2419,11 +2419,24 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld",
 				 (long long)bytes);
 	if (private) {
-		if (bytes > 0)
+		if (bytes > 0) {
 			ret = ocfs2_dio_end_io_write(inode, private, offset,
 						     bytes);
-		else
+		} else {
+			struct ocfs2_dio_write_ctxt *dwc = private;
+
+			if (dwc->dw_orphaned) {
+				struct buffer_head *di_bh = NULL;
+
+				if (ocfs2_inode_lock(inode, &di_bh, 1) == 0) {
+					ocfs2_del_inode_from_orphan(OCFS2_SB(inode->i_sb),
+								    inode, di_bh, 0, 0);
+					ocfs2_inode_unlock(inode, 1);
+					brelse(di_bh);
+				}
+			}
 			ocfs2_dio_free_write_ctx(inode, private);
+		}
 	}
 
 	ocfs2_iocb_clear_rw_locked(iocb);
-- 
2.54.0.1099.g489fc7bff1-goog

