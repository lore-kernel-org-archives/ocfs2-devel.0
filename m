From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 29 Jul 2012 23:30:02 -0700
Subject: [Ocfs2-devel] kernel BUG at fs/buffer.c:2886! Linux 3.5.0
In-Reply-To: <501313B6.70801@aprogsys.com>
References: <501313B6.70801@aprogsys.com>
Message-ID: <20120730063000.GA4025@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent ETIENNE <vetienne@aprogsys.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@oss.oracle.com

On Sat, Jul 28, 2012 at 12:18:30AM +0200, Vincent ETIENNE wrote:
> Hello
> 
> Get this on first write made ( by deliver sending mail to inform of the
> restart of services  )
> Home partition (the one receiving the mail) is based on ocfs2 created
> from drbd block device in primary/primary mode
> These drbd devices are based on lvm.
> 
> system is running linux-3.5.0, identical symptom with linux 3.3 and 3.2
> but working with linux 3.0 kernel
> 
> reproduced on two machines ( so different hardware involved on this one
> software md raid on SATA, on second one areca hardware raid card )
> but the 2 machines are the one sharing this partition ( so share the
> same data )

	Hmm.  Any chance you can bisect this further?

> Jul 27 23:41:41 jupiter2 kernel: [  351.169213] ------------[ cut here
> ]------------
> Jul 27 23:41:41 jupiter2 kernel: [  351.169261] kernel BUG at
> fs/buffer.c:2886!

	This is:

	BUG_ON(!buffer_mapped(bh));

in submit_bh().


> Jul 27 23:41:41 jupiter2 kernel: [  351.170003] Call Trace:
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81327546>] ?
> ocfs2_read_blocks+0x176/0x6c0
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8114e541>] ?
> T.1552+0x91/0x2b0
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346ad0>] ?
> ocfs2_find_actor+0x120/0x120
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813464f7>] ?
> ocfs2_read_inode_block_full+0x37/0x60
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964ff>] ?
> ocfs2_fast_symlink_readpage+0x2f/0x160
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81111585>] ?
> do_read_cache_page+0x85/0x180
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff813964d0>] ?
> ocfs2_fill_super+0x2500/0x2500
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff811116d9>] ?
> read_cache_page+0x9/0x20
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c705>] ?
> page_getlink+0x25/0x80
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115c77b>] ?
> page_follow_link_light+0x1b/0x30
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8116099b>] ?
> path_lookupat+0x38b/0x720
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81160d5c>] ?
> do_path_lookup+0x2c/0xd0
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81346f31>] ?
> ocfs2_inode_revalidate+0x71/0x160
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81161c0c>] ?
> user_path_at_empty+0x5c/0xb0
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8106714a>] ?
> do_page_fault+0x1aa/0x3c0
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81156f2d>] ?
> cp_new_stat+0x10d/0x120
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff81157021>] ?
> vfs_fstatat+0x41/0x80
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff8115715f>] ?
> sys_newstat+0x1f/0x50
> Jul 27 23:41:41 jupiter2 kernel: [  351.170003]  [<ffffffff817ecee2>] ?
> system_call_fastpath+0x16/0x1b

	This stack trace is from 3.5, because of the location of the
BUG.  The call path in the trace suggests the code added by Al's ea022d,
but you say it breaks in 3.2 and 3.3 as well.  Can you give me a trace
from 3.2?

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

			http://www.jlbec.org/
			jlbec at evilplan.org
