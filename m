From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Jul 2008 13:01:31 -0700
Subject: [Ocfs2-devel] [git patch] one more ocfs2 regression fix
Message-ID: <20080710200131.GP28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Thanks to Geoffrey Pan for reporting this and testing the fix so quickly. I
also verified this fix on my test cluster today, since things are getting
down to the wire. It's definitely 2.6.26 material.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/dlmglue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Fix flags in ocfs2_file_lock

The stack-glue merge changed the way we use flags in dlmglue in that we now
use the fs/dlm equivalents. Unfortunately, a merge error left the new flock
code only partially updated. This took a while to show up though, because
the lock level constants are actually identical between o2dlm and fs/dlm.
The *_CONVERT and *_NOQUEUE flags have different values though, which is
eventually causing a crash in flags_to_o2dlm().

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlmglue.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 394d25a..80e20d9 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1554,8 +1554,8 @@ out:
  */
 int ocfs2_file_lock(struct file *file, int ex, int trylock)
 {
-	int ret, level = ex ? LKM_EXMODE : LKM_PRMODE;
-	unsigned int lkm_flags = trylock ? LKM_NOQUEUE : 0;
+	int ret, level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
+	unsigned int lkm_flags = trylock ? DLM_LKF_NOQUEUE : 0;
 	unsigned long flags;
 	struct ocfs2_file_private *fp = file->private_data;
 	struct ocfs2_lock_res *lockres = &fp->fp_flock;
@@ -1582,7 +1582,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 		 * Get the lock at NLMODE to start - that way we
 		 * can cancel the upconvert request if need be.
 		 */
-		ret = ocfs2_lock_create(osb, lockres, LKM_NLMODE, 0);
+		ret = ocfs2_lock_create(osb, lockres, DLM_LOCK_NL, 0);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto out;
@@ -1597,7 +1597,7 @@ int ocfs2_file_lock(struct file *file, int ex, int trylock)
 	}
 
 	lockres->l_action = OCFS2_AST_CONVERT;
-	lkm_flags |= LKM_CONVERT;
+	lkm_flags |= DLM_LKF_CONVERT;
 	lockres->l_requested = level;
 	lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
 
@@ -1664,7 +1664,7 @@ void ocfs2_file_unlock(struct file *file)
 	if (!(lockres->l_flags & OCFS2_LOCK_ATTACHED))
 		return;
 
-	if (lockres->l_level == LKM_NLMODE)
+	if (lockres->l_level == DLM_LOCK_NL)
 		return;
 
 	mlog(0, "Unlock: \"%s\" flags: 0x%lx, level: %d, act: %d\n",
@@ -1678,11 +1678,11 @@ void ocfs2_file_unlock(struct file *file)
 	lockres_or_flags(lockres, OCFS2_LOCK_BLOCKED);
 	lockres->l_blocking = DLM_LOCK_EX;
 
-	gen = ocfs2_prepare_downconvert(lockres, LKM_NLMODE);
+	gen = ocfs2_prepare_downconvert(lockres, DLM_LOCK_NL);
 	lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BUSY, 0);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
-	ret = ocfs2_downconvert_lock(osb, lockres, LKM_NLMODE, 0, gen);
+	ret = ocfs2_downconvert_lock(osb, lockres, DLM_LOCK_NL, 0, gen);
 	if (ret) {
 		mlog_errno(ret);
 		return;
-- 
1.5.4.1
