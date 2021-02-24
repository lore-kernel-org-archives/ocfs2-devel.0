Return-Path: <SRS0=z2TF=H2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1FAC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 09:11:41 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F64464E05
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 09:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F64464E05
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=helmholtz-muenchen.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O98vBM136660;
	Wed, 24 Feb 2021 09:11:39 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36vr624hgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Feb 2021 09:11:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O9AWVh026739;
	Wed, 24 Feb 2021 09:11:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucbym9qe-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 24 Feb 2021 09:11:37 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lEqCm-0005IP-RJ; Wed, 24 Feb 2021 01:11:36 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <bernd.lentes@helmholtz-muenchen.de>)
	id 1lEqCk-0005I1-QY
	for ocfs2-devel@oss.oracle.com; Wed, 24 Feb 2021 01:11:34 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11O9A8B4093412
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 09:11:34 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3020.oracle.com with ESMTP id 36uc6svgyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 09:11:34 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11O95802034529
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 09:11:34 GMT
Received: from mtaextp1.scidom.de (mtaextp1.scidom.de [146.107.3.202])
	by userp2030.oracle.com with ESMTP id 36trfj03yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 09:11:33 +0000
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 1A6801803CC80;
	Wed, 24 Feb 2021 10:11:17 +0100 (CET)
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Yd6H6FB3zklm; Wed, 24 Feb 2021 10:11:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaextp1.scidom.de (Postfix) with ESMTP id 132CF1803CC7C;
	Wed, 24 Feb 2021 10:11:16 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
Received: from mtaextp1.scidom.de ([127.0.0.1])
	by localhost (mtaextp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ojCQ3-_e14tP; Wed, 24 Feb 2021 10:11:15 +0100 (CET)
Received: from mtaintp1.scidom.de (mtaintp1.scidom.de [146.107.8.197])
	by mtaextp1.scidom.de (Postfix) with ESMTPS id 2251D18016D56;
	Wed, 24 Feb 2021 10:11:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 5731D838F044;
	Wed, 24 Feb 2021 10:11:28 +0100 (CET)
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 9jVYVFkp2UPw; Wed, 24 Feb 2021 10:11:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 3C8C28255E53;
	Wed, 24 Feb 2021 10:11:28 +0100 (CET)
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Received: from mtaintp1.scidom.de ([127.0.0.1])
	by localhost (mtaintp1.scidom.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yjj90e9MAihZ; Wed, 24 Feb 2021 10:11:28 +0100 (CET)
Received: from mbxp1.scidom.de (mbxp1.scidom.de [146.107.8.207])
	by mtaintp1.scidom.de (Postfix) with ESMTP id 1D6888255E54;
	Wed, 24 Feb 2021 10:11:28 +0100 (CET)
Date: Wed, 24 Feb 2021 10:11:27 +0100 (CET)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Message-ID: <834203578.59367045.1614157887078.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <01866DBC-59D3-4D41-B404-C76FCA6B6221@oracle.com>
References: <1884783914.58523079.1614110913964.JavaMail.zimbra@helmholtz-muenchen.de>
	<01866DBC-59D3-4D41-B404-C76FCA6B6221@oracle.com>
MIME-Version: 1.0
X-Originating-IP: [146.107.158.78]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - GC88 (Win)/8.8.15_GA_3968)
Thread-Topic: error message in log: ocfs2_reflink_ioctl:4431 ERROR: status =
	-17
Thread-Index: g5xUhHWN9KIR5CmwxPJXuTW4kSHzTvVrXEYA5yqc6Ao=
X-PDR: PASS
X-Source-IP: 146.107.3.202
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	priorityscore=0
	lowpriorityscore=0 malwarescore=0 impostorscore=0 clxscore=178
	mlxscore=0
	adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=873 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102240071
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	11O9A8B4093412
Subject: Re: [Ocfs2-devel] error message in log: ocfs2_reflink_ioctl:4431
 ERROR:	status = -17
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240072
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240072

Ci0tLS0tIE9uIEZlYiAyMywgMjAyMSwgYXQgMTE6MjQgUE0sIFdlbmdhbmcgV2FuZyB3ZW4uZ2Fu
Zy53YW5nQG9yYWNsZS5jb20gd3JvdGU6Cgo+ICNkZWZpbmUgRUVYSVNUIDE3IC8qIEZpbGUgZXhp
c3RzICovCgo+IFlvdSBtYXkgYWxyZWFkeSBoYXZlIHRoZSBmaWxlIGNyZWF0ZWQgZnJvbSB0aGUg
b3RoZXIgbm9kZS4KCj4gd2VuZ2FuZwoKCkhpIFdlbmdhbmcsCgp0aGFua3MgZm9yIHlvdXIgaGVs
cC4KClRoZSByZWZsaW5rIGlzIGNyZWF0ZWQgdmlhOgpyZWZsaW5rIC1mdiAvcGF0aC90by9kb21h
aW4ucmF3IC9tbnQvb2NmczIvcmVmbGluawoKT2YgY291cnNlIHRoaXMgZmlsZSBleGlzdHMgYWxy
ZWFkeSBiZWNhdXNlIHRoZSBza3JpcHQgcmFuIGFsc28gb25lIGRheSBiZWZvcmUuCkJ1dCBmcm9t
IHdoaWNoIG5vZGUgdGhlIHByZXZpb3VzIG9uZSB3YXMgY3JlYXRlZCBpcyB1bnByZWRpY3RhYmxl
LCBpdCBtaWdodCBiZSB0aGUgc2FtZQpidXQgYWxzbyB0aGUgb3RoZXIgb25lLgoKSXMgdGhlIG1l
c3NhZ2Ugc2V2ZXJlIG9yIGRvbid0IGkgaGF2ZSB0byBib3RoZXIgYWJvdXQgaXQgPwoKVGhhbmtz
LgoKQmVybmQKSGVsbWhvbHR6IFplbnRydW0gTcO8bmNoZW4KCkhlbG1ob2x0eiBaZW50cnVtIE11
ZW5jaGVuCkRldXRzY2hlcyBGb3JzY2h1bmdzemVudHJ1bSBmdWVyIEdlc3VuZGhlaXQgdW5kIFVt
d2VsdCAoR21iSCkKSW5nb2xzdGFlZHRlciBMYW5kc3RyLiAxCjg1NzY0IE5ldWhlcmJlcmcKd3d3
LmhlbG1ob2x0ei1tdWVuY2hlbi5kZQpBdWZzaWNodHNyYXRzdm9yc2l0emVuZGU6IE1pbkRpci5p
biBQcm9mLiBEci4gVmVyb25pa2Egdm9uIE1lc3NsaW5nCkdlc2NoYWVmdHNmdWVocnVuZzogUHJv
Zi4gRHIuIG1lZC4gRHIuIGguYy4gTWF0dGhpYXMgVHNjaG9lcCwgS2Vyc3RpbiBHdWVudGhlcgpS
ZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0IE11ZW5jaGVuIEhSQiA2NDY2ClVTdC1JZE5yOiBE
RSAxMjk1MjE2NzEKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20K
aHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
