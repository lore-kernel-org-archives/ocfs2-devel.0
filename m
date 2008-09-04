From: Joel Becker <joel.becker@oracle.com>
Date: Wed,  3 Sep 2008 20:03:38 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Switch over to JBD2.
Message-ID: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 currently uses the Journaled Block Device (JBD) for its
journaling.  This is a very stable and tested codebase.  However, JBD
is limited by architecture to 32bit block numbers.  This means an ocfs2
filesystem is limited to 2^32 blocks.  With a 4K blocksize, that's 16TB.
People want larger volumes.

Fortunately, there is now JBD2.  JBD2 adds 64bit block number support
and some other features.  JBD2 is backwards compatible, so it can be
used with existing filesystems.  The new features won't be accessed
until the ocfs2-tools turn them on.

Before we support JBD2, however, we need to ensure that inode blocks are
allocated below that 32bit boundary.  stat(2) cannot handle larger inode
numbers on 32bit machines.  With that limit in place, we can fully
support JBD2 in the kernel filesystem.  Like XFS, we provide the
'inode64' option to remove that limit.  

A config option is provided (OCFS2_COMPAT_JBD) to force ocfs2 to use the
old JBD.  This is for the paranoid while we test JBD2.

The kernel code is available on the 'jbd2' branch of my git repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=jbd2
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git jbd2
