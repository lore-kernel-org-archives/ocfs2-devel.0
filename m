Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87DAC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Jun 2022 08:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uXne7UP8fQInKPvdL2AnXJJwqX7BHUIuDX5Wq1/1BNw=;
 b=XVnvQho6wSSP6J0ARP4jaA89sLmpUB9x8zbC7bQ7NFrLTgtIwjMoCpxLAQRtp07yr6oHKqTH1bdq
   ovQDR1VIsyjKOMcN5WRKFowi51wCC1xFJoMhl2FAz5bIuQPRIvrqW3cNOW7Cq91IaGWMhCviDChZ
   NGmu+paAaM9IuB9LOaf+bnPAgNxlvyYOXjGMOjON5d6Wdk+A9hcGzPqzKGH0IgBzfaXeEq6weKSU
   3eA2Ve8EKGK1XhH8/hN6OuKf3pmg+PEa/xMlQW5up8fnh0QNcQL1dKh7+s3aqK2rd/alReSx92tg
   +/K+4UMAeQinQelYC4H9BSUfG6ecGTGH6aImdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uXne7UP8fQInKPvdL2AnXJJwqX7BHUIuDX5Wq1/1BNw=;
 b=ML7Fcqx835SNqhyseEfLG2D64Lnvx2Bo/rXHSv31eRcAwOfWOwIZtEMnIa7WnruIxuw51rPHkhTZ
   sHMpce9jSsHRwy+ZlhHf5PrTPh0qPa2MgGJutARU93VrpkP0+VTJryKcFOfP9/CiHcPZ8+MqwCZ3
   q89uU+DbLWIiqX0/x836NrjBsZMot65UlnIfVTe7+FUuFPtA+8qxd+4BsT1O9ZVjq2NCaD1wxuAb
   ykEj3aaNjl/I4NBACo+iQltnWsm5nsH/TniWeQecEcc873XUEs6pYss5Tbn5Vjl/+oXFGFPNnrwB
   eHlvL1gtf2g4IUdbpMCmbGICqR5TVglRl8UJoQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDE00F92PVHY2B0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 13 Jun 2022 08:21:17 +0000 (GMT)
Message-id: <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
Date: Mon, 13 Jun 2022 16:21:01 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
In-reply-to: <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10376
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=939
 priorityscore=0 clxscore=88 mlxscore=0 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130038 domainage_hfrom=8460
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R891e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VGCh8NH_1655108461;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: _aGujjZkUnafY_IyyvW3k5Hcs0q0m4cr
X-Proofpoint-ORIG-GUID: _aGujjZkUnafY_IyyvW3k5Hcs0q0m4cr
Reporting-Meta:
 AAEaTinFhT4LtGHip59e8RA7S+D4knhBFCQzqHYAFbQnNOf13SwFXeORofX5irtr
 +fcdBWrTnxejrS+AB+JqL/0Sk2E8tKccZ70dQ0o5wiF0EOTGQur/EKHo8tppKwsm
 URY0IMZoSc+NHWeOhCFiwKmA9PxMBX0O2huZ52h+B7PfMR3BCXMDkHBSTPSXhpeO
 pEmSMxIpanvgNxkWJpnF7ln1zp/eJP3XyM/tA+zN0d5tGxcKhKYIJBQ1Xw4ASbCV
 O8cPT5gEL4G//JCuDLQBVPWJjSUAK5yQXVOelVsRBsz1O4rpmIKLYfWeubqe1ctE
 2sHEmiFdjFFhOSmKqkgyuFE+dwIa1x1TPaH8U1hKnxcEjeQ196vR14b2bkoaIDEy
 eDBc4Hw1b/EGLQNt/xO7E2eZYwyN9tvG8OnP1e3N+LLIFpFc0012QalDDyXlgU7x
 Gp5NXkS1CFkb4kV0XbaP6k7XIajb1ckzBsqUVnvqtdOUBDGs+bXVaZmlvjAsB2iY
 MgARBuwGyjTrl9+5KQuAmtSc952nkXyOGJxvo5TYZSg=



On 6/13/22 3:59 PM, heming.zhao@suse.com wrote:
> On 6/12/22 22:16, Joseph Qi wrote:
>> Hi,
>>
>> Why can't use local mount? I don't remember if we discuss about this.
>>
> Sorry, I can't follow your question.
> Do you mean why revert commit 912f655d78c5?
> 
> or you are interest with the feature local mount?
> the local mount is created by mkfs.ocfs2, which can't be converted to clustered.
> see mkfs.ocfs2(8) '-M' option.
> 
What Junxiao's main concern is data corruption, so I'm afraid we have to
introduce an ondisk feature bit to prevent mixed nocluster and cluster
mount, similar to local mount.
Another scenario is journal replay after crash.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
