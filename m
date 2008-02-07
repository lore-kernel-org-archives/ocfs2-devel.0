From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Feb  7 14:29:50 2008
Subject: [Ocfs2-devel] Re: [git patches] ocfs2 update
In-Reply-To: <20080207213714.GR22671@ca-server1.us.oracle.com>
References: <20080207200944.GQ22671@ca-server1.us.oracle.com>
	<20080207124745.4868e108.akpm@linux-foundation.org>
	<20080207213714.GR22671@ca-server1.us.oracle.com>
Message-ID: <20080207222928.GB22744@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Feb 07, 2008 at 01:37:15PM -0800, Mark Fasheh wrote:
> On Thu, Feb 07, 2008 at 12:47:45PM -0800, Andrew Morton wrote:
> > On Thu, 7 Feb 2008 12:09:44 -0800
> > Mark Fasheh <mark.fasheh@oracle.com> wrote:
> > 
> > > +static int dlm_protocol_compare(struct dlm_protocol_version *existing,
> > > +				struct dlm_protocol_version *request)
> > 
> > It's somewhat obnoxious that what appears to be a straightforward
> > compare-two-things-and-return-result function will actually modify one of
> > the things which it is allegedly comparing.
> 
> Yeah, a better name would probably help with readability. Joel, how about
> dlm_protocol_compare_and_set()?

	Even better is to move the update outside the function.  What do
we think of the following?

From d667a08d73cd6659219d21cc57f67882f46e42d1 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 7 Feb 2008 14:25:11 -0800
Subject: [PATCH] ocfs2: Clean up locking protocol negotiation.

The comparison functions for protocol negotiation (introduced in commit
d24fbcda0c4988322949df3d759f1cfb32b32953) were confusing.
Separate out the comparison and value update parts.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlm/dlmdomain.c |  102 ++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 638d2eb..de802a7 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -144,8 +144,6 @@ static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
 static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
-static int dlm_protocol_compare(struct dlm_protocol_version *existing,
-				struct dlm_protocol_version *request);
 
 static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm);
 
@@ -681,36 +679,48 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
 }
 EXPORT_SYMBOL_GPL(dlm_unregister_domain);
 
+/*
+ * Compare a requested locking protocol version against the current one.
+ *
+ * If the major numbers are different, they are incompatible.
+ * If the current minor is greater than the request, they are incompatible.
+ * If the current minor is less than or equal to the request, they are
+ * compatible, and the requester should run at the current minor version.
+ */
+static int dlm_protocol_compatible(struct dlm_protocol_version *existing,
+				   struct dlm_protocol_version *request)
+{
+	if (existing->pv_major != request->pv_major)
+		return 0;
+
+	if (existing->pv_minor > request->pv_minor)
+		return 0;
+
+	return 1;
+}
+
 static int dlm_query_join_proto_check(char *proto_type, int node,
 				      struct dlm_protocol_version *ours,
 				      struct dlm_protocol_version *request)
 {
-	int rc;
-	struct dlm_protocol_version proto = *request;
+	int compatible = dlm_protocol_compatible(ours, request);
 
-	if (!dlm_protocol_compare(ours, &proto)) {
+	if (compatible)
 		mlog(0,
 		     "node %u wanted to join with %s locking protocol "
 		     "%u.%u, we respond with %u.%u\n",
 		     node, proto_type,
-		     request->pv_major,
-		     request->pv_minor,
-		     proto.pv_major, proto.pv_minor);
-		request->pv_minor = proto.pv_minor;
-		rc = 0;
-	} else {
+		     request->pv_major, request->pv_minor,
+		     ours->pv_major, ours->pv_minor);
+	else
 		mlog(ML_NOTICE,
 		     "Node %u wanted to join with %s locking "
 		     "protocol %u.%u, but we have %u.%u, disallowing\n",
 		     node, proto_type,
-		     request->pv_major,
-		     request->pv_minor,
-		     ours->pv_major,
-		     ours->pv_minor);
-		rc = 1;
-	}
+		     request->pv_major, request->pv_minor,
+		     ours->pv_major, ours->pv_minor);
 
-	return rc;
+	return compatible;
 }
 
 static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -806,21 +816,23 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 			/* Make sure we speak compatible locking protocols.  */
 			if (dlm_query_join_proto_check("DLM", bit,
 						       &dlm->dlm_locking_proto,
-						       &query->dlm_proto)) {
-				response.packet.code =
-					JOIN_PROTOCOL_MISMATCH;
-			} else if (dlm_query_join_proto_check("fs", bit,
-							      &dlm->fs_locking_proto,
-							      &query->fs_proto)) {
-				response.packet.code =
-					JOIN_PROTOCOL_MISMATCH;
-			} else {
+						       &query->dlm_proto) &&
+			    dlm_query_join_proto_check("fs", bit,
+						       &dlm->fs_locking_proto,
+						       &query->fs_proto)) {
+				/*
+				 * We're compatible, return our
+				 * minor number
+				 */
 				response.packet.dlm_minor =
-					query->dlm_proto.pv_minor;
+					dlm->dlm_locking_proto.pv_minor;
 				response.packet.fs_minor =
-					query->fs_proto.pv_minor;
+					dlm->fs_locking_proto.pv_minor;
 				response.packet.code = JOIN_OK;
 				__dlm_set_joining_node(dlm, query->node_idx);
+			} else {
+				response.packet.code =
+					JOIN_PROTOCOL_MISMATCH;
 			}
 		}
 
@@ -1546,29 +1558,6 @@ leave:
 }
 
 /*
- * Compare a requested locking protocol version against the current one.
- *
- * If the major numbers are different, they are incompatible.
- * If the current minor is greater than the request, they are incompatible.
- * If the current minor is less than or equal to the request, they are
- * compatible, and the requester should run at the current minor version.
- */
-static int dlm_protocol_compare(struct dlm_protocol_version *existing,
-				struct dlm_protocol_version *request)
-{
-	if (existing->pv_major != request->pv_major)
-		return 1;
-
-	if (existing->pv_minor > request->pv_minor)
-		return 1;
-
-	if (existing->pv_minor < request->pv_minor)
-		request->pv_minor = existing->pv_minor;
-
-	return 0;
-}
-
-/*
  * dlm_register_domain: one-time setup per "domain".
  *
  * The filesystem passes in the requested locking version via proto.
@@ -1620,7 +1609,14 @@ retry:
 			goto retry;
 		}
 
-		if (dlm_protocol_compare(&dlm->fs_locking_proto, fs_proto)) {
+		if (dlm_protocol_compatible(&dlm->fs_locking_proto, fs_proto)) {
+			/*
+			 * We're compatible, and we run at the minor
+			 * number negotiated
+			 */
+			fs_proto->pv_minor =
+				dlm->fs_locking_proto.pv_minor;
+		} else {
 			mlog(ML_ERROR,
 			     "Requested locking protocol version is not "
 			     "compatible with already registered domain "
-- 
1.5.2.2


-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
