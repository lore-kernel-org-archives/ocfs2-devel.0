From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 9 Jan 2006 20:29:59 -0800
Subject: [Ocfs2-devel] [PATCH 00/11] ocfs2: implement userspace
	clustering interface
In-Reply-To: <20060109223942.GA8721@locomotive.unixthugs.org>
References: <20060109223942.GA8721@locomotive.unixthugs.org>
Message-ID: <20060110042959.GJ3313@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,
	Thanks for sending all these patches out. Once patch 3 is in the
mailman moderation queue, I'll be sure to let it through - last time was my
fault as I accidentally deleted it along with the millions of spam messages
that got caught in there. I'll start with some higher level commentary while
I try to absorb the patchset :) More commentary will come later for sure.

To get the most nit-picky request out of the way, I noticed that many of the
functions you add (including file system functions) don't have a prefix.
It'd be nice if you could keep that consistent with the rest of the code in
their respective files.

On to more important things:

I'm a bit worried about the new methods for querying heartbeat information,
specifically that things are jumping from all heartbeat status being global
(in the sense that it's collated into one giant map) to it being specific to
a given region. Things like the dlm domain joining code have expected it to
be global for some time now. Tcp had a similar assumption which you had to
fix in patch #8. Of course there, it was easy to work around. I need to
think more on this. Things might actually be ok, but it's not something I
expected to change.

Is there any userspace source available that makes use of this yet? Hmm, I
see that you sent a description of what's required from userspace. Perhaps
that'll answer some more questions :)
	--Mark

On Mon, Jan 09, 2006 at 05:39:42PM -0500, Jeff Mahoney wrote:
> 
> Hello all -
> 
> As mentioned in my last email, here are my patches for implementing a userspace
> clustering interface.
> 
> These should be considered early beta, but I very much welcome comment.
> 
> A quick preview:
> 01 - event driven quorum: o2net will no longer call into quorum
>      directly, but rather generate events that quorum will hook into.
>      Unfortunately, I've run into a bit of a snag with this since there
>      are two places where recursive events can be generated (ie: a
>      connection event generated when handling a node up/down event) and
>      that causes deadlocks on the o2hb_callback_sem. This is really
>      the only patch the entire series is waiting on sorting out.
> 02 - introduce generic heartbeat resource: initially, this will
>      just contain a config_item and will replace the config_item
>      in o2hb_region. Eventually, it will be used as a handle for a
>      generic heartbeat resource, including several operations.
> 03 - split disk heartbeat out from the generic heartbeat: They'll still
>      be closely tied, but going their separate ways. This patch
>      intentionally does very little other than move code around without
>      modifying it.
> 04 - add a heartbeat registration API: This expands the generic
>      heartbeat group structure to include the type information as well
>      as a few operations necessary to abstract the heartbeat resource.
>      In addition, it adds a mechanism for registering a group mode. It
>      uses the first mode loaded. Since disk is the only mode at this
>      point, there is no way to switch. This will be added later.
> 05 - add per-resource events: callbacks can define that they only want
>      events from a particular heartbeat resource, and will only receive
>      events for those. This is useful for only sending the file system
>      the events from the heartbeat resource it's listening to.
> 06 - per-resource membership: fill_node_map can take a resource name
>      (UUID) to use for filling the membership bitmap passed in. If NULL
>      is passed, it uses a global up/down. No changes to the disk
>      heartbeat other than prototype changes are needed, since it still
>      keeps a global membership.
> 07 - o2net refcounted disconnect: Rather than disconnect when a node
>      down event is caught by o2net, it waits until the last reference
>      is dropped. This is useful for userspace heartbeat since it can
>      take down a disk resource but the network resource will still be
>      available.
> 08 - add check_node_status: The userspace heartbeat implementation
>      allows the caller to check on a per-node, per-resource basis if
>      a particular node is up. Building the global list is a bigger deal,
>      so when that is avoidable, it does so.
> 09 - add /sys/o2cb/heartbeat_mode: This patch allows the user to select
>      which mode heartbeat will use. It requires that the change be made
>      before the cluster is created.
> 10 - add userspace clustering: The real goal of all this. This will
>      allow the user to create heartbeat directories as before, but
>      rather than supplying disk information, it allows the user to
>      create symlinks to communicate the current node membership for
>      a given heartbeat group. Since configfs doesn't allow dangling
>      symlinks, this is an easy way to intuitively configure heartbeat
>      resources from userspace. Node UP events are generated when a link
>      is created and node DOWN events are generated when a link is
>      removed.
> 
> -Jeff
> 
> --
> Jeff Mahoney
> SUSE Labs
>  
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
