From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Wed May 19 19:58:32 2004
Subject: [Ocfs2-devel] insmod on kernel 2.6.4
Message-ID: <3ACA40606221794F80A5670F0AF15F8404623228@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I found on kernel 2.6.4, when insmod, there is symbol not found error.
It seems from 2.6.4, the blk_run_queues is removed from kernel.
So mabye the call to blk_run_queues in hash.c shall be changed as
blk_run_address_space(bd->b_dev->bd_inode->i_mapping) ?




-------------------
Intel China Software Lab.
iNet: 8-752-1806
021-52574545-1243(O)
xfling@users.sourceforge.net
Opinions are my own and don't represent those of my employer 
