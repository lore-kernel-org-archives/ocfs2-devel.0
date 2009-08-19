From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 19 Aug 2009 12:54:25 -0700
Subject: [Ocfs2-devel] [PATCH 0/14] ocfs2: Unify the setting of extended
	attributes
Message-ID: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 can store extended attributes in many ways.  They can live inside
the inode's inline data area, they can be stored in a single external
block, or they can be in a "bucket" hanging off of a lookup tree.  There
are differences in how each storage type manages the attributes, and the
current ocfs2 code reflects this.

There are two entirely separate code paths for setting extended
attributes.  The first code path handles "block" storage - the inline
inode or the external block.  The second handles "bucket" storage.  They
do very similar things, but they go about them in very different ways.
This makes reading and understanding the ocfs2 xattr code harder than it
needs to be.  Worse, updating the xattr code requires understanding and
modifying both paths.

This patch series unifies the xattr set code such that inodes, block,
and buckets make the same call.  It removes most of the redundant code,
like the repeated implementations of truncating externally stored values.

The core of the implementation is the ocfs2_xa_loc structure.  This is
an in-memory representation of an ocfs2_xattr_entry.  It has operations
that allow blocks and buckets to behave differently during the xattr
modification process.  Blocks and buckets are different enough that
ocfs2_xa_loc_operations has ten different ops!  But with these
differences encapsulated, we can have a single code path to modify an
entry.

The changes don't reduce the size of the source code perceptibly (~10
lines of actual code without comments or blanks), but to my mind they
greatly improve the readability and maintainability.

The current series is based on the 'fixes' branch; I'll need to rebase
it atop cachme before it can go upstream.  I wanted to send it out as it
stands now so that the concept can be reviewed while I work on
merge-window.

Tao and Tiger, I'd really appreciate you going over the changes with a
find-toothed comb.  Make sure I have my ideas about block and bucket
stuff correct, etc.  Let me know if you think this is a stupid change,
too :-)

Joel

[Pull]
git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git xa_loc
[View]
http://git.kernel.org/?p=linux/kernel/git/jlbec/ocfs2.git;a=shortlog;h=xa_loc
