Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA00A26A088
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795068; cv=none; b=pOoZHGWH2v9XWHFiKmXI0hM0e1+1VWOQFUhbKOEmd62FWWhhSmd+oCVrX5bq4mDKuRzzsseqVJ0Y9y3KE5lXkf3zDk/7cD+gN+jQpCUZoKzrAUsQZqyH1pXn8yKgVr5Ri/FYmFNdwHuePD6BsrzywEuijI2AMsdR+6KyZ1WcMIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795068; c=relaxed/simple;
	bh=N62kHAETrL8juTJSX1jpxPOFFSAnM/2u6veHDTeMh74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UD/rRvFFpz4NOFSJEIDsW2E99KfnK5ZvyFEZgBzFDPNQVE+md2vVHv/Z80nx41IJXH5CWxfld/g7hnEfY52zW4o++ClNoESxKaB/8au/ih43hYYm24uH6q5HttAaJv8jZCTgdXyr4GZWZya2JjxElGlWyJHKbb65Yk82X548z9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCP4veWB; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCP4veWB"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63f7c7185c5so723719d50.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 20:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761795065; x=1762399865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHVQnpkdOsGCMnybMIsF85MLqwj3Q23B3BHIQYvjdKg=;
        b=gCP4veWBrn/Tqzr8aE/grTjjx2hwW8FlNTk8yg9ZdtDUjmC5wrFcE87YyMVyUPCrXC
         aLosDqidHk52RSWTCFL6g9odTaH5TVYbkD1DcxeqXqS6NObCTpcMiOHheetT0z/MBUQq
         CpFtWxJrOVlyg8huYox820OTV0Whk++mF4pETWJGqzUmMq2x8RH7vQH4freVx4ac2L06
         fCUjt4HgdDc7x9VhrZDRaJJRK+Ag6NyzrbVcUEuREEX/lgLQd2YVpne8BSXnermJ4obB
         OUnok7jxQjQ833KBkM5AwYzx+kWtzycuNoMEzpyeGBnBnqxlc+NKIzUazHs3qir0HnZG
         vgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761795065; x=1762399865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oHVQnpkdOsGCMnybMIsF85MLqwj3Q23B3BHIQYvjdKg=;
        b=F7QAqD8nUA4H1ekDZQEcWc3DdjbmTr2jcNucDAuGsxt2WEFaLXWoG4+OlwgHcWPdAh
         lGzBUjXIv937P8EWUb/Ja6+tLbWnbR3LD9KkSjEu6H5XNOP4Be2M0p/URLK217AJrBpr
         Gv/xGn95+QkX3ScsgGum1jTXckUyxUbxeXn5kghEIhUZqtLag3UFydFPNgx6/wo4kw6U
         7vsa90HeziVjPD4sr/a1KqAA1X+aQ4BeZQVK11uVPr0flZJhz2AX0hPavxPioaEFz+zl
         UxYW9lRXFt5bNef77v+/PemmH2E5K2E2ruvKahg6niSyCIi5UjWbwQ7SwzbfLDZ0hWKA
         Hzkg==
X-Forwarded-Encrypted: i=1; AJvYcCW43mBzkoKyIjF2JfMHbMXE8PGz9uLCswJxB0aA09OsYLhsBIn8sRSv1xH2GGTHpBOUvphEIs8faEN2Dw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyYmofVoeMXG8NNM+BxxJi/rTiSwgxSYGbM/UcdfcCoAjVZeS+P
	x3HR7aAC9f5IVPBjBEDiFyeQVXOO0ovuE5g8rfHFjYC2LgsviP1H49RXo2MxJ+2iB/6gyS6o6XO
	woBMQXcQQyYno4jsdHJtleFesPewIekI=
