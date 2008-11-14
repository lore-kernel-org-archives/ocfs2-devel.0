From: David Teigland <teigland@redhat.com>
Date: Fri, 14 Nov 2008 11:25:30 -0600
Subject: [Ocfs2-devel] [Cluster-devel] [RFC] Splitting cluster.git into
	separate projects/trees
In-Reply-To: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
References: <1226654293.4022.56.camel@daitarn-fedora.int.fabbione.net>
Message-ID: <20081114172530.GB4054@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 14, 2008 at 10:18:13AM +0100, Fabio M. Di Nitto wrote:
> At this point we haven't really settled how many (sub) project will be
> created out of this split. This will come once we agree how to split.

I like the third option as long as the number of new git trees doesn't
explode (obviously no one wants 10 new git trees.)  Not to get ahead of
you, but for my own curiosity I looked at what minimum number of git trees
I'd have to start juggling... it's not too bad, but more than this might
get out of hand.

dlm.git:
  libdlm, dlm_controld, libdlmcontrol, dlm_tool

fence.git:
  libfence, fenced, libfenced, fence_tool, fence_node

fence-agents.git:
  <lots>

cman.git:
  libcman, cman_tool, cmannotifyd, qdiskd, mkqdisk
  cluster/config/*
  move plugins into corosync tree?
  group_tool (groupd/libgroup won't exist, group_tool will just be a
  wrapper/shortcut for fence_tool/dlm_tool/gfs_control queries;
  maybe include queries of other related daemons, like ocfs2_controld?)

gfs2-utils.git:
  gfs_controld, libgfscontrol, gfs_control
  mount.gfs2, mount.gfs, libgfs, libgfs2
  gfs_debug, gfs_fsck, gfs_grow, gfs_jadd, gfs_mkfs, gfs_quota, gfs_tool
  gfs2_convert, gfs2_edit, gfs2_fsck, gfs2_mkfs, gfs2_quota, gfs2_tool

gfs-kernel.git:
  gfs.ko

rgmanager.git:

gnbd goes away
cmirror moves away
