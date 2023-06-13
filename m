Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01204C7EE29
	for <ocfs2-devel@archiver.kernel.org>; Tue, 13 Jun 2023 07:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lEgcZQJiRX6znOOIDxOvTFtW2/q7Pr/EkAYDlrGC5v4=;
 b=LwNdzzg+DZ4GRQoh5bKT2txgVqgAJcXqek61/avSc3an9jZlkh4KlR/8PNivtVTUg1o4wd5rUzfA
   jWzJyh+cHOBrFwPd/IFSREkDw14DTdDGbcjCVO4nrBc1gZ7tNjCUJuuWG7nDI7Pg714YJhlwfgUd
   GT5lH0ZPBW/qUpOA+I2eMR0FchqP1/1bmF/MtC5ySmZEqISjA0BfOtSd9YAT7NPX78FRxEZI1xeM
   6Gm2vF7wBQkL+F6U7AYkhhy1FqneXG56NiFD6lz7J5Is46msdBNiIJGCVcI9nMJMy5OsIRTKcJGt
   OINAnwZCt+28bjdgg21EERHLeZJkgWPHq3xCeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lEgcZQJiRX6znOOIDxOvTFtW2/q7Pr/EkAYDlrGC5v4=;
 b=NF7jmxcp/Yx6y2y9+VY5qc7CIuYbfNUgWWH1VOqvugUoMlp5GTYvzOyv/vIsb+cVCdEa/56Edvah
   sb66H5NYDoau37vCNvei06/mw0ZPkMq1n3tjfCD/uuLzEcwRDJ0B4+ATusmw+rjuYWcYfkh6ijRD
   jVIcR5JJ3owwaku6LC4pzxDs30cVZUSw6Vwv3/SGZxh6BGpgQk6BCazudtRRdKvK+7n8yZHOQgfy
   OhSThhiIE/qw5w4CzGKpPtsKlq/RNnnbN9Ea8A3Ui56nUlmBKDQsO/CcQ/ey1AgwQb7Nuuq+T4/+
   rXq7BJiyj/jjxkIx8mECABr/tfY9lA+qoa56lg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RW600LQXM6UEQE0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 13 Jun 2023 07:59:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1686643130; x=1689235130;
 h=content-transfer-encoding:cc:to:subject:from:content-language
 :user-agent:mime-version:date:message-id:from:to:cc:subject:date
 :message-id:reply-to; bh=8gFVICJk82rsLy6XURcItio5Wc3MLyUpCU3bKiLcn7E=;
 b=Zu1eNmH59rjQOm+08m4N17C7EGxZr54zmOO94OfKblpkr1l7peVqWXSNqS+0/kS6gX
 EapSF+QxF6DrIFV0TjB/67BzDJWIFcDgtaU/ji05c1C+S2c0li5WNJzs1zhq3oWZePi/
 79tD5grYYPpJSQ8nJ0OjlVgeckvPmJuUqsskvJq8iWb0tKMjp7scryD6wiMJQt4cTjYE
 oSBIajdSrEdw/p4rEGa1ntbbU7i+yBu7nBU+mXKzl8jn3CI5YTF+XvPARZTLAP3p0WyG
 vadttwCxVI6wTO6MtUsNikCSAdXyyEF62rloPdjiXb9y3SC3T+SQlU3i+rDRrlIs6E3P wTKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1686643130; x=1689235130;
 h=content-transfer-encoding:cc:to:subject:from:content-language
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=8gFVICJk82rsLy6XURcItio5Wc3MLyUpCU3bKiLcn7E=;
 b=G16pr8TeHsM9IEkLDBH6gLTTzb2WESkeoMst+GU30HbEyoAGf0ZMbsESX1B2QgRNuh
 rmzN5iRZznSjBNAqpjPR3Xo7Xez+fqoswDMew1XzhCnoJifxcSW1gO2brq6v/WMVJDER
 JJUUDI03v9I5RxuuB0cVkb3Qr0TEwFf2YelkgECZEqAW3+5Cz557jBXLHb9APNfNdduE
 zFXKqJt+9wPrlg4NHePrO5ws7JGir3bqE/VdOAvuFjlUYPimcj7Gdj6eE6XLxYIlz3ac
 gTjQo+1SDTetCXjDg7KYBacEkc3/kq4s4oSVO+REh/ttNqstU/aLGl1wa0z5kH7Ojrsg LJ5g==
