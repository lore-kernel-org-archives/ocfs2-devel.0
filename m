From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 15 Aug 2012 02:11:30 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't spam on -EDQUOT.
In-Reply-To: <20120815090456.GN31083@dhcp-172-17-9-228.mtv.corp.google.com>
References: <AF11BCE64D6647C0B14576AA905DF52A@SERWER>
	<20120815090456.GN31083@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <20120815091130.GO31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marek =?iso-8859-1?Q?Kr=F3likowski?= <admin@wset.edu.pl>, ocfs2-devel@oss.oracle.com
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org

EDQUOT is a user-visible error, not a logic problem.  Teach mlog_errno()
to ignore it like it ignores -ENOSPC, etc.

Signed-off-by: Joel Becker <jlbec@evilplan.org>
Cc: Jan Kara <jack@suse.cz>
Reported-by: Marek Kr?likowski <admin@wset.edu.pl>
---
 fs/ocfs2/cluster/masklog.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index baa2b9e..2260fb9 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -199,7 +199,8 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 #define mlog_errno(st) do {						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
+	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
-- 
1.7.7.3
