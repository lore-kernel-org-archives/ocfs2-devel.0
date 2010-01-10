From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 10 Jan 2010 02:05:47 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <E61B62B5-C721-4391-8F33-4E8F3098A6BB@oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
	<E61B62B5-C721-4391-8F33-4E8F3098A6BB@oracle.com>
Message-ID: <20100110100546.GB21032@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jan 09, 2010 at 10:24:10AM -0800, Sunil Mushran wrote:
> This needs testing. Joel has forwarded it to Fabbione who has a
> testcase that we believe triggers this issue. If that works, I'll
> push this in the 1.6 testing tree. That way we'll know (a) the patch
> fixes the problem, and (b) does not break other things. This is a
> tricky function. We are just being careful.

Wengang,
	Like Sunil said, this is a very critical part of the code.  Our
locking code is the biggest place for lockups and corruptions to happen.
We always take the safe route here.  We're working to test both of your
patches.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
