From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug  5 19:06:32 2004
Subject: [Ocfs2-devel] found a subdir with link=1
Message-ID: <3ACA40606221794F80A5670F0AF15F840516716D@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I found a subdir with link=1, in my ocfs2 file system.
It is a empty directory, so the link should equal to 2, but now it is 1.
So I can not remove it. I can not remember what kind of operations I do
that cause this directory, but there shall be a bug inside the driver.
Anyone found the same problem?
My ocfs is svn 1331.

-------------------
Intel China Software Lab.
iNet: 8-752-1243
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
