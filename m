From: Christoph Hellwig <hch@lst.de>
Date: Fri May 18 04:13:05 2007
Subject: [Ocfs2-devel] [PATCH] ocfs: use generic_segment_checks
Message-ID: <20070518111239.GA26955@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ocfs2/file.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/file.c	2007-05-18 12:10:10.000000000 +0200
+++ linux-2.6/fs/ocfs2/file.c	2007-05-18 12:11:01.000000000 +0200
@@ -1418,36 +1418,6 @@ out:
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
@@ -1470,7 +1440,7 @@ static ssize_t ocfs2_file_aio_write(stru
 	if (iocb->ki_left == 0)
 		return 0;
 
-	ret = ocfs2_check_iovec(iov, &ocount, &nr_segs);
+	ret = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
 	if (ret)
 		return ret;
 
