From: Himangi Saraogi <himangi774@gmail.com>
Date: Mon, 28 Jul 2014 15:26:42 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: delete double assignment
Message-ID: <20140728152632.GA2926@himangi-Dell>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr

Delete successive assignments to the same location. The two assignments are
simply identical.

A simplified version of Coccinelle semantic match that finds this problem is as
follows:

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Should the fist assignment be initializing the pv_minor field?
 fs/ocfs2/stack_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 13a8537..4bcbb9b 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -591,7 +591,6 @@ static int ocfs2_control_release(struct inode *inode, struct file *file)
 		 */
 		ocfs2_control_this_node = -1;
 		running_proto.pv_major = 0;
-		running_proto.pv_major = 0;
 	}
 
 out:
-- 
1.9.1
