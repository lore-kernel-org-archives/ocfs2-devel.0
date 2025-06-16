Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0D12264AC;
	Mon, 16 Jun 2025 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750071069; cv=none; b=fCpGqucqNNfiNybBCd3OG4oIRWAdU0P9EFmuzHUDpazt7lSSARMeXIys1/Ir8tK1/vC1wfKLHeLgPBklq1ZdhA6WDlFlh7zZqFVL6FMNyB9SXJmegK2E5Txa+4iZydIzRbqEnfLXS0mlHYX1O+XQtvYwaAiyYsUonoJfMysWV2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750071069; c=relaxed/simple;
	bh=mW/gM49W+/lH6XeJ73Jgnv8wvFZuY8rej9CVO1OjhSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pfo53Y2/2lbR4Ma2lTjwT8s1okYVgw9kZtxARQO+hE40Qw5e8OVuAC0gRwipUmLCPDHbS6dKm/B8vleYFs5PIA8AuNQR308NSOXBDyO+sKo8xELt98AiJhczTBtdY4XDeXKNRhnvjdHX69RsgDzlqIhpNInvAeKxuA6wY99yoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiRr597n; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiRr597n"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b2f0faeb994so4845235a12.0;
        Mon, 16 Jun 2025 03:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750071067; x=1750675867; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XiZT8fyfWnDQ5DnwRzZVizGiA0t8KqH/r5W4lxBjzhw=;
        b=aiRr597nFRWbS2Id87eeyTEDHCF4UQyo3VqQCHE/AxciYDsjhQYsABk84WWrXuos+N
         tzsKTRstD3fC/cg1Of3eLncxgzpQZxpiyGMX6DbQCDqr3XnbKphhN1ZoHWHR4ykph1IZ
         l8Q+7yJtwGG8Y0xZ/gRWd3f+t3KZpR1ZWHNji9gCYkaMriQKhjdsj9CgKaT4ow8ch6y8
         QVjT6SieGs75lC0QwhSn7xFgen4V6FhTJCRV9Wt0E8SpJjuCs4TyxHkC2+HVx4lqtHWu
         Ha5AGkmGDVptES/iiRlLPhc6mRGb+4JJZD0wNjca5GvBNylPg3uBmA/9VW/oMEPoFM0h
         YBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750071067; x=1750675867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XiZT8fyfWnDQ5DnwRzZVizGiA0t8KqH/r5W4lxBjzhw=;
        b=qzbwri6Xtih10CBuunIuz4QVpxqJhvz3jcJLP+8Izcjf2C+bN+b7/yzPSzUtyz/0lV
         RkRpJ4/IZc+IUSyGtSTYutjcZZ2vfXk4qGrG6vmKJZgGXNnDqlz+OiAXp/Onipbb0X26
         FxQAaFoxYqEqgH4yQzcd/fXkf6fy2Lo0DD+dToVokV9oiEYMiKWOX0eBZT85HHKm9DyI
         uzsAFgHrAtZEKnSmCWWgY8HLuA9VfEScrzC6fSsWVBuLjThMWoDWL2+4mteB3cxb6S60
         xyLntToiILxkeZ23qmH7oy8nYEA3b6c2zqUFB8GlPU7KFHRsRGF/WzI0i0K/EbPUR30c
         FnAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhMPX3OoMwU8+8g4WbwiWNVxoVpCiKkRK04I7IkvzlpcHpT6wUf46UyXkBQrbIfgmOR3WYhvOmKnc2BLM=@lists.linux.dev, AJvYcCWLSfLczUFmmTeepuLTf+MdZ5FJ1CwwpMRRvUxUEbZOM+ShWAiUP4Hv3SDCGi1T39kOlj1JES03yEB/EWUFBCDyWVQPwA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxhL1cntcV+JdTpryTmMiR0femVaIXXP18ZagHbWwK2+y1+9GAB
	CvyY4UcpG1a3nAMR+gKIccDhk6EbgYGN2ID+wNNtX7H9mz1yWpUwI45n
