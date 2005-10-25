From: Michael Steinmann <msl@calivia.com>
Date: Tue Oct 25 03:31:48 2005
Subject: [Ocfs2-devel] Support for SLES9
Message-ID: <15538.193.5.216.100.1130229159.squirrel@www2.calivia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Support for SLES9 seems to be pretty much lacking at the moment.
The OCFS2 site [1] states OCFS2 is supported with SP2+. There actually
does not exist a SP2+ for SLES9 (or should this rather read "will be
supported in SP3" instead?).

Latest RPMs that come with SLES9 SP2 are 0.99.14 which has critical known
bugs and is unusable.

Anybody got to compile current source on SLES9 x86_64?
1.1.2, 1.1.6 and trunk all fail to compile on SLES9.SP2 2.6.5-7.191-smp SMP
x86_64 [3].


ocfs2-1.0.7 is the latest tarball I got to compile.
Problem here is that we loose IP heartbeat and node1 fences shortly after
mounting a shared LV on the second node [4]. Bummer.

Anybody more luck?

--Mike

[1] http://oss.oracle.com/projects/ocfs2/
[2]
http://www.novell.com/products/linuxpackages/enterpriseserver/SP2/i386/index_all.html
[3] http://oss.oracle.com/bugzilla/show_bug.cgi?id=589
[4] http://oss.oracle.com/bugzilla/show_bug.cgi?id=590
