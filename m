Return-Path: <SRS0=wAx7=IV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590ABC433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:46:29 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A2759619BF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2759619BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFiwrr005715;
	Tue, 23 Mar 2021 15:46:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37d8fr7k1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Mar 2021 15:46:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFeACm099881;
	Tue, 23 Mar 2021 15:46:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37dtts3wjr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 23 Mar 2021 15:46:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lOjEg-0003J6-7k; Tue, 23 Mar 2021 08:46:26 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <kilobyte@angband.pl>) id 1lL45m-0004fA-Dh
	for ocfs2-devel@oss.oracle.com; Sat, 13 Mar 2021 05:14:06 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DDABbt034835
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 13:14:06 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 378keb07jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 13:14:06 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DD4XBt011050
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 13:14:05 GMT
Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	by userp2030.oracle.com with ESMTP id 378kegt7vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 13:14:04 +0000
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94)
	(envelope-from <kilobyte@angband.pl>)
	id 1lL3yz-00GJp4-Ak; Sat, 13 Mar 2021 14:07:05 +0100
Date: Sat, 13 Mar 2021 14:07:05 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <YEy4+SPUvQkL44PQ@angband.pl>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
	<20210310142643.GQ3479805@casper.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310142643.GQ3479805@casper.infradead.org>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
X-PDR: PASS
X-Source-IP: 51.83.246.204
X-ServerName: tartarus.angband.pl
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:89.73.149.240/32 ip6:2001:470:64f4::/48
	ip4:51.83.128.138/32
	ip6:2a02:a31c:8245:f980::/64 ip4:51.83.246.204/31 ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9921
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	phishscore=0 impostorscore=0 mlxlogscore=360 mlxscore=0 spamscore=0
	malwarescore=0 adultscore=0 priorityscore=0 clxscore=224 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103130099
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	12DDABbt034835
X-Mailman-Approved-At: Tue, 23 Mar 2021 08:46:25 -0700
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, darrick.wong@oracle.com,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        Neal Gompa <ngompa13@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 00/10] fsdax,
	xfs: Add reflink&dedupe support for fsdax
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230115
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230115

T24gV2VkLCBNYXIgMTAsIDIwMjEgYXQgMDI6MjY6NDNQTSArMDAwMCwgTWF0dGhldyBXaWxjb3gg
d3JvdGU6Cj4gT24gV2VkLCBNYXIgMTAsIDIwMjEgYXQgMDg6MjE6NTlBTSAtMDYwMCwgR29sZHd5
biBSb2RyaWd1ZXMgd3JvdGU6Cj4gPiBEQVggb24gYnRyZnMgaGFzIGJlZW4gYXR0ZW1wdGVkWzFd
LiBPZiBjb3Vyc2UsIHdlIGNvdWxkIG5vdAo+IAo+IEJ1dCB3aHk/ICBBIGNvbXBsZXRlbmVzcyBm
ZXRpc2g/ICBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSBkZWNpZGVkCj4gdG8gZG8gdGhpcyB3
b3JrLgoKKiB4ZnMgY2FuIHNoYXBzaG90IG9ubHkgc2luZ2xlIGZpbGVzLCBidHJmcyBlbnRpcmUg
c3Vidm9sdW1lcwoqIGJ0cmZzLXNlbmR8cmVjZWl2ZQoqIGVudW1lcmF0aW9uIG9mIGNoYW5nZWQg
cGFydHMgb2YgYSBmaWxlCgoKTWVvdyEKLS0gCuKigOKjtOKgvuKgu+KituKjpuKggCBJJ3ZlIHJl
YWQgYW4gYXJ0aWNsZSBhYm91dCBob3cgbGl2ZWx5IGhhcHB5IG11c2ljIGJvb3N0cwrio77ioIHi
oqDioJLioIDio7/ioYEgcHJvZHVjdGl2aXR5LiAgWW91IGNhbiByZWFkIGl0LCB0b28sIHlvdSBq
dXN0IG5lZWQgdGhlCuKiv+KhhOKgmOKgt+KgmuKgi+KggCByaWdodCBtdXNpYyB3aGlsZSBkb2lu
ZyBzby4gIEkgcmVjb21tZW5kIFNrZXB0aWNpc20K4qCI4qCz4qOE4qCA4qCA4qCA4qCAIChmdW5l
cmFsIGRvb20gbWV0YWwpLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUu
Y29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
