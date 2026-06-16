Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A439DBF2
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 09:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601101; cv=none; b=V+0hLZY2M/72fdEPE3ZyVjZ7Izu5TlCPnNhbhctWXCGuu2ZgGmLJ8i8ByYbK+40ZarUr88B7jqWYSrY2mHKKvnVcyJ/Fc7/g48vxc1cUO46iiBLZvnIy+91f0alU7sEL+qjVEiA8GPT/ne/G8Ikp26kjgbybZSFDGL8Bwy0oZ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601101; c=relaxed/simple;
	bh=wQVEXSot4/PwyZHLxagmzgxyLF/JDKOxL2FeqRI3Mvk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EeDk+q2H6b6tk+CTtQ5oaOaF2ZvijOz1r0S8XEmsftMzS/paZSS13KIR4SMT1PYcQcxbtm+88n1NC459mCquQI9hbwDrlxJBYgfkP2b1ur3tP/tGDgSXnzr1jVz82S1hjcwbH1zD9YiqWpyZs+H9OFpAtSzwU8YwTdRnipFSybY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fr0TBnfc; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fr0TBnfc"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2c0c2c7e0c5so27238265ad.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781601100; x=1782205900; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LBP/qpCWxoWZRyIju3fS/1yAO6QsimeM2pzNhUbDHN0=;
        b=fr0TBnfcxojkrb/5TLQjbTN8vX/FsCKBJ+YfC7GGnH49d2eGkPWiW8+y1X9iqzugf7
         PkHED930negkDn3eKbIyFhtufsXGuGdzcIrhE8l57UvAYTyvF3xID2yhKb49OOOWQa4K
         mtHXEklyHChLE6KqKHuBHzKk+mARU/NRD62yq8hygy4CBmyK6t8CjIGg/kcrIUE104nH
         wi5mOgJYkOLWK9pDqCnY8gD09IKWmPJ4tD6x03p5DG50FcS3s5QQKDLLRuVRUWolC05G
         mLCcl8l2bRj9QVJmNEnofc3lLVIYYApDNxkeyA8cj5xiqyuoOG2TTwok1+ZT3ex61tcc
         NU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781601100; x=1782205900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBP/qpCWxoWZRyIju3fS/1yAO6QsimeM2pzNhUbDHN0=;
        b=BC7C5tXdA2J5+On7gt5xS1GWmf2xkQdedflv7ptHcOmuSNRNlAPpqDqFe64622sRsV
         ov90pxmqBqqpLLrZFNG9kaC4jJ26gGdexh733Ruik9Wn5nYHDuGJX1ttLyiSKJrqoDqg
         GXAvedwPovlJq8GYiTMlinq2ONdE2B3laQpp0+oqQLnSEbXQLrg/6BgEgZWS+Mr3pb1T
         mcWSsAku9zhnVLR31laDhfAP34PmwAxN2MMt3KXrwPvIOd0/UIzwWjcOcXkHH22fq5gv
         fuI39QoUlWftUQdEsvaZXZjvqrmD7qVZDcs0AHlRTBQeFwrHb51E/8YHI0GM+5biSwLt
         V+aA==
X-Gm-Message-State: AOJu0Ywfw/wuUGiqGeYyPC/bqd13HjP2ochazxkrJhEzBGCGq9mb8EJU
	GbJ+Fc2+A1d76N6HZtxLicfTKtsXHcdcp1mS+WOezc0YIQuj3J1bq+IV
X-Gm-Gg: Acq92OFwghNYOgu+F4yGiliXi0vt33LWMAmYbkd9Cu4FCiFPRB/fdyqHCVieD7cXJJx
	DOP3dHZYwv/rTehuuiTZv9tpBx5WOusm6FF96brFX33uj555jH0FZTBdT36WKyNAfeTtoRKORvp
	U2p2SlaMiej4owXwlLO4wnNcmJU7KCA2NKECboAcb/i4HkoRtq9qQUtsho4d1LtE+hiuGeIk81D
	XZm6oITnRZdN71dQJJLeywA2pkgIyCLRY6TA/YB6059GnwMqtBKW7cb2jOdjYNfeBV9+lsbN6Ci
	pgLzvLvY/9vO2AymjgN4VIyMPRGmQnieIYCpsraGLzzWQQoJVQ7X+xX3oXKygEsRiav5CbYC352
	+g37DxYT4p/9/tG/ylBwGLOnyzutOyccKpWSfWY3gZ0hK4dpGyv35AKaD9WdjLnYsQL6MBDQdm9
	C9lzx5XXp0q1INvHSqmbkEDbEEwWCRFHbBbOG9x/e7y9a/5TCh3ql0u4TgRmDuoP8ods88IDIOo
	CeUqw==
X-Received: by 2002:a17:903:249:b0:2c6:9358:3ad5 with SMTP id d9443c01a7336-2c69a1d7b0fmr28721435ad.17.1781601100038;
        Tue, 16 Jun 2026 02:11:40 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a43c9sm127502645ad.41.2026.06.16.02.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:11:39 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	rollkingzzc@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH v3 0/2] ocfs2: validate xattr metadata bounds
Date: Tue, 16 Jun 2026 17:11:30 +0800
Message-Id: <20260616091132.3990054-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Cen Zhang <zzzccc427@gmail.com>

Hi,

This v3 moves the corrupted xattr metadata checks into the metadata
validation paths Joseph pointed at.

Patch 1 validates inline xattr metadata from
ocfs2_validate_inode_block() and keeps the get/list consumers using the
same helper before they derive pointers from i_xattr_inline_size.

Patch 2 validates non-indexed external xattr blocks from
ocfs2_validate_xattr_block(). Indexed xattr buckets do not pass through
that validator, so their header and per-entry bounds are checked after
bucket ECC verification in ocfs2_read_xattr_bucket().

Both issues were reproduced with crafted OCFS2 images under KASAN.

Changes since v2:
- Move inline xattr validation into ocfs2_validate_inode_block().
- Move non-indexed external xattr validation into
  ocfs2_validate_xattr_block().
- Validate indexed xattr bucket entries at bucket read time, after ECC
  verification.
- Keep get/list path checks as helper reuse instead of a separate
  consumer-only policy.

Cen Zhang (2):
  ocfs2: validate inline xattrs during inode block validation
  ocfs2: validate external xattr entries when reading metadata

 fs/ocfs2/inode.c |   4 ++
 fs/ocfs2/xattr.c | 211 +++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 183 insertions(+), 34 deletions(-)

-- 
2.43.0

