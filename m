Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB04373BEA
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378790; cv=none; b=fTLCQEVTiABMG5JPKXN0c9wctXtJFuZwcMqW3shWh91J3fVjwhjgCdoSZ9GxtvvojaOvjJ4A0i66QcoTNHQRm2iLm6COJJBi/0hitZ5rgSGqwm9jrjbGXFTqV03GXHz6n7SC/xVSg10FOs0i1b58CcNfeEFJFhWtQEUEjyasrTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378790; c=relaxed/simple;
	bh=3WFM/kKj3LaZeo7qhEG0pERMzASbVvFqQD5UJLpCojk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lFYm9THWgI0IElM+AXZP8t6R7+TE/BMAWowUZaG8X92uv9q4HKZqZxlrIIalE6hfYR2cl1NRdY92EwepQ1wh4i9SneszL/tVEI25o4xoQHzflkQ7h59Vlqz9gP7amo9mX5RjXR8Ow6Pl2s2E4KBIJLog08wQZXQogiwk7DySP/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCoxVbOp; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCoxVbOp"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c6b67d5fa1so11293305ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378789; x=1782983589; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qj3QzKZVkngDMaCQUoVrAi0ewBE7Z8Oz1g0lcs23BCM=;
        b=LCoxVbOpShtPw5kvA8i2Ol1j/OMBKmBzLokC2obkEP7y5RlgKCDUQKr2MHR0raNanL
         +1xzAgo0/dUuPaTWdM1xGh1lwqaXV4ENPopQNwkL3JJwoigvj16FAW60XTFGq6xll1UB
         43GN1Fm/jWO5I7ROv3xJcj3YpyKlsgjXqKcuxcznBVPNU6S8D9QeDWk8ueHORBNZB0JZ
         uHng3o6C2IRb2+FNlkfPBBbQsmSJdRpQx3g49xlPQ5AzuGaTmA5zDzk/QHx8w0qch4Wc
         T/ybhbOkSDwu3pITM3zZk5LYPMWm6T0LlaRib2may3OiDLt1OCWN4CHo1s2bBNPo73GT
         7Qwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378789; x=1782983589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qj3QzKZVkngDMaCQUoVrAi0ewBE7Z8Oz1g0lcs23BCM=;
        b=XHDu5wWsbdPNpK3e7VlRCWRtr3dzbQj4d5S0T9+XwMeQ8zd+1kEM9gzdw6X8aa0TPw
         6Jso/0qeagkIWyR+aHadB0+TTycVdZYL8nOoVtc1m1on4rslPY3KjbZtjdFp22yf/TkM
         jm9VI+At11q75+D82YGS0Dkl1i1gFoIFU7UTG9KY0cPHXTm2sNXjq65LYCsZZaz22Rz3
         YrPtGyDxbf370AG/o/350pw/xONUpkTLBE/qFNdo0Dqg+hK0A63uTTzPw6KrOViMVLg6
         9T1Vhg3u9LnON6CsYtqc5MNw2GMvHhYZZPVWAmTvqGL0SvtFt7RxQkaba8gS8wtpvPtO
         lkLw==
X-Gm-Message-State: AOJu0YxRSobs0r5GPOSgtuH59LlDlQC1RVIhizn0PRGkgsF5EjUXdxiy
	labc7At0O9VIH5OVvUFmzvSnmbN1MH/YsarkXze9Y6KRw528cbnRI9/J
X-Gm-Gg: AfdE7cnXfDjErkLt2WqJjp7MJeY7smndfR2ZkUg5WWlVT1xcBqtdxWMJUNTTQlHNF92
	FwL9RU7FzFVbdSgAUz5zwhxHNTt3MVjN2RLwoH3kLdxqvSo/i7cAd6vvzDH+M501q9wwugrMQ0U
	h1Wk3szRqSAy8zHVXwxcyRuW9cBqtJTFyvumcoryX7M/88NXH6aGR6H7KnlP0g5E5iB5R7ZP6+G
	mNfCJjnqKGntHRZ7NwbCZVzAoQTuOBoakymYFSLcs4Bact5KbsLiuwOkg9o7jMN9V2SkYfQsmfD
	2dUfMeGWxhERoFgIRkJdBql2oehKdNayQeACdKx09DfVWAAGMBz1hXNyA9Nkh5edOP+sRSLQQYf
	MOq9h97rKYdpTc9xtsn/IBDxzWqoqK6OZcexN5hok3qlGNZJY1VV+e5yqJdecIg1HDRb8dHlhfz
	mywMJ8QVs=
X-Received: by 2002:a17:903:160c:b0:2c0:ca99:3d73 with SMTP id d9443c01a7336-2c7fc665c91mr19968135ad.8.1782378788539;
        Thu, 25 Jun 2026 02:13:08 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5ac899esm16205485ad.7.2026.06.25.02.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:13:08 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v6 0/2] ocfs2: validate xattr entry bounds
Date: Thu, 25 Jun 2026 17:13:01 +0800
Message-Id: <20260625091303.234624-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series validates OCFS2 xattr entry name/value bounds when xattr
metadata is read and validated, before getxattr() or listxattr() can
walk out-of-range entry arrays or offsets from corrupted metadata.

Patch 1 validates inline xattrs from ocfs2_validate_inode_block().
Patch 2 reuses the same entry validator for non-indexed xattr blocks
and indexed xattr buckets.

Changes since v5:
  - Resend as a standalone thread.
  - No code changes.

Changes since v4:
  - Replace the descriptive string argument with enum
    ocfs2_xattr_entry_type.
  - Drop the new per-operation full inline-xattr re-check; operation
    paths keep their existing ibody header/count lookup, and full
    entry bounds validation now runs at inode block read time.
  - Simplify corruption messages to rely on the corrupt block number
    instead of also naming the xattr storage kind.

Cen Zhang (2):
  ocfs2: validate inline xattrs during inode block validation
  ocfs2: validate external xattr entries when reading metadata

 fs/ocfs2/inode.c |   4 +
 fs/ocfs2/xattr.c | 194 +++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 187 insertions(+), 13 deletions(-)

-- 
2.43.0

