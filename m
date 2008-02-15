From: Joel Becker <joel.becker@oracle.com>
Date: Fri Feb 15 18:08:59 2008
Subject: [Ocfs2-devel] [GIT PATCH 0/2] ocfs2: Fix endian bug in o2dlm
	negotiation
Message-ID: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org


These patches fix up two outstanding issues from commit
d24fbcda0c4988322949df3d759f1cfb32b32953 (ocfs2: Negotiate locking
protocol versions).  The first patch cleans up the comparison functions
based on Andrew's review.  The second fixes a byte-order bug in
heterogeneous clusters.

I've tested the changes in said hetergeneous envirnoment.  Comments
and review welcome.  Mark, you can pull these into ocfs2.git if they
meet your approval.

The changes are available via git from
git://oss.oracle.com/git/jlbec/linux-2.6.git proto-version-fixup

Joel
