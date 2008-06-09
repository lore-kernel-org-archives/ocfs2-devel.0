From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2008 16:34:23 -0700
Subject: [Ocfs2-devel] [patch 1/1] ocfs2: use simple_read_from_buffer()
Message-ID: <200806092334.m59NYNlr014749@imap1.linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-use-simple_read_from_buffer fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-use-simple_read_from_buffer
+++ a/fs/ocfs2/stack_user.c
@@ -550,26 +550,17 @@ static ssize_t ocfs2_control_read(struct
 				  size_t count,
 				  loff_t *ppos)
 {
-	char *proto_string = OCFS2_CONTROL_PROTO;
-	size_t to_write = 0;
+	ssize_t ret;
 
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
-		return 0;
-
-	to_write = OCFS2_CONTROL_PROTO_LEN - *ppos;
-	if (to_write > count)
-		to_write = count;
-	if (copy_to_user(buf, proto_string + *ppos, to_write))
-		return -EFAULT;
-
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
_
