Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61DDFC61DA3
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 07:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+G6d0HS2MSL8T4S6uUVe63KOrLZdD2+zCajcrq02Hjk=;
 b=OlJeeyZeA5K24yQ9Va+ey6IUgZapMoha7bp3TI+4fQgf6s4LCaAyRbeBeF07/mLE2PYP+kTX4mKs
   GKMIzxLCJBb04fg9w5ezoJJ2WGtoEWYp9rLF33/IbJ4A90KFmbPs4Pi2tv0naofmEKKVcNTGuxQA
   LfYJIr+oxMUnQkc02dKmRdBxQt0LOy3FadXGqcb+OYB2t7ivOVYW0925Lq3TPVvInX5MxZ4iH4eF
   quAYT0ggeoMucRZ/59Et2OU2fOBvOgzEu98BxkYA7KRXpezuPBa3jvBouamTzw6TztPAJtSgLDn1
   8EzV198QPCD3dDZKp165e57nNFPpWqHD5ng+mA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+G6d0HS2MSL8T4S6uUVe63KOrLZdD2+zCajcrq02Hjk=;
 b=d3DsrGnin3jEYfqp6tzO0u1z/feLXzTpjGJ1bqBhnbiV7ZjhMsa8rJHvdmYmL2MftlygNt/z7McO
   ygzc1+/riwMIcNxvmjteL9T2LNjCoGihYQJ2sSV/dEl4quVv0tGz2THPGwQgJYBN1MzyGuGGV3TU
   U9HWhog3Bl/SFJchuXga5SC8R/33OsEs9Vuq+fCl101KhUAU8PV/c8MeBUoTLQ/pa4ttJTeWDNMU
   eS6nUgEknxbQswt+9jtAfC1MPleIYklGu9wwd8yb1hokWzLaVvO0WVAUbF2vWlCgP9s+362zH+8h
   3M+qu6MhFX495qAfg+co+rx6MXn5GlnRIvho4g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQK00560R815VE0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 07:52:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=i1NZaUzE86DLP3hjzIfA8vAJG7Pi2ahzcpABOTp0M8k=;
 b=adERdgCAhZ22+JKkgvGKsApWdJUcSEll3mswscYMM9/jtsZYLNiSuz0XsISOXTdI5v
 9g41yGgiVkEPKWGTrnwJ6GIqOWB2yKe0Gb7ThKWL/V/+Nm9sEP51J2mgJRqZIcdyHOHv
 faQxh9P+eiAKmAoqPfh0emXT9ijRSJ6xEga/85LE74W3Iu/6Ok1SmCVsKvpuMAsOLuF+
 fFCvAx3Mc15Q4Y/Opp35QWtKf2KXIIwefoB/HlmK6zbdEAPmGFhuADCKmNPDoDzxxJ99
 twcOYRPDaFb5xzFt06t5aQS2Ilj/hCYyKo/uuAvXz67ej14ZW/7qmmWDtAfPejNN7VMd K7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=i1NZaUzE86DLP3hjzIfA8vAJG7Pi2ahzcpABOTp0M8k=;
 b=EYmfBAIcp1zmhTDR3pwhCCXzbur0XCQahwcnHtKmZxJR3Tj8N0OjeP6ByNPHNNF9+E
 sgVX6PD42COHgqNVfN/cMk7A8TSCDm46f6O1CqCvdDb9TWvt7hGEozS+B3ZsHrqJEZEX
 m/GVwJmFyhsEQtAAJh1eUjx+/TZ3HKuHOAYF25SwIO5dRM//WoK66PIBe+wCUIZwE201
 abNeYSkM22rqucUlBSdktStJ2GwKCH0Bj1W7/4booUFqEIEzvo1jAyms6im9GJ/0wGbU
 1EJIl5Nui7Slu/UfSCqO2OpmdiJGMBN0xpqLxsjzdXPXOZAjHtArFV9fbI2wMkKue9x2 rITw==
