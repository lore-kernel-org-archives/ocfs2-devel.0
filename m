Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85436E573
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Jan 2025 02:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218221; cv=none; b=tZTlPCXRngGdjr4o0KioihirAgSN7rQ4tsVStls+D4Vrycof8Qvs8f10oOm15ypXuII/xvMnzMQLGOP+R8mQMAbW2RCV5noFIYTVgA23WgtCwKkZW80zXeNL6+hdlxNrCq7f50pIEk+sjsvcUJ1wPML7DMlrzTeUmeFC19docxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218221; c=relaxed/simple;
	bh=qk46SEuRkIbjPMRsP/B4UPPqU6AyLn7OUUPNrMhKXOg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AYjnzmEtPuxlPog8z4RpWkc+4YTF4jzwA+5lkYGJ2f0YtVE81z3Oxw65MUmybeDk0qztcGZXoMQuAE62NJRZe2Go+2tGxA/02zalbi+7s4CSQu67YYqvlL2AMem8uqQLujru6R7hJy9gPi32RtkyiRS5DUQ+WnyBSGNZTAMWlQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BfGaCNnh; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BfGaCNnh"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so2498717766b.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 18:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736218217; x=1736823017; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEL6HuZhOrssSeK1KDJpmAJL/t5BytjEcqPXzORM7xI=;
        b=BfGaCNnhpWL287myDQ+4h/2ZAMy79eS1WozEL2mOC+2LO1mOVfTJDhIVYrG/L6TsTU
         Cbd2RHNl4KZfOp9A4iXEeclQITeemTictaQ4u1DT+polMx+OHgMprQR+N9SwBcgOdYD6
         AXwF9wU+Csyjzo7L0E/A+k6iulD8JgWQdZJ1s3thx/iWSmz7AuIkr91nWj494fRE4Lnu
         Df/HUb7DIp1lTf6k4Nzr4uGDrrJKqnKvIcn7jNquleLO2qaBmhwqcV2z+odYzRasslCV
         orSE2Su7Q6P47t2f0UFqc66FnUp4yGsBwqGxfUdf5W5UuAdVDX3buX9hgzhvB8hqsBP+
         FyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736218217; x=1736823017;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEL6HuZhOrssSeK1KDJpmAJL/t5BytjEcqPXzORM7xI=;
        b=PZgDLdvN4jTeWuZ7P39LeS+kBMeYOokpHpQ33zvenXBLOb1tViAAs2kIC8Ce2MfEqW
         uWe9xJThyZg4fethvyYJJxzHr6MSPkk7m6mkyoe9HcFMUTOefwcRDdtdeisdhho0Dug4
         ojjkbKq8mDEEjg3b9nqb0I2HgczQ65zvNVlfaIyJPMq9zoX0vwewPCU45KuK6dQ8dVvD
         iO6H5i6x0STfGzWL3CmZ5yT6+44YA2BjCUgsfb7SRflnDZ8BEWjDR74rxpWlTr+7yW3j
         8hE1DXQJtRIY/2DrGRsf4sg7BCFIjYWDEaNvuZZpBMSBXnKfMR6ZXx2LSZmqohrdSJ8W
         8rNw==
X-Forwarded-Encrypted: i=1; AJvYcCWfIZwhARK050+6tYsdmR6cCCqIBz55xga34Ww+AuBvb6kKYra5uDFxAB1bvg4zln4k9yA/JMZwslIA/A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/7Gh4j7XPiL/8OsiYAK1C06HW4KYAHPobE6OAgqOEoiWGko4V
	JL3JBBnIjUFsvy6l4w+Hexy0YgEM6sbsCdw+BSDCOqymxT600ZWFCTurj6BEEoI=
X-Gm-Gg: ASbGncuhEBC+pOjeNpflLQbJLbipnCzOIvlBg6F4sjtVIlwbJ53LyZ7i62X8/YrOPjN
	Eh8ju4t92dU99orI1/EkB0VBd4f0OSZGsSNPPcoKWGbE6K7Aug3higHFA0GixtaCOYLLoi/iR9Y
	yljQDg4WPTz6HM2AthlXYrZyK8jq9EhaMXjw49XNTjJSG/RscknhfAtx1MbHCLyfFECbyswagp5
	PGjtg/0V+Wx/eIF4HOd1wiL8YwwCUwibWv1eN8jrWk3GGld0JqNsL/I/IA=
X-Google-Smtp-Source: AGHT+IHa4CI3p7/EYncLFROKKRCiEmPVnG9ZJhYFnehnCDz97oM1NxsgOmFFIw63lX/28M7STqWkuw==
X-Received: by 2002:a17:907:9405:b0:aa6:93c4:c685 with SMTP id a640c23a62f3a-aac2b946474mr4738634766b.23.1736218216885;
        Mon, 06 Jan 2025 18:50:16 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f447883b0csm38407878a91.42.2025.01.06.18.50.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:50:16 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] generic/620: add '-J block64' mkfs option for ocfs2
From: Glass Su <glass.su@suse.com>
In-Reply-To: <Z3wFFs371-WNVreY@infradead.org>
Date: Tue, 7 Jan 2025 10:50:03 +0800
Cc: fstests@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <AFFEA381-1C08-46B6-97B7-9F7DD954BE0F@suse.com>
References: <20250106140104.91880-1-glass.su@suse.com>
 <Z3wFFs371-WNVreY@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3826.200.121)



> On Jan 7, 2025, at 00:30, Christoph Hellwig <hch@infradead.org> wrote:
>=20
> On Mon, Jan 06, 2025 at 10:01:04PM +0800, Su Yue wrote:
>> mkfs.ocfs2 is using 32bit journal as default.
>> For 16T size device support, '-J block64' should be used.
>=20
> Hard coding this into a specific test is weird.  I would expect
> mkfs to pick the right one, but maybe the maintainers have a good
> reason for not doing that?
>=20
Sounds more reasonable.  64bit journal support of ocfs2 was added in
2008, 17 gears agao...

=E2=80=94=20
Su
> But if not you probably want to force it in your config file or
> we need a workaround in _try_mkfs_dev.
>=20

