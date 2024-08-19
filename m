Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2A189BBD
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092689; cv=none; b=VW5OzOAaCTy2Cjw80vB4uTqJee4pqvPEPDxh5Ivnoi8wjLU4yDFv89BmXwWfMDLGcCoqGXYIRifJ3h4OQEd3/gQXvN9o73a+2rJC47/29twscx5y7tvekdfL7u+PfCBUPYVuUG79HOUwDhx6DT+34bsC2M1OYFsmU4+vg/6a8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092689; c=relaxed/simple;
	bh=7+E295+fTdtFYJE7SO/shAHSrnEGhOeeX5vu6OAwvNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6Uh2tUPJS75rdB03HKBGLPJmU+meOEa7SHDtbIKpZmQfA/vyKqSSmfCWsA4d4P4g6SvK3DyFetxSOzq5SsF+xyj+heCgfS7JeCV5RcCp9/p92k4TBH+1Ky4XdUDwMIBtQ7Ykad3Cr/zUtHrx4Uoitffp6wJ29RX4rhzQKtL7r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZV06uae0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZV06uae0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+k9OgWsKdKtc2JL0VLbtqiJHf8Tzgl+WMY1WPT70Ug=;
	b=ZV06uae0dYvT7YyZaKNyxVfinc4VLpSBNMMTvfQs3VKZVX+UpLMOUoZd6Dp0X29fzE+qo/
	QWuTkJTWft5Cee/vuzacAedRMCth3ICnL4xMje5hPqYHvGj39WVABPNleHE6jiEH/xu7R5
	9tOl1+PAaJFDbqOD8Uw6trk9Ttw8YWE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-7AEv9qrAP9WWqgKCwaEP-g-1; Mon,
 19 Aug 2024 14:38:02 -0400
X-MC-Unique: 7AEv9qrAP9WWqgKCwaEP-g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFF5319560AB;
	Mon, 19 Aug 2024 18:37:59 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 70A651956053;
	Mon, 19 Aug 2024 18:37:55 +0000 (UTC)
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
	aahringo@redhat.com
Subject: [PATCH dlm/next 01/12] dlm: introduce dlm_find_lockspace_name()
Date: Mon, 19 Aug 2024 14:37:31 -0400
Message-ID: <20240819183742.2263895-2-aahringo@redhat.com>
In-Reply-To: <20240819183742.2263895-1-aahringo@redhat.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

A DLM lockspace can be either identified by it's unique id or name. Later
patches will introduce a new netlink api that is using a unique
lockspace name to identify a lockspace in the lslist. This is mostly
required for sysfs functionality that is currently solved by a per
lockspace kobject allocation. The new netlink api cannot simple lookup
the lockspace by a container_of() call to do whatever sysfs is
providing so we introduce dlm_find_lockspace_name() to offer such
functionality.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lockspace.c | 18 ++++++++++++++++++
 fs/dlm/lockspace.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 8afac6e2dff0..00d37125bc44 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -238,6 +238,24 @@ void dlm_lockspace_exit(void)
 	kset_unregister(dlm_kset);
 }
 
+struct dlm_ls *dlm_find_lockspace_name(const char *lsname)
+{
+	struct dlm_ls *ls;
+
+	spin_lock_bh(&lslist_lock);
+
+	list_for_each_entry(ls, &lslist, ls_list) {
+		if (!strncmp(ls->ls_name, lsname, DLM_LOCKSPACE_LEN)) {
+			atomic_inc(&ls->ls_count);
+			goto out;
+		}
+	}
+	ls = NULL;
+ out:
+	spin_unlock_bh(&lslist_lock);
+	return ls;
+}
+
 struct dlm_ls *dlm_find_lockspace_global(uint32_t id)
 {
 	struct dlm_ls *ls;
diff --git a/fs/dlm/lockspace.h b/fs/dlm/lockspace.h
index 47ebd4411926..7898a906aab9 100644
--- a/fs/dlm/lockspace.h
+++ b/fs/dlm/lockspace.h
@@ -22,6 +22,7 @@
 
 int dlm_lockspace_init(void);
 void dlm_lockspace_exit(void);
+struct dlm_ls *dlm_find_lockspace_name(const char *lsname);
 struct dlm_ls *dlm_find_lockspace_global(uint32_t id);
 struct dlm_ls *dlm_find_lockspace_local(void *id);
 struct dlm_ls *dlm_find_lockspace_device(int minor);
-- 
2.43.0

