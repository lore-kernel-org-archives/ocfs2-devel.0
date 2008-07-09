From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 8 Jul 2008 21:17:48 -0700
Subject: [Ocfs2-devel] [git patch] ocfs2 fix for 2.6.26
Message-ID: <20080709041748.GG28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

This single patch fixes an Ocfs2 regression introduced during the merge
window.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Sunil Mushran (1):
      ocfs2/dlm: Fixes oops in dlm_new_lockres()

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index efc015c..44f87ca 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -606,7 +606,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
+	spin_lock(&dlm->spinlock);
 	list_add_tail(&res->tracking, &dlm->tracking_list);
+	spin_unlock(&dlm->spinlock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
 
