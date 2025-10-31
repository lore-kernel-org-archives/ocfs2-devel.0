Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604BF33BBA6
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761918885; cv=none; b=SwzxN1KRsXgI+X5mDUnpD/rxwzPiY8jGHWd4GC08aLqtEEmVK+5WrpYWsxvghXaAcg/dXaTm6Vp+x4LPXlEDSKl0NnZzhvIBauLc+isKa6dEZ5lCY2iv89nJZcdbrSIv6xuvD7J8m8AI3tHbFDfdAfnOqYEo0Wh6VZaCvYau9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761918885; c=relaxed/simple;
	bh=FN2tQDX/wwLUC2mxidAL9H47bLyAFnJDpvPQlovcMVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndfdivVxiqcUhTP4y6CgXNrb6exTsoBhlvp4NqviMb2VznSBXNO8QbKPnrSQJCX5G9AbBTAKru2zR2PK35fOMFFE0aMY+lr+ag/JvR+7EvWsekAuj7SMbwSdqxpCMTfLDSLmfLFLxeamxlYGk1e+vYExNu46mC82EIj8PZy09/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PHDm6nyP; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PHDm6nyP"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-940d327df21so90715639f.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 06:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761918883; x=1762523683; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AIC+1h53umAhjFDxKUylX2ye8sI922EhJMx+ZKGKkKc=;
        b=PHDm6nyPzKw72psKGfMNCTaYX1YXLyj7hhTaU9kj0RGpuI48jcX67eZ72vjhEQUpg5
         jS3kvv4BwurElnU+r/wMxDdwBbqijSByPcKbb1W3QtXxc3o2KE76VvezFXfbwheNInR4
         esDpM8MDg4Dw2x6JyuVws9EzgR47lJd4fX+0+HvS2zbjX6WlvzbEl0kwSOVLZwHoCHPd
         2YlFvowLGh8UpJtFOlv841vwh7+AvD3yO3wY72RaMDoQPcpQL+HgdIdeuLcZ5s3J+oZ9
         lkxq6OJzI6mV00DqV5tO24tUXDvfSer0sjd2Wv4OSu1LRGG7Qdlfab+yvW49SYqHHv+s
         blWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761918883; x=1762523683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIC+1h53umAhjFDxKUylX2ye8sI922EhJMx+ZKGKkKc=;
        b=QhgDpFBpigIQDbOhnwtMty5CdaXO7COIxZ2jiXe8pZ/F6DU55lMM36JWk/ZmgOF9gI
         84CSAY6I8i4mHD6+G9pVcuLGXjH7OEcvoQw7Db/OvcRqWxFg/G4Au1Cxe6w1Y8DzhgY8
         z32Ey4+nkTNNWV96FSQma7M4gCvQtk6cyTY9tpqe/mktfULIBOZjHHMG880AujcRq+IQ
         y7iMri2ToWOccn7iB0Hx+QRiGIGkitG8s68cyox2ix1Gq1/bZMjD1dEF9qG+dWuY6OBi
         yPVbKUbCtjSfzQ2tmh8No31A6dX4MyU4nsn5xY+Wk1l+b0Swg2dEc97LYa+vSyFarlzb
         KLAg==
X-Forwarded-Encrypted: i=1; AJvYcCWL1NvyIaCAg5eLFa1bXhbhIVXFXpakJ+xFLpwuuzCAEhdEnuUq5jaM0wlqme264dqs3vAF+HkfVBRKCg==@lists.linux.dev
X-Gm-Message-State: AOJu0YynZbeV/wd0ws2Gz+WX+cm8qX8CuGBWUm5vRvI/gEUSfrvXCVX4
	UoQsbgDtdpminR2yG5yuruubJcyjfbWuNb2SUEv4Zk/7EeQU8GrBCXcY
X-Gm-Gg: ASbGnctVRxNNRV5uSOWowsO2N2I7EwUB0Kq4PFtUvKwzdeDcB+rhFacHVnqs3MqE+H2
	vqwWDJ77D6XCMZY0AG2Id8sk4vzOEfSQMbnfR7fHYe1xGwuwTI+BG5U1GVM6JskCIUIL1Q2ZhTX
	fN5+OQ9qACdQO+hjPWmgpPwovPsLPFV/79/zs81Uv4XFmbhQ4sLyXNL/rczjpAroegAvSwKE6G+
	tv2Bmk4Snim2GodpstS72Hmlc29nARaqOfFyfX3gg07hObf48xN084nyUlsm+6CTFvEFBwMdsij
	NaLDJGQ8mVmdxWREPnS6CdjY5OaXEwkAvNftW0wUJHfvnfLSJd9PmuMoj4uWHG5NvOPLDaqAUnx
	0dctgARZp9EJsl1HZJtq5zWsS7qsuHaDfAhvs4hC8voB/qK3ctjr98gOvXI2ml6XYEVum8as=
X-Google-Smtp-Source: AGHT+IHCzKlOoNPt0LzvrQC5mz1ulgeoDbMFZSeqzUEOGflwrunfIy79QuN9s2TzFHch5oRbAD1Y3A==
X-Received: by 2002:a92:cd8c:0:b0:432:fd5c:df03 with SMTP id e9e14a558f8ab-4330d1eb232mr49401325ab.24.1761918883467;
        Fri, 31 Oct 2025 06:54:43 -0700 (PDT)
Received: from arch-box ([2607:fea8:54de:2200::c98d])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b6a34b63dfsm721718173.16.2025.10.31.06.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 06:54:43 -0700 (PDT)
Date: Fri, 31 Oct 2025 09:54:41 -0400
From: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com,
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <aQS_oUDXGt_nF__d@arch-box>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
 <aQQ0DLqL0iVN7D15@arch-box>
 <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>

Hi Heming,

> I support adding make_bad_inode() in ocfs2_read_inode_block_full().
> ocfs2_read_locked_inode() calls ocfs2_read_inode_block[_full] to read the inode
> from disk. However, ocfs2_read_inode_block[_full] have many callers, and in
> current code, only ocfs2_read_locked_inode() marks the inode as bad. All others
> forget to set the bad_inode.
> 
> The 'forbid' write operations when read-only mode is worth another patch, and
> I plan to create this patch. This patch adds a similar ext4_emergency_state()
> function for ocfs2.

We're working on this as part of the Linux Kernel Mentorship Program, and we'd
love to take on implementing the read-only check if it's not overly
complicated. We're just beginners, but we thought it would be a great learning
experience to work on this following the ext4 pattern you mentioned - if you
haven't already started working on it by the time you see this reply.

> Therefore, your original patch looks good to me. I will provide my Reivewed-by
> for it.

Thank you so much for your review and the Reviewed-by tag

Cheers,
	Albin
