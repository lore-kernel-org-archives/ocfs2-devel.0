Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6CDC74A5B
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 23:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AbFU/XjGsbRZVN/hCRQwuZmOCPeIMvJSVQGq8L1T6+o=;
 b=YqTRrD7A98JqmeNUCCAwoTCT07syW62aDqRwdJEhh3Jci3kSzmCMdDNSLhGSH2/Kl3NZ07oYc4H1
   iecNgYrAElVujxlmHtdEUGji/e2hOUr2WfJsCcfLCWNFuMfM8YiW5I98Ub2kw70dSa0O0HCaiAju
   jW6L6isBXrG0OeLicV+59lDcN3VryI/WS6IFTMmM+M4nBSnP5h2FiS9GBSEi42jk/r/N28wBFzdF
   yGa+zojDs9f7PEh8+CLnzAtVPreSwLBgOpHjxygvgmkbSb0NYA17qpu/lfv2t9mrD1sE0x7mgKq0
   uz8p1eDO7zk4PL7FxP308nVkAmKwU11E+sbkJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AbFU/XjGsbRZVN/hCRQwuZmOCPeIMvJSVQGq8L1T6+o=;
 b=R2xJzimhFplSfHKpwdQhzRFXGSDQOIOkK7ofKJSPALfNRkf7q/0+Mq9aRUGAyu8E1l1q53UdEtoo
   osa2BP180CdcaQyWNhulH/On2noAPSXqIr6YHn+LXRxvpjNQ2i4cBQfI0tuSuVfbAGu5cgW8Y9Nf
   rQzvRuzvGXtz4s15U9id/nqfX6JnGgws/JFXUM3rr6PYm+/xU5nUrvxHr+Grxjq6kWS5mZwXMHe3
   /QaPFp8zobCYMT7T20TrcBJ/Sn8hNMWZLgd+wTAWE29rMSKxh/Ld5IKcbbQ8ebRpEmop/9YWS2gr
   n+5sg4yOPEac7+KWCOo0rQGqgehwZ9vliRh9tA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RRZ00OE8Z611Z60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 23:42:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1679614909;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=thV1/AZ1OuJuOWPw7pjV/QbFzpiTpQJ2MyO692gPvR0=;
 b=NYkNtemoCv6R5EsPq8GFyteH85EBMhiY99YqBUPV0GxorXDwZ4BHHPSZ6jApnoObXy
 jGQ/kATiHKMLZEW++ynU0B7JvOnCW6cBkdelAe/3hXU6fX57j670XX0rdqwWEYgEBugM
 uXcC0JuwpCs8op/L0zT4SdZ8DdAjD9nJ8c0NLjQvRMVrAIgmxl8MSQsY0g9jf308b89O
 Ny5DEfLM2K0uAK/anxZCKnpF3xg64462iQnVBf3Q5lJZlNStMNfnnwO2+brs/NhCVAH/
 gJkJnPcj4CS9WDqN5OLuvgCi/tHgzFwLERnhG7WUmCoHefD/Y/pZw1AJClRi01+wp5BC dMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679614909;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=thV1/AZ1OuJuOWPw7pjV/QbFzpiTpQJ2MyO692gPvR0=;
 b=HWaHzneGr5lrwHnnLz2UyrzXjevfhPPwVs5WkhwP3e1SiErdJy/jfCxG9npnoBZyuo
 AdKZQzwJOQPrviWmIJbpm+2m8O+6J1vJjILXKR18HAx5rpcjbmX9XYJDBvWw8higEplW
 j6N/hWHBui/KlcqOdL1TazzILKUsFPN+blLXY/aCTJqrXcf5w3glPq3AWjwSfE1SvDAe
 MKYKJ32aGd7CZ3zN4wOQFEkXnBpiJx5910jNu9X8g2ovwiQFxd0FrO3jg30lflL3cXzY
 EQqlQwVMrzQQxFn5kRvdxg/rYTtvX8zy87kOWnvCLll+akqkcjPkwBlSeGBQvsnsLBIj dWPQ==
X-Gm-Message-State: AAQBX9cx9F33GJG3Bc7wUAMUm2WnnpS/GPrv0XhAcvvw2svqaKFQoZyW
 WiNgqvkE3xOaI+ZCqqSv1kckVbzVVBde4x3g6A4v
X-Received: by 2002:a25:db91:0:b0:b75:8ac3:d5d9 with SMTP id
 g139-20020a25db91000000b00b758ac3d5d9mr202424ybf.3.1679614909693; Thu,
 23 Mar 2023 16:41:49 -0700 (PDT)
