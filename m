From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri May 25 11:17:38 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 updates
Message-ID: <20070525181734.GL20632@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,
   These are all some pretty straightforward patches for 2.6.22-rc3.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c       |   11 ++++++-----
 fs/ocfs2/file.c       |   33 ++-------------------------------
 fs/ocfs2/localalloc.c |    7 ++++---
 3 files changed, 12 insertions(+), 39 deletions(-)

Christoph Hellwig:
      ocfs2: use generic_segment_checks

Mark Fasheh:
      ocfs2: trylock in ocfs2_readpage()
      ocfs2: unmap_mapping_range() in ocfs2_truncate()
      ocfs2: fix inode leak

Nate Diller:
      ocfs2: use zero_user_page

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8e7cafb..0023b31 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -222,7 +222,10 @@ static int ocfs2_readpage(struct file *f
 		goto out;
 	}
 
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	if (down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem) == 0) {
+		ret = AOP_TRUNCATED_PAGE;
+		goto out_meta_unlock;
+	}
 
 	/*
 	 * i_size might have just been updated as we grabed the meta lock.  We
@@ -235,10 +238,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		char *addr = kmap(page);
-		memset(addr, 0, PAGE_SIZE);
-		flush_dcache_page(page);
-		kunmap(page);
+		zero_user_page(page, 0, PAGE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
@@ -258,6 +258,7 @@ static int ocfs2_readpage(struct file *f
 	ocfs2_data_unlock(inode, 0);
 out_alloc:
 	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+out_meta_unlock:
 	ocfs2_meta_unlock(inode, 0);
 out:
 	if (unlock)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9395b4f..ac6c964 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -326,6 +326,7 @@ static int ocfs2_truncate_file(struct in
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno,
 		   (unsigned long long)new_i_size);
 
+	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(inode->i_mapping, new_i_size);
 
 	fe = (struct ocfs2_dinode *) di_bh->b_data;
@@ -1418,36 +1419,6 @@ out:
 	return total ? total : ret;
 }
 
-static int ocfs2_check_iovec(const struct iovec *iov, size_t *counted,
-			     unsigned long *nr_segs)
-{
-	size_t ocount;		/* original count */
-	unsigned long seg;
-
-	ocount = 0;
-	for (seg = 0; seg < *nr_segs; seg++) {
-		const struct iovec *iv = &iov[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		ocount += iv->iov_len;
-		if (unlikely((ssize_t)(ocount|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_READ, iv->iov_base, iv->iov_len))
-			continue;
-		if (seg == 0)
-			return -EFAULT;
-		*nr_segs = seg;
-		ocount -= iv->iov_len;	/* This segment is no good */
-		break;
-	}
-
-	*counted = ocount;
-	return 0;
-}
-
 static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 				    const struct iovec *iov,
 				    unsigned long nr_segs,
@@ -1470,7 +1441,7 @@ static ssize_t ocfs2_file_aio_write(stru
 	if (iocb->ki_left == 0)
 		return 0;
 
-	ret = ocfs2_check_iovec(iov, &ocount, &nr_segs);
+	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
 	if (ret)
 		return ret;
 
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 4dedd97..545f789 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -471,9 +471,6 @@ int ocfs2_reserve_local_alloc_bits(struc
 
 	mutex_lock(&local_alloc_inode->i_mutex);
 
-	ac->ac_inode = local_alloc_inode;
-	ac->ac_which = OCFS2_AC_USE_LOCAL;
-
 	if (osb->local_alloc_state != OCFS2_LA_ENABLED) {
 		status = -ENOSPC;
 		goto bail;
@@ -511,10 +508,14 @@ int ocfs2_reserve_local_alloc_bits(struc
 		}
 	}
 
+	ac->ac_inode = local_alloc_inode;
+	ac->ac_which = OCFS2_AC_USE_LOCAL;
 	get_bh(osb->local_alloc_bh);
 	ac->ac_bh = osb->local_alloc_bh;
 	status = 0;
 bail:
+	if (status < 0 && local_alloc_inode)
+		iput(local_alloc_inode);
 
 	mlog_exit(status);
 	return status;
