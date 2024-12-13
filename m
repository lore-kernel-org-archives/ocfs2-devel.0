Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C483918A6B7
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068829; cv=none; b=q7ijgz1cpDUdbbt5cppVf9kepmncR7R6iD5KUYSdWWZkfIX5/osO8PATa7dor7OQUwlllulXlJQZoSVTUaMP98RvKaANmmrxP5lL+K9LCVjH3ks4bwORftSPfGgH7aQywSu/m6yQVePYPmmRUzeHcurMdvj5UaGpZkpYs/lebeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068829; c=relaxed/simple;
	bh=HwkMe9hq5hr2QRbPNXcqLtCxfZxrGOY1qad0lN7B90M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h1oXSl0jyEO2hh4DjkkNEQO1GpLDR5fwhFsMilXyjRHsHtNnMhNZvYpmIR78GSEI1YAYkj43Fm1ES9IVdO6FL5V7dhRfuzP0kqREZCbpST28N6b7OfT4PBfP0RjRbQnirxXS+fBd4lJsNPyo8bqpJ6cZEb3w+2ohSibY+Zyvm/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mo0UlYMC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mo0UlYMC"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21675fd60feso15908675ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068827; x=1734673627; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmVT0W96xTTbgIHaje9qHPh+sH+dkYFHuEVe3qXraIA=;
        b=Mo0UlYMCeUKLZbM9SBx2lYrwuJq/F+O9is0dpO6JidNQ1KnhJsUINcSgur9U1Qafb6
         /yMpdJZSM6K2RoZqG3asXTVfw1mdNHtxTJQUjPWJ/SEGiX8TIhdFEmNSocoOrWrqKYXV
         Xj1msNDlqJqjciiTZoNSNB9z/azw7bB+sQv4gOIHi0btewHpqwTl1CyB2/OLfddabhB1
         g/u/sTgDOfdr95eFs63E8ifmWDTAQ2Z8gGWsSno3JwWqaxfWYa4dks6X2uH4zSMBU/1/
         zQptvV3CClwo1Y2BPMQmxQLGS6bNvHfEQrh4UdR8+AFNDh+KUcNpbY2gH749VX8DBsn/
         +SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068827; x=1734673627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmVT0W96xTTbgIHaje9qHPh+sH+dkYFHuEVe3qXraIA=;
        b=fD4JQWRTQxIOg+mmrf4MfSQmhAwwi7zKrH+kxcKk8hUXdcUbioBvLzoCc+O+p9cLiJ
         Xn93mJyevAaIfmX0CGPcV5xWIo3VqlVgJt/m1DjOf+Znojc5ELxv3MlZIYapjtQP+Uoc
         lLIxtV98IQDSgBbNiMvARXPsVhiLFgRFq30EOxuEqoCZnnCDGgcqMZanbJ1cbsPJx5vI
         5FcSlUVdOIGRwRelQZ5KBSv76gwRklCNgEm6/ifEgfNE/fjoarben+Gm/h/NVGg3nQdX
         PkMqGT+Bc3tdAteduW/IeDT98ynUXosEhUjQUjmsOHcFsIP6ES5QxbCa85J7wiC3GofA
         9TlA==
X-Forwarded-Encrypted: i=1; AJvYcCXmyXBdvmRKa0pil1uDhL7Lde6/imlHXKAMlV9zlHulXuWiYlsvMp5PUaR2uw0C72Y9fpNADb9pAX8fDg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ9oyxFAmPldCfz2980JfZtH0u9zdf/nSeRbDN0/punQHiMA4P
	L4sQyiNkgJKIoIBmdhKiZ43uU/UWtXXp5aZioohJRz/P/IDQKzlstC1UAdD1cLc=
X-Gm-Gg: ASbGncv6APPu/cE1Hzr8zP31TrlADOt/rwrF2Ir2vT/3s9kr3Sa6VGpJ08y3eXtrpnQ
	MyRl3RjM8sfKJ6LaBdsjBBTdln31YG2hbPdjN8Kqvy0YPLsOy1Yi/9NdFboQlsZnPpuSdf3muvP
	sJJll/26R+ZziP64fkWMUJNUSd0xN1CQpfaXdXU800208KZ9QfVNTtHC63HNJHL2s08YRUiBqNc
	QtS7TtofoGybu06YXI5eh5t/ojEyotxojs6jvJk2dqOPbkGw2BISGDAm0UGQ6Nt907HazjJvBbZ
	uGDuHvs=
X-Google-Smtp-Source: AGHT+IGGw/OV/ScatMLc+XWrd5qwOO8iHzpYdxpzWycga8KUsVtQ1P1ntSP55wYL5SQs/JpC5cq7/g==
X-Received: by 2002:a17:902:d484:b0:215:431f:268f with SMTP id d9443c01a7336-21892999536mr21105555ad.10.1734068827157;
        Thu, 12 Dec 2024 21:47:07 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.47.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:47:06 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/7] arch: Replace get_task_comm() with %pTN
Date: Fri, 13 Dec 2024 13:46:06 +0800
Message-Id: <20241213054610.55843-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/arc/kernel/unaligned.c | 9 ++++-----
 arch/x86/kernel/vm86_32.c   | 5 ++---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
index d2f5ceaaed1b..fb8e995823e3 100644
--- a/arch/arc/kernel/unaligned.c
+++ b/arch/arc/kernel/unaligned.c
@@ -200,23 +200,22 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
 		     struct callee_regs *cregs)
 {
 	struct disasm_state state;
-	char buf[TASK_COMM_LEN];
 
 	/* handle user mode only and only if enabled by sysadmin */
 	if (!user_mode(regs) || !unaligned_enabled)
 		return 1;
 
 	if (no_unaligned_warning) {
-		pr_warn_once("%s(%d) made unaligned access which was emulated"
+		pr_warn_once("%pTN(%d) made unaligned access which was emulated"
 			     " by kernel assist\n. This can degrade application"
 			     " performance significantly\n. To enable further"
 			     " logging of such instances, please \n"
 			     " echo 0 > /proc/sys/kernel/ignore-unaligned-usertrap\n",
-			     get_task_comm(buf, current), task_pid_nr(current));
+			     current, task_pid_nr(current));
 	} else {
 		/* Add rate limiting if it gets down to it */
-		pr_warn("%s(%d): unaligned access to/from 0x%lx by PC: 0x%lx\n",
-			get_task_comm(buf, current), task_pid_nr(current),
+		pr_warn("%pTN(%d): unaligned access to/from 0x%lx by PC: 0x%lx\n",
+			current, task_pid_nr(current),
 			address, regs->ret);
 
 	}
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index e9e803a4d44c..1f55d5c2628d 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -246,9 +246,8 @@ static long do_sys_vm86(struct vm86plus_struct __user *user_vm86, bool plus)
 
 	/* VM86_SCREEN_BITMAP had numerous bugs and appears to have no users. */
 	if (v.flags & VM86_SCREEN_BITMAP) {
-		char comm[TASK_COMM_LEN];
-
-		pr_info_once("vm86: '%s' uses VM86_SCREEN_BITMAP, which is no longer supported\n", get_task_comm(comm, current));
+		pr_info_once("vm86: '%pTN' uses VM86_SCREEN_BITMAP, which is no longer supported\n",
+			     current);
 		return -EINVAL;
 	}
 
-- 
2.43.5

