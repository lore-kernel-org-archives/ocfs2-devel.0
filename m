Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351302;
	b=kkbz5OH1M2dE2iHvjoibI0SaJTSJRApcvXvGb1gIIxbF0Wcu01oIia/voC6rs6PlH97+
	 1FBdwUHkOrGr1HXXgzY6zYOzXo1KTWwcPXEf/t+F8ZeCZEMNgNvLNEOzD8XWsdeOFeYzJ
	 1WW85EX3V58DUxLtVYOfub/RYz2SNYW9rqyzx0hXuCYjr6GdsYEuJ6je8crt3PMKldQtX
	 Km0jbQisyTalFERTjRva7T2o5Ellm4lyMv05FMfqYbdbIK5WKf2qxGFABVCMcHipA6TPY
	 9Bx9TtlMuWzOCOZJzXhwTzEgaqshuXvKfG/clqZNkDVl9rNXpow35+KNQkWTxtMLilQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
	b=x/EKxlX0LMvd0xo3aUGr68NchaJxeOJ1CJCyv0qwPL9H/d0ji8NqU8gomxcCXiS5m2Md
	 pAJrUb9Zy8scGazKSpryPsq7KGi7DIbb+dcbufDcSHPKjO2TKaS0yOqFnrVpHg8KbcEaP
	 nqQ9tr1A6qhkjYlKH4+heVlkT3k+KEHRRps1yEBahmBk0WC0lmhF849DfnayX8TcIfLj6
	 wPfdM2LoXu9zhaZSn+Eun4HffzPIYMSsXgiEM2KPFXTXw097+9x+YtRHSdvJX+y7ohYG3
	 0AYr6ETRUOokPsEzA6cbCRMCNvR6kdsnNAJ77v1H5NnikVOsRoQcIx0LWK1DAzXdc5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=g7R74Cgc;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7719E606A321
	for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 22:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7719E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=g7R74Cgc
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b467581b98so24257135e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 10 Nov 2026 14:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794351301; x=1794956101; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=g7R74Cgcy6bpixSjialMQ/ODzALkTnFX3HTckC485DBLzT7tWxoJ6D/uYSsqikm79Y
         ac+JGj65Y73KsK6RFN/Yip8j3pyXlwJ4/4lWNQoP+FMaecS2NC6O3rYSvC4fccqmWwof
         3/OXAWiAHXY1GinmtIILuecFUY94JU392WX5Hz5cbfEU1QOCCjM8AZ4msfMYJ7TL4BoR
         hcsU6jvNdxBVO6O24mIS8Is/0peMBBju8zC47y2NQLnn6bZuiMc6yGndfrkNAPWcuH4o
         65IKveqOVPXJ+Fq45uJrrCHg32CYyVjaI67P3BTD0UcgsHyiS7trr3JprpaH5oYXcakr
         640g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794351301; x=1794956101;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=oX9Zkhvq/eVJWso/XQCt3RWtsxc9M9sXVC0ai7or0VBo0w48AtA5nxXhb55d27o5fA
         6tdBaaI5v9379Elv9/Byadccfv629jjAx/xPWBKAQ5vEcSgj1JNg/XXrO0m/nhy3Xr7F
         Vgy7hZIVG0utElFz50pzQq0vAGLvBbKKGrzSlz3puy77fh+4U6kgyRqulnLdAOCVKSR9
         xcdKWOpINd3qKW1+5QV1h1akZ74LQ+TmIKv77etbIPxRdJx8RfxJqVtxCgAOkClHghC9
         arKrKUxjGU+1/vLnMVzJjYfZoZolHu6VQ5S2NuRCXGvDIfBiH6I9rPCG3prGPICAcxxi
         APyQ==
X-Forwarded-Encrypted: i=1; AL+hErHK9Pxv3/cb/IksPqPBJi4+Bz6sNhE/YCzrW0XGYh9h11ufH0K2vUNeUorCvfu3yz/aBkbr4yc3s9hxyQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8p8gE8fYCBqm6JpBO59sLi5bvpbaexXEKESPEFEo/uDXhLlN5v
	BNrnl+9eH+9Tyya8rvPggjDN9XpKcqOM5aFe5tjcnbBhJmwWEXby9uPyAWAeAEJGkM8LZ2tnf+Q
	64VrML1A2bFlP
X-Gm-Gg: AYBFou1tOHywMSQCtIJGFh7am0pbAxh8vnNIwrl7Dx+vvE8FZZuP361BKELH7E8TSdg
	1JHpUFLZoqhtKKgn+45oT3JQDYVSI0yZm1YqEpjUvTOYtFVyux9ltho8RFnT1ra2hCBWeQWl5cm
	xZLMfDmFUVaCpVKXfu0RB7aULHfr2oGh/mDvbcMq2jb66P2rVYzgPqyfmHc57hZ37w50A3/Mm3A
	0VddZ5OEv9KpPCZYJNb5PfCSuPurE8qjDBNeTvgEIF4wOLkkj4tazTdIwjgNZmw97/uBEpllje9
	GqW8SOz5TwjLSYW/IDvtOH1gtfl3X8K6BlW3gBkXPJiFCo660friUdvv3DG93hx7ZDpMOBhrnhh
	Q4qg5ynoZiB3hssxHzLyS954EJeOZUTwsRslHaeCZcQaMLZAylbfr22J16KCS3FHyb5a6xkqKwu
	Lggsx2gK0UdD8o21cOn/xp9M5mOKTyf5nJLGRY1XM0zjN4BWIqfZ+qME6EX3a8tr67ETZC6epS2
	3BzJX6mPPytKQERADZB6wr4v/YVisNIToTWxCm7LNSqH90qomsDz4LdP9lcVXLYew9kKoPkxNXH
	nRZqyZ2ciJY01/HK9MzC2g==
X-Received: by 2002:a05:600c:3c87:b0:4b8:fdd8:f2c9 with SMTP id 5b1f17b1804b1-4ba093c1c0bmr7546615e9.35.1794351300895;
        Tue, 10 Nov 2026 14:55:00 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e582sm1412409b3a.39.2026.11.10.14.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 14:54:59 -0800 (PST)
Message-ID: <c5c47eed-c927-4ee5-9841-7631674bf6a8@suse.com>
Date: Wed, 11 Nov 2026 09:24:52 +1030
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
 <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
 <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 08:24, Christian Brauner 写道:
> On Sun, Nov 01, 2026 at 01:26:22PM +1030, Qu Wenruo wrote:
>> I love the idea. This reminds me exactly why for btrfs_force_shutdown(),
>> we have to manually set the fs error without marking the fs RO, to avoid
>> exactly the same problem.
>>
>> With that said, can you also a set_bit() call in btrfs_force_shutdown()
>> to also set that flag instead of the exsting setting fs_info->fs_error?
> 
> I think so. I'd set BTRFS_FS_STATE_RO in addition to fs_error though.
> start_transaction(), join_transaction() and btrfs_remount_rw() key off
> BTRFS_FS_ERROR().
> 
> Note that this changes some error codes after a shutdown.
> btrfs_permission() returns EROFS for MAY_WRITE once btrfs_fs_rdonly() is
> true so opening a file for writing fails with EROFS instead of the EIO
> from btrfs_file_open().

That should be fine. A lot of other call sites also return EROFS instead 
of EIO on a fs with aborted transaction.

And I think for fs shut down, EROFS or EIO is really the last time end 
users should care.

Thanks,
Qu

