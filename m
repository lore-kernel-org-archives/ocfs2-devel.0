Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE31D4152
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Aug 2024 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781807; cv=none; b=AGF18CiaszOeP7Isa8BeWU0hK8ZTIwOb9IRD3IQX8wD+zrwO1maOMrJAxVeHw10B1J61AKwkBNXC+maSgByEDzYi7eSUETI35wi+vs8fJEjjr2I7AI11ORWM3wWVwCr//ueC1JQd98vau1c/sYWaSksR2pQalNeoNYXhVzPGKw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781807; c=relaxed/simple;
	bh=OJls2vsbsH6uelH/T/HgOzTBW8h0QC3AGr0F+CJvFJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSKMiVF2MH3R8NkcXAg/sSg7oTriBRNYEDaKb5pwd+jIEtUla3Uai+xN0uwRkY/BF7OSWQ8kgGqpuwp5fhDmyQWwxt09udbZ4BxJJkDek9v4WMerHZLJHzVsGYzkjwlhCkcW/RNb7HAequiqOLEHbURx+4Koo1wJbxP5DFII4RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P17UKGtk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P17UKGtk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724781805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0n3QoftpE0QdZNyZ3i3U02OdoDsTNz9pYwwpvpU4g2w=;
	b=P17UKGtkX+IftFx/3LwlMiNIJ2LssbX4zRIaYVTVUlygg7Wy8SLiyLrxIgKDaiSKgfH0j+
	xQWKVWUE8eZ9wOQDvHxwwP5VF9v1BeaFl26WDQhjJ5yObhissafa+KmzvYp9LVOMom3MAr
	r80m7md0pULajt6JTt1zp2aQUHgGaNA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-IpDebxFUMKGY-2feeLPpiw-1; Tue,
 27 Aug 2024 14:03:22 -0400
X-MC-Unique: IpDebxFUMKGY-2feeLPpiw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 692F91955D4C;
	Tue, 27 Aug 2024 18:03:18 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B1741955BE1;
	Tue, 27 Aug 2024 18:03:14 +0000 (UTC)
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
Subject: [RFC 5/7] dlm: add lkb rv mode to ast tracepoint
Date: Tue, 27 Aug 2024 14:02:34 -0400
Message-ID: <20240827180236.316946-6-aahringo@redhat.com>
In-Reply-To: <20240827180236.316946-1-aahringo@redhat.com>
References: <20240827180236.316946-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This patch adds the lkb_rv_mode to the ast tracepoint. The lkb_rv_mode
is the requested mode by dlm_lock() requests. We cannot use lkb_mode as
dlm internally sometimes changes this value and for cases like the dlm
kernel verifier we want to check on DLM correctness from what the user
is seeing. This new tracepoint events tells us what the requested mode
was.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c               |  9 +++++----
 fs/dlm/dlm_internal.h      |  2 ++
 fs/dlm/lock.c              |  1 +
 fs/dlm/user.c              |  2 +-
 include/trace/events/dlm.h | 11 +++++++----
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 01de0d4b9450..fc2ca37011d8 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -24,7 +24,7 @@ static void dlm_run_callback(int our_nodeid, uint32_t ls_id, uint32_t lkb_id,
 			     void (*astfn)(void *astparam),
 			     void (*bastfn)(void *astparam, int mode),
 			     void *astparam, const char *res_name,
-			     size_t res_length)
+			     size_t res_length, int rv_mode)
 {
 	if (flags & DLM_CB_BAST) {
 		trace_dlm_bast(our_nodeid, ls_id, lkb_id, mode, res_name,
@@ -32,7 +32,7 @@ static void dlm_run_callback(int our_nodeid, uint32_t ls_id, uint32_t lkb_id,
 		bastfn(astparam, mode);
 	} else if (flags & DLM_CB_CAST) {
 		trace_dlm_ast(our_nodeid, ls_id, lkb_id, sb_flags, sb_status,
-			      res_name, res_length);
+			      res_name, res_length, rv_mode);
 		lksb->sb_status = sb_status;
 		lksb->sb_flags = sb_flags;
 		astfn(astparam);
@@ -44,7 +44,7 @@ static void dlm_do_callback(struct dlm_callback *cb)
 	dlm_run_callback(cb->our_nodeid, cb->ls_id, cb->lkb_id, cb->mode,
 			 cb->flags, cb->sb_flags, cb->sb_status, cb->lkb_lksb,
 			 cb->astfn, cb->bastfn, cb->astparam,
-			 cb->res_name, cb->res_length);
+			 cb->res_name, cb->res_length, cb->rv_mode);
 	dlm_free_cb(cb);
 }
 
@@ -134,6 +134,7 @@ int dlm_get_cb(struct dlm_lkb *lkb, uint32_t flags, int mode,
 	(*cb)->our_nodeid = ls->ls_dn->our_node->id;
 	(*cb)->lkb_id = lkb->lkb_id;
 	(*cb)->ls_id = ls->ls_global_id;
+	(*cb)->rv_mode = lkb->lkb_rv_mode;
 	memcpy((*cb)->res_name, rsb->res_name, rsb->res_length);
 	(*cb)->res_length = rsb->res_length;
 
@@ -192,7 +193,7 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 					 flags, sbflags, status, lkb->lkb_lksb,
 					 lkb->lkb_astfn, lkb->lkb_bastfn,
 					 lkb->lkb_astparam, rsb->res_name,
-					 rsb->res_length);
+					 rsb->res_length, lkb->lkb_rv_mode);
 		} else {
 			rv = dlm_get_queue_cb(lkb, flags, mode, status, sbflags, &cb);
 			if (!rv)
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index bc3ff1b64e0c..3f630696f7ab 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -247,6 +247,7 @@ struct dlm_callback {
 	size_t			res_length;
 	uint32_t		ls_id;
 	uint32_t		lkb_id;
+	int			rv_mode;
 
 	struct list_head	list;
 };
@@ -296,6 +297,7 @@ struct dlm_lkb {
 		void			*lkb_astparam;	/* caller's ast arg */
 		struct dlm_user_args	*lkb_ua;
 	};
+	int			lkb_rv_mode;
 	struct rcu_head		rcu;
 };
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 8cb5a537bfd3..21bb9603a0df 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2844,6 +2844,7 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	lkb->lkb_lksb = args->lksb;
 	lkb->lkb_lvbptr = args->lksb->sb_lvbptr;
 	lkb->lkb_ownpid = (int) current->pid;
