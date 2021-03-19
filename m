Return-Path: <SRS0=/zwX=IR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81D9C433E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 07:27:50 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4625764F62
	for <ocfs2-devel@archiver.kernel.org>; Fri, 19 Mar 2021 07:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4625764F62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J7LFE9174400;
	Fri, 19 Mar 2021 07:27:49 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37a4ekxumg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Mar 2021 07:27:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J7Pemj087982;
	Fri, 19 Mar 2021 07:27:48 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37cf2befba-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 19 Mar 2021 07:27:48 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lN9Us-0004hp-0w; Fri, 19 Mar 2021 00:24:38 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lN9Uo-0004hP-Ts
	for ocfs2-devel@oss.oracle.com; Fri, 19 Mar 2021 00:24:34 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12J7K3AH054627
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 07:24:34 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3020.oracle.com with ESMTP id 37cf2v5h37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 07:24:34 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12J7F5tD033861
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 07:24:33 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by userp2040.oracle.com with ESMTP id 37axjvt749-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 19 Mar 2021 07:24:33 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0USWnDpi_1616138664; 
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0USWnDpi_1616138664) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 19 Mar 2021 15:24:24 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: ocfs2-devel@oss.oracle.com
Date: Fri, 19 Mar 2021 15:24:24 +0800
Message-Id: <1616138664-35935-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-PDR: PASS
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	bulkscore=0
	lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=0
	impostorscore=0 phishscore=0 mlxlogscore=999 clxscore=200 spamscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103190048
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	12J7K3AH054627
Cc: Gang He <GHe@suse.com>, Yang Li <yang.lee@linux.alibaba.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: map flags directly in flags_to_o2dlm()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190050
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190049

