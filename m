Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E5B1C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Mar 2023 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BCLkYSOMTHO6X3co6ZqSxntC7/doJjLN1YoFFf1ziKE=;
 b=yW9qUqT5MbnAlSVU2cN+5Yps265sQGWZvov+J9SxQ/r+q9j4fnkLYWt6nqhpKdpcgLE6tQMaaCSG
   wkOAvRe2LG7I5WooQzRxMeBSYEelfQ8lzW6nLHLoM+VnrorEpmIx5PRvpvQPDDn76moW9A7dEUsa
   6JS4YA+P7tZ8FiZsQQ3CpA5ftIIFdYoEEitOdSvi6voex5p97GZuY/mpONqO+2k/kJAjgZ2/4xYm
   fUWKU2I5SA6RgVVfqQQnTMWcjFnlDutON8ybMfFHYstGRpX9TmM9UdBePg43KbeyFMMeewwaBbxu
   K9n/j5Y1dcKHMtHxsbKe7mx7yLl9iX8JNrobsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BCLkYSOMTHO6X3co6ZqSxntC7/doJjLN1YoFFf1ziKE=;
 b=XJ4k5ZESIa0hpNQe8ggu2D7fYuCgjmVR6NNYo6iZJp3RJxOTeVI7P+9oI38UA1QM/1l+YFGEpZyG
   /2YL70MgUk0+QrXOgiYNq2nTbWOhSEaCTEX6F7sWAjN2cYb3cVjOBxFEE6eFYaxv50IFXp67hbar
   tgaNf7o79DzVfF34qbftsCREoWxxNOQkw17PWnj02+ephtdq5nxPmhtv6I7/HPgm7XuKXTT2Ir5A
   cdAv+fhXjuBJbvzqzQE4Yk3V8m/ET9Jkehh931TJHQSRj+jnrim1tcb6ppfaj6LJaoQglCt2789a
   O1MvUPiZD3SbE8qiyT6+RkORDV1mH00w90tmgg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR900ALADMN37C0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Mar 2023 14:59:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1678373926; bh=Fy0PF86k2flygl/jQKs8YcT3wCcxTvDaDOd0+8NdcO8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GkWzvRMehyETFrkEcTAfT0uE2WbV9L213ExoUmXZQQ91gdUEpJ3gg/nYrV07IyA65
 VKEcUkToUjEJs3VEaeMQAlAqLpecmigMbaBrAYwuUNoDxcKPyiuLuTnLck40w2C+fk
 ij1/NUAXURRALcEOmYjejuxgLeV6yM0JAKZY7fcFsqU1f2n5XXr7QLQmN2GeGVq7pI
 gpgdYGj5csLnBzSr85iWtWqt93nxtnPS2X9qxekurHfW7D1vVi6IkPOfG/oD+1JNt+
 vJ/iIqn0PbsgN5WA+HE3caFzXrp7joz+12zp8dh/ZvZF/PgWyBZkmA+Fs7XwUIQ5Z+
 cr7IRPS+GC0sg==
Date: Thu, 9 Mar 2023 15:58:38 +0100
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230309145838.pgkkkhp4ahvqdkv5@wittgenstein>
References: <20230309124035.15820-1-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230309124035.15820-1-frank.li@vivo.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
Cc: tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com,
 viro@zeniv.linux.org.uk
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] fs: add i_blockmask()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: JdXLWgAXyic9SavyyjQZmWq2wDt_5Y-U
X-Proofpoint-GUID: JdXLWgAXyic9SavyyjQZmWq2wDt_5Y-U
Reporting-Meta:
 AAHCtJUaE7Q7QX+vlc5Oe5+QNVqOLDJqCiYsbmyu8V5q3KUJfcEEn3eGoYj7f3op
 zLhdg/n0S/QlXqJ5SjXvjcv6eo10srxGHxRizT/Sou56D/4mj4vGwbKprZkjxeqT
 QcBKzp/JWuM0tVoLFosLXhy4TnIUf0iPQUqfoYIYlfb3Mm4ePs3F3EXoquxG6iY8
 3CahyULE3nnQtLV/yAqHFqG4uUfhg9nxsD3z9/ImyxfspTVuv+UjpWzx1Ha8yD2s
 7BEhty5wsiMwBAiaudmP8+cvn32GjcHJ6Fw983oOEduw9xTE3mJOSCmsySZ3X7MS
 jPfUjp7gEQp99s/UgbowE3GVPacxhYPocwLznIaJkell+I4+DRfsmlBj9+luq9WT
 I1B7tbBBF3nXytL+datObvEOx1tQelB6a1QlVd97VIpDOitjuKAVcM9b/YTeoP81
 3knUynIUDpH1EXensZv+izjXvEmn0Zs9YX8zyEmKNI8hIV/+oendrNu26f3Ccv0m
 3aHFMQBruJJWaBbuuY28DOitzxZky5uJaZoLri+JBHM=

On Thu, Mar 09, 2023 at 08:40:31PM +0800, Yangtao Li wrote:
> Introduce i_blockmask() to simplify code, which replace
> (i_blocksize(node) - 1). Like done in commit
> 93407472a21b("fs: add i_blocksize()").
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---

Looks good but did you forget to convert fs/remap_range.c by any chance?

static int generic_remap_check_len(struct inode *inode_in,
                                   struct inode *inode_out,
                                   loff_t pos_out,
                                   loff_t *len,
                                   unsigned int remap_flags)
{
        u64 blkmask = i_blocksize(inode_in) - 1;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
