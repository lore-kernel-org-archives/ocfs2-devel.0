From: Daniel Phillips <phillips@redhat.com>
Date: Fri Jul 22 15:54:04 2005
Subject: [Linux-cluster] Re: [Ocfs2-devel] [RFC] nodemanager, ocfs2, dlm
In-Reply-To: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
References: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
Message-ID: <200507221322.16706.phillips@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-cluster@redhat.com
Cc: "Walker, Bruce J (HP-Labs)" <bruce.walker@hp.com>, David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, clusters_sig@lists.osdl.org

On Thursday 21 July 2005 02:55, Walker, Bruce J (HP-Labs) wrote:
> Like Lars, I too was under the wrong impression about this configfs
> "nodemanager" kernel component.  Our discussions in the cluster meeting
> Monday and Tuesday were assuming it was a general service that other
> kernel components could/would utilize and possibly also something that
> could send uevents to non-kernel components wanting a std. way to see
> membership information/events.
>
> As to kernel components without corresponding user-level "managers", look
> no farther than OpenSSI.  Our hope was that we could adapt to a user-land
> membership service and this interface thru configfs would drive all our
> kernel subsystems.

Guys, it is absolutely stupid to rely on a virtual filesystem for 
userspace/kernel communication for any events that might have to be 
transmitted inside the block IO path.  This includes, among other things, 
memberhips events.  Inserting a virtual filesystem into this path does 
nothing but add long call chains and new, hard-to-characterize memory 
usage.

There are already tried-and-true interfaces that are designed to do this 
kind of job efficiently and with quantifiable resource requirements: 
sockets (UNIX domain or netlink) and ioctls.  If you want to layer a 
virtual filesystem on top as a user friendly way to present current cluster 
configuration or as a way to provide some administrator knobs, then fine, 
virtual filesystems are good for this kind of thing.  But please do not try 
to insinuate that bloat into the block IO path.

Regards,

Daniel
