From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 9 Jun 2008 13:03:53 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 4/4] configfs: Make multiple
	default_group	destructions lockdep friendly
In-Reply-To: <20080606230154.GK29740@mail.oracle.com>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
	<20080606230154.GK29740@mail.oracle.com>
Message-ID: <20080609110353.GK18153@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 04:01:54PM -0700, Joel Becker wrote:
> On Tue, Jun 03, 2008 at 06:00:34PM +0200, Louis Rilling wrote:
> > On Mon, Jun 02, 2008 at 04:07:21PM -0700, Joel Becker wrote:
> > > 	A couple comments.
> > > 	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
> > > be creating a depth we can't delete.
> > 
> > I think that the best way to avoid this is to use the same numbering scheme
> > while attaching default groups.
> 
> 	If I'm reading this right, when we come back up from one child
> chain, we update the parent to be the same as the child - this is, i
> assume, to allow all the locks to be held at once.  IOW, you are trying
> to have all locks in the default groups have unique lock levels,
> regardless of their depth.

Exactly, otherwise lockdep will issue a warning as soon as one tries to remove
a config group having default groups at the same depth, because it will see two
mutexes locked with same sub-class.

> 	This is obviously limiting on the number of default groups for
> one item - it's a total cap, not a depth cap.  But I have another
> concern.  We lock a particular default_group with level N, then its
> child default_group with level N+1.  But how does that integrate with
> VFS locking of the same mutexes?
> 	Say we have an group G.  It has one default group D1.  D1 has a
> default group itself, D2.  So, when we populate the groups, we lock G at
> MUTEX_CHILD, D1 at MUTEX_CHILD+1, and D2 at MUTEX_CHILD+2.  However,
> when the VFS navigates the tree (eg, lookup() or someone attempting an
> rmdir() of D2's non-default child), it will lock with _PARENT and
> _CHILD, not with our subclasses.
> 	Am I right about this?  We won't be using the same classes as
> the VFS, and thus won't be able to see about interactions between the
> VFS locking and our locking?  I'd love to be wrong :-)

You are perfectly right, unfortunately. This is the reason why I proposed
another way that temporarily disables lockdep, and let us prove the correctness
manually (actually, this manual solution still lets lockdep verify that the
assumption about I_MUTEX_PARENT -> I_MUTEX_CHILD nesting is correct).

A real solution without disabling lockdep and that would integrate with the VFS
should make lockdep aware of lock trees (like i_mutex locks inside a same
filesystem), or more generally lock graphs, and let lockdep verify that locks of
a tree are always taken while respecting a same order. IOW, if we are able to
consistently tag the nodes of a tree with unique numbers (consistently means
that the resulting order on the nodes is never changed when adding or removing
nodes), lockdep should check that locks of the tree are always taken in
ascending tag order.
	This seems unfortunately hard (impossible?) to achieve with reasonable
constraints: lockdep should not need to add links between the locks (this would
make addition and removal of nodes error prone), and lockdep should not need to
renumber all the nodes of a tree when adding a new node.

As a conclusion, I still suggest to temporarily disable lockdep, which will have
the advantage of letting people use lockdep (for other areas) while using
configfs, because lockdep simply cannot help us with configfs hierarchical
locking right now.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
