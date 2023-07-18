Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A21A16403
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jul 2023 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689703652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtKFy5OXgVICH4eSzUBHyPH3TdnYIlEk7+UESLNSAuI=;
	b=AqIyTDmO4IEjRbgFv8jki6TVJswWWdJPW2dNV0teecMb/s2f827zPtwMzK1GgmKIcCEaYF
	0ZQXYXSVq/claCOHpIQhTyR6c+q69oJNazAah8yrOs5GAW1oBSCTIPl5hEq0Z5O4eScgm5
	KGgidxBKBd9qicdDCVRzol8y65SE3eI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-S_0m5qisOG-nAvn7PTtuLg-1; Tue, 18 Jul 2023 14:07:30 -0400
X-MC-Unique: S_0m5qisOG-nAvn7PTtuLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B1E010113C1;
	Tue, 18 Jul 2023 18:07:29 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DA64200BA8B;
	Tue, 18 Jul 2023 18:07:29 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: cluster-devel@redhat.com,
	aahringo@redhat.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Subject: [PATCHv3 v6.5-rc2 1/3] fs: dlm: remove twice newline
Date: Tue, 18 Jul 2023 14:07:19 -0400
Message-Id: <20230718180721.745569-2-aahringo@redhat.com>
In-Reply-To: <20230718180721.745569-1-aahringo@redhat.com>
References: <20230718180721.745569-1-aahringo@redhat.com>
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

This patch removes a newline which log_print() already adds, also
removes wrapped string that causes a checkpatch warning.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/plock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 70a4752ed913..a34f605d8505 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -240,8 +240,8 @@ static int dlm_plock_callback(struct plock_op *op)
 	rv = notify(fl, 0);
 	if (rv) {
 		/* XXX: We need to cancel the fs lock here: */
-		log_print("dlm_plock_callback: lock granted after lock request "
-			  "failed; dangling lock!\n");
+		log_print("%s: lock granted after lock request failed; dangling lock!",
+			  __func__);
 		goto out;
 	}
 
-- 
2.31.1

