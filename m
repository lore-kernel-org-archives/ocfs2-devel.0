Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E81A42C3
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727275; cv=none; b=o5o6TVW9jsl34aEj4QLUV8F47AD4iep7WKxQUi6SI+lps8Fyj/jPQj+wbtjBM2HsfRILYMnv3mYdpIHIZUIOwdAQsuDS1FaanN3STbhYt8EULcbG16nZn3pmhK+g999vqilS34uxDDCldJr4C985+Q6JAXKOOGSmFBRnOSLiJSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727275; c=relaxed/simple;
	bh=x7e6IA84Y6g/2IMVAFPlI1KZz8qVpAguY4Mb70GdZTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHRKqC2SIJYFKpgahFH9fiS4GxKMc7AFYrC4jojg35dTX8PBr7xGNvH6Iz0taVtc477RnvVGFSM4h1A/q6DzVeRH4j+ArjyTiNezTq8wYnzwfdsvPgOhMA8I2domC5KQfc/DpNajA0iNknZKocZsY2wzKcxnmgZnDry86nQXq6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W388tkA3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W388tkA3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQhx9++kG+k1aQeYKn4epgOWGCe4SvtQMhjT//HHnyw=;
	b=W388tkA3W1rFGx36GqvJ8sU7tNMWck/m59WfB3iaaF0A+yTruVHEr32PFsl/LA6g2yEGbM
	yapFXHwaNqNCHrdZCJzAQdtYefAx67vuXkGETspsi0ZrOK7YiX+2t9EDuj8wW7GbFLxsbf
	KLznH/64tgVoEr1KJruUuO+QIGXtSXI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-L1BWnzkOOyWOiKrPDnaWyg-1; Mon,
 30 Sep 2024 16:14:29 -0400
X-MC-Unique: L1BWnzkOOyWOiKrPDnaWyg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BD391955F3C;
	Mon, 30 Sep 2024 20:14:27 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC4081955DC7;
	Mon, 30 Sep 2024 20:14:24 +0000 (UTC)
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
	donald.hunter@gmail.com,
	aahringo@redhat.com
Subject: [PATCHv2 dlm/next 08/12] kobject: add kset_type_create_and_add() helper
Date: Mon, 30 Sep 2024 16:13:54 -0400
Message-ID: <20240930201358.2638665-9-aahringo@redhat.com>
In-Reply-To: <20240930201358.2638665-1-aahringo@redhat.com>
References: <20240930201358.2638665-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Currently there exists the kset_create_and_add() helper that does not
allow to have a different ktype for the created kset kobject. To allow
a different ktype this patch will introduce the function
kset_type_create_and_add() that allows to set a different ktype instead
of using the global default kset_ktype variable.

In my example I need to separate the created kobject inside the kset by
net-namespaces. This patch allows me to do that by providing a user
defined kobj_type structure that implements the necessary namespace
functionality.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 include/linux/kobject.h |  8 ++++--
 lib/kobject.c           | 59 ++++++++++++++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 17 deletions(-)

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
index 72fa20f405f1..09dd3d4c7f56 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -946,6 +946,7 @@ static const struct kobj_type kset_ktype = {
  * @name: the name for the kset
  * @uevent_ops: a struct kset_uevent_ops for the kset
  * @parent_kobj: the parent kobject of this kset, if any.
+ * @ktype: a struct kobj_type for the kset
  *
  * This function creates a kset structure dynamically.  This structure can
  * then be registered with the system and show up in sysfs with a call to
@@ -957,7 +958,8 @@ static const struct kobj_type kset_ktype = {
  */
 static struct kset *kset_create(const char *name,
 				const struct kset_uevent_ops *uevent_ops,
-				struct kobject *parent_kobj)
+				struct kobject *parent_kobj,
+				const struct kobj_type *ktype)
 {
 	struct kset *kset;
 	int retval;
@@ -973,39 +975,38 @@ static struct kset *kset_create(const char *name,
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
 
 /**
- * kset_create_and_add() - Create a struct kset dynamically and add it to sysfs.
+ * kset_type_create_and_add() - Create a struct kset with kobj_type dynamically
+ *                              and add it to sysfs.
  *
  * @name: the name for the kset
  * @uevent_ops: a struct kset_uevent_ops for the kset
  * @parent_kobj: the parent kobject of this kset, if any.
+ * @ktype: a struct kobj_type for the kset
  *
- * This function creates a kset structure dynamically and registers it
- * with sysfs.  When you are finished with this structure, call
+ * This function creates a kset structure with ktype structure dynamically and
+ * registers it with sysfs.  When you are finished with this structure, call
  * kset_unregister() and the structure will be dynamically freed when it
- * is no longer being used.
+ * is no longer being used. Works like kset_create_and_add() just with the
+ * possibility to assign kobj_type to the kset.
  *
  * If the kset was not able to be created, NULL will be returned.
  */
-struct kset *kset_create_and_add(const char *name,
-				 const struct kset_uevent_ops *uevent_ops,
-				 struct kobject *parent_kobj)
+struct kset *kset_type_create_and_add(const char *name,
+				      const struct kset_uevent_ops *uevent_ops,
+				      struct kobject *parent_kobj,
+				      const struct kobj_type *ktype)
 {
 	struct kset *kset;
 	int error;
 
-	kset = kset_create(name, uevent_ops, parent_kobj);
+	kset = kset_create(name, uevent_ops, parent_kobj, ktype);
 	if (!kset)
 		return NULL;
 	error = kset_register(kset);
@@ -1015,6 +1016,34 @@ struct kset *kset_create_and_add(const char *name,
 	}
 	return kset;
 }
+EXPORT_SYMBOL_GPL(kset_type_create_and_add);
+
+/**
+ * kset_create_and_add() - Create a struct kset dynamically and add it to sysfs.
+ *
+ * @name: the name for the kset
+ * @uevent_ops: a struct kset_uevent_ops for the kset
+ * @parent_kobj: the parent kobject of this kset, if any.
+ *
+ * This function creates a kset structure dynamically and registers it
+ * with sysfs.  When you are finished with this structure, call
+ * kset_unregister() and the structure will be dynamically freed when it
+ * is no longer being used.
+ *
+ * If the kset was not able to be created, NULL will be returned.
+ */
+struct kset *kset_create_and_add(const char *name,
+				 const struct kset_uevent_ops *uevent_ops,
+				 struct kobject *parent_kobj)
+{
+	/*
+	 * The kobject of this kset will have a type of kset_ktype and belong to
+	 * no kset itself.  That way we can properly free it when it is
+	 * finished being used.
+	 */
+	return kset_type_create_and_add(name, uevent_ops, parent_kobj,
+					&kset_ktype);
+}
 EXPORT_SYMBOL_GPL(kset_create_and_add);
 
 
-- 
2.43.0

