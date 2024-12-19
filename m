Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658DC86344
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575730; cv=none; b=hFgtzHv54RrVE/MhwsInVSMI64Z1A2BfAv1HRnEUpVnC8xGYaN+rPalYl7OfPeVGHVVexqVv7GmSn/jivnB6fKaeooItA0Les2oacGwk87PxTJlx55gtMhi8tNx4BX5uA9C8dNdDVN1MIa1u84pj4j7IWRzO9dQkREApfbS5kqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575730; c=relaxed/simple;
	bh=VeLbyOfvsBoD/0QCt6XTwvSQyL69DBSOWRzzq8d05w8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xp8h7m3SYEuB0TYKWylnQ30YO9b7L5HG3MNH7hyUBCAiPnV5fSw1ClTuKRHj6AFAOBrwVBHFMYlNSJ2wzW4UQG0AJ8LtRkPcix2VOjDTxzmQ4KIWEQwneQpnqk9ZLHmG+b+Jsst9ksCrhCTw23XXMcl9Xu8YPHG4JkEtLu6fgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WI0xXvo2; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WI0xXvo2"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-728f337a921so332226b3a.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575727; x=1735180527; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lFqN6P61Vcxg60EP2migAvtPpkWX8ZEoCx5nNg3/cM=;
        b=WI0xXvo2S1qGDjE/1+j0/0LgMd6TA9g2pMPmFZXJcWy4YKaBF4vgfJNdYCpJoCxTtx
         9fFRWrNeCbcxlohYYELvGnjhkjgeAgY24W03bRORbohvV3ScHf0G5Djjdz71AywRuUfv
         lc30SODl5/KDGAro4txec0xbtK9WsB/T9bJtR38E2anvOFFHMdZqiXo0X4vfEqF23tjk
         GYjWpXId7UcqmgULttQaduJhgnR7PD8gbf32wxnTK3JmNt9LnfBpK4oy9q+OZlZQyl/H
         DYkgswZo2wp3Xn4X3w8qRlKyVupQdIFI1Co0viez9mX8BPJ0p9YY0KoTLVePtDQ9Zz/n
         ciPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575727; x=1735180527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lFqN6P61Vcxg60EP2migAvtPpkWX8ZEoCx5nNg3/cM=;
        b=ncbgL9lJHIH1Qh9gnux0bve/piSWA3rjsWhc3OpbefJiYmpcVtgie+w6fYfKmqGL3H
         7iqxJf4k61NxuGd6uLPD3NSybPfIfRvuJ/EwS35wlf43S/V1j9/Fqw17RHOme8QS+ZiZ
         H6G/+8FEsOUeWSAJe35BtD7UJLh3dZCdzyV4K8zSRvotSLbJm77DQ9VSqnGX6xlbT6uA
         +FWiqaUQKcDhegwGIdj/iSfcg4GmDDH9wV7/8gR3fKd0eEhQ3K4c3L6LCbQ+qEue0FoK
         oDL7Wi1N83USyaJYOGY9Eks7t5h07fjzg7seERdxVF/ZOnePsXqeDrvn4dwI820siP9s
         /J4w==
X-Forwarded-Encrypted: i=1; AJvYcCUVE+MLECuy9mddU0H0LxVKCKZiiw47qOppSRDnVkvPypVIc6l/TJOmMmoQGwJiTebGSHMxCdr+EnIkJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBS1Oj2LONMZ7Bf5Wi99lMrrnE4YdsL5UyfN4oIj84nFtRF8Qq
	RUMeYYfZtSd+Po7xeZPXwERe3iI15VDM8pO0pdMHawO0a6CjHdtu
