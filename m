From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 22 Aug 2008 14:30:10 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Increment the reference count of an
	already-active	stack.
Message-ID: <20080822213010.GC7773@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@kernel.org

The ocfs2_stack_driver_request() function failed to increment the
refcount of an already-active stack.  It only did the increment on the
first reference.  Whoops.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/stackglue.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 10e149a..07f348b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -97,13 +97,14 @@ static int ocfs2_stack_driver_request(const char *stack_name,
 		goto out;
 	}
 
-	/* Ok, the stack is pinned */
-	p->sp_count++;
 	active_stack = p;
-
 	rc = 0;
 
 out:
+	/* If we found it, pin it */
+	if (!rc)
+		active_stack->sp_count++;
+
 	spin_unlock(&ocfs2_stack_lock);
 	return rc;
 }
-- 
1.5.6.3


-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
