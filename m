From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Wed May 19 20:43:15 2004
Subject: [Ocfs2-devel] insmod on kernel 2.6.4
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E04431EA0@orsmsx404.amr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This problem is in the 2.6.6 kernel.  See http://lwn.net/Articles/75233/
for why the blk_run_queues() function is gone, and why just running the
address space is what file systems are supposed to do.

    --rusty

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Manish Singh
Sent: Wednesday, May 19, 2004 6:40 PM
To: Ling, Xiaofeng
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] insmod on kernel 2.6.4

On Thu, May 20, 2004 at 08:58:27AM +0800, Ling, Xiaofeng wrote:
> I found on kernel 2.6.4, when insmod, there is symbol not found error.
> It seems from 2.6.4, the blk_run_queues is removed from kernel.
> So mabye the call to blk_run_queues in hash.c shall be changed as
> blk_run_address_space(bd->b_dev->bd_inode->i_mapping) ?

Current svn doesn't build with anything prior to 2.6.6 (or SuSE's
patched
up 2.6.5, which is why I haven't bumped the version check yet). Please
use 2.6.6 or higher when running v2 from now on.

Our policy is to track the latest 2.6.x releases until one of our
supported vendors freezes on a certain version. Only then we want to
deal with the headache of tracking different 2.6.x API versions.

If you have a good reason to use 2.6.4, let me know and I'll add the
cruft, but it should be a good reason. ;)

-Manish
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
