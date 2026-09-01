Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9B73B0AD4
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 12:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267148; cv=none; b=RcsIIBR99XP3TdOGbobxAGqId+ykWHn7EAq9mtvTzoU9paUgfdL5E2ivnwGbuZI0IFWkcys8wlrS/wnVFbUCLuC0Tgon+NLweUK7ftpc9Sjun0m1sA6RPQj04K1vTd5bwhoeTW+mzXtc5rf8lGbBgknI0EkUERjIctyNz33Ud0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267148; c=relaxed/simple;
	bh=xuTrV4pXoOZl+Tp7ZjN7Bb2VhtJZoA62HmxbdTh8Doo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jEH4NeYx4g3UelQzHCKpOW+jvpo9JqX4ktCY+X5Olxdb4iHVI/Ot9j63OqUMmu18ydQWv/re3zootrlgdUHRwAktmQ2JxSYkkI5Pgys2k5uopHK9fEXNMv3XaK/0PDCrEbLwpJGRIBRu2kqA+hu8PFhp59hd+o8zPG6+D1mH4/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LfsV5yx2; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LfsV5yx2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267143; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=2CZ+W04NMyQ3mjIM9OeagaKgklHcexVW32i8nCng0YA=;
	b=LfsV5yx2H6lxxKDEO2ygDFY1AoePHuxPMjg8QmZSi7SiE7Ea8oLhKGJqCT5c8Rb5AhR8KdJOaAA/D0SB/JTc0dnhbq8PYHK0zJY671uSVESuOMgzvFeRrK0WivhViPLH1Gxw6Eju7MV0D4OfaE75YFS66a9HmrYWv+kJP+arYS0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA8T02._1788267141;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA8T02._1788267141 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 20:52:22 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] ocfs2: validate suballoc slot and bit of metadata blocks
Date: Tue,  1 Sep 2026 20:52:17 +0800
Message-Id: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
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

This series rejects such values at read time, in the existing
validators, so corrupted objects fail with -EROFS (and a read-only
remount) instead of crashing:

  patch 1 restricts OCFS2_INVALID_SLOT dinodes to system inodes,
        completing fe7a283b3916 ("ocfs2: add suballoc slot check in
        ocfs2_validate_inode_block()"), and turns the "system file
        state is ambiguous" BUG_ON() in ocfs2_read_locked_inode() into
        an ocfs2_error();
  patch 2 rejects oversized dinode suballoc bits;
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

Changes since v2:
  - Patch 2 converts the BUG_ON() against ocfs2_bits_per_group() in
    _ocfs2_free_suballoc_bits() to ocfs2_error().  That bound is
    derived from cl_cpg/cl_bpc of the allocator dinode, which is not
    validated against the actual group capacity and can be
    artificially smaller on a corrupted image, so the static
    validation bound alone is not sufficient.
  - Patch 2 also derives ocfs2_suballoc_bits_per_block() from
    ocfs2_group_bitmap_size().  With discontig_bg enabled the
    suballocator bitmap is capped at OCFS2_MAX_BG_BITMAP_SIZE (2048
    bits), which the previous blocksize-based bound missed, letting a
    corrupted bit in [2048, bits-per-block) slip through validation.
  - Patch 3 also verifies dr_blkno against the physical block number
    in ocfs2_validate_dx_root() like the extent and xattr block
    validators do, so misplaced dir index root blocks are rejected.
  - Patch 4 converts the remaining BUG_ON() against group->bg_bits in
    _ocfs2_free_suballoc_bits() to ocfs2_error(); group descriptor
    validation only guarantees bg_bits within the physical bitmap
    size, and otherwise ocfs2_block_group_clear_bits() could clear
    bits beyond bg_bitmap.
  - The suballoc bit comments in the validators are updated
    accordingly.

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
 fs/ocfs2/dir.c          | 35 +++++++++++++++++++++++++++
 fs/ocfs2/inode.c        | 53 ++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/ocfs2.h        | 12 ++++++++++
 fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++
 fs/ocfs2/suballoc.c     | 33 +++++++++++++++++++++----
 fs/ocfs2/xattr.c        | 25 +++++++++++++++++++
 7 files changed, 199 insertions(+), 13 deletions(-)

-- 
2.39.3
