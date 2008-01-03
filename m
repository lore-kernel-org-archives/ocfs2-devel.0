From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu Jan  3 11:22:08 2008
Subject: [Ocfs2-devel] OCFS2 1.4 Repository Base (3rd attempt)
Message-ID: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This has all the changes requested by Joel. If you have been reviewing
the patches in the last drop, note that only 5 patches have changed since
that drop. The list of changed patches follows:

[PATCH 06/30] ocfs2: Include do_sync_mapping_range() from mainline
Remove #ifdef from alloc.c

[PATCH 09/30] ocfs2: Define enum umh_wait
Rename kapi header

[PATCH 13/30] ocfs2: Define FS_RENAME_DOES_D_MOVE
Rename kapi header

[PATCH 18/30] ocfs2: Handle the removal of struct subsystem
Reworked to reduce changes in fs code.

[PATCH 27/30] ocfs2: Handle missing vectorized fileops aio_read() and aio_write()
Changes (from file.c) moved to a kapi header. Lot cleaner.

Sunil
