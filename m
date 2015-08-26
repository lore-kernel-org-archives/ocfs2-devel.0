From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 26 Aug 2015 15:12:28 -0700
Subject: [Ocfs2-devel] [patch 25/28] ocfs2: update filecheck copyright
Message-ID: <55de39cc.mJ5u4msJMD4jFdeF%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: update filecheck copyright

Besides inode block online check, add file extent block online check this
time, we will add more kinds of meta block online check/repair in the
future.


This patch (of 4):

Update filecheck copyright to the right time/contributor

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    2 +-
 fs/ocfs2/filecheck.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-update-filecheck-copyright fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-update-filecheck-copyright
+++ a/fs/ocfs2/filecheck.c
@@ -5,7 +5,7 @@
  *
  * Code which implements online file check.
  *
- * Copyright (C) 2007, 2009 Oracle.  All rights reserved.
+ * Copyright (C) 2015 Novell.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
diff -puN fs/ocfs2/filecheck.h~ocfs2-update-filecheck-copyright fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-update-filecheck-copyright
+++ a/fs/ocfs2/filecheck.h
@@ -5,7 +5,7 @@
  *
  * Online file check.
  *
- * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2015 Novell.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
_
