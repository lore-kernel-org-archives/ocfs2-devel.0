From: Julia Lawall <julia@diku.dk>
Date: Mon, 24 Mar 2008 19:09:15 +0100 (CET)
Subject: [Ocfs2-devel] [PATCH 2/5] fs/ocfs2/aops.c: test for IS_ERR rather
	than 0
Message-ID: <Pine.LNX.4.64.0803241908490.32740@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function ocfs2_start_trans always returns either a valid pointer or a
value made with ERR_PTR, so its result should be tested with IS_ERR, not
with a test for 0.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = ocfs2_start_trans(...)
... when != E = E1
if at p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if at p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if at p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 fs/ocfs2/aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c	2008-03-24 17:50:26.000000000 +0100
+++ b/fs/ocfs2/aops.c	2008-03-24 17:52:02.000000000 +0100
@@ -467,11 +467,11 @@ handle_t *ocfs2_start_walk_page_trans(st
 							 unsigned to)
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	int ret = 0;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (!handle) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -487,7 +487,7 @@ handle_t *ocfs2_start_walk_page_trans(st
 	}
 out:
 	if (ret) {
-		if (handle)
+		if (!IS_ERR(handle))
 			ocfs2_commit_trans(osb, handle);
 		handle = ERR_PTR(ret);
 	}