X-Gm-Gg: ASbGnctVi6cUVHgHSia9fZXQvT0BxSuignE/eW14EwWfAORkj28VAgzuVlcxOelJALD
	0cQ24rjdLsEqQVPEPprL0mxb6W4PhuWdIk2fnR9W/3Kf/xOU2vYx2t9aMYZ16iwh/aF+pW3I8f3
	StJPnBLqzFwM2vOFiraq9yxX+0MmWp+cgiOvU5vUexGuyMWCkgxESE21tXaExf+fNw7fR3SkrTA
	wCel4nk9HMggOIqG5IPDQbHk/FyAq1JAa+jljibj8FHVMUu6kTlw2kNd6S3KU8mZxei/MzcsDno
	Y6NGamc=
X-Google-Smtp-Source: AGHT+IEASYTltYbmKh5ZDA03zBv0Z8CD36/wkPvI28CV3U8CPosE7HG5sfVxRVIBm8iQbfYV7EQNzQ==
X-Received: by 2002:a05:6a21:788c:b0:1e1:b727:181a with SMTP id adf61e73a8af0-1e5c763cc43mr2386992637.24.1734575726666;
        Wed, 18 Dec 2024 18:35:26 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.35.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:26 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org,
	pmladek@suse.com,
	kvalo@kernel.org,
	bp@alien8.de,
	andriy.shevchenko@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Karol Herbst <kherbst@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 5/5] drivers: Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:52 +0800
Message-Id: <20241219023452.69907-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241219023452.69907-1-laoar.shao@gmail.com>
References: <20241219023452.69907-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org> (For tty)
Reviewed-by: Lyude Paul <lyude@redhat.com> (For nouveau)
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
---
 drivers/accel/habanalabs/common/context.c           |  3 +--
 drivers/accel/habanalabs/common/habanalabs_ioctl.c  | 11 +++--------
 drivers/gpu/drm/i915/display/intel_display_driver.c |  6 ++----
 drivers/gpu/drm/nouveau/nouveau_chan.c              |  4 +---
 drivers/gpu/drm/nouveau/nouveau_drm.c               |  5 ++---
 drivers/tty/tty_io.c                                |  3 +--
 6 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/accel/habanalabs/common/context.c b/drivers/accel/habanalabs/common/context.c
index b83141f58319..9f212b17611a 100644
--- a/drivers/accel/habanalabs/common/context.c
+++ b/drivers/accel/habanalabs/common/context.c
@@ -199,7 +199,6 @@ int hl_ctx_create(struct hl_device *hdev, struct hl_fpriv *hpriv)
 
 int hl_ctx_init(struct hl_device *hdev, struct hl_ctx *ctx, bool is_kernel_ctx)
 {
-	char task_comm[TASK_COMM_LEN];
 	int rc = 0, i;
 
 	ctx->hdev = hdev;
@@ -272,7 +271,7 @@ int hl_ctx_init(struct hl_device *hdev, struct hl_ctx *ctx, bool is_kernel_ctx)
 		mutex_init(&ctx->ts_reg_lock);
 
 		dev_dbg(hdev->dev, "create user context, comm=\"%s\", asid=%u\n",
-			get_task_comm(task_comm, current), ctx->asid);
+			current->comm, ctx->asid);
 	}
 
 	return 0;
diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
index 1dd6e23172ca..8729a0c57d78 100644
--- a/drivers/accel/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
@@ -1279,13 +1279,10 @@ static long _hl_ioctl(struct hl_fpriv *hpriv, unsigned int cmd, unsigned long ar
 		retcode = -EFAULT;
 
 out_err:
-	if (retcode) {
-		char task_comm[TASK_COMM_LEN];
-
+	if (retcode)
 		dev_dbg_ratelimited(dev,
 				"error in ioctl: pid=%d, comm=\"%s\", cmd=%#010x, nr=%#04x\n",
-				task_pid_nr(current), get_task_comm(task_comm, current), cmd, nr);
-	}
+				task_pid_nr(current), current->comm, cmd, nr);
 
 	if (kdata != stack_kdata)
 		kfree(kdata);
