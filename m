Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7646480332
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 11:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779188666; cv=none; b=sWFAMenVnUXlgh99EzL8pu96uYO+FX0sgCKAJqjPfw2B4pnLFLXvM6H0zqECvZ+TF9K9bXhmq2pQK8HR9Js0CL1CvP9wOqrp/MXgSNuYP9MxRSOF50mHJqDFkQxUHuXdTUDghSMFK9YL7mb/Tne0eQLqYrcl4u3xMydaCaSM+1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779188666; c=relaxed/simple;
	bh=1WIhhqyimIG6xgGwMZqPr2KBtiPQ844g/owpCXhS4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nqMdU4L8rbbSjeulOFKL7xBrKfF8YR5bDk6vBPCTf17s4mJS39QO6fL5ZzYonSa8HaIuOr6lRk345Y47sz0Vkito9F7qymIdraNljXw09/ahyUJRe1yqVHGShtWd5SYS5Gjd4o1NzjONsIDuXoqWlU+yo2y/LSyrQ6km2AoiQ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3SVSxf7; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3SVSxf7"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7bf14e33f5bso28528817b3.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779188664; x=1779793464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9WEPJj4wYvtkwkwfLE2DQUprbinqua7axfePI1DHQ9g=;
        b=A3SVSxf7e8hFHRnCRY6T4mDKPRztpLfqNxtwUOEKli7YTrVjm3gHeVrN1sVZwReClI
         pXupj9aJnMt5s3nc/I+H0RMtsmafGszmOrvYN5DPreqJ4DvC7tjhUZqAKBXrcgvOnOEf
         yvJ9M2lCiIlkWINZc2A+tPGJt094P3wcWfDaAuUwNqt5fuFzWhAeWxsIurEFLiSrv6nH
         FrU+24v50AinHDaPM14pUIg2YHTis9i7HHm0leFMIYgJ5PhV05ZxMW197Ch+xaIgrG7B
         DC+Xo8bIRu8t3bHVOgJ0tdU7jq3DKwOumWCB+Cdvq4aFYsPR8/TIeYe5k0vGN0NTc70k
         fjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779188664; x=1779793464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WEPJj4wYvtkwkwfLE2DQUprbinqua7axfePI1DHQ9g=;
        b=c5rHif3lIueESpyI96i2cA2pn2a5BOjnv2NLsgoY7gUw3PXizj4+nWAv6RuF/3xVl4
         hyB0ih7ZAa+MBjj0nCgFEhvlASMCtGOZD3AliivUN5VH3VBD7YnJsbi8akyGJIL0Ux4u
         ZO4DmZFDys3sDfOv1WmkZSoRa0ylvT4bFDdEeatxF7lXBt3AaFo7wOUCX7p7oNsTvZhp
         7ckPCoTRyHfcwNUwF7vaPwDPH+ESnGGsFB+Bt1ep5m8lleCJPhgUvpm/VFsf8i+B3jvI
         VyB/KwhVnzJjjnKs6SUWyq3lIct/rFiIPaj0KGGDmyjUTLDQwfq44JFtuKm6POjlgh3B
         LLXg==
X-Forwarded-Encrypted: i=1; AFNElJ82GsGMBACcPDfLgMV4yHvb4r07QER7/z8dvL8bSQ2SElXTWXrl81bb6pjKm/9vlXhZXFLJrOQuB6x34g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwAr0r2K3okcj3dlFZzQkIs1FZ/G7soF1FL+4mrRcXK1pwCd0lC
	B/iRBNZX3YHlzI7/V+l0MU8NNrxJl7w995UBOUB5sxpvI2343IEb0qng
