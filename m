Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2C213AA2B
	for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 08:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722240305; cv=none; b=tN1UjJG12NKdROFwXqeuDp3eGY25CRV3omHT0BPrkCEzWy1m3iZLQe4Q328oruhVLyx27bjU2/EoInkUsnvSTyLNQ0c1l9iYuWrhHi7qhzIGuumcvMcPWqJYFBzY2KbeQRrUcB4u+/4O3DUHAxz5spEHGpbqOke2kVkLK9SatkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722240305; c=relaxed/simple;
	bh=xQZWZZw3ptMPb/m9dZbnhnbN76NYOZDrgzjxvV6IV3I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bfvTSY5cNHVemq7ghOk8CcHjbOBdmodmlMBcmnEPyqaqtTolCtJyEvFxzW/Fu3wcfX2/KdeELKRdKSxYHJn4QzsB3nL98Sw9Z/pEahkBJCZj+bHGb43TPiPGFvEtlt0F0PfG+v1YZ+OXXwdOnGqoSPW+Z4PSJlV2qX/xMGxY5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ApsvOT/f; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ApsvOT/f"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2eeb1ba0481so50341511fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 01:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722240301; x=1722845101; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B1OsmVfBy0oBGN9JkLK+zqObi3Kuvhtosx8jYsAAvMM=;
        b=ApsvOT/fOikiPhOaH/DxVPVYniakxaIXWIAJBwsTuszztUpdvMfLuhQMNPQawNwoJ8
         sOVeSLs5QU5FO/PGVfsGdOxm6Hyn3GFf1z1D1ALx+V2l7GAyXCd7Z/12CpoOqErhTwb0
         xbiiLSAA9B4EPnOq2D6kMF1nimorzUhuwv9vO4ULFLc9WHmETX32t63ShIYG4o09YfDL
         Vm4PZ0Z74VfoaWyO/L4uUXzBxt1P02Kzwlsx+XMkUYGzZjNj8SMttXIAESxJMlHZ5vAT
         Rt3FfzfKbT7bPcI5KTvMGgY3MV5AsouIGIOYnQ/+gJ2nfTUEKV6f+wUo0Ib1fOZkOazg
         FS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722240301; x=1722845101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1OsmVfBy0oBGN9JkLK+zqObi3Kuvhtosx8jYsAAvMM=;
        b=HEsZ/qHAwYC2oGhAn2WtBHFG3YNii2f/mzYOjBBAce9ySdIAw/txFA5mIohAukLRTQ
         qDnvPqh0Fs+yI40RWn2aWUxbiW9o20UHOC+1JAsdn3BsafzRe2h35pO2xebjmhxHxPmc
         m89s4uNfvrvixDJeZcPCch2k0O5QpXMZOnDcKSBwHKUhojHJvod72Kyu2kodQD/K4aQz
         GGgA26eeO5pTKtzod/tZ3fm65j0KBMBTGtlJipD2WYeooreZPQMwsCXAy4aXK/6utoFY
         OUi33CjxhlgIhmY6X/z3G7EAX6lSh7994kyKxXeGR3MtcwToRRpVOYu6DdflpxSsz8k2
         bZwg==
X-Forwarded-Encrypted: i=1; AJvYcCVdL+KJ+PBwXjH7hDiTukjLKg+ApfyxCVePSe1VlgbBFtnKO0jNORJ4Kkt0sSWBkqtgDxN+8/aqi7htsA==@lists.linux.dev
X-Gm-Message-State: AOJu0YySYxQXIMZq7nwo21NwgznmYTZ3sRG+yLRVvBb71+4wefK3RaKD
	tDjb1Ngtx6/kD/uGomFg2O+Q6TqIgt9VWpE1DXiDckV+g0R7ux+34oKCHWi+cwo=
X-Google-Smtp-Source: AGHT+IGKVQC8jNjMphOsd3qzDGrxaA/7WLK2yrSnLVznQ7/3o+hYE5pbTTgzeIAebKisPtvG/eMp8w==
X-Received: by 2002:a2e:81c8:0:b0:2ef:2e6b:410e with SMTP id 38308e7fff4ca-2f12ebcaf17mr43509371fa.4.1722240300684;
        Mon, 29 Jul 2024 01:05:00 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7edd813sm76560305ad.170.2024.07.29.01.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 01:05:00 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	glass.su@suse.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 0/3] give ocfs2 the ability to reclaim suballocator free bg
Date: Mon, 29 Jul 2024 16:04:51 +0800
Message-Id: <20240729080454.12771-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The v2 3 patch files had been tested by ocfs2-test and xfstest generic test.

v2:

Create 2 new patches:
- ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
- ocfs2: adjust spinlock_t ip_lock protection scope

In ocfs2_read_hint_group_descriptor()
- bypass the validation of GD when the BH is already managed by jbd2.

In _ocfs2_free_suballoc_bits()
- Move up the position of the vars 'idx' & 'rec'.
- Move up the position of the ocfs2_journal_dirty.
- Use le[16|32]_to_cpu() to access cl/fe/rec vars.
- Add error handling for calling ocfs2_extend_trans().
- adjust spin_lock ->ip_lock protection scope.
- Follow Glass's review comments, add 'comment' & 'else-break' for the
  'for-loop'.

v1:

Only create patch:
- ocfs2: give ocfs2 the ability to reclaim suballoc free bg

------------------------

Heming Zhao (3):
  ocfs2: give ocfs2 the ability to reclaim suballoc free bg
  ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
  ocfs2: adjust spinlock_t ip_lock protection scope

 fs/ocfs2/dlmglue.c  |   3 +-
 fs/ocfs2/inode.c    |   5 +-
 fs/ocfs2/resize.c   |   4 +-
 fs/ocfs2/suballoc.c | 240 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 232 insertions(+), 20 deletions(-)

-- 
2.35.3

