From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 26 Jan 2010 16:00:06 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] du_enhancement: add the shared extents
	and the footprint statistics support v1
In-Reply-To: <>
References: <>
Message-ID: <1264492809-13848-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

brief introduction:

the following patch sets add a new feature to displapy the shared extents size per file as well as the
overall footprint statistics for du command.

It using rbtree to track the splitted extents info instead of the clusters or physical blocks to save
the memory in case of the file size is too large(TB, etc).

the current extent splitting algorithem is based on Tao's idea, thanks a lot!

use '--shared-size' or '-E' as the command line trigger, with this option,
du print out the shared extents in parens for each file if its resides filesystem
support fiemap and the file is reflinked.

use '--fxattr' or '--fsync' or both of them to work combine with '--shared-size' for the extra fiemap control,
it will print warning message on the console in case of the filesystem do not support the corresponding fiemap flags.

Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
---
 gnulib |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/gnulib b/gnulib
index 8fc05d0..4b93a25 160000
--- a/gnulib
+++ b/gnulib
@@ -1 +1 @@
-Subproject commit 8fc05d032b3f9a9d068613ab5ee297b4e7d5a08a
+Subproject commit 4b93a2579fb567b9fbbeb24439770d814dac95cd
-- 
1.5.4.3
