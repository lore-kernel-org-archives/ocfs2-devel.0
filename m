Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D936D50D
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.235
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129582; cv=pass; b=nxUzOs0C9/OcV4POUnrB1kuLVYiK5hH9o8grHvXEePAMyQ0pKrwDiobPP2QkqH0AadusdLCnms23NmpDPk4Z8d8dTd0TYAOpysOo1T6lgMPAVXZmPKCveilXcTL5PwiM6qGIp60wnQy1zJ/PQLcRIItVLK//ijTO10xkLW/vibo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129582; c=relaxed/simple;
	bh=JueReRxXF36/Y6Fa8OTRaKAq+634SD8b+cgAtq1zZgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jM3icpnXxvoiEsj9iSaORAVjNEq0lyL69lRJe85eYRhdQIJubQrvvRW0t6OqP4a4jwxu/bbj6tytpHB+VUN1LdNBjF1nOGxfeeronbo1ZgYwCNkPO7NltUIPWiMPPbgZLAEzMn98Op75nliSY5SXAE+TCvWJxbiGTAas8FDb1TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com; spf=none smtp.mailfrom=fasheh.com; dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b=MMiWCodY; arc=pass smtp.client-ip=74.125.230.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fasheh.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fasheh.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fasheh.com header.i=@fasheh.com header.b="MMiWCodY"
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb76c9deeso4794441cf.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 19:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790129580; cv=none;
        d=google.com; s=arc-20260327;
        b=NzmWcXnYbRTR2k5EmgKkM2JU9VePlNDDBpgj8SPeywXr76F8zKss3V5bpSL0w6G+fm
         Dr6q7BYwEVl5A/BT9auRDNBNNtXLsE6HfjsDHrvlOVE8ZmMMQ595ec3F3ZPNZwG6029k
         bbJPl6RpBoss1iXKvPYeoejS83aYd2dejcpR0JuvJN4/K6LjIWqC7P+9ljhs05kFcG2p
         4O5yrAD7qqSv3hJbhAGfHEAEk32zsWtNiP/qZbaHaVOGDmXMAR5OD12EXbh7OalDMXIV
         2yfFxTMqzk8492pVnCDnM1KNzUjvgAnK+yFZejqL91bbx7idWV21dABMjE/NvS6q61zM
         91RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8+NKsnMYUdtlXCVGR3Ho4DQYC3dNIX0jhxzsZA1mWNs=;
        fh=pNW56Q3s7ungvWpiVmo7BrtMXJFwVV6M9JUed3u28hE=;
        b=qfec+SK7R62Isvu3jWA5wKKTLmsXi1KdQ7vgt7F/mA5St20gq8ZY4TxzgwiO1zlCf5
         h35i8OwJ24+R4uADopPm+tIosVkQk9zgGGLU99VT7MXXy0um1ImMCSwm0/5pxJth4Xjf
         MvK6/KH392lson8UYFD5uYsFEr4yjFEYi5yQKPSV6L6IROLe9+NraCemIRYZLMV2EGKf
         ahA70V3Ag4ruQAK/M2Vtz/MuRSifk1DhkB8U5LgFu2v7vubImPaMM+p8Jlo/SoI3yIJc
         h2R9QK57/fzQR8eenFhFIwlfQDt8S2NaAAKVrn+ABGm4MVJhfRTNJF9CqgDqYJkKS6AK
         W5Sw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1790129580; x=1790734380; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8+NKsnMYUdtlXCVGR3Ho4DQYC3dNIX0jhxzsZA1mWNs=;
        b=MMiWCodYyHmsD1wYNbvg+sVqAjVNK/LwKi/UInFP16rHIZXfZ1DqpJ4vJXG3Zc15JE
         3fWVEXz1IinYX/uYK0Ut0mnJngpYuJAQOszK9e2OgEZKWZal4CvgqIK+ZaMYQfb2t5Wr
         5Omix4yvd7VqhqHnimqklu/8mW8pWg3XkSw9ew5IWmdTkwVusEcawczNUZWo08MQq1vs
         9qdnDXoeYNnIfPFiGg3UVYL2M6j6ghgA8Qe16z3EbZhWp4/wF6nZv3FWVsA1VU6aqabY
         haTuMN1v0j+I3Ac0+bXpsMxTNzSb7HQbW4tgBbE4MXrWehJpULYNndeDyn8C8B9fPu/7
         1pwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790129580; x=1790734380;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8+NKsnMYUdtlXCVGR3Ho4DQYC3dNIX0jhxzsZA1mWNs=;
        b=wA1a4x91Wj+Ajwe9OwuHb3rWCxXmIJuDj36+uHBXNW/BhcJHK7Yj79fPikNLgiHXn+
         761JhaKZ556t37Bd2T+RWUuGWiA1zCbnte+F0ghvo2EU2+HvNIV+OVBQGQf7epMio3C4
         /wYRKzNJ3xQV+64QJkqN8/3gnpQx8vvN3ee8gON7++AVz+jJp7WKbgj81BdEyyvDek8M
         97A6tez41nxJjCboh8d0DHcxZi0JNGAEOhOlaYkb9Y9Yx7uiyIEQTnqN/aE5LQbPbfEO
         mnsk7EqVkibFYdDelIq+7LxLwZ7yawcxnMJOyK3rsXDwV+fUcIGqyDY2KG53YdjIS5c6
         ILfw==