X-Gm-Message-State: AO0yUKWcqCN5vaBzx1O5h4k3je6lfrVPXrM7NG/kCOLQnhHBQEK3IpS4
 xbkduw2uhbV7fGMj0oAuHc4=
X-Received: by 2002:a17:903:41cd:b0:19c:1455:d588 with SMTP id
 u13-20020a17090341cd00b0019c1455d588mr14022640ple.0.1677225156242; Thu,
 23 Feb 2023 23:52:36 -0800 (PST)
Message-id: <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
Date: Fri, 24 Feb 2023 15:52:33 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
In-reply-to: <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
X-Source-IP: 209.85.216.42
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 unknownsenderscore=20 malwarescore=0 clxscore=197 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0 priorityscore=266
 impostorscore=0 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000 definitions=main-2302240064
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
 AK7set+jH4kk2AaFhMUZrA9X7rLGNXIyPEOxV5h2ps0tBcRIFrPnIBAEVUQ6J4t3IiNGbK96vYOj9w==
X-ServerName: mail-pj1-f42.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: E7GCoDeHYC20HiYevpLVg9XzK1pVMnTr
X-Proofpoint-GUID: E7GCoDeHYC20HiYevpLVg9XzK1pVMnTr
Reporting-Meta:
 AAFsCIUau8KG7Mp8n0YT9uw83xUGxMCfCZeFkuMDNquEZtE74DYsqXv6RoGY4TYK
 D93Eq8g3qo/szsQP+yY+i0wkJk1czlbdLFAICujCCLNGBm3cFKV5YsHBOqtMHE5F
 GrB1RE19nbB4/UEKeBwXnJ0dtlW88hFdB1AqGMxf5xH4AJMixCtJ48NLeY5WOJXL
 3Z7zobbvXaJHPCq7zomSiTMgrDgzyW4JXjUkZtXiIOOS3eAYnk6BicTrZasLoI1r
 gHBILdSHZNcsjYjvDfSZrhU75qfbL/VwcOstasFLq5s1TGSCScCqtjVTIs0G8x3C
 KHZt+YluHG0/6Wy9zzcPyrQqwJ1DpJ7oyVWDT81robZ7uvVPK9gBQdzv1wb83ksq
 y13Ehji+/omHHsYATzeG48Z3Ocn9shaXU0A7u/oTFV2Us1Dzk/PcFW6vIgs7meB2
 r8FpZNi1m5yXBtYhgmtOGeYKrNUKrcsXe0JC3Kk9u9Vg3xwp37W/L8SiT5xBGOrT
 dfw+a2eyzLraolXiIzgYjs7e8LKAmM7WdzlePBswOd0=

