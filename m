Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099708;
	b=atte2sUEH085YmA5iqdRnJvD8/RmzPGfhJoAOKrab29GSUoJ5kk75ZXOZcDvin08yiBJ
	 1MW/oKSOzsLLh2htuju1LstcEJWC38B70UfFJ/35akZIOYx54s/nYTJUYKVMPw48cB2WW
	 fd8ZxCK55Ck/JqUaueJvZpQLwmD4f+imtNm8yerVBo9SgFsS4y9tG7rkjR9aBkXYE16zz
	 JiJYXjX+x7OYUAJj6nS4pM/3BXthCVyL+ArisXHRqQpU6W7U0PQLtltzY4PR4YGNMi9bd
	 U6HJPdbUkmLGQq5nKmvyxhAWjsPG5lQatZXt2CabQ5kXFGZNlUutPaEqHJl4u8CcXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099708;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ov5kHseyLjUyaFTre9d/J+p3Vxi96a+eJ0R2U6anbzo=;
	b=aoS8+G0iTTXerg8MC+LRHjhR2W0qtqH+aierbZgq9mnq4rLdB5NQAwjp8CzecCr5pwxT
	 0oLgf1wwLRBQqD20W2YdciRdPZ+y/TQZzjAD938+cVL7P4AJCsYWiTO0J3HXtebaZS1wt
	 UU+3TYnPwGdZ1F1oj0shX/yuWaEp/g78O/1rrAXyfLqjHcYaGSDez/LChtxf8M6U+/ve0
	 MI9M2DKktPi0AkYJlD584wfLEfXsQ2QrKPAyNud0mOwpvrPfZSocKegpb6qMUXo6CFrUJ
	 I6dK7+Mx2YZdcHvuWsAIMUGIlWGMUhOKaj0JRndbspS1VcSVr6eX+A3hvTRNKlbkgxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iEbjtoWe;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB6606FF73
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 14:48:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80CB6606FF73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=iEbjtoWe
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElhdR018282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099666; bh=ov5kHseyLjUyaFTre9d/J+p3Vxi96a+eJ0R2U6anbzo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=iEbjtoWex2pWZMp10G3IejFt+2zfT20Va5M2xBXlD93shEMj2l4FCOlTtUgsS727i
	 cxv6pz0cRpja1t1wYe8ReGdlIFaYK2EHxM2fMYsIAc1o8kgtY9OKfzaPVeeny7OjFe
	 uzTHpI8ZtZweppriaTuyNKZ0QkGS2ACmtsVQBS4EmLwTU4OHxiuvGyJY7xN4V78729
	 3ckURY1oge9fprh0cL+K2XvfarseqnRLoIa/6CuUklY/Al+xTdw8aPZZWDvz1ljXCz
	 Kq6ON1jENF6mHxXEtlZndHX0NjOXPie+uesqtsS/K1L4hPuOsZI63QQsIprmI71Fkb
	 I1NCGccr3vDsQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7B0172E019D; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 0/2] fs: fix readdir position truncation on 32-bit kernels
Date: Thu, 19 Nov 2026 09:47:26 -0500
Message-ID: <179509948659.1938961.8825616044401676676.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 06 Aug 2026 10:20:42 +0800, Zhan Xusheng wrote:
> Both ext4 and ocfs2 rebuild the directory cookie in ->iterate with
> 
> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
> 
> ctx->pos is loff_t (64-bit) but sb->s_blocksize is unsigned long. On
> 32-bit kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a
> 32-bit value (e.g. 0xfffff000 for 4 KiB) and, under the usual arithmetic
> conversions, is zero-extended to 0x00000000fffff000 in the AND with the
> 64-bit ctx->pos. The high 32 bits of ctx->pos are silently cleared even
> though a directory may exceed 4 GiB.
> 
> [...]

Applied, thanks!

[1/2] ext4: fix readdir position truncation on 32-bit kernels
      commit: c966757ff80fe8407e2e3acdd720964769ddf937
[2/2] ocfs2: fix readdir position truncation on 32-bit kernels
      Not applicable for the ext4 tree

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
