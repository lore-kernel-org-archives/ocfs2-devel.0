From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 19 Jun 2020 11:39:16 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] gfs2: Rework read and page fault locking
In-Reply-To: <20200619093916.1081129-1-agruenba@redhat.com>
References: <20200619093916.1081129-1-agruenba@redhat.com>
Message-ID: <20200619093916.1081129-3-agruenba@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

The cache consistency model of filesystems like gfs2 is such that if
data is found in the page cache, the data is up to date and can be used
without taking any filesystem locks.  If a page is not cached,
filesystem locks must be taken before populating the page cache.

Thus far,  gfs2 has taken the filesystem locks inside the ->readpage and
->readpages address space operations.  This was already causing lock
ordering problems, but commit d4388340ae0b ("fs: convert mpage_readpages
to mpage_readahead") made things worse: the ->readahead operation is
called with the pages to readahead locked, so grabbing the inode's glock
can now deadlock with processes which are holding the inode glock while
trying to lock the same pages.

Fix this by taking the inode glock in the ->read_iter file and ->fault
vm operations.  To avoid taking the inode glock when the data is already
cached, the ->read_iter file operation first tries to read the data with
the IOCB_CACHED flag set.  If that fails, the inode glock is locked and
the operation is repeated without the IOCB_CACHED flag.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/aops.c | 27 ++--------------------
 fs/gfs2/file.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 27 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 72c9560f4467..73c2fe768a3f 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -513,26 +513,10 @@ static int __gfs2_readpage(void *file, struct page *page)
 
 static int gfs2_readpage(struct file *file, struct page *page)
 {
-	struct address_space *mapping = page->mapping;
-	struct gfs2_inode *ip = GFS2_I(mapping->host);
-	struct gfs2_holder gh;
 	int error;
 
-	unlock_page(page);
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	error = gfs2_glock_nq(&gh);
-	if (unlikely(error))
-		goto out;
-	error = AOP_TRUNCATED_PAGE;
-	lock_page(page);
-	if (page->mapping == mapping && !PageUptodate(page))
-		error = __gfs2_readpage(file, page);
-	else
-		unlock_page(page);
-	gfs2_glock_dq(&gh);
-out:
-	gfs2_holder_uninit(&gh);
-	if (error && error != AOP_TRUNCATED_PAGE)
+	error = __gfs2_readpage(file, page);
+	if (error)
 		lock_page(page);
 	return error;
 }
@@ -598,16 +582,9 @@ static void gfs2_readahead(struct readahead_control *rac)
 {
 	struct inode *inode = rac->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder gh;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
-	if (gfs2_glock_nq(&gh))
-		goto out_uninit;
 	if (!gfs2_is_stuffed(ip))
 		mpage_readahead(rac, gfs2_block_map);
-	gfs2_glock_dq(&gh);
-out_uninit:
-	gfs2_holder_uninit(&gh);
 }
 
 /**
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index fe305e4bfd37..f729b0ff2a3c 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -558,8 +558,29 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vmf)
 	return block_page_mkwrite_return(ret);
 }
 
+static vm_fault_t gfs2_fault(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	vm_fault_t ret;
+	int err;
+
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	err = gfs2_glock_nq(&gh);
+	if (err) {
+		ret = block_page_mkwrite_return(err);
+		goto out_uninit;
+	}
+	ret = filemap_fault(vmf);
+	gfs2_glock_dq(&gh);
+out_uninit:
+	gfs2_holder_uninit(&gh);
+	return ret;
+}
+
 static const struct vm_operations_struct gfs2_vm_ops = {
-	.fault = filemap_fault,
+	.fault = gfs2_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = gfs2_page_mkwrite,
 };
@@ -824,15 +845,51 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 
 static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
+	struct gfs2_inode *ip;
+	struct gfs2_holder gh;
+	size_t written = 0;
 	ssize_t ret;
 
+	gfs2_holder_mark_uninitialized(&gh);
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = gfs2_file_direct_read(iocb, to);
 		if (likely(ret != -ENOTBLK))
 			return ret;
 		iocb->ki_flags &= ~IOCB_DIRECT;
 	}
-	return generic_file_read_iter(iocb, to);
+	iocb->ki_flags |= IOCB_CACHED;
+	ret = generic_file_read_iter(iocb, to);
+	iocb->ki_flags &= ~IOCB_CACHED;
+	if (ret >= 0) {
+		if (!iov_iter_count(to))
+			return ret;
+		written = ret;
+	} else {
+		switch(ret) {
+		case -EAGAIN:
+			if (iocb->ki_flags & IOCB_NOWAIT)
+				return ret;
+			break;
+		case -ECANCELED:
+			break;
+		default:
+			return ret;
+		}
+	}
+	ip = GFS2_I(iocb->ki_filp->f_mapping->host);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret)
+		goto out_uninit;
+	ret = generic_file_read_iter(iocb, to);
+	if (ret > 0)
+		written += ret;
+	if (gfs2_holder_initialized(&gh))
+		gfs2_glock_dq(&gh);
+out_uninit:
+	if (gfs2_holder_initialized(&gh))
+		gfs2_holder_uninit(&gh);
+	return written ? written : ret;
 }
 
 /**
-- 
2.26.2
