Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DAAC64EC4
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Mar 2023 22:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TWHleSnOkYY7wljxADwH2nlnfNlAyRzzrYYFW3EnvHU=;
 b=K2VkXGR8XFRMFtENco3b8MuqyMcpuxNfdZG+zrXJ8v0xbliilMMOveyoUsJ8DZ8VKvEKV1VaiOEq
   paEVrl3pdlpF6zOc1gl4qUyDNpg2qCWqdooAotSqc0AbDs3/10sSLL3rJAhRGhsdR8np9iS5f3A0
   pL7fyjB2gJ3E2DtDnCDZLU0+HVkgoCZEALncxUaa3UEiD7nHXjxfpg2+LLjoHmEHlLo/R+P/2Tzw
   z6VF91lA315t8V7AncgypQW5vUki7DSOYyYk9Q4dA3wBE6GARZ0TCns8kYp19qFdweM6jDQfbQ7J
   fC3UuTzp08BEuSBekfp+2xyLSQRIetvySLjtvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TWHleSnOkYY7wljxADwH2nlnfNlAyRzzrYYFW3EnvHU=;
 b=BtwesyvN7FhiNxHrOckqQFIpABC41llOnWhKNpTbncRVXFYBOpBnulzeOAKxMGsrgTOE+shCVgku
   xpEmA5dufyruNO+JSVW4DWJ5kGvapy7QKAPeUuxB+tnW3uRsXMYh8Mc2gYyysDtC4efINtfnntuQ
   fGAkxYC0D5J6XcixumEjd1oldmZ5khHx6p9mBp3en9oRCBhsdkDgAT1UxCRKNekTqCCYK7/6DMDD
   JGudBxECv6VhyX6zR1kAjE31lmhkGhYJ3wgfm3lb5f99PId3UDJ8djHEa713wNM7EtiNEstLDomo
   v3e7I/SuMcyHHscwDyEurgXS3UKM4RkWAnbhIA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR800D50386PM60@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Mar 2023 22:16:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1678313798;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=tkhViH9kdWNjYXwKnPEs08Xl3095dV6IZ6LM3uHmPgg=;
 b=bPXrjsfNIA8aCilQN80V8tZJJRnYiUaUiYYE6WDP0poZXHmgRnngHO4Lb96J8qrY8s
 0UFv5K7lMRJloKD0tWGMmVKDB1rB7L2PYgY245lC/cGDS2TdHabWAHsD74tYHk7XWX+9
 ctSErcrpU4ra1h7MNt4j2JB1T46qH5KSu8XZMjjoIq7fVYdLws67bRDNtSSAyq5ddIEU
 URzRfvXhHoHE7mhDjTIo/KgBW+4k4yBsfFL5q4a+jwiG/cTxuGsLWCziz32JVyllZ+pC
 DZbdjHIIJFo9Zy6iaSLyCS5thVAOwak49iMLSnuOr6HQ+YCMlQc6/QjcnOmMkEQALnF5 7qLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1678313798;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=tkhViH9kdWNjYXwKnPEs08Xl3095dV6IZ6LM3uHmPgg=;
 b=U5cul07iRRI16Jalv/TWWcbX6Uq5ehXr//rnopowsDVczi3DLHXXcseoSNcLuRZIlb
 uTlHHBYazh6huriRJH3+GOKIdu0kU4wGxH52kLNhy4IBcwqWAjSPlrpoWDff8XHlUygq
 MRC0C2WrfP6ci5U8tPCCtnYfLesQVCKnkbKvc3qY7/R/kKQCglt9eFJwWbMjyxHbSHwr
 sAD89WZjP6cTXQsz+vrdQb6MLUrd56g0kCfRAemLeL96nGjPJROoSVFqNHhGDGgJhiZ7
 wrMe24p30DIMK1cZIwmmcpsKxkur5AqAsGCQuqoUgZFT7nHzdlI5ZtoI2iEUKtG1nXRs rkew==
X-Gm-Message-State: AO0yUKXxB9t+6KvRw9jz3o2zKhqe1XEabR6YCkSz7nBtzJZvkG/tKUA9
 KqQA8NLueKNkHHI78/ols9Ryh8Qb1rf2lZ/wb3Gh
X-Received: by 2002:a17:903:2587:b0:19a:9f86:adab with SMTP id
 jb7-20020a170903258700b0019a9f86adabmr7646529plb.7.1678313797868; Wed,
 08 Mar 2023 14:16:37 -0800 (PST)
MIME-version: 1.0
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
In-reply-to: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
Date: Wed, 8 Mar 2023 17:16:26 -0500
Message-id: <CAHC9VhTRT=o9Rv+EhZ4aab1FDCyTNa7XEYuhuOiSEkWh0Cdrnw@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.216.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=60 malwarescore=0
 mlxlogscore=464 adultscore=0 clxscore=163 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080188
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v7 0/6] evm: Do HMAC of multiple per LSM
	xattrs for new inodes
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
 AK7set++0GvPRL/fArYHKN0SqlsLssuQ2AVagfsEuJmq+L5qFprSO0qSDic4f0ylWLwNIoHyQ3gpdgkwfLpUMJ7FI+Y=
