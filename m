From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 09 Feb 2010 13:49:12 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
 and an unlock ast message
In-Reply-To: <20100209205508.GF29766@redhat.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com> <20100205060148.GA3416@mail.oracle.com>
	<4B6C65F3.8000805@oracle.com>
	<20100205193313.GG11402@wotan.suse.de>
	<4B6CABA7.4020502@oracle.com> <20100209205508.GF29766@redhat.com>
Message-ID: <4B71D858.8050002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> BUG hit just five minutes after starting make_panic and alternate on four
> nodes.  (I can send history before this if you need.)
>

Feb 9 14:09:52 bull-05 kernel: (6983,0,dlm_astd):

ocfs2_locking_ast:1104 lock M000000000000000009732800000000, action 2, 
unlock 0, level 0, newlevel 5
ocfs2_unlock_ast:3075 UNLOCK AST called on lock 
M000000000000000009732800000000, action = 2 (DROP_LOCK)
ocfs2_blocking_ast:1059 BAST fired for lockres 
M000000000000000009732800000000, blocking 5, level -1 type Meta
ocfs2_generic_handle_bast:932 lockres M000000000000000009732800000000, 
block 5, level -1, l_block 5, dwn 1

Feb 9 14:09:52 bull-05 kernel: (7009,2,ocfs2dc):

ocfs2_process_blocked_lock:4004 lockres M000000000000000009732800000000 
blocked.
ocfs2_prepare_downconvert:3295 ERROR: lock 
M000000000000000009732800000000, lvl -1 <= 0, blcklst 1, mask 1, type 0, 
flags 0x104, h


So the BAST fires after the UNLOCK AST (DROP_LOCK). That is what
we thought.

Why does ocfs2_generic_handle_bast() not take into account the current
lockres->l_level?
