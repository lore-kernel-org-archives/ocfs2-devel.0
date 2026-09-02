Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6516539EF20
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Sep 2026 21:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788383292; cv=pass; b=mJWy1Ih9q9pcpVE1QxOI4BNIOYUpNHTpi6ZxGTPL4+osaWEuzX/TQrJhtQL05hPs61azdVT9N5DRn6eB3Uz0Qi7UYzpjKPY98Snk8j6Vo2OUfcoN4RZLIedJON8DOuozywUUCl86JRGirQwYMvwUzWq0v1mlcGDgp9e5gkXPP+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788383292; c=relaxed/simple;
	bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ncaezMZWCmBI35WqJWuDx/i88mqOkaTZE0YwjJowZXERA5JRDp55oUp9Eb8ij1XDa8nsNQhFlPcZkFkgZOLw9FvRoJvf3CYEUPIQIjlHjgcg8wYT9wXafFsLJyIYS9MZycnCfVzUGSwRpIOnBlOu15sb6zZm5N7cwDPigg3UdVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com; spf=none smtp.mailfrom=fasheh.com; dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b=PqYN2Dkk; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fasheh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b="PqYN2Dkk"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9390dd46b45so115664885a.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 02 Sep 2026 14:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788383285; cv=none;
        d=google.com; s=arc-20260327;
        b=TSdJJnT1fN0Ezcpnq95iZcC84BRhE49ChUoZ+05VU4NwpTy1Im3cZn6v6HeEXOy/w4
         BLocB8zm024r+93zim+aeW0z+18thfbWJ4NFZGdPPsWEHtMCLaxJIEibYOoHAbq2dAcs
         6mguh8Dh1HV19UnyuHW99213Vi2hc6v1RYnYjHFAlN1n5ud0ouA4f2v38jwQ07wODvAl
         suXYnr5Ff28TxYtnOEJ/BqFYYPWKt0r9tAcImG4fU4bnzhDrU9gd52y8heeXnYbhP/33
         WTYFrHY76+noh+qBTjnU3dl4180sdRztXD17snPchzMO5aNoai760cavHcUKemyR5J/g
         NE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        fh=MIAxTcsRRd82R5LmCkUgLdBP0KVLdtE4bV8H9hNrOec=;
        b=VU6BZx4ce0+v34s/JQZhSwzuIkjtDGrLe71gQbEP9M3iNoaMKHauGn7pHm8PN5BFfg
         DmIiTKL/w/Vd/dN9Hfssf6wRg+OzdzBOj/d0/Isoh/ACrjVpyFPahnPq3lfqtB6H0euE
         1w+wHeSskv7w7ScWX6J4cKi94K5/JvBhiYiRJoUqbWdr/wIrvqIR/YiDFfsLPnTXiPC9
         /GEun0AHwTLU8SfFrNL9uxbh2jVcC7E6GwwesmGpXCesAEhHey3ZGe6VIgUN/RfMZ9xm
         u5qE6xVLggmjVfydAN3QgpZ0cz4tV4tckzeUtWZoTtKHgeDZxeoRRhTAwNaz3BS77/1Z
         tS0Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1788383285; x=1788988085; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        b=PqYN2Dkkn3VpIkGJFoAjdbfkIaUZMWknhHjaY5vLi4J5J0qAH4SLZx2Y5bclYNKyTD
         BxdXoQfnJx+3lDw55xJwcKwTo/+BbhzW9VM21JFP5wFNwrHUyrs1bM0ezU3KdWxc2eaS
         xZUHUodeFz3jfAwbR5AWLrbrt90CA7YxH1ePBGmRiAucllf53te2OcB64c0oJ2bx8zB/
         68vxoxLZn7Am05iqAuo1CHxzZFfEjF5mwAOCIG0Y6d3IOAVlHnzA0P3dwcFI2uy7/xrB
         /GyxG3gLOagsrWe3+r+xOvU8+3C9qIGs7iMFpxDWI8NVsUJFDuiy/YhCE33pRoJGpBFW
         Tupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788383285; x=1788988085;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UN1N4GaOPeTmD6Z07qcHfiRUT1OJYE5x12PsUkTyt3Q=;
        b=kES/Q8CFtj5sr5HUxPUBNT7Glu4dYG2+nTO3O0RtyRj11MQEQj/UmhitTDvt1HYRV4
         4XT+U2F83KwJUtuR4KFAKvQPBwRwC7RA4pCdocaKJR3LrLmOYWjWSWuco9q6j1R1VLRq
         eKWI1/Gmim9PHPxWXCFDZB8l+ribiuSKGKoKFFyeW4wdUlzDqg+dlNcS3bsyd+rAYQBK
         P1YyfJi5iQYAm+CTIsLpIKNbD8eC1gVkf1sYKAUW4J5lnndBoeBxob+QMb9XFCZC57K/
         J0XQ5oRyx12LuLuRNpHCQQxjahn6AwOZiuhPb3exjmO2tge0OXQYAgdGI3MWTkktsSs/
         WAcg==
