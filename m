From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:37 -0700
Subject: [Ocfs2-devel] [PATCH 04/17] ocfs2: use simple_read_from_buffer()
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-5-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Akinobu Mita <akinobu.mita@gmail.com>, Andrew Morton <akpm@linux-foundation.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/stack_user.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index c021280..24e0b19 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -549,26 +549,17 @@ static ssize_t ocfs2_control_read(struct file *file,
 				  size_t count,
 				  loff_t *ppos)
 {
-	char *proto_string = OCFS2_CONTROL_PROTO;
-	size_t to_write = 0;
-
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
-		return 0;
-
-	to_write = OCFS2_CONTROL_PROTO_LEN - *ppos;
-	if (to_write > count)
-		to_write = count;
-	if (copy_to_user(buf, proto_string + *ppos, to_write))
-		return -EFAULT;
+	ssize_t ret;
 
-	*ppos += to_write;
+	ret = simple_read_from_buffer(buf, count, ppos,
+			OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN);
 
 	/* Have we read the whole protocol list? */
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
+	if (ret > 0 && *ppos >= OCFS2_CONTROL_PROTO_LEN)
 		ocfs2_control_set_handshake_state(file,
 						  OCFS2_CONTROL_HANDSHAKE_READ);
 
-	return to_write;
+	return ret;
 }
 
 static int ocfs2_control_release(struct inode *inode, struct file *file)
-- 
1.5.4.1
