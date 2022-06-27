Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A611BC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Jun 2022 05:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KbX5rC5UMwwYGAHS2tM9KgqgKUeHvevMkvFzhjMoajw=;
 b=xNuTrse6iVawl37lYGKKcf8odELno9oc/IvQ5W2iJ4pMHSKRpaDy4mG7CvRmI9tvKlTu/rI8CdUC
   PJUHyGGRuF2tkfmGKK0aAwzu+b0gO8mRaphRYEv6K5Pmb3MwBrQPpA9pC2mE3+MYACV5NpqIJw/d
   +NLRM5URoyM9m8Lk0Hn4o7Wrht5jv6wL8D9VoJF25tXSP0ckvFmbSC/Poz3qMXb8sAtrhFCa8ZPZ
   R4e6AW5+U5Jhs4MqpKvABoNzg75XLKWYyj/HzqJqrN+k2zqW3+NMBO/TglfEZQdGmuGJbxCBli49
   PMP+G0urUmaZbFDJDb94DOGG0GbEr6/2S3xpBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KbX5rC5UMwwYGAHS2tM9KgqgKUeHvevMkvFzhjMoajw=;
 b=M9eHAVLtdRp2p9EhhZvMYAeIST73v0jAGL2FyKMSzPPCFj/IvanOnqKau7pZY7nCkNH9E8EPYZL3
   FygkKgDUw1wznGc7a9LPpgrxmTp82+e8GB9V4Xwnd+ZjZLuybBHqLXQsyPTUltNg9hnKaPho2Ly0
   FSROV1ezZ0thdAKPzRjvn4BhsfEYZTQRHA+zjb1+726IM2je5Sfxz+x0QCQEAy+3R3D9XmW9Y30D
   JIVV8vjFdPlp/GS2bE1egk3kSILTYY1vHR7TxTF73u4DluM1UzjMv6xezVaqaYEyT1IaYrdF3Dmg
   Un6lJ5tUquSUUHi6iG/Ou/tJ4/Kt1TkONz8Y6A==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RE400OZBGEMBA20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 27 Jun 2022 05:54:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1656309245; bh=Sus3/9KJFbCudnP5NL9Wq/YGxqU1cqKDlw/yXzz/byE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=PmnyKU2R6B3OwWkNwA71Bb3W4yu3aSzlU4JKpSGEYVhtUVgjXPiWii2v775TAVKXH
 71qSOmGElh9zC6RSYT5QQRe4TkLChzhb4joLhhlzKZVtuPRAInPSRc5/29vrUHxJJQ
 l6JnTSuBl/ebjvoqtCkynONE2ZRG51fMWyWayEE0=
Date: Sun, 26 Jun 2022 22:54:04 -0700
To: Junxiao Bi <junxiao.bi@oracle.com>
Message-id: <20220626225404.e12f34eb4d416c6e6184f9bf@linux-foundation.org>
In-reply-to: <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
References: <20220626202113.CE8DAC34114@smtp.kernel.org>
 <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-version: 1.0
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10390
 signatures=595540
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=120 suspectscore=0 clxscore=198 mlxlogscore=962
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270026
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] +
 revert-ocfs2-mount-shared-volume-without-ha-stack.patch added to
 mm-hotfixes-unstable branch
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xveB18uRoHGWiO-NLaYgjpGIE-qnu-7K
X-Proofpoint-GUID: xveB18uRoHGWiO-NLaYgjpGIE-qnu-7K
Reporting-Meta:
 AAGh6HbgWOIdvUGtEr1p/kCqEWiLIdDdUi2jQOUE7jThShiW1QmynSKhU6y1y0Ma
 ekoS7hssU30KmJU1X4pnxdH0w4Ph73Wf3CcKpmKEkYKeZ0V5w/KSxsAPx9F2isiy
 MKlMJfkJYe0esZhrx0gS+QjUBPHRQtvjI04D0jO6fe6a09Y9b9bDc7KWSpLLYQtN
 hk+8WclVK4caQI8vRaR1EAURr+Mh+bc7JLIqb1gUm+OFfBidHzUwfcy5dS28LhQu
 JoNHdn6Xgs51C01LsNS0mNUPCPDmy2YgUGPLSNx4h20S1vyLCk1TFCARWFqL36yv
 M7kFlBn8cO2WZlvZOwdfMgLOIqBAAO4naEsIU3QE/GpAvVsxOdhF2SolZtpPgUUE
 K/0iZgO0k2L7x5rCqTFGx+b5YHJD/FBPwlE8Lj1yAP5eI8Hwnt8dDSpn+BtVNrvB
 U+AsVyLios4OGZEE8rf6ayUTaYtswBMnlC5rFn2NLc90LJEMQGYqzSWzkIn+yGBQ
 DpzVuWbZnHVWSudDvyVBPxp6rC+F1w1kz48xh/42XOA4

T24gU3VuLCAyNiBKdW4gMjAyMiAyMzoxODo0NCArMDAwMCBKdW54aWFvIEJpIDxqdW54aWFvLmJp
QG9yYWNsZS5jb20+IHdyb3RlOgoKPiBUaGFua3MgZm9yIG1lcmdpbmcgaXQgdG8gbW0uCj4gSSBz
ZWUgdGhlIOKAnEZyb23igJ0gaXMg4oCcIEp1bnhpYW8gQmkgdmlhIE9jZnMyLWRldmVsIDxvY2Zz
Mi1kZXZlbEBvc3Mub3JhY2xlLmNvbT7igJ0sIGNhbiB5b3UgaGVscCBmaXggdGhhdD8KClRoYW5r
cywgSSBmaXhlZCB0aGF0LgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUu
Y29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
