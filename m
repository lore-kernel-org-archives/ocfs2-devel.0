Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC73118A6DB
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644108; cv=none; b=EREvOtmla85bAdK1YHwO1vLq7JUOz9WX2AT6bl3VgC4Xsm9qLeX2weNeD1GzuHKRxYCYoRqxcu8PJgeeY4EiEbiMAHf3VHNus66v6WTH23CS9c1pjuRceizhJa/NR/ffZxUXUrWB77gzGYegPQpbILQPlYJXzO2bL3TRgQmqUnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644108; c=relaxed/simple;
	bh=k6DLSLxt2mS92AW9THnTfyPCYL+zu3tAMKUQnsjBdO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CrUJdYQkcLoRUPEjeTN/UeLpEWG1XlxsRjtcTTp1aKTS3By8YqL9j3/RVioxhmfDqdzwShuxY8BnaMqgdbH76cgLYqg3YE8M61UHYXG8oVYddaADfgE+pLlJd5V1R12NH1+sqGKz4CBvYjvvEyKY1mlEkYpSh5VfdieKaPoZc/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShSc8v43; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShSc8v43"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so8534849a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764644105; x=1765248905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihzWcZQrPg9oGqI6ksnq5pPm895AlT5PWrtOUGngFrA=;
        b=ShSc8v43MUOb85O2GOPhwFGVi1W1BskbUMVH3MDKT6MLytreBWVDGOU+Frg4RtQqZ7
         /i+Nf5yg8IT2vKQFNEvYY7aKN4cluQR55yE1JpuTO+/4OQzXuklEJZVJjLCDXGN4Bnvy
         MCSM6/bOoAw/wJTuPVFKXOYc4tUz0enuHX8RmYj3NXgHkZscGAMoaYjzHlDx9FtDYwZw
         wtVt4F/NtWKn2xt2HJa/JlDuorZdf1HEZDRaOdjTvWBdq0VVRg3i30yCUX3YyyhPDzN8
         9UfafzjAfkXvjdE5+YUmNq41p4jueU1I7Dd2M65XoGqc7PRA1de++uS+NK85zlXMrgzK
         SHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764644105; x=1765248905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihzWcZQrPg9oGqI6ksnq5pPm895AlT5PWrtOUGngFrA=;
        b=GhHjTSdBIkaJaHy2reFzYwXw35wQClWZOsn41COIfvgEYIUqWfM8JwX6SDR9PoQat4
         fZDB81B7nCYISJmMTV9KU6IrrWNae9Aoc1gdOyNiklhk8WfWRsMTqE8R1mAI5WdUjCSJ
         wVxdSHG6ALeXzTMhpA4hSrKr6eKudA84cFPVcXK1SpUwuj6vMvd3eyXNdIIq6vNKB8rZ
         Kk6T1LUTt3p6M5BVJR64psmWbPPOnOzzMenS69jezuQs2/C1ee5lq7XCHEHoTNicb1g0
         43Xv6oeKiCn9vXG9Q3FjIcggJSwnEIZ0MqMwKSzj7uJ+1DUJ1ly22AZ0ys28yoi2/axb
         v48Q==
X-Gm-Message-State: AOJu0YwBozxnT8pjYX/xB20a0mogYjkyOzCDQhhSUHalw7Vfdvffd5i+
	W3PuTI6lx0/GK6DjX/dbrnQ4AYu+JLhENoOf9RYWUZTwrfC0yPmG/4Cc
X-Gm-Gg: ASbGncsqoKBjRaB/2FdaAUtwRdA6tEMnIET4N9/LkPU9I/mglDuqN3NU6NRiK8bY/1c
	8JDKL6mO9EfzZ8csaEPhJW8rQKE1e9Y1yWrBn/uVZxx9+JNZSUPkbgC4MtBmltDGL3mmwOAPmN1
	knhZl8l/VUcQtPyIL92MZ4sRrNbjDAcmi6x9MQ4cvU8adUFSk8yZ89mKu442G5ySpyoiSeFHQj7
	JvlYDqlZzkwvvE283cbZY9E2m5NpiIrO8Py3T+KwzhZkwBhzowVVZwKGi6fXYBi/eEDKisnS6Gh
	9hbngSh43CV3SfaAWnKzbA4a3v3R1zy7zohutwzX62hP20hlhVjTGbioyr1nIbvTtEgINoXa1Nv
	M3tB3l2aalTJSIr6aowWo0xf3u4yrKLzSmXfZA6o08evAzrho7yK7qIFNQKreC5Foa5JJac/otR
	JHAqceZh3noaE=
X-Google-Smtp-Source: AGHT+IHACKfZCb2Ae70WzhfT7RSHRzi/eUS7PAx9okIuPRvvx7+2XuYOSdwDoPe4xb+V0Jsucrla/A==
X-Received: by 2002:a05:6402:518a:b0:641:8d6b:88cb with SMTP id 4fb4d7f45d1cf-64555cf06b5mr39537888a12.28.1764644104956;
        Mon, 01 Dec 2025 18:55:04 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062261sm15753978a12.33.2025.12.01.18.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:55:03 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: [PATCH v3 0/2] ocfs2: Refactor read-only checks to use ocfs2_emergency_state
Date: Tue,  2 Dec 2025 05:54:56 +0300
Message-ID: <cover.1764643790.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Following the fix for the `make_bad_inode` validation failure (syzbot ID:
b93b65ee321c97861072), this separate series introduces a new helper
function, `ocfs2_emergency_state()`, to improve and centralize
read-only and error state checking.

This is modeled after the `ext4_emergency_state()` pattern, providing
a single, unified location for checking all filesystem-level emergency
conditions. This makes the code cleaner and ensures that any future
checks (e.g., for fatal error states) can be added in one place.

This series is structured as follows:

1.  The first patch introduces the `ocfs2_emergency_state()` helper
    (currently checking for -EROFS) and applies it to `ocfs2_setattr`
    to provide a "fail-fast" mechanism, as suggested by Albin
    Babu Varghese.
2.  The second patch completes the refactoring by converting all
    remaining read-only checks throughout OCFS2 to use this new helper.

Previous-link: https://lore.kernel.org/all/cover.1763337347.git.eraykrdg1@gmail.com/

Ahmet Eray Karadag (2):
  ocfs2: Add ocfs2_emergency_state helper and apply to setattr
  ocfs2: Convert remaining read-only checks to ocfs2_emergency_state

 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/file.c           | 23 ++++++++++++++++-------
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  5 +++--
 fs/ocfs2/ocfs2.h          | 18 ++++++++++++++++++
 fs/ocfs2/resize.c         |  8 +++++---
 fs/ocfs2/super.c          |  2 +-
 7 files changed, 46 insertions(+), 17 deletions(-)

-- 
2.43.0

