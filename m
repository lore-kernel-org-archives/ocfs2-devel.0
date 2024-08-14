Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447291B3F00
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646073; cv=none; b=imzUhgH7Kn7LuE9RmI8DHiZqc8GKnj3M6+iYH1y5RgXVkTVDNc5oqz+njQJhf7rzuysnk+XdhlkGYHVegZXr+zv7RU88OOWi2Kq+Nqrh5Azl5O7U1W6+xiye8x2TlAQKtxiyTppXDdTX6IswocAw94Ua+i9beuxh77QEL2kr5Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646073; c=relaxed/simple;
	bh=7+E295+fTdtFYJE7SO/shAHSrnEGhOeeX5vu6OAwvNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPR4qS2f5/2BHtH1audvQDap3en6y9cfbWoHqpThaWHcJpJGgzRokmXfGKpsVauJNSmxT1vNlThRwu70Z3SgZxBX+fQrTSAu2VAaYwTT6h0YlfC4NBCo4G0sjpG/LHJLj/mTjrm6WdBRePea8pqRZP7FBRkVXLFqJv19+Oql6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bo2fddRG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bo2fddRG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+k9OgWsKdKtc2JL0VLbtqiJHf8Tzgl+WMY1WPT70Ug=;
	b=Bo2fddRGSWfv1YrnDyEBcK/Q9CREs3BOM1kWewroA43DuHJ7erRB5o7+ui0zeYfVWYBW/B
	UZQYmh9dXLq56Zl2FJX/nm3VHZGyYSXz3h8wFkQTT6Y+jaO8NBnpXhN5f2MwfmwxjoVvp8
	/tA1Az4OsK+kELQJg4F2goCAMlDAMuQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-mkjJ2jwPODy_EEJ1DSFBhw-1; Wed,
 14 Aug 2024 10:34:27 -0400
X-MC-Unique: mkjJ2jwPODy_EEJ1DSFBhw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7F6818EA957;
	Wed, 14 Aug 2024 14:34:24 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5AC5D3001FD6;
	Wed, 14 Aug 2024 14:34:22 +0000 (UTC)
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
	lucien.xin@gmail.com,
	aahringo@redhat.com
Subject: [RFC dlm/next 01/12] dlm: introduce dlm_find_lockspace_name()
Date: Wed, 14 Aug 2024 10:34:03 -0400
Message-ID: <20240814143414.1877505-2-aahringo@redhat.com>
In-Reply-To: <20240814143414.1877505-1-aahringo@redhat.com>
References: <20240814143414.1877505-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

