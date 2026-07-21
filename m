Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30683345752
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 13:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784639565; cv=none; b=RwByejZQk9NKfi+XemiN5VPbDfIZVn5b4qRCKJo8hDvLPzYvlzmztzs+bDp9V1BQDDynqvse1Ea2773VN03qBGeBLpJcd158+O2lnDmahdgA9RT2LekJQ+gcUDHUYWTzY7YDXcW1dBonccvA04HgAMLzQsLMN8/2PfZwoLfGiYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784639565; c=relaxed/simple;
	bh=fiT5St2Z30ofp3OH5iVd8OJXjJ4QD0Rozv3/47Awp8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzIVuQmpQJV5J/NEEx4Y5CNnL7iNuDGR/tLbXIsa8gsf2wGCj5YNXJ8uqjEb0qtc1Z/Z8c8mU7EKHdXlvnADLEYbAsur8bm7nmlMRQ8cC8YcKNepDB3phglbFs3/egIzjTRTpXhBe4l/heE784XCzbDgkHAoOgYJi9evA7JG2KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OJHbTpXP; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OJHbTpXP"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f7854678bso680589f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 06:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784639561; x=1785244361; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ioETa9ajAjgthSRn8XVUlWgrnejtF100jjMdi1lWaeQ=;
        b=OJHbTpXPXf/EQ3xp1h2zIAKTSUWUXIBidc50EsYrt0gtZD5axtOXIPVgYsknT8qCaM
         l5yLc+Kt+/EHcG3ymCO/Sq6wanawDxa7nPOxWg64bnuylWs/WPahx3nD7smXgEG5AFMj
         aq/uWMTP8cu/CtodDREVtwIJw4+L1qWRncPvSflmccUa3wYjnZhNzZ1JWoR6Ufe4lboc
         qvAEV7oBkuBTS0WcIT2iruB4UJPYzuzWEdPAWgDrotLO1Pvtj3tGcZs3LWCoXHVdtW9Q
         FrtqXGOQcLAG3VAeuEsdkQCyABB23TYnAl4Yg5oUsxd7QTOU2JvIOWToh4mgrIM4JrlR
         ktZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784639561; x=1785244361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ioETa9ajAjgthSRn8XVUlWgrnejtF100jjMdi1lWaeQ=;
        b=fiSzR/Y4Q2j1owXgmUyAqhHm88oRuK87dJv5/J3JG65hea+SMlYfpAYJo+pehTiNgA
         kwZ05GSDrNi5DcLWk3UQ2NLtmPDT8TiOVFTJ/6/VjauKK40vfIKJ+vl2bZN+4kcHSLmu
         +FLGaQCiZAo5XWoTKMv44r8/SSOtTL1T3ksB773zkvfc8eJQrB0uImP6FeuG9C7BcFyE
         JplYcHOtl7ramVFfPwF0galxCTCVIKJsODSjaY3mDD5gZLkuGXtHkZ/FKhHfe3o4hn+I
         n9gduhipTRoY2H7zNHFpMvWaBocW/bjwszmAn8OP1FXzEp5B3OlkiS90iTbpzyqBTzpH
         fEVg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4lf4b6N65fMYnE/nTGubZBVC2F1vt5cKmHypxeNp7HY0bySx1yG9kQk9Npgq1Z5EuraUZoWiusNIycg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRSJoABO7Sq5AMXuz+qugkDC50Q+7M+fqgoCwxlKYaFcmYkkd4
	9jmAh3c6whY20UyEKjjjFCLqfw7F0EY+ync0hs/WpgcAWjI8ngAbUJx4p0XFxwM24wQ=