X-Gm-Gg: ASbGnctNjk+QUBnvF5daM5iOIQjBOwZesl9iMc2l0wZIcS8fFjqliFctm4Dh1FWBkn9
	ElhQxTVh2qsJbwcnpfT2FnSMyjNCTzVcd3Vgr1dh0AwkticXHPqASlVlxv346GeqRmrS9Gdd4hX
	sOQKN8xr6UGLOANm0///yesMKeVcOeHoMzbJeuZASqKJhWTtBqWNoVkdTaptv/ORptoLG+jMTKI
	oan7QhCrrgaoSO3IvQfoZLcGgG2jFG16CVfiXPHEl4R4VxK4isgvaUVde0KhjQzRSQ7QBoaLxK3
	O4rVFwV2wf0cr6M2b3LTDnuZtuj+8MEy62cJ80H8jA8f5JdYqcSFJ0IM2sSgySXWiBB7KkeMZlM
	u3jEc6CtW/qm1bNd7Iw==
X-Google-Smtp-Source: AGHT+IE4omYKJqyL/KYZqyQgCYrH8mhzUBKZKG0S+o6pOvpI7nPqf26GDX0iloH0LttyYw/5k0ECNQ==
X-Received: by 2002:a05:6a21:150b:b0:215:ead1:b867 with SMTP id adf61e73a8af0-21fbd56945amr14844625637.14.1750071066946;
        Mon, 16 Jun 2025 03:51:06 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c68:884c:5800:7324:c411:408d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe15bb83asm5508221a12.0.2025.06.16.03.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 03:51:06 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: skhan@linuxfoundation.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] fs/ocfs2: use scnprintf() in show functions
Date: Mon, 16 Jun 2025 16:20:28 +0530
Message-ID: <20250616105028.371633-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace all snprintf() instances with scnprintf(). snprintf() returns
the number of bytes that would have been written had there been enough
space. For sysfs attributes, snprintf() should not be used for the
show() method. Instead use scnprintf() which returns the number of bytes
actually written.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 fs/ocfs2/cluster/masklog.c |  2 +-
 fs/ocfs2/cluster/sys.c     |  2 +-
 fs/ocfs2/stackglue.c       | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 563881ddbf00..0bc21dc71d29 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -28,7 +28,7 @@ static ssize_t mlog_mask_show(u64 mask, char *buf)
 	else
 		state = "off";
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", state);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", state);
 }
 
 static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 022f716c74ff..23febbe3dc5d 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -21,7 +21,7 @@
 static ssize_t version_show(struct kobject *kobj, struct kobj_attribute *attr,
 			    char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%u\n", O2NM_API_VERSION);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", O2NM_API_VERSION);
 }
 static struct kobj_attribute attr_version =
 	__ATTR(interface_revision, S_IRUGO, version_show, NULL);
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index a28c127b9934..9af03869a04b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -477,9 +477,9 @@ static ssize_t ocfs2_max_locking_protocol_show(struct kobject *kobj,
 
 	spin_lock(&ocfs2_stack_lock);
 	if (locking_max_version.pv_major)
-		ret = snprintf(buf, PAGE_SIZE, "%u.%u\n",
-			       locking_max_version.pv_major,
-			       locking_max_version.pv_minor);
+		ret = scnprintf(buf, PAGE_SIZE, "%u.%u\n",
+				locking_max_version.pv_major,
+				locking_max_version.pv_minor);
 	spin_unlock(&ocfs2_stack_lock);
 
 	return ret;
@@ -525,8 +525,8 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
 
 	spin_lock(&ocfs2_stack_lock);
 	if (active_stack) {
-		ret = snprintf(buf, PAGE_SIZE, "%s\n",
-			       active_stack->sp_name);
+		ret = scnprintf(buf, PAGE_SIZE, "%s\n",
+				active_stack->sp_name);
 		if (ret >= PAGE_SIZE)
 			ret = -E2BIG;
 	}
@@ -545,7 +545,7 @@ static ssize_t ocfs2_cluster_stack_show(struct kobject *kobj,
 {
 	ssize_t ret;
 	spin_lock(&ocfs2_stack_lock);
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", cluster_stack_name);
+	ret = scnprintf(buf, PAGE_SIZE, "%s\n", cluster_stack_name);
 	spin_unlock(&ocfs2_stack_lock);
 
 	return ret;
@@ -595,7 +595,7 @@ static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
 					struct kobj_attribute *attr,
 					char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "1\n");
+	return scnprintf(buf, PAGE_SIZE, "1\n");
 }
 
 static struct kobj_attribute ocfs2_attr_dlm_recover_support =
-- 
2.49.0

