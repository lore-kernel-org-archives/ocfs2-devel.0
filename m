From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Apr 14 18:09:28 2004
Subject: [Ocfs2-devel] [BUG] can not chmod to 777
In-Reply-To: <3ACA40606221794F80A5670F0AF15F843C28A5@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F843C28A5@PDSMSX403.ccr.corp.intel.com>
Message-ID: <407DC414.4020508@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I agree with kurt about adding a lockfe for making changes
in the volhdr. But short of that, if all you are doing is single
node tests, just hack it. As in, comment out the root inode
check in ocfs_setattr and also jump over any code making
fe changes on disk for this. There is no fe for root in ocfs.

This should help in reducing the noise in ltp.

Ling, Xiaofeng wrote:

>HI
>	I create a directory /ocfs, and take it the mount point of ocfs2
>filesystem, but I can not
>use "chmod 777" to change its permission, it always shows 755.
>Seems this breaks a lot LTP test cases.
>I report it as bug 56.
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
