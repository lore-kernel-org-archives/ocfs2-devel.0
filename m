Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3110A18BBAC
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068821; cv=none; b=tSYl8t4YE72d82OvV8MVtN7y9N+tUxAtmD0bTdpPhA8wxL3EpMJzhRecSxufiPBbXOprq1WnZkc1zQCw15zZlBjjSd7/D+U2UTA0WrcsV3XLP/LcmTbfs7+pcBlKuiuSjwfCJJg3PrbrQakgvEPRnwr+d8MxxGAY8LjW/8bNVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068821; c=relaxed/simple;
	bh=PCh1gNdVkWHp7L2j8aSJAn81J3xtchPE0tLiHOyl/eU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uP8Ket50Nde/2WGXKtYPo+or2bpZKdAgAW40tru8l/fmPEt/m+HmGwy3hswdkFqcboBrn5LVw395M/l8gyNfPoNE8J6rbAXOfRzDHFzhTj7EeiY4EdHCmp734MV4d141hqNqSfpGV9x1mnoUBA+HpbCSs/ngMsHbmqpZtoV2KPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrapazSM; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrapazSM"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21636268e43so18023685ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068819; x=1734673619; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVaAhWgLsrOIaawWt+Es3lyBYssP2HU9Cngct4cKfGw=;
        b=jrapazSMypZ6u0IUDVHo3ctjrLJH+M7ikqrcg7oSGcMnP8Kp2H753amQ/A3SfzUUfc
         K3orRYGGI5ysVv+nzeOe+P68tILiTwYiQSZ/XMcF++R1sbAkQWObs4oKOe9RPZGbJ0pJ
         JVRPs9ugsS+L1jLn+eWEjmjH0vAf57bbvP7BKRS4GJxZ1PpxjkJEzaOyXML/ooQJla9Z
         1iTU1zb1Rm6tOXFUh7/CKrBCl7HUHfd2InfpVq7Ku9K4Y3YjjyuBod87TByKhLjBLyyb
         hHRW1nHPs3gNG071YyYHSUAQflOkx9bRcQrew0phQqoqW1Z6piYNYmj6npH3yygsJ8YH
         OLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068819; x=1734673619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fVaAhWgLsrOIaawWt+Es3lyBYssP2HU9Cngct4cKfGw=;
        b=brSBEPsyCCEwY+nylF9hcGiloXsrilTT/cqAUgzyphYRQYWFOnCeyPtUcWBl9IP5xj
         T7CxZA5D0rtFqgrJkmQ+nCS0J1tD1Mx1cOMx0NU/dbPNsZrwFaBmoUY9HQuHA0XZmWib
         NqavEgQdJDVozowj4sG8TjiAIol8ag3yLeQMD87KLuyUKB6GuHBAIX+P1OBxn4fPMdNC
         qc2wkuLI6W1R5hyDZTtmLG6soUCun4WK0PFBATfePY72IRkuaE3aODtg7BfW5J/+Tdvp
         ukP5uI4EKc5E/puVisc6gUMk0ent2WuBmTEfUrw0FjSpIKOFTGFZNY6qCtNsgTQR6Yc5
         0wag==
X-Forwarded-Encrypted: i=1; AJvYcCVgZWqw3n4ILMLwlV48OXaWDUaWjQxyhlzWt5+0U7pFE4ro+CjyPxlXy98EascWQMuknCO89+cVixiK9w==@lists.linux.dev
X-Gm-Message-State: AOJu0YyF2mbbK4EQzXC3RfMl0KOKr6+8lhdIOJUPtM7Dm8PCUW24k6Eg
	mIVVQDxM03ETBc87dSrXsko0J6Gwhr59XLEJtdCUjWAf7q47NuHN
X-Gm-Gg: ASbGncsMy29Zb8j6kbqjYjL4k0393WO0TPKBjBlIM9X1eXQptwfM9RuE79wsVD8UiNW
	Ccx1D9UmWBceFtgE4hvHS/Pu8ZQBlbtvR/VeidosP+2UH+U07rWUY5/xRy1gYN5+QEwvDIwWB0M
	K2w/o1P+I2LuZ7Gwoyo4p9XaWUQIvTzEznrBypytQ0WSG8SJ3hYJVaK0Raa/I8RHXCuRoy9R1pO
	8Iebj98CvM/u5eln0qwE9/8SOaODotTp+LEOe2moPslLucvOFQ25cbGjdH2o5YHTj+8hzBVKbfz
	T5Wq04U=
X-Google-Smtp-Source: AGHT+IGnQMpyX4qO4c9TaUxIvkW9bvqpb4HtTDVE3C9gZFkXCVV6ksZB8lAWhFJzpiBj11HO1t8PNw==
X-Received: by 2002:a17:902:e88b:b0:212:615f:c1 with SMTP id d9443c01a7336-218929a19c2mr20599995ad.14.1734068819460;
        Thu, 12 Dec 2024 21:46:59 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.46.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:46:58 -0800 (PST)
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
	Serge Hallyn <serge@hallyn.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH 2/7] kernel: Replace get_task_comm() with %pTN
Date: Fri, 13 Dec 2024 13:46:05 +0800
Message-Id: <20241213054610.55843-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copye it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "André Almeida" <andrealmeid@igalia.com>
---
 kernel/capability.c     | 12 ++++--------
 kernel/futex/waitwake.c |  5 ++---
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index dac4df77e376..4512cd797f49 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -38,10 +38,8 @@ __setup("no_file_caps", file_caps_disable);
 
 static void warn_legacy_capability_use(void)
 {
-	char name[sizeof(current->comm)];
-
-	pr_info_once("warning: `%s' uses 32-bit capabilities (legacy support in use)\n",
-		     get_task_comm(name, current));
+	pr_info_once("warning: `%pTN' uses 32-bit capabilities (legacy support in use)\n",
+		     current);
 }
 
 /*
@@ -62,10 +60,8 @@ static void warn_legacy_capability_use(void)
 
 static void warn_deprecated_v2(void)
 {
-	char name[sizeof(current->comm)];
-
-	pr_info_once("warning: `%s' uses deprecated v2 capabilities in a way that may be insecure\n",
-		     get_task_comm(name, current));
+	pr_info_once("warning: `%pTN' uses deprecated v2 capabilities in a way that may be insecure\n",
+		     current);
 }
 
 /*
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3a10375d9521..df8f8c85d776 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -210,13 +210,12 @@ static int futex_atomic_op_inuser(unsigned int encoded_op, u32 __user *uaddr)
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28)) {
 		if (oparg < 0 || oparg > 31) {
-			char comm[sizeof(current->comm)];
 			/*
 			 * kill this print and return -EINVAL when userspace
 			 * is sane again
 			 */
-			pr_info_ratelimited("futex_wake_op: %s tries to shift op by %d; fix this program\n",
-					get_task_comm(comm, current), oparg);
+			pr_info_ratelimited("futex_wake_op: %pTN tries to shift op by %d; fix this program\n",
+					    current, oparg);
 			oparg &= 31;
 		}
 		oparg = 1 << oparg;
-- 
2.43.5

