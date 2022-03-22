Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC0BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 22 Mar 2022 20:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0AVeWIyNqpQ5bBED4e5wwyEpwmKJ0cZsxKlEevlA0pM=;
 b=2P4gOk9GmGlydgtEgKEPyWoBE6IRpKZaLQXdjWgqdFXGqFjGVbXgoPB+GfpVNaEL+LAV6D+umnAS
   4j0LmUT9eM4ykD1qUITrLCIeJsd50pdM/Qh7OBBrmPv3HMn1/2BIcJFklMA7JGF2tHPOoVqt69ft
   b0HzAkHl8TWq7knN462N67gfGaVc7o3PhaPRFRXCWo2PKza7IxfN+AUjL7O683XlA5ov1SdoiPYS
   RCr0z6J/WdvbEYTfu7AsZ1fXi+FR6kvf0q9M5CZhOl8x+/26/PHLcO8J2R5JVrfBy+1FYgsfO62u
   cFS+RAjul5Bl9rogFQHNnHtf6vHQae6UNnCptA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0AVeWIyNqpQ5bBED4e5wwyEpwmKJ0cZsxKlEevlA0pM=;
 b=iczhuxXuNG1lR1BzkSY3dfOQXKvI4kSUBqSKwsVV2hCMKeL7l3K7g4FI28RkKAKsi7AFfHbDlE6B
   HtiRUFIXBmNKbZIlHNTRV3KO5sCOgK46PR3Qz4bjXuNo+HntJ0Y9t1zYLfe/ODdhndUIM2FXIN0i
   sV4bePlPICLdRAmmzhFWumF13cliyHwsXtW8E9MjKVhF+Ecn8c4O7wRmRSgA50dwvgq7lF6vyMlv
   p+7BGysK9xOQVi3Y4TeMQg5Crep1qViaOf45Z6GtaPE8MkN1y89Cy3pIiQvSLaPYGnkFvKwcvzZK
   W1wyyDxQNhpJI3zW6imLKgzYoNXZdyGUCe/RGA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9500DCMYKWUX30@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 22 Mar 2022 20:36:32 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=vvidic@valentin-vidic.from.hr; dkim=pass header.s=2020
 header.d=valentin-vidic.from.hr; dmarc=pass header.from=valentin-vidic.from.hr
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=valentin-vidic.from.hr;
 s=2020; t=1647981345; bh=xUB6V3iJ7Xhl9pkuQnVjET2rGiobVvuBo0GYXUwuhjI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qSZ1tXNx6dsXB11Y0eDkV6td4I/YzYN2KgQeGOqnNVnvX1KrYyL4RTTDPLoHERI+v
 KOA699NaYBBPpYdkySXPQaDPizbFBRqw5mKykyZancXaQlh9ACF7rReveCxEN/t3v7
 J6B49daX7kqg5a+9HqO/7zC/cAgB59oLKHcljr5jXj0PpK6TI8TXTMBKj1bPD6QLbz
 fJ8ko5d/9x4xu8Ep7JF//raVlMj5qoB1qhI4wdGrkayKlVtjl1kMPKsSk1dhZZuZE7
 I6HjYQlq6bvSJlBR+jRN39lvpCb8as0+xDFT0Hv0xbf/s5clQJ9Eu31avcoYoPK7gy
 63/RESpOYjKlBwmDXF9H290fCenH2q1RCzUWEigX2MpOzlzuOvM0EVyCjENdFWyIbR
 Abmqcm+vRRlDcz96v5mlI7hLJe0HzWaYVrzSce07hg3aNt1tv69dxWiCR50e+q1Krj
 s04SlTuk4FqFc7h7NLwoS6kiBvV2Vkg5RwnESJMiIti0V2q5gE9NT/5WlgEgmUaVy7
 O2DqLZ0DxtKAfIqKeJxwF7j6Y/4OFsSaidHCRqPBmKZLyiSkpq7k3cWWDyuiehTnkH
 MG/oN2rsjs/XCvdiVFH1I3oeLy2A4OYbDXIwQosJe6t9SUf/vG2Zyqkgzca8IQQnAB
 lUIYmqZP5s/5Et1S0AiMbXxA=
Date: Tue, 22 Mar 2022 21:35:45 +0100
To: Joseph Qi <jiangqi903@gmail.com>
Message-id: <YjozIZ3j8Oczc7W8@valentin-vidic.from.hr>
References: <20220322031215.1449435-1-vvidic@valentin-vidic.from.hr>
 <0bb64f66-6343-72d4-3948-6c6dd49be41a@gmail.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <0bb64f66-6343-72d4-3948-6c6dd49be41a@gmail.com>
X-Source-IP: 109.200.23.17
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 adultscore=0 priorityscore=60 malwarescore=0 clxscore=197 mlxscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=941 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220105
Cc: linux-kernel@vger.kernel.org, Dayvison <sathlerds@gmail.com>,
 Tuo Li <islituo@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: quota_local: fix mount crash of
 filesystems with quota enabled
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
From: Valentin =?utf-8?B?VmlkacSH?= via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 2K0vt9XvsHAgRMerKF1n0WgfHBkbqnw_
X-Proofpoint-GUID: 2K0vt9XvsHAgRMerKF1n0WgfHBkbqnw_
Reporting-Meta:
 AAFwyjTIpqsLJ2luov7loIIbYwAXgMEVfsrX7wmEomNTe0EGQvHpZfxjLKdO3RzQ
 K1q1+Hc2dfpI/f6HyUQRlloqjmlImHv+1lsKhq4oWq7KhMfcbDKq3bz8P8HgHUeN
 DFdHNQ+UHb9+tnZzyJBF6c34hBZlG3jpwJWCmFzx6J+Emy4Jw4yemYlPlUaS0Hjc
 O7t4p9kC/RhW4QXpC7BzNkP3vdvoihB3O0aXb6jKlH7aFiuWXwDwtuXIU9zgy4qS
 iNqYzJWouVkYkMfXyXNr8jZ1YktjB8qVacJSklHgo0b28QnjoD6d57kl09ZwTN5/
 2lBTjm3pJ0slIzU5HQE3jae/tmirCTgLjQvuIrAMFwWSF/gnGh9djnABrRgQsIO/
 ASmtAJf5lPehB10aMOQZ0y5Gc8BixfoMiiWBUQuv0c8bOa0brH2nf1NPj25khXdB
 meVRqRqSHudPkUilTwRve95wFSR4+ztMe8K4MOpy1hR/ModUmIn5SH1qw3kVTG+U
 t/G9U7cBy+ajCd6IPdAsp4MNYKs5QPvyk4iyhwEtSbuIwA==

On Tue, Mar 22, 2022 at 03:32:35PM +0800, Joseph Qi wrote:
> Thanks for pointing this out. My fault when reviewing the introduced commit.
> But this change will lead to access uninitialized dqi_gqlock when
> ocfs2_global_read_info() fails.
> How about the following way?

Looks good and works for me :)

Tested-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

-- 
Valentin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
