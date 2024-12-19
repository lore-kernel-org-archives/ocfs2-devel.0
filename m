Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30408634F
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575708; cv=none; b=mjbRluDeSUja6aKOmkMkBfQ4VFAZt2Zu/v40hE5R16g48HbbLFbGfk8aPsxLFeXXzop0oN1QJ+CnHizEEMZhTpK3fRS4Mm0YPuqO8j2/OlZVnVh2sUsJfchchexOzHr7MSb0CL37mwiKBd/qDIwvEwfY8EKw3G923YhlmNQhwxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575708; c=relaxed/simple;
	bh=yqzB/UQ5CgxwEer/KAHpFdkzi3xdVyXYQPOSmuyPZ6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7NuJA2rmFEgYMCanSqtwr0dwKdtCF/azhwM9F9zs/Vi6ZuNDBHRo6eJleZN/w675Yx3Txdzb2MgyH/RyhsVr2HFKZjcUlLq5MpTTlG6Z5PUrnLd9XEFA/AwoVsCncBUVOS2SjhC9t76tAvGFFIm3uueb+jwPgkBV5JgJnzjaXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LqRVcb0+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LqRVcb0+"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2167141dfa1so2840805ad.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575706; x=1735180506; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yZ75uwrgzXS/KAS9XiI4pfcH/Aa7U+Upt9QqSiD0i8=;
        b=LqRVcb0+jpoDNp585hO7hJpgi3QCsJZAc02zuXjyxGqt26AfS9h6sVie3NUnlfOvAo
         IXx01fm8j5IEd2fwV1LymS9TNdg5djL+luNwFx+UXFwiCS73zbhoctlQK1A1tfKmwVpT
         JtD3cOuk5gqN2Gm+y/+9EzYQ9jEcUiwJ6QI8MACMtX8tgTWPoIS+VioIbf6IRjUECnIY
         +wICLbQp9oRVIGplX1a2ho3ed8a6y45GAZnOq4Ty9lV6BMbFf5Fx30a3Nfi71H5R1kDj
         HRXf0eG74tG4mKfji3H2Oc/bvtc/TBO/E+plrsq8UGQRuzxX7e8YzTcydbpbEWo0NBOW
         Oz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575706; x=1735180506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6yZ75uwrgzXS/KAS9XiI4pfcH/Aa7U+Upt9QqSiD0i8=;
        b=PuT8yMUXZkByUaD1QAZ/aCRbqt2hYESCg1pV6hRB9bE7mm9FVdOyKWAfetgF2pZdeg
         etuX+XLA3poD14nkMDhyeRay/ztMmdqRMVka8DqMVxhP/bmediQUq7NirGmZdxk/HMOo
         KQHARPGOCLgm7JzIwchXZB6FVD1pFn/6dj7/JwhBVMGejUI0Bb3j4NpBc+l4UUSmnxo8
         TfLXz34c+cd+66QCTdIN8TiP+A3dSI7Ya8IpD1JB5u1MVeQkLY2Ve8HMlKdrxnrSymB6
         Ow2soQkUyBQPrNKBHaO5rlLnc826xa/FRHTho/lAjQ3r7m7k+IzFJemzhxkoV/EtqrZl
         4RgA==
X-Forwarded-Encrypted: i=1; AJvYcCVet0oBEwEcKIHABD9uW/2jSC0Din0UpCROicp7mF8rZF4DUOyCqbhM443Z3aJWMdMZyCgzyHnLYVJ0lw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxUINat8EMJJ9pZaG6D0VQqMvo8xTd9poc4EVQ4j0sakd9DVsQe
	qE/SnQt4NYIbVUtpeWO4EY44mg77aQIPB+rcODb+mEtDf61l89+R
X-Gm-Gg: ASbGncsFTYaYFqEIzgEZI7FRqRJzJdM7grhvVnuY+/7VCbR0SK8hr5JoQ6NoHIQunz8
	HFlq62riq+ZQAwswqTPRaGj4cFjvqXlIZZNw/3kfYpqVmaRW4/8XIrdN+py8vbS7k2dzg1aijRU
	GVH1eMMjM720mUZK9UYfbs8mRNK2c6EuqiSBCRrGrpsAcLk1xdQNdaPjT0DEIvPHE2guyNx96Ub
	z//xFXlt0HKqmfP4OM0qrD2B7SOYRakPNPKnqXTSUrBWJqU/1bFBkM+LEovAbQY8S1FsX3P91RZ
	wT3WVI4=
X-Google-Smtp-Source: AGHT+IHDUXmWYVlYvXYhHIsD36N49JfOorXAToNFZUciCwG5nEYfG9fZ9g2sYrKUGUIeEzsd5pUGJQ==
X-Received: by 2002:a17:902:f689:b0:215:2d2c:dd0c with SMTP id d9443c01a7336-219da5e3b97mr23433885ad.14.1734575706180;
        Wed, 18 Dec 2024 18:35:06 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.35.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:05 -0800 (PST)
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
	Serge Hallyn <serge@hallyn.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v2 1/5] kernel: Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:48 +0800
Message-Id: <20241219023452.69907-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241219023452.69907-1-laoar.shao@gmail.com>
References: <20241219023452.69907-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
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
 kernel/capability.c     | 8 ++------
 kernel/futex/waitwake.c | 3 +--
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index dac4df77e376..e089d2628c29 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -38,10 +38,8 @@ __setup("no_file_caps", file_caps_disable);
 
 static void warn_legacy_capability_use(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_info_once("warning: `%s' uses 32-bit capabilities (legacy support in use)\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 
 /*
@@ -62,10 +60,8 @@ static void warn_legacy_capability_use(void)
 
 static void warn_deprecated_v2(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_info_once("warning: `%s' uses deprecated v2 capabilities in a way that may be insecure\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 
 /*
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3a10375d9521..eb86a7ade06a 100644
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
 			pr_info_ratelimited("futex_wake_op: %s tries to shift op by %d; fix this program\n",
-					get_task_comm(comm, current), oparg);
+					    current->comm, oparg);
 			oparg &= 31;
 		}
 		oparg = 1 << oparg;
-- 
2.43.5

