From: Julia Lawall <julia@diku.dk>
Date: Wed, 26 May 2010 15:59:02 -0000
Subject: [Ocfs2-devel] [PATCH 15/17] fs/ocfs2/dlm: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  Unlock as in the other code
that leads to the leave label.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ocfs2/dlm/dlmdomain.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 6b5a492..2ccad86 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1709,6 +1709,7 @@ retry:
 		}
 
 		if (dlm_protocol_compare(&dlm->fs_locking_proto, fs_proto)) {
+			spin_unlock(&dlm_domain_lock);
 			mlog(ML_ERROR,
 			     "Requested locking protocol version is not "
 			     "compatible with already registered domain "
