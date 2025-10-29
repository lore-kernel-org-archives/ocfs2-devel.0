Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EB121B192
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752408; cv=none; b=TwpdWkU6bqJ+MgVL5ERPvhSlW9XfazLqVA2oPKh8orHHKx/90SZ1w1vKjP8mlVjHI1HW8ioZ3DISlwfv8C/93sYDMXnMUonrxLHfmnOb/ty+5E0qXv2EP7RH+9qcan3i6UT5ty9GqvyodFHt3yJa6Zwry3Hxmp+GkTco3K3ohQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752408; c=relaxed/simple;
	bh=fP+8OujjhIPutsUcKY0D8SU1dEEJQAy7jIHrWj3sooM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZzFbkDC/ZrCl1sgL6cW43m7eAdxbrTTRkt2JMR1iUkPgC8HNT/wxk16tr6K9uqaiYnMvQ88XGtqj4yt5tUqbdooBo2p2HVCUSf7l5MW/9czeA3+jzf7/vaZSO1CqScfP2XB2VLo4jMSa6qjwWqItAVtWYM8awflQ0vs5kWCtwyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=PKXuNa38; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="PKXuNa38"
Received: from mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:1a9f:0:640:d543:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTPS id 1594081E1E;
	Wed, 29 Oct 2025 18:34:22 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id KYg0X92LOmI0-v07JZEAy;
	Wed, 29 Oct 2025 18:34:21 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761752061; bh=fP+8OujjhIPutsUcKY0D8SU1dEEJQAy7jIHrWj3sooM=;
	h=In-Reply-To:Cc:Date:References:To:Subject:From:Message-ID;
	b=PKXuNa38aAxKZgwxRfoCn6W28HBbSHOOzmG47nKQb4YxL9lO6HJpv86Gys5CaqJGQ
	 K4c21zb4gHYiMGakGUdi/jB43oH/66HYk0HcLoXLF9KuAez+yJonAJViC2CIHxRPMb
	 vRrC23o+VSHlmrgMRZF+SocVUVqfC76JtdlHajm0=
Authentication-Results: mail-nwsmtp-smtp-production-main-58.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <33acdfb3-396f-4d6b-8462-c973bed5e7ca@yandex.ru>
Date: Wed, 29 Oct 2025 18:34:20 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, akpm
 <akpm@linux-foundation.org>, Heming Zhao <heming.zhao@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <CADhLXY7Uy-y8gAtXD1=xmc_UBocVci1z-nE17iA7q-y01Y_WFw@mail.gmail.com>
Content-Language: en-MW
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <CADhLXY7Uy-y8gAtXD1=xmc_UBocVci1z-nE17iA7q-y01Y_WFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/25 6:02 PM, Deepanshu Kartikey wrote:

> I'd like to investigate this and send a fix. Let me know what additional
> information you have, or I can create test filesystems with different
> block sizes and debug it myself.

I would suggest to start from the following:

--<cut from here>--

#!/bin/bash

BS=16M
COUNT=1024

# Blocksize 512
rm -f img-512.ocfs2
dd if=/dev/zero of=img-512.ocfs2 bs=$BS count=$COUNT
sudo losetup /dev/loop0 img-512.ocfs2
sudo mkfs.ocfs2 -b 512 -M local --fs-features=metaecc /dev/loop0
sudo losetup -d /dev/loop0
sync

# Blocksize 1K
rm -f img-1k.ocfs2
dd if=/dev/zero of=img-1k.ocfs2 bs=$BS count=$COUNT
sudo losetup /dev/loop0 img-1k.ocfs2
sudo mkfs.ocfs2 -b 1024 -M local --fs-features=metaecc /dev/loop0
sudo losetup -d /dev/loop0
sync

# Blocksize 2K
rm -f img-2k.ocfs2
dd if=/dev/zero of=img-2k.ocfs2 bs=$BS count=$COUNT
sudo losetup /dev/loop0 img-2k.ocfs2
sudo mkfs.ocfs2 -b 2048 -M local --fs-features=metaecc /dev/loop0
sudo losetup -d /dev/loop0
sync

# Blocksize 4K
rm -f img-4k.ocfs2
dd if=/dev/zero of=img-4k.ocfs2 bs=$BS count=$COUNT
sudo losetup /dev/loop0 img-4k.ocfs2
sudo mkfs.ocfs2 -b 4096 -M local --fs-features=metaecc /dev/loop0
sudo losetup -d /dev/loop0
sync

--<to here>--

and then check the things trying to mount an appropriate drive (most likely /dev/sdb) from:

qemu-system-x86_64 ... -kernel [kernel] -drive file=[rootfs] -drive file=img-512.ocfs2 ...
qemu-system-x86_64 ... -kernel [kernel] -drive file=[rootfs] -drive file=img-1k.ocfs2 ...
qemu-system-x86_64 ... -kernel [kernel] -drive file=[rootfs] -drive file=img-2k.ocfs2 ...
qemu-system-x86_64 ... -kernel [kernel] -drive file=[rootfs] -drive file=img-4k.ocfs2 ...

Dmitry


