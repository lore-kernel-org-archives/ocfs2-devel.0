From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 22 May 2014 22:46:44 +0200
Subject: [Ocfs2-devel] [PATCH] fs: ocfs2: move_extents.c: Fix for possible
	null pointer dereference
Message-ID: <1400791604-12094-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/move_extents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 599eb4c..6a8e3c8 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -902,11 +902,13 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct inode *inode = context->inode;
 	struct ocfs2_dinode *di;
 	struct buffer_head *di_bh = NULL;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_super *osb;
 
 	if (!inode)
 		return -ENOENT;
 
+	osb = OCFS2_SB(inode->i_sb);
+
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
 		return -EROFS;
 
-- 
1.7.10.4
