Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47E416406
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jul 2023 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689703653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0LxZ4wLhre+tj0sV3i83n0Bu7Q8ujCWgNiGos+rdEew=;
	b=Fmpz3BkkdEsJ3Aa9IrQJwQ7266JsIeBIAda9Gep/FBw00LpbmqGQA89WV1SnUxAMPHVc10
	9x6JZzbZM+bzh1d1J+AGz9jGUu1t5EGQ3IyyUx+o4dDs4sY8mmwvTfCpavDeJsUooFu0fN
	p6GRG5vy3ovy/kpLH/1s0T9Ss7ofE94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-fxpWsb-POzyaDuQZXf4QPA-1; Tue, 18 Jul 2023 14:07:29 -0400
X-MC-Unique: fxpWsb-POzyaDuQZXf4QPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25829800B35;
	Tue, 18 Jul 2023 18:07:29 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA63D200BA8B;
	Tue, 18 Jul 2023 18:07:28 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: cluster-devel@redhat.com,
	aahringo@redhat.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Subject: [PATCHv3 v6.5-rc2 0/3] fs: dlm: lock cancellation feature
Date: Tue, 18 Jul 2023 14:07:18 -0400
Message-Id: <20230718180721.745569-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Hi,

this patch series implements lock cancellation feature. Either if a
POSIX F_SETLKW got interrupted by a signal (most common use case) or
lockd sends a F_CANCELLK request.

As I note: the current nfs handling seems to be broken. This patch
assumes that the current behaviour works. Future patches will fix the
nfs handling which seems to be broken anyway.

- Alex

changes since v3:

- drop patch "fs: dlm: ignore DLM_PLOCK_FL_CLOSE flag results", we assume
  that plock ops with DLM_PLOCK_FL_CLOSE flag set will never fail.
- Let DLM_PLOCK_OP_CANCEL to always send a reply back. This is useful when
  the op fails, e.g. older dlm_controld will return -EINVAL and we can
  implement F_CANCELLK which does not have a reference of the plock_op
  instance.
- remove DLM_PLOCK_OP_FLAG_SENT as it was only a optimization for a
  rare case. That DLM_PLOCK_OP_CANCEL sends a reply back will
  synchronize it now.
- remove DLM_PLOCK_OP_FLAG_INTERRUPTED as it's not necessary anymore
  because waiting for a reply of DLM_PLOCK_OP_CANCEL we don't need to
  handle this special case anymore.
- add "fs: dlm: remove twice newline" because I saw this while doing nfs
  lockd experiments.

Alexander Aring (3):
  fs: dlm: remove twice newline
  fs: dlm: allow to F_SETLKW getting interrupted
  fs: dlm: fix F_CANCELLK to cancel pending request

 fs/dlm/plock.c                 | 162 ++++++++++++++++++++++++++-------
 fs/gfs2/file.c                 |   9 +-
 fs/ocfs2/stack_user.c          |  13 +--
 include/linux/dlm_plock.h      |   2 +
 include/uapi/linux/dlm_plock.h |   1 +
 5 files changed, 136 insertions(+), 51 deletions(-)

-- 
2.31.1

