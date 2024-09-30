Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12911A38E9
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727270; cv=none; b=dy7qFNyjzWuDrxOxJcMPPbqBUYTlKHbtoa7U5fFLzvJUe/YisnKC8KedoDQSaKyxAYIIWEqOwW0cpnxbjK71C29mdGVo9eTq+T9VuEj6XkrIbMimb0YE36FVdom38DAwvMbyXKuC4cOicLRYgEqIUt5VhJ3IhT3uEpsavziTl7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727270; c=relaxed/simple;
	bh=3sFK6ohKBfjbKqpeMer5E4SiRe74+gADhS8Xvs8bGjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKlwbYmwJcJVA9zsuUgGqrIkdIrlACoP5649vc0K+GUkyabDooL5expL9JWKlonUOorsZsTrQMU/t6GTxOtqqX1oKLTWxaGQGWzhiPpYuRTGxrP6f2PC4xdVjB2f77Tl4YAOHUK28UaEvsYT2kLhrfb1/9ZE6NkM7yJknT6Q82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JIO3GJO2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JIO3GJO2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5yoLzHqzDYMoo8JKEcZUXSdhcVw5MkEGCtLdOL8Nxw=;
	b=JIO3GJO2tvDVKIhWjyAR2Erx7ESTiX8nJn3GRmVF0NPaH4USGsUWLlFlY/uTSwXksahi/X
	I5IN7sS83y5GHmugWG29cZIlx3hN12G+hwlaAt0uFEVkLQHnFhDxhfuev2WWyZCxQOXc+D
	HBXUmr71iLS6ylmfmY0ZmFUh4lYcsXQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-WrNaCy74Pky-JAdSQRPKvw-1; Mon,
 30 Sep 2024 16:14:26 -0400
X-MC-Unique: WrNaCy74Pky-JAdSQRPKvw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89072196A105;
	Mon, 30 Sep 2024 20:14:24 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (unknown [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EDDFE1955DCD;
	Mon, 30 Sep 2024 20:14:21 +0000 (UTC)
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
Subject: [PATCHv2 dlm/next 07/12] dlm: rename config to configfs
Date: Mon, 30 Sep 2024 16:13:53 -0400
Message-ID: <20240930201358.2638665-8-aahringo@redhat.com>
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

This patch will rename the config.c implementation file to configfs.c as
in further patches we will introduce a configuration layer to allow
different UAPI mechanism operate on current configfs configurations. We
need a different UAPI mechanism as we want to separate our configuration
on a per net-namespaces basis. The new file "configfs.c" only contains
functionality to maintain configfs handling.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/Makefile                 | 2 +-
 fs/dlm/{config.c => configfs.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename fs/dlm/{config.c => configfs.c} (100%)

diff --git a/fs/dlm/Makefile b/fs/dlm/Makefile
index 5a471af1d1fe..48959179fc78 100644
--- a/fs/dlm/Makefile
+++ b/fs/dlm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_DLM) +=		dlm.o
 dlm-y :=			ast.o \
-				config.o \
+				configfs.o \
 				dir.o \
 				lock.o \
 				lockspace.o \
diff --git a/fs/dlm/config.c b/fs/dlm/configfs.c
similarity index 100%
rename from fs/dlm/config.c
rename to fs/dlm/configfs.c
-- 
2.43.0

