From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb  5 17:49:50 2004
Subject: [Ocfs2-devel] important: ocfs2 version number bump
Message-ID: <20040205234947.GC26471@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

*** WARNING: None of this should be attempted on a production file system.

We've bumped up the version number in the ocfs2 module. This means however
that it won't mount ocfs1 filesystems. To be able to mount with ocfs2, you
MUST download, build and install the current SVN version of ocfs-tools and
do one of the following:

1) Format as a version 2 filesystem. Run mkfs.ocfs2 with the same options as
you used to use with 'mkfs.ocfs'. For example:

       mkfs.ocfs2 -b 4 -L ocfs2_test -m /ocfs2 /dev/sdb1


2) If you have an existing version 1 filesystem, then you can use the
tuneocfs '-c 2' option to bump up the version number. You will not be able
to go back to version 1 after this.

	tuneocfs -c 2 /dev/sdb1

This option is currently undocumented as it is changing rapidly. Again, NONE
of this should be attempted on a production file system.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
