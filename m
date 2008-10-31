From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:38:53 +0100
Subject: [Ocfs2-devel] [PATCH 03/27] quota: Remove bogus 'optimization' in
	check_idq() and check_bdq()
In-Reply-To: <1225435157625-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
Message-ID: <1225435157218-git-send-email-jack@suse.cz>
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
index 59e8aea..735e2c3 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1041,7 +1041,7 @@ static inline char ignore_hardlimit(struct dquot *dquot)
 static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
@@ -1073,7 +1073,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes, char *warntype)
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
 	*warntype = QUOTA_NL_NOWARN;
-	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_bhardlimit &&
-- 
1.5.2.4
