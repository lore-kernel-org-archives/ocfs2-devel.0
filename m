From: Manish Singh <manish.singh@oracle.com>
Date: Wed May 19 20:40:09 2004
Subject: [Ocfs2-devel] insmod on kernel 2.6.4
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404623228@PDSMSX403.ccr.corp.intel.com>
References: <3ACA40606221794F80A5670F0AF15F8404623228@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040520013958.GA29801@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 20, 2004 at 08:58:27AM +0800, Ling, Xiaofeng wrote:
> I found on kernel 2.6.4, when insmod, there is symbol not found error.
> It seems from 2.6.4, the blk_run_queues is removed from kernel.
> So mabye the call to blk_run_queues in hash.c shall be changed as
> blk_run_address_space(bd->b_dev->bd_inode->i_mapping) ?

Current svn doesn't build with anything prior to 2.6.6 (or SuSE's patched
up 2.6.5, which is why I haven't bumped the version check yet). Please
use 2.6.6 or higher when running v2 from now on.

Our policy is to track the latest 2.6.x releases until one of our
supported vendors freezes on a certain version. Only then we want to
deal with the headache of tracking different 2.6.x API versions.

If you have a good reason to use 2.6.4, let me know and I'll add the
cruft, but it should be a good reason. ;)

-Manish
