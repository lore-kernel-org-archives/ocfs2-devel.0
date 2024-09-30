Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DADC1925A2;
	Mon, 30 Sep 2024 20:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727729346; cv=none; b=URcqlpaR6AtbFZk+TDchAEGRhm8E6FiZCWK0azG8PmgJchhYXnSLS0jGAWHdRK7gvXwepC+8ZuQ/lbOR3DTLoeBwQ9nKv0pE6bqHMu6V6cCQ7ft3kCH2FLAyYCAOGK3CR2BIvuoJlboaLjlcXZAwUfFSKhCgZH+gkvY8o4t4bCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727729346; c=relaxed/simple;
	bh=YaHjeiBRe/nFirwisSZ35F2Hti7+Kk06tqfCivehidw=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=XtQQ7XGnJTl174ua2T4hKLxxPuguG+faX1Am0f0i9BwNo/Sd259VNaGT4ZKm+1QK2TIjEkT9pDrf28+gPcbOnHbQnbZjgYg1ubv814tJIDrJEVp5GMn3Ibv9jiZmpM5XQh6a8BBYPSyEmtlxeW1KOn+5k9VhqyHMoq5hEaTcMiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 50FEF1E1AF;
	Mon, 30 Sep 2024 16:39:06 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 04FA2A09C4; Mon, 30 Sep 2024 16:39:05 -0400 (EDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26363.3177.994264.260348@quad.stoffel.home>
Date: Mon, 30 Sep 2024 16:39:05 -0400
From: "John Stoffel" <john@stoffel.org>
To: Alexander Aring <aahringo@redhat.com>
Cc: teigland@redhat.com,
    gfs2@lists.linux.dev,
    song@kernel.org,
    yukuai3@huawei.com,
    agruenba@redhat.com,
    mark@fasheh.com,
    jlbec@evilplan.org,
    joseph.qi@linux.alibaba.com,
    gregkh@linuxfoundation.org,
    rafael@kernel.org,
    akpm@linux-foundation.org,
    linux-kernel@vger.kernel.org,
    linux-raid@vger.kernel.org,
    ocfs2-devel@lists.linux.dev,
    netdev@vger.kernel.org,
    vvidic@valentin-vidic.from.hr,
    heming.zhao@suse.com,
    lucien.xin@gmail.com,
    donald.hunter@gmail.com
Subject: Re: [PATCHv2 dlm/next 00/12] dlm: net-namespace functionality
In-Reply-To: <20240930201358.2638665-1-aahringo@redhat.com>
References: <20240930201358.2638665-1-aahringo@redhat.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Alexander" == Alexander Aring <aahringo@redhat.com> writes:

> Hi,
> this patch-series is huge but brings a lot of basic "fun" net-namespace
> functionality to DLM. Currently you need a couple of Linux kernel

Please spell out TLAs like DLM the first time you use them.  In this
case I'm suer you mean Distributed Lock Manager, right?  

> instances running in e.g. Virtual Machines. With this patch-series I
> want to break out of this virtual machine world dealing with multiple
> kernels need to boot them all individually, etc. Now you can use DLM in
> only one Linux kernel instance and each "node" (previously represented
> by a virtual machine) is separate by a net-namespace. Why
> net-namespaces? It just fits to the DLM design for now, you need to have
> them anyway because the internal DLM socket handling on a per node
> basis. What we do additionally is to separate the DLM lockspaces (the
> lockspace that is being registered) by net-namespaces as this represents
> a "network entity" (node). There might be reasons to introduce a
> complete new kind of namespaces (locking namespace?) but I don't want to
> do this step now and as I said net-namespaces are required anyway for
> the DLM sockets.

This section needs to be re-written to more clearly explain what
you're trying to accomplish here, and how this is different or better
than what went before.  I realize you probably have this knowledge all
internalized, but spelling it out in a clear and simple manner would
be helpful to everyone.  

> You need some new user space tooling as a new netlink net-namespace
> aware UAPI is introduced (but can co-exist with configfs that operates
> on init_net only). See [0] for more steps, there is a copr repo for the
> new tooling and can be enabled by:

What the heck is a 'copr'?   


> $ dnf copr enable aring/nldlm
> $ dnf install nldlm

> or compile it yourself.

These steps really entirely ignore the _why_ you would do this.  And
assume RedHad based systems.

> Then there is currently a very simple script [1] to show a 3 nodes cluster

nit: 3 node cluster

> using gfs2 on a multiple loop block devices on a shared loop block device
> image (sounds weird but I do something like that). There are currently
> some user space synchronization issues that I solve by simple sleeps,
> but they are only user space problems.

Can you give the example on how to do this setup?  Ideally in another
patch which updates the Documentation/??? file to in the kernel tree.

> To test it I recommend some virtual machine "but only one" and run the

I'm having a hard time parsing this, please be more careful with
singular or plural usage.  English is hard!  :-)

> [1] script. Afterwards you have in your executed net-namespace the 3
> mountpoints /cluster/node1, /cluster/node2/ and /cluster/node3. Any vfs
> operations on those mountpoints acts as a per node entity operation.

Which means what?  So if I write to /cluster/node1/foo, it shows up in
the other two mount points?  Or do I need to create a filesystem on
top?   

