Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1A38BF76
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jul 2026 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783328240; cv=pass; b=cU/Hdc8WWZM9LNAJLE9lhjPDjw2RWAAvDe2FsWn5kNjjmhdNKQmp96i+YoVDkiurbqX6ySDLvtspNler/nz5lGMRsmsg8RacuTkHkWSMwZv6xUifHrkWldsUCPnEnN/YFGj9hSQ6lkpPi37zCNw5lFsC+OZxry8/nt5Rc0rE9Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783328240; c=relaxed/simple;
	bh=3ei4JGq621TpLEYaeIPVyJz6Rv2URImPhoRrRi+QUCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HP2Mo6XWepUpVlTo24IyFCZdnPtzz6arq4gGTD30Mz82UkkKrCId0jIIwH6tRei+nNWp2sdne4FFrFF5x3hCREWixe2u9QQVsulSV7JNkR+VN1b0jMlaFDs6Ko91N+3cqU0O00tQxs20BEFVHBXoppFl8WDnlm7f6weB3cWi/rA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2GOhO2B; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2GOhO2B"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-80cbb0688c8so38563777b3.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jul 2026 01:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783328229; cv=none;
        d=google.com; s=arc-20260327;
        b=UOy3N16g/1M95mwhhTM1CXLzPjycyCqCCWJV382F+1IlrTA8ycbEMtLyZObTJeRwBS
         LC+lnu1NgFEBSyY4z0v1v5sVRAc7lB31JKUvekvLVXQsRloogcuY9xoWQFXNCVUAnQQ+
         bfkoEJlKHam1P7OmxMjouQtZehBhD2P6NqndljuZdlSi1ZxmkukVOFjxZeOdCLlRx6Bl
         HHSlPkBJlGsFaakMDdm2HrOt7HbJz6vjahGzSTq0XwoSSbyklpW7EzhnYw5EEVwCxDeo
         0TLcfpPmbJyatuPi3/kVV5p4vj8N7JAinBArCYxjavAxoBclRsVxpfyTAH0IJMgWOFud
         fTlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N2etlpIn5EKQOAmKmriCOa0lKT3T1K8RZ+Raku32510=;
        fh=MSvir7TB+vM1TGVcwzzCuIYmBlYPs/TnizdwXyHp+6I=;
        b=CUDsjko+WX9w1xYUL5eC8oJ1wN6LDAV4EmU3/YIeXFU3XVHaswmRyZD5IwKf3YgKhJ
         XQwLdrg/uW4B2MfQhW8NhLOokGBeOLiWiO6EOzScOBKcdgRvzcVBvKA5u29RjvLDfFM5
         FKhXM0rdiEIY2dK8jQKj0lLQvhR01WZqqPrANDh2ktqW4hVsyxLgiKhrq7q1tA7u85S5
         s6RwWzROYNIlF+GF+Vu7/tcspHiKFKl0rdl4d8z/xVA5SYlKsBragJg6B0IMKLxUJNQs
         85wualPkteUcgI19pKOGWdu+6f5j4BHQm0NALVNWMG3LZMlyv+nmCxrbUbN7LqE79Jca
         vDmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783328229; x=1783933029; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2etlpIn5EKQOAmKmriCOa0lKT3T1K8RZ+Raku32510=;
        b=J2GOhO2BUaCdUSayd1wWdLcRCk3nZAGKYLBbtlwoARXbpzr059wOmSmE0Rzs3yyOVs
         8yGuUJJe4dEYZPP7cyJrXFOG0bWfZWFtk8qkN5PcFsuQgp2XsSs+FjXPWADcmRGbIhcj
         utPWBepsyW0y1jrV2aFsV2Nc+zAq61HBPHgYMvKQqI3sAjBQ3KJErUMieLSfhL4KZ9P5
         oIzPo3MQqXascmQMOwo5bAGYKre5BTzHZmw2Cke5xxQqffsTRju9XR+qNJrkVjQEHrvD
         JlFgt5WV/6UJ+yteEVaoMpnP0hQNl+GNBfdIn4CIf+9nM8WwJ2VghBeZ23962jNIAOYt
         d52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783328229; x=1783933029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N2etlpIn5EKQOAmKmriCOa0lKT3T1K8RZ+Raku32510=;
        b=l4KeLBuhRFrGANpA8xV9fkCA6Ia2gPL/VsBpiQKyhpWVQdiRRBzvfXT3I1SCS48+Jn
         mV2Bir+l7/Yc2O5riNgQL/RT2Vz+KyGiL85DNPEZ75xYxIshJV/AgUjBnsPU22IT/Coi
         UzQWef2bvUMrELoZlSoeH4Urc7dHdket/ahtbG0zdOPLOdjZOBa72jpZnhTsy3xRGWJ4
         Os3YuwHLhefYCMUnxV+ajkHO9TZ+B5dz4B4J0lT18F2QfMNUNRBxgQepGDjkGEfO8LUf
         qyDi0U0/BXcXwt1WdEG9Upg0FeRA8AR+OnVT5tKNsGjqgJTxLrhqyhRE6KAaeOQooKsl
         nOVg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5NrymFzgrCaWjkIDN4Ch7Hy+ZqHC6bO2nECFb4Mei+7GCOK8Tk2jL61TKpoVGGeB3dYLrGy/g3NfR1g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwNp8RsHjUmE6wvi/HA/uEwgk2zxuOGU/frY9Jixn4QCHGbYrGg
	HDDVoKXlX5PjekXxpGJqs1LvVCr+8ejGJSgiPPYFBtNmsxs+7RqZGixZQ+Zhvy5btup8FZww1Mv
	OyotYVSGtH4bVlJPVScAwaoNTF2cfCeo=