CgpPbiAyLzI0LzIzIDM6NDggUE0sIEhlbWluZyBaaGFvIHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToK
PiBPbiAyLzI0LzIzIDI6NTQgUE0sIEpvc2VwaCBRaSB3cm90ZToKPj4gSSBjYW4gcmVwcm9kdWNl
IHRoaXMgaW4gbXkgbG9jYWwgVk0uCj4+IEkndmUgdHJhY2VkIG9jZnMyX2Rpc21vdW50X3ZvbHVt
ZSBhbmQgZm91bmQgdGhhdCBpdCBoYXNuJ3QgYmVlbiBjYWxsZWQuCj4+IFNvIEVCVVNZIGlzIHJl
dHVybmVkIGluIFZGUyBsYXllci4gSSBndWVzcyBzb21ldGhpbmcgd3Jvbmcgd2hlbiBkb2luZwo+
PiBhIGNvcHkgd2l0aCBsaW5rZWQgU1FFcyAobm9ybWFsIGNvcHkgc2VlbXMgbm8gcHJvYmxlbSku
Cj4+Cj4gCj4gSSBhbSBpbmNsaW5lZCB0byBhZ3JlZSB3aXRoIHlvdS4gSSBhbHNvIHRlc3QgbGli
dXJpbmcgZXhhbXBsZXMgYXBwcwo+IG9uIGV4dDQgcGFydGl0aW9uLCBldmVyeXRoaW5nIGxvb2tz
IGZpbmUuCj4gCj4gSSB1c2VkIGJlbG93IGJwZnRyYWNlIG1ldGhvZCwgdGhlIHJldHZhbCBpcyAn
MycuCj4gwqBicGZ0cmFjZSAtZSAna3I6bW50X2dldF9jb3VudHtwcmludGYoIiVkXG4iLCByZXR2
YWwpO30nCj4gCj4gSXQgcmVzcG9uZHMgdG8gZmxvdzogcGF0aF91bW91bnQoKSA9PiBkb191bW91
bnQgPT4gbW50X2dldF9jb3VudCAoZ2V0cyAnMycpCj4gClllcywgdGhhdCdzIHRoZSBwbGFjZSBy
ZXR1cm4gRUJVU1kuClNvIHRoZSBwcm9ibGVtIHNlZW1zIHRvIGJlIGdldG1udC9wdXRtbnQgbm90
IG1hdGNoIGluIHRoaXMgY2FzZS4KClRoYW5rcywKSm9zZXBoCgo+IAo+Pgo+PiBPbiAyLzI0LzIz
IDg6MzIgQU0sIEhlbWluZyBaaGFvIHdyb3RlOgo+Pj4gSGVsbG8gTGlzdCwKPj4+Cj4+PiBJIGZv
dW5kIGEgd2VpcmQgYnVnIG9uIG9jZnMyLiBJIGFtIGJ1c3lpbmcgd2l0aCBvdGhlciBqb2JzLCBp
ZiBhbnlvbmUgaGF2ZSB0aW1lCj4+PiBoZS9zaGUgY291bGQgZml4IGl0LiBUaGlzIGJ1ZyBpcyBi
bG9ja2luZyBmc3Rlc3QgZ2VuZXJpYy8wMTMgdGVzdCBjYXNlLCBhbmQgYWxzbwo+Pj4gYmxvY2tp
bmcgZnN0ZXN0IHRvIGRvIGxhdGVyIHRlc3QgY2FzZXMuCj4+Pgo+Pj4gSG93IHRvIHRyaWdnZXI6
Cj4+PiBgYGAKPj4+IGdpdCBjbG9uZSBnaXQ6Ly9naXQua2VybmVsLmRrL2xpYnVyaW5nLmdpdAo+
Pj4gY2QgbGlidXJpbmcKPj4+IG1ha2UKPj4+IGNkIGV4YW1wbGVzCj4+PiBtb3VudCAtdCBvY2Zz
MiAvZGV2L3NkYSAvbW50Cj4+PiBjcCAvZXRjL2hvc3RzIC9tbnQvYQo+Pj4gLi9saW5rLWNwIC9t
bnQvYSAvbW50L2IKPj4+IHVtb3VudCAvbW50Cj4+PiBgYGAKPj4+Cj4+PiB1bW91bnQgdHJpZ2dl
ciBlcnJvciBtZXNzYWdlOgo+Pj4gYGBgCj4+PiAjIHVtb3VudCAvbW50Cj4+PiB1bW91bnQ6IC9t
bnQ6IHRhcmdldCBpcyBidXN5Lgo+Pj4gYGBgCj4+Pgo+Pj4gVGhlIHVtb3VudCBlcnJvciBjYW4g
b25seSBiZSB0cmlnZ2VyZWQgYnkgbGlidXJpbmcgd3JpdGUgb3BlcmF0aW9uLgo+Pj4KPj4+IFRo
YW5rcywKPj4+IEhlbWluZwo+IAo+IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCj4gT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Cj4gT2NmczItZGV2ZWxA
b3NzLm9yYWNsZS5jb20KPiBodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpo
dHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
