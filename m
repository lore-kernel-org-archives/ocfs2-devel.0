From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Thu Mar  4 18:38:35 2004
Subject: [Ocfs2-devel] RFE: Change #include usage
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A569AD@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I want to make a suggestion that we change from the usage of:

#include <ocfs.h>

To:

#include "inc/ocfs.h"

This should make for cleaner Makefiles that don't need to add a -I flag
to add the inc/ directory.

Any comments on this?

Enclosed please find a patch which does this.

John

-------------- next part --------------
A non-text attachment was scrubbed...
Name: include-fix.diff
Type: application/octet-stream
Size: 8257 bytes
Desc: include-fix.diff
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040304/cb9d3e51/include-fix-0001.obj