X-Gm-Message-State: AC+VfDys7EVr6P3JWkxO+PXjoKv58LLvDik20y0KyYLI06TX7lEKk78Y
 FuiVYyhxacJGqh9XjccGZ3Y=
X-Received: by 2002:a17:902:b489:b0:1b3:7de7:f83f with SMTP id
 y9-20020a170902b48900b001b37de7f83fmr8268095plr.26.1686643130358; Tue,
 13 Jun 2023 00:58:50 -0700 (PDT)
Message-id: <32dc96d0-2d27-47e4-448a-a42e9ce352af@gmail.com>
Date: Tue, 13 Jun 2023 15:58:28 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-language: en-US
To: mark@fasheh.com, jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>, akpm@linux-foundation.org
X-Source-IP: 209.85.214.180
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10739
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=347 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=763 unknownsenderscore=20 clxscore=219
 impostorscore=0 adultscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2305260000 definitions=main-2306130069
 domainage_hfrom=10166
Cc: baijiaju1990@outlook.com, Linux Kernel <linux-kernel@vger.kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [BUG] ocfs2/dlm: possible data races in
 dlm_drop_lockres_ref_done() and dlm_get_lock_resource()
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
From: Tuo Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Tuo Li <islituo@gmail.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ4LF6u5/W4jCFiUuKAjF1AFewN+gLsPgJsbR4sHJpvM3DYDCzMRA98AOm63FAOSef1TdAzbog==
X-ServerName: mail-pl1-f180.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: FVBACiTy0RxJh_RQul-BmH9gajhey06X
X-Proofpoint-ORIG-GUID: FVBACiTy0RxJh_RQul-BmH9gajhey06X
Reporting-Meta:
 AAHJjDUfISVTe7IO+h0utLDlGWqbFrZqYHOL+74rG466nBUWJ71Qu8ETjpLq7Jfn
 BQXzifjLF1dRxNuV5GBKcttLxdbmz9Xq6bmbamHdbzzaSz/UyNlVmm5ea6Xm2PEq
 E1iTeG+KRvTkPLnBEIHm6MSGWHdnYMk43+kxBGw34L4Mx+Xb1zY74RsxvVKW33xv
 haisNlgLtONpiwm8Xuee3JLx6M0cxqv8r7ZCB83CBVhmqhWYfhdQ8sfdfEmIaD6b
 JeQCSspVTe8828QWnvjfif3sbJlV4vboCMcRpdlwzJ61snPp5n8KHQdJHlrVfjyE
 G4ezq1Bq2N1ycWZZr4a4WqRu2dpV6Of8FDFBLRUzPS9H8pB5LeY4KV5rmLgBWeiQ
 H63Ngw3rPswD/AP9xAoXrTT3xXwwK2lMv8diZeMy8Iwe7dDxRvkKLSzQLhA2N7if
 2QVojN3i0s3BMdXtcsIDjzReQEuZFRZZYk1qx7ssNsk+uF1P4uXcS59912FgSLGo
 r6piQBVBJ9xuYfownEIw1HXWZEjfs6cJ5xAFOPw+zqs9

