Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ABB192B75
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Oct 2026 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438219; cv=none; b=O4LlR6s7mmHsSGUPyescdKlAEGD7XhRqtC8S51nFEg42mHLcLQqJ+aPAp31bZjcZt1VmvvpTN7eM90MDHfS8q75Lb+biAMvsbNPSKCRZTEVBDY1QXdyhc65eGsG+ndq4ApfHOgH8kTthua6AdHom1cY5HNtjTRVGPf21+EATRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438219; c=relaxed/simple;
	bh=RKPQvuzYcnEoA1+2OIfPiThF1mYVZhGB5ePjjPvkH9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=JrbICp/+C/sXU/UpBjLpk5BHEnhlyYfZcWMMRnZOLbgDtf62/btdXAnZhNCXYSda1IY5Vl9p9gL4B9IP3y4P7DaupclMNIBuznpwHwCQF5BkvceGHZzLNo5mE5WHs98ODqOiogV+g8zxHHkRGvtWo+kJGFHlrqVyoSA59lulA7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KZzI2LP8; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KZzI2LP8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791438204; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=RKPQvuzYcnEoA1+2OIfPiThF1mYVZhGB5ePjjPvkH9Y=;
	b=KZzI2LP89ST+L4jZSgyOc9ndU9OeL+mSQ432AlvovWI4vh5ZzFttICSsoyTQk8GT4HdmSW5CWau8yHw8zPYqctchk9jOdW8lrZK3z+W4IXg56nXWPVrexSr5ssny/flOQnxX3EwPx6U2da3t3WnY+I6uSENYpPDNa0/msL26KRg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0XCKsXNv_1791438203;
Received: from 30.221.149.122(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCKsXNv_1791438203 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 13:43:23 +0800
Message-ID: <5ea330b4-6b04-4415-a2c0-287d500c46db@linux.alibaba.com>
Date: Thu, 8 Oct 2026 13:43:23 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ocfs2: lookup fails with ENOENT for filenames containing bytes >=
 0x80 on 6.12 (works on 6.1 and 4.9); readdir and debugfs.ocfs2 show entries
 correctly
To: Anderson Ferneda <anderson.ferneda@braza.com.br>
References: <CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
In-Reply-To: <CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/8/26 4:16 AM, Anderson Ferneda wrote:
> Hi,
> I'm seeing what looks like a regression (or an incompatibility) in ocfs2 lookup on kernel 6.12 for filenames containing non-ASCII bytes. The same volume works fine on older kernels.
> SUMMARY
> On a shared ocfs2 volume, files whose names contain bytes >= 0x80 (Latin-1 encoded names, e.g. "a\xe3o") are listed by readdir but cannot be looked up (stat/open/ls -l return ENOENT) on a node running kernel 6.12. ASCII-only names work normally. The same files are accessed without any problem from nodes running older kernels.
> ENVIRONMENT
> Failing node: Debian 13 (trixie), kernel 6.12.111+deb13-amd64, x86_64, VMware guest, ocfs2-tools 1.8.8-3
> Working nodes: Debian 12 (kernel 6.1.0-38) and Debian 9 (kernel 4.9.0-18), same volume, same cluster
> Cluster stack: o2cb, mounted with "ordered data mode"
> Storage: shared LUN via multipath, device-mapper device
> Volume features (tunefs.ocfs2 -Q "%M %H
> "):
> backup-super strict-journal-super sparse extended-slotmap inline-data xattr indexed-dirs refcount discontig-bg
> The files were created over time by applications running on the older nodes (names are in ISO-8859-1, not UTF-8; the kernel should treat them as opaque bytes).
> SYMPTOMS
> ls in the directory prints one error per affected file:
> ls: cannot access 'Jo'$'\343''o ...': No such file or directory
> and, without -l, lists the names correctly.
> LC_ALL=C stat $'a\xe3o.xls' -> "No such file or directory"
> Names with only ASCII characters in the same directory are fine.
> Locale makes no difference (same result with LANG=en_US.UTF-8, LC_ALL=C and POSIX).
> No related errors in dmesg after the volume is mounted (the only errors were -107 from earlier mount attempts, before the o2cb port was opened in the firewall).
> WHAT I HAVE RULED OUT
> Locale/charset: the failure happens with LC_ALL=C and with raw byte names.
> On-disk data: debugfs.ocfs2 run from the failing node ("ls -l <dir>") shows all entries with correct names and inodes.
> Name integrity: the same files copied via tar from a 6.1 node and extracted on a local filesystem on the 6.12 node work fine.
> Same volume on 6.1 and 4.9 kernels: all names resolve correctly.
> Multipath/block layer: no I/O errors, and readdir returns the correct entries from the same blocks.
> HYPOTHESIS
> Since the volume has indexed-dirs enabled, I suspect the directory index (dx) lookup, e.g. the name hash computation or comparison for bytes >= 0x80, behaves differently on 6.12 than on older kernels, so the index lookup misses entries that the linear readdir finds. I have not looked at the code or bisected this, so this is only a guess.
> QUESTIONS
> Is this a known issue or a known change in dx hash / lookup handling between 6.1 and 6.12?
> Is there something I can run (debugfs.ocfs2 commands, tracing) to confirm whether the index lookup is what fails?
> Is it safe to assume that a 6.12 node must not write to directories containing such names while other nodes run older kernels?
> I can provide more output (debugfs.ocfs2 stat of the directory, dx root info, kernel config) and test patches or other kernel versions if useful.

It seems the root cause is not an ocfs2 change. It is commit
3bc753c06dd0 ("kbuild: treat char as always unsigned"), which added
-funsigned-char to KBUILD_CFLAGS and thereby changed the on-disk dx
name hash ocfs2 computes for any name containing a byte >= 0x80.

Seems we have to support 'signed char' in str2hashbuf() to retain
the previous behavior. I'll send a patch later.

Thanks,
Joseph

