From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed May 19 20:54:29 2004
Subject: [Ocfs2-devel] insmod on kernel 2.6.4
Message-ID: <3ACA40606221794F80A5670F0AF15F84046232DC@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ok, just found the newest svn 928 has fixed the problem.
seems I use the old one.:)


>-----Original Message-----
>From: Lynch, Rusty=20
>Sent: 2004=C4=EA5=D4=C220=C8=D5 9:43
>To: Manish Singh; Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: RE: [Ocfs2-devel] insmod on kernel 2.6.4
>
>This problem is in the 2.6.6 kernel.  See=20
>http://lwn.net/Articles/75233/ for why the blk_run_queues()=20
>function is gone, and why just running the address space is=20
>what file systems are supposed to do.
>
>    --rusty
>
>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Manish Singh
>Sent: Wednesday, May 19, 2004 6:40 PM
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] insmod on kernel 2.6.4
>
>On Thu, May 20, 2004 at 08:58:27AM +0800, Ling, Xiaofeng wrote:
>> I found on kernel 2.6.4, when insmod, there is symbol not=20
>found error.
>> It seems from 2.6.4, the blk_run_queues is removed from kernel.
>> So mabye the call to blk_run_queues in hash.c shall be changed as
>> blk_run_address_space(bd->b_dev->bd_inode->i_mapping) ?
>
>Current svn doesn't build with anything prior to 2.6.6 (or=20
>SuSE's patched
>up 2.6.5, which is why I haven't bumped the version check yet). Please
>use 2.6.6 or higher when running v2 from now on.
>
>Our policy is to track the latest 2.6.x releases until one of our
>supported vendors freezes on a certain version. Only then we want to
>deal with the headache of tracking different 2.6.x API versions.
>
>If you have a good reason to use 2.6.4, let me know and I'll add the
>cruft, but it should be a good reason. ;)
>
>-Manish
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
