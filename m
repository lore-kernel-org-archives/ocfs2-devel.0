From: Fabian Frederick <fabf@skynet.be>
Date: Sun, 21 May 2017 17:39:47 +0200
Subject: [Ocfs2-devel] [PATCH 00/11 linux-next] super magic values
	consolidation
Message-ID: <20170521153947.26281-1-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, fabf@skynet.be, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, pvfs2-developers@beowulf-underground.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com

This small patchset reorganizes magic.h and fixes filesystems
which defined locally super magic values.

Fabian Frederick (11):
  uapi: reorganize magic.h
  exofs: use magic.h
  ceph: use magic.h
  orangefs: use magic.h
  ubifs: use magic.h
  jfs: use magic.h
  ocfs2: use magic.h
  fuse: use magic.h
  freevxfs: use magic.h
  fs: define hfs super magic values globally
  hfsplus: export super magic value

 fs/ceph/super.h            |   4 +-
 fs/exofs/common.h          |   6 +--
 fs/freevxfs/vxfs.h         |   6 +--
 fs/fuse/control.c          |   3 +-
 fs/fuse/inode.c            |   3 +-
 fs/hfs/hfs.h               |   4 +-
 fs/hfsplus/hfsplus_raw.h   |   2 +-
 fs/hfsplus/part_tbl.c      |   2 -
 fs/jfs/jfs_incore.h        |   6 +--
 fs/ocfs2/ocfs2_fs.h        |   5 +--
 fs/orangefs/protocol.h     |   3 +-
 fs/ubifs/ubifs.h           |   4 +-
 include/uapi/linux/magic.h | 104 ++++++++++++++++++++++-----------------------
 13 files changed, 65 insertions(+), 87 deletions(-)

-- 
2.9.3
