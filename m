From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  7 Jul 2008 13:26:17 -0700
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: Silence an error message in
	ocfs2_file_aio_read()
In-Reply-To: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1215462380-12975-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch silences an EINVAL error message in ocfs2_file_aio_read()
that is always due to a user error.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d4cf056..79c4ee1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2450,7 +2450,7 @@ static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 
 	ret = kapi_generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
-		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
+		mlog(0, "generic_file_aio_read returned -EINVAL\n");
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
-- 
1.5.4.3