X-Gm-Gg: AfdE7cmhhqKrnD/EM3wJ17BasuraSM23+V7V2MkIt5gMHRswgjezJwLsT2wiRAmkDug
	73hzF4iPO43lZWjccJUk67wTIzTlMHj2i2+9ZKAiDCnbauvKJDDpUgJT3vvk9VhjxhJc8HkNux2
	kyuySQfr+r5JyeAfxxM3Xg4/0kv1rXWl6xJuIdlAmKiJ5eMVCziIBplaiSjL3dj4Y7FyX08jrSA
	XfqxDFTAexgo6bFEozzSJezO8ULigBnV/qiZKON3KoHiA7QwatKiTPUzFu7pLZxxjBVdeIPKuU=
X-Received: by 2002:a05:690c:c454:b0:80c:3848:bdf4 with SMTP id
 00721157ae682-817396f8523mr109297857b3.41.1783328229094; Mon, 06 Jul 2026
 01:57:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260624095310.763763-1-zzzccc427@gmail.com>
In-Reply-To: <20260624095310.763763-1-zzzccc427@gmail.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 6 Jul 2026 16:56:57 +0800
X-Gm-Features: AVVi8CdkQ-UrTujiFxQuJKSaTpeK1voNmJqw5IlNLwSNXf7GnnSoitSJ4UZdiv0
Message-ID: <CAFRLqsW4URbUTjiFEqM-xqDxoArt1gCzLgL+Pes0CY98jfycjg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ocfs2: harden heartbeat teardown races
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Gentle ping on this series.

This is based on the earlier patch that has been queued in Andrew's
-mm tree, and it fixes two OCFS2 heartbeat/o2net teardown races found
by KASAN.

Please let me know if there are any comments or if I should make any change=
s.

Best regards,
Cen Zhang

Cen Zhang <zzzccc427@gmail.com> =E4=BA=8E2026=E5=B9=B46=E6=9C=8824=E6=97=A5=
=E5=91=A8=E4=B8=89 17:53=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> This series fixes two OCFS2 heartbeat/o2net teardown races found by
> KASAN.
>
> This series is based on my earlier patch:
>
>   [PATCH v2] ocfs2/cluster: keep heartbeat local node stable
>
> That patch has been queued in Andrew's -mm tree as:
>
>   ocfs2-cluster-keep-heartbeat-local-node-stable.patch
>
> It is needed as the base because this series uses the stable per-region
> heartbeat node number from that patch instead of re-reading
> o2nm_this_node() during teardown.
>
> Patch 1 stops heartbeat callbacks from queuing o2net reconnect and
> disconnect work after local o2net teardown has started, while still
> keeping the callbacks registered for quorum state.
>
> Patch 2 keeps a heartbeat region non-armable while it is starting or
> stopping, unregisters negotiate handlers before tearing down state they
> can reach, and waits for the active or destroying o2net ordered
> workqueue before freeing the region.
>
> Thanks,
> Cen
>
> Cen Zhang (2):
>   ocfs2: synchronize heartbeat callbacks with o2net teardown
>   ocfs2: o2hb: quiesce negotiate handlers and timeout work
>
>  fs/ocfs2/cluster/heartbeat.c   |  99 ++++++++++++++----
>  fs/ocfs2/cluster/heartbeat.h   |   5 +
>  fs/ocfs2/cluster/nodemanager.c |   4 +
>  fs/ocfs2/cluster/tcp.c         | 186 +++++++++++++++++++++++++++------
>  fs/ocfs2/cluster/tcp.h         |   2 +
>  5 files changed, 247 insertions(+), 49 deletions(-)
>
> --
> 2.43.0
