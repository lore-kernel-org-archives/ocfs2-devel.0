Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3BEC64ED8
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 11:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=avbVLB0DfxYlrg81VODyQhjT8qT1zsv09Bf7WhkcfqE=;
 b=Mnvxn7bKTi4IwVo7x/D0Qf7dH4CuhXZ5aAl3nmKcKB/+Nndq+FMahuy5npwgZ40/LWBlmNHIKicY
   6OpbH0Syq8I4+rXzo/TZbvhb6gswS7cX/yCJVDyXL1Xejbv1bpC5mq8iR6jK5h8s/bE3il4j6Ere
   wcSPyQEGRlPdgZZ0QhQTJ3ecFy3Gu8IUFt/s+A4/eJJwDMqushoq+oDcKW2s3wAbLtJ4VEiCjLFk
   2ZAMnDm1IJc+B6xugoVe5AMtQ3z3X+kHv2wmtImlZ0fbLGLq6BkDuZ7+hbmxqz1F/0YswIDC3SyU
   Vcu3HBPpP1HmvgvmiNYIRcmd6dHhlQ4TUWv/cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=avbVLB0DfxYlrg81VODyQhjT8qT1zsv09Bf7WhkcfqE=;
 b=G5ghPI1JzX9SfkXGGzL5nWK+cN1An2zI0jgDSOyCMOuMRhK0+adEFqMdKN8m7QOHdE96e2YGn1xN
   /sTl+PMasatkbeyKzjnWzCuiWiLeHx7wwWxVPHZZ2eZ9iYgvfmjSUcO9QZmeWabLUeNRxMbTpGxz
   i7EMWn+zYjSuXn7P3Zw/mrvaPXi/NGGUOr20JumDyFG7lScSzvl1Ec6mSV4V+vRfjvsXQhnMLwcC
   SvGwNbAfY1bOEbxpOrRS76FAklRoHrO2quEjZGf5IMdicjb/DD62YwO2+zeetfCIU25dacnbCNan
   CelOHVGx+VGrliFMefGa/loMIEQCEWTh3xx54w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQK005UQZW3U420@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 11:00:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=+3UtMAjnENsdam0H8Z2Rw6ijK5AlzFt+p/YgWqf8LgM=;
 b=V/Ewmnvq3NxVHYNjGeMOFSUodF+kJAzdQeWr9VxaSN/h1M0PTQypyWdQWcYndMAVNi
 xuL4AHAZilWhjxvtpmW1Casn2w7KzpeR1uLODWJ+IhodvcuTVuPBelekDlxg1e+bV6cD
 LQBN5t0jOWtz0MfPfYawsthDaooK3SOjRb0aWRzI6JGDHuCsPN52OOg8LJ4JH5UU4YPX
 b64erjPZJshc+2rdQLMgl24laBwxZ6O08rYyBarlHsC20agRSrOHmOl12dJ7hoJM1A+D
 UTObWH/lHV/gj+NYCBaIti5B2TNoI0n4zVDvsqDB+uMRomFTTh9RcxWaPO+715DaX/6U wf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+3UtMAjnENsdam0H8Z2Rw6ijK5AlzFt+p/YgWqf8LgM=;
 b=v8orlDKXIltbsQOldeeAkYq3qxYXZobftjf2ItutyePHzD0lKnBbKnljHLYVCwxvU+
 EXiGnOwsMefuWek3ZJq3J8wmKTgG4vlyHG5cQtretrsfzd0wzaTh3Dx/0hEtVjF8XsaZ
 DiQhrqXyFHylh1b0Rz6p5eWLguFpyCImHcODcwy56331+Ql+QGKoEtoIsnxc7xV7UnTY
 edqpVJ3aVtByoGmBc7+MGa6tyXI0Mbz1XRaWVX/v/OKx+gctJeaBRo1qc39Ytb2X8xA4
 7awTcJdGTTcadt8ZUclwevuWdEudr+Y41LFXol3Qkf7KRPhFCokO1S8I7Z/iFcwT2ImB JbIQ==
