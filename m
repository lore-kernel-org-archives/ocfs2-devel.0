From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 2 Aug 2012 00:57:44 -0700
Subject: [Ocfs2-devel] [RFC PATCH] ocfs2: don't depend on
	DCACHE_DISCONNECTED
In-Reply-To: <20120731223323.GA32253@fieldses.org>
References: <20120731223323.GA32253@fieldses.org>
Message-ID: <20120802075743.GA3368@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

On Tue, Jul 31, 2012 at 06:33:23PM -0400, J. Bruce Fields wrote:
> From: "J. Bruce Fields" <bfields@redhat.com>
> 
> XXX: I don't understand this code, but I also can't see how it can be
> right as is: a dentry marked DCACHE_DISCONNECTED can in fact be a
> fully-connected member of the dcache.  Is IS_ROOT() the right check
> instead?
> 
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>

NAK.  DISCONNECTED is cleared when the dentry is materialized.

Here's the context.  When an ocfs2 dentry is discoverable via the tree
(lookup or splicing an alias), we hold a cluster lock (the "dentry
lock").  This is why we override d_move(), to make sure that state is
kept sane.  That way, other nodes can communicate unlink to this node.
They notify our node via the locking system, which does a
d_delete()+dput(), which sets DISCONNECTED.  When the dentry gets its
final put, we can properly accept an empty lock.

Joel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

			http://www.jlbec.org/
			jlbec at evilplan.org
