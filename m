From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:23:24 -0800
Subject: [Ocfs2-devel] ocfs patches for review
Message-ID: <20171130142324.a59ac0e6cec0ec85d0003cac@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


I'm sitting on a bunch of ocfs2 patches which need additional review,
please.  I'll send them out now.  I have a couple of notes-to-self:


Subject: ocfs2: remove ocfs2_is_o2cb_active()
Subject: ocfs2: give an obvious tip for mismatched cluster names

  Joseph had issues with this one

Subject: ocfs2: move some definitions to header file
Subject: ocfs2: fix some small problems
Subject: ocfs2: add kobject for online file check
Subject: ocfs2: add duplicated ino number check
Subject: ocfs2: fix qs_holds may could not be zero

  Needs a new changelog and a fixed comment

Subject: ocfs2/dlm: wait for dlm recovery done when migrating all lockres
Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()
Subject: ocfs2: add ocfs2_overwrite_io()
Subject: ocfs2: nowait aio support


Thanks.
