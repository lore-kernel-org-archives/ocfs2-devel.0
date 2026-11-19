Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102357;
	b=P4Y0TA1/YRmIronfgexwaCV3hHSBtmf+sUhNeXqY9jCUI2ZDVwRfNUFYJOlZrzDgD9tD
	 tiJo0BocoGKWE3nWxayL9E+nlKKpMF3Z9Iw0A097kj654ZrTBiY1+QglakdVqI90VY9+x
	 fPfhvo6lheEzVkAUzquBvGBwvsW0HnMAQKNFR4SrNXrIv2ixmrLsfRBB/NdVFXMwbp9lz
	 Uof9YNnq+COSIb2toFWZmWJeDINKA1VIYLhnvD+/+nMXhbXgGsb0vhJ4wNMBvZJH+3WLx
	 dz1uqTnx8WQefnv1KH01UPVoy1zySYn4ZcTcYis/2TnORIj2z5VVhwxeQDuzDh8ntzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
	b=JoHK2NPnzXE0WiKzD0W1RE3A1pXfWEMXfmDVA3LbmIX1SMHN9PbSCyu9ehavQPTKLp6g
	 8eVQDGNlttZRkXGratWDHG9nN9V8lsX+MUVMAP0cxrhXXX+zgFACi+EaEDrsHSlxmOjT1
	 Ws2BYOoOrOaGabU3/zmUL49tN3XP06kEcZFoqRLSLGdwEtJT8mbhVIs/7Lo8XCfaf/6KV
	 G+P8OjqOqmHZdsG3cOrsMvDL9knJgLnqAoJVwKG3G49W24mcgqusc286SAahJlkilon51
	 mZZBMDY+0Jex1KFJ6ahEq4Yzl8+KJBqmOmdV45M79poCD1N8bu517HIC83fjDcPVnoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uR0wM2zQ;
	arc=none smtp.remote-ip=209.85.208.182
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5476F606A339
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 15:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5476F606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uR0wM2zQ
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3ae25dcbd81so22103091fa.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795102355; x=1795707155; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=uR0wM2zQORWGmbKo1cDXy2RLMlYcA6NcKFKLmpeXIu3GTrYAh/tGgVO4/5pgxT0eUZ
         JY4f+P3rygyCE0GEIy8qLUGR1u8yH377DTc26OScrnKQbQcvJTwCjEQtIDCuA6DYLDJk
         cpeeILo/9EHaYkUUY5iRuB+lN3vF0alrtQ7HUZJWFdiz4ssqB8LUPeWvdMsFiFMdFLuH
         BU7ZlZA707rBJz7F7JU8jxEug+wyozMq8IDE7rVb7GpcWm0sttmDxl35ufQj+n+NTryH
         d1+plupk+y713Nf7r419aqK+8ZjluIqO6O37qK04C8HbPigG9dq7SVFINsYC9fI+PGi9
         bxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102355; x=1795707155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=BIRFbzZLR4geCnF2YQxi3OLvfKbBbcJ2CqWeSmeXah4+1xDsn1rMLK/RHMhaSJI2NA
         JjE6g4bOKWXn3gAdxF9IxHPFXOnLHnaMieeDQ6RNWTNRfnGBszBm4xD9sL7mai2bUcno
         FpHL5OFtWbTh0Y8en+ULS/wpMzDao+R/y8ucGKgTeUgNxL/5bHuxUKJLTVtjVhShpYEQ
         v9OqrRlgLIRTiTEmcahCNGObHjQGr1DCkIadGFAQTdFlmyB9Qi8bD7BBi1JMKZshqliy
         5dwBSRM83uRUKkO1lZb+6qjXbgOzuteL5W5VnThTH7clpvquQSxRvNfLLkxkI0ETC+mY
         DoSg==
