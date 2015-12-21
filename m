From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 21 Dec 2015 11:00:59 +0800
Subject: [Ocfs2-devel] ocfs2-test for v4.3 done
Message-ID: <56776B6B.2010208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

I have run a full ocfs2-test(single/multiple/discontig) to v4.3 mainline
kernel. The following three issues are found. The first two are
regression bugs.

1. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1357
  Fix merged. Upstream commit 087ffd4eae99("jbd2: fix null committed
data return in undo_access")

2. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1358
  A recursive locking issue, discussing fix in ocfs2-devel.

3. https://oss.oracle.com/bugzilla/show_bug.cgi?id=1359
  o2hb-increase-unsteady-iterations.patch to fix this issue, merged by
-mm tree

I have setup a test env to build and auto do ocfs2 test. With it, Ocfs2
for mainline and linux-next will be test regularly, the test status and
bugs will be reported to ocfs2-devel. Feel free to take any bug if you
are interested, it will be a good start point with ocfs2. Hope this can
catch regression bugs earlier before merged by mainline.

For the test cases, now only ocfs2-test is supported. Ltp is going to be
merged in the future. If any other test cases or benchmark useful to
ocfs2 test, please let me know.

Thanks,
Junxiao.
