Received: from forward500d.mail.yandex.net (forward500d.mail.yandex.net [178.154.239.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7113385A3
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761811933; cv=none; b=MdZLYtz+danWMbHFUTmwMSzJYPeTNIvfzDqHsUgN6vET7u86J3djaz/tKewrxcX6BV/e3SNHOlBqHawXpkHVbmcyhQvK1uBbe40sWaYddC//beKrN7Od84sGgvast+uXhHoEIMq6VFAQg65RGVCfK1gFKbZY31CwwBLqIWCFjDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761811933; c=relaxed/simple;
	bh=8tcZvySeN/V2dt6sbobRc1JmD5E9TR9rrhkaCVMpA0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9KVoOomdSHtsg9HH3BL8GAwnRDwMQvw21ON7gbijJHWBKhuP4OOrZbhGViLzi6hTk/i4TIPfkQia+QxWNjixnd6ySLSpnsxtEfjrF4caqxnPwSV5sOWkw2KC7A0+s3/BNkBoUPRFRJHRrTC5NwX//SyZoHugo5YT6+3RMUcjuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=FJkctWwl; arc=none smtp.client-ip=178.154.239.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="FJkctWwl"
Received: from mail-nwsmtp-smtp-production-main-84.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:41d:0:640:f0c1:0])
	by forward500d.mail.yandex.net (Yandex) with ESMTPS id 6A4008135F;
	Thu, 30 Oct 2025 11:12:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xBatpF4M0Os0-kcxnXRYx;
	Thu, 30 Oct 2025 11:12:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761811920; bh=e6q27sdk07+eSwhn0qjSluT2Rw2Fu5NZwMC6rxZOdmI=;
	h=In-Reply-To:To:From:Cc:Date:References:Subject:Message-ID;
	b=FJkctWwlNKU+FG/VsrXzxz6yqkLufFTTGki938UFrWsNSvMY4A3PEpnc/Q0wLcsBb
	 NyeXgytVpVOUYCYmyRjfQSLltwtw6tJBaqoSgty2Oq17Fh7x6csQZrImJBbNNxCiat
	 1FYG57OWMhK1mHLtf90SPwehbM3bNqnt5bMSEZS8=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <f2323939-4939-439c-8fc3-773c60cc25e6@yandex.ru>
Date: Thu, 30 Oct 2025 11:11:59 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
Content-Language: en-MW
To: Heming Zhao <heming.zhao@suse.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, akpm
 <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
 <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
 <ruygrlyh5vq5tbcsolpgyxgs6r36yiyph4rzgoti4txq5d6xky@k2q2smssjekq>
 <CADhLXY6rVF8+gVCT3=SjRXB3EerBT3yC8qsk25VU+tjVRkWrcQ@mail.gmail.com>
 <eeee7189-c9ed-4c80-8312-d4d15e0260e4@linux.alibaba.com>
 <CADhLXY5TPHyVkgB3f9ZNzWUursXcOByEAEch7w4GpqP6CTzv6g@mail.gmail.com>
 <CADhLXY5zFHjm81iU5Jkv2iVYuUNg_18rYqVUmZ+-V=v=P6KjFQ@mail.gmail.com>
 <eba45ee8-1268-4c55-bfa1-c690b28c2e21@linux.alibaba.com>
 <CADhLXY5QK3vDcXhuW-xq5Bd72uPCVA1MeTnxn_991irOmvhRCg@mail.gmail.com>
 <x4g7symjachxmkyhjqx5x2dfdn4ybvfkbzjvqiso7qbtxdgov7@2xds57btyzt2>
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <x4g7symjachxmkyhjqx5x2dfdn4ybvfkbzjvqiso7qbtxdgov7@2xds57btyzt2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/25 7:22 AM, Heming Zhao wrote:

> One way I considered uses the inode block number to bypass global_bitmap.
> the code seems ugly (demo):
> 
> ```
> osb = OCFS2_SB(sb);
> inode = ocfs2_get_system_file_inode(osb, GLOBAL_BITMAP_SYSTEM_INODE, OCFS2_INVALID_SLOT)
> 
> if (OCFS2_I(inode)->ip_blkno != le64_to_cpu(fe->i_blkno))
>    goto by_pass_the_check;

This is what happens in ocfs2_initialize_super(), and, IIUC, the global (cluster) bitmap
is the only dinode which can have cl_bpc set to 1. So what about the following:

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 709afbfd1f9f..a8138c150d81 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1520,7 +1520,18 @@ int ocfs2_validate_inode_block(struct super_block *sb,
                                          le16_to_cpu(cl->cl_next_free_rec));
                         goto bail;
                 }
-               if (le16_to_cpu(cl->cl_bpc) != bpc) {
+
+               if (OCFS2_SB(sb)->bitmap_blkno == 0 && le16_to_cpu(cl->cl_bpc) == 1)
+                       /* This dinode represents a cluster bitmap, and we're reading
+                        * it for the first time from ocfs2_initialize_super().
+                        */
+                       ;
+               else if (OCFS2_SB(sb)->bitmap_blkno == le64_to_cpu(di->i_blkno))
+                       /* This dinode represents a cluster bitmap, and we can
+                        * recognize it by using the known block number.
+                        */
+                       ;
+               else if (le16_to_cpu(cl->cl_bpc) != bpc) {
                         rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
                                          (unsigned long long)bh->b_blocknr,
                                          le16_to_cpu(cl->cl_bpc));

Dmitry