X-Gm-Gg: ASbGnct0RgIgApigsxlxl7+EksXF2n1dMI5//oWrUYXYHN8fuFbuLmnJT4kfn7rvw48
	TcZBhjXhEa3i2FUxuTQ/ImMIvkcxU2cWjUOquSc3aL4Hv180XyycF99GQ5W5xIsKcFbYhAIRkC9
	l3zQAs1BNaP7Ja0zLVVz5YVFWsG46hcugeIJ5EHhm4GBlNWHRVk9SonJ+po1goJW3pxKxJujkNl
	0ydDGkX//0sG4KtSfk5oDHqpMcRKsVta9YACILQRxX6iHhNy17ZJ2xPI5sYruRTafBrkgjNL1Jo
	30IsaYnYIGj+AAvKmg==
X-Google-Smtp-Source: AGHT+IE+KWgCxY9UWLro7vkMLeN+sz1zh3tlu9lWmyVOp5AfnvnpEVcXbzC+1Oi36SGQWKeUWx4kX6/C/FDQOivraI8=
X-Received: by 2002:a53:d013:0:b0:632:5ba8:1bb5 with SMTP id
 956f58d0204a3-63f837bc367mr1113064d50.21.1761795064751; Wed, 29 Oct 2025
 20:31:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru> <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com> <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com> <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
In-Reply-To: <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Thu, 30 Oct 2025 09:00:53 +0530
X-Gm-Features: AWmQ_blYvvIkgF9F0QMZAAcnLziGqfs-E3pp6nebsfQ48KH9GWLWXA2Ed7umCrA
Message-ID: <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>, 
	akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	lvc-project@linuxtesting.org, 
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Joseph, Heming, and Dmitry,

Investigation complete. Here are the full test results:

**Test Setup:**
- Kernel: Custom build with cl_bpc validation patch
- Filesystems: Created with mkfs.ocfs2 -b [512|1024|2048|4096] -M
local --fs-features=3Dmetaecc

**Results:**

512-byte blocks (4KB cluster):
  inode=3D20: cl_bpc=3D8, expected=3D8 (cluster_bits=3D12, block_bits=3D9) =
 : PASS
  inode=3D23: cl_bpc=3D1, expected=3D8 (cluster_bits=3D12, block_bits=3D9) =
:FAIL
  =E2=86=92 Validation detects corruption

1024-byte blocks (4KB cluster):
  inode=3D12: cl_bpc=3D4, expected=3D4 (cluster_bits=3D12, block_bits=3D10)=
 :PASS
  inode=3D15: cl_bpc=3D1, expected=3D4 (cluster_bits=3D12, block_bits=3D10)=
 :FAIL
  =E2=86=92 Validation detects corruption

2048-byte blocks (4KB cluster):
  inode=3D10: cl_bpc=3D2, expected=3D2 (cluster_bits=3D12, block_bits=3D11)=
 : PASS
  inode=3D13: cl_bpc=3D1, expected=3D2 (cluster_bits=3D12, block_bits=3D11)=
: FAIL
  =E2=86=92 Validation detects corruption

4096-byte blocks (4KB cluster):
  inode=3D8:  cl_bpc=3D1, expected=3D1 (cluster_bits=3D12, block_bits=3D12)=
 : PASS
  inode=3D11: cl_bpc=3D1, expected=3D1 (cluster_bits=3D12, block_bits=3D12)=
 :PASS
  =E2=86=92 All inodes correct, mount succeeds

**Analysis:**

1. The validation calculates expected cl_bpc as:
   expected_bpc =3D 1 << (cluster_size_bits - block_size_bits)

   This matches the mkfs.ocfs2 source code you referenced:
   di->id2.i_chain.cl_bpc =3D s->cluster_size / s->blocksize

2. For non-4K block sizes, some allocator inodes (20, 12, 10, 8) have
   correct cl_bpc values, while others (23, 15, 13) consistently have
   cl_bpc=3D1.

3. For 4K blocks, all allocator inodes have the correct value (1).

The improved error message now includes:
  "Inode %llu has corrupted cl_bpc: ondisk=3D%u expected=3D%u
   (cluster_size_bits=3D%u block_size_bits=3D%u)"

Please advise on next steps.

Thanks,
Deepanshu
