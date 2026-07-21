Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7012360EDB
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784639568; cv=none; b=oUCsRzrvfWvCqAqLco3vlv4SiMpBLZ0lFEVfoWin8FRHvKeWBg5FPS41+lQL9x3U4l7DApFC5cDzxXSGtdkvH3FqkWOgaq2lnVJnuT4yzmwrHO34bLFJcgdZsVuL0EQMB4UnD/4XfrAdYbfyMgvTdUxezGa1iI1hdNSiIMsPf4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784639568; c=relaxed/simple;
	bh=8s6UjPPxUC+WU+GOlooynAFJu683hzUfQZ1dycjQ1Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiLhO2w6/ZxFPVwRiESlhiiyEid1lMz2gHOLsKFy/QXmiHC3unPbwp7pw8LXciQI/6dU5vPEv1ICVnlrlIxEOwXyMcsnclKawVhYYgawluFsB+ycBSg7wJ2zZR3q/NMsEQk2WrXwYvPHrXLwCqX+K7Z4ykaj0H2OMssesgIFSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LEX09Mee; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LEX09Mee"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso7409356f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 06:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784639563; x=1785244363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFYQPc/AUmoponr7iNZhaXGCIgX0+Ls311ZPwQA2S6I=;
        b=LEX09MeeDKnCCU8NH/muVmkNAW8O4ABwIyAZBaT1EKUeErQr/r8D6pwq24rCPYctjp
         ICTxj45ID6vk5qOBr5sVwiTOLCwA1hh8NTVhxi9etzptSdXoct2pC1d5JQslGZ3FYmif
         NVN+vxPyW6KVVFsLxYBjhhXACqaczJuEQRkGMm5VblOpOAukd1fb7elp6lSPwuoxfdmK
         DPHYPj50WVVh+pghEI7mXfoCqrrZ+IG+/KmP+zQ4APoF0404+wOWEXcAjsc9VfUoGLK1
         HuPOgSrn1im9U5xmUHwGhQiPJltz90KfMR8ZnirfaSNBHBByVuHebpmaRO7fW5ppwkKL
         oE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784639563; x=1785244363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uFYQPc/AUmoponr7iNZhaXGCIgX0+Ls311ZPwQA2S6I=;
        b=pn4dJ6X50Tymq2mTe66/y/qfOyY/sb0YR6E9qKDFCQ+vQjAB8Php003avUzpixjkF1
         MSPfCMFoh5Y69ZToZdB5/ZB48KZb3AmeYjQ1o+H3nr+HRfyuM+qIXwg8tJHjpJ3vDKXr
         fXA5v3x7QGw0F0A2cGR7m83CXvG/RGHiTaPjiQJWXM/sdWY3BggvhpGH+rZD4ymm0dvh
         iJQEfP6QFsSyPDfNLafHuBEdHv3rU33Ft2o0gWQSTmOG3/QQInu+RjYglBwoDI7GVV/D
         uP0nVz+7qixiE+5cWsgSdl6x9T4YCeqhxvmnAqkGjZUzEh4eU8pkm5+hT0UBEi2ZFFsv
         FcWw==
X-Forwarded-Encrypted: i=1; AHgh+RrVAiTeI7n0NuJoZ5iwi/zTa5lOdZ8fV+m79lWcqWbxHhr7lInobTAfIymFmzRjLMDbO5xcV/s5wjpLLw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxdwgCDpy311KOjbPrxT1F7oDcPFsUTYvbvE03buspI+xxTHngO
	B6UXNr+ix1vbCniL3BAREZQa22lLgmLvhWiNn3JYZ5WdFf3QDtswFXoUD7DkiP9HDPA=
X-Gm-Gg: AR+sD12GZUr1lmqmPYHgZiDjmNpri6EQlnkW6xSKqgCF5TrQ/EZP9XCbfIkFKLIaCGy
	NEFggzWV3whjcoUkJ9t8GC+DfAfBkNwcrccNwHUrxGpXuIzY4bpOIe2XxajxuRW4HyZeNWRXfOa
	NNao32wweCszxeIfMOhefGddyEKHRcVIDpMxoGdgVLM/jtb5hWgQhBLJ6RVZu8IA7r8IpWYxJ9N
	Ws6IOY4K7e47QCYJWJlI9MDfaM4JUMqLtZ34zakVjmfrzm93PVLCYp+Y/FjC/h2McWf/TXQa8yw
	yAp/rd9zWmouKUc5FVw/0eMQucXzYrm2iMJHmU1oimREqmDA7oB0Sr7QF1xkgpCyKhldUg48pIR
	n90GhT0o45fjDEm8jmSQ7J7lvs3Vc0SQtrRyJzLzGL4Q1/1wJLqhpaopoyQaMFGu051tqdRgtgQ
	==
X-Received: by 2002:a05:6000:4023:b0:47f:81fe:12fb with SMTP id ffacd0b85a97d-47f81fe1712mr2452175f8f.47.1784639562827;
        Tue, 21 Jul 2026 06:12:42 -0700 (PDT)
Received: from zovi.suse.cz ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ee9281sm42070938f8f.36.2026.07.21.06.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:12:42 -0700 (PDT)
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
Subject: [PATCH v2 2/3] time/jiffies: Include linux/sysctl.h for proc_int_u2k_conv_uop(), ...
Date: Tue, 21 Jul 2026 15:11:26 +0200
Message-ID: <20260721131207.803760-3-petr.pavlu@suse.com>
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

The kernel/time/jiffies.c file uses proc_int_u2k_conv_uop(),
proc_int_k2u_conv_kop(), proc_int_conv(), proc_dointvec_conv() and
proc_doulongvec_minmax_conv(), which are declared in linux/sysctl.h. It
currently relies on this header being included indirectly through
linux/module.h -> linux/kmod.h. Add the missing include in preparation for
removing the linux/sysctl.h include from linux/kmod.h.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 kernel/time/jiffies.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index d51428867a33..17cdb5ef8893 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sysctl.h>
 
 #include "timekeeping.h"
 #include "tick-internal.h"
-- 
2.54.0

