Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 550A8C77B72
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pLdQm2tA1sh++uz+qbcrP7rFtAAMeojswgYKJbXcCEM=;
 b=kKKVcXhZSoYpEVXFmWdOcSFmuDqfiB7O8pfg0Gxotwy/FUZwGZpYSNK9vF584QhxzpsBabtFuBMc
   Pb/8M7bcDfZt3uJ7owyu/GvtkHrCx4q8viTdVSxWLgBLMtsI8cfVGji8q58YvN0tj9IqVnoe9qVr
   Urthz/2yNSqqpeGb6y3VTnaAwerEv7RP78X9v2aRAmFJAFRjPnLG047a0x2NvwSs2HS0KwMdHM2D
   twRo4derx8gJqlna+SEd5QrLEVQ48V+CkJojoZLePcbF7znupzRUbVhJqAr5b3P0Opz4G4WVKFy9
   cUyKoB5lrvpMtvAjDTtlPC3gcnPRullYzJqLkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pLdQm2tA1sh++uz+qbcrP7rFtAAMeojswgYKJbXcCEM=;
 b=PkP3F2Ntp3ySnqpwVjvRBya0qC2OJa0VR+JlNZu1YILWw8WlDXOkTjCc/FMahUsvkOjvBJvpogGJ
   eotwiXG5zU0pJBkdm/3/bvsnYK3xnnkDLStM4Dq9kozpUfjluFesJ78aQu9fWE+cVkOuxtc5KYrj
   alP678Cyw2LLyw3dE/M3gEIYzoU9ZM9gYwU2muK+AI/3PYuviVC7rQy0dES/BasbUrAKS+Lbl6Mk
   Z4BQuceLIC3wg4Now2lRO9MM9+k6Uuh7N0cpHGGY8PsT/QXW5qKzrcxZFmp/skPv6pMd/x08B0Cf
   0lsESyNBR8mNbDtsJvetgqIsDSelxa4+0Gx0WQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTF000YPBB0EW90@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Apr 2023 17:01:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20221208.gappssmtp.com; s=20221208; t=1682010083; x=1684602083;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=eMADD16mbnU9U9nwmJ1TEHgIp8QQ7hr++iHttnQXxms=;
 b=lTWCDRi+/9/ifvYhq+aqhiFxzjtzbv5y5nVijD4wOkSgdy90iPSEas7W4Hgu04eW9t
 FmGr4VBDXg8FH1FcfuRgPOVnmfhfBwly8qjA63vcB2HT0EBVcLcg8DGGc25KcSp2mGDx
 o7dBLh7aZ9pn3iXMdbWyxb4QpbBe5YyL2+bcsqcc9n4j7vk0PRl+FzGYN1v56iMIeKTn
 Ks9XNIxuA1+oP1FR+VwZ0l56jlk1l1DC075BAlHJZGR8Satod/z+ZLVn7rNP1pzQhqDT
 rbWiL2Z8ttehufjNFghHoTLx/4AvDs0tYAVZ8ak+G8kqtpaFeaGVcJDxjodYFmC5GJxI nrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1682010083; x=1684602083;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eMADD16mbnU9U9nwmJ1TEHgIp8QQ7hr++iHttnQXxms=;
 b=KvBlljQq1EPXAiIJZCiWOx3iWuG1PyJDdFTyvAzWZv4dLvUr4BGx31NlSLI4IFOcon
 TrPFPBzYP+wZ8z9nFWjusGJUghANjGgHPVifLKdpnZyjZ/7wQbnAQ83b8DynB1Q+nPxK
 V5hSeoUW6VwwJohq9XancNicF/gUqasrPZJEP82kxNJwpLLeR0N1r0v8c8sbmlkiUxFf
 MmLl9s8KBDULxZqipVNFcQrq7dm+CVOqdG+EsLqcxR+RYI8iUvQqjTsp8l3eTH1Bta9r
 BRbS2I8gRGHWGmXUH0Hk7K8rXDo0MGe4vtupwko/iutNfEvQc5DY3bmbUHB9O1y+FZ30 XGrQ==
X-Gm-Message-State: AAQBX9f/LKmkztlqP11xiYmCjgg3iWI2HW5TtE2JT+Fa7KOtQF+Epstz
 GpmAVDupDLDCxs92DDaqNIUbT/bWoxg2fRWw33oMRA==
X-Received: by 2002:a0d:e60b:0:b0:54f:8b56:bb2 with SMTP id
 p11-20020a0de60b000000b0054f8b560bb2mr1413715ywe.9.1682010083088; Thu,
 20 Apr 2023 10:01:23 -0700 (PDT)
MIME-version: 1.0
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
 <d1e719ea-95bf-bb96-62db-e550cefe0a80@linux.alibaba.com>
 <20230419142159.fd5ca2e91658fe304e317a72@linux-foundation.org>
 <20230420-wetten-aneignen-8324959e629d@brauner>
