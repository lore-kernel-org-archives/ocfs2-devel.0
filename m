From: WeiWei Wang <wangww631@huawei.com>
Date: Tue, 23 Sep 2014 17:05:09 +0800
Subject: [Ocfs2-devel] [PATCH 0/7 v2] ocfs2: allocate blocks in direct I/O
 write
Message-ID: <542137C5.1020207@huawei.com>
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
write any more because the allocate blocks are enabled in direct I/O now.

This patch set can be applied against 3.17-rc6 branch of ocfs2 directly.

Please consider, Thanks.
							-- Wang

Weiwei Wang (7)
	ocfs2: eliminate the static flag of some functions
	ocfs2: add two functions of add and remove inode in orphan dir
	ocfs2: add orphan recovery types in ocfs2_recover_orphans
	ocfs2: add and remove inode to orphan in ocfs2_direct_IO
	ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks
	ocfs2: do not fallback to buffer I/O write if appending
	ocfs2: do not fallback to buffer I/O write if fill holes

 fs/ocfs2/aops.c    | 160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
------
 fs/ocfs2/file.c    | 104 +++++++++++++++++++++++++++++++----------------------------------------------------
 fs/ocfs2/file.h    |   9 ++++++++
 fs/ocfs2/journal.c |  90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 fs/ocfs2/journal.h |   5 ++++
 fs/ocfs2/namei.c   | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
---------
 fs/ocfs2/namei.h   |  21 ++++++++++++++++-
 fs/ocfs2/ocfs2.h   |   6 +++++
 8 files changed, 451 insertions(+), 105 deletions(-)
