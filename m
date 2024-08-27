Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A01D2F72
	for <ocfs2-devel@lists.linux.dev>; Tue, 27 Aug 2024 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781804; cv=none; b=ZDp37lT5CVz2ef7I2PzG9GVd73MgNFI9Ge0SjYiXNCJnUqMnb+vHf9YxgL7I3JSpwSHuew7OtMuQ2uYTbLNhKKvEM/PnetsVJi2fjIaNp9WJ+RAAk6yEPRpRm5d5bJKu6WLHio1XCK4XdoYSEhyJcEV18F1DhE7ilzPBfje4NUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781804; c=relaxed/simple;
	bh=LrvL7Ph/QlOSx7zujU2LmzLvPYnl+n/ew0XfqKHb0TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofzGoEL0C3AgH96d51PPBum1lYJN+r2WmwCQ4/5tUbKgYCNM23iKYbHi+uohzQ/wAAleGcy7pO8TBJUoy5AcVReTi59oTGxfP5mUlKSpHl6XoXqgXOpJJnqpDb40S6R1m9fwu0BkqwDVF17HK0uASiK2Y6Yywuy1GOlE4u4q3qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1HOQN5F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1HOQN5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724781802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SCDbnalavEPDZ6X8+FuzaIDIjdKt3WdCbgJCmYzM6cw=;
	b=Q1HOQN5FfJbZtAY7f7Ye1EehmxhYb6xCKMbzV/k5mC7bL1X1s9qqMGR3TExi/De9TwEpUq
	tVOmZN/ro8+c4b/zwDdfiEJ3uuDT+/Bfm807v+ofyQlNMOg7Sp0yMENyM7T6ejz9Nk/ZvY
	/0+dl/sGw+DXKz7YlYYcbC2LgBPIjhc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-3JmjOdStOcu7MPESNnoFGg-1; Tue,
 27 Aug 2024 14:03:18 -0400
X-MC-Unique: 3JmjOdStOcu7MPESNnoFGg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE35C1955D55;
	Tue, 27 Aug 2024 18:03:14 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D03CA1955DD8;
	Tue, 27 Aug 2024 18:03:10 +0000 (UTC)
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
Subject: [RFC 4/7] dlm: add our_nodeid to tracepoints
Date: Tue, 27 Aug 2024 14:02:33 -0400
Message-ID: <20240827180236.316946-5-aahringo@redhat.com>
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

This patch adds our_nodeid to some DLM tracepoints that are necessary
for the DLM kernel verifier to know from which nodeid the traceevent
comes from. This is useful when using DLM in net-namespaces to get a
whole cluster-view of DLM in traces.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/ast.c               | 23 +++++++++++++----------
 fs/dlm/dlm_internal.h      |  1 +
 fs/dlm/user.c              |  9 +++++----
 include/trace/events/dlm.h | 36 +++++++++++++++++++++++-------------
 4 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 0fe8d80ce5e8..01de0d4b9450 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -18,20 +18,21 @@
 #include "user.h"
 #include "ast.h"
 
