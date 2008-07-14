From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:38 -0700
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: Silence an error message in
	ocfs2_file_aio_read()
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

This patch silences an EINVAL error message in ocfs2_file_aio_read()
that is always due to a user error.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 57e0d30..e8514e8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2202,7 +2202,7 @@ static ssize_t ocfs2_file_aio_read(struct kiocb *iocb,
 
 	ret = generic_file_aio_read(iocb, iov, nr_segs, iocb->ki_pos);
 	if (ret == -EINVAL)
-		mlog(ML_ERROR, "generic_file_aio_read returned -EINVAL\n");
+		mlog(0, "generic_file_aio_read returned -EINVAL\n");
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(filp->f_flags & O_DIRECT));
-- 
1.5.4.1
