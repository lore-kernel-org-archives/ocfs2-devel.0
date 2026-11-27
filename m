Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750404;
	b=ohAdepU4lIUI8ezeHc+2BEHj9sBAe5zFuuLnP9nCxgZWt1o/oKWoF1r/AKn0UJcZn1eU
	 TRRTX4WEUuaxl90GrlM3pGebb69qeWBWM+65neXdC66IJZvDOHENKKIgABdTNt5bsBspV
	 NlbJ0bHyT2U4U9bE8FTS1GT9t5muJYDijJDlqkYQ4TGN5wH3LxUPzla6S6QNX7kvFRMvX
	 s35TamMtusU8Tz8iyGhLaKxafEIxH1UoFAJJWIEVOZzOzx8VmNFpqgkxQE7Ividhv69kV
	 tRyejeT3PlqGtOZmGMiUjef0oMLbILM8RJKAkEBQmwLX04lslfV6QcVBh00RJxzEjoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=88MOwP+WFiSndeMYNiLWNJfmFa4GEaqIuVkyLHkH81c=;
	b=zuwvqDt+PvXF4sSIE1fH1jAJCgToqParUeJc9tKk/Sx+usZD9wltpYsTY96MEhDySW/h
	 XtorE8Yx8N5rN7m2IQXc/ImtLcVLLN22i80oPnQT4gFlaI4Ny9q5U6WGOSO+wdugamfDb
	 v7dgFEH9kBJEZZCri4n97XAiAaIko/BE6Zwtjt8D8YjyFfTgTko5+fkwYPAV2TtGtSUlS
	 2ebnG+AX+frcjDryxMSgd3FMMFVkaQyhKALrNLv3kskwJFhCFBkgAv/br3KQSHLsGLWVf
	 ecof9ZsXWUym7VTuE1/puCMq8v8nYrjCKKg/wyBxeq3a+3L/r+05HhX39G+8LTBJPpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="E/diMXGE";
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0230606A329
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Nov 2026 03:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0230606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=E/diMXGE
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c506187deb9so125843366b.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Nov 2026 19:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795750402; x=1796355202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=88MOwP+WFiSndeMYNiLWNJfmFa4GEaqIuVkyLHkH81c=;
        b=E/diMXGEpZVNJwcV28C2mpVNHJYj0C04AS4ArPBQRsfpRwWI7yU+0e+C5izBcPi/8+
         33lYTpuyInWYWxRHsih0pyF/Ykcv09masNIFC0Ak9Dk69jgT9NRDRZIIUo1yukMErdDZ
         o1A8Az/XAf5eVHU7iyl2dyv9SROAzU14YhO5gO31Nassf3HpNdYGz1fD2V/1kA42h/m9
         DUv/V6/BRNI2xlg+rcELAKlrHoF1gNysn9iFQukqIa4MAXoXpGg81dqBh79A+AKm4K87
         i7n1TSkKDQFhonzlO9Y3SwDc/iqPGtTjq5zrhcmC3tL8y2ewAOyxEAJlQSzpT3vsctqp
         Y48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795750402; x=1796355202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=88MOwP+WFiSndeMYNiLWNJfmFa4GEaqIuVkyLHkH81c=;
        b=AUNmZiVPDfRGpXe0RYD1NTVVb6uWyFUwG56gCYqb8zZB9k9wCtWnREJKAhYwnh6R4t
         KnrKduEWnd6CzJ+6QTo8cFFYbPVkMc23JsJEviJf5cUloH0ReA9WrgQOH1ZzO8qQ2dSx
         PVyklEwPBN9p9mS8A+aoAK/2tNmeVTnQ9XiPenPEzxYpGe181CxkliFBO+OUsKetis1C
         0be0bXof5+Ep6P+H3K71DAQ7eQz0BMFOD6YNFhc1vIO+Ev2p/lsH+sILfGpuDq/9lb6M
         rCIdCcJ7r8oH/XWkNUD6Ghv1VL5BbWDD7Lz0MPNuwnDnJ2zZTo0k0AVzrSAgfbvmqOx+
         ucDQ==
X-Forwarded-Encrypted: i=1; AL+hErHd7gTVHb190cV/mcNOhTGbXxSrFH/E4QTVdT03jpsg9/ewWvFXPZOhg+bvajkWQbRVIyy/v5sA4I28mw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9J4II9LKhTrRhGbnTkhZsHPnTmCnVDK5HQYURadDuHf/8V4vwT
	45jYx+rr+LO+DyQObKlyrMtq6g4bhPqkfSsGQIly58SjhlBbnXF4s/psP7G5dzBjeoU=
