From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Thu Mar  4 12:32:19 2004
Subject: [Ocfs2-devel] 2.6 status
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A5699E@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

At the moment it builds using the stuff currently in svn.

You just need to do:

./autogen.sh --enable-kernel-26
make

This works for me on Fedora Core 2 Test 1 release with all the
development updates applied as of yesterday.

John



> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com 
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Wim Coekaerts
> Sent: Thursday, March 04, 2004 10:27 AM
> To: ocfs2-devel@oss.oracle.com
> Subject: [Ocfs2-devel] 2.6 status
> 
> 
> so I need to send something that at least builds to suse today or
> tomorrow(absolute latest) for 2.6, can I ? 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
