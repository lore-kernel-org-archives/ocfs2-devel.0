From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Tue Feb  3 18:38:52 2004
Subject: [Ocfs2-devel] invalidate: busy buffer
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A6178029@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Playing with revision 19 from Subversion of OCFS2.

It appears that when I create and then delete directories I will get the
following error message when I unmount the partition:

invalidate: busy buffer
...
invalidate: busy buffer


Has anyone else seen this?

John
