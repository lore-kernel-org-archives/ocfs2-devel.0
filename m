From: WeiWei Wang <wangww631@huawei.com>
Date: Wed, 10 Sep 2014 20:38:04 +0800
Subject: [Ocfs2-devel] [PATCH 0/7] ocfs2: allocate blocks in direct I/O write
Message-ID: <5410462C.8090707@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi all,
In ocfs2 append I/O write and fill holes I/O write situation, blocks have not been allocated yet, so the direct I/O write will fallback to buffer I/O write.
Buffer I/O write the data to page cache first, then flush the page cache to disk, this will consume some performance. In this patch, the direct I/O write
doesn't not need to fallback to buffer I/O write any more because the allocate blocks are enabled in direct I/O now.

This patch set can be applied against 3.17-rc4 branch of ocfs2 directly.

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
