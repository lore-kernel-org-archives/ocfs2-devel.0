Return-Path: <SRS0=s8PX=HL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55065C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 09:46:27 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2C7964DDF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 09:46:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2C7964DDF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1199U1JT173060;
	Tue, 9 Feb 2021 09:46:26 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 36hkrmxtdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Feb 2021 09:46:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1199UdeC049404;
	Tue, 9 Feb 2021 09:46:25 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36j4vr3g6b-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Feb 2021 09:46:25 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l9PbE-0007MX-3r; Tue, 09 Feb 2021 01:46:24 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l9PbC-0007MA-4Z
	for ocfs2-devel@oss.oracle.com; Tue, 09 Feb 2021 01:46:22 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1199V0Nx168174
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 09:46:21 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 36j51vut4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 09:46:21 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1199XEtj044584
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 09:46:21 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36hhqu3p5e-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 09:46:20 +0000
X-IronPort-AV: E=Sophos;i="5.81,164,1610380800"; d="scan'208";a="104368304"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 09 Feb 2021 17:46:18 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 7E31B4CE6F81;
	Tue,  9 Feb 2021 17:46:13 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 9 Feb 2021 17:46:12 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
	<9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
	<20210209093438.GA630@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
Date: Tue, 9 Feb 2021 17:46:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209093438.GA630@lst.de>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 7E31B4CE6F81.AEF5B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 adultscore=0
	spamscore=0 bulkscore=0 clxscore=229 malwarescore=0 suspectscore=0
	priorityscore=178 mlxscore=0 mlxlogscore=840 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102090046
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	1199V0Nx168174
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 5/7] fsdax: Dedup file range to use a
	compare function
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090046
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1034
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090046

CgpPbiAyMDIxLzIvOSDkuIvljYg1OjM0LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBPbiBU
dWUsIEZlYiAwOSwgMjAyMSBhdCAwNToxNToxM1BNICswODAwLCBSdWFuIFNoaXlhbmcgd3JvdGU6
Cj4+IFRoZSBkYXggZGVkdXBlIGNvbXBhcmlzb24gbmVlZCB0aGUgaW9tYXBfb3BzIHBvaW50ZXIg
YXMgYXJndW1lbnQsIHNvIG15Cj4+IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB3ZSBkb24ndCBtb2Rp
ZnkgdGhlIGFyZ3VtZW50IGxpc3Qgb2YKPj4gZ2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3ByZXAo
KSwgYnV0IG1vdmUgaXRzIGNvZGUgaW50bwo+PiBfX2dlbmVyaWNfcmVtYXBfZmlsZV9yYW5nZV9w
cmVwKCkgd2hvc2UgYXJndW1lbnQgbGlzdCBjYW4gYmUgbW9kaWZpZWQgdG8KPj4gYWNjZXB0cyB0
aGUgaW9tYXBfb3BzIHBvaW50ZXIuICBUaGVuIGl0IGxvb2tzIGxpa2UgdGhpczoKPiAKPiBJJ2Qg
c2F5IGp1c3QgYWRkIHRoZSBpb21hcF9vcHMgcG9pbnRlciB0bwo+IGdlbmVyaWNfcmVtYXBfZmls
ZV9yYW5nZV9wcmVwIGFuZCBkbyBhd2F5IHdpdGggdGhlIGV4dHJhIHdyYXBwZXJzLiAgV2UKPiBv
bmx5IGhhdmUgdGhyZWUgY2FsbGVycyBhbnl3YXkuCgpPSy4KCgotLQpUaGFua3MsClJ1YW4gU2hp
eWFuZy4KPiAKPiAKCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