-static void dlm_run_callback(uint32_t ls_id, uint32_t lkb_id, int8_t mode,
-			     uint32_t flags, uint8_t sb_flags, int sb_status,
-			     struct dlm_lksb *lksb,
+static void dlm_run_callback(int our_nodeid, uint32_t ls_id, uint32_t lkb_id,
+			     int8_t mode, uint32_t flags, uint8_t sb_flags,
+			     int sb_status, struct dlm_lksb *lksb,
 			     void (*astfn)(void *astparam),
 			     void (*bastfn)(void *astparam, int mode),
 			     void *astparam, const char *res_name,
 			     size_t res_length)
 {
 	if (flags & DLM_CB_BAST) {
-		trace_dlm_bast(ls_id, lkb_id, mode, res_name, res_length);
+		trace_dlm_bast(our_nodeid, ls_id, lkb_id, mode, res_name,
+			       res_length);
 		bastfn(astparam, mode);
 	} else if (flags & DLM_CB_CAST) {
-		trace_dlm_ast(ls_id, lkb_id, sb_flags, sb_status, res_name,
-			      res_length);
+		trace_dlm_ast(our_nodeid, ls_id, lkb_id, sb_flags, sb_status,
+			      res_name, res_length);
 		lksb->sb_status = sb_status;
 		lksb->sb_flags = sb_flags;
 		astfn(astparam);
@@ -40,8 +41,8 @@ static void dlm_run_callback(uint32_t ls_id, uint32_t lkb_id, int8_t mode,
 
 static void dlm_do_callback(struct dlm_callback *cb)
 {
-	dlm_run_callback(cb->ls_id, cb->lkb_id, cb->mode, cb->flags,
-			 cb->sb_flags, cb->sb_status, cb->lkb_lksb,
+	dlm_run_callback(cb->our_nodeid, cb->ls_id, cb->lkb_id, cb->mode,
+			 cb->flags, cb->sb_flags, cb->sb_status, cb->lkb_lksb,
 			 cb->astfn, cb->bastfn, cb->astparam,
 			 cb->res_name, cb->res_length);
 	dlm_free_cb(cb);
@@ -130,6 +131,7 @@ int dlm_get_cb(struct dlm_lkb *lkb, uint32_t flags, int mode,
 		return -ENOMEM;
 
 	/* for tracing */
+	(*cb)->our_nodeid = ls->ls_dn->our_node->id;
 	(*cb)->lkb_id = lkb->lkb_id;
 	(*cb)->ls_id = ls->ls_global_id;
 	memcpy((*cb)->res_name, rsb->res_name, rsb->res_length);
@@ -185,8 +187,9 @@ void dlm_add_cb(struct dlm_lkb *lkb, uint32_t flags, int mode, int status,
 			list_add(&cb->list, &ls->ls_cb_delay);
 	} else {
 		if (test_bit(LSFL_SOFTIRQ, &ls->ls_flags)) {
-			dlm_run_callback(ls->ls_global_id, lkb->lkb_id, mode, flags,
-					 sbflags, status, lkb->lkb_lksb,
+			dlm_run_callback(ls->ls_dn->our_node->id,
+					 ls->ls_global_id, lkb->lkb_id, mode,
+					 flags, sbflags, status, lkb->lkb_lksb,
 					 lkb->lkb_astfn, lkb->lkb_bastfn,
 					 lkb->lkb_astparam, rsb->res_name,
 					 rsb->res_length);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 2de5ef2653cd..bc3ff1b64e0c 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -234,6 +234,7 @@ struct dlm_callback {
 	bool			copy_lvb;
 	struct dlm_lksb		*lkb_lksb;
 	unsigned char		lvbptr[DLM_USER_LVB_LEN];
+	int			our_nodeid;
 
 	union {
 		void			*astparam;	/* caller's ast arg */
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 1b682f8f95b6..c4d6e67ff63e 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -868,13 +868,14 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	spin_unlock_bh(&proc->asts_spin);
 
 	if (cb->flags & DLM_CB_BAST) {
-		trace_dlm_bast(cb->ls_id, cb->lkb_id, cb->mode, cb->res_name,
-			       cb->res_length);
+		trace_dlm_bast(cb->our_nodeid, cb->ls_id, cb->lkb_id,
+			       cb->mode, cb->res_name, cb->res_length);
 	} else if (cb->flags & DLM_CB_CAST) {
 		cb->lkb_lksb->sb_status = cb->sb_status;
 		cb->lkb_lksb->sb_flags = cb->sb_flags;
-		trace_dlm_ast(cb->ls_id, cb->lkb_id, cb->sb_status,
-			      cb->sb_flags, cb->res_name, cb->res_length);
+		trace_dlm_ast(cb->our_nodeid, cb->ls_id, cb->lkb_id,
+			      cb->sb_status, cb->sb_flags, cb->res_name,
+			      cb->res_length);
 	}
 
 	ret = copy_result_to_user(&cb->ua,
diff --git a/include/trace/events/dlm.h b/include/trace/events/dlm.h
index af160082c9e3..2621bb7ac3a8 100644
--- a/include/trace/events/dlm.h
+++ b/include/trace/events/dlm.h
@@ -98,6 +98,7 @@ TRACE_EVENT(dlm_lock_start,
 	TP_ARGS(ls, lkb, name, namelen, mode, flags),
 
 	TP_STRUCT__entry(
+		__field(unsigned int, our_nodeid)
 		__field(__u32, ls_id)
 		__field(__u32, lkb_id)
 		__field(int, mode)
@@ -109,6 +110,7 @@ TRACE_EVENT(dlm_lock_start,
 	TP_fast_assign(
 		struct dlm_rsb *r;
 
+		__entry->our_nodeid = ls->ls_dn->our_node->id;
 		__entry->ls_id = ls->ls_global_id;
 		__entry->lkb_id = lkb->lkb_id;
 		__entry->mode = mode;
@@ -123,8 +125,8 @@ TRACE_EVENT(dlm_lock_start,
 			       __get_dynamic_array_len(res_name));
 	),
 
-	TP_printk("ls_id=%u lkb_id=%x mode=%s flags=%s res_name=%s",
-		  __entry->ls_id, __entry->lkb_id,
+	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x mode=%s flags=%s res_name=%s",
+		  __entry->our_nodeid, __entry->ls_id, __entry->lkb_id,
 		  show_lock_mode(__entry->mode),
 		  show_lock_flags(__entry->flags),
 		  __print_hex_str(__get_dynamic_array(res_name),
@@ -141,6 +143,7 @@ TRACE_EVENT(dlm_lock_end,
 	TP_ARGS(ls, lkb, name, namelen, mode, flags, error, kernel_lock),
 
 	TP_STRUCT__entry(
+		__field(unsigned int, our_nodeid)
 		__field(__u32, ls_id)
 		__field(__u32, lkb_id)
 		__field(int, mode)
@@ -153,6 +156,7 @@ TRACE_EVENT(dlm_lock_end,
 	TP_fast_assign(
 		struct dlm_rsb *r;
 
+		__entry->our_nodeid = ls->ls_dn->our_node->id;
 		__entry->ls_id = ls->ls_global_id;
 		__entry->lkb_id = lkb->lkb_id;
 		__entry->mode = mode;
@@ -178,8 +182,8 @@ TRACE_EVENT(dlm_lock_end,
 
 	),
 
-	TP_printk("ls_id=%u lkb_id=%x mode=%s flags=%s error=%d res_name=%s",
-		  __entry->ls_id, __entry->lkb_id,
+	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x mode=%s flags=%s error=%d res_name=%s",
+		  __entry->our_nodeid, __entry->ls_id, __entry->lkb_id,
 		  show_lock_mode(__entry->mode),
 		  show_lock_flags(__entry->flags), __entry->error,
 		  __print_hex_str(__get_dynamic_array(res_name),
@@ -189,12 +193,13 @@ TRACE_EVENT(dlm_lock_end,
 
 TRACE_EVENT(dlm_bast,
 
-	TP_PROTO(__u32 ls_id, __u32 lkb_id, int mode,
+	TP_PROTO(unsigned int our_nodeid, __u32 ls_id, __u32 lkb_id, int mode,
 		 const char *res_name, size_t res_length),
 
-	TP_ARGS(ls_id, lkb_id, mode, res_name, res_length),
+	TP_ARGS(our_nodeid, ls_id, lkb_id, mode, res_name, res_length),
 
 	TP_STRUCT__entry(
+		__field(unsigned int, our_nodeid)
 		__field(__u32, ls_id)
 		__field(__u32, lkb_id)
 		__field(int, mode)
@@ -202,6 +207,7 @@ TRACE_EVENT(dlm_bast,
 	),
 
 	TP_fast_assign(
+		__entry->our_nodeid = our_nodeid;
 		__entry->ls_id = ls_id;
 		__entry->lkb_id = lkb_id;
 		__entry->mode = mode;
@@ -210,8 +216,8 @@ TRACE_EVENT(dlm_bast,
 		       __get_dynamic_array_len(res_name));
 	),
 
-	TP_printk("ls_id=%u lkb_id=%x mode=%s res_name=%s",
-		  __entry->ls_id, __entry->lkb_id,
+	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x mode=%s res_name=%s",
+		  __entry->our_nodeid, __entry->ls_id, __entry->lkb_id,
 		  show_lock_mode(__entry->mode),
 		  __print_hex_str(__get_dynamic_array(res_name),
 				  __get_dynamic_array_len(res_name)))
@@ -220,12 +226,15 @@ TRACE_EVENT(dlm_bast,
 
 TRACE_EVENT(dlm_ast,
 
-	TP_PROTO(__u32 ls_id, __u32 lkb_id, __u8 sb_flags, int sb_status,
-		 const char *res_name, size_t res_length),
+	TP_PROTO(unsigned int our_nodeid, __u32 ls_id, __u32 lkb_id,
+		 __u8 sb_flags, int sb_status, const char *res_name,
+		 size_t res_length),
 
-	TP_ARGS(ls_id, lkb_id, sb_flags, sb_status, res_name, res_length),
+	TP_ARGS(our_nodeid, ls_id, lkb_id, sb_flags, sb_status, res_name,
+		res_length),
 
 	TP_STRUCT__entry(
+		__field(unsigned int, our_nodeid)
 		__field(__u32, ls_id)
 		__field(__u32, lkb_id)
 		__field(__u8, sb_flags)
@@ -234,6 +243,7 @@ TRACE_EVENT(dlm_ast,
 	),
 
 	TP_fast_assign(
+		__entry->our_nodeid = our_nodeid;
 		__entry->ls_id = ls_id;
 		__entry->lkb_id = lkb_id;
 		__entry->sb_flags = sb_flags;
@@ -243,8 +253,8 @@ TRACE_EVENT(dlm_ast,
 		       __get_dynamic_array_len(res_name));
 	),
 
-	TP_printk("ls_id=%u lkb_id=%x sb_flags=%s sb_status=%d res_name=%s",
-		  __entry->ls_id, __entry->lkb_id,
+	TP_printk("our_nodeid=%u ls_id=%u lkb_id=%x sb_flags=%s sb_status=%d res_name=%s",
+		  __entry->our_nodeid, __entry->ls_id, __entry->lkb_id,
 		  show_dlm_sb_flags(__entry->sb_flags), __entry->sb_status,
 		  __print_hex_str(__get_dynamic_array(res_name),
 				  __get_dynamic_array_len(res_name)))
-- 
2.43.0

