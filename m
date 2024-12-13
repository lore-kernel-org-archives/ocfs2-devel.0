Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850D18C039
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068852; cv=none; b=YDb/IDsbfYFZh/Z94HPAWjIpFWU6LmZbDk9ijRLSrj2ngZ/fBjwLJScPdprTE+OTiTDPsLsi6WVZpBltyvZHOBbGbyTHFS95CH+p2hKA/D/aKlnOlbOSaKfW30W6XVS5VfT8p909CFQXzJwYONH00qTZ3IzwYJmxJ/jxIrVG/Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068852; c=relaxed/simple;
	bh=KjNx//tf6qnRkSn9x4PGnNW5eZ14kzaocEF//pfnNk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jsI4q9QjKFbM0+TqeBlR/ycRhLy4/OpBT2fbAc9mnLB7PGetEBBeeAk7EfgArxi39ij9lDKSSQhmzYlEkKG/+LWDz9g3l0bwcudxLEaUKAcrH0bDbB4J6c7CXnUyVjxycOUoxOZxrWJVqe26vDBVcBxSZEcW5a6VTpTVFFgbHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4kw6RqP; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4kw6RqP"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-8019f048bc7so1024970a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068850; x=1734673650; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WABVozVaGAUeC6WVv6dNDEWCXVmF+XIaxOqP2xXRnSs=;
        b=P4kw6RqPrXSPymq0QvLIdLzoW+q5PF2vQgU4v9/EazyJoE2m1NGinDYImQQazp/lWB
         Jrm7/ATxRW+XpOmMMkwN7FKrmXw3UdWhRRKBavNfQ9LRwDhzpVr/xUCwqY1YleAcrLZO
         xCspLLD7FY/Nm5obPOqNjJbJvJKbVvZTqrLm/Ab1FQNrFuEuOkpLGpCEo9xfly66wBYD
         sC17+PKDzDumAAWoXLcxhMj5KI2dMM/mAHuuQPf9ishoy96GosbIEdXPeaN157E6I9tm
         qcAc31kiQoyGtctQ1vIZOH8bRkgL3Yc8Un/nuNTqGW0YlvAP+oDhRJcBoc/wOHWg/noI
         XRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068850; x=1734673650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WABVozVaGAUeC6WVv6dNDEWCXVmF+XIaxOqP2xXRnSs=;
        b=cL45jT1o2uD8bUawogTVZ/Oz6EaywUF8+Vry0YwF0W/w6LlVYnCqlbu3NNwxJPa+x0
         imUGsRyY1nZ73aG9qhxpdT8iiHrznsm5fHxWbe7faCyNZqW3PrIz1l0iEJItlI61g7oQ
         1ZI9cdbrqm4RyzvZvjdkKHX4Z8bwlkPFNzyqQMOl+AzKAtw9ceXEeHsun9EN9j5K1tXv
         Ge8GAu8UvP+95PV4WtHGC5cd04PZVq71MORgKxA+93jdwgeJcFDDPCtMu8jqCGcelmfj
         sBNg3AQu8AM21ZQpbpIuEXJNJBeKSQslnJNwSh8d1QH0ttr1/VJ6hLBdCM24sOW07FG2
         Or9g==
X-Forwarded-Encrypted: i=1; AJvYcCXc/EhXWcnuQ90667xVMUgXbZBCEX+fn3hHqqbdifAUQPUypI+4nBV+APPE3tHZ0iVZag69riyrLtj2mA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwExgnaVCzP+42PDQ6tSCGnh2h3DmMU9QkRFGckoUr+RbZ1ebGL
	jpWiPI80Pm0OP8BCl1JwaMD2XAHZakT02ujyIGArPkGIXNEGEfom
X-Gm-Gg: ASbGnctaGZom2GQTzLM3e7G4D9kv2zoqVcaPjKB9pFhM2kBdFZRCLU3mCZAc+ZKJ1kj
	2xBN/m6MQe976fjW/3eK9mReoriEF5+ZyM2qrqo64g53VV5i7twS4ssJcxhkHuiZYiQ+JigWnBq
	p6S39hUbggGxHyJ+vgSfm93fATeNQ4J3/hsU6Xs7EyV7u/p4wkmq9kwqsjnyvnh/rKvqV2NAPPc
	a5ZO3jyStv/L2wJcK60cdRsZyNWB76Vihzawy8Dl3gJXwWWpXwx0TiHO5Doh9ZYmW0E538lWRZS
	MeZV9xs=
X-Google-Smtp-Source: AGHT+IGFE1mRmyM5NL2PUAWpAoscqFHXvU8vwTTuUZkYB6i9lL3x0jZgiaefTaKhcRetCPxuiJ6lzw==
X-Received: by 2002:a17:90b:3889:b0:2ee:aa28:79aa with SMTP id 98e67ed59e1d1-2f28fa55d20mr2136406a91.6.1734068850070;
        Thu, 12 Dec 2024 21:47:30 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.47.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:47:29 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
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
	Ofir Bitton <obitton@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6/7] drivers: Repace get_task_comm() with %pTN
Date: Fri, 13 Dec 2024 13:46:09 +0800
Message-Id: <20241213054610.55843-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
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
Cc: Ofir Bitton <obitton@habana.ai>
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
 drivers/accel/habanalabs/common/context.c         |  5 ++---
 .../accel/habanalabs/common/habanalabs_ioctl.c    | 15 +++++----------
 .../gpu/drm/i915/display/intel_display_driver.c   | 10 ++++------
 drivers/gpu/drm/nouveau/nouveau_chan.c            |  4 +---
 drivers/gpu/drm/nouveau/nouveau_drm.c             |  7 +++----
 drivers/tty/tty_io.c                              |  5 ++---
 6 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/accel/habanalabs/common/context.c b/drivers/accel/habanalabs/common/context.c
