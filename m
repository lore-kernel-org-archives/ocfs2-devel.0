From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Sat, 11 Jul 2009 10:57:27 -0500
Subject: [Ocfs2-devel] Initialize count in aio_write before
	generic_write_checks
Message-ID: <20090711155727.GA11989@baloo.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

generic_write_checks() expects count to be initialized to the size of
the write.
Writes to files open with O_DIRECT|O_LARGEFILE write 0 bytes because
count in uninitialized.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a5887df..5b9c8af 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1841,6 +1841,7 @@ relock:
 		if (ret)
 			goto out_dio;
 
+		count = ocount;
 		ret = generic_write_checks(file, ppos, &count,
 					   S_ISBLK(inode->i_mode));
 		if (ret)

-- 
Goldwyn
