From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Aug  6 17:53:48 2004
Subject: [Ocfs2-devel] why skip zero is removed?
Message-ID: <3ACA40606221794F80A5670F0AF15F8405167BDB@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I found in r1323, the skip zero is removed from ocfs_extend_file.
So what's the reason? The log say "skip_zeros is pointless with the new
zeroing scheme."
What's the new zeroing scheme?  Now the performance for directory droped
again to 200/s in svn1331.

-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
