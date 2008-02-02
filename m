From: Jeff at locomotive.unixthugs.org <Jeff@locomotive.unixthugs.org>
Date: Sat, 02 Feb 2008 16:27:54 -0000
Subject: [Ocfs2-devel] [patch 00/16] ocfs2: SLES10 compatibility patch queue
Message-ID: <20080202162652.006821000@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 Here is the original set of fixes, split out into 14 individual ones.

 In addition to splitting them out, I also changed the ones that were
 HAS_* to NO_* as requested. The last two patches are needed to build
 on openSUSE 10.3 which is based on 2.6.22. I used it as a sanity check
 and found those failures.

 -Jeff

--
Jeff Mahoney
SUSE Labs
