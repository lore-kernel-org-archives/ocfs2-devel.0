From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Thu, 22 Jul 2010 15:04:16 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] JBD2: Allow feature checks before journal
	recovery
References: <874ofr2myq.fsf@patl.com>
Message-ID: <8739vb2mxr.fsf@patl.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org

Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
confirm that its journal supports 64-bit offsets.  In particular, we
need to check the journal's feature bits before recovering the journal.

This is not possible with JBD2 at present, because the journal
superblock (where the feature bits reside) is not loaded from disk until
the journal is recovered.

This patch loads the journal superblock in
jbd2_journal_check_used_features() if it has not already been loaded,
allowing us to check the feature bits before journal recovery.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bc2ff59..5cfd8d4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1365,6 +1365,10 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
 
 	if (!compat && !ro && !incompat)
 		return 1;
+	/* Load journal superblock if it is not loaded yet. */
+	if (journal->j_format_version == 0 &&
+	    journal_get_superblock(journal) != 0)
+		return 0;
 	if (journal->j_format_version == 1)
 		return 0;
 
