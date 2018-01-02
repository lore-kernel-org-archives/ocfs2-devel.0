From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  2 Jan 2018 11:34:42 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs: fix
	fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
Message-ID: <20180102103520.865665-1-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Changwei Ge <ge.changwei@h3c.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Jun Piao <piaojun@huawei.com>, Fabian Frederick <fabf@skynet.be>, alex chen <alex.chen@huawei.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

The 'ret' variable is used to store the integer return value of
ocfs2_get_clusters(), as shown by this warning from modern
compilers:

fs/ocfs2/aops.c: In function 'ocfs2_range_has_holes':
fs/ocfs2/aops.c:2437:11: error: comparison of constant '0' with boolean expression is always false [-Werror=bool-compare]

Fixes: mmotm ("ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ocfs2/aops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 87562112cb5e..8aa2519a0966 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2432,10 +2432,11 @@ static bool ocfs2_range_has_holes(struct inode *inode, loff_t pos, size_t count)
 	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
 
 	while (clusters) {
-		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
-					 &extent_flags);
-		if (ret < 0) {
-			mlog_errno(ret);
+		int err = ocfs2_get_clusters(inode, cpos, &phys_cpos,
+					     &extent_len, &extent_flags);
+		if (err < 0) {
+			mlog_errno(err);
+			ret = true;
 			goto out;
 		}
 
-- 
2.9.0
