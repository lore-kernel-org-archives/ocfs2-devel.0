From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 15 Aug 2012 03:22:42 -0700
Subject: [Ocfs2-devel] [RFC PATCH] ocfs2: don't depend on
 DCACHE_DISCONNECTED
In-Reply-To: <20120802125910.GC9849@fieldses.org>
References: <20120731223323.GA32253@fieldses.org>
	<20120802075743.GA3368@dhcp-172-17-9-228.mtv.corp.google.com>
	<20120802125910.GC9849@fieldses.org>
Message-ID: <20120815102241.GP31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

On Thu, Aug 02, 2012 at 08:59:10AM -0400, J. Bruce Fields wrote:
> On Thu, Aug 02, 2012 at 12:57:44AM -0700, Joel Becker wrote:
> > On Tue, Jul 31, 2012 at 06:33:23PM -0400, J. Bruce Fields wrote:
> > > From: "J. Bruce Fields" <bfields@redhat.com>
> > > 
> > > XXX: I don't understand this code, but I also can't see how it can be
> > > right as is: a dentry marked DCACHE_DISCONNECTED can in fact be a
> > > fully-connected member of the dcache.  Is IS_ROOT() the right check
> > > instead?
> > > 
> > > Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> > 
> > NAK.  DISCONNECTED is cleared when the dentry is materialized.
> 
> Are you sure?  ocfs2 uses d_splice_alias in its lookup method, which
> doesn't clear DISCONNECTED.
> 
> (d_materialise_unique does something similar to d_splice_alias and also
> clears DISCONNECTED.  However, I'm almost certain that's a bug in
> d_materialise_unique.  The export code connects a
> looked-up-by-filehandle directory by doing lookups in parents one step
> at a time up to the root, only clearing DISCONNECTED once we know that
> the dentry is connected all the way up to the root.  Clearing
> DISCONNECTED as soon as a single dentry is connected to parents will
> lead to bugs.)
> 
> > Here's the context.  When an ocfs2 dentry is discoverable via the tree
> > (lookup or splicing an alias), we hold a cluster lock (the "dentry
> > lock").  This is why we override d_move(), to make sure that state is
> > kept sane.  That way, other nodes can communicate unlink to this node.
> 
> Alas, I'm not following you.  I'll stare at some of the code and try to
> understand....
> 
> > They notify our node via the locking system, which does a
> > d_delete()+dput(), which sets DISCONNECTED.  When the dentry gets its
> > final put, we can properly accept an empty lock.
> 
> So you also depend on d_kill setting DISCONNECTED, huh.

	So, I think you are right that we can't be relying on it *that*
much, because splicing the alias doesn't clear it right away.  In other
words, we rely on other mechanisms to ensure we have our lock attached
when the dentry is reachable, but if we're dropping an unreachable
dentry, we might not have the lock attached, and we need to detect that.
	So your original point, that the code "can't be right", is
really that the code is overly permissive.  If we have a reachable tree
with DISCONNECTED not yet cleared, that lock should be attached, but
this check won't catch it.  That's fine.  We rely on other code.
Conversely, we *know* we can get here with DISCONNECTED set from nfs or
d_kill, and we don't want to print errors for a sane state.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

			http://www.jlbec.org/
			jlbec at evilplan.org
