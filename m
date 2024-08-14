Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511A1B9B3E
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646094; cv=none; b=RS7OfWeeN0W0pqfkbLq5mnON7fqDQ1ar98Eby2fQ2sftR2BaFNgV1KFMW3Knl4xtf6Zsmi0kOS66cE3FczM2QMCDJh1TASb5XcMExTryKztdOuezPjYyahC3mVqqYZc3Aka6s/ohfKt3WtaUkAj0gGWpD+TMx9y/Abahkw3z00A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646094; c=relaxed/simple;
	bh=ypQTMu2LYzWPCWkIUYRC3XuhqMDUHANoI/TysjruBKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNHNJ7/fMFthZ20ywxeY2TAaj8KcPNaWDsKJVtWmv0POeDLPXG+b7tsW1PL+Uh6KEVMUx2cW8AjhO98ncyJlL2hAg+qQC3tM0pASKiBZcnLnlV1VDsC8ibJmDmnmJ6EDBIhKV51GLiiF98p9+epCyvVl5mKiMZofjZDlAwsTDD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5Sfkk4U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5Sfkk4U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gK9wqwZ/FioxvNa+QEJ8mK8in5wLMaE0mkWFGRr0K34=;
	b=L5Sfkk4UXbTn7vcsvD2j/qdnjFegMoUHUKx/LxogE4g0z35Qe3ab3PmBOFxlZaXHmblMBo
	K8MiAg9m/4ApFE/wLKlDhSYEjDME2kZ+1MRoaGValb6NJhJsscbQ+55CBrCGXsX2Lh2vnX
	OgfRjMC2cTMsf7Fv1y3ILn/izhRnqaI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-bkdead-9ME-xjyA50iYzQw-1; Wed,
 14 Aug 2024 10:34:47 -0400
X-MC-Unique: bkdead-9ME-xjyA50iYzQw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D02B18EB234;
	Wed, 14 Aug 2024 14:34:45 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 10CBE3001FDD;
	Wed, 14 Aug 2024 14:34:42 +0000 (UTC)
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
Subject: [RFC dlm/next 09/12] kobject: export generic helper ops
Date: Wed, 14 Aug 2024 10:34:11 -0400
Message-ID: <20240814143414.1877505-10-aahringo@redhat.com>
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

This patch exports generic helpers like kset_release() and
kset_get_ownership() so users can use them in their own struct kobj_type
implementation instead of implementing their own functions that do the
same.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 include/linux/kobject.h | 2 ++
 lib/kobject.c           | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 7504b7547ed2..5fbc358e2be6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -181,6 +181,8 @@ kset_type_create_and_add(const char *name, const struct kset_uevent_ops *u,
 struct kset * __must_check
 kset_create_and_add(const char *name, const struct kset_uevent_ops *u,
 		    struct kobject *parent_kobj);
+void kset_release(struct kobject *kobj);
+void kset_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid);
 
 static inline struct kset *to_kset(struct kobject *kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index fbae94ea9bb5..3c455002fd96 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -920,19 +920,21 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 }
 EXPORT_SYMBOL_GPL(kset_find_obj);
 
-static void kset_release(struct kobject *kobj)
+void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
 	pr_debug("'%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
 	kfree(kset);
 }
+EXPORT_SYMBOL_GPL(kset_release);
 
-static void kset_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
+void kset_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
 {
 	if (kobj->parent)
 		kobject_get_ownership(kobj->parent, uid, gid);
 }
+EXPORT_SYMBOL_GPL(kset_get_ownership);
 
 static const struct kobj_type kset_ktype = {
 	.sysfs_ops	= &kobj_sysfs_ops,
-- 
2.43.0

