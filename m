From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jun  8 22:01:16 2004
Subject: [Ocfs2-devel] ATTN: OCFS2 coders and testers
Message-ID: <3ACA40606221794F80A5670F0AF15F840493009B@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From result of profile, the ocfs_bh_sem_lookup occupy most of the CPU =
time,
Do you mean it will be removed soon?
Is there still a semaphore for each buffer_head?=20

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
>Sent: 2004=C4=EA6=D4=C29=C8=D5 6:53
>To: ocfs2-devel@oss.oracle.com
>Subject: [Ocfs2-devel] ATTN: OCFS2 coders and testers
>
>Ok, as of SVN revision 1024 I've commited some changes which=20
>include a set
>of BUG() assertions. If you hit a BUG() on an acquire_lockres,=20
>or any bh sem
>hash related functions (get data, get data write, etc) please=20
>copy and send
>the entire output to me and/or to the list (both is prolly good).
>
>Since this stuff is going away soon, I didn't bother to put=20
>the assertions
>in the replacement functions which are used when BH_SEM_DEBUG=20
>is defined.
>Please don't build with that enabled in the Makefile (it is disabled by
>default).
>
>What we're trying to do here is use an alternative locking=20
>scheme for I/O
>instead of the acquire_lockres and bh sem hash stuff. When=20
>we're comfortable
>that the new scheme works, we'll be removing those two.
>
>The hope is that by putting this out a bit early we can get=20
>any corner cases
>we've missed.
>	--Mark
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
