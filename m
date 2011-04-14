From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Thu, 14 Apr 2011 14:19:32 -0700
Subject: [Ocfs2-devel] [PATCH V8 8/8] ocfs2: add cleancache support
Message-ID: <20110414211932.GA27830@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com, dan.magenheimer@oracle.com, mel@csn.ul.ie, yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org

[PATCH V8 8/8] ocfs2: add cleancache support

This eighth patch of eight in this cleancache series "opts-in"
cleancache for ocfs2.  Clustered filesystems must explicitly enable
cleancache by calling cleancache_init_shared_fs anytime an instance
of the filesystem is mounted.  Ocfs2 is currently the only user of
the clustered filesystem interface but nevertheless, the cleancache
hooks in the VFS layer are sufficient for ocfs2 including the matching
cleancache_flush_fs hook which must be called on unmount.

Details and a FAQ can be found in Documentation/vm/cleancache.txt

[v8: trivial merge conflict update]
[v5: jeremy at goop.org: simplify init hook and any future fs init changes]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik Van Riel <riel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Ted Tso <tytso@mit.edu>
Cc: Nitin Gupta <ngupta@vflare.org>

---

Diffstat:
 fs/ocfs2/super.c                         |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.39-rc3/fs/ocfs2/super.c	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/fs/ocfs2/super.c	2011-04-13 17:11:45.664861458 -0600
@@ -41,6 +41,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
+#include <linux/cleancache.h>
 
 #define CREATE_TRACE_POINTS
 #include "ocfs2_trace.h"
@@ -2352,6 +2353,7 @@ static int ocfs2_initialize_super(struct
 		mlog_errno(status);
 		goto bail;
 	}
+	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
 
 bail:
 	return status;
