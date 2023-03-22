Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635BBC6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5nUBlxMcSs+KB2yPCsOMXvrMKNhC+qQ2BsL/x0U13vs=;
 b=I2waamGCoWrZSN91nO4pzR7pM+uRTvv690tXwpmZFIXkpRggfp4RbpDmRYd8mi9WkUBXMhyPhOAW
   WA8OgXyLbRCsA77nJVj+oV/agCmRMnwdSVQANO5NOsCuBTdf3mfflv2EvzlgOCSViUwWY4y+blQg
   vptqAW+vg267tvtM2JI6Q4gpj6r6KaSpULefR3634k/x8XWhvWDayKMdP6bhuyfc+Ebezbntl+hi
   3TWscYzl7iYP7JKCVMloS5dxI68kGL3XOEnGr1L++BvZv+YDJOwUbTYvCYG8xpQIDvneh6dj+YKo
   ybfCEfsn67s3/Nmu0ZIN2dWw9nu7lH5+ZNOeAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5nUBlxMcSs+KB2yPCsOMXvrMKNhC+qQ2BsL/x0U13vs=;
 b=lUEVqbU2J2XnkafUNmv829nTrTu9GnD9iyamswwymndF+yI0hGyI/qjvbNbXcP6TpFLWi24V0gSP
   9Mt3K4Wx+Ahhj6avE/mqxwC4k0YmAo6H/za6AfDsjjRZGKZwSVELJbBhTgaf+ARoJe+SZVVFyutr
   UYpm/NC5AvpEv74tUHq+AcFz1PDJMAbsoTOF6V9SidyO9IlmE7G5du9eDQ+nYNnQu7T8/jRV5ajC
   2QQSA5xDandf9iE1f6j1Cey+anoVRIs/oOMqt0nEQahZLBzwnBiIEGv+tDU99eK3OKx/AMTdERD0
   PkfNMnO0R731+XoBeNP1pTWVSRA+oilAV07NhQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRZ00MXXCFSY6A0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 15:31:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1679527901; x=1711063901;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=q9SHaaGc/iP3oUCDDkuobziv3fI8u5euiS4kcHH3kx8=;
 b=fGhRed7WUoBjrjIdo4SbgQTMXCrstuKgASuBx7XNAXQN0YaV+AMAN1yG
 j55E2Nu/B9SeI6f3KJA+T85/IiyJa4CKYthtznw0L8zl4SSlERw09AYsT
 r1M3pubMRYC80SnXkacb8ErZ8vQCQ83laKkGI26ht6qrhA0iOpKeh+n51
 5UJXuFZg3S8bUYmSeCCX3LnjKTvW3RavK7qHeP2bFthwfbOIRsRX18G9T
 VuiwQ4ozDq2Xy2n7CnlxMCdiztNRTVZufAifXJXe3o+OtLOdygtmlzDjF
 GKnVgaW4571LNr9qj5vTeNXAuqc5aXIlignCRvVFKgeO/37xhQ+yt2F7t w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d= opensource.wdc.com;
 h=content-transfer-encoding:content-type
 :in-reply-to:organization:from:references:to:content-language
 :subject:user-agent:mime-version:date:message-id; s=dkim; t= 1679527898;
 x=1682119899; bh=q9SHaaGc/iP3oUCDDkuobziv3fI8u5euiS4 kcHH3kx8=;
 b=jXOcAHSjzQp3Y8DRAhI7Eqaykde0th0S9alUrID1c2LCC3wfAb9
 gKLpCqhNvhXIVpoACyCWdORhWPyVwcLyv+I3A4HyVbq47iykpBBgezzTIryrgP44
 YEKzud94Zk+Y8HC/UY2RnSvJBZedTJ3OfzPeXnPWHU3PAOtYg4P8hX2IvtQ6yBhi
 j4r/QQvfwmqbzwmimzdJGIuPI0o0MfJdBhX8DuQYGVDi4A2JABTEyXrQamz1e+uF
 +gUlyjlv0VsY1s6/lX1w99QOTvab/kA98gC8MKGuF5bkUAv65So0qyJzKTEypPY0
 ciNq+kgkTDjVCQlQD4ZfSdBBlYkyJL09/6w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Message-id: <5e7e8187-f514-c65e-2615-26762a329590@opensource.wdc.com>
Date: Thu, 23 Mar 2023 08:31:30 +0900
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
 trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
References: <20230322165830.55071-1-frank.li@vivo.com>
Organization: Western Digital Research
In-reply-to: <20230322165830.55071-1-frank.li@vivo.com>
X-Source-IP: 68.232.141.245
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10657
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 adultscore=0 malwarescore=0 priorityscore=169 suspectscore=0 mlxlogscore=999
 clxscore=185 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220171 domainage_hfrom=11268
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
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
From: Damien Le Moal via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.98,282,1673884800"; d="scan'208";a="338330688"
X-ServerName: esa1.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 exists:%{i}.spf.hgst.iphmx.com
 ip4:199.255.45.14/32 ip4:199.255.45.15/32 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: QxicB4QObY7fZrFF2poey14bk95DP_tK
