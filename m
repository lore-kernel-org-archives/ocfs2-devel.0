Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF65EC7618D
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Apr 2023 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=17T8ef4iTfwWjOR8GpzMHpC+dvzLCHxGUpo7CPBEYrw=;
 b=wZKb1nM6nNzQ8o1lbUlEG+v5vBrBM9eT+AgEoppAHIi59Td73eQIVWaSZtNyfnQL81zweLmr0bO4
   MSkNJg2ymuZQQIKUktepubslgE3TNDZTvOBAs3cfYCXkU5Atqfwnf8FKeAIVyEdyuJPZtX4h9qmO
   iOcPO3U/iD9FsqkM6T7EQ473Muv4ycEKc9ZIt8Ibre3sqWgarHGku3xydealk0j/6LdtEA0T7ez0
   TmpKFS+Px1Lhl0sFfCpnSbQn9rqdlJzV4RLm2E3Qw1wHZx0hIUwBszW4bTVj/c8wr3Ouf87BSGcC
   7LbdpgD2prCLPneocnC4ADzVPBByCEB4Mlpr8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=17T8ef4iTfwWjOR8GpzMHpC+dvzLCHxGUpo7CPBEYrw=;
 b=ecgCkFRiCvh7PxwkHa1g1fLBH8NhZTciL2KPVDrcMIxJ0M/BfYczW875xD/7yxtvwBbH61Rw2BTa
   LRo/a+roXo3HC8I3Hb7oy+WwY5XHJHF5gp171reOXzo+aT/qCHcMp68OiiqIdnhL/XP1RyzeefEQ
   WTItV7JRZkAbszp//FMxM9Y5nca1lEfURteAzC6+HuNGk9xXk1tVVIntlhsaKCYFJlHnP3+UO9J6
   UcCAJMhqDqz/eGcBJtLPV3QkspQ08M4nL7HQ8GSvCfQh44YKnw7BrtK9TxHuuhutY8CdkowGmFu9
   NSHH7e5MrpUTMTjpY5TF/ic1OixSOxYQC0BsTQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSO00H773V2MP30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Apr 2023 00:25:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1680740736;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YnG+nCyPWB8ZL9Ap6fLZh9ezCdT+TIIsCMEMmA9isDc=;
 b=EXmP3vYYRWRmJJRhXqggrPi1F1uu+Px2PPChOJibgm3Iy2xeiePk+WOfQZu1yO6rZwQzHn
 TyRjQExsPrN0h7D8yQeWJU3VFabn5gyBuaXgqilAfs35cEtZOss7WZKqBMtgxes7zO/an/
 AzW/iwAdPfxBRjZHMURGqnb3Qf8tBNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680740734;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=YnG+nCyPWB8ZL9Ap6fLZh9ezCdT+TIIsCMEMmA9isDc=;
 b=A9yOL0Bmb7sFhSp+ZTmAfOxrRN7E2NTUvBWHwApqqc899qdEZFrMSw05yvglnbqPsc
 IIFR3IxT45TWAwmsCinJ1j3SU/W093bPzXS6kdn0EX0hdmjzw/wwokIqEGxBWyViSKsa
 GW4RF36RvDAbGK1XsESL7Ug2VlSCtLesMAG1p9+xSmRurNbT/WaAJi/e/F0cuXqLwtyE
 vrmKFleI9wFCJdJxSEac1BvsiQyb9N1tVElm8xGLb4Y9wYAwNwLTdqhm5Fo15kF39QYM
 Nz+ouOAt9hMK+JtixDJ7BVpN65KQsHXulUzlfqTxSeSfQJ87bwmCE8gltVogAMSC4w6u b7Uw==
X-Gm-Message-State: AAQBX9cPNsdAFBVZ5lfoq/YbR+9myaEt+2xIRt1XC64lMP6uAEIBE6WP
 u5ZhPiAYv5s26UT+YXbvTNlMRbZoiRWaeJgf0Jg1o/b1cCCGUD6WNWP7vtmgSiATz07CAHbGEJS
 N2aJrSnuXGQBc3b2usZpZrA==
