Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE252D5C8E
	for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766068940; cv=none; b=rqYIIiXDQ7T0BMauSiNDKhaSEz2dL9o9UefF3sL2tmQj0RAUnUua2mVeCspRoRamVJ44QCw3nv5W4vD8kxzHDmHb+bU18ckBCBuev+ox981Wn74xKWaSg9I8W49k3BHC7JGZDC1MGi69eivtcmOEIzGtpQc/rGwE+oYaprp7B7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766068940; c=relaxed/simple;
	bh=JbyFwkemdotVzzBjsqkcR3Wg92KF14of6JS2PxZwGXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wep43Gz/UZmLj5fqAlMIUMeoXjbbsC9xHhPhTNQrAfe+FJwhoGXxYl/PlLC5hKOvuF0AZp+fxPgkJ89p10Us9njKURQ4/hs669vQw7n57xZymZ1X4LeUPKlxHyn/qSe37xnpkWR7VSEXDc+5pUVjn1rf4K3vWY5tzPYJUwfkn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AJ0OohiH; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AJ0OohiH"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47797676c62so954295e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 18 Dec 2025 06:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766068936; x=1766673736; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xG4qJgVPaHrhU6PmkRbaH1ZkPndgRDfVqYG0LjPu2bs=;
        b=AJ0OohiHQV0oYgXg88F1QVpOcLqRxDkYZj4KCKOauCDSFjZxmTiVXy/wcbVs0hlpzj
         9y1fIPV/JdjPfURaUURlIsDOF2PGh7NRy/S+XOFl5HQFrocs541KoYo5Ucljdzg3Ipa2
         tL+iSuZGfxgyHr6uEXPDOfORkbDv78lj57bSkAp+YeqOr+94LkFpgDMoRYgjuCgAIKbk
         WpBfDA+LRY15RXIsK2I+xJOkGzHeTPlQ4cVuETfpOt+nyqy4JYvIrcZcXBhtoPQw+JO1
         hI1DwFD1i/xh8KZ8Q3xKm3haXOCJIoL6VNeM6vMSjkj3bMuw5kemHJgTUqbWB8CG+xM+
         H0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766068936; x=1766673736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xG4qJgVPaHrhU6PmkRbaH1ZkPndgRDfVqYG0LjPu2bs=;
        b=kkBkdUoDVQVcycI7pKWafpYbAw0kjYjpouC67Okvet5HeftrBuQw2LBdayK9nShwIO
         BeRZVdWGr/0VIHocwiE8Tskq+M1dxKs1lS1jii+KfK5StYaxKm3WXXyaxq4QCvHRcu9h
         YBj+lUA6G2cKnhTr+UqpplZcQdgZBEtfluZswyEBiubUymp/L0Qbj/h8N6lpAqL1NpDX
         sRH/lYZeuiSaWaVkuZTQYK2bcutpVAPCBL4rTUFy/e9vkJljY00MTGp3s2v5KbA1jONq
         KtczTRgdyOD/j1Ikr7qiXUSvox4pmwPj8a1bd57OiJLZAHU1GzEcchoAN/nsu619AYgD
         2/og==
X-Gm-Message-State: AOJu0YxoU8S3+1MKlcEYMZb6tOabVIdcKmig4AMakxsorqyOsRc66TSa
	Lbp0uzSdG0FVUdQFbEaTXMeIGDk3ilJEtgmaFxgqlos5rm8Z3b6ZJLN9t/RiP7LQVPI=
X-Gm-Gg: AY/fxX7NaLXgImju1q2isvyB9bKIfGh0mcvzNwCOINH5RcJQ1Fesp62M4UA6t5Qpck4
	9imPdUoSEfYJaIeVJSoQkO89hB7+1gd9DjoeNmhyLMCeVfcgiStHolbIaK3/sAMP09Cs1xZy2Bk
	n/tzyYb6XReAOAH4yeLWoMGwVAGMKovEnPQkDPLt59ilWSLk5PwtH/sFjOmf3Bne+8zIxTjtSIN
	aK+IF67C/0irnjM77DnQIDpVeSJ2S3USGYbR8cVP/NahOQEu5HwskiAwP6YzAT7YnvmYOwO/EKX
	QrGnN3Gcm6cgC5UTnmVfZ9tj+AucJzyiBs8uCj6CTP/H5jg3EHwEjTsvghRwbNs2VY52WkqhUEF
	t5onXGaBZ49UM3vziIrU5pVN3EF7O7yNMPWnSkfpn2YnzDMpcos2Y2V/E++O2bNBjQ0fnVM9sYG
	8JnNGCXFsyIg==
