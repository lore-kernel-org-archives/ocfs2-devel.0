From: Denis Cheng <crquan@gmail.com>
Date: Thu Dec  6 20:20:56 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
Message-ID: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 uses a subsystem under sysfs: /sys/o2cb, which is not good,

the canonical use of sysfs is one kset under /sys/fs, like the approach
gfs2 does.

if someone will agree my opinion, I can improve this code.

--
Denis Cheng