index b83141f58319..e4026051b735 100644
--- a/drivers/accel/habanalabs/common/context.c
+++ b/drivers/accel/habanalabs/common/context.c
@@ -199,7 +199,6 @@ int hl_ctx_create(struct hl_device *hdev, struct hl_fpriv *hpriv)
 
 int hl_ctx_init(struct hl_device *hdev, struct hl_ctx *ctx, bool is_kernel_ctx)
 {
-	char task_comm[TASK_COMM_LEN];
 	int rc = 0, i;
 
 	ctx->hdev = hdev;
@@ -271,8 +270,8 @@ int hl_ctx_init(struct hl_device *hdev, struct hl_ctx *ctx, bool is_kernel_ctx)
 
 		mutex_init(&ctx->ts_reg_lock);
 
-		dev_dbg(hdev->dev, "create user context, comm=\"%s\", asid=%u\n",
-			get_task_comm(task_comm, current), ctx->asid);
+		dev_dbg(hdev->dev, "create user context, comm=\"%pTN\", asid=%u\n",
+			current, ctx->asid);
 	}
 
 	return 0;
diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
index 1dd6e23172ca..32678cd0775a 100644
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
-				"error in ioctl: pid=%d, comm=\"%s\", cmd=%#010x, nr=%#04x\n",
-				task_pid_nr(current), get_task_comm(task_comm, current), cmd, nr);
-	}
+				"error in ioctl: pid=%d, comm=\"%pTN\", cmd=%#010x, nr=%#04x\n",
+				task_pid_nr(current), current, cmd, nr);
 
 	if (kdata != stack_kdata)
 		kfree(kdata);
@@ -1308,11 +1305,9 @@ long hl_ioctl_control(struct file *filep, unsigned int cmd, unsigned long arg)
 	if (nr == _IOC_NR(DRM_IOCTL_HL_INFO)) {
 		ioctl = &hl_ioctls_control[nr - HL_COMMAND_START];
 	} else {
-		char task_comm[TASK_COMM_LEN];
-
 		dev_dbg_ratelimited(hdev->dev_ctrl,
-				"invalid ioctl: pid=%d, comm=\"%s\", cmd=%#010x, nr=%#04x\n",
-				task_pid_nr(current), get_task_comm(task_comm, current), cmd, nr);
+				"invalid ioctl: pid=%d, comm=\"%pTN\", cmd=%#010x, nr=%#04x\n",
+				task_pid_nr(current), current, cmd, nr);
 		return -ENOTTY;
 	}
 
diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index 56b78cf6b854..416aff49ceb8 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -391,7 +391,6 @@ void intel_display_driver_resume_access(struct drm_i915_private *i915)
  */
 bool intel_display_driver_check_access(struct drm_i915_private *i915)
 {
-	char comm[TASK_COMM_LEN];
 	char current_task[TASK_COMM_LEN + 16];
 	char allowed_task[TASK_COMM_LEN + 16] = "none";
 
@@ -399,13 +398,12 @@ bool intel_display_driver_check_access(struct drm_i915_private *i915)
 	    i915->display.access.allowed_task == current)
 		return true;
 
-	snprintf(current_task, sizeof(current_task), "%s[%d]",
-		 get_task_comm(comm, current),
-		 task_pid_vnr(current));
+	snprintf(current_task, sizeof(current_task), "%pTN[%d]",
+		 current, task_pid_vnr(current));
 
 	if (i915->display.access.allowed_task)
-		snprintf(allowed_task, sizeof(allowed_task), "%s[%d]",
-			 get_task_comm(comm, i915->display.access.allowed_task),
+		snprintf(allowed_task, sizeof(allowed_task), "%pTN[%d]",
+			 i915->display.access.allowed_task,
 			 task_pid_vnr(i915->display.access.allowed_task));
 
 	drm_dbg_kms(&i915->drm,
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index 2cb2e5675807..5bcfda6ecafe 100644
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
+	snprintf(args.name, sizeof(args.name), "%pTN[%d]", current, task_pid_nr(current));
 
 	ret = nvif_object_ctor(&device->object, "abi16ChanUser", 0, hosts[cid].oclass,
 			       &args, sizeof(args), &chan->user);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 107f63f08bd9..3264465cded6 100644
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
-	snprintf(name, sizeof(name), "%s[%d]",
-		 tmpname, pid_nr(rcu_dereference(fpriv->pid)));
+	snprintf(name, sizeof(name), "%pTN[%d]",
+		 current, pid_nr(rcu_dereference(fpriv->pid)));
 	rcu_read_unlock();
 
 	if (!(cli = kzalloc(sizeof(*cli), GFP_KERNEL))) {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9771072da177..bd39167d4234 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2622,14 +2622,13 @@ static int tty_tiocgicount(struct tty_struct *tty, void __user *arg)
 
 static int tty_set_serial(struct tty_struct *tty, struct serial_struct *ss)
 {
-	char comm[TASK_COMM_LEN];
 	int flags;
 
 	flags = ss->flags & ASYNC_DEPRECATED;
 
 	if (flags)
-		pr_warn_ratelimited("%s: '%s' is using deprecated serial flags (with no effect): %.8x\n",
-				__func__, get_task_comm(comm, current), flags);
+		pr_warn_ratelimited("%s: '%pTN' is using deprecated serial flags (with no effect): %.8x\n",
+				__func__, current, flags);
 
 	if (!tty->ops->set_serial)
 		return -ENOTTY;
-- 
2.43.5

