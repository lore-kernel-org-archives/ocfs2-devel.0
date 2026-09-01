Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796B4381E85
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244394; cv=none; b=JCRtnVPB27DGCJ9UEaipi6nPUdLSI2X9FWQFeUxyPWNfYYjL86kf3Sjduf7X7rreNagCOT+yrVa34Fk4sNd26dIn9iwud0p9yTiHcdCaIqHBnOWqtsrjO7TPWlfKdQfSP/2pAvJZWNV+lqGSblLxs1LYjEl1hap0bhLsBRsSeEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244394; c=relaxed/simple;
	bh=edazl2ou1TLvrk3rmjtmKnMfsy2LB8FGmDUno3DnjzU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cvqR93ldSTF5us17lFwiLZOuky7UJdCrPIPQltThg0YIjOfMHSeI2Vd50XMffYMqifgZAMf13mTjZnL03JV5zy2qnVUo8iJjB2jUnWa4WPb6hY3e7XBAX96HQ2nhD+koLVU56gDlAQ2DAzrfL56Y20ECuYxL8dssA3Bgi5/z8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=extOXSQQ; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="extOXSQQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788244383; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bnWFImoGhAi1v6CrkWMP07uZX5A0q/0x1mw75nQV2cA=;
	b=extOXSQQiONYlW1TTxYk/YwJeje0Kh+miGxzk/5Us34Tm8r39AGuwtBxcdXtDXWNPF8geZ5dOGfa/FNO1ZdSZ8SZCB+6iM4TcPJD1QiROc2XCQlK71gWqmwJJN6pyi3R8AJt7YhyXxLK7Di81ElvMwMRwI9xlR0V5o0XwuaEhsE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA47zCd_1788244381;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA47zCd_1788244381 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 14:33:02 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] ocfs2: validate suballoc slot and bit of metadata blocks
Date: Tue,  1 Sep 2026 14:32:57 +0800
Message-Id: <20260901063301.984933-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ocfs2 metadata validators trust the on-disk suballoc slot and bit
without checking them against the slot range of the mounted filesystem
and the capacity of the block group bitmap.  A corrupted image can
carry OCFS2_INVALID_SLOT or another out-of-range slot, or a suballoc
bit beyond the bitmap, and once the corresponding inode, extent block,
xattr block, dir index root or refcount block gets freed, the bad
value goes straight into ocfs2_get_system_file_inode() or
_ocfs2_free_suballoc_bits() and hits a BUG_ON() or runs off the end of
local_system_inodes[].

This series rejects such values at read time in the existing
validators, so a corrupted filesystem fails with -EROFS and remounts
read-only instead of crashing:

  patch 1 restricts dinodes with OCFS2_INVALID_SLOT to system inodes,
        completing fe7a283b3916 ("ocfs2: add suballoc slot check in
        ocfs2_validate_inode_block()"), and turns the "system file
        state is ambiguous" BUG_ON() in ocfs2_read_locked_inode() into
        an ocfs2_error();
  patch 2 rejects oversized suballoc bits in dinodes;
  patch 3 validates the suballoc slot and bit of xattr and dir index
        blocks;
  patch 4 validates the suballoc slot and bit of extent and refcount
        blocks.

The checks only enforce what the kernel and mkfs.ocfs2 already write:
a valid slot from meta_ac->ac_alloc_slot and a bit within the block
group bitmap, with system inodes carrying OCFS2_INVALID_SLOT plus
OCFS2_SYSTEM_FL and extent blocks using slot 0.  Nothing changes for
healthy filesystems.

Each new check was exercised under QEMU by corrupting the field in
question with an out-of-range value; with the series applied the
access fails with -EROFS and the filesystem remounts read-only instead
of hitting the BUG_ON().

Changes since v1:
  - Patch 1 also turns the system-file-state BUG_ON() in
    ocfs2_read_locked_inode() into ocfs2_error().  i_flags is on-disk
    data, so a crafted dinode with OCFS2_SYSTEM_FL passes the slot
    check and still hit that BUG() on a plain lookup.
  - Patches 2-4 now bound the suballoc bit against the block group
    bitmap capacity (block size minus the group descriptor header)
    instead of the raw block size, using a new
    ocfs2_suballoc_bits_per_block() helper.
  - Patch 3 also validates xb_suballoc_bit and dr_suballoc_bit.
  - Patch 4 also validates h_suballoc_bit, and adds rf_suballoc_slot
    and rf_suballoc_bit checks in ocfs2_validate_refcount_block().

Joseph Qi (4):
  ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
  ocfs2: validate suballoc bit during inode read
  ocfs2: validate suballoc slot and bit of xattr and dir index blocks
  ocfs2: validate suballoc slot and bit of extent and refcount blocks

 fs/ocfs2/alloc.c        | 27 +++++++++++++++++++++
 fs/ocfs2/dir.c          | 27 +++++++++++++++++++++
 fs/ocfs2/inode.c        | 53 ++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/ocfs2.h        | 11 +++++++++
 fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++
 fs/ocfs2/xattr.c        | 25 +++++++++++++++++++
 6 files changed, 161 insertions(+), 9 deletions(-)

-- 
2.39.3

