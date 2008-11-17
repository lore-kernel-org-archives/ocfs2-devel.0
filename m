From: Fabio M. Di Nitto <fdinitto@redhat.com>
Date: Mon, 17 Nov 2008 06:45:41 +0100
Subject: [Ocfs2-devel] [Cluster-devel] [RFC] Splitting cluster.git into
 separate projects/trees
In-Reply-To: <20081114172530.GB4054@redhat.com>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
	<20081114172530.GB4054@redhat.com>
Message-ID: <1226900741.2447.23.camel@daitarn-fedora.int.fabbione.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 2008-11-14 at 11:25 -0600, David Teigland wrote:
> On Fri, Nov 14, 2008 at 10:18:13AM +0100, Fabio M. Di Nitto wrote:
> > At this point we haven't really settled how many (sub) project will be
> > created out of this split. This will come once we agree how to split.
> 
> I like the third option as long as the number of new git trees doesn't
> explode (obviously no one wants 10 new git trees.)

Ok it looks like we all agree on splitting into different trees (option
three).

The main reason why I didn't want to suggest the trees is because I
don't have yet a full picture of what needs to be split.
Specially we have some circular build dependencies that will require
work for all of this to fit together properly and it's not clear to me
yet what is going to change or how.

I can't say yet how many trees there will be at the end of the process
but we are around 8/10.
On the other hand, I don't think anybody except me should really worry
about that. Your development focus will rarely span across more than 2/3
trees. You will get the other components as updates for your distro on a
regular base (using the OpenSUSE build service to provide "crack-of-day"
packages).

Maybe cluster.git master will turn into a simple set of Makefiles that
will just pull all the trees for you to build always the very latest
making transparent how many trees you are actually working on...

>   Not to get ahead of
> you, but for my own curiosity I looked at what minimum number of git trees
> I'd have to start juggling... it's not too bad, but more than this might
> get out of hand.

No worries :)

> 
> dlm.git:
>   libdlm, dlm_controld, libdlmcontrol, dlm_tool

+1

> 
> fence.git:
>   libfence, fenced, libfenced, fence_tool, fence_node

+1

> 
> fence-agents.git:
>   <lots>
> 

I want to keep this separated from fence related daemons. Agents are
very often updated for bug fixes and to support new firmware at a much
higher speed than the daemons.

> cman.git:
>   libcman, cman_tool, cmannotifyd, qdiskd, mkqdisk
>   cluster/config/*
>   move plugins into corosync tree?
>   group_tool (groupd/libgroup won't exist, group_tool will just be a
>   wrapper/shortcut for fence_tool/dlm_tool/gfs_control queries;
>   maybe include queries of other related daemons, like ocfs2_controld?)


We will need a cluster-infrastructure.git (*) tree that will contain all
the basic components. That would be all the cluster/config, init
scripts, liblogthread.

cman.git will contain libcman, cman_tool, cmannotifyd and possibly
group_tool as long as it can build without any of the includes from the
daemons it needs to query.

I am not entirely sure qdisk should live in cman.git. Maybe it's big
enough to live in its own tree by now.

(*) name to be defined ;)

> gfs2-utils.git:
>   gfs_controld, libgfscontrol, gfs_control
>   mount.gfs2, mount.gfs, libgfs, libgfs2
>   gfs_debug, gfs_fsck, gfs_grow, gfs_jadd, gfs_mkfs, gfs_quota, gfs_tool
>   gfs2_convert, gfs2_edit, gfs2_fsck, gfs2_mkfs, gfs2_quota, gfs2_tool
> 
> gfs-kernel.git:
>   gfs.ko

While I generally agree that kernel and userland should be separated, I
think gfs1 should live in one project and gfs2 in another one. With gfs1
including both userland and kernel.

gfs1 will be phased out sooner or later. easier to have it contained in
one place.

> rgmanager.git:

I haven't made up my mind on this one yet.

> gnbd goes away

indeed.

> cmirror moves away

this is already out of the tree from master.
