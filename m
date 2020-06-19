From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 19 Jun 2020 11:39:15 +0200
Subject: [Ocfs2-devel] [PATCH 1/2] fs: Add IOCB_CACHED flag for
	generic_file_read_iter
In-Reply-To: <20200619093916.1081129-1-agruenba@redhat.com>
References: <20200619093916.1081129-1-agruenba@redhat.com>
Message-ID: <20200619093916.1081129-2-agruenba@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

Add an IOCB_CACHED flag which indicates to generic_file_read_iter that
it should only regard the page cache, without triggering any filesystem
I/O for the actual request or for readahead.  With this flag, -EAGAIN is
returned when regular I/O would be triggered similar to the IOCB_NOWAIT
flag, and -ECANCELED is returned when readahead would be triggered.

This allows the caller to perform a tentative read out of the page
cache, and to retry the read if the requested pages are not cached.

Please see the next commit for what this is used for.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/fs.h |  1 +
 mm/filemap.c       | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6c4ab4dc1cd7..74eade571b1c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -315,6 +315,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_CACHED		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
diff --git a/mm/filemap.c b/mm/filemap.c
index f0ae9a6308cb..bd11f27bf6ae 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2028,7 +2028,7 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 		page = find_get_page(mapping, index);
 		if (!page) {
-			if (iocb->ki_flags & IOCB_NOWAIT)
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_CACHED))
 				goto would_block;
 			page_cache_sync_readahead(mapping,
 					ra, filp,
@@ -2038,12 +2038,17 @@ ssize_t generic_file_buffered_read(struct kiocb *iocb,
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
+			if (iocb->ki_flags & IOCB_CACHED) {
+				put_page(page);
+				error = -ECANCELED;
+				goto out;
+			}
 			page_cache_async_readahead(mapping,
 					ra, filp, page,
 					index, last_index - index);
 		}
 		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_CACHED)) {
 				put_page(page);
 				goto would_block;
 			}
@@ -2249,6 +2254,13 @@ EXPORT_SYMBOL_GPL(generic_file_buffered_read);
  *
  * This is the "read_iter()" routine for all filesystems
  * that can use the page cache directly.
+ *
+ * In the IOCB_NOWAIT flag in iocb->ki_flags indicates that -EAGAIN should be
+ * returned if completing the request would require I/O; this does not prevent
+ * readahead.  The IOCB_CACHED flag indicates that -EAGAIN should be returned
+ * as under the IOCB_NOWAIT flag, and that -ECANCELED should be returned when
+ * readhead would be triggered.
+ *
  * Return:
  * * number of bytes copied, even for partial reads
  * * negative error code if nothing was read
-- 
2.26.2
