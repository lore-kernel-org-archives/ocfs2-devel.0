Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5D11D27B7
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Aug 2024 18:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781790; cv=none; b=nqKzOfntfRKunNVNIohSjdK/xICaMNh41FA49lmrsIIqW0Q8CxrqKddZAsvCinf3JKhTAVKK8tcLz+yd2PJO68NkCNIkGX6KUE3YF9hjlzCe30BjZISPuNLrjBER5v59h2Kz+d7rPwZ+SH9Gfi10J2uSWzfb3+2sppmUp24i/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781790; c=relaxed/simple;
	bh=oR96iOXx+rs3wrdkJBENkx2GGB/C+AMxImmsvKqiHvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T8dJ5eMGc/Rdmq2Z/H60vnTUKjvsa45JUYCB6IoKo+EqFacxIFET7RZuxBtSwiMjGfzDCPrp3VnLp+BehL6IZ5yATond7VQKljqoO2N6Z7ndXJ/qBcmIVKFoGtm919Egq8Ry++DqDYcZmRplviP+lOmS41OY7lXWXAmL0xAsyDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bHb07a7o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHb07a7o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724781786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p8/cxNE6VJvsneEbrGqWQbWsphVxB+ixn/SyQ/i73Rc=;
	b=bHb07a7oLhTnGDNDMXVvU61lKdn22+SEM0ks1WaK/DWhr5WVtQcdtgQja/EDBSAixjDENX
	pf097P0StQ0ewOVSNNcPjCCVZBjUSkxvWTDdVyIgxO1UlhYZ5wvK41lmbEfsg80iARloMp
	75cyLi5DbHtE3DcOKZQMHUq3Sr5iUjo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-x4bboJ_cMxOfXXcFMjZ1oA-1; Tue,
 27 Aug 2024 14:03:03 -0400
X-MC-Unique: x4bboJ_cMxOfXXcFMjZ1oA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8B2C1955D48;
	Tue, 27 Aug 2024 18:02:58 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EAE651955F1B;
	Tue, 27 Aug 2024 18:02:53 +0000 (UTC)
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
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	juri.lelli@redhat.com,
	williams@redhat.com,
	aahringo@redhat.com
Subject: [RFC 0/7] dlm: the ultimate verifier for DLM lock correctness
Date: Tue, 27 Aug 2024 14:02:29 -0400
Message-ID: <20240827180236.316946-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi,

I send this rfc patch series to show a (for me) usable use-case for the
DLM net-namespace functionality that is currently pending, see [0]. This
patch-series introduce the DLM verifier to check on DLM correctness on
any workload running on DLM with net-namespace feature. E.g. on gfs2 you
can just run some filesystem benchmark tests and see if DLM works as
aspected.

This comes very useful when DLM recovery kicks in e.g. when nodes
leaving the lockspace due e.g. fencing and recovery solves lock
dependencies transparently from the user. However there is no "fake
fencing switch" yet for DLM net-namespaces, but might be an idea for
future functionality.

There could be bugs in the verifier, that I don't care if they exists...
We need to check whats happening when the verifier complains but so far
everything looks fine. It just an issue if the verifier doesn't say
anything but a small bug introduced in DLM and the verifier will
complain a lot.

There might be still improvements in the DLM verifier. I needed to
change a little bit the python scripts to generate the code but I did
not add them here to this patch series. Also checkpatch complains about
some things in the verifier code but I oriented myself mostly to the
other existing verifiers. There is a printout of all holders if those
violates the DLM compatible locking states. I might improve them when I
actually try to figure out an existing problem, but for now this
printout is very minimal.

I mainly do this work because I prepare more changes in the DLM recovery
code in future to scale with lockspaces with a lot of members that we
can easily try out with the net-namespace functionality.

I cc here the rcu people, may they also get some ideas to check on lock
correctness using tracing kernel verifier subsystem.

- Alex

[0] https://lore.kernel.org/gfs2/20240814143414.1877505-1-aahringo@redhat.com/

Alexander Aring (7):
  dlm: fix possible lkb_resource null dereference
  dlm: fix swapped args sb_flags vs sb_status
  dlm: make add_to_waiters() that is can't fail
  dlm: add our_nodeid to tracepoints
  dlm: add lkb rv mode to ast tracepoint
  dlm: add more tracepoints for DLM kernel verifier
  rv: add dlm compatible lock state kernel verifier

 Documentation/trace/rv/monitor_dlm.rst |  77 +++++
 fs/dlm/ast.c                           |  30 +-
 fs/dlm/dlm_internal.h                  |   3 +
 fs/dlm/lock.c                          |  64 ++--
 fs/dlm/lockspace.c                     |   4 +
 fs/dlm/user.c                          |   9 +-
 include/trace/events/dlm.h             | 121 ++++++-
 include/trace/events/rv.h              |   9 +
 kernel/trace/rv/Kconfig                |  18 +
 kernel/trace/rv/Makefile               |   1 +
 kernel/trace/rv/monitors/dlm/dlm.c     | 445 +++++++++++++++++++++++++
 kernel/trace/rv/monitors/dlm/dlm.h     |  38 +++
 kernel/trace/rv/monitors/dlm/dlm_da.h  | 143 ++++++++
 tools/verification/models/dlm.dot      |  14 +
 14 files changed, 907 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/trace/rv/monitor_dlm.rst
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm.c
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm.h
 create mode 100644 kernel/trace/rv/monitors/dlm/dlm_da.h
 create mode 100644 tools/verification/models/dlm.dot

-- 
2.43.0

