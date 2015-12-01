From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 1 Dec 2015 10:36:51 +0800
Subject: [Ocfs2-devel] ocfs2 test for 0-day test
Message-ID: <565D07C3.2020609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Fengguang,

I heard you ever asked for test cases from subsystems to merge into your
0-day test framework. For ocfs2, we have a test project "ocfs2-test",
its git tree at
https://oss.oracle.com/git/ocfs2-tools.git/ocfs2-tools-1.8.4?p=ocfs2-test.git;a=summary
. There is a README in it about test cases and steps to setup test env.

Recently we fixed lots of issues of it and I am using it to test ocfs2
mainline regularly. Two regression bugs have been found by it. It's a
little pain for me that I have to analysis and fix regression bugs
manually. Since 0-day test supports auto bisect, I am curious whether
you are interested in merging it into your 0-day test?

Thanks,
Junxiao.
