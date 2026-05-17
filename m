Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD33314B9
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 11:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779016235; cv=none; b=OU4A4oGo04z9ZQxLw90OsDfyNDb5nFzT72SkYdS1dMedwRx36c8WFqCTcnFgv81kJhOC5tDjoazjv5sCeB++hm8uSSqb/cXyCt4q3liPv2pDMmNCoMz04XDGOKYgoFN4znhXeAHPaUgX2DWQqWXzSMyOLn5/eHz14bnZ39rZlJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779016235; c=relaxed/simple;
	bh=WSAeD9+GINAzh16KM2LUaC6xph/bYkCKYNODz21UYmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ku1BBS13T1++URuFaYANuKWbLtSoDqJuRek71LPgt7EodWo7BYC1IWv1Gowk8ndanwJiLO87urGJs6xpIzM7z2xms54jZuVX2jyFTyNJS7VfSMBYFoNQpvOOMVcEkHf+E9o3PixzI7zkEmEDHj1S0X7P++tPtzW6NN6y18JLwzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XA8Mz0tW; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XA8Mz0tW"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50e63771eb0so17984141cf.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 May 2026 04:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779016233; x=1779621033; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pt++DOA6Wc2HF8ky6f3A8ACPhJyI14sNysUPXV2Ffo4=;
        b=XA8Mz0tW1JdBPouKHxmBhxm6U2SC9/QR6HTNWg52Z2eToXpghc0e4ujZrNeHJMkkql
         vhrUPUyDjNUoKKgT4bTQWSahjNakFY3OrgU4gpjehgI97SekpdQ1UaKbQU0+RwfCluD8
         bLiYeSsHWf0tT7Kac31wsTpDBO4Sc4jQU4j0YWSUHDLWkrJYkvZqMBmZBCR9xar6/OiC
         aZmpkMWbbaAjtovyD/Z5gvf3Ls8VhLoxSBh30lwOU5Etox9e3UdS/QY+82XwIJZh86Y1
         nBVBPahuW1GyrfNMSGWeadHV5cA78Ix1XccI8cj08r9PqCQscTslksYSl1O9suOTR7XJ
         KIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779016233; x=1779621033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pt++DOA6Wc2HF8ky6f3A8ACPhJyI14sNysUPXV2Ffo4=;
        b=Xuva0YAwdDy7ccnicdzyB47rEtDpkUfNrSGEov6D87xUfjHJh/AdfzDUUXftg1D5pp
         h/aq+FwaYBZifH3+eVsrW09fnAu92ri0awtMe7Z962fu1bhA7NE55BKBRiUPF1ta8J7y
         +6xAMS98OzJeCwLvHCou6slwQDaOQpO1OPpEgc+7nBF2TyAt4qMF8D97PKXZuF+CbG1m
         5QaZGGwUwYsQbfR0J7JzLPkqdhJl5N0JFsyVWwlNq6+HHH8T7DLj5U5dyr1KE4T+5nB9
         9xKMhZuptmm8G0UpAx+YxnGYlhO4je1zB07NAbQ5YCxMhz3/aZh4R/+3gQ+nZuSOftHZ
         JpPw==
X-Forwarded-Encrypted: i=1; AFNElJ+bob0D4UtNRDUTLm2EoxK3pBCQY2JbEZaLzaKSwpjLtqs4+nQ8FIktSpnEUGvMzsaSvx/L3iInJqgRLw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo3juyoXxQ3DUaycma6XiXHHojecwTO3osffir3sfRZqDI1NVx
	2DSOgFTxf/q2SH/brW5eSgHxQ+TAilvvsUWl5/ZOa4r2G2ludoE99GAx
X-Gm-Gg: Acq92OGNBDeLG0nyJ0rLj2ERev5w8Bq5H10iVlEykb0YxstXxOb+1ar74vgOHXopPrJ
	1lCb0kw3eEmPyEGH0GyIUroZe+QJ4PlvLrKgLcgMdrLqhrr9rBI1Xv0PUCPxOC2W3gSiklMw8+3
	mgT9dEhWeMGsIi2I2IZ2TuojcX5T+HfxzqUiP1UFbw689ZemG4E+d2yRNY0MDCBOKGga/7mtJ2Q
	zcfUfeHXZf1G+nDaX/y5VkmpJa8rUZa8n/muqMKxB24gL+Yslum8tsZIdFKqqgBy8m2xij51gJI
	bxScZoIsjbAlXpWQZuTkWlLW4RxJqExptVfH8a63PdUSvh6KIcP5zIh7PzheBcCoGzIKXEH7Biu
	kWLCpAeWy+EFD/2rtkg/nabx/7z7VXPt2jmLbIzA0f5/BYIAqiLYuOY3PhwhOhkrjBVM9xkKroA
	C72V4Bn1k6m1YqIIBraGx/AJEmAEHKaQ5A6zmIK9VB611YMxkY+g7dgaJgwtILXvqdy+7xn2DaG
	YDeqIdw3R8WUodo/dWbhtQl5nb5fRkC6jSQliELyQqyS9RMK3VAWdjlv5awvmV4
X-Received: by 2002:a05:622a:996:b0:50f:de06:45e2 with SMTP id d75a77b69052e-5165a0d077bmr145323161cf.31.1779016232644;
        Sun, 17 May 2026 04:10:32 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456df09csm100306651cf.13.2026.05.17.04.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 04:10:31 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ocfs2: harden inode validators against forged metadata
