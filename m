From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed Aug 11 15:57:14 2004
Subject: [Ocfs2-devel] data inconsistency when write in a memory map way
Message-ID: <3ACA40606221794F80A5670F0AF15F8405251CDA@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This is also for 2.6 kernel and also for normal read/write as I reported =
yestoday.

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Chen, Yukun
>Sent: 2004=C4=EA8=D4=C211=C8=D5 2:38
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] data inconsistency when write in a=20
>memory map way
>
>Hi all
>
>for beta 4 release, on kernel 2.4.x
>
>steps to duplicate:
>
>1.on node a, write to a file residing on a ocfs2 partition in a way of
>memory=20
>
>map
>
>2.then on node b , check the writtent data but nothing will be found.
>
>It is ok if I use a normal way to write file and check on another node.
>
>Any ideas on it.
>
>BTW, the issue has been reported as bug#124 to oss.oracle.com
>
>Thanx.
>
>
>Aaron
>
>Intel China Software Lab
>
>Tel:  8621-52574545 Ext.1587
>
>E_mail:yukun.chen@intel.com
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
