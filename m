Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA7DF52
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Aug 2023 21:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692047488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tZEXFed81ekvMweSZpvZmhvnw/W3DW6CK17WR1HloMI=;
	b=P3RxCVQh+HOTTR8HxJPRMEsCh9Qla7Vyly2ISNqfVco0Nbh6RRBgf3+df1wW2kqrnCQYMa
	oVuq37zTiIKM0LLXH1BZg0Ce/rlO5CZnD0KclXGaU3IvaZcwdNEgolg6vVPRS1Me9c85gn
	fjdJ0kR0EN41p336IwwUu4wtg2B9Uhw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-OwVOreIAOrWvXEOKEJzbog-1; Mon, 14 Aug 2023 17:11:24 -0400
X-MC-Unique: OwVOreIAOrWvXEOKEJzbog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BE3F3C0253A;
	Mon, 14 Aug 2023 21:11:24 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0000CC15BAD;
	Mon, 14 Aug 2023 21:11:23 +0000 (UTC)
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
Subject: [RFCv2 6/7] dlm: use FL_SLEEP to check if blocking request
Date: Mon, 14 Aug 2023 17:11:15 -0400
Message-Id: <20230814211116.3224759-7-aahringo@redhat.com>
In-Reply-To: <20230814211116.3224759-1-aahringo@redhat.com>
References: <20230814211116.3224759-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8

This patch uses the FL_SLEEP flag in struct file_lock to check if it's a
blocking request in case if the request coming from nfs lockd process
indicated by lm_grant() is set.

IF FL_SLEEP is set a asynchronous blocking request is being made and
it's waiting for lm_grant() callback being called to signal the lock was
granted. If it's not set a synchronous non-blocking request is being made.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/plock.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 0094fa4004cc..524771002a2f 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -140,7 +140,6 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	op->info.optype		= DLM_PLOCK_OP_LOCK;
 	op->info.pid		= fl->fl_pid;
 	op->info.ex		= (fl->fl_type == F_WRLCK);
-	op->info.wait		= IS_SETLKW(cmd);
 	op->info.fsid		= ls->ls_global_id;
 	op->info.number		= number;
 	op->info.start		= fl->fl_start;
@@ -148,24 +147,31 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	op->info.owner = (__u64)(long)fl->fl_owner;
 	/* async handling */
 	if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
-		op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
-		if (!op_data) {
-			dlm_release_plock_op(op);
-			rv = -ENOMEM;
-			goto out;
-		}
+		if (fl->fl_flags & FL_SLEEP) {
+			op_data = kzalloc(sizeof(*op_data), GFP_NOFS);
+			if (!op_data) {
+				dlm_release_plock_op(op);
+				rv = -ENOMEM;
+				goto out;
+			}
 
-		op_data->callback = fl->fl_lmops->lm_grant;
-		locks_init_lock(&op_data->flc);
-		locks_copy_lock(&op_data->flc, fl);
-		op_data->fl		= fl;
-		op_data->file	= file;
+			op->info.wait = 1;
+			op_data->callback = fl->fl_lmops->lm_grant;
+			locks_init_lock(&op_data->flc);
+			locks_copy_lock(&op_data->flc, fl);
+			op_data->fl		= fl;
+			op_data->file	= file;
 
-		op->data = op_data;
+			op->data = op_data;
 
-		send_op(op);
-		rv = FILE_LOCK_DEFERRED;
-		goto out;
+			send_op(op);
+			rv = FILE_LOCK_DEFERRED;
+			goto out;
+		} else {
+			op->info.wait = 0;
+		}
+	} else {
+		op->info.wait = IS_SETLKW(cmd);
 	}
 
 	send_op(op);
-- 
2.31.1

