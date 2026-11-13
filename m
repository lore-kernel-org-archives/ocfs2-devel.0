Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564785;
	b=J12WhHQv9KbWHejYSJZJtnLpZJA+lLcSZ8Igz2JMja1sz/dlxUMg6ufET2BewMbPzbb1
	 mR/iClgHB7Opu1ojZ4Esi+MkDD8QkuhEoQS60q71F8MjwT4Gd9Geq2p11fPxMnAc5GaOF
	 U/am8obRFHLvIkV7ysYD+QiQDtsGaHHC44FXTE+wWRt84AKTeoNyF5/e3d7BEZWl1tpT9
	 /QpOCCq2YSrerZ5xUJ7TrMS0z7zfZBvEjGWDBRe3Vil6fdUCmkhl3m05t1h3X7r3rmsTd
	 28D9vEaqoQ0F1hz0J0yLd67nJqUBC+iDUxtid8Ba11RKjITPT8SBf9bz/8ZUZ5lwlRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	b=qwondcMUj/qRKFS2m/PSROaA9VAIdWmacDFSGgzsWXvN1L9x3cvRQqVrX6oit7qxqCXn
	 g7BfFqWyZ7k/4yzz5Llg2GlbRJ+NGbxbsuIeD4Bjy8OWAumrcXo4Lv+AZOj05a4NjWTpG
	 s7tVZ0BoG93hH+oiAoy0vyFW/GPYsLLc+U8zMca+MpUpRw+vCl7Kp/3ZVQ6Y1Sa/LgyAk
	 l/zgCLEvx5HPnkbQMK3sWRMZOf4i4NHzwUyFe2300mGlb8dPH1VK9lo5flmF2i1k4L0UU
	 3sGc/krwVyhKSUOSIPTGp0xYgkDMhXFUU/TYN39c8IMcQxBRhcwZdbKpNNEe1t9Fdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e1myWE6m;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D2606A889
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 10:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 975D2606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=e1myWE6m
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so10676515e9.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 13 Nov 2026 02:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=e1myWE6m24IWw7yO55WYjJEyiNRIFIH9VtBgLn2wa1MeQOGfiulE/mdBZc22DqUEpj
         LBtiiW6O2Ag0NjZTpRJ40TtRMZU8fCff+u90toSJhGqOAoRyDZWFIoS5We1jrN4WgXNO
         JuRjtUCHP1AOX0G7NXkhoxlO02/HgbXQfM0mp2A6TlFXtekUlZKcwwW6BgwJuTMhjgyF
         C9V6dt0ln8hW4H3BWEtb5Ysens3PIyjbvmvUfZEuE6KFb/JvRKTUmZuX9ss31juLIE9P
         Q5BPM9aE7X46wCjJILMdvD8WVwaHKCgBFWUKkxd893AUBxFjUmMLNvefvu/OXp2qFDMU
         mYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=UxcFgTFONRyvxbjNehXQTvtsGRUt0FGOT+S8F0RsnFNP8f3i58zmP2oXDH8gkmTWrj
         Mpx+7l0zN1WMJv8bHDJ7FCxpWIrmrofmjq+qYrvvLUrcFJop1laqHADQT1LI931j6pzS
         AUjObxrek3t8LM8Ca24RfOvQ6SmzIldGA9+JBrHujZEut4RR6D7wmh2zADoprjmkuaNH
         raGK3/iKY3j6yDGkPey7ncGGpnJCb9b3cDe39ECzrov3LqztaNtHzTi1/aOmy0BWxEKa
         kAe4uTDlfEoWpgosQtWny8fJ1wXR/Zke3MZHijvmH7EGJIEZcP/6UZ+q4nJdu9taYI2Z
         93Iw==
X-Forwarded-Encrypted: i=1; AL+hErGgBr5U0g7YhhBEs+l/Tp7gh7F9yqlV/bov7mu6u4qJ0auaEJKkVVJDmWIAA3EfR8j7kKQ2y14MD5YctA==@lists.linux.dev
X-Gm-Message-State: APuU4Z8Fk4d36BWtG5dj8P95IHZIWPlEqCmYdW/Y+BeKFZqYn3ojjfqW
	ZrYLZ+bFa9nZF96ZR/N5DOvtA4xtBQtLoijT8V+lndFn0O9LI1GpraM6a5jJ5kW4yM0c
X-Gm-Gg: AYBFou2RmqW+VIwZem/ciT25rKR9c21ceB1VgDpsTDVNs2UImQLsvzaWUH23oRXuPZV
	LLHcTCQWnM70bCZhY7OEDmilU4BeDACWQohDnlTVw65XmCBhSywbRuVmFnucXv62jsS2cSurvCs
	F6ROBUoaTmsncHy+BR5TxqBCk4nVvNxqRB+ADf/Yv2LpylBaZH+/KgWzJQFjFdkqg5fk/0OWNAt
	jjRswYD6LbS1T2a+1U4/e/xJxRL+9KFcMgmLscFLiDnctgXy/Pm8OtKGFLBxdm9Ee0QgFXtrhRF
	qpW69FK0vVPxgQ+8jhCm0EeDK5AC7XdY7rFrS0Hgb0igBlKIYMiwzEsfJAMIrtzyxspBwAIwjrr
	DsbsBM9x3Sqcdqx3CVbv5Jpq0RqhZmZ26p/5L7EeRVfw0HnTY49HCUoVpUsGrR1WWWPL1hI/wNl
	zUHytzSQtms5N3/Ht2ZWXQBTxJlZuJ5SOad+Z1yQY9K8B2+frR5x8yzY5UScxx6n9FtzDZDalAE
	kgMVKSyue9xX8m2pjXfzChJwlyO/6Jr+rD1eRCtXDQGTgY9nrh4LLZH9nzizmA8l6H+upJW70nu
	tL//inyme7UibL++N66NGu5ZszVw7L69vaaBINmLzUbitkqQQyH9XdEY3a9pzhvH
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