+	lkb->lkb_rv_mode = args->mode;
 	rv = 0;
  out:
 	switch (rv) {
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c4d6e67ff63e..75fb85676e90 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -875,7 +875,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 		cb->lkb_lksb->sb_flags = cb->sb_flags;
 		trace_dlm_ast(cb->our_nodeid, cb->ls_id, cb->lkb_id,
 			      cb->sb_status, cb->sb_flags, cb->res_name,
-			      cb->res_length);
+			      cb->res_length, cb->rv_mode);
 	}
 
 	ret = copy_result_to_user(&cb->ua,
diff --git a/include/trace/events/dlm.h b/include/trace/events/dlm.h
index 2621bb7ac3a8..f8d7ca451760 100644
--- a/include/trace/events/dlm.h
+++ b/include/trace/events/dlm.h
@@ -228,10 +228,10 @@ TRACE_EVENT(dlm_ast,
 
 	TP_PROTO(unsigned int our_nodeid, __u32 ls_id, __u32 lkb_id,
 		 __u8 sb_flags, int sb_status, const char *res_name,
-		 size_t res_length),
+		 size_t res_length, int rv_mode),
 
 	TP_ARGS(our_nodeid, ls_id, lkb_id, sb_flags, sb_status, res_name,
-		res_length),
+		res_length, rv_mode),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, our_nodeid)
@@ -239,6 +239,7 @@ TRACE_EVENT(dlm_ast,
 		__field(__u32, lkb_id)
 		__field(__u8, sb_flags)
 		__field(int, sb_status)
+		__field(int, rv_mode)
 		__dynamic_array(unsigned char, res_name, res_length)
 	),
 
@@ -248,16 +249,18 @@ TRACE_EVENT(dlm_ast,
 		__entry->lkb_id = lkb_id;
 		__entry->sb_flags = sb_flags;
 		__entry->sb_status = sb_status;
+		__entry->rv_mode = rv_mode;
 
 		memcpy(__get_dynamic_array(res_name), res_name,
 		       __get_dynamic_array_len(res_name));
 	),
 
-	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x sb_flags=%s sb_status=%d res_name=%s",
+	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x sb_flags=%s sb_status=%d res_name=%s rv_mode=%d",
 		  __entry->our_nodeid, __entry->ls_id, __entry->lkb_id,
 		  show_dlm_sb_flags(__entry->sb_flags), __entry->sb_status,
 		  __print_hex_str(__get_dynamic_array(res_name),
-				  __get_dynamic_array_len(res_name)))
+				  __get_dynamic_array_len(res_name)),
+		  __entry->rv_mode)
 
 );
 
-- 
2.43.0

