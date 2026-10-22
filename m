Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792659998;
	b=hThcgmkVEt3sJ2AYVECMGRYsxEJb0etmr3FlFp9/bkA/9/SGICw9SVxtWk+sOVSnqcjo
	 vsxRNB4WbeRU+LbwTFwZrWKNvD/JNjFyGbMIylsazGBat7F9eJvtHaI3fOXEeO01gQmA5
	 3s7zMUtGH2qLT6J+9PuYlsTAc5QeCZAJAUzFw1HAfdnwOzFudFcP7WStOFpT/Q1xHYwqc
	 x23qpCNy4kjI+vKnh95uJkuL/sF1hFl9fD1vdiZg+XZ/JQt4H9/liGCGTJi3dcdseTA67
	 2PTdEby95+Do3K+yE0xVDuEi3iZYHI0QBndadDGz05bPQwY8yzWEvqeLdX05h5qnn2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659998;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UyTUiRbbZdV2Y+E25wMhrOuOBCwv5kPE3Qb6sCbOz4U=;
	b=MjR0oeq+7AUkAyNqItV98NzypBhAWgDAxPeVhEkC1+w9DyMv5E1m4nCQO4uiELDKd89D
	 G45MnocP2H844curqciJlQgRtiXZe61D7MsUU29PKD8XpFTLa+TpcLj3YV3K/L8VJaz39
	 3F+fpC73zCJLmURj55jNZO1Of/tbxeix0sLZ4S9aCSxOvoS6vG60I9zCvC7xmGRlm7l3c
	 yBOWGmO8bvAgfVQN2IXaiSeja3gbRePSN1LUeOlIZmeFjnqoXzKt/9U0oV2XNRdkNUdZ0
	 xjMOi9fWMSLtY0IE3HXFdX5tKrkdOfR1mxOj2UFRK0a1XdItvWL6gTGAd+hnp6vQgTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F4AFz17C;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.171
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624A8606A31B
	for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 09:06:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 624A8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=F4AFz17C
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b0d91601bdso5649557b3.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 22 Oct 2026 02:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792659997; cv=none;
        d=google.com; s=arc-20260327;
        b=M4zhffx7uiNFgQKJ9rQ/jV6W1dw7NpGhcs1E11xHjYT1doJvgW/WsVSek64xPf7Twk
         +Wl+/w3mDZriZlswyT8JmUHcA0VwwJNNsx380kstwxGWetxMP2O8qVB1NcamHHdi1rys
         4/QuRt2nH4aeWY4me5NhAX8RXgpF1sXGFq4+pGcVFMdTa5/WCh2DM+z//H4Vb8jqdOhv
         Jm/1bKeR3SBvfA6j7WHQAL0eS5tQrQUs84IWuS/3o63px3uqXvnI/Zel3bBEFZpzdJmn
         o7BA+LlhhnvtjHS3+ZUGfG+8+oJgv9jEmj6Zz5wcwTpEQ1X9ZLNCXz/pk+bi8E+FT6P2
         NXEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UyTUiRbbZdV2Y+E25wMhrOuOBCwv5kPE3Qb6sCbOz4U=;
        fh=38VAkLc8LmLOgmiL+a4A/zEYqwcQ6XpLJFruUJBEEGI=;
        b=CmmL/qTrpUtyy8oZwtjtOz8TIGWx2J1Ywt5HjbJsh03KXlZPMx97A7auN6JoAiSeIE
         cSM5rXla7rRaNJp/60otdF1GeClI5tHz8jw1HSCJBUFR7m9NQ8AYuVwOH3NCDqTCKcat
         4rQNkzKEZS9TxW5GR/Kfi+Y2Qm9NM+D3TuXH4SwP0W8/MD9P95dsJhlJBNsM+tzY9abP
         u8Ll1quor2sYg9SETnXyypoGFvz08Pi42EczCoaxLjLOR5ERZFb45iedookp48UcKWQX
         Ai9IJ7KgzL8K+8lKy+zQEw55+EAaw2vDVGTh4ayqyiNl0/j/adKBmKoX62n5HRgkY7Iw
         /C3A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792659997; x=1793264797; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UyTUiRbbZdV2Y+E25wMhrOuOBCwv5kPE3Qb6sCbOz4U=;
        b=F4AFz17CEAfNedjLiqNYitWsjLe3raQhcdHDxXZwzuT09E1vHYyZC2vz/SJNnFKAPA
         cMqlyXUffNzlDAQq/2uoXVbR9A19t5f92L3tHPpXxAG8kRTpxO1mq8Grb/YR7qhJxkoy
         /M0ZPAVvVtFRa3X6KpU/9xRDQ8Hmz71fmunj+KtZcmJUHUM84qa8VxpSUtlfdTNJ/jVI
         HoE9mkjfKV7pyfED+GZH4H67bDFi11aRyAYVreVlrAv8oL3e5JVC8uIQ36i0Krdjti5C
         BR8OjFDCWd/akHMXTdGx6aPwgRYTf2aEOw9GaZs/2hVnsBrN6+vWMJiGpwQqkqAsM3su
         /kmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659997; x=1793264797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UyTUiRbbZdV2Y+E25wMhrOuOBCwv5kPE3Qb6sCbOz4U=;
        b=KQ8oU1Xxk6jC97kDhui4E1wsCMqC33PDOUZ8Fu+Il/p/rJyzDBpzmRAIXxMRyAgFqB
         AKZMiIfW6qcNyfijcUXoC67Ox8Q+LOTfwDoZv+gUxRKFv/jFxknpcz36reHHNSs0g9QK
         1X2cz/dtmeXXulbcpdO770OOyzxexDQYdp18Z4yOioKV3T52tNMt1y+Qdfku+5aXMkOW
         J+t/Jy3PxCaQ7ndedNC2Lo2hSfTgJOblqb2uzWgURBMvrTsjmKK7C//O9U9mNw0L1Nja
         vb9Lqsng0Ky9vG9o/JDQfKpdOacK53opOd+rYjDJH6VQi3qAB6XBGyCi5wmRddnsi7lf
         TgEw==
