Return-Path: <SRS0=6hlh=KG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC95C433B4
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 02:17:31 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 150956162B
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 02:17:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 150956162B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B2Esf4004718;
	Tue, 11 May 2021 02:17:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 38djkmd4s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 02:17:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B2FwqB162519;
	Tue, 11 May 2021 02:17:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38e4dt9vj8-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 11 May 2021 02:17:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lgHxe-0002wl-5A; Mon, 10 May 2021 19:17:26 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1lgHx9-0002vq-DM
	for ocfs2-devel@oss.oracle.com; Mon, 10 May 2021 19:16:55 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14B2FxAB162611
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 02:16:55 GMT
Received: from oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 38e4dt9up4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 02:16:55 +0000
Received: from userp2040.oracle.com (userp2040.oracle.com [127.0.0.1])
	by pps.ucf-imr (8.16.0.36/8.16.0.36) with SMTP id 14B2EXfn007911
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 02:16:54 GMT
Received: from out30-131.freemail.mail.aliyun.com
	(out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by userp2040.oracle.com with ESMTP id 38evq0mf6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 02:16:54 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UYUn5Xl_1620699407; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0UYUn5Xl_1620699407) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 11 May 2021 10:16:48 +0800
To: Wengang Wang <wen.gang.wang@oracle.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
References: <1620643062-124920-1-git-send-email-jiapeng.chong@linux.alibaba.com>
	<1EED85DE-EFE1-4FBA-9AA5-648D8E586DD9@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <2c9b7d34-01b9-d7de-2334-5d684d29d4eb@linux.alibaba.com>
Date: Tue, 11 May 2021 10:16:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1EED85DE-EFE1-4FBA-9AA5-648D8E586DD9@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.131
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	suspectscore=0
	mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0
	impostorscore=0 phishscore=0 clxscore=286 priorityscore=140 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105110014
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	14B2FxAB162611
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Reomve err less than zero check
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110015
X-Proofpoint-GUID: YuNl1-l7gb0AeRCC1In_QW0gq7B5S5TE
X-Proofpoint-ORIG-GUID: YuNl1-l7gb0AeRCC1In_QW0gq7B5S5TE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1034 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110015

CgoKT24gNS8xMC8yMSAxMTo1MCBQTSwgV2VuZ2FuZyBXYW5nIHdyb3RlOgo+IEhpIEppYXBlbmcs
Cj4gCj4gVGhvdWdoIHRoZSB0eXBlIG9mIGVudW0gZGxtX3N0YXR1cyBoYXMgYSB2YWx1ZSByYW5n
ZSBzdGFydGluZyBmcm9tIHplcm8sICBJdCBjYW4gYmUgYXNzaWduZWQgd2l0aCBuZWdhdGl2ZSB2
YWx1ZXMgd2l0aG91dCB3YXJuaW5ncy4KPiBJIGFtIHdvbmRlcmluZyB3aHkgeW91IGFyZSBzdXJl
IGl0IGNhbuKAmXQgYmUgbmVnYXRpdmU/ICBZb3Ugd2VudCBvdmVyIGFsbCB0aGUgY2FsbGluZyBw
YXRoIGFuZCBzbyB5b3UgYXJlIHN1cmUgaXQgY2Fu4oCZdCBiZSBuZWdhdGl2ZT8KPiBJZiB5b3Ug
ZGlkIHRoYXQsIEnigJlkIHRoaW5rL2d1ZXNzIHlvdSBzaG91bGQgYWxzbyBiZSBhYmxlIHRvIHNh
eSBpdCBjYW7igJl0IGJlIERMTV9NQVhTVEFUUyBvciBiaWdnZXIsIHJpZ2h0PyBJZiBub3QsIHdo
aWNoIGNhbGxpbmcgcGF0aCBhcmUgcmV0dXJuaW5nID49IERMTV9NQVhTVEFUUyB2YWx1ZT8KPiB3
ZSBzaG91bGQgZml4IHRoYXQgdG9vLgo+IAo+IEnigJlkIHRoaW5rIHdlIHNob3VsZCB0cmVhdCB0
aGUgdHdvIGNvbmRpdGlvbnMgb2YgKGVyciA+PSBETE1fTUFYU1RBVFMpIGFuZCB0aGUgKGVyciA8
IDApIHRoZSBzYW1lIHdheS4gIElmIGtlZXAsIGtlZXAgYm90aC4gaWYgcmVtb3ZlLCByZW1vdmUg
Ym90aC4KPiBJ4oCZbSBzdXNwZWN0aW5nIHRoZSBjb2NjaWNoZWNrIHdhcm5pbmcgaXMgYmFzZWQg
b24gdGhlIHR5cGUgb2YgZW51bSAoc3RhcnRpbmcgd2l0aCAwKSwgYnV0IGlmIHRoYXTigJlzIHRo
ZSBvbmx5IHRoZW9yeSB0byByZW1vdmUgKGVyciA8IDApLCBJdOKAmXMgTkFLIGZyb20gbWUKRExN
X01BWFNUQVRTIGlzIGEgdmFsaWQgdmFsdWUgZm9yIGRsbV9zdGF0dXMuClRha2UgYSBsb29rIGFn
YWluLCBJIGFncmVlIHdpdGggV2VuZ2FuZyB0aGF0IHdlJ2QgYmV0dGVyIGtlZXAgdGhlIGNoZWNr
CmhlcmUgZm9yIHRob3NlIG1pc3VzZWQgcmV0dXJuIGNvZGUuCgpUaGFua3MsCkpvc2VwaCAKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVs
IG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFj
bGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
