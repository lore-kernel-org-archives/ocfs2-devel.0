Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE2DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu,  6 Jan 2022 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dY+7+jy1TPDSA+rb+L16n4ESk+TbAaZNriX4KkHX/vI=;
 b=y3ltvAu3Of/mrSO4NFZgmayAtZyYtRSOUBg2k+93lDiAXynIXkFFp/N9PTLmaUZFGluz+QPHEabR
   2U04/KfvZmANWrpzOE/06K/r52T9Zc5tqjPZ9OsChE5L9km/BI4zS4fNaq2kXAsm1gAP0vDPqDx8
   Cox1oNJsEvoNL+Rqws2Mh8UbzN8U58HHRGLTYfRvtoogDEgP+dHF/cRirJdR3VZrs3UvZMAhOz4k
   1WvnDgFakC4ELNc6HYJ9VQAHPzZ4JuoLAOBA3LdxLvgfTOPwQF7U1KVvHu3CcM2TYfZOvYKHfeN8
   Pg+lT4RDw/FablAbKTHGYN4M3OZU34dcDFT/KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dY+7+jy1TPDSA+rb+L16n4ESk+TbAaZNriX4KkHX/vI=;
 b=PbnYBOYMj9zYrlg/QrtrD7r5qvT9KOnZShLSsS9GFdT2Y80sYGOg05r28mviKWefcQ7jtiVvp5Px
   EBMfN64ofrpLeJJnRrgrC+0MZoFKsc5pJCxE/M1Pdbua5QxcduHwve2oBpr329Ly0yx/rBwMgsVv
   Jj8FY8TXWgBGLEdwDlr4jtgjjdt2pvi/Q3ePvyvnB+5X6PlX7nDOBOLp+mKanjUMGjixm2Snz9Sg
   J4yap57R0r1I5aBysTotjjEGCd7M+P0PDzW1i0KwBIAtq1WiOhYhgct0aa3BS9SxwVly+Ct0axAV
   tZBECquE19csigbRalTSTjWHUEuc7+78hH6f+w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5A00ED6DBIYHC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 06 Jan 2022 11:30:54 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <0dd319cf-8e2e-e378-368f-e419d5f9b6a6@linux.alibaba.com>
Date: Thu, 6 Jan 2022 19:29:24 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org
References: <20220106102028.3345634-1-gregkh@linuxfoundation.org>
In-reply-to: <20220106102028.3345634-1-gregkh@linuxfoundation.org>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 clxscore=236
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 priorityscore=178 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060081 domainage_hfrom=8302
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Miguel Ojeda <ojeda@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: cluster: use default_groups in
	kobj_type
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R851e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
 TI=SMTPD_---0V15g75R_1641468564;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: _YGzQpQrxMaSbpBft-HBk21gFmmEqAc4
X-Proofpoint-GUID: _YGzQpQrxMaSbpBft-HBk21gFmmEqAc4
Reporting-Meta:
 AAEx6NmhYvXpUYKmka1yfqek/VoR+l+LHib0389Sw+xfuiDeeFSdTkxDAPAPhN2M
 9giulLAEh4MHALcnw0EPFE96tTDtpW04MY/6UPudbxv0HpEeE1ET2Sd96K7wtclm
 HVhELOC33P/2me4QnI1w4uubDnSD8JBYjFubT3C5+9xOn5IS0q2LOsONPHjhBtHh
 r5hbwe7ixhMy6tfzZgvLnE19UDzLiB3KedwQU0SODGIkkWHCROp6/K/G58Ciq10I
 +ufKMtVXTCPm0CQdaYAFu9VOOmGxzKMCJsi0Ox5Qc4ETyn3nEHKItkQkjzYoGD6M
 P4YS0SAOklfHByS0HP4t1+1obTpcMf0M4Oemkl35TAJxPKA15hLGfP6JTB4ErORK
 hYbB7rqgG2ua+opMZJxMHDLMMxcBWh12AxGtLJdd/tItL9o1I3OZxFusEC+Z4q0H
 oUgAinxHemm3d53WZ7dKJVpmZxLgYL+Ei1pkJ3i0Bjo0d2mA47lDOKx+Aee3hMp8
 X+iLh3wcYxoqMCsddsOpBz/U6Tg1/iZ4wF4Pfv/eqXVM

Reviewed-and-Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

On 1/6/22 6:20 PM, Greg Kroah-Hartman wrote:
> There are currently 2 ways to create a set of sysfs files for a
> kobj_type, through the default_attrs field, and the default_groups
> field.  Move the ocfs2 cluster sysfs code to use default_groups field
> which has been the preferred way since aa30f47cf666 ("kobject: Add
> support for default attribute groups to kobj_type") so that we can soon
> get rid of the obsolete default_attrs field.
> 
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: ocfs2-devel@oss.oracle.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ocfs2/cluster/masklog.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index 810d32815593..563881ddbf00 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -120,7 +120,8 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
>  	define_mask(KTHREAD),
>  };
>  
> -static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
> +static struct attribute *mlog_default_attrs[MLOG_MAX_BITS] = {NULL, };
> +ATTRIBUTE_GROUPS(mlog_default);
>  
>  static ssize_t mlog_show(struct kobject *obj, struct attribute *attr,
>  			 char *buf)
> @@ -144,8 +145,8 @@ static const struct sysfs_ops mlog_attr_ops = {
>  };
>  
>  static struct kobj_type mlog_ktype = {
> -	.default_attrs = mlog_attr_ptrs,
> -	.sysfs_ops     = &mlog_attr_ops,
> +	.default_groups = mlog_default_groups,
> +	.sysfs_ops      = &mlog_attr_ops,
>  };
>  
>  static struct kset mlog_kset = {
> @@ -157,10 +158,10 @@ int mlog_sys_init(struct kset *o2cb_kset)
>  	int i = 0;
>  
>  	while (mlog_attrs[i].attr.mode) {
> -		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
> +		mlog_default_attrs[i] = &mlog_attrs[i].attr;
>  		i++;
>  	}
> -	mlog_attr_ptrs[i] = NULL;
> +	mlog_default_attrs[i] = NULL;
>  
>  	kobject_set_name(&mlog_kset.kobj, "logmask");
>  	mlog_kset.kobj.kset = o2cb_kset;

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
