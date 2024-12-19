Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B74146A6B
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575713; cv=none; b=h0k0lmX828nzZe4Zb8Oyok+ift+bZ1O2Bq2L1UIO7BlzNpH7nmCWqqthQKqELk/ce22y9zLhT8H3FxleQlN5lYoB+HZxpbo/Opq/2tNPc4XpE59Xa60/V31tv76SjGaIzn7zv3dqbFjzjM8/Bl9xdvMS0e6LneCTdDK+hi7lJiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575713; c=relaxed/simple;
	bh=fjvo4dYkUreQMMEsg3L8KRAKXKBd4yx0ng+KH/F5vq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uhz5PMSOzmyyUwJit7Ip8pmZ/dGyrowAgz02zk9gYsu3zM8gd4JxVUku9qfB2iQ2osOYrYM7wFfufVu6CimgmSNlLToH2aiQKN1sudlwpVKKa01Rl8286dVCtg9uBRDGUzEtn0VTIbn46gpshIKS2maxoaKVODy7qr8er+U74k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxpr6qjR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxpr6qjR"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-725ecc42d43so279660b3a.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575711; x=1735180511; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFcOX4O91tQFD6muydW9g9dtgYf4vZjGzF6jEGHBeGo=;
        b=jxpr6qjRIC3bsrV8Hfw5Q/uz72e6NeA6qIOVGxabARJayyYIGITvVZHeDVjBn0PFSt
         U1ZbvmFna2/llGyja6Or+VPku7nbMX4FpqkmM2LxW0z1UjoCZbNAu+P/7i1VFl1Pc7Cs
         0Qwpiqww/B6ka2/dIuOsh6IIX/K1nkFw9O67i0CfxnpIf5c6WbEBzKkAJdNgpemZsJQH
         serdyT/LaEtYBvRCFpRiZ9X9R313Hflj3qPRNduHCsdmiISNNlwl4tabjjMWmKcNFlYy
         p4XgFkznl3rfmtsJHz5L81Nixj9bwgnMqp9JuptDaN+uJ8h963S8tRL2ADUf5t5xzGvW
         maNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575711; x=1735180511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFcOX4O91tQFD6muydW9g9dtgYf4vZjGzF6jEGHBeGo=;
        b=vG5kXhL4o6662NUefWSMuniE4r5elnVQ1mZb3FXka8jZHpJHV2zw2jfGzYGZG+RoY9
         /sCW/xJ/GzWMkorEtfR3Lt7MKkowQL1+pzX6a7xHWDuP+cUb12EQuj/YwQBhllaQgi1m
         4T3eWfHi9oqXgXoKKG3hqD1ZYQvKLzXfSG+ZDXUwx+u1c7eO8xjfEKuqVi1I9WO8ur2Y
         Ll0QiEIl4CNChgFt4Lv/x0sGlwU8eZk/r2fXNpQ/iqfYoPNLyzjVpqOBh5O0hr6uTJki
         aN5cKTe4ILHD1XltRbyFPF9DB+vIt9BxuAQ75gseMQLJD3WjYYzznqMre/1oqbkrWI5V
         nZ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu1XDlGHJUUVbflu8MyrkB8QcHutB++4gyci7uRWaTLkZVBdfVvFr03xoy1B/2Jq9iR+nhm83hdHIrBw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHfXsvjSe2qvbsuFRHGQRV3jSSaXbxmtBqtzJ1BBaUG57x1w5+
	86NYF9GTl9Qa93FSDJwlq/z6VdcrOiSHxRMxgBbI/sb6IioSJwUnLXGtOyklsn0=
X-Gm-Gg: ASbGncspL5JbDNwX8dJHuaQ2gSj0QyNoqWa+94nANE0tWpCV8MaKxSfwijtBFSdalBC
	Xpvw6i8fERKvYvihLpJdii9/OkwdW7hv4ohYhnJwuELl+Eyv0VGfm+RuBHN/Gguhbx6K0vMf9kt
	of5vzrUjwKZ2+9g5RlTBY70KK9b/fWs5JeV/cdZB9pg9NO9ySsAfMCqjTN5C84CnQkvuGrJgvSf
	whOyipSa8+wq8KT5Q56F8PLU3Th2Xun/x/zNCqGeD8Sc3VvLQxQZfU99Zw4CMXXGuf3eNWdFjFd
	lpxT7A0=
X-Google-Smtp-Source: AGHT+IF8uDHPAeHRKoSWXDpZOfxN83+9I3jRkG5wW7qXuv+87XI+9vIxsP70Tcc6kEOf0TdmQfwRSg==
X-Received: by 2002:a05:6a20:c6c2:b0:1e1:ca25:8da3 with SMTP id adf61e73a8af0-1e5b4820f26mr9200947637.20.1734575711218;
        Wed, 18 Dec 2024 18:35:11 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.35.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:10 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org,
	pmladek@suse.com,
	kvalo@kernel.org,
	bp@alien8.de,
	andriy.shevchenko@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/5] arch: Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:49 +0800
Message-Id: <20241219023452.69907-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241219023452.69907-1-laoar.shao@gmail.com>
References: <20241219023452.69907-1-laoar.shao@gmail.com>
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
 arch/arc/kernel/unaligned.c | 5 ++---
 arch/x86/kernel/vm86_32.c   | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
index d2f5ceaaed1b..3b2d8b1bd271 100644
--- a/arch/arc/kernel/unaligned.c
+++ b/arch/arc/kernel/unaligned.c
@@ -200,7 +200,6 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
 		     struct callee_regs *cregs)
 {
 	struct disasm_state state;
-	char buf[TASK_COMM_LEN];
 
 	/* handle user mode only and only if enabled by sysadmin */
 	if (!user_mode(regs) || !unaligned_enabled)
@@ -212,11 +211,11 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
 			     " performance significantly\n. To enable further"
 			     " logging of such instances, please \n"
 			     " echo 0 > /proc/sys/kernel/ignore-unaligned-usertrap\n",
-			     get_task_comm(buf, current), task_pid_nr(current));
+			     current->comm, task_pid_nr(current));
 	} else {
 		/* Add rate limiting if it gets down to it */
 		pr_warn("%s(%d): unaligned access to/from 0x%lx by PC: 0x%lx\n",
-			get_task_comm(buf, current), task_pid_nr(current),
+			current->comm, task_pid_nr(current),
 			address, regs->ret);
 
 	}
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index e9e803a4d44c..e6cc84143f3e 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -246,9 +246,8 @@ static long do_sys_vm86(struct vm86plus_struct __user *user_vm86, bool plus)
 
 	/* VM86_SCREEN_BITMAP had numerous bugs and appears to have no users. */
 	if (v.flags & VM86_SCREEN_BITMAP) {
-		char comm[TASK_COMM_LEN];
-
-		pr_info_once("vm86: '%s' uses VM86_SCREEN_BITMAP, which is no longer supported\n", get_task_comm(comm, current));
+		pr_info_once("vm86: '%s' uses VM86_SCREEN_BITMAP, which is no longer supported\n",
+			     current->comm);
 		return -EINVAL;
 	}
 
-- 
2.43.5

