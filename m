Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6231FBC8C
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331643; cv=none; b=OYWxnk/Vy3r3K8Sp73K/CqOvZAAjjQg2AYeI8LAAm5mNKe3rZlCNh1wWCNh2VrWpPSTWFh8BLmWtMOPEwsanJ5yi1au+IsoIuRL9wcbvQz/omoF5CAcoV8q2Ym0M7NcAIOxtondNPRrJKOv/F05tFWoR8Kod6O9EwSxavKQcQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331643; c=relaxed/simple;
	bh=mbobndWLdH175gyo5HAxh8xrj9w260lPq9E4uMPKsb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Frx1d4g3/IkmoBzW1yb3qd7IHClIzHtnE3aQWXHZr1b5CdBHW4LjMUgPoTHdBGSpmaVG5NgGl1KkExatX4/lZXq8aqrP3Y/qQmybZb2pYavDVOYmz2BUO8g2YT8cCQlHAU/bdE88cM6darecpjKuYajqu+0h0/F3BYcvxeWv6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LTkoYSF5; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LTkoYSF5"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47797676c62so8331465e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 17:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765331639; x=1765936439; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VRie6qifJusADsCTyMYhZ4FPQ/4zynZODZnNaocTPyQ=;
        b=LTkoYSF5D9RCsAkV8YV3kFKeZnH2571FLyKKfNcwZqOh5ocmw8Ha55eISnH0SuhXmI
         MBXs29eL8A96dTReRBdZ3+Rg4/ZdV697TnTsX2xv4/5d+YzihWQ9HRVlgR5nGY3LaZTY
         Y0dRML3pceCh1n8gI2HzOTaIm0Yu32gx+fRn1sF4Qu4tIbo+1vq1KHtwynICkjlBGr9x
         wFz/AA2HMRGC07bJbS/ZcS3eC6/rvSoQblJa3JTD74VA6WIEIJY7jChcyZB0ogHWM93a
         DscmN//5VgnlLl/BcBOwJuf1cqEJrir/MXAQavel+Ep99zdkMDBXao217n1NolN/hce9
         YgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331639; x=1765936439;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VRie6qifJusADsCTyMYhZ4FPQ/4zynZODZnNaocTPyQ=;
        b=QfpBmE4PLvcZqgRIvOWWADCGJZG8NWL9r7Jx7uwkysTpcs0NpSNF/FWIrGWoANZtWU
         PM28c0m9CPx8JoDtjhyPvwbmJU/ttebXyAKbOTJzkEx8s8AzSfiqFoNQBcR8cCIsDVDD
         IdeUomfijx709+BWD76KAXwfo0a+W3YPJzrF6jfHqlzUrowUjIqQKRZ33ok/okEzzlwJ
         Ek51l/nrAHADlnCzz1lcDAuKKyQNpeSN8Uq9l5uIeSZzI3bjF5QuDiCwInEAYBiTKx6A
         Pnu0LTGY/vThoQclTZsBBVAtiteibEZFPAUEg/ttRau6vZPa4Lcf9lz73v4QgMSdhdpk
         afFg==
X-Gm-Message-State: AOJu0YxtPqyAK0K3PUOnjNmrrR9pZFXMrVfrbP0EyAvP01MkPsGL1Kr3
	egvHW4yG53rfaVcyzA5UPxtga6jfWNbO2li3mJOJS22YSxztlL4iaQGayenWHvduwyY=
X-Gm-Gg: ASbGnct9civVBrzQoBxkE6JuwS4IwiR0Nh4eeQ9jKpvpAZGhEZuNLF01Id45RoaYqju
	GovX7sG/w2MTJZ2Bkp4piYt4pwz9d+tZESmzrbWfer4zgD8fcFfa+jOb/ZhofG5uSRRMsdu7lY+
	WcdZCwGH7xKZ4kI+C/F7S1qKIbLHPYwgc1tMhzRtvXr/dvnu/RmwoXB6MRVRE8UvwS8JdHjvvPr
	jgG1FSA+sjpLrmplL9GN7d6RC3a6HwEvEqy0QI8znRDoOm0i2bV9tZDM6MJEn/MdB5G00yyzgIO
	SMd2qznHDIQjAGt5r84zxjq3TE2W8d2Xrv0U+gCngnOAp4WFBZimE1GS/15GFpepJf4ZLOFC9dA
	/H8TFkeLzYGQuZPtRCXBL1AGkM+kM2D1RtHxm4Vsc6DgZfNAo+egH+e3+lIBiB2Xlhsrb8FU6/X
	CRuDzxAE9ixSSevoz+Tw==
X-Google-Smtp-Source: AGHT+IELv4YJgV3w8Da8H1yWimfcFbyrN5FIGR9vxKTaLiQ40PTEvlZHFVkEoRX9UTG5H6sSR/Z+1Q==
X-Received: by 2002:a05:600c:310c:b0:477:9c9e:ec7e with SMTP id 5b1f17b1804b1-47a8380c6a8mr4362575e9.6.1765331639321;
        Tue, 09 Dec 2025 17:53:59 -0800 (PST)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaac07csm164532215ad.86.2025.12.09.17.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 17:53:58 -0800 (PST)
Message-ID: <538b2cea-3d8d-4f51-b9b0-4ff2132826c5@suse.com>
Date: Wed, 10 Dec 2025 09:53:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/1] ocfs2: fix reflink preserve cleanup issue
To: joseph.qi@linux.alibaba.com, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251210015058.8327-1-heming.zhao@suse.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251210015058.8327-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

sorry, the ocfs2-test cases are incorrect, I will resend this patch.

- Heming

On 12/10/25 09:50, Heming Zhao wrote:
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
> single_run-WIP.sh -f 1 -k /usr/local/ocfs2-test/tmp/linux-2.6.39.tar.gz -l /usr/local/ocfs2-test/log -m /mnt/ocfs2 -d /dev/vde -b 4096 -c 32768 -s pcmk -n hacluster -t reflink
> 
> xattr-single-run.sh -o /home/ocfs2test/results/ -d /dev/vdb -b 1K -s pcmk -n hacluster -C 4K /mnt/ocfs2
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
>    ocfs2: fix reflink preserve cleanup issue
> 
>   fs/ocfs2/xattr.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

