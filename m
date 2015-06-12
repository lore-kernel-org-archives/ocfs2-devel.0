From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 12 Jun 2015 18:59:03 +0200
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: use swap() in
	dx_leaf_sort_swap()
Message-ID: <1434128344-10474-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/dir.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index a9513ff..ffecf89 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3533,13 +3533,10 @@ static void dx_leaf_sort_swap(void *a, void *b, int size)
 {
 	struct ocfs2_dx_entry *entry1 = a;
 	struct ocfs2_dx_entry *entry2 = b;
-	struct ocfs2_dx_entry tmp;
 
 	BUG_ON(size != sizeof(*entry1));
 
-	tmp = *entry1;
-	*entry1 = *entry2;
-	*entry2 = tmp;
+	swap(*entry1, *entry2);
 }
 
 static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
-- 
2.4.2