SGVsbG8sCgpPdXIgc3RhdGljIGFuYWx5c2lzIHRvb2wgZmluZHMgc29tZSBwb3NzaWJsZSBkYXRh
IHJhY2VzIGluIHRoZSBPQ0ZTMiBmaWxlCnN5c3RlbSBpbiBMaW51eCA2LjQuMC1yYzYuCgpJbiBt
b3N0IGNhbGxpbmcgY29udGV4dHMsIHRoZSB2YXJpYWJsZXPCoCBzdWNoIGFzIHJlcy0+bG9ja25h
bWUubmFtZSBhbmQKcmVzLT5vd25lciBhcmUgYWNjZXNzZWQgd2l0aCBob2xkaW5nIHRoZSBsb2Nr
IHJlcy0+c3BpbmxvY2suIEhlcmUgaXMgYW4KZXhhbXBsZToKCiDCoCBsb2NrcmVzX3NlcV9zdGFy
dCgpIC0tPiBMaW5lIDUzOSBpbiBkbG1kZWJ1Zy5jCiDCoMKgwqAgc3Bpbl9sb2NrKCZyZXMtPnNw
aW5sb2NrKTsgLS0+IExpbmUgNTc0IGluIGRsbWRlYnVnLmMgKExvY2sgCnJlcy0+c3BpbmxvY2sp
CiDCoMKgwqAgZHVtcF9sb2NrcmVzKHJlcywgLi4uKTsgLS0+IExpbmUgNTc1IGluIGZzL29jZnMy
L2RsbS9kbG1kZWJ1Zy5jCiDCoMKgwqDCoMKgIHN0cmluZ2lmeV9sb2NrbmFtZShyZXMtPmxvY2tu
YW1lLm5hbWUsIC4uLik7wqAgLS0+IExpbmUgNDkzIGluIApkbG1kZWJ1Zy5jIChBY2Nlc3MgcmVz
LT5sb2NrbmFtZS5uYW1lKQogwqDCoMKgwqDCoCBzY25wcmludGYoLi4uLCByZXMtPm93bmVyLCAu
Li4pO8KgIC0tPkxpbmUgNDk4IGluIGRsbWRlYnVnLmMgCihBY2Nlc3MgcmVzLT5vd25lcikKCkhv
d2V2ZXIsIGluIHRoZSBmb2xsb3dpbmcgY2FsbGluZyBjb250ZXh0czoKCiDCoCBkbG1fZGVyZWZf
bG9ja3Jlc193b3JrZXIoKSAtLT4gTGluZSAyNDM5IGluIGRsbW1hc3Rlci5jCiDCoMKgwqAgZGxt
X2Ryb3BfbG9ja3Jlc19yZWZfZG9uZSgpIC0tPiBMaW5lIDI0NTkgaW4gZGxtbWFzdGVyLmMKIMKg
wqDCoMKgwqAgbG9ja25hbWUgPSByZXMtPmxvY2tuYW1lLm5hbWU7IC0tPiBMaW5lIDI0MTYgaW4g
ZGxtbWFzdGVyLmMgCihBY2Nlc3MgcmVzLT5sb2NrbmFtZS5uYW1lKQoKIMKgIGRsbV9nZXRfbG9j
a19yZXNvdXJjZSgpIC0tPiBMaW5lIDcwMSBpbiBkbG1tYXN0ZXIuYwogwqDCoMKgIGlmIChyZXMt
Pm93bmVyICE9IGRsbS0+bm9kZV9udW0pIC0tPiBMaW5lIDEwMjMgaW4gZGxtbWFzdGVyLmMgCihB
Y2Nlc3MgcmVzLT5vd25lcikKClRoZSB2YXJpYWJsZXMgcmVzLT5sb2NrbmFtZS5uYW1lIGFuZCBy
ZXMtPm93bmVyIGFyZSBhY2Nlc3NlZCByZXNwZWN0aXZlbHkKd2l0aG91dCBob2xkaW5nIHRoZSBs
b2NrIHJlcy0+c3BpbmxvY2ssIGFuZCB0aHVzIGRhdGEgcmFjZXMgY2FuIG9jY3VyLgoKSSBhbSBu
b3QgcXVpdGUgc3VyZSB3aGV0aGVyIHRoZXNlIHBvc3NpYmxlIGRhdGEgcmFjZXMgYXJlIHJlYWwg
YW5kIGhvdyAKdG8gZml4CnRoZW0gaWYgdGhleSBhcmUgcmVhbC4KCkFueSBmZWVkYmFjayB3b3Vs
ZCBiZSBhcHByZWNpYXRlZCwgdGhhbmtzIQoKUmVwb3J0ZWQtYnk6IEJhc3NDaGVjayA8YmFzc0Bi
dWFhLmVkdS5jbj4KCkJlc3Qgd2lzaGVzLApUdW8gTGkKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1k
ZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGlu
Zm8vb2NmczItZGV2ZWw=
