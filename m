Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34B28382
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745294739; cv=none; b=UX9jFig/FQAbXZMTJQ0rHNXnuOJKpEJnYYzvUfJLpFa7CMBNQAUzCgrzsYCK2ovz3YEPJla7Ivl7efTGT81Ncj8OX4HYfSE4wAfbjSmPK96GL24KvTn1qEPx8khow58s1JdyYH+YSSJccNt8bhiApp/DK8jS+4kZwwAN9RC6A3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745294739; c=relaxed/simple;
	bh=As3J5nCFEI5ZPwCc6PlBfFv9oq5d/IVwD9QPOXV7sZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4Q7AjIZZ/y14azroKoDARNaQVdL/RiLVSKBrnuxQTGXA5hcbCBw03mNUa8m9VDSwip0r7YM/55dL+tajSoLGnzrqYlgtkaHum+K4J4wJdEYZD+CYkitF+RRavbSFV/hJUPUse4df6nGabeYyzJPKWje0RJ9jgLZ4G30jPs9RTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XcJ/JkJA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XcJ/JkJA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf861f936so9062475e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Apr 2025 21:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745294735; x=1745899535; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hLWH9XEvb0KTPkNLtiIqP+rJvqNufMuQtjamqkcMLVI=;
        b=XcJ/JkJA1/+cLk8cpBj0Mvek81ay8RxBW8Y7nn8m4LVtJ5ZyjKHXvYqUTGrZkYh6Sj
         rhnHwFSo3fqqpbJ300mQ3jUClDnLObiN2DDHkRFCwc726Jyxe4+pq4E4XwW55vTjqN7e
         Kqg7V3LJyQbiAtjIcYMP0kz1UCwHHjJ6gs2k7Kc3Xmz5BDorGyPcpsXX/GCrfOTFfT5b
         klPZadShmJnl3MvplgSyBIKr0MwN9eFe+zpyykd+tMj1ld6Rs8svc5OhaB6F4O9+5Hzb
         1AyS4YNCC4y9be8r2fHqPt4K5BMQeAN2ae6WUGd+NZT9ybswfYKWDU8XKFUaxKBfiu2u
         +KOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745294735; x=1745899535;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLWH9XEvb0KTPkNLtiIqP+rJvqNufMuQtjamqkcMLVI=;
        b=OUU+89btWtczms5quZvEzO+m1jo6BD3DTVGHJX8xhyvLVgH2v7J2/kC87nO05TqN0p
         N6bumk/cIn3d0Ktu6BC/yJ0MoyZUDPbgQ/LOeS1ebYashJu6MPcemTXdP1jQrWYZKg5O
         SsFcwSMfeLVL1M3jdjTqDswSmXLivYBwrGqupHf8uQ666dKNuy5QEHrIL8Mv+2QxkCjV
         hYAiY5XobWefHIx8K3t4LY1AjfVQafYCVsd/ihUp+q022pXqUvEKYBnqp5SmyWth8dow
         vmK0hf32MoQsEgivRjGyKrKMtbrQZ1Mp5YVzxTazVE1lCRX1vF9gmThhwOxqF58aIWaB
         JkeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQnpVVg7dLdTGdPLvYmYKyugObW9vIq7W23tDDzw3htfyklBWWXQdcEZUt6YXsK91zk0UAoeCsBQHh0w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHM6yfJ8S4jxHD49+nM8cpJXMpQ6zWwu8y/vAw68KP7NlJboE0
	Hx/AxQaLPgJecpS0omW06P5TwH5m+pakubRf4DUSOOCrrce91qgc6E7QbJdS1e8MCarsMjCiUVS
	X
X-Gm-Gg: ASbGncuaXBzmkIRbR4KIbkzWOhuPQjgFOcU5tyGaDj6CQSRt+Tv1fdNgCLapUFA15CX
	VHOdu4VHCJiBEDiwxxQNzQ5OO3hHk8KdMUBDR8A3WK013w0+HfuUv20TTyrIOq8fNph+FcOP+nW
	pVId4LimTaHamvqKULdOrxeeQ2Zc2LYGEFadsaLrQgwcXPn9kivV+EGLmaX3Xdsg50D2x0ACYzw
	iIg5m8Cunae8VxIU4yep4lIZRO3nRrFVU+8KCuqU2xdrjHYmSyXGwLaLZY1mQ1CS2uaK+YClmjJ
	QVzm8n/bZfSdwJQgMgmtE4rzGeEMjzy6THwlDCrsR+sgQF4=
X-Google-Smtp-Source: AGHT+IEoA7pp2nNUf1QVbsDACIi90CSbdKlQPbqzqoWNXBVr6aKfM4uUYfBYdE+zF9BAQBBC79L+9g==
X-Received: by 2002:a5d:6486:0:b0:39c:1258:32d3 with SMTP id ffacd0b85a97d-39efbb0c1a8mr3705104f8f.15.1745294734756;
        Mon, 21 Apr 2025 21:05:34 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bdac20sm74415375ad.2.2025.04.21.21.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 21:05:34 -0700 (PDT)
Message-ID: <608f3834-13fa-42ac-a13f-71d72a34babc@suse.com>
Date: Tue, 22 Apr 2025 12:05:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] ocfs2: Fix deadlocks in quota recovery
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
References: <20250403112908.13750-1-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250403112908.13750-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

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

Sorry for the late comments.
I tested the three patches, and only patch [2/3] has a minor issue. Please check my comment in that patch for details.

- Heming