Date: Sun, 17 May 2026 07:10:11 -0400
Message-ID: <20260517111015.3187935-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This series adds three structural checks to
ocfs2_validate_inode_block() that catch attacker-controlled bytes
in a freshly read dinode before ocfs2_populate_inode() copies them
verbatim into the in-core inode.  All three checks fire on the
mount, lookup, and read-after-cache-invalidation paths and reject
the block with ocfs2_error(), the same error-propagation
mechanism the existing suballoc-slot, inline-data, chain-list,
and refcount checks use.

Direction
=========

This continues the validator-hardening direction visible in the
recent in-flight ocfs2_validate_inode_block hardening series,
e.g. ZhengYuan Huang's "ocfs2: revalidate the journal dinode
before toggling dirty"
(<20260512024115.4036371-1-gality369@gmail.com>), "ocfs2: add
extent tree depth validation"
(<20260416110229.3283682-1-gality369@gmail.com>), and "ocfs2:
add extent list validation v2"
(<20260423094116.876696-1-gality369@gmail.com>).  Each of those
adds a per-field invariant check against bytes that downstream
code paths trust unconditionally.

The three checks in this series cover three more fields whose
attacker-controlled values currently propagate into VFS-visible
state without question: i_mode (type bits and reserved bits),
i_rdev (cross-checked against the file type), and the
i_size / i_clusters pairing for regular files on non-sparse
volumes (patch 3 is gated on !ocfs2_sparse_alloc(); sparse-
allocation mounts legitimately commit i_size > 0 with
i_clusters == 0 via ocfs2_zero_extend()).

Threat model
============

The validator is the chokepoint that protects
ocfs2_populate_inode() from a malformed dinode whether the
malformation got there via:

  (1) An attacker-supplied disk image mounted by a privileged
      user.  The mount path runs every dinode through this
      validator before any unprivileged user opens a file on
      the volume.  This is the same threat model the existing
      inline-data, refcount, and chain-list checks in this
      function were written for.

  (2) A compromised cluster peer with raw write access to the
      shared block device.  OCFS2 is a clustered filesystem;
      the on-disk blocks behind bh->b_data live on shared
      storage that other cluster nodes can write.  The local
      node's cache-eviction re-read runs the newly fetched
      block through this validator before ocfs2_populate_inode()
      runs again.  Oracle's BlockErrorDetection design document
      scopes the existing CRC32 + Hamming integrity primitive
      explicitly as defense against memory and wire corruption,
      not as authentication of peer writes; the field-level
      validators are therefore the kernel-side defense
      whichever path produced the forged block.

The three checks in this series are deliberately structural:
they each express an invariant mkfs.ocfs2 and the kernel
maintain unconditionally, and they reject any dinode whose
header violates that invariant before its bytes propagate to
the in-core inode.

Scope note: these checks block forge patterns that touch i_mode
(outside the canonical envelope), i_rdev (on a non-device file),
or the i_size / i_clusters pair (regular file with size but no
extents, on non-sparse volumes only).  A forger who keeps the
dinode within these structural envelopes (for example, flipping
only the permission bits and uid/gid on a regular file that
already has clusters allocated) can still produce a dinode that
satisfies the field-level invariants; closing that residual
class is outside the scope of this hardening series.

Validation
==========

Each patch builds on top of the previous one against mainline;
the series as a whole builds clean against v7.1-rc1 with zero
new warnings.  checkpatch --strict reports 0 errors, 0 warnings,
0 checks for each patch.

The series was exercised on a two-node QEMU cluster (virtio-blk
shared LUN with share-rw=on, both nodes joining the same o2cb
cluster, mounted ocfs2 with metaecc):

  - Pre-series baseline: a peer-node raw-write forge that adds
    S_ISUID and flips uid/gid to 0 on a regular file is accepted
    by the existing validator chain; the unprivileged user on
    the victim node exec()s the file and gains euid=0.  This
    confirms the cluster-peer write primitive is reachable in
    today's mainline.  Per the Scope note above, this particular
    forge stays within the structural envelope these patches
    enforce and is NOT blocked by them; closing it requires the
    out-of-scope keyed-integrity work.
  - Post-series, structural-variant forge: a peer-node forge
    that, in addition to the setuid + uid/gid changes, stores
    i_rdev = MKDEV(1,1) on the same regular-file dinode (the
    cleanest cluster-context attacker primitive patch 2
    catches) is rejected by ocfs2_validate_inode_block() with
    ocfs2_error "non-device mode 0104755 with i_rdev N".  The
    buffer-head propagates -EFSCORRUPTED to
    ocfs2_read_locked_inode and the user-visible result is
    Permission denied on subsequent stat / open / exec of the
    forged file.  Analogous post-series forge variants that
    flip i_mode outside the canonical envelope, or that set
    i_size > 0 with i_clusters == 0 on a non-inline regular
    file mounted from a non-sparse volume, are rejected by
    patches 1 and 3 respectively.

A separate cluster regression (mount, peer-write a regular
file, drop_caches on the second node, read it back) runs
clean post-series, so the checks do not regress normal
operation.

In-tree selftests under tools/testing/selftests/ that
reference fs/ocfs2/inode.c or any changed symbol were checked;
no matching selftests exist for ocfs2_validate_inode_block(),
which is consistent with OCFS2 having no in-tree selftest
coverage.  The subsystem's standard regression coverage is
xfstests (the generic fs group) plus ocfs2-test, both out of
tree.  Those were not run as part of this series; a full
xfstests pass before merge is recommended and I am happy to
run a representative subset and report results if reviewers
would find it useful.

Patches
=======

Michael Bommarito (3):
  ocfs2: reject dinodes with non-canonical i_mode type or stray bits
  ocfs2: reject dinodes whose i_rdev disagrees with the file type
  ocfs2: reject regular files with non-zero i_size and zero i_clusters

 fs/ocfs2/inode.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

--
2.53.0

