From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Tue Mar  9 12:40:10 2004
Subject: [Ocfs2-devel] Bug in error handling
Message-ID: <404E0F78.4020206@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have encountered on my system a bug when OCFS2 tries to do a journal_wipe.

At the time that it does the call it gets back an error of -22.

The problem is that it seems to leave stuff in an inconsistent state when it exits out of the functions that have called it.  So later on bad things happen :(

This diff simulates the error that I received.  I am trying to figure out what is the stuff that has been partially initialized when this gets called but I am having a bit of difficulty and tracking it all down :(

John


Index: journal.c
===================================================================
--- journal.c	(revision 766)
+++ journal.c	(working copy)
@@ -1261,8 +1261,11 @@
  	if (!journal)
  		BUG();

-	status = journal_wipe(journal->k_journal, full);
+// FIXME: Simulate BUG
+//	status = journal_wipe(journal->k_journal, full);
+	status = -22;

+
  	LOG_EXIT_STATUS(status);
  	return(status);
  }
