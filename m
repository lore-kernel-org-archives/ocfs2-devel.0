From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 6 Jun 2008 16:01:54 -0700
Subject: [Ocfs2-devel] [RFC][PATCH 4/4] configfs: Make multiple
	default_group	destructions lockdep friendly
In-Reply-To: <20080603160034.GA17308@localhost>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com> <4836F48A.70008@kerlabs.com>
	<20080602230721.GD19500@mail.oracle.com>
	<20080603160034.GA17308@localhost>
Message-ID: <20080606230154.GK29740@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 06:00:34PM +0200, Louis Rilling wrote:
> On Mon, Jun 02, 2008 at 04:07:21PM -0700, Joel Becker wrote:
> > 	A couple comments.
> > 	First, put a BUG_ON() where you have BAD BAD BAD - we shouldn't
> > be creating a depth we can't delete.
> 
> I think that the best way to avoid this is to use the same numbering scheme
> while attaching default groups.

	If I'm reading this right, when we come back up from one child
chain, we update the parent to be the same as the child - this is, i
assume, to allow all the locks to be held at once.  IOW, you are trying
to have all locks in the default groups have unique lock levels,
regardless of their depth.
	This is obviously limiting on the number of default groups for
one item - it's a total cap, not a depth cap.  But I have another
concern.  We lock a particular default_group with level N, then its
child default_group with level N+1.  But how does that integrate with
VFS locking of the same mutexes?
	Say we have an group G.  It has one default group D1.  D1 has a
default group itself, D2.  So, when we populate the groups, we lock G at
MUTEX_CHILD, D1 at MUTEX_CHILD+1, and D2 at MUTEX_CHILD+2.  However,
when the VFS navigates the tree (eg, lookup() or someone attempting an
rmdir() of D2's non-default child), it will lock with _PARENT and
_CHILD, not with our subclasses.
	Am I right about this?  We won't be using the same classes as
the VFS, and thus won't be able to see about interactions between the
VFS locking and our locking?  I'd love to be wrong :-)

Joel

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd at loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
