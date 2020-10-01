From: Mauricio Faria de Oliveira <mfo@canonical.com>
Date: Thu,  1 Oct 2020 19:44:17 -0300
Subject: [Ocfs2-devel] [PATCH] ocfs2: ratelimit the 'max lookup times
	reached' notice
Message-ID: <20201001224417.478263-1-mfo@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>

Running stress-ng on ocfs2 completely fills the kernel log with
'max lookup times reached, filesystem may have nested directories.'

Let's ratelimit this message as done with others in the code.

Test-case:

  # mkfs.ocfs2 --mount local $DEV
  # mount $DEV $MNT
  # cd $MNT

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  # dmesg | grep -c 'max lookup times reached'

Before:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [11116] successful run completed in 3.03s

  # dmesg | grep -c 'max lookup times reached'
  967

After:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [739] successful run completed in 0.96s

  # dmesg | grep -c 'max lookup times reached'
  10

  # dmesg
  [  259.086086] ocfs2_check_if_ancestor: 1990 callbacks suppressed
  [  259.086092] (stress-ng-dirde,740,1):ocfs2_check_if_ancestor:1091 max lookup times reached, filesystem may have nested directories, src inode: 18007, dest inode: 17940.
  ...

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
---
 fs/ocfs2/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 3c908e9416af..0043eddabdb8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1095,8 +1095,8 @@ static int ocfs2_check_if_ancestor(struct ocfs2_super *osb,
 		child_inode_no = parent_inode_no;
 
 		if (++i >= MAX_LOOKUP_TIMES) {
-			mlog(ML_NOTICE, "max lookup times reached, filesystem "
-					"may have nested directories, "
+			mlog_ratelimited(ML_NOTICE, "max lookup times reached, "
+					"filesystem may have nested directories, "
 					"src inode: %llu, dest inode: %llu.\n",
 					(unsigned long long)src_inode_no,
 					(unsigned long long)dest_inode_no);
-- 
2.17.1
