Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853A1357A3E
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 06:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788157735; cv=none; b=it5A9tdmsubSQXeqlSXXBLEsVSYOQo2SgZ2BIicVjja+Qrtjz1XEF5y1auYlplmDViG1n0UnNC4pgTt4x5DEU5dxQntkydhbeX3YzZrDjAFBOYOoQLZ0ZL971DLk/lEbl5zX7hNeDpjh9EnqA3gI0hOiXQL/xEZinu2abUC4otc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788157735; c=relaxed/simple;
	bh=24F7JnUKIQwR1p9OEYUFcs/P364dEGyxjRuC7f4ru7w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f3DmEQCz+jv4ObFmp8bA+zazkZEpJ3J+aKQurUK5kq2Pw49YCYG01Tljhg4aBhETLv7/LLNY8VO+3/1+ZG0HhXcGE2KxC8r2s/NfONykV6UXoHAQEB86YB3A2agya+JMikwiCh8XHmrxX7bvBsxGk8m5ENx9de/i26Gc9PfEFxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b6wbcLDr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b6wbcLDr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788157730; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=y1z3/Aa1omnaTPLQzWaM4xGI1FJmgF5SMzjGce8CzKM=;
	b=b6wbcLDrJDv+R4c0yZsdr+BaHBcNqMPepBdiwxG9U0eCO+5Z8RWWu8nTRz1xpHzq7J8tMvbs/mwPzbKctM91PclIhQVIbgA5gOGM3dCTtHbHmQmowxuyxe0Qd8QgIm4jIO7MGiY53Zzj+5Fdf29QFpyEm3tCJo2Kv+CWtRtImSc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9tzGoQ_1788157729;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9tzGoQ_1788157729 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 14:28:49 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ocfs2: validate suballoc slot and bit of metadata blocks
Date: Mon, 31 Aug 2026 14:28:44 +0800
Message-Id: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2 metadata validators trust the on-disk suballoc slot (and the
dinode suballoc bit) without checking them against the mounted
filesystem's slot range.  A corrupted image can carry
OCFS2_INVALID_SLOT or another out-of-range value; when the
corresponding inode, extent block, xattr block, or dir index root is
later freed, the unvalidated slot/bit is passed to
ocfs2_get_system_file_inode() or _ocfs2_free_suballoc_bits() and hits
BUG_ON() or indexes local_system_inodes[] out of bounds.

Mounting ocfs2 requires privilege (ocfs2 cannot be mounted from a
user namespace), so this needs a privileged mount of a crafted or
corrupted image -- e.g. an administrator mounting untrusted media or a
disk image supplied to a virtual machine.  Once such an image is
mounted, an unprivileged user who can delete the corrupted object
triggers the crash.

This series rejects such values at read time, in the existing
validators, so corrupted objects fail with -EROFS (and a read-only
remount) instead of crashing:

  patch 1 restricts OCFS2_INVALID_SLOT dinodes to system inodes,
        completing fe7a283b3916 ("ocfs2: add suballoc slot check in
        ocfs2_validate_inode_block()");
  patch 2 rejects oversized dinode suballoc bits;
  patch 3 validates the suballoc slot of xattr and dir index blocks;
  patch 4 validates the suballoc slot of extent blocks.

All checks match what the kernel itself writes (always a valid slot
from meta_ac->ac_alloc_slot) and what mkfs.ocfs2/libocfs2 write
(system inodes carry OCFS2_INVALID_SLOT with OCFS2_SYSTEM_FL, extent
blocks carry slot 0), so legitimate filesystems are unaffected.

Tested with negative corruption testing under QEMU: for each new
check a test image was generated with the field overwritten by an
out-of-range value; with the series applied the access fails cleanly
with -EROFS and the filesystem remounts read-only instead of hitting
BUG_ON().

Joseph Qi (4):
  ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
  ocfs2: validate suballoc bit during inode read
  ocfs2: validate suballoc slot of xattr and dir index blocks
  ocfs2: validate suballoc slot of extent blocks

 fs/ocfs2/alloc.c | 14 ++++++++++++++
 fs/ocfs2/dir.c   | 14 ++++++++++++++
 fs/ocfs2/inode.c | 33 +++++++++++++++++++++++++++++++--
 fs/ocfs2/xattr.c | 13 +++++++++++++
 4 files changed, 72 insertions(+), 2 deletions(-)

-- 
2.39.3

