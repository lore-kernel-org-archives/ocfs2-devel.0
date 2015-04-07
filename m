From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 07 Apr 2015 14:55:59 -0700
Subject: [Ocfs2-devel] [patch 5/9] ocfs2: clear the rest of the buffers on
	error
Message-ID: <5524526f.kgDXDACeZXa2du4P%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: clear the rest of the buffers on error

In case a validation fails, clear the rest of the buffers and return the
error to the calling function.

This also facilitates bubbling up the error originating from ocfs2_error
to calling functions.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/buffer_head_io.c~clear-the-rest-of-the-buffers-on-error fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~clear-the-rest-of-the-buffers-on-error
+++ a/fs/ocfs2/buffer_head_io.c
@@ -316,6 +316,12 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		bh = bhs[i];
 
 		if (!(flags & OCFS2_BH_READAHEAD)) {
+			if (status) {
+				/* Clear the rest of the buffers on error */
+				put_bh(bh);
+				bhs[i] = NULL;
+				continue;
+			}
 			/* We know this can't have changed as we hold the
 			 * owner sem. Avoid doing any work on the bh if the
 			 * journal has it. */
_
