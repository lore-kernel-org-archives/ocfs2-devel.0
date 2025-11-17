Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D81316198
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 11:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379853; cv=none; b=qMk+dBoV68tPwnTLuQ1pWaNSbFJhA+Zbtj6z7od/XbX4KQw/BQmguraKZ16M8C4peiZDuvTlj6JeQV6MXD2ZDfPwxz0b/jeOShAjq+z3dPeQlS0AqIK3WmwmwIiT562otfv3XXN/FFDnneGraqvC89azh3cOIbrQ64lqtn3KaOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379853; c=relaxed/simple;
	bh=FL8BdqnCyOjm2sKY78J9SDM0kLMomnkZg8sB06ASAl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TS93lkBvmO5+zC2A7tic20nyLKSwopjI/aw5NLM4uMQUXIB1+YyJnCrVatqz3ntRVTRwGV1bp+1vuetPdvfvRhDelc3Pgf0DrWswJWRU8RCdsW1YH2B7MYN0FYpatZjnhQIe0Be6DcHhmej+AbSNy/wtnvcBJwFR/dNHKGMELog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ty+NasP/; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ty+NasP/"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-640d43060d2so3607801d50.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 03:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763379851; x=1763984651; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FL8BdqnCyOjm2sKY78J9SDM0kLMomnkZg8sB06ASAl4=;
        b=Ty+NasP/HQAQSLA6D20oIWRwyqPX+orG66sEwrU0J4n9vzH32PhYaz7pbPZFv/ygV0
         r2cM6vr0XCqBjAJQxFMDsrbvtsYcZ9pH8gBRBLCwB58gaGc/KteFU7SPnuJqq34tu91P
         hQnenLaPEnKGLTDqzOvAiWlBPMhaETivA3vBiZDWMDmnmU9EmsFO/f1WrRRN/GWTFg5W
         QphpXfAh2H6B1FclVN9XCGQWxTcbQxuYyqDfFlsXDFLNnSHBHEsTr6V+XleV2EY5alz8
         Ectc8niDxCFNLjgAJVziH2jdTeLg+6mEQk/AVIBU+CsqT4Z+KHY0zzR+6BtUI6FXwiLI
         4ADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763379851; x=1763984651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FL8BdqnCyOjm2sKY78J9SDM0kLMomnkZg8sB06ASAl4=;
        b=dA+Vrb93FnSPfzRu4ksszjGgf2qDk9vSV2t47yZ3y3jZ5tFjD+HTgEBfmT6O1+VCq0
         5nJlZSqUgtDEKjRvK5niOayVUQJA0X/iPJPWzsPQICCJtWLU+PbDn9OPe/5JobgbcfjF
         wmbtyz48UEHbV0krSQqtC/AzqhVtYlH2N1x9SwIFRqWSyND4AUB09vdjEpSe4hV2tIpY
         +yC0rmXZ/g7ahrOgcHoWqQNABBMe2Kc42id4Ef6x/aIVZlInhKi1XpiLmtt/yDmN4G3j
         v4StvYUvdDa7fjkjcGEzljM+qzIz6ARheGouzmupi+vd4I+Lco4nUWfUr3OFgxiHrP9C
         PMqA==
X-Forwarded-Encrypted: i=1; AJvYcCUJZDEm+cDZkuJN5j/ACD9qiWmkym4MQ85wlYWO0/eJcm5fslbbGCj9R1/4LITNr3Pmxcx9jjfobptE+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzDXXcHxb0luBtU7vtbejN5uuReEb2ebPIAosrpoM9+Ro8L1SLB
	RvybMxlgYW4P/DbqVc5cXMBL5GrouIVPZUIpaKNtaKLD1mX2qARNAzTVanmyE7NEqrqFodaapYy
	N6vfxXnSiqoggtUueGCjVhW5CSXFsMQ8=
X-Gm-Gg: ASbGncs7AHXkXCGtZjgA5IwT5NFU3Yp+9oG/SygkJkWELuMPGNNRPK4NYfehphv3pzS
	scaW0bxsTy6gvNfifkmsfqGfip8YPMs0geAh6RpNLSalJejIqZDcPaEsFequaplvHD+HWUhAFfr
	vxWmtwuJ8MlqFiZAcIxKW3NfHyvtevrdbbGhvNWHQuYA0rA9hnvMjyh7bSdJ4mUtxktIly6S8QI
	eiDreR92whCUrfYEnh0Um2wqXiD3QTV2pLjmeGfZrXk+yTkA4OFnc47cLrONQqLFveq0+x/m3OT
	Bxr6h/Y7uHrBvGuFcsyqRKH3hm0=
X-Google-Smtp-Source: AGHT+IH1uk7m9bCPBzHK8pZ03wDvb+0fuFqKFq1/YskhqflWYSeMtUB01FQERCXqrz8vTfSpDkKZTLqc/jj44nBCc34=
X-Received: by 2002:a05:690e:23c5:b0:63f:9f6d:5b1e with SMTP id
 956f58d0204a3-641e76ac07dmr7870715d50.67.1763379851213; Mon, 17 Nov 2025
 03:44:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117063217.5690-1-kartikey406@gmail.com> <yiza5dit6fgkeoshpqptaqyuohxup7n2jtmdasodblp6voi7qa@66pgsjaykg73>
In-Reply-To: <yiza5dit6fgkeoshpqptaqyuohxup7n2jtmdasodblp6voi7qa@66pgsjaykg73>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 17 Nov 2025 17:13:59 +0530
X-Gm-Features: AWmQ_bmaXDhzE3b4IgloLxYtlDIBf9OxEqD_mpsJcWi-RfC1OK8PI39xZo5HqTU
Message-ID: <CADhLXY4QvE2277mVNiO_vRpj4PsAU+=TFWzhryFRzHQkNeH1jQ@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: validate xattr entry count in ocfs2_xattr_list_entries
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Heming,

I have sent the patch v3.

Thanks
