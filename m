From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:07:56 +0200
Subject: [Ocfs2-devel] [PATCH 03/29] quota: Remove bogus 'optimization' in
	check_idq() and check_bdq()
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861022940-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Checks like <= 0 for an unsigned type do not make much sence. The value
could be only 0 and that does not happen often enough for the check
to be worth it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 413e71d..9eda830 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1039,7 +1039,7 @@ static inline char ignore_hardlimit(struct dquot *dquot)
 static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
@@ -1071,7 +1071,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_bhardlimit &&
-- 
1.5.2.4