X-Forwarded-Encrypted: i=1; AKwUvBydmCYcTRj9qr9yXkoAPdDzdlLTfDJC/1iWhNgq7UMEHQGBwnhmPrzcZwh0gDoCuLjUTOMeUEJ0sggXdg==@lists.linux.dev
X-Gm-Message-State: AFuF++n44+8CWoXnrGAGRd2ydcManu6jzbmupSAWNMlZ/rktYFIJUCPS
	8h0xzgAIb9GOtjgCQ6qA8YRA9bcNSQLHJt8eHdsjVVFewOEyU+0VY56fXi0PxZpNUC1ZnPtQ8WD
	FrvvcqH7hLu4aNR0V/RelK6YSLLJ91WCXRNUSajiQT7VqffCWZuePnnM=
X-Gm-Gg: AYBFou0oqwUXg90UPQTkXtnffr8VRhptDFT1EkwVzFdx4yuQJiK/D8y/QudWYDckOzd
	lhNKnXeDWKoEQuaJmoAFLizWNaIS8kgXZoCyO1sHNHq5a1HyR0JamS0U/gdgDEkA35yYoeywI78
	tA89bukp8u/jnWaakqBPPB+nDiwP5XM7VrqzJU8zNq35GFBAD5INHr12nbmj4blibWATQAQHel1
	eGbEiNtx2GH6usokxzCTVttpVmzfIfgYb6Xu9naPD/iWNmoOIMu0chjSm/DU+sCQl4thF+9yP1A
	YmzEJBVRphV961LenWwf8H775IOd6zlpBCPvNfTeXm6J0/ILJufn6yYa6UQ/NLy1TGrg87fPsEg
	0hMyEebjRba6V
X-Received: by 2002:a05:622a:390:b0:532:9ca3:a400 with SMTP id
 d75a77b69052e-532eac690d2mr24213961cf.16.1790129580278; Tue, 22 Sep 2026
 19:13:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923003920.2382398-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20260923003920.2382398-1-joseph.qi@linux.alibaba.com>
From: Mark Fasheh <mark@fasheh.com>
Date: Tue, 22 Sep 2026 19:12:49 -0700
X-Gm-Features: AcwNN1UpkX3jOorW0vjOas-FroH4RgfpD_GIVXXvNGML4JW5Y6f9y4ClrdqhKt0
Message-ID: <CAGe7X7=pfXetdZ0Yze_nFWpa4XqFoQFXWkCtH7qh0eRHC5drjg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Heming Zhao as ocfs2 reviewer
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 5:39=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
> Heming Zhao has contributed ocfs2 a lot recent years, both as a author
> and reviewer. So add him as ocfs2 reviewer.
>
> Cc: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Acked-by: Mark Fasheh <mark@fasheh.com>

Thank you, Heming, for your contributions!
   --Mark
