From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 16:28:34 2008
Subject: [Ocfs2-devel] [GIT PATCH 0/2] ocfs2: Fix endian bug in o2dlm
	negotiation
In-Reply-To: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
References: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20080219002800.GE22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 06:07:31PM -0800, Joel Becker wrote:
> 
> These patches fix up two outstanding issues from commit
> d24fbcda0c4988322949df3d759f1cfb32b32953 (ocfs2: Negotiate locking
> protocol versions).  The first patch cleans up the comparison functions
> based on Andrew's review.  The second fixes a byte-order bug in
> heterogeneous clusters.
> 
> I've tested the changes in said hetergeneous envirnoment.  Comments
> and review welcome.  Mark, you can pull these into ocfs2.git if they
> meet your approval.

Both these look good to me, thanks Joel.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
