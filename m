Return-Path: <SRS0=wAx7=IV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A404C433E2
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:46:29 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A264F619BB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 Mar 2021 15:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A264F619BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFj0qg005745;
	Tue, 23 Mar 2021 15:46:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 37d8fr7k1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Mar 2021 15:46:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NFe934099827;
	Tue, 23 Mar 2021 15:46:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 37dtts3wjw-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 23 Mar 2021 15:46:27 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lOjEg-0003JZ-9g; Tue, 23 Mar 2021 08:46:26 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <kilobyte@angband.pl>) id 1lLCUb-0004VX-GZ
	for ocfs2-devel@oss.oracle.com; Sat, 13 Mar 2021 14:12:17 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DMAGT8055847
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 22:12:17 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 378kebbv69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 22:12:17 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DM4bk8003358
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 22:12:16 GMT
Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	by userp2030.oracle.com with ESMTP id 3795k8g9sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 22:12:16 +0000
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94)
	(envelope-from <kilobyte@angband.pl>)
	id 1lLCJc-00GN3W-3k; Sat, 13 Mar 2021 23:00:56 +0100
Date: Sat, 13 Mar 2021 23:00:56 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Neal Gompa <ngompa13@gmail.com>
Message-ID: <YE02GArtVnwEeJML@angband.pl>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
	<20210310142643.GQ3479805@casper.infradead.org>
	<YEy4+SPUvQkL44PQ@angband.pl>
	<CAEg-Je-JCW5xa6w5Z9n7+UNnLju251SmqnXiReA2v41fFaXAtw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEg-Je-JCW5xa6w5Z9n7+UNnLju251SmqnXiReA2v41fFaXAtw@mail.gmail.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	adultscore=0
	mlxlogscore=557 impostorscore=0 mlxscore=0 clxscore=389 spamscore=0
	phishscore=0 malwarescore=0 priorityscore=78 bulkscore=0
	lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103130170
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	12DMAGT8055847
X-Mailman-Approved-At: Tue, 23 Mar 2021 08:46:25 -0700
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        Al Viro <viro@zeniv.linux.org.uk>,
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

T24gU2F0LCBNYXIgMTMsIDIwMjEgYXQgMTE6MjQ6MDBBTSAtMDUwMCwgTmVhbCBHb21wYSB3cm90
ZToKPiBPbiBTYXQsIE1hciAxMywgMjAyMSBhdCA4OjA5IEFNIEFkYW0gQm9yb3dza2kgPGtpbG9i
eXRlQGFuZ2JhbmQucGw+IHdyb3RlOgo+ID4KPiA+IE9uIFdlZCwgTWFyIDEwLCAyMDIxIGF0IDAy
OjI2OjQzUE0gKzAwMDAsIE1hdHRoZXcgV2lsY294IHdyb3RlOgo+ID4gPiBPbiBXZWQsIE1hciAx
MCwgMjAyMSBhdCAwODoyMTo1OUFNIC0wNjAwLCBHb2xkd3luIFJvZHJpZ3VlcyB3cm90ZToKPiA+
ID4gPiBEQVggb24gYnRyZnMgaGFzIGJlZW4gYXR0ZW1wdGVkWzFdLiBPZiBjb3Vyc2UsIHdlIGNv
dWxkIG5vdAo+ID4gPgo+ID4gPiBCdXQgd2h5PyAgQSBjb21wbGV0ZW5lc3MgZmV0aXNoPyAgSSBk
b24ndCB1bmRlcnN0YW5kIHdoeSB5b3UgZGVjaWRlZAo+ID4gPiB0byBkbyB0aGlzIHdvcmsuCj4g
Pgo+ID4gKiB4ZnMgY2FuIHNoYXBzaG90IG9ubHkgc2luZ2xlIGZpbGVzLCBidHJmcyBlbnRpcmUg
c3Vidm9sdW1lcwo+ID4gKiBidHJmcy1zZW5kfHJlY2VpdmUKPiA+ICogZW51bWVyYXRpb24gb2Yg
Y2hhbmdlZCBwYXJ0cyBvZiBhIGZpbGUKPiAKPiBYRlMgY2Fubm90IGRvIHNuYXBzaG90cyBzaW5j
ZSBpdCBsYWNrcyBtZXRhZGF0YSBDT1cuIFhGUyByZWZsaW5raW5nIGlzCj4gcHJpbWFyaWx5IGZv
ciBzcGFjZSBlZmZpY2llbmN5LgoKQSByZWZsaW5rIGlzIGEgc2luZ2xlLWZpbGUgc25hcHNob3Qu
CgpNeSB3b3JrIHRlYW0gcmVhbGx5IHdhbnRzIHRoaXMgdmVyeSBwYXRjaHNldCAtLSByZWZsaW5r
cyBvbiBEQVggYWxsb3cKYmFja3VwcyBhbmQvb3IgY2hlY2twb2ludGluZywgd2l0aG91dCBzdG9w
cGluZyB0aGUgd29ybGQgKHRoZXJlJ3MgYSBzaW5nbGUKZmlsZSwgInBvb2wiLCBoZXJlKS4KCkJl
c2lkZXMsIHlvdSBjYW4gc3RpbGwgZ2V0IHBvb3ItbWFuJ3Mgd2hvbGUtc3Vidm9sdW1lKC9kaXJl
Y3RvcnkpCnNuYXBzaG90cyBieSBtYW51YWxseSB3YWxraW5nIHRoZSB0cmVlIGFuZCByZWZsaW5r
aW5nIGV2ZXJ5dGhpbmcuClRoYXQncyBub3QgYXRvbWljIC0tIGJ1dCByc3luYyBpc24ndCBhdG9t
aWMgZWl0aGVyLiAgVGhhdCdzIGVub3VnaCBmb3IKZWcuIGRuZi9kcGtnIHB1cnBvc2VzLgoKCk1l
b3chCi0tIAriooDio7TioL7ioLviorbio6bioIAK4qO+4qCB4qKw4qCS4qCA4qO/4qGBCuKiv+Kh
hOKgmOKgt+KgmuKgi+KggCBOQURJRSBhbnRpY2lwYSBsYSBpbnF1aXNpY2nDs24gZGUgZXNwYcOx
YSEK4qCI4qCz4qOE4qCA4qCA4qCA4qCACgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMy
LWRldmVs
