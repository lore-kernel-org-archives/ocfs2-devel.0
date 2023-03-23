Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91890C74A5B
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oXXu6SQ9jDSIuxfnPCLUkhEMMnrqFu9lbu2gL6GjxN4=;
 b=m7p5u1cClutlPGzJ7cB4OIqKtZYA9X3wXiYgFaTMiFYIzQf7st+RC+BbSajgVWr+nWTcT7P+bJZ7
   Md+EJZ8BgzJm7Iz9IfLnMNvdQRNVPunU/h7NuBqU/mtnkNC29OVWhxN2dRGHJVmFzRHmmfFYixC8
   JEtffmlQ6cskNEgTx7Mwq66nNkgnhhOIydNfT/iAm59NEXS8f9wPvczWwB93czE3BGvCpuYNGShb
   I097BeuBdkxQ4/iCJXMqqtwKgTeUh0brDZQq0ulhIOtuFwB4u1DXALQ291oX5ryBc1ewJGGknZzT
   LtVWqFC6UJd4vBCAgLM6+z1tcciq4wWMADEtsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oXXu6SQ9jDSIuxfnPCLUkhEMMnrqFu9lbu2gL6GjxN4=;
 b=FII4BIm9pplDed4UF+6Ep+C9uMTN3BOMAMAAp2cWVJhmJqb5Iezjv/fgkdMvwNIfVY1GCRj8aNVr
   ITSpV7/uZgagzaeL2oUhz0EbBoSssv73IIxneLmfJMH/HOpO3AqoM8K6YJovy3qo4T0sKZKKWpOU
   dytMt2hBqcP2nJQGvMwoPdGUFfkg6BliuVZm0yM2MGPi5s+iBf2KN9rQQmYHw/svhdsbpZh4uMMJ
   GlzI30PR58d/KR1RjH22kPH5u+KWgmKbzqh0HLOIKnAR98xfSC4RnBV9G57N05D2ADkYQczYw0mY
   bUUO+lo9qBdqvetSalWudll+SfyRSo/PqUgWPQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRZ00A52CFSLA00@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 15:31:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1679574366; bh=hSIUlO1HxyEpsf7qIxo9KBJ0VL8excdKGJYYFukRPL4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=m6MeQSnsMeVy2O0Vk8RTY0vHNrmj2AIgXtab/TGNOFfzWTZud+JQGikV8JyH/6bL2
 HXj5AQv7PGMyWu5gO4aQNckaFR7jMxyPlxC/GN/SkGd9UjEckISINsL0GjCLdhE22C
 5zuGNqdawoE4Z0VJ+MBNSEjFCrSN9mJPfzKZRDpc=
Date: Thu, 23 Mar 2023 13:26:03 +0100
To: Yangtao Li <frank.li@vivo.com>
Message-id: <ZBxFW5Yi0rwLvTsx@kroah.com>
References: <20230322165830.55071-1-frank.li@vivo.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230322165830.55071-1-frank.li@vivo.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10657
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 spamscore=0 clxscore=248 mlxlogscore=305 mlxscore=0 priorityscore=156
 lowpriorityscore=0 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230093
Cc: rafael@kernel.org, linux-mtd@lists.infradead.org, naohiro.aota@wdc.com,
 linux-nilfs@vger.kernel.org, richard@nod.at, trond.myklebust@hammerspace.com,
 xiang@kernel.org, chao@kernel.org, josef@toxicpanda.com, huyue2@coolpad.com,
 dsterba@suse.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
 konishi.ryusuke@gmail.com, linux-nfs@vger.kernel.org, clm@fb.com,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, anna@kernel.org,
 linux-fsdevel@vger.kernel.org, jth@kernel.org, linux-erofs@lists.ozlabs.org,
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 5_msXSSWVuAOJj4k30-Z5yqILHSqkp0I
X-Proofpoint-GUID: 5_msXSSWVuAOJj4k30-Z5yqILHSqkp0I
X-Mailman-Approved-At: Thu, 23 Mar 2023 15:31:02 +0000
Reporting-Meta:
 AAHYQQoMBl0vaD79E44+Kuz6Pmh5OUDWH5P2DyCAVjyHLHo0lLUOpZ7BJZWzqZVO
 s76j8FzvfiK5jrSAaEt1cXIWCD9YA+v8zGai70lMe7yG2G2sJ0uPW4dZfhE6cp2v
 QRycV5sAk8LNbde5G5HHUw4UZ/Mm7VyH8fV58YKMxSSoNUcRskOQrg7oHubOcYoh
 1MyZ4bHJPnVQEp9Oxj8qvO9QqFoOIog/jJJ66p1NpYmFulZMQNGNV3fWJ/uCyZ6A
 QKg2DET7+KCioRSrEXNQrztE/vWk8qgg9BBTixglEoePjIYTNc2U4yY5xJjI/c86
 PTW3s2pkPCVUMsUjme58T06W7VusY+hZAgOG3T8eOtAkh8QxKA8wVxOwGMZRqqlL
 b3YRT6OvVjP/QpR+IyuhlrQV3VyfRnGcwoQ1KHjDVyI83d9CoZx+eiaeUfn12klj
 NuhJqfrqUPmmTGSEl0IdqvTte9M88Spj7HsIgy4bWjmLRpxNty6Wt8T6X5DP56Ar
 yog8KU2EAinVEiV43jVe1wMXw7UPJ4wfuMnO2r37I0ln

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

Meta-comment, something is wrong with this email as it is not linked to
the rest of the series.

You can see that by looking at this message in lore.kernel.org:
	https://lore.kernel.org/r/20230322165830.55071-1-frank.li@vivo.com

No 2-10 patches linked there (they show up as a separate series.)

So even if I wanted to take this series now, we can't as our tools can't
find them...

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
