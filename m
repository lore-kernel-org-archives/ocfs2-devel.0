Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B67F34252D
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138022; cv=none; b=MmPG6Ae0i0Oavf0eRCqW6pu8qYR9nIucSoZyNCpBoVP6UELNwkMAHDvRtNAi2D9j5IEtEYyXHla43TDyiXinusmQ7BVAQ5p7Zk5lNYPT7TDpuixmLvVhjh8Du9CQV2w9C4sZ6Juu1u7OmiMBHiKHNpRsQ5eqCmYiJTL+pSxzIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138022; c=relaxed/simple;
	bh=DmDN6UHtKvikcXdajHKVO+yHNn5RNaijR4wIa+sYjRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vh/RuTzi38lcvfnjkI42Ahcfm5TKdl4J+J2EeBCaeuMwOujXshR92Z4KxBnkdEHXXB9D8wusAtGz+SfstkYZ1dyM94rts8/xQxN0j0QC6MbwrFSwHy5/LVJrAcKnw71DCo78Wfs7z+/wOiBoMrNHKqAaAedtT/iTFlfHr88feh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GsX/39PY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GsX/39PY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so6921065e9.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 07:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789138018; x=1789742818; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6DAY0H524IPnoUin0wM315IyLKxNaVBFm7h+DvdUw5U=;
        b=GsX/39PYpR3++58/bf3jlk2zpq9TKtYuAj7vVVCBLaIYDKYdYlU7f2Jm/sZsMscC9M
         NAyeDU5ItM7tAGwWLgRcFkJcdineIaS/fELRC9tNcGHi9mJuHrVv3cFE6axAaqvJ3EO8
         ybKmnQiCGn5z7yFONMvL9QLhqYY8UpVm7tiG5ZSXqitL9hg2TCpCFrPIaZod+my8wBk4
         H5DOSlK4/TCs+wQQ4EGEMFgoHeGObzMmVGy2qSTVJV6Ov42LtlcijDBw9/B208bebwxo
         gXGyVcd4OkBa0LCOzAGfDC48gFYEPElzrLz9dpq3eYUMRqO+ObRzhkN9U5MSARGZj2RU
         6Y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138018; x=1789742818;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6DAY0H524IPnoUin0wM315IyLKxNaVBFm7h+DvdUw5U=;
        b=Kq1lPjaBxdFyCCXwO9ppS3QLT8ZajdojfLOIA1n2pn+TxCumKDzy0L5I/fmiiq6TLw
         HpKYYuPVx3LptVJrjArT7Z+E57jYQgJyuXvuTFYB0Qnt8EDf00fuHDXpd34QMDzKg40m
         1d8tCBV12tZ4a5M33GtO75WczpvVZiiG9Mx04B+U/04q0z21rfxr5Ad18o9Q4ggyj+XR
         6B2k/sPJ5vwmHyQFMgFsMQQUD65L9bF+zsysG0ZkouSIs9LSJMgo5OgYyoZMUV43vyhJ
         1U4jH4m6/+d21uhYg7dZ82lv+1M60lbrKLoqAQiIxhKEu4Uf245BeofHqSOIHw+0crFc
         HhlA==
X-Forwarded-Encrypted: i=1; AKwUvBxPw9UF3qr6doub9MLCKA+gCcQsAswAaceoMdAjbfMU8tr7VsIUl9x1lOOFG+r0gzrdVSg+8toNUtCeJw==@lists.linux.dev
X-Gm-Message-State: AFuF++ml5x7vgdtLnWDXrwlrfvcxWbwfsPFSD3nzghCaZoKG/qHQPm7x
	FYTtOXwG/SR0K+ndTzS2wocxfhrhZiwznf2mPuN22a31cLum9oo+nigefijrugFBp5E=
