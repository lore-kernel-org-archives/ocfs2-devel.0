Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86221C761AF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=waE6nTgkqu2YXJmcFtHJX4gzmKhhWPMmxT9ox1ZT+KQ=;
 b=3CfSQVCsOwYyN/nPiG+6MNp8CwcV0KONmbdWar0/0BJji1r67wO8+EmTPstTgxNvCwGNnfVePLS0
   u4hEbEyIn/lSisc72oKw7BF3JtAsqbNTKdNkFE7SpCdNJE1qbj96nIvc903l4/Xzxi1VA6KnShMi
   sKy4ndiNJXpX9PyCa4xfGNCLUTTC57es8IPCUvKhllbrkvntkh1M8qZT6jFN64QtEvbYJ0VL3YnI
   m2R+9snkLxDDcwsjzmmN5xgi5wbW4BEpYHyha106NHFvzK17smpyYgH9RxVIhevxg2NPkW539NWX
   ysPgRZOP36Kn+tmSBCdyQBh6DViWfLWMjhW5CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=waE6nTgkqu2YXJmcFtHJX4gzmKhhWPMmxT9ox1ZT+KQ=;
 b=FGb/K1uoQ45JgIxlrZyLVsWZ3D9UTS7mZ98xL78rGxS1SOwmytiI7mzzpnl19aT+XfmLWRNPyG2G
   uWqjG9x0xEWp63wRtV4QnKu18xJMAgQEO0dQisKXi8YBRzNg9pS0GWxSwK/b17aA4tCl+YTf0E54
   wy4mhlKXIMW2ffKFzUgvH8j2S7wNS3yT5bftnS40wQOfKvhRhUkuIp9W1kNA9CfTDMmpn2d0jKpU
   YNPEBURXZ7AmhL08smXVC4Y0Jfzo/mzS/49KxML9wjwFNLElBs5iMqpLPAxQa0MFqQdZxKDaU4s5
   HpeKxmgrZBnIyoje+BdGDad3jFdXiDOgupMZJw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRZ00MY3CFSY6A0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 15:31:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1679548610;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HoUzTMO8R5MhPq7S8OoMssryl9/6eR6zluDti49MEro=;
 b=VenPyRS7ykgOC4kdbDyUaXDTFZc75EDXi41x3ovq7GXEJGHEQbz+73KZZNWLl/6PP6BxzB
 UPahLevW7ttMB3TJnf88cWXYONf2orGnBzl409euEbtlXKg4nz/8D35caRQg31VYm+szc+
 NDkOg0OssvAzgDFR/Xn1aoG39SN3lOY=
Date: Thu, 23 Mar 2023 13:16:20 +0800
To: Yangtao Li <frank.li@vivo.com>
Message-id: <ZBvgpBzEuFuyOD/c@ovpn-8-16.pek2.redhat.com>
References: <20230322165830.55071-1-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230322165830.55071-1-frank.li@vivo.com>
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10657
 signatures=596816
Cc: rafael@kernel.org, linux-mtd@lists.infradead.org, naohiro.aota@wdc.com,
 linux-nilfs@vger.kernel.org, richard@nod.at, trond.myklebust@hammerspace.com,
 xiang@kernel.org, chao@kernel.org, josef@toxicpanda.com, ming.lei@redhat.com,
 huyue2@coolpad.com, dsterba@suse.com, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, konishi.ryusuke@gmail.com, linux-nfs@vger.kernel.org,
 clm@fb.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, anna@kernel.org, linux-fsdevel@vger.kernel.org,
 jth@kernel.org, linux-erofs@lists.ozlabs.org,
 damien.lemoal@opensource.wdc.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v3 01/10] kobject: introduce
	kobject_del_and_put()
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
From: Ming Lei via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Ming Lei <ming.lei@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: KY9zo7YzPqyCZhglvOgcqw-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: ehbfxPIprCMp7OhnVmiqn51pefGD3n6e
X-Proofpoint-ORIG-GUID: ehbfxPIprCMp7OhnVmiqn51pefGD3n6e
X-Mailman-Approved-At: Thu, 23 Mar 2023 15:31:02 +0000
Reporting-Meta:
 AAGSASnzR0AXPnQp3p4Lbeu82w2uTtjNeqy+a9tBAFTBpGsn3NfC5LBjYLkR7M1J
 khcTOwzasFK65+7V9onuB9M/3CFMwqBp6xsemCshNS8y5/EGZ72XjVRKEGQR1DXD
 clhFxKtUTkwGsNYw1DKaXl9Js5KK9S4FZrSspEwbhWoy4UTTC5OjA4BoLCeZZjEa
 rjG9X8jabbSEfDqL5HDwtFKSIo7QqceUB0+7S6XW0QlMNpBP7J28U+nQplsx/UBH
 EjKWQBOrTkSOivcASVhr9Fe6hTZXRsDaPBRFhU/k6hyiPvjOLn90kisNUCbf12ZN
 Fp9MfTrBy3puQE379+D6IFugvTDy5PcEU0oQ8WIqrLCoSeOBh1CbYzUcMxI0FCPY
 LzE5Noed4PlKU7mvT+7wtGrNLzSBuKkuZOFLVHJYs7nkTNT6aJUpzeqktxbdfcic
 QoJHYZQHe3qpMKsZv05Rx5+HP8srF2DX4sOHH0n+uxhBLq46rAWX2LR8Lsa83gTh
 BKxpuBqDnMB6ORPUW5OMOhJz1UlgUe5x+NGCh9gA8bc7

On Thu, Mar 23, 2023 at 12:58:30AM +0800, Yangtao Li wrote:
> There are plenty of using kobject_del() and kobject_put() together
> in the kernel tree. This patch wraps these two calls in a single helper.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v3:
> -convert to inline helper
> v2:
> -add kobject_del_and_put() users
>  include/linux/kobject.h | 13 +++++++++++++
>  lib/kobject.c           |  3 +--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index bdab370a24f4..e21b7c22e355 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -112,6 +112,19 @@ extern struct kobject * __must_check kobject_get_unless_zero(
>  						struct kobject *kobj);
>  extern void kobject_put(struct kobject *kobj);
>  
> +/**
> + * kobject_del_and_put() - Delete kobject.
> + * @kobj: object.
> + *
> + * Unlink kobject from hierarchy and decrement the refcount.
> + * If refcount is 0, call kobject_cleanup().
> + */
> +static inline void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}

kobject_put() actually covers kobject removal automatically, which is
single stage removal. So if you see the two called together, it is
safe to kill kobject_del() directly.


thanks,
Ming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
