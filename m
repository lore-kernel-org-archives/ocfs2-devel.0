From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue, 24 Jun 2008 14:34:39 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: error handling for
	ocfs2_setup_io_locks()
Message-ID: <4860957F.7000508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

in case of no-memory, ocfs2_buffer_lock_ctxt_insert may returns -ENOMEM;
then there may leave an unexpected up_read() on mm->mmap_sem.

this patch fixes that problem.

this patch is based on 1.2 svn.
since this code is removed in kernel mainline source, no patch for mainline.

Signed-off-by Wenwen Wang <wen.gang.wang@oracle.com>
---
 mmap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: mmap.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/7a9a9b4b/attachment.pl 
