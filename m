From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar  3 15:54:32 2004
Subject: [Ocfs2-devel] [PATCH]check return from ocfs_journal_wipe()
Message-ID: <200403032154.i23Ls9kU018323@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I managed to get into a state on my 2.6 build where ocfs_journal_wipe()
failed, and then because we were not checking the return status of the
the function, the journal_load() in ocfs_journal_load() called BUG.

Here is a quick patch that should catch such a problem by bailing
when an error is detected.

    --rusty

Index: src/osb.c
===================================================================
--- src/osb.c	(revision 751)
+++ src/osb.c	(working copy)
@@ -415,11 +415,16 @@
 	/* If the journal was unmounted cleanly then we don't want to
 	 * recover anything. Otherwise, journal_load will do that
 	 * dirty work for us :) */
-	if (!mounted)
-		ocfs_journal_wipe(&osb->journal, 0);
-	else
+	if (!mounted) {		
+		status = ocfs_journal_wipe(&osb->journal, 0);
+		if (status < 0) {
+			LOG_ERROR_STATUS(status);
+			goto finally;
+		}
+	} else {
 		printk(KERN_NOTICE "ocfs2: File system was not unmounted "
 		       "cleanly, recovering volume.\n");
+	}
 
 	/* will play back anything left in the journal. */
 	ocfs_journal_load(&osb->journal);
