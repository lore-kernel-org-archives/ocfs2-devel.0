Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185854;
	b=Oxxq4yKCTGT41vM+0QQPoAHqYPSh5U0AU9+k2ruWhCRtwDVbdt20iIOzaK45y8E5UJkh
	 vOQsq1xr0csfevffjrmMp2RUChT/DiH97uyRO17feWlPzsqVu17NIOB7gL+gRqn3DhYHo
	 z1kEQGmOvXtHMzGwPcT8m4dhfypeqtZTC7JzeuTfFNiVHAWklHKMDQeq3iIZ1uk1+v1Cx
	 TaArcba0M5BEynrT6qhxyMtfkD+I+NXtbmWFf3HofcySdDupv+JzamUuvqS7cpijkjNpq
	 fT77u8UE9axTajAZcJra+haxlqKkkZFMJukXe0scC/EMzo+L4jrDc7qv1lufcx6/AmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
	b=w3lWuID5YexXyeoYdjWZ9WlB8zTjf6a0PAY3ZXuejMDqCc2q640l4g1beHTJ8Yi03Iel
	 aGCxNE1NhT9+v0qToVCLp0qE4i2r77VVHGgnBER5XEZHoDqDdpRXQpyLlMaYQTGvsWNmi
	 jgtErn9Pmc9WWUul/3fVHhVYoMh3061/A/7pIGZhPKkaTlhXEk164BlukYAusLgRzeucV
	 bAd7RX6PHbd+0EljiCOWmL9RjJJzIY9pOpnUgpx+/aheoA4Mt0PIxJREWHKD0Gsox4+cB
	 xrGWvH6xmkLaBcToeRqZ/eKdIV/ZY0//+yJK/L5LQoL59Cpc2d7kIPmXYKex7ZXO5jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5PTNQb6;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD984606A32C
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 14:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD984606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s5PTNQb6
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-497614c95f0so609962f8f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185852; x=1795790652; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=s5PTNQb6+u9r6+ahsnp9e+tFEaO92ClCHnDNLlfs+1MrSc1KSaAKxhW2s4F2bGQ/KS
         WsFeFhoQMhHPDgraIt7xC1Ltw80KRG8h0HU4v/IrNRSl/vJcIWV+6qU/tCXOj4FkIANJ
         x3S/b1k6qQ3Y5jgq9irF0A81W4iHmtlRNzIUDHLyhB/LLKjo4n6Y1g0uN2Z/DclTwFkH
         /IeEi/hewyRpr2MW1XK3Vu3erdXkwOcYYIWs57qCzz6ln3Sm0H0+pxydNr5U11xrbWSJ
         nBGDSaqLK39T72ASngolkb51ZcrHpnRKeBudhlxpYcQyxRX7p6o4dGweNthmIZu4gJa8
         fNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185852; x=1795790652;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=YvEcS9nlVOb6OPAlvDJbkv+SXPAUMfJALYRVZYl+jCtnAFA9WB5dGxNfPImczFKQTH
         FZICSiAldQjPig0eSf5qX1Ku+UWLJ0am8SUUPIeftcFsadfXZMT/E1x933ABYTR+nt3L
         tVWQasZ0kxLAOaAnzbPdt9eNBGWkh8Xue7HlxfLybm1b+URY6/j8L+c/qHBRn1i9gPvf
         3nRX4Mn/g8hA5mVsRSvGZi+ZCfJhGBegXXDgyOWe3dVBcu5eHXtPpeVKdCcECrHomOtM
         G4j93rl0VZFWI+/JwRHElmb3TYwSgub6p7n63VD8uEzHljx3DzNVRV4kcaDSorhKhT8a
         ik4g==
X-Forwarded-Encrypted: i=1; AL+hErH8zG9eHiEB2HYgKOkD+EdCJ2I9u5k7traO8i0lpCCQHX+yhgB1ZNIr3W00wsBnqZCfkdL/2YRrxwEhlA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+D3mkf6XsRCSea4iGHfu8WnNXpvUgpcDjMkRwBcgv0662R7Rza
	rF6U1KSJ9/6/Jg4O32NC9XYkF/MLDmjgZrdXWbkzb7kR5Q98LXlWjsZc
X-Gm-Gg: AZFdTZfGkiT5uYw1vKz0eVnoHAq4tLaAHNyqkUakok8WsSS/PBV2TYWuw+B2CEU73DK
	RgK7se1rw0bK+CD3gU3wmOqUKJT5CbB6uCiK4XgFiFkK7VtnrPJR+ZewVKbnq9d/IUa9pxqd2lc
	FsFPf9tTFFxvAWvcXPU7TpJ7EF8NKfXGZHWbJ7FXk9bvJy8ykucG4rxS7H7tkHK2rsPde6UyyN9
	6IZsUf9AcboJ+StwkOdtiv3M866U1RCgaKa9g25oNqKwI+t5TfW3PES1JKhe3i+72FqJniC53wM
	xraetVS7gSheVLbw1Lw9rieTW/ZvDgeOfZ0jsoL4P7HEpN4rmJlH2EqM5lWyerAGsfNtbiSTmDP
	CxhsxEszDtMH8ykZn9UIHMgj5bh9Pe2x1+CvPmKm3aytPOnEiqkwqmDLeGaur64Q9p9nCxSHpyK
	VrBWlViVMKNocHHd22KdgJRowTfWNY1RS/AIAIeX4L/HO0pSSpKi2YOAlqn1ytrwRzauoljUpdb
	EN6ZBXODbvfDwlHAM2tI2JXDIMuPGK/FTHb+xE/95xUEp9quspWfbcb0L3nAmliIgwD861Amtfx
	Gu6wkQxQ8CcZas4+nSdyqXP82VXQXKA5v89IX0UiHsFIcMLS
X-Received: by 2002:adf:e014:0:20b0:491:8462:20cc with SMTP id ffacd0b85a97d-4abb400c0cbmr5198457f8f.37.1795185852061;
        Fri, 20 Nov 2026 06:44:12 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm6426849f8f.13.2026.11.20.06.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:44:11 -0800 (PST)
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:44:07 +0100
Message-Id: <DN049T7Y67NZ.10CIWW8DE6PP5@gmail.com>
Cc: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
 <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
 <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>> > With non-zero xflags_mask, internal contact masks
>> > can be used for -EINVAL not for silent ignoring.
>>
>> What do you mean by "internal contact masks"?
>>
>
> I mean that users do file_setattr() with a bunch of flags
> some of them are just ignored randomly without any any way
> for user to know about it, because this logic is some internal kernel con=
stant,
> which cannot and should not be documented in the API.

Ah ok.

Thanks,
koraynilay

> Thanks,
> Amir.



--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBctwAKCRA0bnTtJTDo
OG67AP99DCLnFsLMHCsRAeUitR3pAiNRglGbALKnTbw7U718dAD/Rbb718IIJvnz
/T8g9StMlY2VrgWntvlMz+RabJ8OUgY=
=dJIP
-----END PGP SIGNATURE-----

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd--
