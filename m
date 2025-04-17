Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0166187553
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Apr 2025 04:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744862637; cv=none; b=cF52i/z/PVzQKeqUR2hlAJGeBHFZPiHoz/n30p/UsGrtHDU5wFfR3ui6wj8IPu/VtK6232ebFGztVma+1PI8x/ZCiCUVTgKORiByIDImX3ccBICUplq66gqk1C3VRYX6fgfJTekj7BE0s07jLRrT5+w1jCssaR+D643O3eewJDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744862637; c=relaxed/simple;
	bh=cFYmkmGsKJNq1fkV3vfj912JTE93U02zLkiX+nJL3xM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/cWrLHrR76SiU+Sk/wUOvmUwSx3/Mnenf9InjeU0x6asEn0N1XGUZSb9CSILza5cmKPeHDMFhpynLaqlbpmFm/lvDkfebPTeIHVAp9xSigVp7EvGfcicXbC6MJt5yjxpoNFqMNLSixW3BfaMuWdYUy7bIY7utidT6hOgAijx3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dNGNSeCu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dNGNSeCu"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43eeb4e09b5so555465e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Apr 2025 21:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744862633; x=1745467433; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7KuPj20ipm9eqNUt7W5lhYtAlVF1K9kw6ltcUM3R1I=;
        b=dNGNSeCulxYBGm1NOnl0BoN1p93a2n9pN45Y4ER1TVF2aeN8bG08z34xjsDQ6XXXZL
         oKZX0Fj/hDwYd0qMvcNUWkIimaaEV5fV2rEKB0+2vgu7XZWnaYlc6G2Axwhx7wYP2iv5
         zZgdgjBT9SMhAiGMFpDgmTZzwpVjCStSHZwMvC5G5KVNRdErbJIhhyUx9k2iYgMFgExc
         M1PXsbRDTMJpk7mjvxCP5qNr8Gg5Z+xQc9e+WSLH8n2334rj32ub6Ibkrza0FNntGlrc
         Jk1rZuZYn7QL0lst6Nz8aoWXjqAV8Mqu3ATxqXQyw8rwMegXA54R46ehKzUgwZu1LrgB
         Fzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744862633; x=1745467433;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7KuPj20ipm9eqNUt7W5lhYtAlVF1K9kw6ltcUM3R1I=;
        b=T9qcQ57MO8DbDjGpqQ3bjlq1WVjkrUPiKJ7ju6f7UpHmrr0+2xn1iJXnWp1RqP5CBP
         W/WEY7Yh8OaaKgesxH6PHXO5E594h+Eud1DvpNi6y0JW4NEqPvAn0p1cfGSrIk0SVCgC
         YJobL3Mqy+/HlTWwFlyKTwNGJbF7Vm4a4hCqSFznfDcfTo9CTwhLXb55xgGE+r3GLjlt
         tABHK2Gg9F1/i9M0PEKz8jsx9xCPQjqzOXxEndNKUiGBsswzNiwaGiah1Yvu665/CkGm
         IY9Tgmx01VTOoB3ZxardMKgINxHlpdL4P90VIBTorbc9CdUqUMtdX1XdRCFQmC/biwqh
         nQEg==
X-Forwarded-Encrypted: i=1; AJvYcCUUu7qEFjhLuvi3LuEGFqUaW43ooWVgS939qGYkHvTA3e48e+IzyFZLII2QHeNCm23qR6G1mDJzg409KQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxpX9sT2Ne+b27SwsAK1mWe4m0DdmQRtXHmAOKaudjtoKIPgygI
	ysarbORu4Jq64mkH5sg8bxPv+ISn+YOrRdBkA8izqY4jxXLAV3+pANLNnXkebLM=
X-Gm-Gg: ASbGncu09Rpff6sNcEJWCJnDq/Emx2BBJELnde9vqmH4GU6WIcIvqwXC32XhOqFir0u
	OLO60pgOIqkMpfGY/MfrJxteHKkL4wNZlZouuUcPx6qzvkuKCOmMyByHXg0w4/O4Xj+NiJCVM6z
	VGST2oXnYnTk0VUbkWDRDHwgAw4Wu36BRAYede7yIqdEl1L5/+qvL7LF5OJe4ovuVBFLvCacvFF
	/u6zuOijpgTYasPM4u4C9mn5WQ2EwwbEom9cpQEtfOq9JmL88wvlvcsto9hXlXucCkz2j2DIrG2
	LG+d3hxUht1oOX+fTkGUf/pqsxTex+Xzx2QJwc0uVu2AE/0=
X-Google-Smtp-Source: AGHT+IEP02h+5rE2YoY6sc8apWqQofgtYhqoySVQ8thqsCMPIraS40t765lMjwc+rYWk/RwhHJ94Eg==
X-Received: by 2002:a05:6000:4202:b0:39c:13fa:3e0 with SMTP id ffacd0b85a97d-39ee8fabd25mr473297f8f.9.1744862633002;
        Wed, 16 Apr 2025 21:03:53 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-308611f3f54sm2522269a91.13.2025.04.16.21.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 21:03:52 -0700 (PDT)
Message-ID: <89d94f84-8e88-4860-aaf7-102a51c11537@suse.com>
Date: Thu, 17 Apr 2025 12:03:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] ocfs2: Fix deadlocks in quota recovery
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
References: <20250403112908.13750-1-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250403112908.13750-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I created a branch for these 3 patch files. Let's ask syzbot to test them.

syzbot page: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f

#syz test: https://github.com/zhaohem/linux jans_ocfs2

On 4/3/25 19:32, Jan Kara wrote:
> Hello,
> 
> this implements another approach to fixing quota recovery deadlocks. We avoid
> grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
> stop quota recovery early in ocfs2_dismount_volume(). Please review and test,
> the series has been only lightly tested in local mode as I don't have
> proper OCFS2 test setup.
> 
> 								Honza
> 

