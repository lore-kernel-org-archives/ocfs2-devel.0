Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082461;
	b=Ml+VBCErnrxxA1WAz7UI9c9so4vRKCFvs6lOBC5s0T3rnTqiOmz4QU1YSCPmMyvJOlG+
	 jggHw4ghVzlCbZ+AMdUtGl0Yj+9ILF1dXzRt/2Un+iAZBpexOxwdfOUJh4LjVp0O1QL/H
	 QTmkMvP51rhJM6IR+nqfAh57TjRqOBXfx0jEt+SC6YKGk3nRQFH8A8/RqKawxbnSd944k
	 BoCQ03nflK9Pb6Z4v6QsYdwZ/58sAQPMm66xs5n/qi+PoS6p06h5jxE/YycljeD6RAzJa
	 VL/aRFMAU5aoP0GCTWBVUkDuFAA3lu9RJkE6FjE50aLsvxbGOwti8wt+uAf8I3LTPOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
	b=ZQUwS+TnZ//lu8vHF+FiUqjmtP1qfO0I99W1RgySesnlYFldN4/OUdagJ60YwjSMmIrW
	 uV+UUNbhfhKYUqiKfWe1cn+UkK9/mdPHZaN31Pd+Cl+5fmCLWyrmZF7tGYWv/0rIgxGK2
	 i3mY8EEY+UF/vy8gS/792M/nTncwDBKBVGlJLEb0ycIciyrIer71W6L7S8s6513+tmE5g
	 EtZUDZkQJ51vtf+iLvdN8EgU7gmbRWNe3tXIcV6kcfIinHls4qGTQsVE1RG62z8BjsNqG
	 +BqhP2+mRHnScrVjp4XBaMKVUDYGdkTQIir2FHncDZ2giPu/q3XMceVFw64CLrW07Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f1ViIEs2;
	arc=none smtp.remote-ip=209.85.208.182
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4E60A2607
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 10:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33F4E60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f1ViIEs2
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3acc7a0b558so18867371fa.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 02:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795082459; x=1795687259; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=f1ViIEs25I9TwKr+t3a8lhoeElJAQlBm92pui+G2lfAj0Q0r4jdnce9VWn0RVBP3iy
         UzTG0ZXeagBR5zP7XImjITWuNlmHgehhTJ9aYoQl87PUHr8zvkjV8dxyA5hCdffoqwXX
         5fEPp9J6OEpoJtTM/1C/ZCnQDBEtasNDCXR3eH0O3gVCpvjjDdwHnivH1c3sG3PmeNyR
         6tmh61rL/hva/CBy0xBiKO18jdwdLTJn5vNbn/k0nVHJQTA9vzCAVWfC3jj77Z73J/h6
         MvXgftYsvOZvwCWNTxKehCvIFWZU3GSZJUKI28XUbsEBEBIKduYAp7oviWVyOAJoRAEC
         HJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795082459; x=1795687259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=SWclvdBTQpiikrRcA0IarcjlMKjYwhWKRrl8nTYFN6NT5ANKUa/cmLhgOkqGGwsFOZ
         JUjcZIYGffYJi2yH7/i5NrKYf+K3ZJ288nwbP8nYK/nHhcT3bZM9BVE+vAquAGMTHrEs
         Xr38C1Tfx8X0B9KXjyi0UknerMa+1+YDkKhpS6Pu5028VSaG8vRG1+rI79GVifLbsMCQ
         1CEvw9/Q0kmEjnhz/1UtWVcDV35lmrFLvSrBwxIy3oy1ZgdJTvJACQgRtCJQW/eXPZQS
         30e0VrCzQMRI7Ka9/8VvpVEk87ojVzTXapZp6XRi07l7hhHzqg0QDeCpuN1aNfPPlYgz
         oCYw==
X-Forwarded-Encrypted: i=1; AL+hErHxg/ZICdrF/ppfgpVlGA0yFB1KBRyiyH2afQU+aVC6dUuo6hjGlSWcp5KWukiD2aFQsk4B3bf8+Yy4UQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+kdPI3YyztkCDUTvUF/xazTZDyWHb+HjlMse+m7PG3p0Raj3jv
	qYhOLse6z6YKLOIg/urGdhjXJXZmmUPvVrBaldLn5h60YdTzoUaCLCGB