X-Gm-Gg: AZFdTZdKG5cXCsQ6Wjlnnuxa/GSZsYAZXp1d7z7zB870Vd4RS1zkqQ0g/C1wBdSJq75
	sOk8EUPX3mpoiJNMa9njRCNrxOKLW1JB9L0xjCLuA29FxidtFDPsIG4w+Dalivsh3PAmv2cySR/
	JDPiNIIgFSJnmAq67EivbxUg524F+yVpr4vG3WKhZiph0moMhigDGzPtdvIIT1NrD5/zT3x8Unv
	pCv2XICGFLteVyGHNv6mNqyd5+jtzMJYHqIUPPc45Pvd/Zc5wKE7WgDosy/dwXZ/H5bG5wbhm7k
	CtlmAXDfp8sG0p6hBqij5hI9YxU7M9IQBz3KN3lbkEkKmfmIBARoGNNpxAh/GNCLiymio7hBs3k
	KFUz5Qpoob3dYX1JTZjK9lQTWKNc6G2ciB52AO/NKrbBMhPFX5xdQLhjr8R/jKz6ugATA4v2mph
	3bTeyLIDpW8XPa/1Vv7kJNWv2edGwEjUaCIF1cEA9DR7Sg5H+orJkB0VzDMHRchgnAPt3bH4YKk
	ewNJm5osBF3z7ohBq+Ozr9vtaNj5WFLQ0nby0+lOqpFNpDiSX3g5Xo4G44KQr47ur9nk39VwqZd
	4ZbhtVB7ZcgIeIBT+sCbGh6OXI3Uy5W0v18z80lXCsw=
X-Received: by 2002:a17:906:80d7:b0:c51:9c26:7f10 with SMTP id a640c23a62f3a-c519c26a5cfmr675203866b.3.1795750402350;
        Thu, 26 Nov 2026 19:33:22 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm38375797a91.4.2026.11.26.19.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 19:33:20 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v12.1 0/3] migrate ocfs2 DIO from buffer_head to iomap
Date: Fri, 27 Nov 2026 11:33:09 +0800
Message-ID: <20261127033313.9169-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set migrates ocfs2 Direct I/O (DIO) from buffer_head mode
to iomap mode. It is based on commit aebb72744764 (v7.4-rc3), and
also incorporates Joseph's code and ideas.

v12.1 changelog:
patch 1/3: no change

patch 2/3:
 - patch [2/3]: add "Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>".
   Joseph already gave his reviewed-by on v10.

patch 3/3:

sashiko: [High] ocfs2: missing fsync tid and i_blocks update in ocfs2_dio_end_io_write()
fix: updating oi->i_sync_tid, oi->i_datasync_tid in ocfs2_write_end_nolock()
     and ocfs2_dio_end_io_write()

sashiko: [High] ocfs2: ocfs2_dio_cleanup_range() fails on zeroed folios past i_size
fix: rewrite the clean dirty pages api ocfs2_dio_cleanup_range(). Add a new
     function ocfs2_write_range_buffers() which directly syncs dirty buffer
     head. the previous code in v12 used filemap_write_and_wait_range() which
     only clears folio dirty flag but leaves BH_Dirty set on the buffer_heads.
 
sashiko: [High] ocfs2: missing IOMAP_F_DIRTY in ocfs2_iomap_begin() for
         uncommitted metadata
fix: set IOMAP_F_DIRTY when oi->i_datasync_tid changes in ocfs2_iomap_begin.
     without this change, the uncommitted metadata changes will be skipped 
     in the iomap path.

sashiko: [Medium] ocfs2: overestimated metadata reservation in 
        ocfs2_write_begin_nolock() for DIO
fix: refactory ocfs2_lock_allocators(), change parameter extents_to_split to
     max_recs_needed. this change fits for the new iomap direct write path

sashiko: [Medium] ocfs2: per-cluster multi-MB allocation thrashing on ENOSPC in
         ocfs2_dio_wr_map_blocks()
fix: remove retry logic in ocfs2_dio_wr_map_blocks() when ocfs2_write_begin_nolock()
     returns -ENOSPC. This retry logic is ineffective when the disk space is
     exhausted, as it only works if another process releases space while -ENOSPC
     occurs.

sashiko: [Medium] ocfs2: stale inode state after lock drop in ocfs2_dio_upgrade_rw_lock()
fix: remove ocfs2_dio_upgrade_rw_lock() and its calling logic. After this removal,
     the rw_lock behavior is the same as before this patch set.



--------------
# test report

This patch set has been tested on 7.4-rc3 kernel

## ltp

runltp -f dio -d /mnt/ocfs2/

results: passed


## xfstests

./check -g quick -T -b -s ocfs2 -e generic/081 \
-e generic/266 -e generic/272 -e generic/281 \
-e generic/338 -e generic/347 -e generic/361 \
-e generic/628 -e generic/629 -e generic/648 -e generic/650 

