Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164451B32DC
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Aug 2024 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646088; cv=none; b=MoTvDAYvkSgURZ6gK27H4E1ayoYBmiG8z/zDW8pzA17UTCigEl+qaKGq1KBTFyuHyvxGWDQo48cv2lxSyayWwx93n7qWarqbwQf9esRUPceQd8XOZdHzzA+gpybopRMSGP7coVvR1ODbr+j1WHKPLTLBUzVD/IO5tSfJ0YXCH2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646088; c=relaxed/simple;
	bh=3sFK6ohKBfjbKqpeMer5E4SiRe74+gADhS8Xvs8bGjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbYMP+NKOJsnxbhsnLGF9/A0x6gTjEYfk8nit/4wAG5k1HVGb6mk+jJG973jwS9AzGKdWSDd7xaZ2SUnhI4enL0KRhxcX/HqGbG4RnoafoZK3ZBlBf4qG2jEBdGKU5z0COxwqa7MBmjTaYkhDoCTNKGpz5yc5bxLvvRZbF12EuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Js+UIFhJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Js+UIFhJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5yoLzHqzDYMoo8JKEcZUXSdhcVw5MkEGCtLdOL8Nxw=;
	b=Js+UIFhJJ24v5IS2Np71Epyruf022G5UDFDB9qZpvJrlvA8t3FUnY6VSb61GnDomH7Zpw/
	mxqMjXcrt2D2lwQl7nSbZZW8D9/zs/T0upK8xdE0X7dHZoWcwv5pfhy4hWDMGTzSk5p/NR
	pJmsEODa0IJ49CuKTyXiCHh6bXDY5xk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-RM_na9fePw-MPpXM1dCruQ-1; Wed,
 14 Aug 2024 10:34:42 -0400
X-MC-Unique: RM_na9fePw-MPpXM1dCruQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9364D18EA946;
	Wed, 14 Aug 2024 14:34:40 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E7C5300019A;
	Wed, 14 Aug 2024 14:34:38 +0000 (UTC)
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
Subject: [RFC dlm/next 07/12] dlm: rename config to configfs
Date: Wed, 14 Aug 2024 10:34:09 -0400
Message-ID: <20240814143414.1877505-8-aahringo@redhat.com>
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