X-Google-Smtp-Source: AGHT+IGayWHPtSOEruhFKHTQk/9aJEqcT1gZBr58SwN0OrVHd0xH0UDMRUZYrO+FNHjay3o25ZYlpA==
X-Received: by 2002:a05:600c:628c:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-47be3c862f5mr14630545e9.1.1766068936109;
        Thu, 18 Dec 2025 06:42:16 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fa20f18sm2575265a12.23.2025.12.18.06.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:42:15 -0800 (PST)
Date: Thu, 18 Dec 2025 22:42:12 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/1] ocfs2: fix reflink preserve cleanup issue
Message-ID: <2ddspqqrnjaf4dsw46cx5h7wxnlmaqpbhhiolrfrn2c63v5txg@deaax4xovu64>
References: <20251210015725.8409-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210015725.8409-1-heming.zhao@suse.com>

ping...

On Wed, Dec 10, 2025 at 09:57:23AM +0800, Heming Zhao wrote:
> why resend?
> I pasted incorrect ocfs2-tools test cases.
> (only modified the cover-letter; no code changes)
> -----
> 
> Linus and Andrew are busy, so I don't include them in the patch review phase.
> This patch continues Linus's job to fix the remaining issue in the reflink
> preserve path.
> 
> The patch passed the following tests.
> 
> from xfstests:
> 
> ```
> ./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
> -e generic/081 -e generic/266 -e generic/272 -e generic/281 \
> -e generic/331 -e generic/338 -e generic/347 -e generic/361 \
> -e generic/479 -e generic/480 -e generic/628 -e generic/629 \
> -e generic/648 -e generic/650
> ```
> 
> 
> from ocfs2-test:
> 
> ```
> single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l /usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster -t inline,xattr,reflink
> 
> discontig_runner.sh -f 1 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster /mnt/ocfs2
> ```
> 
> special test:
> (reflink command is from ocfs2-tools)
> 
> ```
> ## this case will leave one entry after cleanup job
> ## create file
> cp /usr/bin/basename /mnt/ocfs2/a0
> ## set OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS
> setfacl -m u:ocfs2test:rwx /mnt/ocfs2/a0
> ## check, will output: "user:ocfs2test:rwx"
> getfacl /mnt/ocfs2/a0
> ## set OCFS2_XATTR_INDEX_USER, don't trigger cleanup
> setfattr -n user.comment -v "tst-xattr" /mnt/ocfs2/a0
> ## check, will output: "tst-xattr"
> getfattr -n user.comment /mnt/ocfs2/a0
> ## set OCFS2_XATTR_INDEX_SECURITY
> setfattr -n security.selinux -v "unconfined_u:object_r:user_home_t:s0" /mnt/ocfs2/a0
> ## reflink non-preserve
> reflink /mnt/ocfs2/a0 /mnt/ocfs2/ra0
> ## reflink preserve
> reflink -p /mnt/ocfs2/a0 /mnt/ocfs2/ra0-p
> ## check
> getfacl /mnt/ocfs2/ra0  # "user:ocfs2test:rwx" non-exist
> getfacl /mnt/ocfs2/ra0-p
> getfattr -n user.comment /mnt/ocfs2/ra0 # "tst-xattr" exist
> getfattr -n user.comment /mnt/ocfs2/ra0-p
> getfattr -n security.selinux /mnt/ocfs2/ra0 # no security attr item
> getfattr -n security.selinux /mnt/ocfs2/ra0-p
> 
> 
> ## this case will trigger cleaning up all array entries.
> ## create file. then set file with OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS and 
> ## OCFS2_XATTR_INDEX_SECURITY
> cp /usr/bin/basename /mnt/ocfs2/b0
> setfacl -m u:ocfs2test:rwx /mnt/ocfs2/b0
> setfattr -n security.selinux -v "unconfined_u:object_r:user_home_t:s0" /mnt/ocfs2/b0
> ## reflink non-preserve
> reflink /mnt/ocfs2/b0 /mnt/ocfs2/rb0
> ## reflink preserve
> reflink -p /mnt/ocfs2/b0 /mnt/ocfs2/rb0-p
> ## check
> getfacl /mnt/ocfs2/rb0 # "user:ocfs2test:rwx" non-exist
> getfacl /mnt/ocfs2/rb0-p
> getfattr -n security.selinux /mnt/ocfs2/rb0 # no security attr item
> getfattr -n security.selinux /mnt/ocfs2/rb0-p
> ```
> 
> 
> Heming Zhao (1):
>   ocfs2: fix reflink preserve cleanup issue
> 
>  fs/ocfs2/xattr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> -- 
> 2.43.0
> 
