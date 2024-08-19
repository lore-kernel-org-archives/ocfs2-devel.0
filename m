Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893218C916
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 18:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092710; cv=none; b=PYk3YCv3Fl1Ek5gS8fjhwXNoQVwjwVJI1mUT1esh1AUZcHJEhCTxzsD1WU6Tmspse66031RvvhWIq7zReNeUi7/02EjEmIaElAUohUVyeCB7UevT/zboBkDt5/VV/9JBlRhqApV2NoyeDq7eoAgE/wv3f31ObY1Na/HM/mHEqjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092710; c=relaxed/simple;
	bh=3sFK6ohKBfjbKqpeMer5E4SiRe74+gADhS8Xvs8bGjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuFghzrubBeQ9x7Ke+e02NmnPcbroqEVtrB1rxp7CPDHHrF8LmBZeX8mhbalfBTgQrrqdoHKWTn14kXah6mb3ns/kG0BjciENUdijTtUgwo/bj0x9QHz5qPKC6fa7YXNJkDLo+q0DjoeT55/srMqusbPnbJr9ZNjFBMiyWCBLEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agug31Az; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agug31Az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5yoLzHqzDYMoo8JKEcZUXSdhcVw5MkEGCtLdOL8Nxw=;
	b=agug31AzC8dZYkL+SpoiCKCyyWCbep+3iKv4fhtSPBLitliKIa8mlS/7SylYlebsV0SqvJ
	2bKh2zx4xrP+17qRg+Nfz4yH2A26vOzzGhFBtCxKGS9kM6FD58APj4Cj4LSlGhhpUXEOPH
	yoirXQuxIvkc2rP4KQTsYgQ7yjfTq1I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-cMLgutugOeOZ0EFlL1Yu7A-1; Mon,
 19 Aug 2024 14:38:21 -0400
X-MC-Unique: cMLgutugOeOZ0EFlL1Yu7A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77A481955F08;
	Mon, 19 Aug 2024 18:38:19 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B997719560A3;
	Mon, 19 Aug 2024 18:38:16 +0000 (UTC)
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
Subject: [PATCH dlm/next 07/12] dlm: rename config to configfs
Date: Mon, 19 Aug 2024 14:37:37 -0400
Message-ID: <20240819183742.2263895-8-aahringo@redhat.com>
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