X-Gm-Gg: AR+sD134ZsCutAHely6XV/dPbn4f0srWVZjYhjrbEnvv26tx3WJWzEFluiGxLCpc4gS
	tTnOwCFRvok7qZ2E7IsyzAfVm7DMI8yME9UUMucjQwYldnUVjFVHleeWsFNnEEroqR2/IY18/rj
	OZVUTwBAQV06qcYGFT55E6rl1ns1z0s+9Z7bkRRpbkAbFy+l85FBT/6EGugiMdUcZ0TA+k5AmAF
	dFNTInUvXAlTnMKs1iggBEJeDPa+kI9b+8gQGCAYaonp8gS6LFruyLOz4qHL+0TLQeAwQGea/EJ
	WSRtYfjEVm6N2lGAL4xkY5SEJCSrYLI2NguwM9JeiU/I2zw4rUjD4rEMf5qwaNWFWRRub8vFVtQ
	6f8y2sfG11CA/IowWY1p+DmM8Zz4RsTHK8h5vwznCha4mqj01kLpoZZZGYlFExmePcSUv57ArFw
	==
X-Received: by 2002:a05:6000:604:b0:47f:8389:3477 with SMTP id ffacd0b85a97d-47f838934d0mr784345f8f.48.1784639560942;
        Tue, 21 Jul 2026 06:12:40 -0700 (PDT)
Received: from zovi.suse.cz ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ee9281sm42070938f8f.36.2026.07.21.06.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:12:40 -0700 (PDT)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Michal Januszewski <spock@gentoo.org>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linux.dev,
	linux-block@vger.kernel.org,
	greybus-dev@lists.linaro.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-acpi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-pm@vger.kernel.org,
	driver-core@lists.linux.dev,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v2 1/3] umh, treewide: Explicitly include linux/umh.h where needed
Date: Tue, 21 Jul 2026 15:11:25 +0200
Message-ID: <20260721131207.803760-2-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721131207.803760-1-petr.pavlu@suse.com>
References: <20260721131207.803760-1-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The usermode helper declarations were previously provided by linux/kmod.h
but commit c1f3fa2a4fde ("kmod: split off umh headers into its own file")
moved them to linux/umh.h in 2017. Add explicit includes of linux/umh.h to
files that use usermode helpers and remove linux/kmod.h where it is no
longer needed.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 arch/x86/kernel/cpu/mce/dev-mcelog.c | 2 +-
 drivers/block/drbd/drbd_nl.c         | 1 +
 drivers/greybus/svc_watchdog.c       | 1 +
 drivers/macintosh/windfarm_core.c    | 1 +
 drivers/pnp/pnpbios/core.c           | 2 +-
 drivers/video/fbdev/uvesafb.c        | 1 +
 fs/coredump.c                        | 2 +-
 fs/nfs/cache_lib.c                   | 2 +-
 fs/nfsd/nfs4layouts.c                | 2 +-
 fs/nfsd/nfs4recover.c                | 1 +
 fs/ocfs2/stackglue.c                 | 1 +
 kernel/cgroup/cgroup-v1.c            | 2 +-
 kernel/module/kmod.c                 | 1 +
 kernel/power/process.c               | 2 +-
 kernel/reboot.c                      | 2 +-
 kernel/umh.c                         | 2 +-
 lib/kobject_uevent.c                 | 2 +-
 net/bridge/br_stp_if.c               | 2 +-
 security/keys/request_key.c          | 2 +-
 security/tomoyo/common.h             | 2 +-
 20 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/dev-mcelog.c b/arch/x86/kernel/cpu/mce/dev-mcelog.c
index 053555206d81..af4e76babe7a 100644
--- a/arch/x86/kernel/cpu/mce/dev-mcelog.c
+++ b/arch/x86/kernel/cpu/mce/dev-mcelog.c
@@ -11,7 +11,7 @@
 
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/poll.h>
 
 #include "internal.h"
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f9ffcd67607b..de90cf4a0789 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/umh.h>
 #include <linux/drbd.h>
 #include <linux/in.h>
 #include <linux/fs.h>