X-Proofpoint-GUID: QxicB4QObY7fZrFF2poey14bk95DP_tK
X-Mailman-Approved-At: Thu, 23 Mar 2023 15:31:02 +0000
Reporting-Meta:
 AAG4y4RCoAEJ0pnpfCom0gO2tbhY+ctldFHSIKjbo8f4ferJi7XfXrq2pcIrxZnj
 RnMs4rFlj+IJeMBMDQOcc7kMBQAZiUeD1klhFADOsf1+9MYE1p67ewjvTksttOKC
 zpjgrQI3qKNWxIHu7fuEJEA7NAwKiodty8JxW9AVz0H15ac35U8o+krddN71MYhk
 v5dYHlur2IgdhfadmzrDmjovBTvMEFuKdFTPeN7iQBQSR7B/Qq9/ohohi3aaj7Bg
 O6ZrYk0Xvn81gSEhSAp1kcKn5TYOPNhPAaIL4ab53nYzQTlQmA3siENm41U1ISLc
 Xblp+miOoRkNY4E/JE9DQHpEnRkuJimuGsfNNwdcEbPJ7H2X1eI6IUmrjvYMaySr
 iKygeHkrnsN+W2JZkri8l/ldm9CAV7c0s6AEqEo9auKynW0KQXJEndi4JYo7YqG4
 9YdP/3Ls27ea+F86fLk/QLqQFy3PPKbvmjnEg/lOb8NW2Z0YuTeyQ9cOuGPpyIdP
 Htgrku8O/rI9POedXdQ0MA0PSiPDdQFE5Jk+Ker9yP2v
IronPort-SDR:
 AWTj92Lav/wQoikEN0RVrgIjOEOfHuVPhOodrXwY7LNyN8yEJxzyafORvyQw4mRZ5Vz1cF6Qjz
 1tDQQL/ia8yN7eWWDQ/+qgDGeVAteQl89eiSmrpgeVYzHcwq390EMpIaUQwuPTzKLNc79coGpN
 Q4Ht1H9JIwilktkuxx6SyvHDroQSFDdh2XXs4vI0nJYnbjq/tMMxJNvs9VxcmJ7JpvevDzWQkb
 nFD/RmsyC6T7KhhlWAktzDHy2fqt8HwnePRbLRidnWu2jQEsHTOrTmByhp4pq7NzJGcGyWvFmM 69o=
IronPort-SDR:
 I4QX4jl3h69oqtub3Ux0rPoGRB9jk/x8YedPUm5NtFt+6/t5dvX2ET445vCQhC/vUcresbLJGi
 2Uf2cy3Y23X/saLufV9HH0mJUfLFNziiBe5FAMyHHPFKnl6ltm8LusMdsbnGuUm14TT06E9k5X
 bG9kk8f/yJPcL1HBkpihZxzD+YeP7xqoMJ7uovTFohqr/ixaj19+73QtZuI/uwyRsFSoyIZ+N2
 DTB3wRUgCXS9s+D3kBn2SEotosDB7AYw98xYOO7vwbR3vrdUfbP9XOVdgFHxK3EC8wyVD5HcNn Ks8=
WDCIronportException: Internal

On 3/23/23 01:58, Yangtao Li wrote:
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

Unlink kobject from hierarchy and decrement its refcount.

> + * If refcount is 0, call kobject_cleanup().

That is done by kobject_put() and not explicitly done directly in this helper.
So I would not mention this to avoid confusion as you otherwise have a
description that does not match the code we can see here.

With that fixed, this looks OK to me, so feel free to add:

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> + */
> +static inline void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}
> +
>  extern const void *kobject_namespace(const struct kobject *kobj);
>  extern void kobject_get_ownership(const struct kobject *kobj,
>  				  kuid_t *uid, kgid_t *gid);
> diff --git a/lib/kobject.c b/lib/kobject.c
> index f79a434e1231..e6c5a3ff1c53 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -876,8 +876,7 @@ void kset_unregister(struct kset *k)
>  {
>  	if (!k)
>  		return;
> -	kobject_del(&k->kobj);
> -	kobject_put(&k->kobj);
> +	kobject_del_and_put(&k->kobj);

Nit: You could simplify this one to be:

	if (k)
		kobject_del_and_put(&k->kobj);

and drop the return line.

>  }
>  EXPORT_SYMBOL(kset_unregister);
>  

-- 
Damien Le Moal
Western Digital Research


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
