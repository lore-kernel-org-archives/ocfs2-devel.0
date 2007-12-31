From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Dec 31 14:25:59 2007
Subject: [Ocfs2-devel] ocfs2-1.4: A new beginning - 2nd attempt
Message-ID: <1199139862-31452-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These patches have incorporated almost all of Joel's comments. I still need
to discuss 0018-ocfs2-Handle-the-removal-of-struct-subsystem.patch with him.

Joel, I added your sign-offs even in patches that required changes (that is
after making the change.) I did so for easier tracking. Let me know if you
have any other comments.

Thanks
Sunil

===================================================================
These patches allow ocfs2 pulled from mainline commit
e7b34019606ab1dd06196635e931b0c302799228 to build on 2.6.18.
I am not emailing the first set of patches that essentially copy
the source from the mainline and copy the build infrastructure files
from ocfs2-1.2.

The rationale behind this series of patches is not only to allow
it to build with el5 (2.6.18) but to do so with minimal code changes.
The latter will help us later when we have to backport new patches
from mainline.

Please review the patches concentrating on the tricks played to
allow one to build the same tree against both 2.6.18 and mainline.
=====================================================================