@@ -1308,11 +1305,9 @@ long hl_ioctl_control(struct file *filep, unsigned int cmd, unsigned long arg)
 	if (nr == _IOC_NR(DRM_IOCTL_HL_INFO)) {
 		ioctl = &hl_ioctls_control[nr - HL_COMMAND_START];
 	} else {
-		char task_comm[TASK_COMM_LEN];
-
 		dev_dbg_ratelimited(hdev->dev_ctrl,
 				"invalid ioctl: pid=%d, comm=\"%s\", cmd=%#010x, nr=%#04x\n",
-				task_pid_nr(current), get_task_comm(task_comm, current), cmd, nr);
+				task_pid_nr(current), current->comm, cmd, nr);
 		return -ENOTTY;
 	}
 
diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index 56b78cf6b854..62596424a9aa 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -391,7 +391,6 @@ void intel_display_driver_resume_access(struct drm_i915_private *i915)
  */
 bool intel_display_driver_check_access(struct drm_i915_private *i915)
 {
-	char comm[TASK_COMM_LEN];
 	char current_task[TASK_COMM_LEN + 16];
 	char allowed_task[TASK_COMM_LEN + 16] = "none";
 
@@ -400,12 +399,11 @@ bool intel_display_driver_check_access(struct drm_i915_private *i915)
 		return true;
 
 	snprintf(current_task, sizeof(current_task), "%s[%d]",
-		 get_task_comm(comm, current),
-		 task_pid_vnr(current));
+		 current->comm, task_pid_vnr(current));
 
 	if (i915->display.access.allowed_task)
 		snprintf(allowed_task, sizeof(allowed_task), "%s[%d]",
-			 get_task_comm(comm, i915->display.access.allowed_task),
+			 i915->display.access.allowed_task->comm,
 			 task_pid_vnr(i915->display.access.allowed_task));
 
 	drm_dbg_kms(&i915->drm,
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index 2cb2e5675807..cd659b9fd1d9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -279,7 +279,6 @@ nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
 	const u64 plength = 0x10000;
 	const u64 ioffset = plength;
 	const u64 ilength = 0x02000;
-	char name[TASK_COMM_LEN];
 	int cid, ret;
 	u64 size;
 
@@ -338,8 +337,7 @@ nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
 		chan->userd = &chan->user;
 	}
 
-	get_task_comm(name, current);
-	snprintf(args.name, sizeof(args.name), "%s[%d]", name, task_pid_nr(current));
+	snprintf(args.name, sizeof(args.name), "%s[%d]", current->comm, task_pid_nr(current));
 
 	ret = nvif_object_ctor(&device->object, "abi16ChanUser", 0, hosts[cid].oclass,
 			       &args, sizeof(args), &chan->user);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 107f63f08bd9..ea7206484d22 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1159,7 +1159,7 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_cli *cli;
-	char name[32], tmpname[TASK_COMM_LEN];
+	char name[32];
 	int ret;
 
 	/* need to bring up power immediately if opening device */
@@ -1169,10 +1169,9 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 		return ret;
 	}
 
-	get_task_comm(tmpname, current);
 	rcu_read_lock();
 	snprintf(name, sizeof(name), "%s[%d]",
-		 tmpname, pid_nr(rcu_dereference(fpriv->pid)));
+		 current->comm, pid_nr(rcu_dereference(fpriv->pid)));
 	rcu_read_unlock();
 
 	if (!(cli = kzalloc(sizeof(*cli), GFP_KERNEL))) {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9771072da177..102e31f62f76 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2622,14 +2622,13 @@ static int tty_tiocgicount(struct tty_struct *tty, void __user *arg)
 
 static int tty_set_serial(struct tty_struct *tty, struct serial_struct *ss)
 {
-	char comm[TASK_COMM_LEN];
 	int flags;
 
 	flags = ss->flags & ASYNC_DEPRECATED;
 
 	if (flags)
 		pr_warn_ratelimited("%s: '%s' is using deprecated serial flags (with no effect): %.8x\n",
-				__func__, get_task_comm(comm, current), flags);
+				__func__, current->comm, flags);
 
 	if (!tty->ops->set_serial)
 		return -ENOTTY;
-- 
2.43.5