In-reply-to: <20230420-wetten-aneignen-8324959e629d@brauner>
Date: Thu, 20 Apr 2023 10:01:12 -0700
Message-id: <CAGe7X7mLU0JOftGVA+NHabu-9a=fuaofy+KhpvCJFnkRz5ANtQ@mail.gmail.com>
To: Christian Brauner <brauner@kernel.org>
X-Source-IP: 209.85.128.177
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=814 bulkscore=0 priorityscore=100
 unknownsenderscore=20 suspectscore=0 clxscore=284 impostorscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200142
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
 AKy350bdKlWJ3mUZYcfNH5+6kLsgrjcqPufwnq2jGFda8xb8CP+RhVG1NR1ezPFxdvHR+KMEJGITrsU9rzF22PaoKeE=
X-ServerName: mail-yw1-f177.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: T6_f4dl8xwoNFf-Fx4qDyYlVuhdMdyxN
X-Proofpoint-ORIG-GUID: T6_f4dl8xwoNFf-Fx4qDyYlVuhdMdyxN
Reporting-Meta:
 AAFbUQpOowBR84aftdI3lpWdOofWszwgUwvcbWKz+EzQqO685O/WGLRtdL4abwlZ
 NrSX0uVGB/g/LID/3rppLbAp+eeCrJZ8bMKmE7k2n5olKolC7fDrOkPTEmVWhoN2
 BgC8K87bPy5j90lEYUZ5374wMLEn+KVvsBcPprTtss/INJZOaSr7j1AXfgK54RQq
 bQtdEDr8WsX8+yLGGavjRgDFHBgMx8TEGlqdknXlJxSRKm9ZX1dLnPHYClh1SlC9
 HWBGX+PDrUUq3Lnq9k4TuxuB6/wIKem3tMk6IDVSb7Lx+EsnCBBT6JQ+szC2Hf27
 q5rp4Th4ATDUKeLL/AF80l+KYerNjSMyRLhPN0j0qM6AH+d8Bwg3B1n1azlPBUc0
 r43jOr7AadjLHs/ml0xgD5Wx6IhamBJu0oM4peYjrmpbeIzVCCsPS+m9XdjMwiRO
 lrFzp9yYDoRDBy4OIZH5kEtkn06wCHbQe6ZwH0Xa2c+ZIfUkF/DCxejnn1qbZ+rx
 Ho2HUhLVOfeNKt7LfOyt675c71gjJZnM4B4YqLVhzyxc

T24gVGh1LCBBcHIgMjAsIDIwMjMgYXQgMjozNOKAr0FNIENocmlzdGlhbiBCcmF1bmVyIDxicmF1
bmVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+IEkgdGhpbmsgSSBtaWdodCBub3QgaGF2ZSBjb21tdW5p
Y2F0ZWQgYXMgY2xlYXJseSBhcyBJIHNob3VsZCBoYXZlLgo+IFNpbXBseSBiZWNhdXNlIEkgbmFp
dmVseSBhc3N1bWVkIHRoYXQgdGhpcyBpcyB1bnByb2JsZW1hdGljLgo+Cj4gQnkgIndlIiBJIG1l
YW4gcGVvcGxlIHJlc3BvbnNpYmxlIGZvciAiZnMvIiB3aGljaCBub3cgaGFwcGVucyB0byBhbHNv
Cj4gaW5jbHVkZSBtZS4gU28gdGhlIGdvYWwgb2YgdGhpcyBpcyBmb3IgcGF0Y2hlcyBmYWxsaW5n
IHVuZGVyIGZzLyB0byBnZXQKPiBwaWNrZWQgdXAgbW9yZSBxdWlja2x5IGFuZCBicm9hZGx5IGFu
ZCBzaGFyZSB0aGUgbWFpbnRlbmFuY2UgYnVyZGVuLgoKRGlkIHlvdSBnZXQgYnV5LWluIGZyb20g
b3RoZXIgZm9sa3MgaW4gJ2ZzLyc/IFdoYXQgb3RoZXIgcHJvamVjdHMgYXJlCnlvdSBjYXJyeWlu
Zz8gR3JhbnRlZCBJJ20gYSBiaXQgb3V0IG9mIHRoZSBsb29wIHRoZXNlIGRheXMgYnV0IHRoaXMg
aXMKdGhlIGZpcnN0IEknbSBoZWFyaW5nIG9mIHRoaXMuCgpBbmRyZXcgaGFzIGEgd2VsbCBvaWxl
ZCBtYWNoaW5lIGdvaW5nLCBzbyBpZiBoZSdzIHN0aWxsIG9rIGNhcnJ5aW5nCnRoZSBwYXRjaGVz
IHRoZW4gdGhhdCdzIHdoZXJlIEknZCBsaWtlIHRoZW0gdW50aWwgc3VjaCB0aW1lIHRoYXQgeW91
CmNhbiBwcm92aWRlIGEgdGFuZ2libGUgYmVuZWZpdC4KClRoYW5rcywKICAgLS1NYXJrCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBt
YWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xl
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
