Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9855214A64
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 07:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761894251; cv=none; b=ejtk1EOfzQgbqGdNfh79BmVL6Iq3TdB/6CEL1+TgmcUvUfUG7/KtFDPLT5ecbHTFpAjYP4NZVBvG/IpPlDrkCLla5H1gOrtqZiHzBGJ1mGIn3OjGepp1Vq+F25fiJXLpC7m8b+WrVE3JDlOX5FdlHudtq52ITPEublfR0OCpohU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761894251; c=relaxed/simple;
	bh=oLMCmmEia+w9/vo2VNryqUYejtfLk5Br1N13I2cnmTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqrJQsxBVe35O4yi/bf5XDOdt1rhrdAGQH0A/8+6JuCmd0KePGG4OtQHcsZ/XGgwu0CTYGs/trbcJV4qLzBai7d6zKTg8YPRKTc+uKGF1V7V7a9ZrM2mnvGE7IX9IY7MdykpQQr0L0Uf2wxnUU2IISnrK+R+M5RtPgybaMOiyyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EPHXKbsE; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EPHXKbsE"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3f4319b8c03so207004f8f.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 31 Oct 2025 00:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761894248; x=1762499048; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xiWigIdfjh8lgJ3SEN1A7uaDplKEo1jveY+w8/D092o=;
        b=EPHXKbsEpleMkSRre0G4ZsWOb29etTI2HutBMi5Dd43YJ9Yi8EothEp++Tb+LxUMWC
         PDKcHsRKMFRedv/BUgXq7FfFjfu72rNwRC9eqwkJf4QTfI52nFtQEBZLJt08UQQV0The
         EQSrH39+kgTwofne8uoyf3cTRngy+fnrjd0imBMTNZsS5fT0g3seCuF+RcmT0nRqzqLl
         VnKsmu3DraBe6aQkHfDcJ6GOK8rWbr2QMoR0K+EUAnoNK7xKViUTD/KsxQJNIoX8WEck
         FSLtS+YlAnCokO9XgDlMe1zesuJ0xhxqul4NhwRFv+51wS3wo/Sq7vhYNUzacYkeioo0
         d46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761894248; x=1762499048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xiWigIdfjh8lgJ3SEN1A7uaDplKEo1jveY+w8/D092o=;
        b=wkoBYp8lx5KDOfcpsWjO/SCSW/Kaxw86c4abaZeXde7SVPmnNROw0ZOqqTwuw1B/um
         yD/L9OrOFTjUHuB6fyggh03zBSYt5sJ0hLAi6oCKhGoGDxbQDDJKGc96KSZwMNGdZBON
         tSAEToGMGgdB2khwgp03RQIp3LybBtb6jrOk9e2Ue0H5SnpWtqGNJx2r4W0/opnEbtqm
         oF+13vQ7vXY3uZkvQHYwtjceQ7p83LH2c8G9Sve46AZv0h/Yf3djWB+6C9W1nybEc+nd
         EEXaY/HgRCmvsp5FO512j2tCbEfGoxqfTvSAkB1FslceCEg4M0CpWjJVg/VqvbxeKZ/Q
         ApYw==
X-Forwarded-Encrypted: i=1; AJvYcCWs5FpJNg/kpIdnvBU4rXq72SUSWFuJWxB/rg/gvh5JFWshuSLIbKb6HkWEiRISViGEAKdz+lW7jpmTNA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxxXxRe2drHZw/jJw2YHg+OejizncVhwZpcf2QuHoz887+KoCUa
	d2PuH98Kt6bET+1trdkpG27smKCP0B58gUqqEL84a/yZYzH5u6B5CyqgF6f5uUiEg4w=
