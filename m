Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426AEC77B73
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 03:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tFxGnJmz4MwGBAsBSn/cwmjIteWxcRT/tXwXr2r3vg8=;
 b=qHf80T5QjsyLWVvhdbUS5cM3aS8+nJQf5pRD/EHa9ABU+/uM9PkhI1LRYPtwDBQ4ed5fiGqwSR0h
   EaMVoW8dUGdTm5MW1RbmadbFdNDaKM5vTGCi8OZlLhy/BrqqI7j2CIQ5QSsA6GfT2xSwUaUXPLSe
   iquhgxJiIDTmpIJdiH8vNkpD/lRYAAK7j6IIToquCITJn7nxBTjdY6EXag0tDSb23UZPU4Pha8uI
   OcQemJMU1dqZwmmH5N//2HHPr+qPhzeV6pTKhHN/YMit4V2LA5RNGB218Moa8vFgraQu6YEqSVuT
   K0buG794f0R/pEmw0bvd75Mj3MRIux+Kbk0q+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tFxGnJmz4MwGBAsBSn/cwmjIteWxcRT/tXwXr2r3vg8=;
 b=gLi//twkJBQo4zu0BVHreravb8lLDihoxURWBVNJ3P73hf9OnOkuKNpP3ueI2h3fhcMdP0bMp96C
   HHCKMfcXTWZxq+AoHH/0pyVKWD1pDUim6Oavf3Cy9hd2+YZZcVR4yQrCgeka7WXxnroQsScfRp3K
   Q/KwDL7Opg0QNa2N67tlOfgfalUOVhJouc/Ec1Ky3SXcTTjT3DJ74iYIYEotspFZTLjQZWCVmuHX
   VyP1eKnEK8/T7qdI0TvK1fuI9z1A2yJBkr6hMR79Pyny117R3bSPUM2rOnVYjjD/1+6+oexEj6/s
   vOU3nGfs1CLOqwMvP1z7L5lZWATv6f3cNcdatw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVI00HI576ML5D0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 03:32:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20221208.gappssmtp.com; s=20221208; t=1685503951; x=1688095951;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=iwIn9A/3h6kb4VvZG2aUfPXs9cJPwe4RAvyyxJjYKPk=;
 b=2CNVHhuaVTG584FDACPkoosLtm5xST6kmLqLiv+9h42wJnfSaSf1kLL8OvTJSB6Bp3
 cukhpJId7lTytvkDhlOj/lVIiv9OBAOM7q8yDoP3qkuPNnESZOWuWnrEduVTKarKbzLd
 EHEES7P+R+DE7K2AycjgZPdPrtSJP5XqrEFm5kEtxlrG1WXGrx2RwH0hMzNJzl7ZKVLp
 ximLQN0W4UgszV1DBwK4v3Qb5YHhNLVIx5vO9cvFadr1P6rL+VuPd8nxu7vdsQo65G8j
 ejpqDUVBPoOgYfd1tvC2NfaQrFLpPQnqtXrkQLmPyIpF1N+YcG73/+JgwPK+UeitSiAz 3MPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1685503951; x=1688095951;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iwIn9A/3h6kb4VvZG2aUfPXs9cJPwe4RAvyyxJjYKPk=;
 b=IsCXxS9HKgB4ST87IxIXhHd1i5g+EUdZOeFiGyUV0lReeLfujfcBQ5x1qhPUIWXYmb
 oLM07kFyQjD5pcdlKmLKmuh2QFwNEePV9woOddmskBrX+XDBu06Y86EiZaggp88DRDmI
 icu/RYxTCgNq0+gM4rZncW0484Mon2cpMAUrMAd0iyeh84rzGuh2wAPuDjWNmjllUy3r
 ELQKXna95Z4bBZH1i7tVlsGH+eYCFEeVDVytXW0PAgdRXze5ZnvDfhFwIC+84uqpFJDI
 Qyr3aTi5nay+imy4pVWd1pFi+ZWzLWjzg5kUK0zy0Hz2wMnfxRN34aA+mZZfDghDPDA3 jzwQ==
X-Gm-Message-State: AC+VfDy2q8zvjkafgSa5DWOzxMryJU8CaJZiWHzoHp3Zz0BIedUjKJDI
 tStr2DRMeAur34YjjgzTdyIXhLHVTMUP8pT14xMXGg==
