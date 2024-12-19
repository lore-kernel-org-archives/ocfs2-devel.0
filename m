Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A4513B58C
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575703; cv=none; b=rZJF4PVcLimxw6zDhf3asimEL7mhLjLu1eHKiao4NBegyERNIs8lraA1JGy2M+D8wQQbeD9vSINhuBiCL1emHQoBP3mYk4I8SCx9UYA0u5aVpKtpGkdjlIVVCxU7Li7Vh0EK8i/h1WUgWNk9iGt+GGQiRfNNNLD2CUG7dtBs3W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575703; c=relaxed/simple;
	bh=Q/OzGJuA13XAM54QEDmg31aplMOMUc0jAFVuTy4gpzc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=e7YSUmlMhUrWhewMN4mwqWAyRhxJpu1uRPmIgNzgu5yjvvAfkBDCM7c7RdnOvZhOcMJbya1m2NB8E0cyW/Z0gqSrOe7McwJPV9omauyQUVYESs5oOBfEkxC4mm33fLd1lzmoeiCus9x9jIJLIYvu4kKBn6E0YTfcURx4BQEMxCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBi7JDFr; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBi7JDFr"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7242f559a9fso419423b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575701; x=1735180501; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ewYmRGbtjw/u5CZQB/fGCIYq/IkhzVppRPs0v4hq1mw=;
        b=jBi7JDFrEqC/V1PFIT3hFhST+7GRqT16jtCkIEp9mhpX2SBDmJg8f5jbntTmfK5lir
         4CGp6PWAgvVpUGsi+GjaoF83Ma1owC93m9ACm0bX95zqtfbtR+G/zchjvH6slgNFKQ3U
         c7I6+kZZtXocqrpRqgdfVW/FOW4vhmADJ8u8NKEvvqwdCQpQPJhAyqJw/sDX8LIqQu59
         9lNYuOdUgocLuo2r7/wsqG6OR4LkfUyXhYHAGYR9uyXLYNfMU8Ib9TCy/vFuVcmLKFlz
         oIBd1bMgB4GSNdiDZhTOnf9xurm3k7hWSbMU9D53u/girvE9rH4CRY1AZV2EGh6WAHRr
         lt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575701; x=1735180501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewYmRGbtjw/u5CZQB/fGCIYq/IkhzVppRPs0v4hq1mw=;
        b=kLl+R5vz2lAU7MTpWeTdn2mwoATxhlR9UTD+u7pgYE3ct3O8QxVSgoGcxwiz/h5pLJ
         r+drnwNhwrvLTrgIyBH75sJs0EOl8fjMYi/ebXjCyt6WQlmYLgqcTzDFi2AhmWRXjnmq
         kycz7fw8Ie6UB3WDy6W515PoxuaKppqiu04GJ3ufhTL0ZdVbAeD0SxLjYcSp9AOQrHCQ
         Y/Y2/b3OaGHXQg7k6FEl2RL7nsBC18PjcwwD3GQMuAT1AwebB/lN2capte9AFrlQqWch
         7E/qKqLeAXc0Ac6s1zRWJv1LL0AeQ9482Mqk+oh+QvhZDWKnpNmDv8XIcsKjLVqBntKw
         AbYA==
X-Forwarded-Encrypted: i=1; AJvYcCUXGIAikMwxUAEfbVYNjd+tmEVAbtEC1gs9Ei+wyZWlmi48Ll18eLdGpES+AWO7HMku9kr2d0t6HLDYMw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxK2yblaKTyleaSarNU/4NMSQRvaUA0ngYZ3iHfiZF3U0Df9p7Y
	k9npQDs9K5tfSit+9x0R8aJHflZFDE6em6f6C8MdX/fp6wLahfZi
X-Gm-Gg: ASbGncvLf4bRf2RxJ26wKN23JJ9nqQbSSWlhWWqOwkN5sLCopct0P64C2FNa7UvdfvC
	9g3IOEKYxn4+vBQH4MNdnpql5i9oTCMeecZfUfVVHRJ5jFAc9pTn3oKFDHcGjw1ana2cOsnsrfA
	dNPFUZ9RcWAdQYz0vKV+Rbd2wlSRAS6r0rXY8xNuhZgqcd24BKE+93iU7arHH2r07NakUw7mYyG
	TdR9JuFFhDZUDfIdqxujiq73K5xRgEnG4GqSyX7kGKvt/dbi8wLjlzGjS5L7vwTmw3PmzHjZARH
	Mi7h92s=
X-Google-Smtp-Source: AGHT+IGkt8eWE3wh1dURnDDolV6IzXf9MexDfJ0kaeAEgc6DDmy7cFDTyCLLAMMKibF6E7v5iDX6cg==
X-Received: by 2002:aa7:9316:0:b0:724:ed8f:4d35 with SMTP id d2e1a72fcca58-72a8d2e0557mr8641134b3a.26.1734575700792;
        Wed, 18 Dec 2024 18:35:00 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.34.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:00 -0800 (PST)
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
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 0/5] Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:47 +0800
Message-Id: <20241219023452.69907-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

v1->v2:
- Don't add "%pTN" (Petr, Kalle, Borislav, Andy, Linus)

v1: https://lore.kernel.org/all/20241213054610.55843-1-laoar.shao@gmail.com/

Yafang Shao (5):
  kernel: Remove get_task_comm() and print task comm directly
  arch: Remove get_task_comm() and print task comm directly
  net: Remove get_task_comm() and print task comm directly
  security: Remove get_task_comm() and print task comm directly
  drivers: Remove get_task_comm() and print task comm directly

 arch/arc/kernel/unaligned.c                         |  5 ++---
 arch/x86/kernel/vm86_32.c                           |  5 ++---
 drivers/accel/habanalabs/common/context.c           |  3 +--
 drivers/accel/habanalabs/common/habanalabs_ioctl.c  | 11 +++--------
 drivers/gpu/drm/i915/display/intel_display_driver.c |  6 ++----
 drivers/gpu/drm/nouveau/nouveau_chan.c              |  4 +---
 drivers/gpu/drm/nouveau/nouveau_drm.c               |  5 ++---
 drivers/tty/tty_io.c                                |  3 +--
 kernel/capability.c                                 |  8 ++------
 kernel/futex/waitwake.c                             |  3 +--
 net/wireless/wext-core.c                            |  4 +---
 security/yama/yama_lsm.c                            |  4 +---
 12 files changed, 19 insertions(+), 42 deletions(-)

-- 
2.43.5