X-Forwarded-Encrypted: i=1; AL+hErF2ji9ebPSKUTnE9v72KdH9k4tzmYHCHgQOurRZ8DUjupdom3TaAXXa/vrYnznTQl0YjDia9jTT41iclA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/i9GgAEFJuCaM+qomp3PwO2HRPuT4Kl4F11hcD2qQI8YcaUcYh
	6RAxkeQPtTV2dAB7Z5QPqfZ1nKw4BBWPs+FcqRUvN4NEYlVDgt0+FloR
X-Gm-Gg: AZFdTZeHANs+DZqXdIs5wyEOI2JlN4i+1FvIYyC0WC9Fcu4cvV2EFseIWoLXxdxWjZj
	dcM0LKJQGCVMz4vD7/dFz56tj+qRrgP6TAORms+0QJxiGY4K9rJAVClf0PETwlmuNzNvHWEEOgr
	B0q+/Y5kfQ416rZH2+qeKaMy0Z0t1kEAzVhpX8Rx590l9HKHdi9I/jGyvu/+lucgHxHq+jkc/ct
	PAdAW8uplJI/u7/Oz+r3yQXnZltPl3ri4MRIlVTnzIzuKHooWopJuJN+6tccyc7iOrljfGKtQzB
	RGFYNhSyc/1BevEcyxeEm8wbBa1gHmv7Me6iqdRN6E9p9Tz4m2EB1G42mTc8bk2p+4V2/9bAoun
	kHVp/awkfmA1o/xqxyci6Gom366XQomBjdHqnikmlZjHmEyTzJAWfezW6FzQV4H7N2MjgKzqeCN
	XGA5v+GxgLJTGElmgrbrxOlq9eJsEY84ZX++dLyzX1Whto+2bLzCXjQxXhFKd1QWbo+b9WzYZwu
	IwYQLCljbsJRfRq2GMLK/3OIvO09MgGQvVn1xinh1O5Mq55rjl4fZoHxGWBf8x6KHBGgKhK2V0S
	CyU6oys0OVCATElx/K3O7cy+juRIUa4R3GJAC6JiFnr/+9AH3f+Lf5yt4bCzbcq8w+YdWVIRPtk
	33wipmwun4ReMkNdWPhLseW0eih3PmO9P2qCkZjnT+AQTpbleYBbnUAkrWfY=
X-Received: by 2002:a05:651c:a149:b0:3aa:ef31:e51e with SMTP id 38308e7fff4ca-3ae7fa644d5mr1204161fa.19.1795102355312;
        Thu, 19 Nov 2026 07:32:35 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegwnwppvr5uhf9-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c16c:a39e:e605:54b5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ebe67e2sm11532121fa.33.2026.11.19.07.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:32:33 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
	linux-cifs@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 17:32:22 +0200
Message-ID: <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
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

On Thu, Nov 19, 2026 at 01:00PM +0200, koraynilay wrote:
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

Thanks, that is useful. I agree it would go there, whichever meaning
it ends up with: as a newly added flag its bit would be added to
FS_FILE_ATTR_XFLAGS_MASK next to FS_XFLAG_PROJID, since your
fileattr_to_file_attr() masks the value with it as well as the mask
bit.

Your mask also changes the question I asked Christian. With it, a
plain "may share" flag works the way stx_attributes_mask does: a
filesystem that sets the bit in fsx_xflags_mask answers, and one that
does not (btrfs today) reads as "not reported" rather than "not
shared". The inverted meaning was only there because file_attr had no
such mask.

One constraint for that case: the flag has to stay out of
FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
FS_XFLAGS_MASK is reported as supported on every filesystem, so a
plain flag there would read as "supported, not shared" on btrfs.
Outside FS_XFLAGS_MASK the flag is also never seen through the legacy
FS_IOC_FSGETXATTR, which masks with FS_XFLAGS_MASK. That is fine,
since only file_getattr() needs to report it.

Christian, with this mask on the way, would you take a plain flag
(say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
that filesystems advertise through fsx_xflags_mask? If so, I'll build
the RFC on top of koraynilay's series instead of using the inverted
FS_XFLAG_NOSHARED.

Thanks,
Lauri
