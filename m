From: Theodore Tso <tytso@mit.edu>
Date: Sun, 3 May 2009 19:45:18 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
Message-ID: <20090503234518.GB17044@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
> int reflink(const char *oldpath, const char *newpath);
> 
> The reflink(2) system call creates reference-counted links.  It creates
> a new file that shares the data extents of the source file in a
> copy-on-write fashion.  Its calling semantics are identical to link(2).
> Once complete, programs see the new file as a completely separate entry.

How should quota handle reflinks?  Since there are separate inodes,
the two files could be owned by different user ID's.  Since the data
blocks exist only once, I can imagine a number of different ways of
handling it:

1) When the reflink is created, the owner of the new reflink is not
charged the number of blocks of the file against his/her quota.  If
the original inode is deleted, the original owner continues to have
the cost of the file charged against his/her quota until the last
reflink disappears.

2) When the reflink is created, the owner of the new reflink is NOT
charged the number of blocks of the file against his/her quota.  If
the original inode is deleted, the owner of the reflink is charged the
number of blocks against his/her quota.  If that drives the owner over
quota, the quota subsystem will enforce the soft and hard quota limits
as per normal.  If there are more than one reflink against the file,
the system will randomly choose one user and charge the blocks against
his/her quota.

3) When the reflink is created, the owner of the new reflink is
charged the number of blocks of the file against his/her quota.  The
original owner of the inode continus to also have the blocks of the
file charged against his/her quota, so in effect the blocks are
"double counted".

4) When the reflink is created, the owner of the new reflink is NOT
charged the number of blocks of the file against his/her quota.  The
original owner of the inode continues to also have the blocks of the
file charged against his/her quota; if the file is deleted the blocks
associated with the file will not be charged against any users' quota.

All of these have various problems; and maybe the answer is that
reflinks aren't really compatible with quotas, so pick something least
bad (say #3), and we can just move on.

						- Ted
