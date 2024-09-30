Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667C41A0BC7
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727254; cv=none; b=ZYrUgsKy47F0gLtJo0qXy4mh9SCD4KxxfqBLh0TaNavOU5F0L2UogaIma1T1aJVtg9crerSLIxjts01pJLmT3I3JqzfV7TkKsmK36zA1ZFX+XGnuKtRp0YvS5cOKt0EChg7NfA0m1CnDo7uvu5AsUX1XVgLH+SWCcxsGwmhCI8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727254; c=relaxed/simple;
	bh=Dl98yQSaJt7Lo8GSCpWs+NSnjuYZ3QakkNLz4aaqQd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FT6owebuz1WJO2oEm8vjhSBltHGO+8d7urqS93bN5cAoIHip/9yhw9zKtYp8NPHKlJ6iASpUK3vF+9qeYI3EZUDqXEV/F/67wz36c+Su9MQYHQBhuh8qN1ubaEqXxkIG9up5rq9McnE/SYLVof42cN3xAUy4AjkXhDQDvDhyQm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2vkU33j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2vkU33j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F9G29mhnObs+xsbD9UFjgj7PmnL5CbB/d5ihcQWmydI=;
	b=L2vkU33jnGRmDeiudY3jppEWid3ZEEnwnl+T/CADPVLTD4G52nD5GUfwzHgKfMpaRdfZrb
	RpbB/nXMbyzaJDoTkChPXWFpy3z+bC5p3YDtVgSJfn5PTzUk7gzh6cTORXFEfR1cobOGhh
	1bTEA7eaYfIwh9/ah3kIWdxY435UFgY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214--MA1yQvBPPevx7c2V0WgWg-1; Mon,
 30 Sep 2024 16:14:08 -0400
X-MC-Unique: -MA1yQvBPPevx7c2V0WgWg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0EB1196A111;
	Mon, 30 Sep 2024 20:14:05 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00C881955DC7;
	Mon, 30 Sep 2024 20:14:01 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
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
	donald.hunter@gmail.com,
	aahringo@redhat.com
Subject: [PATCHv2 dlm/next 00/12] dlm: net-namespace functionality
Date: Mon, 30 Sep 2024 16:13:46 -0400
Message-ID: <20240930201358.2638665-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi,

this patch-series is huge but brings a lot of basic "fun" net-namespace
functionality to DLM. Currently you need a couple of Linux kernel
instances running in e.g. Virtual Machines. With this patch-series I
want to break out of this virtual machine world dealing with multiple
kernels need to boot them all individually, etc. Now you can use DLM in
only one Linux kernel instance and each "node" (previously represented
by a virtual machine) is separate by a net-namespace. Why
net-namespaces? It just fits to the DLM design for now, you need to have
them anyway because the internal DLM socket handling on a per node
basis. What we do additionally is to separate the DLM lockspaces (the
lockspace that is being registered) by net-namespaces as this represents
a "network entity" (node). There might be reasons to introduce a
complete new kind of namespaces (locking namespace?) but I don't want to
do this step now and as I said net-namespaces are required anyway for
the DLM sockets.

You need some new user space tooling as a new netlink net-namespace
aware UAPI is introduced (but can co-exist with configfs that operates
on init_net only). See [0] for more steps, there is a copr repo for the
new tooling and can be enabled by:

$ dnf copr enable aring/nldlm
$ dnf install nldlm

or compile it yourself.

Then there is currently a very simple script [1] to show a 3 nodes cluster
using gfs2 on a multiple loop block devices on a shared loop block device
image (sounds weird but I do something like that). There are currently
some user space synchronization issues that I solve by simple sleeps,
but they are only user space problems.

To test it I recommend some virtual machine "but only one" and run the
[1] script. Afterwards you have in your executed net-namespace the 3
mountpoints /cluster/node1, /cluster/node2/ and /cluster/node3. Any vfs
operations on those mountpoints acts as a per node entity operation.

We can use it for testing, development and also scale testing to have a
large number of nodes joining a lockspace (which seems to be a problem
right now). Instead of running 1000 vms, we can run 1000 net-namespaces
in a more resource limited environment. For me it seems gfs2 can handle
several mounts and still separate the resource according their global
variables. Their data structures e.g. glock hash seems to have in their
key a separation for that (fsid?). However this is still an experimental
feature we might run into issues that requires more separation related
to net-namespaces. However basic testing seems to run just fine.