X-Forwarded-Encrypted: i=1; AKwUvBzsEF09gjeozn4fz7ri6HUf510n/dP+RyskyMwkB4Vnd0tkEwToi7LHmoCoUnfvwIIcypPtwueu7++IFg==@lists.linux.dev
X-Gm-Message-State: AFuF++nZ+s767NEjqm/dLBI/Zu4zmiLJPXsKhSM6G8gXUM386sa4YFXd
	32lqCYO0fG4y8CCAUbHgRCh28KJPwRp26Cj06sooUkI9lE9H60sFOPOwe+93HfiA2ecye4HAmJN
	3Mi2qJ56Kw48IRJ06Spq3xgpGbBgYsspfKNuXlIW3Rw==
X-Gm-Gg: AYBFou32GyHnuGXxlxwadBGqlm1vbKBUwoS/DsC/PGZ7L4I/SysYx60k4d7nE4ZT81e
	Y2ws8ttVjnGC49kfubINFEkD0Im+x7QLy5/xikkYbAMCDT3VkXs4RLRWulM8TZIvhcDM/P+GHzt
	fQOqdK5rFobWr5d/DMmLKR6R8qdmR3pJF/MSGX43BWMnk7o+0477vqAIxD1/Ny5KbzTuPLMmufa
	tuyptSTiUCvSjEw0aiKa+m/jhJokhy/I5T33n+lD2WXaOWJ892vxl1Z6vxIFeJ6Cobsz7JbUu2A
	qUoxdIEUmV2k/UeIcmhJ+PybRCvk5bbL4iGFYqdX+BgFud/cKTY/EsHMG/X7Bm5nyZdzETZ/EU9
	kcNvLnzlDtoE=
X-Received: by 2002:a05:620a:a489:b0:938:fd23:1e29 with SMTP id
 af79cd13be357-93960cb95e6mr829447085a.4.1788383284982; Wed, 02 Sep 2026
 14:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260902132458.23590-1-jack@suse.cz> <20260902133702.1313635-3-jack@suse.cz>
In-Reply-To: <20260902133702.1313635-3-jack@suse.cz>
From: Mark Fasheh <mark@fasheh.com>
Date: Wed, 2 Sep 2026 14:07:53 -0700
X-Gm-Features: AcwNN1WtV1dqVx49J7eUpu1wKtIk7R3uNrgG2lJ_B3RcbI_Kpq3v_hSHulQC3gM
Message-ID: <CAGe7X7kgULLGViiEt1o+F32eU7cR9-vTvc3YGJXSg9Wjxa2Sqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Refuse to enable ocfs2 format for another filesystem
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 8:26=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> requesting to enable quota using ocfs2 quota format. With suitable
> passed arguments this can get upto ocfs2_local_check_quota_file() where
> the passed superblock is from the ext4 filesystem and that can cause all
> sorts of interesting things, most likely crashes. As ocfs2 quotas are
> specific to ocfs2 filesystem, verify we are indeed enabling quotas
> there.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Mark Fasheh <mark@fasheh.com>