> We can use it for testing, development and also scale testing to have a
> large number of nodes joining a lockspace (which seems to be a problem
> right now). Instead of running 1000 vms, we can run 1000 net-namespaces
> in a more resource limited environment. For me it seems gfs2 can handle
> several mounts and still separate the resource according their global
> variables. Their data structures e.g. glock hash seems to have in their
> key a separation for that (fsid?). However this is still an experimental
> feature we might run into issues that requires more separation related
> to net-namespaces. However basic testing seems to run just fine.

So is this all just to make testing and development easier so you
don't need 10 or 1000 nodes to do stress testing?  Would anyone use
this in real life?  

> Limitations

> I disable any functionality for the DLM character device that allow
> plock handling or do DLM locking from user space. Just don't use any
> plock locking in gfs2 for now. But basic vfs operations should work. You
> can even sniff DLM traffic on the created "dlmsw" virtual bridge.

So... what functionality is exposed by this patchset?  And Maybe add
in an "Advantages" section to explain why this is so good.  

Thanks!
John


> - Alex

> [0] https://gitlab.com/netcoder/nldlm
> [1] https://gitlab.com/netcoder/gfs2ns-examples/-/blob/main/three_nodes

> changes since v2:
>  - move to ynl and introduce and use netlink yaml spec
>  - put the nldlm.h DLM netlink header under UAPI directory
>  - fix build issues building with CONFIG_NET disabled
>  - fix possible nullpointer deference if lookup of lockspace failed

> Alexander Aring (12):
>   dlm: introduce dlm_find_lockspace_name()
>   dlm: disallow different configs nodeid storages
>   dlm: add struct net to dlm_new_lockspace()
>   dlm: handle port as __be16 network byte order
>   dlm: use dlm_config as only cluster configuration
>   dlm: dlm_config_info config fields to unsigned int
>   dlm: rename config to configfs
>   kobject: add kset_type_create_and_add() helper
>   kobject: export generic helper ops
>   dlm: separate dlm lockspaces per net-namespace
>   dlm: add nldlm net-namespace aware UAPI
>   gfs2: separate mount context by net-namespaces

>  Documentation/netlink/specs/nldlm.yaml |  438 ++++++++
>  drivers/md/md-cluster.c                |    3 +-
>  fs/dlm/Makefile                        |    3 +
>  fs/dlm/config.c                        | 1291 +++++++++--------------
>  fs/dlm/config.h                        |  215 +++-
>  fs/dlm/configfs.c                      |  882 ++++++++++++++++
>  fs/dlm/configfs.h                      |   19 +
>  fs/dlm/debug_fs.c                      |   24 +-
>  fs/dlm/dir.c                           |    4 +-
>  fs/dlm/dlm_internal.h                  |   24 +-
>  fs/dlm/lock.c                          |   64 +-
>  fs/dlm/lock.h                          |    3 +-
>  fs/dlm/lockspace.c                     |  220 ++--
>  fs/dlm/lockspace.h                     |   12 +-
>  fs/dlm/lowcomms.c                      |  525 +++++-----
>  fs/dlm/lowcomms.h                      |   29 +-
>  fs/dlm/main.c                          |    5 -
>  fs/dlm/member.c                        |   36 +-
>  fs/dlm/midcomms.c                      |  287 ++---
>  fs/dlm/midcomms.h                      |   31 +-
>  fs/dlm/netlink2.c                      | 1330 ++++++++++++++++++++++++
>  fs/dlm/nldlm-kernel.c                  |  290 ++++++
>  fs/dlm/nldlm-kernel.h                  |   50 +
>  fs/dlm/nldlm.c                         |  847 +++++++++++++++
>  fs/dlm/plock.c                         |    2 +-
>  fs/dlm/rcom.c                          |   16 +-
>  fs/dlm/rcom.h                          |    3 +-
>  fs/dlm/recover.c                       |   17 +-
>  fs/dlm/user.c                          |   63 +-
>  fs/dlm/user.h                          |    2 +-
>  fs/gfs2/glock.c                        |    8 +
>  fs/gfs2/incore.h                       |    2 +
>  fs/gfs2/lock_dlm.c                     |    6 +-
>  fs/gfs2/ops_fstype.c                   |    5 +
>  fs/gfs2/sys.c                          |   35 +-
>  fs/ocfs2/stack_user.c                  |    2 +-
>  include/linux/dlm.h                    |    9 +-
>  include/linux/kobject.h                |   10 +-
>  include/uapi/linux/nldlm.h             |  153 +++
>  lib/kobject.c                          |   65 +-
>  40 files changed, 5566 insertions(+), 1464 deletions(-)
>  create mode 100644 Documentation/netlink/specs/nldlm.yaml
>  create mode 100644 fs/dlm/configfs.c
>  create mode 100644 fs/dlm/configfs.h
>  create mode 100644 fs/dlm/netlink2.c
>  create mode 100644 fs/dlm/nldlm-kernel.c
>  create mode 100644 fs/dlm/nldlm-kernel.h
>  create mode 100644 fs/dlm/nldlm.c
>  create mode 100644 include/uapi/linux/nldlm.h

> -- 
> 2.43.0