OCFS2_MKFS_LOCAL_OPT="-b 2K -C 8K --fs-features=local --fs-feature-level=max-features"
Failures: generic/003 generic/056 generic/075 generic/091 generic/094
generic/112 generic/177 generic/211 generic/225 generic/263 generic/321
generic/322 generic/329 generic/331 generic/370 generic/376 generic/424
generic/448 generic/467 generic/477 generic/481 generic/498 generic/510
generic/512 generic/513 generic/534 generic/537 generic/552 generic/557
generic/563 generic/564 generic/578 generic/588 generic/607 generic/620
generic/630 generic/755 generic/759 generic/760 generic/771 generic/777
generic/779 generic/784 ocfs2/001
Failed 44 of 632 tests

## fio

no test

-------------
patchset history

v1 patch set:
https://lore.kernel.org/ocfs2-devel/20260724052559.15409-1-heming.zhao@suse.com/
v2 patch set:
https://lore.kernel.org/ocfs2-devel/20260727061802.18485-1-heming.zhao@suse.com/
v3 patch set:
https://lore.kernel.org/ocfs2-devel/20261018143319.22329-1-heming.zhao@suse.com/
v3 sashiko review:
https://sashiko.dev/#/patchset/20261018143319.22329-1-heming.zhao%40suse.com
v4 patch set:
https://lore.kernel.org/ocfs2-devel/20261103135605.22943-1-heming.zhao@suse.com/
v4 sashiko review:
https://sashiko.dev/#/patchset/20261103135605.22943-1-heming.zhao%40suse.com
v5 patch set:
https://lore.kernel.org/ocfs2-devel/20261105071930.16399-1-heming.zhao@suse.com/
v5 sashiko review:
https://sashiko.dev/#/patchset/20261105071930.16399-1-heming.zhao%40suse.com
v6 patch set:
https://lore.kernel.org/ocfs2-devel/20261115154013.9379-1-heming.zhao@suse.com/
v6 sashiko review:
https://sashiko.dev/#/patchset/20261115154013.9379-1-heming.zhao%40suse.com
v7 patch set:
https://lore.kernel.org/ocfs2-devel/20261118002050.9019-1-heming.zhao@suse.com/
v7 sashiko review:
- https://sashiko.dev/#/patchset/20261117150053.18417-1-heming.zhao%40suse.com
- https://sashiko.dev/#/patchset/20261118002050.9019-1-heming.zhao%40suse.com
v8 patch set:
https://lore.kernel.org/ocfs2-devel/20261119064029.11910-1-heming.zhao@suse.com/
v8 sashiko review:
https://sashiko.dev/#/patchset/20261119064029.11910-1-heming.zhao%40suse.com
v9 patch set:
https://lore.kernel.org/ocfs2-devel/20261120060014.12087-1-heming.zhao@suse.com/
v9 sashiko review:
https://sashiko.dev/#/patchset/20261120060014.12087-1-heming.zhao%40suse.com
v10 patch set:
https://lore.kernel.org/ocfs2-devel/20261124045501.10281-1-heming.zhao@suse.com/
v10 sashiko review:
https://sashiko.dev/#/patchset/20261124045501.10281-1-heming.zhao%40suse.com
v11 patch set:
https://lore.kernel.org/ocfs2-devel/20261124152623.7838-1-heming.zhao@suse.com/
v11 sashiko review:
https://sashiko.dev/#/patchset/20261124152623.7838-1-heming.zhao%40suse.com
v12 patch set:
https://lore.kernel.org/ocfs2-devel/20261125154626.22335-1-heming.zhao@suse.com/
v12 sashiko review:
https://sashiko.dev/#/patchset/20261125154626.22335-1-heming.zhao%40suse.com 

-------------------
Heming Zhao (3):
  ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
  ocfs2: switch DIO read path from buffer_head to iomap
  ocfs2: switch dio write path from buffer_head to iomap

 fs/ocfs2/Kconfig        |    2 +-
 fs/ocfs2/aops.c         | 1950 +++++++++++++++++++++++++++++++--------
 fs/ocfs2/aops.h         |   43 +-
 fs/ocfs2/extent_map.c   |   34 +-
 fs/ocfs2/extent_map.h   |    3 +
 fs/ocfs2/file.c         |  294 +++++-
 fs/ocfs2/inode.h        |    9 +
 fs/ocfs2/mmap.c         |    2 +-
 fs/ocfs2/ocfs2.h        |   25 +-
 fs/ocfs2/refcounttree.c |    2 +
 fs/ocfs2/suballoc.c     |   50 +-
 fs/ocfs2/suballoc.h     |    5 +
 fs/ocfs2/super.c        |    3 +
 13 files changed, 1976 insertions(+), 446 deletions(-)

-- 
2.55.0