Limitations

I disable any functionality for the DLM character device that allow
plock handling or do DLM locking from user space. Just don't use any
plock locking in gfs2 for now. But basic vfs operations should work. You
can even sniff DLM traffic on the created "dlmsw" virtual bridge.

- Alex

[0] https://gitlab.com/netcoder/nldlm
[1] https://gitlab.com/netcoder/gfs2ns-examples/-/blob/main/three_nodes

changes since v2:
 - move to ynl and introduce and use netlink yaml spec
 - put the nldlm.h DLM netlink header under UAPI directory
 - fix build issues building with CONFIG_NET disabled
 - fix possible nullpointer deference if lookup of lockspace failed

Alexander Aring (12):
  dlm: introduce dlm_find_lockspace_name()
  dlm: disallow different configs nodeid storages
  dlm: add struct net to dlm_new_lockspace()
  dlm: handle port as __be16 network byte order
  dlm: use dlm_config as only cluster configuration
  dlm: dlm_config_info config fields to unsigned int
  dlm: rename config to configfs
  kobject: add kset_type_create_and_add() helper
  kobject: export generic helper ops
  dlm: separate dlm lockspaces per net-namespace
  dlm: add nldlm net-namespace aware UAPI
  gfs2: separate mount context by net-namespaces

 Documentation/netlink/specs/nldlm.yaml |  438 ++++++++
 drivers/md/md-cluster.c                |    3 +-
 fs/dlm/Makefile                        |    3 +
 fs/dlm/config.c                        | 1291 +++++++++--------------
 fs/dlm/config.h                        |  215 +++-
 fs/dlm/configfs.c                      |  882 ++++++++++++++++
 fs/dlm/configfs.h                      |   19 +
 fs/dlm/debug_fs.c                      |   24 +-
 fs/dlm/dir.c                           |    4 +-
 fs/dlm/dlm_internal.h                  |   24 +-
 fs/dlm/lock.c                          |   64 +-
 fs/dlm/lock.h                          |    3 +-
 fs/dlm/lockspace.c                     |  220 ++--
 fs/dlm/lockspace.h                     |   12 +-
 fs/dlm/lowcomms.c                      |  525 +++++-----
 fs/dlm/lowcomms.h                      |   29 +-
 fs/dlm/main.c                          |    5 -
 fs/dlm/member.c                        |   36 +-
 fs/dlm/midcomms.c                      |  287 ++---
 fs/dlm/midcomms.h                      |   31 +-
 fs/dlm/netlink2.c                      | 1330 ++++++++++++++++++++++++
 fs/dlm/nldlm-kernel.c                  |  290 ++++++
 fs/dlm/nldlm-kernel.h                  |   50 +
 fs/dlm/nldlm.c                         |  847 +++++++++++++++
 fs/dlm/plock.c                         |    2 +-
 fs/dlm/rcom.c                          |   16 +-
 fs/dlm/rcom.h                          |    3 +-
 fs/dlm/recover.c                       |   17 +-
 fs/dlm/user.c                          |   63 +-
 fs/dlm/user.h                          |    2 +-
 fs/gfs2/glock.c                        |    8 +
 fs/gfs2/incore.h                       |    2 +
 fs/gfs2/lock_dlm.c                     |    6 +-
 fs/gfs2/ops_fstype.c                   |    5 +
 fs/gfs2/sys.c                          |   35 +-
 fs/ocfs2/stack_user.c                  |    2 +-
 include/linux/dlm.h                    |    9 +-
 include/linux/kobject.h                |   10 +-
 include/uapi/linux/nldlm.h             |  153 +++
 lib/kobject.c                          |   65 +-
 40 files changed, 5566 insertions(+), 1464 deletions(-)
 create mode 100644 Documentation/netlink/specs/nldlm.yaml
 create mode 100644 fs/dlm/configfs.c
 create mode 100644 fs/dlm/configfs.h
 create mode 100644 fs/dlm/netlink2.c
 create mode 100644 fs/dlm/nldlm-kernel.c
 create mode 100644 fs/dlm/nldlm-kernel.h
 create mode 100644 fs/dlm/nldlm.c
 create mode 100644 include/uapi/linux/nldlm.h

-- 
2.43.0