MIME-version: 1.0
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-4-roberto.sassu@huaweicloud.com>
In-reply-to: <20230314081720.4158676-4-roberto.sassu@huaweicloud.com>
Date: Thu, 23 Mar 2023 19:41:39 -0400
Message-id: <CAHC9VhS4=bH1nO6eag7zLOQrx80AAqsnCZPPJsTZ1wcQXSn0uw@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.219.181
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10658
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=60 adultscore=0 impostorscore=0 phishscore=0 mlxlogscore=848
 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=105
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303230171
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v8 3/6] security: Remove
	security_old_inode_init_security()
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
From: Paul Moore via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paul Moore <paul@paul-moore.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350Y07LmdJ00VZHB5SCSf+bLOqKsfH0jPu8dbkgkADvJ+KRyt25TCp5x1Uyuw9HiLKhJv2/hToxbHH1V58rKDxHw=
X-ServerName: mail-yb1-f181.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: hI3HMnG1Z-md1GhO3RTJQxp-FAN_STDS
X-Proofpoint-ORIG-GUID: hI3HMnG1Z-md1GhO3RTJQxp-FAN_STDS
Reporting-Meta:
 AAHZIguoNulSVExU/MMhgAmkvh7/BtDhYulcI2XadnuxeaOZEjnwaearIs+IAXfk
 X6Uith2kt8AYEUEmiGyUqaV0ahbmh4vn3xWGDuBRdR8sYunmHeUMtXEmDKjJZz9p
 yK4pqnWSpGlLVtLJdO629ZiTLbvlId3V2EqdfhQREAB4PJAPjSDuqGQ9gIIXSrwl
 ihmMp93FcudQv3VHgz2Zn1YmXjhPZ2HsegAwodWTMa3IL9C8B4I9eCi7TeaO5168
 XrMOjZ9fx/tRV7JlZmJmF/6c9CJZUiBvK7ByNLOLJSYz24n7F3bXNCCFmexhzJrO
 yy4jVkFGoX+vRX4DUEbNQrNrqHWDLyT8U5y/yqIr1idT4g93Ij/vSrptyJNvo4tD
 gvkIkPkpvk//f141MBw+5IWqcd7/x7yKpspMbA9kzh0c4vqxU/cwIeNkdy1J+tgf
 1wPIdbf7jqOxBK+2p5hR5MPjfoGj/7ImcXYps1jM8RNLm3QDOt7PW5xAdxVbjPxa
 uReeeqtKGXJ0FE9fYQULsiakLArP+aAliaMl9YM1NrDN

T24gVHVlLCBNYXIgMTQsIDIwMjMgYXQgNDoxOOKAr0FNIFJvYmVydG8gU2Fzc3UKPHJvYmVydG8u
c2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPgo+IEZyb206IFJvYmVydG8gU2Fzc3UgPHJv
YmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4KPgo+IEFzIHRoZSByZW1haW5pbmcgdHdvIHVzZXJzIHJl
aXNlcmZzIGFuZCBvY2ZzMiBzd2l0Y2hlZCB0bwo+IHNlY3VyaXR5X2lub2RlX2luaXRfc2VjdXJp
dHkoKSwgc2VjdXJpdHlfb2xkX2lub2RlX2luaXRfc2VjdXJpdHkoKSBjYW4gYmUKPiBub3cgcmVt
b3ZlZC4KPgo+IE91dC1vZi10cmVlIGtlcm5lbCBtb2R1bGVzIHNob3VsZCBzd2l0Y2ggdG8gc2Vj
dXJpdHlfaW5vZGVfaW5pdF9zZWN1cml0eSgpCj4gdG9vLgo+Cj4gU2lnbmVkLW9mZi1ieTogUm9i
ZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPgo+IFJldmlld2VkLWJ5OiBDYXNl
eSBTY2hhdWZsZXIgPGNhc2V5QHNjaGF1Zmxlci1jYS5jb20+Cj4gUmV2aWV3ZWQtYnk6IE1pbWkg
Wm9oYXIgPHpvaGFyQGxpbnV4LmlibS5jb20+Cj4gLS0tCj4gIGluY2x1ZGUvbGludXgvc2VjdXJp
dHkuaCB8IDEyIC0tLS0tLS0tLS0tLQo+ICBzZWN1cml0eS9zZWN1cml0eS5jICAgICAgfCAxMSAt
LS0tLS0tLS0tLQo+ICAyIGZpbGVzIGNoYW5nZWQsIDIzIGRlbGV0aW9ucygtKQoKTWVyZ2VkIGlu
dG8gbHNtL25leHQsIHRoYW5rcy4KCi0tIApwYXVsLW1vb3JlLmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0
Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
