From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug 17 20:45:27 2004
Subject: [Ocfs2-devel] [BUG] LTP:mkdir try to inherits group id failed
Message-ID: <3ACA40606221794F80A5670F0AF15F840533B40A@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

LTP test case mkdir02 failed.This time, it is not LTP bug. see bug 130
You can reproduce it manually:
with root
1. mkdir dir1
2. chmod ugo+w dir1
3.chmod g+s dir1
 with another user user1 and group group1
4. cd dir1
5. mkdir dir2
6.ls -l dir2
The group id is group1, not root. While in ext3, it is root.



-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
