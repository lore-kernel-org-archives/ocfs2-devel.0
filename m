Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164CF1B5824
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646088; cv=none; b=djRgwNmNwTTUWoZcTZOG08bAaMUX+rifnWJCWs9elQPz7pWWjVGO8H8y1/gBhv6gz6uojBhsDxeznkTO51BuxHrY7RVsYi+d1AwmxnG9bStU5Dyrt+tB/30YZ6l2ElML+OQ/yWiOAjZV2EfW4LSgkK+BCuBlSrAlXqQGgfzkbB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646088; c=relaxed/simple;
	bh=mZ01JtDaUD/i9QmvCnEBD7uT+iQumoqRxJK8mE937U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugaA/fjy6724v6du6f0Hd4jEoX7UAYjiQS07Tp+bUKA+eQwiFW+lTvidwiz8B0Jz/JOfMQIsw5cCcARmOgx/bqopKDxQqOonfP4XkCAo2SqmEPGfMPm4hGgQ9V7uZmMtzTjjPKF52DklOgJ56FqPrPGBC6qUHoHgNwYi/4yVcZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GgqIqV6U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GgqIqV6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xq6iygHBk0ksC7GNR20/uaYtB/Nu4ijVs0KvpevZBKI=;
	b=GgqIqV6U2mDeYUWxOQJh+HenRfPmwICyh50AKfBLK6w9n0kXag++h4ppxRyD1sP3KspWfj
	y/Qnk/d6hTvtMOke/XYDrVNEIKovEj+I5NlMLx9gauBDMdW3J0N3dZJvWGBfyfNZZmtV0v
	auJgP16lXF3yofCcFPmlMc9Wl+3xNbI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-kltiuUI-N0SERsKfbxUp1g-1; Wed,
 14 Aug 2024 10:34:44 -0400
X-MC-Unique: kltiuUI-N0SERsKfbxUp1g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D11B11953945;
	Wed, 14 Aug 2024 14:34:42 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA1F4300019C;
	Wed, 14 Aug 2024 14:34:40 +0000 (UTC)
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
Subject: [RFC dlm/next 08/12] kobject: add kset_type_create_and_add() helper
Date: Wed, 14 Aug 2024 10:34:10 -0400
Message-ID: <20240814143414.1877505-9-aahringo@redhat.com>
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

Currently there exists the kset_create_and_add() helper that does not
allow to have a different ktype for the created kset kobject. To allow
a different ktype this patch will introduce the function
kset_type_create_and_add() that allows to set a different ktype instead
of using the global default kset_ktype variable.

In my example I need to separate the created kobject inside the kset by
net-namespaces. This patch allows me to do that by providing a user
defined kobj_type structure that implements the necessary namespace
functionality.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 include/linux/kobject.h |  8 +++++--
 lib/kobject.c           | 49 +++++++++++++++++++++++++----------------
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index c8219505a79f..7504b7547ed2 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -175,8 +175,12 @@ struct kset {
 void kset_init(struct kset *kset);
 int __must_check kset_register(struct kset *kset);
 void kset_unregister(struct kset *kset);
-struct kset * __must_check kset_create_and_add(const char *name, const struct kset_uevent_ops *u,
-					       struct kobject *parent_kobj);
+struct kset * __must_check
+kset_type_create_and_add(const char *name, const struct kset_uevent_ops *u,
+			 struct kobject *parent_kobj, const struct kobj_type *ktype);
+struct kset * __must_check
+kset_create_and_add(const char *name, const struct kset_uevent_ops *u,
+		    struct kobject *parent_kobj);
 
 static inline struct kset *to_kset(struct kobject *kobj)
 {
diff --git a/lib/kobject.c b/lib/kobject.c
index 72fa20f405f1..fbae94ea9bb5 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -957,7 +957,8 @@ static const struct kobj_type kset_ktype = {
  */
 static struct kset *kset_create(const char *name,
 				const struct kset_uevent_ops *uevent_ops,
-				struct kobject *parent_kobj)
+				struct kobject *parent_kobj,
+				const struct kobj_type *ktype)
 {
 	struct kset *kset;
 	int retval;
@@ -973,17 +974,32 @@ static struct kset *kset_create(const char *name,
 	kset->uevent_ops = uevent_ops;
 	kset->kobj.parent = parent_kobj;
 
-	/*
-	 * The kobject of this kset will have a type of kset_ktype and belong to
-	 * no kset itself.  That way we can properly free it when it is
-	 * finished being used.
-	 */
-	kset->kobj.ktype = &kset_ktype;
+	kset->kobj.ktype = ktype;
 	kset->kobj.kset = NULL;
 
 	return kset;
 }
 
+struct kset *kset_type_create_and_add(const char *name,
+				      const struct kset_uevent_ops *uevent_ops,
+				      struct kobject *parent_kobj,
+				      const struct kobj_type *ktype)
+{
+	struct kset *kset;
+	int error;
+
+	kset = kset_create(name, uevent_ops, parent_kobj, ktype);
+	if (!kset)
+		return NULL;
+	error = kset_register(kset);
+	if (error) {
+		kfree(kset);
+		return NULL;
+	}
+	return kset;
+}
+EXPORT_SYMBOL_GPL(kset_type_create_and_add);
+
 /**
  * kset_create_and_add() - Create a struct kset dynamically and add it to sysfs.
  *
@@ -1002,18 +1018,13 @@ struct kset *kset_create_and_add(const char *name,
 				 const struct kset_uevent_ops *uevent_ops,
 				 struct kobject *parent_kobj)
 {
-	struct kset *kset;
-	int error;
-
-	kset = kset_create(name, uevent_ops, parent_kobj);
-	if (!kset)
-		return NULL;
-	error = kset_register(kset);
-	if (error) {
-		kfree(kset);
-		return NULL;
-	}
-	return kset;
+	/*
+	 * The kobject of this kset will have a type of kset_ktype and belong to
+	 * no kset itself.  That way we can properly free it when it is
+	 * finished being used.
+	 */
+	return kset_type_create_and_add(name, uevent_ops, parent_kobj,
+					&kset_ktype);
 }
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
-- 
2.43.0

