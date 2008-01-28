From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jan 28 19:34:18 2008
Subject: [Ocfs2-devel] [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129033307.GE23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>

Greg's commit c60b71787982cefcf9fa09aa281fa8c4c685d557 inadvertantly broke
Ocfs2 userspace ABI, so I have a rather high priority single line patch from
Joel to fix things up for you to pull. A copy of the patch is attached to
the bottom of this e-mail. Embarassingly enough, I missed this while acking
the patch late last week :(

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Joel Becker (1):
      ocfs2: Fix userspace ABI breakage in sysfs


From: Joel Becker <Joel.Becker@oracle.com>

ocfs2: Fix userspace ABI breakage in sysfs

The userspace ABI of ocfs2's internal cluster stack (o2cb) was broken by
commit c60b71787982cefcf9fa09aa281fa8c4c685d557 "kset: convert ocfs2 to
use kset_create".  Specifically, the '/sys/o2cb' kset was moved to
'/sys/fs/o2cb'.  This breaks all ocfs2 tools and renders the
filesystem unmountable.

This fix moves '/sys/o2cb' back where it belongs.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index a4b0773..0c095ce 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -64,7 +64,7 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
+	o2cb_kset = kset_create_and_add("o2cb", NULL, NULL);
 	if (!o2cb_kset)
 		return -ENOMEM;
 
-- 
1.5.3.6
