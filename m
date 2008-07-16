From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 16 Jul 2008 10:27:03 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup
	after mkdir()	failure
In-Reply-To: <20080716130821.GF3801@hawkmoon.kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
	<20080711220740.GC22577@mail.oracle.com>
	<20080716130821.GF3801@hawkmoon.kerlabs.com>
Message-ID: <20080716172703.GA18105@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jul 16, 2008 at 03:08:21PM +0200, Louis Rilling wrote:
> On Fri, Jul 11, 2008 at 03:07:40PM -0700, Joel Becker wrote:
> > On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> > > This patchset fixes two kinds of bugs happening when
> > > configfs_attach_group()/configfs_attach_item() fail and userspace races with
> > > mkdir() or symlink().
> > 
> > 	Ok, I've merged all this work.  Please check out my configfs-ALL
> > branch and make sure I have everything we've worked on.
> > 
> > http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
> > git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL
> 
> Looks complete.

	Ok, I'm going to get it to linux-next,then off to Linus for .27.

> There is still a few things in flight:
> - error handling in config_*_init_type_name(): has rather low priority in my
>   TODO list, will come back to it probably in a few weeks.

	I thought we did this already.  Perhaps I didn't include it?
Did we have another change to make?

> - a small locking cleanup in configfs_rmdir(): will do at the same time as
>   lockdep stuff.

	What sort of change?  I suppose I'll see it when it arrives.
	I figure this new stuff will probably miss the .27 window, but
it sounds like that's fine - nothing too serious, and it will make .28.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
