Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB89C07E9D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 27 Sep 2022 01:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QgYZ6UwarggZk9rRkUYu3e9jPifTm2uVzS/7W7UQkuY=;
 b=aJDkPoCPF0jDCttTaKHOFqMEQTdj3mEvjPJ+ZH5se4+c2wrgTz47WqtUCFxEsP0Tf6Y2FsH5eSz8
   jwL5kdXKqohXCEh4y9KT7+Jog6iqsLP29HJBmPtdey3bCuHMDCaKbWZ346MY5dtjvHASvgR4fU9M
   TwW+3f9fQHXpDDHTo3EnetYKS5rq1RbAVAKq+Ne4WG6c5SYQ6FpzgcoI/vtj2RRzyJblclr/4KxJ
   ddUlytyaJt6aKnYj9JWHAqeNc5OCjWSrV9RgwJgsWHEaWPc0uRDdB4eUgyvY1ipt4bn+KhZFxAVQ
   ZQMHyst1125jjXnrl1H927lVrcut9Io50uthFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QgYZ6UwarggZk9rRkUYu3e9jPifTm2uVzS/7W7UQkuY=;
 b=TbwrrT0x3iSb2oyp4AJk2RoJycD2P0JD6vZVeJo4Siz5q1NckhXQ+y3Qf64SlfdSYaTGm0/0ntEY
   rElakAiwbyM85TXmy7jXdD/6uQOzjAhYGCw/j6D3eWYfi5+11ELirGMGFm4k2mwvKBCQ2OUBT3SN
   wvYxs56iAbWUAKW6doQGhAALOFv4lO+GrVRuKF1tb9VPV3drUJAYXJSIgW2gMBHQ0yTMocz4/p80
   wYrsd2a/8oFTOx/69ywAUdjbn0ySM2UDAh6NnNUTvflyJSQwObx0HjofsuUDuefPG/gCgiEP3027
   jUeWX4VRHNFg0VCCvJ3RM8UAw72xS71m3qs6ZQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RIU00LF4IISBYC0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 27 Sep 2022 01:52:04 +0000 (GMT)
Message-id: <1081a9ca-38d9-1ee5-e380-bf2dbe422eec@linux.alibaba.com>
Date: Tue, 27 Sep 2022 09:51:39 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Content-language: en-US
To: Rock Li <lihongweizz@inspur.com>, mark@fasheh.com, jlbec@evilplan.org
References: <20220920073638.1358-1-lihongweizz@inspur.com>
In-reply-to: <20220920073638.1358-1-lihongweizz@inspur.com>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10482
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=105
 priorityscore=138 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270009 domainage_hfrom=8566
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix crash issue if access released
 lockres in debugfs
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R951e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0VQpkeU7_1664243499;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: tHquMLFXkwa1mpQu_hu1lgFoBHesY9aA
X-Proofpoint-ORIG-GUID: tHquMLFXkwa1mpQu_hu1lgFoBHesY9aA
Reporting-Meta:
 AAFqXtQlf6oBGz90L65V9bZJBoEsSppzr8jwCV464p+ks7tsfpoPL+8bn0A9/MeH
 8Wd3H8FpQYYfjWLMQdnuE5eL4RBDz9skF0bZViksDvp9xEjRouq3JVca6V3mGkG1
 dk09yyd3OYfmq0xCWU7PPvlHTJRKzyYn/6Xr4CsaqJ6nF2oFV0br7TecO2puyZSu
 +NtOUj00vpUlGRdUMFgOSeo4Oo6or77H0Ex7RNv54iu3BhN5sIeYjo+xbsKSIcA6
 hznwTuRaeKDavI/R62dTzgXOftHAzfbcbxRkicqvJOQMzceNWG3sPyMPPcSlvsBN
 CB2+W8GYp6R/a6SzuZLynk9NyUp0pGJE8U4HBFdHq39O3Rjc8Nj6+wUmhMUXUmHn
 AqtbUIHhVqzPVGgNvsEs00xzQCgvtbk1p/cWwEdQ6zGWbSxUrK2e4rj6D5DPHwr7
 W93CjprkM1cR+v2JtzBzyh5Iwjkjf45ltK3gV7gRA3OTXEUhy7x/c6Ot9iR5kFa5
 7OeNqvTOs87gADjFUsfmgqiXUySfysqhIxwn8Bvgb8c=

Hi,
Sorry for the late reply.
It seems it is indeed an issue and I'll get into it more deeply.
I'm curious about how you figure out this? Is it a real issue you've
encountered?

Thanks,
Joseph

On 9/20/22 3:36 PM, Rock Li wrote:
> Access locking_state of dlm debugfs may cause crash as scene below:
> 
> Proc A:                  Proc that access debuginfo:
> add_lockres_tracking(lockresA)
> ...
>                          ocfs2_dlm_seq_next():
>                            //priv->p_iter_res points to next
>                            //lockres e.g. B. priv->p_tmp_res hold
>                            //copy of lockres A before leave
>                          ocfs2_dlm_seq_show()
> ...
> remove_lockres_tracking(lockres B):
>   //free lockres B, l_debug_list in
>   //priv->p_ter_res is updated but not
>   //priv->p_tmp_res
> ...
>                          ocfs2_dlm_seq_next():
> 			   //priv->p_tmp_res which holds a old copy of
>                            //lockres A, the l_debug_list holds a
>                            //out-of-date succeed pointer, which will
>                            //cause crash as //access invalid memory
>                            iter = v; //priv->p_tmp_res
>                            iter = ocfs2_dlm_next_res(iter, priv)
> 
> The root cause of this issue is that private->p_iter_res acts as the
> agent of accessing lockres and is protected by ocfs2_dlm_tracking_lock
> while p_tmp_res is only a copy of the lockres and will be out-of-dated
> after leave critial region of ocfs2_dlm_tracking_lock. We should use
> priv->p_ter_res as the forward iterater instead.
> 
> Signed-off-by: Rock Li <lihongweizz@inspur.com>
> ---
>  fs/ocfs2/dlmglue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index c28bc98..5d84350 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3109,7 +3109,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
>  	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
>  
>  	spin_lock(&ocfs2_dlm_tracking_lock);
> -	iter = ocfs2_dlm_next_res(iter, priv);
> +	iter = ocfs2_dlm_next_res(dummy, priv);
>  	list_del_init(&dummy->l_debug_list);
>  	if (iter) {
>  		list_add(&dummy->l_debug_list, &iter->l_debug_list);

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