X-Received: by 2002:a0d:d412:0:b0:565:8c16:a0e1 with SMTP id
 w18-20020a0dd412000000b005658c16a0e1mr5507264ywd.13.1685503951455; Tue,
 30 May 2023 20:32:31 -0700 (PDT)
MIME-version: 1.0
References: <20230529152645.32680-1-lhenriques@suse.de>
In-reply-to: <20230529152645.32680-1-lhenriques@suse.de>
Date: Tue, 30 May 2023 20:32:20 -0700
Message-id: <CAGe7X7kxfrTvg0s3JGasnhFOLFS9FR7uTjwp+YGG7hTNi2UULw@mail.gmail.com>
To: =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
X-Source-IP: 209.85.128.175
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10726
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 mlxscore=0 priorityscore=143 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 mlxlogscore=390 suspectscore=0 clxscore=68
 lowpriorityscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305310028
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: check new file size on fallocate	call
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
From: Mark Fasheh via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mark Fasheh <mark@fasheh.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ7EXnW0YcjSmJKT8Tx9qr3ImGNRICkccKl2sn7+ggBZczeplHrHQVfss+yln0MJrKESPw4iHtHFmQylrz1feaA=
X-ServerName: mail-yw1-f175.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 7GxDtCXlhBUDcH6L3pjX3x0FpsHekk52
X-Proofpoint-GUID: 7GxDtCXlhBUDcH6L3pjX3x0FpsHekk52
Reporting-Meta:
 AAGYZFPkRvu+m4L3xvQfDNL9EU/I0osmy6jJTvaFBXWq+z9uKSwjhbSMoH0fs34h
 3sNN6laaedg/u7JIt0fseVMyAA2D6fVOEHA/C4l0J6Z/ER4KevgYZDQ9e4h7jplZ
 frxXZT3zWktSJtVBjxpWeXrRoOc280Nz6lp0cokHTeZ/z8ic0Pfcq51b+o02pUo2
 lN/wUjnj/ZT6+9ZeFGSm90mA389k1uLJVByxN30/0sLAYi06hverkdfUFG1pj6IF
 Q8F2QMs6wGvJFcDdGKYqPAnTaInN0mGfRtW4BiQRGqcF95dCHynkEFJlx5PKz/5s
 noXPAltNTOXIXBfhV2D/q3pDk5Xcs2p0jcPNTJEYUqLrzVO1NnL8FVNcaqFlLgXF
 oPvvi9ni+IRW8+0nSDUpSXyq43Id6EzRftZo3X4TQU/sH5m5BNfXU8eL1ZhjVzCW
 0sdHszPV4oDDDl6xJQQ+KnuApiklh3EJxakxff+PkrTvI2UDQqJ+5Gi6MluA9FuY
 UcQEdvjTf0qcAq50CTZG8zokqJrCfoM69CUwC3+mDsJOQA==

T24gTW9uLCBNYXkgMjksIDIwMjMgYXQgODoyNuKAr0FNIEx1w61zIEhlbnJpcXVlcyA8bGhlbnJp
cXVlc0BzdXNlLmRlPiB3cm90ZToKPgo+IFdoZW4gY2hhbmdpbmcgYSBmaWxlIHNpemUgd2l0aCBm
YWxsb2NhdGUoKSB0aGUgbmV3IHNpemUgaXNuJ3QgYmVpbmcKPiBjaGVja2VkLiAgSW4gcGFydGlj
dWxhciwgdGhlIEZTSVpFIHVsaW1pdCBpc24ndCBiZWluZyBjaGVja2VkLCB3aGljaCBtYWtlcwo+
IGZzdGVzdCBnZW5lcmljLzIyOCBmYWlsLiAgU2ltcGx5IGFkZGluZyBhIGNhbGwgdG8gaW5vZGVf
bmV3c2l6ZV9vaygpIGZpeGVzCj4gdGhpcyBpc3N1ZS4KPgo+IFNpZ25lZC1vZmYtYnk6IEx1w61z
IEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgoKTG9va3MgZ29vZCwgdGhhbmtzIEx1aXMu
CgpSZXZpZXdlZC1ieTogTWFyayBGYXNoZWggPG1hcmtAZmFzaGVoLmNvbT4KCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcg
bGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21h
aWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
