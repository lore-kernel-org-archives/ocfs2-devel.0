From: TaoMa <tao.ma@oracle.com>
Date: Tue, 22 Sep 2009 06:27:14 +0800
Subject: [Ocfs2-devel] [PATCH 00/42] ocfs2: Add reflink file support. V5
Message-ID: <4AB7FDC2.1060305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
    As reflink system call may not be merged into .32, I re-generate the 
patch set and now it only uses ioctl to reflink a file.
Most patches are unmodified, the big change exists in the last one. So I 
only send it out for review.

[View]
http://oss.oracle.com/git/?p=tma/linux-2.6.git;a=shortlog;h=refcount_no_sysctl

[Pull]
git://oss.oracle.com/git/tma/linux-2.6.git refcount_no_sysctl.

Regards,
Tao
