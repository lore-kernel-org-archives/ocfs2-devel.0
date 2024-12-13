Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B615183CC2
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068806; cv=none; b=H9ANCds4iqenBdQDnPTFXSILFnSniKVT/gDeMvoS7Ioj3bu1n8rXDLAa6DFN8tlynX3K5sFJizp9cOy19NuHV4C87zt9NL2sDSgnDhruUdkShO6Da/9zWO0SSS5X0gdKecdzezSWYNNlbKyjoOoIsMSE9SRffc5ThB2IYu7syuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068806; c=relaxed/simple;
	bh=OVgnmW0ca8umO0SwlloJBit9jW9fr1tJz+XCXh2DFpE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hXqWAcNABztAicFdVGnxFeqkUkKHBEy6UjOLKoKbj+YPiWQ/vwSc/ptgKLb+rjpsSaP+UJ+O/oN5Q5JgHzm/mwW8YOI9HT/SyKx4yI2JHbJxOdwi0WusjKamPaOUJ890lOTRD156IVqghlPScPAPwCVceCGzD/Xu9Se5+cnCivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rt/MiH0g; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rt/MiH0g"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2156e078563so10800185ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068804; x=1734673604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9nDBDHl8OkOEbonP7/O/xeWGAuqOftf+4IMvf+gS1cw=;
        b=Rt/MiH0gIQWa6T2wB3CGGuMi4+R8EEyEtosD0/dai6qJWaCz/yc8F/tNqBTOQAlNns
         chE3MqCtUQEry7z8khwIysciIg/eD9k0oNh9HRnU2k6sOr+Q54MJb+mDO8TcbLtBhNIQ
         1hTxxLG5vHjzjhVa2I2RwOFIORTbBSoJaDR69yW+e70AngBJ7YzMfQmWAl9TYjox+d1h
         ABoTK3iw2v/5Q+SFGQblXQBF430FxzQDlbYoE5TbgVKkzzLZS1Ku/3St2wm1+8khpEX5
         XDDX+cAoErV3JYD9ZpO/7+GJIH/bWEd92QGEluvf2YicyO+eK1ttwsRB02zdowULC9VL
         mgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068804; x=1734673604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9nDBDHl8OkOEbonP7/O/xeWGAuqOftf+4IMvf+gS1cw=;
        b=GDxTWJgkVRQxLw+Bz00Daptn036TEKh5M0iHg123VF+gvNc2MZYpSAAoybqbnq0FlO
         6smE55KvOOYJxMRRdjiPln5L5VO1QJW6ef2fnSECTJ1O48hMyR7z7CnYVIcNFkaLI/zm
         njxxhSe0d/g7ppRRDhha/zo8DbM5G70zXszpFSh36LlB71+SOorRkzTUaZiTux5ohI6A
         xrreqXuGa+JEAj3xNDoWbu3WL0XQH3axBzNz4RejSL87bUY8obmz80axHQGCvUJdbfar
         oj2MlWZCUZfJfdAY9tVR2FULl/ktm4zoH5mfveHovEl+uep/u7Mabg7YBMpoIAfIk2vV
         1xJw==
X-Forwarded-Encrypted: i=1; AJvYcCXlx+PN+ysmUrmNeSOSkbBI9+KAJRIpdEDWdxCWlVOKyQ0Os1XvronHoVHiG1gxrHF74gp2QAtlPejgXw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3JiFPbvi7FLhnODlSTZb9FubE1cnzLc1NGwwN96ia51kShn97
	wQkauXBcc3TPk12ScN6v//Zj4CVwVUVMe44MnWkJtczwrkNYVKqv
X-Gm-Gg: ASbGncs0NCV+GnyT9hJnw50tSaO4upJf8Hl58+xfv9wJLAasbCXN3ZCJUgj1FpuezV9
	uQpwdUTRyYKvKMFx/xfM06LmxEqLVQxsPCZ5BiBk4bQVWK12oqmjSgJhgv4Afv7b13pdd2Pynr2
	FKc+wYzlj4klvCg46c+J2qJjeF6+x8zCA78OAg35Gme07GW26oYMLMb1usxAi2eW3uu1xXoqg/a
	DFzAgk2jAAwTZdWyphZli6wTaOytVsOwYMcJ0KQHvj8biPk/jEni8ekuxxVZ4nAAK+cMsUdI3mP
	hN2l5Ik=
X-Google-Smtp-Source: AGHT+IHVKByQs8aQw9nFW65MyCdke95tovLrIe/teYLFc9u83Eik6guIs9oKZyvf6Ts5Rmy4R5h3SA==
X-Received: by 2002:a17:902:ccd2:b0:216:26f1:530b with SMTP id d9443c01a7336-21892a70579mr20915305ad.51.1734068803702;
        Thu, 12 Dec 2024 21:46:43 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.46.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:46:43 -0800 (PST)
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
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 0/7] vsprintf: Add %pTN to print Task Name 
Date: Fri, 13 Dec 2024 13:46:03 +0800
Message-Id: <20241213054610.55843-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, it can be printed
directly. This patch introduces a new vsnprintf format specifier, %pTN, to
print a task's name. In this specifier, p represents the task pointer, T
stands for "Task," and N denotes "Name." With this abstraction, users no
longer need to manually retrieve the task name for printing purposes.

In this patchset, all instances of get_task_comm() used for printing the
task name have been replaced with the new %pTN specifier. The raw uses of
'xyz->comm' for printouts will be addressed in a subsequent patch.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/bpf/CAHk-=wgqrwFXK-CO8-V4fwUh5ymnUZ=wJnFyufV1dM9rC1t3Lg@mail.gmail.com 

Yafang Shao (7):
  vsprintf: Add %pTN to print task name
  kernel: Replace get_task_comm() with %pTN
  arch: Replace get_task_comm() with %pTN
  net: Replace get_task_comm() with %pTN
  security: Replace get_task_comm() with %pTN
  drivers: Repace get_task_comm() with %pTN
  fs: Use %pTN to print task name

 arch/arc/kernel/unaligned.c                    |  9 ++++-----
 arch/x86/kernel/vm86_32.c                      |  5 ++---
 drivers/accel/habanalabs/common/context.c      |  5 ++---
 .../accel/habanalabs/common/habanalabs_ioctl.c | 15 +++++----------
 .../drm/i915/display/intel_display_driver.c    | 10 ++++------
 drivers/gpu/drm/nouveau/nouveau_chan.c         |  4 +---
 drivers/gpu/drm/nouveau/nouveau_drm.c          |  7 +++----
 drivers/tty/tty_io.c                           |  5 ++---
 fs/ocfs2/cluster/netdebug.c                    |  5 ++---
 kernel/capability.c                            | 12 ++++--------
 kernel/futex/waitwake.c                        |  5 ++---
 lib/vsprintf.c                                 | 18 ++++++++++++++++++
 net/wireless/wext-core.c                       |  6 ++----
 scripts/checkpatch.pl                          |  6 ++++--
 security/yama/yama_lsm.c                       |  6 ++----
 15 files changed, 57 insertions(+), 61 deletions(-)

-- 
2.43.5

