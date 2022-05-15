Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84036C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 15 May 2022 14:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F51NnLHcdUcMwktZ2RA5Z7M4l7AhGDTww1pvY7xFBTQ=;
 b=UrZT7MNP/dHrSLvLJcTnkCJd1+9l0dMYzTXcEdekC2OLz/wa0luLA98McIiqgSgMbtsGnCuANqVF
   b+CXPpArJR2zWcNRE6QMeFC1P3i8CBP5/nlKORhyhk4lY6tOZIV/46YY894lWNG/ARLgeaPwxfJZ
   T/zQQ44NxfCdHtVYpo7b3qVx8o8blkp2bn+93zdooiD9AC+I7QRJItoLBicVy6w4itQykiV6xiVN
   Yed7/TMH4HbNWpGMB9FpLg5WZweawkHpspvYGliRHN2xohwMZrvPLgn6KpuzMZrh+3nKIkgliI2O
   0z4iWX9DHMbE2PWdtY9CZMHJziHFSZAJftKK7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F51NnLHcdUcMwktZ2RA5Z7M4l7AhGDTww1pvY7xFBTQ=;
 b=EhLPXeJ4NAaUmxwAKAaSiDBxCHnOFvlBM5CCEBTmCihSJq9O2drBaJ+ZMjD5jrgontTNgmKYgfgc
   FjZqwrgagm89KvwXPUp0G1sqcYaBQIKtj23I1iBN1UlGIU4FR/zra4yDv5lIcY5lwoAU9b7R0j2i
   +LjxAPzZhuXVDC4Px/9to0jFxDD6yAn7BKdmPrS4hBijHIZ3B0e7VtBjdtHldxp4zWBwu2+BZ4wG
   ng0FcNKsfhlzuVTh80YTrMvXtOt31PhLrxx79liqsaKdGq24hd3kW4O5ZR8GGoRgS9HSzY4TFr0e
   4aU3HXVgXS8+gS5brGkVSnI/GKgXuKpMTNwjPg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBX00J6CIWT2690@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 15 May 2022 14:58:05 +0000 (GMT)
Message-id: <7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com>
Date: Sun, 15 May 2022 22:57:45 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
 <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
 <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
In-reply-to: <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
X-Source-IP: 47.90.199.16
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10348
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 clxscore=132 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205150082 domainage_hfrom=8431
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: dlmfs: not clear
 USER_LOCK_ATTACHED when destroy lock
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VDAz3Yz_1652626665;
X-ServerName: out199-16.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: XvznyzEmKQE7wFkWr0_MQ3aus4VRYeFv
X-Proofpoint-ORIG-GUID: XvznyzEmKQE7wFkWr0_MQ3aus4VRYeFv
Reporting-Meta:
 AAH+Bzo6zZH6DwvOo308Tv8fAzQHnb/NhuJRWvPbW0l3YGAVeN5Tsf9RwLT5r60K
 uY3ZpJvj4B1++BQbBOuITW8iozrQt0gSjOXz/vEzoPk6GOKOTQR+zfnCx3z7xBiu
 b827HzBh5VdnG0HgvR7Gfiu3lnWvyZtm3jX0cz1sIHz2xzb1N3xAVknLUqXQcV3Y
 W8SEcwPWz66iaUEK6ojYDw9JztnONfvyuhx/GSn2eMexVgq85gQ9btOLucl4Gi/J
 JrRDpTyitnMxrlE46Whn9h38OGwevHsbFI3laDL2xOxFGkYh3cg/cF1PrlRHkixC
 m1izKEI4P1/kbYpnlc5SNcwabqxy+uat+O/jEmqoq15cICLMiL4YyL/iKlb9OWp4
 lKHJDRPDCxF5MAtK7P7ChMX6D1CRK+99ilwakly+fdYQB7lNdf/Vp7gKRrGLGERX
 7Ghez8EV4/xN282RJWsnI+NQENE783moJuQwlINS9eeMsfsDU1eWQo4ffUPMotpt
 prsUoxHg5iGB0FIHojzXpkzrg1wkMm64CVS4hwdU1SBD



On 5/14/22 12:27 AM, Junxiao Bi wrote:
> On 5/12/22 7:05 PM, Joseph Qi wrote:
> 
>>
>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>> this flag is set when lock request is granted through user_bast() and
>>> only the following function will clear it.
>>>
>> user_ast?
> Good catch, that's a typo, should be user_ast.
>>
>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>> issued if this lock is never granted. For example, lock file is created
>>> and then get removed, open file never happens.
>>>
>>> Clearing the flag here is not necessary because this is the only function
>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>> check USER_LOCK_ATTACHED.
>>> Drop the clear, so we don't need take care it for the following
>>> error handling patch.
>>>
>> Seems it depends on initializing lockres every time, but it seems this
>> is not true for directory now.
> 
> Sorry, i didn't get this. Can you elaborate this?
> 
lockres may be reused and if we don't reinitialized, the left flag can
cause unexpected behavior.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