X-Gm-Message-State: AO0yUKWJFd721IkKADTluzuDgZoBWFmsHrC7dXqtwiNQB8QJ9gKpAjIm
 wu8k20/F14YPGBzpWWty+PY=
X-Received: by 2002:a05:6a20:6909:b0:cc:f39:5094 with SMTP id
 q9-20020a056a20690900b000cc0f395094mr8325446pzj.30.1677236390252; Fri,
 24 Feb 2023 02:59:50 -0800 (PST)
Message-id: <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
Date: Fri, 24 Feb 2023 18:59:47 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
In-reply-to: <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
X-Source-IP: 209.85.214.175
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=313 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 unknownsenderscore=20 clxscore=29 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000 definitions=main-2302240090
 domainage_hfrom=10057
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AK7set9NAXwMHQWpJ7N51yGMmfOq0LRvnigvOnR8cc54hjOUxwwSYNrF3U/jTiXorBuPRev12VARcQ==
X-ServerName: mail-pl1-f175.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: BISj1JSZNW0uC6Skkoc62_ViUvnH6yvI
X-Proofpoint-ORIG-GUID: BISj1JSZNW0uC6Skkoc62_ViUvnH6yvI
Reporting-Meta:
 AAGyQ4kTxpFWJpOAoy0s+a7K0fe02SpFZK+P5TNC1b6/wECWODd/VcVJXzcjNTMP
 I68WhPrZGD9i10KvP53eBU81Ohmg34FyuVZgkhazdzUwVt5gvQz46myvuQpqEFC5
 NekRqbdszoWv4yEhdN0IfYo3H3Z+EBQpHEkmy+lnz5Gs3hLi/3eha4LoYIp0MMt2
 nzATXWMT04ej79Fy7bCN7qqN6bWyg0W/zQiG6slcihYMF2N0wbHPpKBXR4g91GYs
 TxbdGm3hLXCH4SuVnSvMZWE5o+SjhVeCDk+FGy19Jz476C0jI4+fvqqmF/HApxEr
 w+kSonocjbyjZxdwWLrKtHnJfeFLd6AZXcX13FSFgXAY98Uvkan5nzbtYUfTPIcj
 EEczcpydnXFModFVW9+CYpBDk0kq/WXqZsrLVVY5pJO7+LQY80UWGGKFoOgN9JZH
 6Gwrl9yN8XObq8CKCelnDXPlf8AxCkcxh3GQJvHxPL+ozTSiXGsOexSY3kmnjjDQ
 RgtvYEjPvUIimTJE2DymzUHWtKG1kVI/Unzj4BgpVaQ=

