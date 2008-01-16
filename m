From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:10 2008
Subject: [Ocfs2-devel] [PATCH 18/20] ocfs2: Allow for debugging of
	transaction extends
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 0879c584ffcccd50a8d0f72cab3a51702613f901
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 3 Dec 2007 16:42:19 -0800

The nastiest cases of transaction extends are also the rarest. We can expose
them more quickly at the expense of performance by going straight to the
journal_restart() in ocfs2_extend_trans(). Wrap things in OCFS2_DEBUG_FS so
that we only do this when "expensive debugging" is turned on.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/journal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 909a344..9988abc 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -193,11 +193,15 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 
 	mlog(0, "Trying to extend transaction by %d blocks\n", nblocks);
 
+#ifdef OCFS2_DEBUG_FS
+	status = 1;
+#else
 	status = journal_extend(handle, nblocks);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
+#endif
 
 	if (status > 0) {
 		mlog(0, "journal_extend failed, trying journal_restart\n");
-- 
1.5.3.4
