From: Daniel Phillips <phillips@google.com>
Date: Wed, 26 Apr 2006 11:34:12 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <200604262008.06346.ak@suse.de>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>	<p73odyp7z8n.fsf@bragg.suse.de>	<20060426180600.GJ10524@ca-server1.us.oracle.com>
	<200604262008.06346.ak@suse.de>
Message-ID: <444FBD24.4090403@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Andi Kleen wrote:
> On Wednesday 26 April 2006 20:06, Mark Fasheh wrote:
>>On Wed, Apr 26, 2006 at 06:11:04AM +0200, Andi Kleen wrote:
>>
>>>Won't you get into deadlocks then when the system is low on memory?
>>>(freeing memory might require write outs on OCFS2 and the user space
>>>cluster might be stuck already)
>>>
>>>Or rather if you rely on user space you would need to make sure
>>>that the basic block write out path works without such possible
>>>deadlocks.
>>
>>The DLM certainly wouldn't be in userspace - there's also a convincing
>>performance argument for it being in kernel.
>>
>>Primarily then I think we're worred about that in the context of something
>>like heartbeat. In that case, we probably want something that can do it's
>>work within some preallocated, mlock'd area. 
> 
> That's not enough - it wouldn't be able to do anything that requires
> memory allocation in the critical path. This includes most system calls.

Indeed.  In general, what we have to do is give such a userspace process
access to the PF_MEMALLOC reserve, simply by setting that flag.  This
introduces a requirement to audit tasks's memory usage, but this isn't
different from what we have to do in kernel anyway.

So we can do this if we want to, but it isn't clear to me why we want
heartbeat in userspace.

Advantages for heartbeat in kernel:

   * Easier to manage reserve memory
   * No memlock requirement
   * Can act on heartbeat timeout with higher precision, possibly
     hard realtime precision

Disadvantages:

   * Handling heartbeat timeout looks a lot like policy
   * Need to invent a mechanism for communicating with userspace
     helpers

I am biased towards heartbeat in kernel, but the issues really need to be
talked out in detail.  The ground rule is that *everything* that can
execute in the block writeout path has to have access to reserve memory.
This includes everything in the failover path, fencing for example.

Regards,

Daniel
