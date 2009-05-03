From: Joel Becker <joel.becker@oracle.com>
Date: Sat,  2 May 2009 23:15:00 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call.
Message-ID: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Hi everyone,
	I described the reflink operation at the Linux Storage &
Filesystems Workshop last month.  Originally implemented as an
ocfs2-specific ioctl, the consensus was that it should be a syscall from
the get-go.  Here's some first-cut patches.
	For people who have not seen reflink, either at LSF or on the
ocfs2 wiki, the first patch contains
Documentation/filesystems/reflink.txt to describe the call.  The
short-short version is that reflink creates a reference-counted link.
This is a new file that shares the data extents of a source file in a
copy-on-write fashion.
	The second patch adds iops->reflink() and vfs_reflink().  People
interested in LSM interaction, please look at my comments in the patch
header and the implementation of vfs_link().  I think it needs
improvement.
	The last patch defines sys_reflink() and sys_reflinkat().  It
also hooks them up for x86_32.  The final version of this patch will
obviously include the other architectures.
	The patches are also available in my git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git reflink

The current ioctl-based implementation for ocfs2 is available in Tao's
git tree at:

  git://oss.oracle.com/git/tma/linux-2.6.git refcount

It will be reset atop the system call very soon.
	Please send any comments along.

Joel

 Documentation/filesystems/reflink.txt |  129 ++++++++++++++++++++++++++++++++++
 Documentation/filesystems/vfs.txt     |    4 +
 arch/x86/include/asm/unistd_32.h      |    1 
 arch/x86/kernel/syscall_table_32.S    |    1 
 fs/namei.c                            |   96 +++++++++++++++++++++++++
 include/linux/fs.h                    |    2 
 6 files changed, 233 insertions(+)

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
