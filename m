Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A764A8FC3
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441218; cv=none; b=YYI+gE0BLAjScGW41H1F30IP7I/HlbtN5nMngVc7M2q46lxDpu+OCbx5iJNwsrifNiwr3eo8F1yN5fmiawrszJ+leQw/ETqBgdcc+fk5PsgMhUi6fY9+AFF/TpVFzSwO8KW7mENo+jkKr7E5/Sm7uUdkF+ddObXsZ5XIPTNSdfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441218; c=relaxed/simple;
	bh=ODpDPyQlLQZ9GcisqtAFmuv0wByqwZNPY1Y+zGwjuPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fk9QXhQZROGbxtlJ5oMizqCM0pH+Se4P7wX7U2bFOf56z1nJ/uX3Y7AQOGsI9liDMdB/8luVYZZaxu8zzvEb3eTCDTpYuaNYU2oAt6AkhAHFI3fU9l2PiFD8C75WGeQSL0g7+edqZingbxemWETI7eRaNSqXEMwNMyDXudiAWCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DByqAHjQ; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DByqAHjQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788441195; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=zaJFr6gdl6SHI1QMfo77MGjM21RtsVjuYJkhLmdiGvA=;
	b=DByqAHjQRmrP2Yx9p3SAV2xGYPM2Op2ClSvb8+p68mhAAdthfxvmcZxPA/XZ9v3NtKvB6D72Uo8cWe++HnDEoweXA7xUQC7ozFoXYpGamNN2q/2eq8N/P9tEq9X26rsjQnuYMkZIjDfBaXTwGzne7OZJJTK84/WkwtDaiLmIcs4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAG2x2N_1788441193;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAG2x2N_1788441193 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 21:13:14 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ocfs2: xattr bucket validation fixes
Date: Thu,  3 Sep 2026 21:13:11 +0800
Message-Id: <20260903131313.2396208-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260902124109.27775-1-joseph.qi@linux.alibaba.com>
References: <20260902124109.27775-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two problems around xattr bucket validation.

Patch 1 fixes a false-corruption failure on blocksize-512 volumes:
the bucket validator limited the entry array to the first bucket
block while the write path stores entries across the whole 4096-byte
bucket region, so a legitimately written, fsck-clean bucket could be
rejected and force the filesystem read-only.  It also adds an
alignment check on the bucket block number, since the entry array is
accessed as one contiguous region and a corrupted xattr tree could
otherwise point a bucket at blocks straddling a page boundary.

Patch 2 converts two mlog_bug_on_msg() checks in the bucket defrag
path to ocfs2_error() returns, so that a corrupt bucket holding
overlapping entries or an inflated xh_free_start marks the filesystem
read-only and fails the setxattr instead of panicking the kernel.

Both patches have been tested in QEMU: the blocksize-512 reproducer
(40 xattrs with 100-byte values, previously failing with "entry count
32 exceeds maximum 31") now passes with a clean fsck.ocfs2 result,
and the ocfs2 testsuite xattr tests pass 48/48 across blocksize
combinations.

Changes since v1:
- v1 was a single patch ("ocfs2: allow xattr bucket entries to span
  multiple blocks").  The series is now split into two fixes.
- Patch 1: reject buckets whose first block number is not aligned to
  the bucket size before validating the entry array; the flat entry
  access could otherwise read out of bounds for a bucket from a
  corrupted xattr tree that straddles a page boundary.
- Patch 2 is new: return an error instead of BUG() when defrag finds
  inconsistent bucket contents.

Joseph Qi (2):
  ocfs2: allow xattr bucket entries to span multiple blocks
  ocfs2: reject inconsistent xattr bucket during defrag

 fs/ocfs2/xattr.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

-- 
2.39.3

