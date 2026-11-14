Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686757;
	b=BerQeXV397D/Cuib5WtW+9Hcs7DllxZkupvBI7fvVBXUDoq+NRrf7d5zVqS6Bmidiiaf
	 Lyji3TE85a7wkTVDglH4zsPCkVEojvGdXHx9WQPRAlqNZfREGqrzdtfYUKLZYEBGG+9yR
	 /7R55pDp1oUuoSgDfEm3UMSmMh1+j9/B9UDaHy1ZleXdD1r35Dh7z049A5Z2j3w6T+oll
	 ZcqWhjMNHe4fdH5zZctL/ew/nona0OEXEjPeLOaOFh+4ZoNFfyNKrKKly9vSd8tS2h2wb
	 LuEBitwIV2Acn0il0cWt/vsod7cvYyMxNfTUkK1fJLc6K9qk6TYxsrq7PhmfZ1wOqAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	b=s2msq0R1rFJR5lHMTmAV/9PKxVJ1phOWQMTzkhEargwU0uKXdBrhEycA2+tk2ax6M15y
	 d7p49ifn/YuBvbFK0ZzOQwmBkEEQhYgQ+hEEJOQXym8f2JJj3noLY0nCyBB4NsW+tUco3
	 tRI0K5HpwbDWCQe5WEp/XgrJPYr+piGJMO+WuMlXYHosxOY3aQYgstDo3bfKxDEwPpFZz
	 32iJJ1446lYndVCxDywYxIPaI9s9u990nSNmGX+/vtuvYeFtS6D5TYu2sVNzxzJflIpn5
	 k1nibiY4B3h97p+MTswgCtyvzOavVkJXjP3ZfLSvoU5UaVwAE2vE8fgPAqo+yEeDRUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=PzooN50t;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4484606A334
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 20:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4484606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=PzooN50t
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so1463748b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 12:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=lists.linux.dev;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=PzooN50tk6Jvo1qz/TShfwPqaa4BsD8Gg+GfDc5bzng12G37IHsCyHW+pKP6tifk2b
         oNjoJBEHbYzEmeMNWndVLiCwfsU4HSoJbv52m1N+6sbHWEHQjOS48HDR4XQmwrbDuJvf
         BAxSOEtWBW5hNocnz6dgI+fhoEkWkh91+mn7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=oLfrK8Nk4nDULj6Oj9nDi2YifliC2z2vPaechZCVjdtbmBS9NBoHWDTb/IJwiPbXS2
         EKLRfWRecEFMjFbsoXIrG1v1EO/2QGu5NfL3N1VM2zGjs8pAcYQ61UpZBNIrKDOgdp0j
         GVl6TbHQWl/Yx3bxSUzS/pJ9fENtSeq9qMW9BYIIjdRACWvlSHydNsip3sfY1RjQ156o
         WsV5C8/vBy8pCQDX2fwkTU0jWwhnJlN6fFyWOnM49qkuwbde/XaTg2e0jmhTFTL687Z+
         V5xFDv2njBNO+1zAiCcNvUTuQW00q0UXz3LBG4TE4NC7woT8BAB/PP4ixZHXYnM8KOMN
         lvpA==
X-Forwarded-Encrypted: i=1; AL+hErHExSYys0fX/8mTUfN2jIjj+4gay7Hl1BIq/SaascoP8qBsSrWAAqQF94oV32PbJvSdfhDfLpW5L67dFw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+P3ZRZyImfSsVEVAm61iOlJXu910SgYHJ2JQapaPR8+rXPsKtK
	xLjK+NojG4aEQ5qXG9Nlj/UPugojcq88ms1o/BKlcqcGpV5Ihw6by76gco8+65oPvGs=
X-Gm-Gg: AYBFou2ok2dufWKjhxJ/6dDB5Bctk7BkLmTfZn8S/9WFi+V9zujp0ZI8xqZW3G3u4ac
	bXS8eb39bca/sCUCHLChwr4WCjSG2dFC8n0FdcaJgPwpYlv8CzMf4Gx6FnaN1xwA94v22mEroAI
	GFp8xgcnTzjdobyucWOd3SPK2SIAuU9m88nMT9X2HcZ4bLZtgce9RP7eI7Zz6xm/cZHVN24b8Wj
	bZmUwmCiDmSXpowhlFBz6ed40b5pee9Y3+pr1sLbk7RU46goTslOX9agCyUVP5od6Lu1FstGOrA
	uosycvokvOkpDPzLwJLX3MPHvw8VcdDniDptNTyihElINuRwPEwWLl62xdp8N/w7euwisnr21cb
	GjnFx7FwoCPIvp3r9p9FIUZsEtYzJP77rW6o3pEeWDNbVup0joiXM9WeQ0xAtuk6n0TbwbNFVOy
	g2J7W/pIxcbJa5eZNeSb08cKncPgewQdYrc+8ckhoZs4lsrk4fpP5AUrYQ2Rzo9jNpXcJ/VmMm6
	RC33rLTV8zttTqhTVVuSMOIAHmbWqG/SpzQV0LFKFy/rm1i2iDgu00iQzBiFMeIT5u+8h/8aJig
	2E4TZCFmUhQQEIxszrwAx4mpuOmhFWzdRSW9L2c2dnI6Xe4pLex03cbhASCyN/CSvvc1dSfTukq
	TNAh50/KwCglZJc1CbAwCG9L1pKVabtlc318N4TjfCgPLX14xmcPakgizmIXncP6G2vmATu9T0k
	NQR1sSjBLCWit7uTDQEgSJ6LumvVtL0wHkfJ0c/rtKh9QnntLzXzTR5+vu
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris
