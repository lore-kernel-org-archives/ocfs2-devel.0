From: David Teigland <teigland@redhat.com>
Date: Wed, 10 Feb 2010 14:35:27 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <4B73155C.2000602@oracle.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
	<4B73155C.2000602@oracle.com>
Message-ID: <20100210203527.GB5062@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 10, 2010 at 12:21:48PM -0800, Sunil Mushran wrote:
> >(7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> >M000000000000000003f00400000000, convert from 0 to 3
> >Feb 10 13:19:39 bull-01 kernel: 
> >(7211,0,dlm_astd):ocfs2_blocking_ast:1061 BAST fired for lockres 
> >M000000000000000003f00400000000, blocking 5, level 0 type Meta
> >Feb 10 13:19:39 bull-01 kernel: 
> >(7211,0,dlm_astd):ocfs2_generic_handle_bast:934 lockres 
> >M000000000000000003f00400000000, block 5, level 0, l_block 5, dwn 0
> >Feb 10 13:19:39 bull-01 kernel: 
> >(7211,0,dlm_astd):ocfs2_locking_ast:1106 lock 
> >M000000000000000003f00400000000, action 2, unlock 0, level 0, newlevel 3
> >Feb 10 13:19:39 bull-01 kernel: 
> >(7258,3,alternate):__ocfs2_cluster_lock:1426 lock 
> >M000000000000000003f00400000000, convert from 3 to 5
> 
> So it requests NL => PR. It gets a BAST with blocking EX
> before the AST for PR. The last patch added changed the
> BAST handling to not schedule the downconvert thread if
> the current lock level was compatible. In this case, because
> the BAST is before the AST, the lock level is still NL.
> 
> One fix would be to take l_requested also into account.
> As in, schedule the dc thread if the current or the requested
> lock level is incompat.
> 
> But this should be a fsdlm bug. Why is it sending a BAST
> before the AST? If we do look at the requested lock level and
> do schedule the down convert thread, we are just buying a
> little more time for the AST. That's it. The problem from the
> glue side is that we are expected to handle multiple BASTs.
> The last patch made it ignore a BAST that was sent after a
> AST for a drop lock. I'm wondering whether we can sanely handle
> this in glue.
> 
> Thoughts?

It does sounds suspicious on the dlm side, I'll look into it.
Dave