diff --git a/drivers/greybus/svc_watchdog.c b/drivers/greybus/svc_watchdog.c
index 16e6de5e9eff..b318eb34bcca 100644
--- a/drivers/greybus/svc_watchdog.c
+++ b/drivers/greybus/svc_watchdog.c
@@ -7,6 +7,7 @@
 
 #include <linux/delay.h>
 #include <linux/suspend.h>
+#include <linux/umh.h>
 #include <linux/workqueue.h>
 #include <linux/greybus.h>
 
diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 5307b1e34261..e66de11c69a3 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -34,6 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/umh.h>
 
 #include "windfarm.h"
 
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index f7e86ae9f72f..46af1f549337 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -47,7 +47,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/kthread.h>
 
 #include <asm/page.h>
diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 9d82326c744f..6c503e6914d6 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/umh.h>
 #include <video/edid.h>
 #include <video/uvesafb.h>
 #ifdef CONFIG_X86
diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..4908b44f6fdc 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -32,7 +32,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
diff --git a/fs/nfs/cache_lib.c b/fs/nfs/cache_lib.c
index 9738a1ae92ca..ca4e81d4e315 100644
--- a/fs/nfs/cache_lib.c
+++ b/fs/nfs/cache_lib.c
@@ -6,7 +6,7 @@
  *
  * Copyright (c) 2009 Trond Myklebust <Trond.Myklebust@netapp.com>
  */
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mount.h>
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index f34320e4c2f4..008f0f088c3a 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2014 Christoph Hellwig.
  */
 #include <linux/exportfs_block.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/file.h>
 #include <linux/jhash.h>
 #include <linux/sched.h>
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6ea25a52d2f4..20b98e43f668 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -41,6 +41,7 @@
 #include <linux/fs.h>
 #include <linux/hex.h>
 #include <linux/module.h>
+#include <linux/umh.h>
 #include <net/net_namespace.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
 #include <linux/sunrpc/clnt.h>
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 741d6191d871..0ccaab29426d 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -18,6 +18,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/sysctl.h>
+#include <linux/umh.h>
 
 #include "ocfs2_fs.h"
 
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a4337c9b5287..cbcde5c28b18 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -2,7 +2,7 @@
 #include "cgroup-internal.h"
 
 #include <linux/ctype.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/sort.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
diff --git a/kernel/module/kmod.c b/kernel/module/kmod.c
index a25dccdf7aa7..dcaad5d65275 100644
--- a/kernel/module/kmod.c
+++ b/kernel/module/kmod.c
@@ -28,6 +28,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <linux/uaccess.h>
+#include <linux/umh.h>
 
 #include <trace/events/module.h>
 #include "internal.h"
diff --git a/kernel/power/process.c b/kernel/power/process.c
index dc0dfc349f22..295904ec9a82 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -16,7 +16,7 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <trace/events/power.h>
 #include <linux/cpuset.h>
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index 695c33e75efd..3d4a262973e7 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -11,13 +11,13 @@
 #include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
-#include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/syscore_ops.h>
 #include <linux/uaccess.h>
+#include <linux/umh.h>
 
 /*
  * this indicates whether you can reboot with ctrl-alt-del: the default is yes
diff --git a/kernel/umh.c b/kernel/umh.c
index 48117c569e1a..72b2d9a878aa 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -8,7 +8,7 @@
 #include <linux/binfmts.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/cred.h>
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index ddbc4d7482d2..a67129e452a3 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -17,7 +17,7 @@
 #include <linux/string.h>
 #include <linux/kobject.h>
 #include <linux/export.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
 #include <linux/skbuff.h>
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index a7e5422eb5d1..89bc161a4b47 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -8,7 +8,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <net/switchdev.h>
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index fa2bb9f2f538..e6ba2d054399 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -9,7 +9,7 @@
 
 #include <linux/export.h>
 #include <linux/sched.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/err.h>
 #include <linux/keyctl.h>
 #include <linux/slab.h>
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index d098cf8aae61..d26034000913 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -16,7 +16,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/file.h>
-#include <linux/kmod.h>
+#include <linux/umh.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
-- 
2.54.0

