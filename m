Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE011FB35
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Aug 2023 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692826436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xwzXGvvpmt4FEgLenzZ4PyVYxrazVCtDHUJfiFZMDNA=;
	b=VmfQybc4pRvDu8poo5q1w7lod1MlMC58rXKm/95ouJA7mvwHf671RURHmyJIqRuI+gARwP
	jsDz1Ku3GIRJMp6F/LTzI2dRjaX/XUfRfrsiYoSG52+6qgNioe/aYlDCKD/AfsorUP1OY8
	x6uMOrgtdsfFLeQIzESIxu91fPffY+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-spbckOqvMlO9RRIv8uuOkg-1; Wed, 23 Aug 2023 17:33:54 -0400
X-MC-Unique: spbckOqvMlO9RRIv8uuOkg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2244185A78F;
	Wed, 23 Aug 2023 21:33:53 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44F2D40C6F4C;
	Wed, 23 Aug 2023 21:33:53 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: linux-nfs@vger.kernel.org
Cc: cluster-devel@redhat.com,
	ocfs2-devel@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	teigland@redhat.com,
	rpeterso@redhat.com,
	agruenba@redhat.com,
	trond.myklebust@hammerspace.com,
	anna@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org
Subject: [PATCH 0/7] lockd: dlm: async lock request changes
Date: Wed, 23 Aug 2023 17:33:45 -0400
Message-Id: <20230823213352.1971009-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2

Hi,

I sent this as a PATCH now and drop the RFC. I got some review back from
Jeff Layton and hope I was successful to follow it. There are still
issues with lockd and asynchronous lock request but it will at least not
directly crash when somebody is using nfs on top of GFS2. The issues are
related to cancellation of locks/lockd decides to drop nlm_block for
some reasons while pending request is happening.

I did not change more documentation about the asynchronous lock request
functionality to not confuse users. In my opinion there should be more
documentation about what you SHOULD NOT do with this API. Otherwise I
think the documentation is still correct.

I will send a follow up patch to fsdevel to change all users using
IS_SETLKW() to use FL_SLEEP to determine if it's blocking or non-blocking
and send it to fsdevel as it was recommended. This will just be a grep
and replace patch and look what happens. 

- Alex

changes since RFC:

- drop the pending callback flag but introduce "lockd: don't call
  vfs_lock_file() for pending requests", see patch why I need it.
- drop per nlm_block callback mutex
- change async lock request documentation
- use always FL_SLEEP to determine if it's blocking vs non-blocking in
  DLM

Alexander Aring (7):
  lockd: introduce safe async lock op
  lockd: don't call vfs_lock_file() for pending requests
  lockd: fix race in async lock request handling
  lockd: add doc to enable EXPORT_OP_SAFE_ASYNC_LOCK
  dlm: use fl_owner from lockd
  dlm: use FL_SLEEP to determine blocking vs non-blocking
  dlm: implement EXPORT_OP_SAFE_ASYNC_LOCK

 fs/dlm/plock.c           | 20 +++++---------------
 fs/gfs2/export.c         |  1 +
 fs/lockd/svclock.c       | 40 +++++++++++++++++++++++++++-------------
 fs/locks.c               | 12 +++++++-----
 fs/nfsd/nfs4state.c      | 13 ++++++++++---
 fs/ocfs2/export.c        |  1 +
 include/linux/exportfs.h |  8 ++++++++
 7 files changed, 59 insertions(+), 36 deletions(-)

-- 
2.31.1

