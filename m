Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AA63515D6
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138030; cv=none; b=ewh3/ZnQndd/oclKkZTc+Mz5XoSFrGVgn4kMR29cjmDS2pGiU7XCfcWWValncwgnMRITxwTnSm8gJyWRcHwf4tWVkMnzWKTEQQ/kCbJ8K5ZC8iGzCNU6D8nNqiiX7uQ7YNouELOUYSYqWSIzD2j6AKVgTTbUp7MK2FTfCO2q44U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138030; c=relaxed/simple;
	bh=6qK7Y4OCyC5WsOE2SJMQ4fti6jzNs1Pji9/QbACrVAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dgy2Wd65eQX2nmoaGzARcnY/gV3s0Uh6fm+l8DJOCU/ZRdffigclvP2K7zxIjJJcUtNjCQrcLxAQF3kYgkZm9C8MrdX17rnfrviT7Ge2mW2L/SSgbwfQnm0FF+BA6hjRToyfkZUbkBaRQyxxt6DoWfHi9tojrpXwKCiscuqeJLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cny1MnC2; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cny1MnC2"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-486e70f2457so490901f8f.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 11 Sep 2026 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789138023; x=1789742823; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QuYE5JBWhvW9oHs2kdysh3HB71WxLYQMcei9gKN4bpc=;
        b=cny1MnC2ym62qSCqjDcHXDr1B3cphkDjNNRt1/zNpEfA0/xNuUjJbNX0ftwlaU30j5
         wMhhm6PrcTc7wnJFrSpTIWo3QKMpCTo427WRQUsqTJIOHd9A+lr4iN1W+AK1tH/ivCvb
         oVsg+t3jjzYUcb4J4jAUhIsxyrf3j/fRpKhGyNvjYz5zYgNhQe7vVRtX/l6YL347yWa4
         6GbJec+r8VeJeLal/sbpw3JaypHwXT/VO3L+IaLgX/stFtPWbDvHVreh0aG5VbYMxrL4
         zzDHrBx1zuCzaQu+PmIxOlMgpszTcsvz81g57NDiM0+ZlDkRLlKkYyRMW2gziPjdfT7D
         iS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138023; x=1789742823;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QuYE5JBWhvW9oHs2kdysh3HB71WxLYQMcei9gKN4bpc=;
        b=bMyYvBYbZqMyqEJ6tw04KoZsMAEwO1EJwICbWtQoWXjPEdg1V3tZCWXTB9FWRpp/U0
         AcVMD5Nx+c5yRxxL24XFap56OjU4ln0X+9z/ViXVBstG5inD4J8t1u7VW2fbHRQPMXup
         GJpiT8I2S69ySYzVZ4UVw78oEsnBvcBnsgWyKjoiG69WJr/4GVsxQhpec9fp0xy1GDDM
         sh0+fUIfBqaInGlDj9f8cgnGQLRe2yyICim8eFkxKcwzs0JPA20uGUXttQ3qZaS62pgV
         r6cLPx+HNhjyU8eK76gdomSh0P7ThQynNeU52JDVGwb5HsDwNKbJfBoHRTbtqYYk4M3q
         wkaQ==
X-Forwarded-Encrypted: i=1; AKwUvByXBiDCLwv8JcIFQER+R/1uXVqrdVSiBRAoLAO69pTy2QPATm/zNxY8ocQk92PMucG2lwDsSNThFfgQKQ==@lists.linux.dev
X-Gm-Message-State: AFuF++mBvSmwfoxNytkdeUslnUWi0OIYgULb2zNu1SphYZ3eFq1IHg4Y
	YIPd9zJToNpKZB/W5RdwopGZ5COJ9WnOQ/63vlvBzZZyQfNOnpkws2yw34rhQmZfc4o=
X-Gm-Gg: AYBFou1GPy05NMj17cTT57tDhNE4FyGfcsEq+d894aPoxw2Av91xLtizHkTIUR3+Dzr
	VsxRHsU6TN0D4MHWRrbdH0K1Eqf3atL87Q7GSBsqbD3WI7NWm0/Ld4ucA88WRf1EgfKTh6sBmlo
	/0hp/Dq8EOvZ3WtXp8sOCtWcRyWv12ZGM6w0wKuEv9QuCOwE6z6cib0INQlzt0fkSQyIgYpZb9g
	f4L2t/4fZWG8z+8T6eXfzm/A4jM5QaEGto5QZ+iOl4SOKWQAcvzJ1VAdr4ayPFIRjEUiCzNEgUF
	CIYYz/D72lr4/707CDHbZrHn5LMumXwcXDZ+Ix2H0wNtJyQP7OT8T3BNd+T8Jl+uZkuWiLjVn44
	2B0BcR3qJ6h1+Wzk9sr7xYH09RjgQzEdGS1dG/OOERdvB+gmC4a5jGJkc3tuYIFLXpBNY56nsTp
	7B9LyNP3nBIWbhH4pkaRGgmw2CzYuCrFjgnWTjJp5JS6d87nDtT+qS+8NZgVScRocTSr9jLDV03
	XPSIQ==
X-Received: by 2002:a5d:5e08:0:b0:486:e81b:842a with SMTP id ffacd0b85a97d-486eb358ab6mr5259626f8f.48.1789138022582;
        Fri, 11 Sep 2026 07:47:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e8d1sm6328068f8f.11.2026.09.11.07.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:47:02 -0700 (PDT)
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
Subject: [PATCH v3 2/3] time/jiffies: Include linux/sysctl.h for proc_int_u2k_conv_uop(), ...
Date: Fri, 11 Sep 2026 14:46:15 +0000
Message-ID: <20260911-module-include-kmod-v3-2-6ebccc3e0731@suse.com>
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

jiffies.c uses proc_int_u2k_conv_uop(), proc_int_k2u_conv_kop(),
proc_int_conv(), proc_dointvec_conv() and proc_doulongvec_minmax_conv(),
which are declared in linux/sysctl.h. It currently gets that header
indirectly through linux/module.h -> linux/kmod.h, but the latter no longer
needs to include linux/sysctl.h.

Include linux/sysctl.h directly in jiffies.c ahead of removing the
unnecessary include from linux/kmod.h.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Thomas Gleixner <tglx@kernel.org>
---
 kernel/time/jiffies.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 213ae1d6a014..9231fea557ce 100644
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
2.55.0
