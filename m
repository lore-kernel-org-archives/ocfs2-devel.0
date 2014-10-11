From: WeiWei Wang <wangww631@huawei.com>
Date: Sat, 11 Oct 2014 20:23:59 +0800
Subject: [Ocfs2-devel] [PATCH 0/7 v4] ocfs2: allocate blocks in direct I/O
 write
Message-ID: <5439215F.2020709@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Currently in case of O_DIRECT append write (block not allocated yet),
ocfs2 will fall back to buffered I/O. This has some disadvantages.
Firstly, it is not the behavior as expected. Secondly, it will consume
huge page cache, e.g. in mass backup scenario. Thirdly, modern
filesystems such as ext4 support this feature.

In this patch set, the direct I/O write doesn't fallback to buffer I/O
write any more because the allocate blocks are enabled in direct I/O
now.

changelog:
v4 <- v3:
 -- zeroing blocks when O_DIRECT append write is not cluster aligned.
 -- fallback to buffered I/O if we are appending and concurrent
	O_DIRECT writes are allowed.
 -- no longer call ocfs2_start_trans with ocfs2_inode_lock, to avoid
	possible deadlock.
 -- no need call ocfs2_journal_access_di since it will be called in
	ocfs2_orphan_add and ocfs2_orphan_del.
 -- simplify the ocfs2_orphan_reco_type to two types.
 -- fix a deadlock in ocfs2_recover_orphans, and distinguish the new
	truncate logic from original recover logic.
 -- refactor ocfs2_direct_IO.

Any feedbacks are always appreciated.
Thanks,
							-- Wang

Weiwei Wang (7)
	ocfs2: eliminate the static flag of some functions
	ocfs2: add two functions of add and remove inode in orphan dir
	ocfs2: add orphan recovery types in ocfs2_recover_orphans
	ocfs2: add and remove inode to orphan in ocfs2_direct_IO
	ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks
	ocfs2: do not fallback to buffer I/O write if appending
	ocfs2: do not fallback to buffer I/O write if fill holes

fs/ocfs2/aops.c    | 223 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
----
fs/ocfs2/file.c    | 104 +++++++++++++++++-------------------
fs/ocfs2/file.h    |   9 ++++
fs/ocfs2/journal.c | 131 ++++++++++++++++++++++++++++++++++++---------
fs/ocfs2/journal.h |   5 ++
fs/ocfs2/namei.c   | 165 +++++++++++++++++++++++++++++++++++++++++++++++++++------
fs/ocfs2/namei.h   |  20 ++++++-
fs/ocfs2/ocfs2.h   |   5 ++
8 files changed, 555 insertions(+), 107 deletions(-)
