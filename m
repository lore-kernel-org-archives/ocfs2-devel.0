From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Aug 10 17:19:46 2004
Subject: [Ocfs2-devel] [BUG] write and read on other node are not consistent
Message-ID: <3ACA40606221794F80A5670F0AF15F840520BD03@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


svn 1343 kernel 2.6.6
try this case
test1()
{       
 	  WD="aaaaaaaa"
        ssh $REMOTE "echo $WD > /ocfs/testcluster$$"
        sleep 10
        RD=`cat /ocfs/testcluster$$`
        if [ "x$WD" == "x$RD" ];then
                echo PASS
        else
                echo FAIL
        fi
}
It fails, so now write on node and read from anther is not consistent.
what 
read from anther is some random data. 
But after remount, it's correct.

-------------------
Intel China Software Lab.
iNet: 8-752-1243
8621-52574545-1243(O)
503-712-6740(Temp)

xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
