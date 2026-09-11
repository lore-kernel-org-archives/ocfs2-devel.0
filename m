Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C9536E494
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138033; cv=none; b=ewaBoRTLuUYu0e4UfJJw6YMXPYouuLau+wna7iyfw7fv1RZpQO50vOQWIu/quio/TqSu/5MZmAz3HdijcK74PpCuozlFSq9CEPfIp41zeElJ7R0k8uIT0weKJwRQGadKz/yLhGTPp9cb1FZAV5MZSISU/vceCB/Dy4SpZa9BYXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138033; c=relaxed/simple;
	bh=dcMfYcrZvJo2odetIockDZHB6TyER2n5DIFvd4jrOOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G1gRU3RacmlvdJ9WGYIDG7S8/l72FUOTicEwDED+iIYEj3x5+Fn6fS6imtCGckxxUt2z/ji4rv/IUY54QfDU9WM97w1RntSUZvYw3WrqBs9Zh5G9abxER7TMxpxM93V6hRKp3CPYtVbs0HGAZuqs4kDNmbj+6bqwU1bB1jx/gXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cli6Dva7; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cli6Dva7"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so781690f8f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 07:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789138025; x=1789742825; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sAWK/0nRwHnvVvMYnd/Ub3wFPGnd0x9DJjP7YOulvgY=;
        b=cli6Dva7UoOu42JhIIlR0WIyERbtL7UQORl7+b4twen7ghp62tpaAp1vwAa3lI3ull
         XrXtxA/2V3QzYDZsKV976Y7geT2bMWFsiasCaU+ApJ1gLBUFM8GNv0pZ4g5PeasX2AmA
         xWeJyxkrDKDZ3W+274tLLe+35CgcwISdOJwmb8/2Nw9/msT5b03dSEM4kSXPb0wDe9YQ
         U8Npr+QxKUr8sfTrtI6ZfEQ0vpRMG3oqJXknV/nT+2bb1rJCCtiCPAjhKh6UigDCM/v9
         B2aqK9aAmda6hkya/h3mSwamEPl6ZLLQgnQxKVXdRbEICOuZ7ieQ7kKuv8TuwGLmrlCI
         1K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138025; x=1789742825;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sAWK/0nRwHnvVvMYnd/Ub3wFPGnd0x9DJjP7YOulvgY=;
        b=BusOBohJLlZtjU647VF5XNyHrRL7dzayJz57GDuq9tiIc9xEuIzYZXMWkUmT+A6vU+
         IMZJrKWQrWnjZiFQwCIU6n9UjA9fDM3Wj9cjTq3xWf6Z8I+PbZFt90A4Op0E4jBO2ciZ
         Pe3vpClsqhPzQgfcwS0fIUJ+UeUhpZY6dJma2crRwXfnVC9d8G+Re5CL58fyBIGAOFWg
         wdm3GomIWzsKXjIheCcVtD3WKoLh5UU5vUJ0sAqV6Hq9UeR5PD8QIlLcQa8yU27ecpgo
         CBi3ImrdVz2uhxjf7eI8/86oyKwnfljMaBJ8FeZNCbu+DdMnc/bohna2rsEorPmbw0LW
         j6rQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzXAjAtBy8Xpfa0vHbxVwZgFs+TITUGA0udOyIZdCVAZgjBMOXUyDi1ADtMn6HUBtJxhzbekhF7qWYsQ==@lists.linux.dev
X-Gm-Message-State: AFuF++k0jCvGx7ulPCaH6z4EoTTC0nUPs6d+sDQ/yhhWm5FejHQCK0kM
	ANBoT/XAcCuLdXGy7kdqktA3V/sZ6E8cuEfhulo/OATSeo7K5oGrISfrH2o5LVz8gVQ=
X-Gm-Gg: AYBFou12hr7deu4ZHX3IMNmlWNJx2Mh79DtkX1URp10VBllFiqdMstWS1BWjPMuUEin
	M76g8Q9SvXtUHQoBqH2ezGa61Syli+TOyLc/hYzp18RW0bJkQTRCOtJ0dIPOlCQ2cDOUBcn8tLd
	8rNj4eEGdq8KosG+Pg5Q0JrscAzBOTs+FzyF0VI8zL0OzQ9sqrQc3/uslU9sFg7duA963jrwxow
	g6auEz9PspKArT9wOSWPC1SSITgHpVBVvnEcewCPt1e3txcT6oD9UxLShFS3dCfrmMTm9+ruhyj
	+5BvWM+2QQohQz5RkjN34dLqniS1dpxo+d8T+zxVYpsNJIgLo1/MXuPtWB5MkG9g4eX6MCHHky6
	fSSPdkYz0WzeQu/jc6zU3DyA05KjnSmxLdhX7iEio9UYQaB2ELvYRIxLAukVkS5awomUEapE4He
	BIbC3E2VhV9Ofpdt1sEoaV6R8gA0QrOi8vjj2lxbCJWQtz9oMcB7BVM2l95bVvkpbY27NH4SJIX
	/oSCg==
X-Received: by 2002:a05:6000:26cf:b0:482:f61c:7cdd with SMTP id ffacd0b85a97d-486eb1d8541mr10746731f8f.4.1789138025130;
        Fri, 11 Sep 2026 07:47:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e8d1sm6328068f8f.11.2026.09.11.07.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:47:04 -0700 (PDT)
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
Subject: [PATCH v3 3/3] module: Bring includes in linux/kmod.h up to date
Date: Fri, 11 Sep 2026 14:46:16 +0000
Message-ID: <20260911-module-include-kmod-v3-3-6ebccc3e0731@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
References: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Including linux/kmod.h alone results in 1.5 MB of preprocessed output, even
though it provides only a few functions and macros.

The header currently depends on:

* __printf() -> linux/compiler_attributes.h,
* ENOSYS -> linux/errno.h,
* bool -> linux/types.h.

Include only these files, reducing the preprocessed output to 10 kB.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/kmod.h | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 9a07c3215389..b9474a62a568 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -2,17 +2,9 @@
 #ifndef __LINUX_KMOD_H__
 #define __LINUX_KMOD_H__
 
-/*
- *	include/linux/kmod.h
- */
-
-#include <linux/umh.h>
-#include <linux/gfp.h>
-#include <linux/stddef.h>
+#include <linux/compiler_attributes.h>
 #include <linux/errno.h>
-#include <linux/compiler.h>
-#include <linux/workqueue.h>
-#include <linux/sysctl.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value

-- 
2.55.0
