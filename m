From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 26 Apr 2006 11:06:00 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <p73odyp7z8n.fsf@bragg.suse.de>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<p73odyp7z8n.fsf@bragg.suse.de>
Message-ID: <20060426180600.GJ10524@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Apr 26, 2006 at 06:11:04AM +0200, Andi Kleen wrote:
> Won't you get into deadlocks then when the system is low on memory?
> (freeing memory might require write outs on OCFS2 and the user space
> cluster might be stuck already)
> 
> Or rather if you rely on user space you would need to make sure
> that the basic block write out path works without such possible
> deadlocks.
The DLM certainly wouldn't be in userspace - there's also a convincing
performance argument for it being in kernel.

Primarily then I think we're worred about that in the context of something
like heartbeat. In that case, we probably want something that can do it's
work within some preallocated, mlock'd area. I'm not sure (yet) how the
various stacks handle this problem, or even if they do. I need to think
about membership software. I want to say that I don't think this would be an
issue there, but I have a feeling I could concoct a case during node
recovery.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