X-Gm-Gg: AYBFou3k6Xms9uL4igFwFMJXadjCAYNbdBpkb0AoPBAcrP3x6blXG6E8Sz279KB+JsK
	N2YPojA/DyMp0/28kQArkqLV27DLXJ97xAOFq6A8aYHiS4n9r3UB9EDyeeSGLV7UH/CwgDNyhWD
	+s5V6kZPyTzbz0QbYEKEqC0GzytemK8oGLEaLWd2Ot+uxbPtv5AEesnsL8PJ+fZNfS4uNN9CywW
	tYfBxO1EvTIRq9QcVIIE0ODUhB5dbKpPtzdHzeUMJq0iUPaP1JyHVDURiOZeXyyh3/9lRRSHK12
	ECsdiZNaN/4mmH88QV/UAfe7uPFax9Eq5CZvhXcpWMHSAKGNa8iVYC+TgEr3ZTkRI5KDGVTlS/A
	QQPksJ2aeKqgmD2ymOwqPP1tgbbj8tJvaIZbAYQHGFZaKNgCjf1I0Bu3Kr5A5CN4a8eiVq3skyU
	LbMgiJiDFoHd3+pfMhOeGHbXjIRfZ5RMYlPMLVyj+weqbPpRNIG9PMO9gwVjiO2lGYHZ8ZRpX0c
	jfjjA==
X-Received: by 2002:a05:600d:8444:20b0:49d:27ee:79c9 with SMTP id 5b1f17b1804b1-49d27ee7af0mr93376655e9.8.1789138017731;
        Fri, 11 Sep 2026 07:46:57 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e8d1sm6328068f8f.11.2026.09.11.07.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:46:57 -0700 (PDT)
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
Subject: [PATCH v3 0/3] Bring includes in linux/kmod.h up to date
Date: Fri, 11 Sep 2026 14:46:13 +0000
Message-ID: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260816-module-include-kmod-14d1a0e19462
Content-Transfer-Encoding: 8bit

The usermode helper declarations were previously provided by linux/kmod.h
but commit c1f3fa2a4fde ("kmod: split off umh headers into its own file")
moved them to linux/umh.h in 2017. Add explicit includes of linux/umh.h to
files that use usermode helpers and remove linux/kmod.h where it is no
longer needed.

Also add a missing include of linux/sysctl.h to kernel/time/jiffies.c.

Finally, clean up linux/kmod.h so that it includes only the headers that it
actually requires, importantly removing the compat linux/umh.h include.

This cleanup is motivated by trying to reduce the preprocessed size of
linux/module.h, which includes linux/kmod.h. linux/module.h appears in
roughly 15k #include directives across the kernel. This makes it a "hot"
header, so it should avoid pulling in unnecessary definitions. Note that
this series doesn't immediately improve the situation, since most of the
files included by linux/kmod.h are, for now, also included by
linux/module.h through other paths.

Apologies for the wide distribution. Acked-bys are appreciated.

---
Changes in v3:
- Rebase on top of v7.3-rc2.
- Clean up commit descriptions.
- Link to v2: https://patch.msgid.link/20260721131207.803760-1-petr.pavlu@suse.com

Changes in v2:
- Remove the linux/kmod.h include from kernel/cgroup/cgroup-v1.c.
- Add a missing include of linux/sysctl.h to kernel/time/jiffies.c.
- Link to v1: https://patch.msgid.link/20260708154510.6794-1-petr.pavlu@suse.com

---
Petr Pavlu (3):
      umh, treewide: Explicitly include linux/umh.h where needed
      time/jiffies: Include linux/sysctl.h for proc_int_u2k_conv_uop(), ...
      module: Bring includes in linux/kmod.h up to date

 arch/x86/kernel/cpu/mce/dev-mcelog.c |  2 +-
 drivers/block/drbd/drbd_nl.c         |  1 +
 drivers/greybus/svc_watchdog.c       |  1 +
 drivers/macintosh/windfarm_core.c    |  1 +
 drivers/pnp/pnpbios/core.c           |  2 +-
 drivers/video/fbdev/uvesafb.c        |  1 +
 fs/coredump.c                        |  2 +-
 fs/nfs/cache_lib.c                   |  2 +-
 fs/nfsd/nfs4layouts.c                |  2 +-
 fs/nfsd/nfs4recover.c                |  1 +
 fs/ocfs2/stackglue.c                 |  1 +
 include/linux/kmod.h                 | 12 ++----------
 kernel/cgroup/cgroup-v1.c            |  2 +-
 kernel/module/kmod.c                 |  1 +
 kernel/power/process.c               |  2 +-
 kernel/reboot.c                      |  2 +-
 kernel/time/jiffies.c                |  1 +
 kernel/umh.c                         |  2 +-
 lib/kobject_uevent.c                 |  2 +-
 net/bridge/br_stp_if.c               |  2 +-
 security/keys/request_key.c          |  2 +-
 security/tomoyo/common.h             |  2 +-
 22 files changed, 23 insertions(+), 23 deletions(-)
---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260816-module-include-kmod-14d1a0e19462
