From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 25 Feb 2013 13:11:03 -0800
Subject: [Ocfs2-devel] OCFS2 mainline state?
In-Reply-To: <512BCA9E.4090702@nod.at>
References: <512BCA9E.4090702@nod.at>
Message-ID: <20130225211103.GA13510@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard@nod.at>
Cc: ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at

On Mon, Feb 25, 2013 at 09:33:34PM +0100, Richard Weinberger wrote:
> Today I encountered the following problem on v3.8:
> [   28.940032] general protection fault: 0000 [#1] PREEMPT SMP
> ...
> [   28.984953] Call Trace:
> [   28.986628   [<ffffffffa04cb200>] ocfs2_fast_symlink_readpage+0x70/0x1b0 [ocfs2]
> [   28.988302]  [<ffffffff8110dc49>] ? add_to_page_cache_lru+0x29/0x40
> [   28.989942]  [<ffffffff8110ddca>] do_read_cache_page+0x7a/0x170
> [   28.991573]  [<ffffffff8110def4>] read_cache_page_async+0x14/0x20
> [   28.993212]  [<ffffffff8110df09>] read_cache_page+0x9/0x20
> [   28.994827]  [<ffffffff81170ae5>] page_getlink.isra.9+0x25/0x80
> [   28.996442]  [<ffffffff81170b61>] page_follow_link_light+0x21/0x40
> [   28.998049]  [<ffffffff8117090d>] generic_readlink+0x3d/0xa0
> [   28.999653]  [<ffffffff8116c0db>] sys_readlinkat+0xfb/0x130
> [   29.001246]  [<ffffffff8116c126>] sys_readlink+0x16/0x20
> [   29.002839]  [<ffffffff815d8dad>] system_call_fastpath+0x1a/0x1f

I've seen that patch actually and yes it should have been in mainline
already. I didn't see whether it's in -mm (Andrew is pickup up some of the
patches for us right now).

I'll check and if it's not I'll try to send him a version of it today.
	--Mark

--
Mark Fasheh
