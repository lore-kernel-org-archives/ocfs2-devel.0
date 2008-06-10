From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 9 Jun 2008 18:58:00 -0700
Subject: [Ocfs2-devel] [BUG] deadlock between configfs_rmdir() and
	sys_rename() (WAS	Re: [RFC][PATCH 4/4] configfs: Make
	multiple default_group)	destructions lockdep friendly
In-Reply-To: <20080609125443.GL18153@localhost>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
	<20080609110353.GK18153@localhost>
	<20080609125443.GL18153@localhost>
Message-ID: <20080610015800.GD14820@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 02:54:43PM +0200, Louis Rilling wrote:
> Following an intuition, I just found a deadlock resulting from the whole default
> groups tree locking in configfs_detach_prep().

	Ugh, thanks for catching this :-(
 
> The issue here is that the VFS locks the i_mutex of the source and target
> directories of the rename in source -> target order (because none is ascendent
> of the other one), while configfs_detach_prep() takes them in default group
> order (or reverse order, I'm not sure), following the order specified by the
> groups' creator.

	What actual targets are you renaming?  Sibling default groups?

> The VFS protects itself against deadlocks of two concurrent renames with
> interverted source and target directories with i_sb->s_vfs_rename_mutex. Perhaps
> configfs should use the same lock before calling configfs_detach_prep()?
> Or maybe configfs would better find an alternative to locking the whole
> default groups tree? I strongly advocate for the latter, since this could also
> solve our issues with lockdep ;)

	I think the former actually works nicely.  We are playing with
the subtree, and want to keep all operations out of it.  Except, of
course, that we come into rmdir() with our parent i_mutex taken, so that
violates the ordering of the rename locks, right?
	I'm not against the latter AT ALL.  I just haven't come up with
it yet - we can't remove parts of the tree, it must be all or none.
Hence, we lock them all speculatively.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