X-Forwarded-Encrypted: i=1; AKwUvBxIYERn4jXZ7htkbQ7lCJx1KkA8UbiEg74sCwp7/sU3eTaJyPakRmrKt5jnel0UAGz46/RGcplRt5TW6Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYJUGYa4JfHEvY5Zd6BmNK7CcQPP8EE8BacxkegxFHCUAXURiJVc
	Rhsp0CrzQJ07+wA0vIWI3aXaD0rKTheyWIVC8rn8ad32cyunnAP5zpJNha1g/F7ondaZV0K3FE2
	9o6QCp4W4/lNm9vNJkfinrdXNzEuHLMs=
X-Gm-Gg: AYBFou1viKVcZ/dI7LAdBEHcDIyRW4Qn7ehzQwNJZnK59LKfPlvxG5sH7jvJVEfVq0z
	axzE6X6dvaDhth9v+9s1csdjYWPce73QDOaGrw4ugeTGb77Sc6StEKy4ZDIFF3nuPLE0A0kdkZD
	/UWAhEXur2tsBLhxq//JtJYPLEvhjj5xYjDk2A681B31dfORN6bNXyJulyU7VMszwGysly9Pn8g
	iw0fnP6+pra6TGEXB6KiOClBBIzswTTyfnWs/VmY+XNvtJzfSKiig1EECXEfvNaeIGt65px3JJr
	r9tWUDbyXQtwXEG9VaCzZhzZRhlkBheUrR2czdIDgMIpYZLGl/sIJlmHHgBeUh9ofHhHmcMnoSs
	Abo+uSJ41AUtDGD4aA9qNmqwWqo/3em4hPBHLyWM=
X-Received: by 2002:a05:690c:39c:b0:87e:645c:182b with SMTP id
 00721157ae682-8b14566215bmr12678527b3.26.1792659997417; Thu, 22 Oct 2026
 02:06:37 -0700 (PDT)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <pm-ocfs2-objects-candidate-0076-v5-dd198d8a9358ad81f70e@gmail.com>
 <71dabc63-7e67-4c25-87eb-17fcdf2ddd3a@linux.alibaba.com>
In-Reply-To: <71dabc63-7e67-4c25-87eb-17fcdf2ddd3a@linux.alibaba.com>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Thu, 22 Oct 2026 17:06:25 +0800
X-Gm-Features: AclHuK8qr8lGZVzy8X9c2s5HmaHwSWxAw5vzbUjDMFtGTi0PMRSmysIaKNfkgTU
Message-ID: <CAFRLqsWR_ud2TH9wFnErxvayZODG=SN13c1H-AS4XVL=gytwnQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2/dlm: drain join handlers before releasing module text
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, heming.zhao@suse.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, baijiaju1990@gmail.com, jjzuming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

Joseph Qi <joseph.qi@linux.alibaba.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8821=
=E6=97=A5=E5=91=A8=E4=B8=89 21:02=E5=86=99=E9=81=93=EF=BC=9A
>
> dlm_unregister_net_handlers() is also reached from the dlm_init() error
> label on failures that happen before any handler was ever registered.
> So in case of an empty dlm_join_handlers, o2net_unregister_handler_list()
> walks nothing, but o2net_flush_wq() still takes o2net_wq_mutex and drains
> the entire o2net workqueue.
>
> Thanks,
> Joseph
>

Thanks for pointing this out. I've added a nonempty-list guard in
dlm_unregister_net_handlers() before calling
o2net_unregister_and_flush_handler_list().

Early init failures now skip the global flush. Partial registration
failure still unregisters and drains the published handlers; the
subsequent cleanup from dlm_init() sees the empty list and skips the
redundant flush.

The list is private to the serialized module init/exit paths.
Nonempty lists retain the full unregister-and-flush operation, and
the generic o2net helper is unchanged.

This change is included in v2.

Best regards,
Cen Zhang
