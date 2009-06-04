From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Jun 2009 19:30:21 -0700
Subject: [Ocfs2-devel] Anything I'm missing for 2.6.31?
In-Reply-To: <20090602010636.GB32688@mail.oracle.com>
References: <20090602010636.GB32688@mail.oracle.com>
Message-ID: <20090604023021.GH7933@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 01, 2009 at 06:06:36PM -0700, Joel Becker wrote:
> 	We're coming up on the next merge window, and I only have a
> couple tiny fixes for ocfs2.  I thought I'd list up what I know is
> outstanding, and I was hoping to find out if I was missing anything.  If
> I am, I need to get it in linux-next and set for the merge window ASAP.

	I've now created the merge-window branch for the 2.6.31 cycle.
It contains the quota fixes, the orphan dir background scan, metaecc
stats, and a few small fixes.  The only thing I see outstanding is the
btree add branch bug Tao and Mark are working on.
	Please have a look and let me know if there are any problems or
if anything is missing.

Joel

[Pull]
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git merge-window
[View]
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=shortlog;h=merge-window

-- 

Life's Little Instruction Book #510

	"Count your blessings."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