X-ServerName: mail-pj1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 4B1OizrMxUBSvD_-gNPJTkZjHBInNQVy
X-Proofpoint-ORIG-GUID: 4B1OizrMxUBSvD_-gNPJTkZjHBInNQVy
Reporting-Meta:
 AAGgaocKzds9l9bXpY6Q1t3ZjNHxINYgCY1KXjeEThBX0bdIdnXW2Hx2tPt10Fxa
 wFeCeFToLMDZKCbv8hgRSMtsw2I3ExD1j0w1BCgyW9FrSU6oE5jsxAZBsR5md7yG
 mAYue898WiGpDrIXpdkHEbJZe8IItj1F01BrNGKwmDjJk2ZeE43Ou46Ew/Hx52Fx
 ncuYQSNkmhoa3mlmogn2QDrv3AOBJ9drFLyQiRO4IbIm1s/uFcwlzKasf9Cx70DI
 G72LBDqFT2iNSM/4htf6RBzNmUWHYwsx38qFnIHd6oWcMuFCTgTNsZuyyh9FYJpR
 SmkeJNvU8CJs0tDiwWooHa7ubvEZA0j4ZEc+KUYK21tOjKOuCxPwSVQfSZDM8A0a
 3tBL07RJF61n8gGwZwupOBEKKNavD8qtNIK/vvPuVyieSnNU32WTPD7HfKx5kcWJ
 SqfwpqJcguhC4tziYwqSMV15QjIl6VSUz1Q23TCPxONPWky5xmx9qphFjYHmp+JK
 IzTCOXhMhnpS/mL23cKrA046HAmB4Hp4g/lHVFsodu0=

T24gVGh1LCBEZWMgMSwgMjAyMiBhdCA1OjQy4oCvQU0gUm9iZXJ0byBTYXNzdQo8cm9iZXJ0by5z
YXNzdUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+Cj4gRnJvbTogUm9iZXJ0byBTYXNzdSA8cm9i
ZXJ0by5zYXNzdUBodWF3ZWkuY29tPgo+Cj4gT25lIG9mIHRoZSBtYWpvciBnb2FscyBvZiBMU00g
c3RhY2tpbmcgaXMgdG8gcnVuIG11bHRpcGxlIExTTXMgc2lkZSBieSBzaWRlCj4gd2l0aG91dCBp
bnRlcmZlcmluZyB3aXRoIGVhY2ggb3RoZXIuIFRoZSB1bHRpbWF0ZSBkZWNpc2lvbiB3aWxsIGRl
cGVuZCBvbgo+IGluZGl2aWR1YWwgTFNNIGRlY2lzaW9uLgo+Cj4gU2V2ZXJhbCBjaGFuZ2VzIG5l
ZWQgdG8gYmUgbWFkZSB0byB0aGUgTFNNIGluZnJhc3RydWN0dXJlIHRvIGJlIGFibGUgdG8KPiBz
dXBwb3J0IHRoYXQuIFRoaXMgcGF0Y2ggc2V0IHRhY2tsZXMgb25lIG9mIHRoZW06IGdpdmVzIHRv
IGVhY2ggTFNNIHRoZQo+IGFiaWxpdHkgdG8gc3BlY2lmeSBvbmUgb3IgbXVsdGlwbGUgeGF0dHJz
IHRvIGJlIHNldCBhdCBpbm9kZSBjcmVhdGlvbgo+IHRpbWUgYW5kLCBhdCB0aGUgc2FtZSB0aW1l
LCBnaXZlcyB0byBFVk0gdGhlIGFiaWxpdHkgdG8gYWNjZXNzIGFsbCB0aG9zZQo+IHhhdHRycyBh
bmQgY2FsY3VsYXRlIHRoZSBITUFDIG9uIHRoZW0uCgpIaSBSb2JlcnRvLAoKVGhlIHY3IGRyYWZ0
IG9mIHRoaXMgcGF0Y2hzZXQgaGFkIHNvbWUgZ29vZCBkaXNjdXNzaW9uLCBhbmQgYmFzZWQgb24g
YQpxdWljayByZWFkIG9mIHRoZSBjb21tZW50cyBpdCBsb29rcyBsaWtlIGV2ZXJ5b25lIHdhcyBl
dmVudHVhbGx5CnNhdGlzZmllZCB0aGF0IHRoZSB2NyBkcmFmdCB3YXMgZ29vZCBhbmQgbm8gZnVy
dGhlciBjaGFuZ2VzIHdlcmUKbmVjZXNzYXJ5LCBpcyB0aGF0IGNvcnJlY3Qgb3IgZG8geW91IGhh
dmUgYW4gdXBkYXRlZCBkcmFmdCBvZiB0aGlzCnBhdGNoc2V0PwoKLS0gCnBhdWwtbW9vcmUuY29t
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1k
ZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mu
b3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
