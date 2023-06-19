Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324B0C0015E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i3DN+iKbqIpzkLwbJxxPkZ7wu0p86FPDzBmweOP5prk=;
 b=EhZwshBbkENU3C8t38scqYTYp7GkhUauH4ydNFQTy4yMFLljaSsHuCvtJap4LScYOLTlxkFcRuhh
   caOnqKLDEI6tLYXjfsK6g6SfycvQct4PJXaIOUJCnSnZBXNuL4OxCh7i74pOns62W+r3Zl+qzxla
   6jHsde5uzXC86F8GdYclTt0sWq9S1Wy6J/qfXH0FRl/WFN1Zp6ZdAlJBOQehl6gOXwmSWCSAxBFr
   OBYrm3UoBF7xh0nCB3tHVW3H2xFs+NtxPo8fsYktOWj6Oe9LKl9nu7oDX+sJkQVZMbTsl2H60T2r
   pI3i15dmXjF7U9CeFd5JWe3SqU3QOUGRuCWg1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i3DN+iKbqIpzkLwbJxxPkZ7wu0p86FPDzBmweOP5prk=;
 b=rJNZ+XcMsoK/fZ5BKz457nAlJEN+nBNW4TkOJ0DjfvC0R4bur7uCibFAdZtec0FhMXVTJktTB2Fj
   Vbzx4azJYY5iaJWBkq/EJ9hCfsjDWsJXH6eSlbT/MauyRKCOmNX+LMl9F8H2pTgk3ctHuXp0Iwf2
   9qW1Ztk1sEh1+aQo/Gaujze6yJ3UUKg22KdC/+aP5BWMS1gMKCnfcIUpqawL5IYJsDTjw0ukF9W8
   e25/jE9zPlCFhulpOCGJCatjkhcOWj9e+ve4lAciQfv0MX0V/4mAO229CkDdkX875NL3f9R2Fr3w
   dgA+f15hdYRsQ1BETP3MmtueWfWOfa5j9rh4Sg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00G8D45YZ2D0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1687171325; x=1689763325;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
 :date:message-id:reply-to; bh=Lc8A8Vw9LtMkTqv5o4GSfreuArCukUUbiIQJyiLS2Gs=;
 b=meJYO/VluisrybFU77MgPXARQR8H/BczsgubpOvzbai2yX5V/vNJ1a44DdL5P+gT9h
 zWaMyX4vsVMcZpdzrqrHuVgt+KJuH3wxsdVuftFTJAWDxqpYYhN8DbGuM3qnFIwm16oj
 82X3mXu6193cPrAuBqSkaBVCPjA+IlrSg0lVP2EgXLsSKrDYFwgPWW6rm/HGLgLKKYIl
 34H3ha0Lr8mUP3vvONSgYZQMDRcXXwTvK2ivTbHlbWcynep/tWcyXhjnXuYYReLgQVjd
 0N2/eM5FJL05+0TX1P5SmIhH8m9bEJkBy7lV3xJ+RlpmSHuYsp1dMtRC0O3xgQ4t5YUO G+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1687171325; x=1689763325;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=Lc8A8Vw9LtMkTqv5o4GSfreuArCukUUbiIQJyiLS2Gs=;
 b=GQ+D0zYd1yEvDPbQ3NgcSy6/+I9Vbcwj5RF6vmkYezhahZKYGRc1YbvqpgSQ16yb55
 pEshmpVFuLfW8DNZG37INS+WwlhgqEroHpcQ85x4RRi0K/yoUjOPWyfDaCtfgjIFyMDW
 9SdC+SnmQX5vw6xe++9f1r9JxaYAEwReo9KM4lsGgIZpKsVIhazXveS8QuCHpL/5d6LQ
 TfFNetNeMYGOIcNvEAFw0XhMjIaeYfnR2Wv6ep12lW0or/5ld99vs+GHW7lLtmBJmrNs
 eLqIqiCNZ8eHo/acWGf9GFz2RF4LKPLkhAfiV0mI/8rJmThzA5ZvlP121darQhaZPaU1 YsYQ==