VXNlIG1hY3JvIG1hcF9mbGFnKCkgaXMgdHJpY2t5IGFuZCBjb2NjaWNoZWNrIG91dHB1dHMgdGhl
IGZvbGxvd2luZwp3YXJuaW5nOgpmcy9vY2ZzMi9zdGFja19vMmNiLmM6Njk6NS0xNjogVW5uZWVk
ZWQgdmFyaWFibGU6ICJvMmRsbV9mbGFncyIuClNvIG1hcCBmbGFncyBkaXJlY3RseSBpbiBmbGFn
c190b19vMmRsbSgpIHRvIG1ha2UgY29jY2ljaGVja8KgaGFwcHkuCkFuZCByZW1vdmUgQlVHX09O
KCkgaGVyZSBhcyB3ZWxsIHRvIHNpbXBsaWZ5IGNvZGUgc2luY2UgaXQgcnVucyB3ZWxsCmEgbG9u
ZyB0aW1lLgoKU2lnbmVkLW9mZi1ieTogSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFi
YS5jb20+Ci0tLQogZnMvb2NmczIvc3RhY2tfbzJjYi5jIHwgMzYgKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMTgg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvb2NmczIvc3RhY2tfbzJjYi5jIGIvZnMvb2Nm
czIvc3RhY2tfbzJjYi5jCmluZGV4IGRiZjhiNTcuLmY3MDAxMjAgMTAwNjQ0Ci0tLSBhL2ZzL29j
ZnMyL3N0YWNrX28yY2IuYworKysgYi9mcy9vY2ZzMi9zdGFja19vMmNiLmMKQEAgLTU5LDMxICs1
OSwzMSBAQCBzdGF0aWMgaW5saW5lIGludCBtb2RlX3RvX28yZGxtKGludCBtb2RlKQogCXJldHVy
biBtb2RlOwogfQogCi0jZGVmaW5lIG1hcF9mbGFnKF9nZW5lcmljLCBfbzJkbG0pCQlcCi0JaWYg
KGZsYWdzICYgKF9nZW5lcmljKSkgewkJXAotCQlmbGFncyAmPSB+KF9nZW5lcmljKTsJCVwKLQkJ
bzJkbG1fZmxhZ3MgfD0gKF9vMmRsbSk7CVwKLQl9CiBzdGF0aWMgaW50IGZsYWdzX3RvX28yZGxt
KHUzMiBmbGFncykKIHsKIAlpbnQgbzJkbG1fZmxhZ3MgPSAwOwogCi0JbWFwX2ZsYWcoRExNX0xL
Rl9OT1FVRVVFLCBMS01fTk9RVUVVRSk7Ci0JbWFwX2ZsYWcoRExNX0xLRl9DQU5DRUwsIExLTV9D
QU5DRUwpOwotCW1hcF9mbGFnKERMTV9MS0ZfQ09OVkVSVCwgTEtNX0NPTlZFUlQpOwotCW1hcF9m
bGFnKERMTV9MS0ZfVkFMQkxLLCBMS01fVkFMQkxLKTsKLQltYXBfZmxhZyhETE1fTEtGX0lWVkFM
QkxLLCBMS01fSU5WVkFMQkxLKTsKLQltYXBfZmxhZyhETE1fTEtGX09SUEhBTiwgTEtNX09SUEhB
Tik7Ci0JbWFwX2ZsYWcoRExNX0xLRl9GT1JDRVVOTE9DSywgTEtNX0ZPUkNFKTsKLQltYXBfZmxh
ZyhETE1fTEtGX1RJTUVPVVQsIExLTV9USU1FT1VUKTsKLQltYXBfZmxhZyhETE1fTEtGX0xPQ0FM
LCBMS01fTE9DQUwpOwotCi0JLyogbWFwX2ZsYWcoKSBzaG91bGQgaGF2ZSBjbGVhcmVkIGV2ZXJ5
IGZsYWcgcGFzc2VkIGluICovCi0JQlVHX09OKGZsYWdzICE9IDApOworCWlmIChmbGFncyAmIERM
TV9MS0ZfTk9RVUVVRSkKKwkJbzJkbG1fZmxhZ3MgfD0gTEtNX05PUVVFVUU7CisJaWYgKGZsYWdz
ICYgRExNX0xLRl9DQU5DRUwpCisJCW8yZGxtX2ZsYWdzIHw9IExLTV9DQU5DRUw7CisJaWYgKGZs
YWdzICYgRExNX0xLRl9DT05WRVJUKQorCQlvMmRsbV9mbGFncyB8PSBMS01fQ09OVkVSVDsKKwlp
ZiAoZmxhZ3MgJiBETE1fTEtGX1ZBTEJMSykKKwkJbzJkbG1fZmxhZ3MgfD0gTEtNX1ZBTEJMSzsK
KwlpZiAoZmxhZ3MgJiBETE1fTEtGX0lWVkFMQkxLKQorCQlvMmRsbV9mbGFncyB8PSBMS01fSU5W
VkFMQkxLOworCWlmIChmbGFncyAmIERMTV9MS0ZfT1JQSEFOKQorCQlvMmRsbV9mbGFncyB8PSBM
S01fT1JQSEFOOworCWlmIChmbGFncyAmIERMTV9MS0ZfRk9SQ0VVTkxPQ0spCisJCW8yZGxtX2Zs
YWdzIHw9IExLTV9GT1JDRTsKKwlpZiAoZmxhZ3MgJiBETE1fTEtGX1RJTUVPVVQpCisJCW8yZGxt
X2ZsYWdzIHw9IExLTV9USU1FT1VUOworCWlmIChmbGFncyAmIERMTV9MS0ZfTE9DQUwpCisJCW8y
ZGxtX2ZsYWdzIHw9IExLTV9MT0NBTDsKIAogCXJldHVybiBvMmRsbV9mbGFnczsKIH0KLSN1bmRl
ZiBtYXBfZmxhZwogCiAvKgogICogTWFwIGFuIG8yZGxtIHN0YXR1cyB0byBzdGFuZGFyZCBlcnJu
byB2YWx1ZXMuCi0tIAoxLjguMy4xCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5v
cmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1k
ZXZlbA==