X-Gm-Gg: Acq92OE0Gg/nns6AEx0G5W4kqR949wlkPIh3tM6p4N62p9kZiCE0CeqWDy9lnq1VhGc
	bwmrTavKL+OUagDx1tmoH9thui3OB4MflSrLwgLIdqoKYUGT4obb3OP/ZLJwUiQXYaTlwBdDbsm
	OZgpc+uCtOz6Ht23EDI+/KGtU0urICwjw3AkOZAUo1EtirTceWcbZYSONxDDhqW/FdiKVWzmTaa
	M7mOieS0jDXDQHkSfrNVznvesShaJqug8nyBGmv3aVUVzrfsb5WTCxeaWe3h92tGBrYGu5W0Qn4
	lJujNtjrBePdpNvaCvNfhAfzRwQQDA55pfO1PLIfVzlJqg4iDroGp+D9k6uMh2Knh6O2KQw2Dn/
	kevKc8DWKKBL9gbTPRxf6Vt3YN227gGnkdFQ4eah4Ktd0YdxDw/VSwWznCOZp7+t14J6G6zmD9O
	BoNH0wr5/0QHVlOA6mQRCmQHVCgSQdm7eUCnDX8xhBokb3/lm14qJwDId+4OQdEjphdTKCTnzFH
	vtVtEDtKt+ZMKEPxnwuIwnKoC1rUOU=
X-Received: by 2002:a05:690c:c1a:b0:7ba:fdc5:17a3 with SMTP id 00721157ae682-7c95c6f978fmr196298607b3.43.1779188663775;
        Tue, 19 May 2026 04:04:23 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9bc0ccf7sm35206827b3.25.2026.05.19.04.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:04:23 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ZhengYuan Huang <gality369@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ocfs2: harden inode validators against forged metadata
Date: Tue, 19 May 2026 07:04:01 -0400
Message-ID: <20260519110404.1803902-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This series adds three structural checks to OCFS2 dinode validation so
malformed on-disk fields are rejected before ocfs2_populate_inode()
copies them into the in-core inode.

The checks cover:

  - i_mode values whose type bits do not name a canonical POSIX file
    type;
  - non-device dinodes whose id1.dev1.i_rdev field is non-zero; and
  - non-inline dinodes that claim non-zero i_size while i_clusters is
    zero, covering directories unconditionally and regular files on
    non-sparse volumes.

The normal read path reports these through ocfs2_error(), matching the
existing suballoc-slot, inline-data, chain-list, and refcount checks.
The online filecheck path uses the same structural predicates but keeps
its own reporting contract, returning OCFS2_FILECHECK_ERR_INVALIDINO
instead of calling ocfs2_error().

Validation from v1 still applies to the unchanged reachability model.

---

Changes in v2:

  - Patch 1 drops the tautological S_IFMT|07777 mask check and reuses
    fs_umode_to_ftype() for the canonical file-type predicate.
  - Patch 1 mirrors the i_mode check in the online filecheck path.
  - Patch 2 factors the i_rdev cross-check into a shared predicate.
  - Patch 2 mirrors the i_rdev check in the online filecheck path.
  - Patch 3 factors the size/cluster invariant into a shared predicate.
  - Patch 3 extends the zero-cluster rejection to non-inline
    directories, while preserving the sparse regular-file carveout.
  - Patch 3 mirrors the size/cluster check in the online filecheck path.
  - Patches 1 and 3 add Link trailers to the Sashiko review Andrew
    pointed out.

Testing after v2:

  - Replayed all three patches onto the original base, checked with
    checkpatch --strict, and applied cleanly with git am.
  - Rebuilt a fresh bzImage from the v2-applied tree.
  - Booted that v2 kernel five times under QEMU: sparse regular-file
    regression, non-sparse no-forge regression, forged non-canonical
    i_mode, forged non-device i_rdev, and forged non-zero i_size with
    zero i_clusters.
  - The three forged dinodes were rejected by
    ocfs2_validate_inode_block(); the two unforged regression cases
    completed without validator errors.

Michael Bommarito (3):
  ocfs2: reject dinodes with non-canonical i_mode type
  ocfs2: reject dinodes whose i_rdev disagrees with the file type
  ocfs2: reject non-inline dinodes with i_size and zero i_clusters

 fs/ocfs2/inode.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 2 deletions(-)

-- 
2.53.0