X-Gm-Message-State: AC+VfDxSQJveNw80srxx6LKHN64ZULenTXMBKqAlpK/kSZj4tLcJei80
 jSXiWXjrrsaoVBbzEZ9UV/0=
X-Received: by 2002:a17:907:7207:b0:988:8786:f56c with SMTP id
 dr7-20020a170907720700b009888786f56cmr3273576ejc.0.1687171324574; Mon,
 19 Jun 2023 03:42:04 -0700 (PDT)
Message-id: <efb4cbf2ee6f006b2b458c209fc0f31e8ba655e2.camel@gmail.com>
To: Jan Kara <jack@suse.cz>, Bean Huo <beanhuo@iokpp.de>
Date: Mon, 19 Jun 2023 12:42:02 +0200
In-reply-to: <20230619095604.uknf7uovnn2az2wu@quack3>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
 <20230618213250.694110-3-beanhuo@iokpp.de>
 <20230619095604.uknf7uovnn2az2wu@quack3>
User-Agent: Evolution 3.44.4-0ubuntu1
MIME-version: 1.0
X-Source-IP: 209.85.218.45
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=339 impostorscore=0
 lowpriorityscore=0 mlxlogscore=438 clxscore=22 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190097 domainage_hfrom=10172
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/5] fs/buffer.c: convert
 block_commit_write to return void
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <huobean@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ6gvL3qDfw9MwR4eqOkuWp5n5zJry97i6r137AZVb9sYts/gHSzat3Fvpas0VxRgRcJ5YqdUQ==
X-ServerName: mail-ej1-f45.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: uMGYTPtefSr4npBsIWH2yDSLwqLQm4NC
X-Proofpoint-ORIG-GUID: uMGYTPtefSr4npBsIWH2yDSLwqLQm4NC
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEHTp0d1XitezXReH86RfPFz/Mx4ntfb2HpXxKNudsMHGUImPLTle6bz2++t5Vz
 XhQaYjhq1wFrCAvnUxbMessU2CgzbfFGrduk9+b2wDYhJSspwXvaPV9Sx5v7K1fl
 Zl39Gf9yMIzUKk/qVmTvA/NQAZLpl1mb2XYwmuQuY6d9kPaiE5b4FsroAkHHxc/L
 8WcBoTR+2v82nzR478Kg/QxKWZIuzh/EYYExlpHMOXf1AfCQCOi1xC4k8o550kUc
 oRV6bT0LzbdmWyW15eau3uuozIsYjiiQIJSOnaYwS87i5ivCBiwt2Um6bfsICKp6
 +aPKhf+/YSrOkZLC1kjUF7Xra6zkB64TYFksBzV4LaknOeUemOsYgsmixh0893NZ
 ueMCuriwcAcrznxth7yhwnHdjF0Yx3Yoo2R6WZ+l1BTHp9zde4As3+gQV4gXzONU
 lhjCzFZqzuaifQKdXQ/OM0qX6GQyqqRK6CNBdgEi15CyRC5n+x6npxSRQ6q02aQ6
 09KE4jqD6g27gZMs+qhVI8wbbPXfHuF2xyLjKnv5Juw=

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDExOjU2ICswMjAwLCBKYW4gS2FyYSB3cm90ZToKPiBMb29r
cyBnb29kIHRvIG1lIGJ1dCB5b3UnbGwgbmVlZCB0byByZW9yZGVyIHRoaXMgcGF0Y2ggYXQgdGhl
IGVuZCBvZgo+IHRoZQo+IHBhdGNoIHNlcmllcyB0byBhdm9pZCBicmVha2luZyBjb21waWxhdGlv
biBpbiB0aGUgbWlkZGxlIG9mIHRoZQo+IHNlcmllcy4KPiBPdGhlcndpc2UgZmVlbCBmcmVlIHRv
IGFkZDoKPiAKPiBSZXZpZXdlZC1ieTogSmFuIEthcmEgPGphY2tAc3VzZS5jej4KPiAKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoEhvbnphCnRoYW5rcyBKYW4sIEkgd2lsbCByZW9yZGVyIGl0IGluIHRoZSB2Mi4K
CktpbmQgcmVnYXJkcywKQmVhbgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNs
ZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