X-Gm-Gg: ASbGncv4Ji0qOHzCZvdi1/DrC23RZNZYzfP3FLlA8bgLFAbp7L/29qAwrtNBZPV2b6j
	yBSv3ra43Znr6t2XiB80A0WmsfomvKuSxWVWH7aqv5Clqfpg3zj9IZNp2Jv7au9HRTil3OwRvcL
	cED5SbBazqOvCe8awlNm2uudpEJK7twju3INnq3yMYAlvgeSDSniTszm35q3STYBaoGZkpl5rzq
	SEKIMxWzqAWR42pd9+0GUrNzqUPDRXeNw6+QvlbXbEmIVJVWWXU6G8Q9XgGAX4/CeWULHem8a8R
	erKESoA2F85prJMjR33vixYO6CWdjS9LU7umECnmoGVSwOkQWe9sNXEEDSL9UzzufMxfJohE4a+
	CEKfgstejdNW9FxGaWiPtKp+P5H5yRd6NDlnST2hFkrML+/lSO7INqyzh5oy40aEJUwKrSjhU5u
	Q=
X-Google-Smtp-Source: AGHT+IEeqUFVKJ1hFaxe7zqKDUJhcpRVzgWqw6m6PPHOQHTGejVbMJJPn4hu++UXlkkSqK9yP1ks2Q==
X-Received: by 2002:adf:fa85:0:b0:429:bde0:1da8 with SMTP id ffacd0b85a97d-429bde01e0amr624513f8f.7.1761894247949;
        Fri, 31 Oct 2025 00:04:07 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db0a07cfsm1036897b3a.39.2025.10.31.00.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 00:04:07 -0700 (PDT)
Date: Fri, 31 Oct 2025 15:04:04 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Cc: Ahmet Eray Karadag <eraykrdg1@gmail.com>, mark@fasheh.com, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, skhan@linuxfoundation.org, 
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
Message-ID: <leys5guzkcvlilaccjmsw7cvncm6o2vqo2wwezhuz7r6lcfjnk@va3cnphl4zf3>
References: <20251029225748.11361-2-eraykrdg1@gmail.com>
 <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
 <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
 <qfizhbe5rwzddwnoekr6xjy3gozbqbtl64c5xmfeuudxvficmv@onazesxv4ur6>
 <aQQ0DLqL0iVN7D15@arch-box>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQQ0DLqL0iVN7D15@arch-box>

On Thu, Oct 30, 2025 at 11:59:08PM -0400, Albin Babu Varghese wrote:
> Hi Heming, Thanks for the feedback.
> 
> > > I had one question about your proposal to combine this patch with
> > > Albin's [1]. When you mentioned, "We should forbid any write
> > > operations," were you referring to Albin's read-only check in
> > > ocfs2_setattr as the mechanism to "forbid" the operation? Or
> > > were you suggesting we should use the inode size sanity check
> > > itself (e.g., by converting the BUG_ON to an -EIO return)
> > > as that mechanism?
> > > 
> > 
> > The 'forbid' refers to the read-only check in ocfs2_setattr.
> > We can refer to ext4_setattr(), which calls ext4_emergency_state()
> > to forbid write operations.
> 
> I just looked at the ext4 implementation you mentioned. When we were working on
> it, I actually referenced how XFS's setattr was handling this because I
> couldn't find the exact ext4 implementation for this at the time, so I wasn't
> sure. From what I understand now, ext4 is doing something similar too.
> 
> If everything looks good, we can combine these two patches and send them as a
> patch series.
> 
> Best,
> 	Albin

I support adding make_bad_inode() in ocfs2_read_inode_block_full().
ocfs2_read_locked_inode() calls ocfs2_read_inode_block[_full] to read the inode
from disk. However, ocfs2_read_inode_block[_full] have many callers, and in
current code, only ocfs2_read_locked_inode() marks the inode as bad. All others
forget to set the bad_inode.

The 'forbid' write operations when read-only mode is worth another patch, and
I plan to create this patch. This patch adds a similar ext4_emergency_state()
function for ocfs2.
Therefore, your original patch looks good to me. I will provide my Reivewed-by
for it.

Thanks,
Heming
