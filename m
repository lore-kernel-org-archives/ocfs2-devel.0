From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Apr 13 20:47:00 2004
Subject: [Ocfs2-devel] [BUG] can not chmod to 777
Message-ID: <3ACA40606221794F80A5670F0AF15F843C28A5@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

HI
	I create a directory /ocfs, and take it the mount point of ocfs2
filesystem, but I can not
use "chmod 777" to change its permission, it always shows 755.
Seems this breaks a lot LTP test cases.
I report it as bug 56.