X-Received: by 2002:a17:90b:17c7:b0:23f:7d05:8765 with SMTP id
 me7-20020a17090b17c700b0023f7d058765mr8769213pjb.10.1680740734098; Wed,
 05 Apr 2023 17:25:34 -0700 (PDT)
X-Received: by 2002:a17:90b:17c7:b0:23f:7d05:8765 with SMTP id
 me7-20020a17090b17c700b0023f7d058765mr8769184pjb.10.1680740733840; Wed,
 05 Apr 2023 17:25:33 -0700 (PDT)
Message-id: <7c2bfeb5-3c93-1fc9-cc1e-e7350b406ea1@redhat.com>
Date: Thu, 6 Apr 2023 08:25:24 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
In-reply-to: <20230404171411.699655-4-zlang@kernel.org>
Content-language: en-US
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10671
 signatures=596816
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 anand.jain@oracle.com, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported
	mailing list
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
From: Xiubo Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Xiubo Li <xiubli@redhat.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: bv2bI_PrPOaOlH-B12cMIw-1
X-Google-Smtp-Source:
 AKy350YchunmOlWsqR1uqhyleFq+e6uT40JJEkEYVgwX9vsqmDYfOCSrK9/Althx8xc8uY/FzfvVaQ==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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
X-Proofpoint-GUID: ELMzOGy-59P9iZ-Gmmb1Xebc0JZhPsex
X-Proofpoint-ORIG-GUID: ELMzOGy-59P9iZ-Gmmb1Xebc0JZhPsex
Reporting-Meta:
 AAFwSp2OyhzjbEKI+0Mc1IP4NQR53Q+9IGUFCdr842amMQ4ux6/errpl2MtvQZ0K
 RhUvK56c5VSRvNvqYJghXyTiovdsPRK1ZvuthoZMqrnOtMAXh0xeApKs/dFFulH+
 H10hxl2XrVpCBtbpeXKWTBx4B6jpBBDKfrLb2ignXnyUPx0ynKs1z6kYpNSzuyAR
 q/jX3i7ZyeMBlmtxQkXnxHrYZcjVjsfclVJz5RdkZzB3581qjrCEi6u/V2mMcBNQ
 wJTsJi1W2DSIl0KVjF5bAd96g2hQRLVs6NBqkt2wNhzdoYlS1+5mn4cRY2Vr39PW
 5RJ96DEdx8tfOM6rt2o9XVX3r+SUiTAfJJUElS3th66txoDM1zMdoqMH4opVjGtM
 N1EvnPKcsAr5m7+o0SSSHv3PI5hCo08OLdBjT28HXCEx2Di4UbRRw1eMxb/M8N1X
 mnlP3l8bsK/Bm8lXTK4ZttRclymnSsMEVkmM7LlXirf0lDSp2+CXc7++3qglH2Zy
 6TkOkbK+PDA9Y8v9T/5gPsLiXlycuR5Vm7UN6mcou5iz


On 4/5/23 01:14, Zorro Lang wrote:
> The fstests supports different kind of fs testing, better to cc
> specific fs mailing list for specific fs testing, to get better
> reviewing points. So record these mailing lists and files related
> with them in MAINTAINERS file.
>
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>
> If someone mailing list doesn't want to be in cc list of related fstests
> patch, please reply this email, I'll remove that line.
>
> Or if I missed someone mailing list, please feel free to tell me.
>
> Thanks,
> Zorro
>
>   MAINTAINERS | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 77 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 09b1a5a3..620368cb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -107,6 +107,83 @@ Maintainers List
>   	  should send patch to fstests@ at least. Other relevant mailing list
>   	  or reviewer or co-maintainer can be in cc list.
>   
> +BTRFS
> +L:	linux-btrfs@vger.kernel.org
> +S:	Supported
> +F:	tests/btrfs/
> +F:	common/btrfs
> +
> +CEPH
> +L:	ceph-devel@vger.kernel.org
> +S:	Supported
> +F:	tests/ceph/
> +F:	common/ceph
> +

LGTM and feel free to add:

Acked-by: Xiubo Li <xiubli@redhat.com>

Thanks,

- Xiubo


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
