Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D91CD1E0
	for <ocfs2-devel@lists.linux.dev>; Mon, 16 Dec 2024 23:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734390182; cv=none; b=Z6eJUkDKvvD2TeEzvjkdhRdoT99AR5mtlcBw5M1P7lmHiahG+PVs8UxrJqXaabmQ1tzu3xKyfkS6yJGFM6y1HphiL2clKKgV+WUJkXVH612fLMG3QMpytltoe/Gkm4ZeKFgXZCLAM3PZj2XgSp23Z8PV42T30LGzBaSgcMDoAdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734390182; c=relaxed/simple;
	bh=dNpEYIyEEiuL5B3Q9Wf2beKGcqDDezzwhblK7pmzQkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JY7qc4WU7BRFJudZIKCptXcxXRrV2GwdI8ovFlK5u1TrEsYl/Ww49oh5HEDyEs0IJTSvydIzpTc9abIObkMLobyIouPEUkgpwhfQp0iZZ0KMcAnfZy//chipwVJsC1oU0hXG3gSJN4J13nRsGMHSLdhXec79/zy6GM8lHr6tN4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=WKoEy2Mk; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="WKoEy2Mk"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6ef7f8acc33so45669167b3.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 16 Dec 2024 15:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1734390178; x=1734994978; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kgbUCS6yRX96lOYmbdxrGaaVnG1rWgKUlUa61iIjIk=;
        b=WKoEy2Mk0TBcNhYesukBibHDPdFVmhcBF6ROyIipjxXDJ+94FKfgJrdd+YgJVuA9YQ
         veM08kMlAtXcAqx8DiTrVT6+w7FEPAu5gjmDMnRfw6zRn105Gc5ja9IdStW5t2DrB6DL
         D+ezcIfIual7xS65ei6qZ3DViGeXDd5TTnOcWaa7dufGaQFpe22Ap3SudsmypZ05VVA9
         w7uz/nSDGht3p9NvAwQ+Bj+XHyMJa62LWjsnYkArwr7ho+mlAYjCqgX2eKEaTo2Kw0GN
         Inb9nieAAZ6JqzSlElzF3wBH68sRO/iQnHe7I/vIXSwPlH+BNfWA/AdVsGySroP+2ffn
         oF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734390178; x=1734994978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kgbUCS6yRX96lOYmbdxrGaaVnG1rWgKUlUa61iIjIk=;
        b=EY16RbhYDmNLfihonLXoDJB6368RDNSCmJvti/NhgTSrDzdfteoaIkwQi4FhcSNTyL
         toKv4o+MsA5Cb2ENUl6ceF9idGJoH1E9LjqSaC+PTWBbhoRzkDgwG+qjZlLARiGQSyTC
         CwwAGSSHVjIIHWqmHxSSLialtdXPVr7NWbVymvmMnwVLj8s0RODTJAOaANtJw9Fy0MKs
         Z5hfvC8PzXzj7/5t6DYKhcl91ojlCAzDvwm4T41/2YXNO+RmcspPVtnCrk44e7N9YYaD
         Kddp1eEnXLCjh7y8GKa0mEqzKAZOgcW6TFJSwG5uqCmvgXN+Zd43Es8MlomZK/BGzspM
         2i1w==
X-Forwarded-Encrypted: i=1; AJvYcCUc+/NdZGeLNadNl5bP7Uz+3pO89rWDnx0J4bCYEbshWUqbQ36SIPfQgzFjPwYg94CshfxeTDZ5eDGWwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9nxK+ON55N9hfQUts177p5mWoymdktPp3hCn+0yOqzCHcKUo7
	IWdkOLcaeKbJ5UNqG0hYvOTE6U0Vuv3NGGasrCoU1NBy3qAAcHkEODD0eZEszX1ZHWRUrFl+1rc
	LqYbT2zJ1ipQwG7u07e9kt8wni35dI0//Cc2X
X-Gm-Gg: ASbGncsaeFWicZxUULSYcrT0EZqnLCrUQe/QIsm10haOWOIoVvO4fD+2FeU4U3lPtkp
	WVzK9WjjwcHpvDF7O8YHKg7FdWKx9oAhkSVb3
X-Google-Smtp-Source: AGHT+IHrwagCDxh86JudR61ERsEoZaOO+nNF5gGHxdmt+LQ6ru1sGeudHuNKonCIKj4X7Au1PNG0jPlYUBpASW7wnTk=
X-Received: by 2002:a05:690c:690c:b0:6ee:c338:9d4a with SMTP id
 00721157ae682-6f279bb01d6mr139492107b3.28.1734390178273; Mon, 16 Dec 2024
 15:02:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213054610.55843-1-laoar.shao@gmail.com> <20241213054610.55843-6-laoar.shao@gmail.com>
In-Reply-To: <20241213054610.55843-6-laoar.shao@gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 16 Dec 2024 18:02:47 -0500
Message-ID: <CAHC9VhSHP4zt-GtOWgjzC+vVJriJh32_T+7dt0uBtTLXuoYvnQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] security: Replace get_task_comm() with %pTN
To: Yafang Shao <laoar.shao@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	x86@kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-wireless@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, ocfs2-devel@lists.linux.dev, 
	Kees Cook <kees@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 12:47=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> Since task->comm is guaranteed to be NUL-terminated, we can print it
> directly without the need to copy it into a separate buffer. This
> simplifies the code and avoids unnecessary operations.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> ---
>  security/yama/yama_lsm.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

You need to wait for Kees' ACK, but this looks okay to me.

Reviewed-by: Paul Moore <paul@paul-moore.com>

> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index e1a5e13ea269..4bdfa51ea6fd 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -76,7 +76,6 @@ static void report_access(const char *access, struct ta=
sk_struct *target,
>                                 struct task_struct *agent)
>  {
>         struct access_report_info *info;
> -       char agent_comm[sizeof(agent->comm)];
>
>         assert_spin_locked(&target->alloc_lock); /* for target->comm */
>
> @@ -85,9 +84,8 @@ static void report_access(const char *access, struct ta=
sk_struct *target,
>                  * Imagine angry ranting about procfs here.
>                  */
>                 pr_notice_ratelimited(
> -                   "ptrace %s of \"%s\"[%d] was attempted by \"%s\"[%d]\=
n",
> -                   access, target->comm, target->pid,
> -                   get_task_comm(agent_comm, agent), agent->pid);
> +                   "ptrace %s of \"%pTN\"[%d] was attempted by \"%pTN\"[=
%d]\n",
> +                   access, target, target->pid, agent, agent->pid);
>                 return;
>         }
>
> --
> 2.43.5

--=20
paul-moore.com
