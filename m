From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 17:22:46 -0700
Subject: [Ocfs2-devel] xattr fixes branch
Message-ID: <20081024002246.GF12751@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Folks,
	To keep track of what we want to upstream in the 2.6.28-rc
cycle, I've put together a branch called 'xattr-28' with almost all of
the patches merged.  You can see it and pull it from my linux-2.6.git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=xattr-28
Pull:
git://oss.oracle.com/git/jlbec/linux-2.6.git xattr-28

	The branch contains the following changes:

Joel Becker (5):
      ocfs2: Check xattr block signatures properly.
      ocfs2: Don't return -EFAULT from a corrupt xattr entry.
      ocfs2: Check errors from ocfs2_xattr_update_xattr_search()
      ocfs2: Specify appropriate journal access for new xattr buckets.
      ocfs2: Don't repeat ocfs2_xattr_block_find()

Tao Ma (1):
      ocfs2: Remove unused ocfs2_restore_xattr_block().

Tiger Yang (4):
      ocfs2: fix license in xattr
      ocfs2: fix function declaration and definition in xattr
      ocfs2: remove duplicate definition in xattr
      ocfs2: add handler_map array bounds checking

	These fixes and cleanups I think are candidates for 2.6.28-rc.
The last patch I'm waiting for is Tao's "ocfs2: Proper hash collision
handling in xattr bucket division."  That's also a bugfix, and I think a
candidate for 2.6.28-rc.  Once we get that nailed down, I think we're
good, and we'll send this stuff along upstream.
	Tristan, I'd love it if you could test this branch to make sure
these fixes and cleanups didn't break anything.

Joel

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
