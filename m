From: Walker, Bruce J (HP-Labs) <bruce.walker@hp.com>
Date: Fri Jul 22 15:54:04 2005
Subject: [Linux-cluster] Re: [Ocfs2-devel] [RFC] nodemanager, ocfs2, dlm
Message-ID: <3689AF909D816446BA505D21F1461AE404167CFB@cacexc04.americas.cpqcorp.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux clustering <linux-cluster@redhat.com>, David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, clusters_sig@lists.osdl.org

Like Lars, I too was under the wrong impression about this configfs "nodemanager" kernel component.  Our discussions in the cluster meeting Monday and Tuesday were assuming it was a general service that other kernel components could/would utilize and possibly also something that could send uevents to non-kernel components wanting a std. way to see membership information/events.

As to kernel components without corresponding user-level "managers", look no farther than OpenSSI.  Our hope was that we could adapt to a user-land membership service and this interface thru configfs would drive all our kernel subsystems.

Bruce Walker
OpenSSI Cluster project
 

-----Original Message-----
From: linux-cluster-bounces@redhat.com [mailto:linux-cluster-bounces@redhat.com] On Behalf Of Lars Marowsky-Bree
Sent: Wednesday, July 20, 2005 9:27 AM
To: David Teigland
Cc: linux-cluster@redhat.com; linux-kernel@vger.kernel.org; ocfs2-devel@oss.oracle.com
Subject: [Linux-cluster] Re: [Ocfs2-devel] [RFC] nodemanager, ocfs2, dlm

On 2005-07-20T11:35:46, David Teigland <teigland@redhat.com> wrote:

> > Also, eventually we obviously need to have state for the nodes - 
> > up/down et cetera. I think the node manager also ought to track this.
> We don't have a need for that information yet; I'm hoping we won't 
> ever need it in the kernel, but we'll see.

Hm, I'm thinking a service might have a good reason to want to know the possible list of nodes as opposed to the currently active membership; though the DLM as the service in question right now does not appear to need such.

But, see below.

> There are at least two ways to handle this:
> 
> 1. Pass cluster events and data into the kernel (this sounds like what 
> you're talking about above), notify the effected kernel components, 
> each kernel component takes the cluster data and does whatever it 
> needs to with it (internal adjustments, recovery, etc).
> 
> 2. Each kernel component "foo-kernel" has an associated user space 
> component "foo-user".  Cluster events (from userland clustering
> infrastructure) are passed to foo-user -- not into the kernel.  
> foo-user determines what the specific consequences are for foo-kernel.  
> foo-user then manipulates foo-kernel accordingly, through user/kernel 
> hooks (sysfs, configfs, etc).  These control hooks would largely be specific to foo.
> 
> We're following option 2 with the dlm and gfs and have been for quite 
> a while, which means we don't need 1.  I think ocfs2 is moving that 
> way, too.  Someone could still try 1, of course, but it would be of no 
> use or interest to me.  I'm not aware of any actual projects pushing 
> forward with something like 1, so the persistent reference to it is somewhat baffling.

Right. I thought that the node manager changes for generalizing it where pushing into sort-of direction 1. Thanks for clearing this up.



Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

--
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

--
Linux-cluster mailing list
Linux-cluster@redhat.com
http://www.redhat.com/mailman/listinfo/linux-cluster