X-Gm-Gg: AYBFou1BBqwlvGS0cD0WvYjd3SX9wSje1zGA1eYY4x8Zw1q8eqQj3YqZvtBXIMoh2Hm
	xF9mtLYobvXyAjBSauvvAObPe5TQE6olJiGHyX2eRyM8hti+/bOa7LqNssfJVT1eEoMgIgXpNCg
	XJ5Q98UX6AE+Gq9CGCzWhQIQL3MDl2MOCWWE00XTVSV6QrgN9/+pIpeH5uKeXQV+e47sSq1iiPh
	oVYtphVOKu+KFhO3NAQZPrX/ESYGPINnZKDY+jHmThXxymJko0eef7XnKJ3AuBljaZnf0/VHLSN
	ndDu+sIA2kTkA9redQdlWgACXZEuASyf+u8JO+5bh6Bhr7Uvcz/WasHCmwlc0vvojdrAZYMg7fy
	B40BRRuNbKr4W5MEDO1xRRdC+kJjuOq3KlOD/lNXqI6+gxbq40sIjmRigZM+66ZaaAAe6JPRKwZ
	ZpBz6RxHvREuWokqaYpdY+ybDNancFM1xcqaGF9vaXEpafcvBDB+w3ZgHj/SR6vzkWt6YhmkPTQ
	KEiZVwP3o2bHExFNixMlrB/oh3wFPVGwNaT5z25Olcv5btWd6eCukr91b4/xRnR1cmYbNa5F560
	M5HGtEUvQU43Uvyvw3fzjhkvjErtbQRkilkgUg2zN31s6eISFLA0zgX4QFCnUkeMA9naulmulug
	+6wh2M70K+g5AFOCVwJ1sNJFMNBPmEU2bBbxiseE8gvduLWthtBxbOQYlpPs=
X-Received: by 2002:a05:651c:1987:b0:3ac:7ad6:2003 with SMTP id 38308e7fff4ca-3ae670dda79mr17356091fa.6.1795082459145;
        Thu, 19 Nov 2026 02:00:59 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeervp7z67jbft6-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:352b:8deb:4901:b3ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ea7c798sm8419451fa.11.2026.11.19.02.00.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:00:57 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 11:59:43 +0200
Message-ID: <20261119095943.85048-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <av4Hn9u80fs8iHZ6@dread>
References: <av4Hn9u80fs8iHZ6@dread>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> I really don't care if it is exposed by statx or file_attr; checking
> the flag through either interface will be orders of magnitude faster
> than using FIEMAP to iterate extents on every file to find shared
> extents. My concern with statx is coherency - it runs completely
> unlocked and so can race with operations that add/remove the reflink
> flag...

Thanks, Dave and Christian. Given Christian's preference and the
coherency point, I'll write the RFC against file_attr, once the
question at the end is settled. xfs_fileattr_get() already reads the
flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
work. The answer can still go stale right after the call, as with any
stat result: a clone that lands after the read is missed, just as one
that lands after FIEMAP returns is missed today.

As I suggested on the 6th, the flag would take the inverted meaning,
so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
("no extents shared with another file"), read-only, in
FS_XFLAG_RDONLY_MASK next to the case-folding flags. XFS would set it
when XFS_DIFLAG2_REFLINK is clear, and ocfs2 when
OCFS2_HAS_REFCOUNT_FL is clear. btrfs keeps no per-inode record and
would leave it unset, as would nfs and cifs, so their files read as
"may share" and a du tool falls back to FIEMAP there, as it does
today.

overlayfs needs care: ovl_fileattr_get() reads the upper inode, which
for a metacopy file has no data extents. The overlayfs patch would
take the flag from the lower data inode, and leave it unset ("may
share") while that inode is not yet known (the lazy lookup on
data-only lower layers).

Christian, one question on the shape within file_attr: would you take
the inverted flag, or would you rather keep a plain "may share" flag
and add a mask to struct file_attr that says which xflags the
filesystem reports?
