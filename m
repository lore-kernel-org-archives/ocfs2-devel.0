Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2AC3AFD05
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782133421; cv=none; b=LXD8dPI7xxcGDHklbrNj/Z1OvpWfu2HQNRWraE3JQnHIoX7yNf3zSSyYIlpzwtE+8jUzzIR2HVwy+tRkLYw/QLEXw7KbdMHgeO+c7vDW+VOjh3BmWaQMK4yKCCBgIU9Pqjl0Wx+tAbjpz/RNOw9z6oK3+k/08cO4UYtC0DyAZzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782133421; c=relaxed/simple;
	bh=RfznLkS+ZpsSvId4xOD4/cnLi/Phx3olePuZ7XR8qCk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lqfBGJY1W3YGZ8Hyr/Ru05J874UaJ8JaqHZsNRKrW56nMHeXc3eb7GooFtAXIqzQmEg3sN+kGKzgw9DxCdIu7+N0iDKLAlR7oxNNNUJN11Y8SEonb/manIyqFdp5f2p+4b7YFBzl7rwBCaFDJGzyEbRGzUdX6rJ7w0pl8Duu8bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZidEdyB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZidEdyB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso27204715ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 06:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133418; x=1782738218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XbKFFG1L00z5MlRiOkKCPtXY87GUTjiQbqND4Ea6D2k=;
        b=DZidEdyB71jN8Cmz281gZc5wDzwDMnh0r4HOr/kKmVqMjBBCowTRDyvbnjo6xu9i6v
         b8bWLFgxoIvGiGo7IeUBtM7p9/ax658Ndcyl2iVhePwlSXqdZkbmnVh4ggxJUF1FxCms
         svj0UuYqAS0NokYDtJde8IaF5hscoqVwZIi6z1MV1zNror+k1SsATe9NdVbqu1es83Jm
         I84+Tnyk6ZH+ThiPrPO+KoLsVljH1Yv8Jd60GeN9WUDFJ3C3kSOGt23Sq4mIJTSIc1Fh
         YUh6yJ5d9MeOC2l3ElduUqRIWnmAH0pC+wbdyMqC+rHdYUtSfRMdkAZqubpVZoNTgA6x
         dg4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133418; x=1782738218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbKFFG1L00z5MlRiOkKCPtXY87GUTjiQbqND4Ea6D2k=;
        b=II+gF6/ZEkD21j5MGvU+AzCCNNyAkI4uMf9u6zvB67RucBB2z+hqPtXahsIdEudu5N
         ecKKEgTMRfl67BwBsENUpFUAEJJHBh5JBdEUwODlN3dbL6DjuW3u2JFTRj7fN2gk/1OJ
         SjqhZNHbCM9vi5aHi5nJ/K6x+hvRkjozttYJUnzqwunRYIy3bkPAl+H+82lUYIb7ocRq
         MMzsAUmUEmbynYcr1+UPBsRsssEvGMhF/lo9BKUdhOvJD5uG+Zo1aSdJTdYIlKY1YQCu
         gDOWUAjo56QzbrHaX1/O51vU7RQArGJEAozQ9/ZQsovbBpn+05tf/o3vyPXBmx8AHPr8
         OHbA==
X-Gm-Message-State: AOJu0Yw6Jx5mGHDf0S9XdapqYnHQC+Da0qZyj79ZZ3c1nutXtdgBnHqo
	Tmqtvmhzha0Ch0bPMdVwKpNGy2Qg+K9XMrKgBEDmPPdh9FTMbISdbTLG
X-Gm-Gg: AfdE7cmZQu+RGVlFwxKVCx1qgdkPB86Z+mLMDOcBF/VEfmvD9aY3JLG31M81ZhzFUKR
	DZatkT6Zs0mThNGks22qaYGStsz3mt4St8FVEieSkQ6E2p1W+EXNIwo+LQD0i/Z8gUzTl+gixbb
	WYTlfS2uXEm3Pks1fydtuKc3mbV4WSm/oJPYs0887vxeVGnSPYd+ICXswVKlI237GjbNglnhOdR
	j60lXLHPGlZNk0Wdv5pq7xyHiKca4TI17K+jfaSWqlM5EJX5JXJKBEHWJvQx8b1t0fZpa+x6O1K
	AFf/1U5o3Vl+sIUtsW4/SaPMH1D8JG57A3tjxdYjC9w3Sv8VONf/jBM1Vw9H0Gv2r87zcc5Xu6a
	yfDaT4eLc482G/b4syxRzO9CTbhrCMLi+czZwyN4r06mbIxrcqc9JB/87lxRv44RhUO/jyS+42s
	JvUh835I5zU0DKCUfDSA==
X-Received: by 2002:a17:903:390d:b0:2c6:b38b:e75d with SMTP id d9443c01a7336-2c725d38359mr158556635ad.20.1782133418077;
        Mon, 22 Jun 2026 06:03:38 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743fd6420sm78895885ad.70.2026.06.22.06.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:03:37 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] ocfs2: validate xattr metadata bounds
Date: Mon, 22 Jun 2026 21:03:30 +0800
Message-Id: <20260622130332.2094018-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This v4 rebases the series on current torvalds/master and reworks the
inline xattr part on top of the newly merged
ocfs2_xattr_ibody_lookup_header() helper.

Patch 1 extends the shared ibody helper with xattr entry name/value
bounds checks and calls it from ocfs2_validate_inode_block().

Patch 2 validates non-indexed external xattr blocks from
ocfs2_validate_xattr_block(). Indexed xattr buckets do not pass through
that validator, so their header and per-entry bounds are checked after
bucket ECC verification in ocfs2_read_xattr_bucket().

Both issues were reproduced with crafted OCFS2 images under KASAN.

Changes since v3:
- Rebase on current torvalds/master.
- Build on the newly merged ocfs2_xattr_ibody_lookup_header() helper
  instead of adding a duplicate inline-header helper.
- Keep indexed bucket xh_entries[] bounded by the first bucket block,
  while checking name/value offsets against the addressed bucket block.

Cen Zhang (2):
  ocfs2: validate inline xattrs during inode block validation
  ocfs2: validate external xattr entries when reading metadata

 fs/ocfs2/inode.c |   4 +
 fs/ocfs2/xattr.c | 192 +++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 177 insertions(+), 21 deletions(-)

-- 
2.43.0