CgpPbiAyLzI0LzIzIDQ6MDMgUE0sIEhlbWluZyBaaGFvIHdyb3RlOgo+IE9uIDIvMjQvMjMgMzo1
MiBQTSwgSm9zZXBoIFFpIHdyb3RlOgo+Pgo+Pgo+PiBPbiAyLzI0LzIzIDM6NDggUE0sIEhlbWlu
ZyBaaGFvIHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToKPj4+IE9uIDIvMjQvMjMgMjo1NCBQTSwgSm9z
ZXBoIFFpIHdyb3RlOgo+Pj4+IEkgY2FuIHJlcHJvZHVjZSB0aGlzIGluIG15IGxvY2FsIFZNLgo+
Pj4+IEkndmUgdHJhY2VkIG9jZnMyX2Rpc21vdW50X3ZvbHVtZSBhbmQgZm91bmQgdGhhdCBpdCBo
YXNuJ3QgYmVlbiBjYWxsZWQuCj4+Pj4gU28gRUJVU1kgaXMgcmV0dXJuZWQgaW4gVkZTIGxheWVy
LiBJIGd1ZXNzIHNvbWV0aGluZyB3cm9uZyB3aGVuIGRvaW5nCj4+Pj4gYSBjb3B5IHdpdGggbGlu
a2VkIFNRRXMgKG5vcm1hbCBjb3B5IHNlZW1zIG5vIHByb2JsZW0pLgo+Pj4+Cj4+Pgo+Pj4gSSBh
bSBpbmNsaW5lZCB0byBhZ3JlZSB3aXRoIHlvdS4gSSBhbHNvIHRlc3QgbGlidXJpbmcgZXhhbXBs
ZXMgYXBwcwo+Pj4gb24gZXh0NCBwYXJ0aXRpb24sIGV2ZXJ5dGhpbmcgbG9va3MgZmluZS4KPj4+
Cj4+PiBJIHVzZWQgYmVsb3cgYnBmdHJhY2UgbWV0aG9kLCB0aGUgcmV0dmFsIGlzICczJy4KPj4+
IMKgwqBicGZ0cmFjZSAtZSAna3I6bW50X2dldF9jb3VudHtwcmludGYoIiVkXG4iLCByZXR2YWwp
O30nCj4+Pgo+Pj4gSXQgcmVzcG9uZHMgdG8gZmxvdzogcGF0aF91bW91bnQoKSA9PiBkb191bW91
bnQgPT4gbW50X2dldF9jb3VudCAoZ2V0cyAnMycpCj4+Pgo+PiBZZXMsIHRoYXQncyB0aGUgcGxh
Y2UgcmV0dXJuIEVCVVNZLgo+PiBTbyB0aGUgcHJvYmxlbSBzZWVtcyB0byBiZSBnZXRtbnQvcHV0
bW50IG5vdCBtYXRjaCBpbiB0aGlzIGNhc2UuCj4+Cj4gCj4gSSBkaWRuJ3QgZmFtaWxpYXIgd2l0
aCBzZXR0aW5nIHVwIGtlcm5lbCBiaS1zZWFyY2ggZW52LiBJIHVzZWQgb25lIGxhc3QgeWVhcgo+
IG9wZW5TVVNFIHR1bWJsd2VlZCAod2l0aCBrZXJuZWwgNS4xNi4yKSwgdGhpcyB1bW91bnQgaXNz
dWUgZG9lc24ndCBleGlzdC4KPiBTbyB0aGVyZSBpcyBhIHBvc3NpYmlsaXR5IG9uZSBvY2ZzMiBj
b21taXQgaW50cm9kdWNlZCB0aGlzIGlzc3VlLgo+WW91IGNhbiBjaGVja291dCBlYWNoIG1haWxp
bmUgdmVyc2lvbiBsaWtlIExpbnV4IDYuMCwgNi4xLCAuLi4gYW5kIHRyeQp0byBjaGVjayBpZiBp
dCBjYW4gYmUgcmVwcm9kdWNlZC4KCkkndmUgdHJpZWQgdHJhY2UgbW50Z2V0L21udHB1dCB1c2lu
ZyB0aGUgZm9sbG93aW5nIGJwZnRyYWNlIHNjcmlwdCwKbGluay1jcCBvdXRwdXQgc2hvd3MgaXQg
bWlzc2VzIGEgZnB1dC4KCiNpbmNsdWRlIDxsaW51eC9tb3VudC5oPgojaW5jbHVkZSA8bGludXgv
c3RyaW5nLmg+CgprcHJvYmU6bW50Z2V0CnsKCSRuID0gKChzdHJ1Y3QgdmZzbW91bnQgKilhcmcw
KS0+bW50X3NiLT5zX3R5cGUtPm5hbWU7CgoJaWYgKCFzdHJuY21wKHN0cigkbiksICJvY2ZzMiIs
IDUpKSB7CgkJQFtjb21tXSArPSAxOwoKCQlwcmludGYoIiVzIiwga3N0YWNrKTsKCX0KfQoKa3By
b2JlOm1udHB1dAp7CgkkbiA9ICgoc3RydWN0IHZmc21vdW50ICopYXJnMCktPm1udF9zYi0+c190
eXBlLT5uYW1lOwoKCWlmICghc3RybmNtcChzdHIoJG4pLCAib2NmczIiLCA1KSkgewoJCUBbY29t
bV0gKz0xOwoKCQlwcmludGYoIiVzIiwga3N0YWNrKTsKCX0KfQoKSm9zZXBoCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5n
IGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
