From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Tue Mar 16 14:26:32 2004
Subject: [Ocfs2-devel] Re: Revision 559 of ocfs2/src/inc/io.h
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0E3DD6@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0E3DD6@orsmsx410.jf.intel.com>
Message-ID: <20040316202627.GA21259@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

John,

This makes a little more sense if you take a look at the related changes
over in hash.c and the change to the prototype of ocfs_bh_sem_lock_modify
in proto.h.  This is one of those instances where you absolutely require
a macro in order to get at the __FUNCTION__, __FILE__ and __LINE__
preprocessor magic.  

The problem we were trying to solve here was that we were hitting a lot
of deadlocking on the bh semaphore locks.  I added in a field that could
be compiled out in the final release (because it bloats the structure)
to stick the original "modifier" of this buffer head into that char *.
Then when another process comes along as a waiter on that lock and
notices the likely deadlock, he will print out the modifier and his own
line number, getting right to the deadlock on the first try.  

In this case if I didn't make OCFS_BH_GET_DATA_WRITE a macro also, then
the modifier would always come up as something like 
"OCFS_BH_GET_DATA_WRITE:inc/io.h:146".  Not too helpful ;-)

So if you ever seem to hit real deadlocks (not just a deadlock warning,
but the warning plus one or more processes permanently stuck in D state)
just turn on -DBH_SEM_DEBUG and try again.

Thanks!
-kurt

On Tue, Mar 16, 2004 at 11:41:58AM -0800, Villalovos, John L wrote:
> Kurt,
> 
> I had a question about your Revision 559 of ocfs2/src/inc/io.h.
> 
> I was trying to figure out the purpose of converting the function into a
> macro and putting it in the #ifdef.
> 
> The two functions seem identical except the one in the DEBUG section
> does not do a printk.
> 
> Looking at it I can't really see a reason for the macro.
> 
> So I was wondering if you could tell me what I am missing in
> understanding it?
> 
> Thanks,
> John
