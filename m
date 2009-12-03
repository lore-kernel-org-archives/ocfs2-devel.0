From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  3 Dec 2009 11:18:12 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Incorrect address of pos passed to
	__generic_file_aio_read()
Message-ID: <1259867892-1635-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

__generic_file_aio_read() was being passed as incorrect address for pos
leading to a run-away read.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 kapi-compat/include/aiovec.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kapi-compat/include/aiovec.h b/kapi-compat/include/aiovec.h
index a10d5b5..a8896f1 100644
--- a/kapi-compat/include/aiovec.h
+++ b/kapi-compat/include/aiovec.h
@@ -13,7 +13,7 @@ static ssize_t kapi_generic_file_aio_read(struct kiocb *iocb,
 {
 	BUG_ON(iocb->ki_pos != pos);
 
-	return __generic_file_aio_read(iocb, iov, nr_segs, &pos);
+	return __generic_file_aio_read(iocb, iov, nr_segs, &iocb->ki_pos);
 }
 
 static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
-- 
1.5.6.5
