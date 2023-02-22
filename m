Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373FFC76196
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bay7evCYBgA+hniNvwMFy+f9waKOVGnD38ssH1PA4jU=;
 b=14TWG3QpwcSwVHMzAGIp/N1vRUsugmk92AotVgBFwJpUdGAuN8Uy7QO/iySo/ZbgJXKj/uxiwImh
   X/fh6IMyLZZxxrNiA94cg46u9Hsxz45AzNSTO0GEYhmcf2eJFaSoL7F9UKvfztjhr1MghPDegyWv
   2peCwg13qSMKP3bygizRr+w72yf1/GQAposnXxlNWpjR65qIXhUSvqtYewu5CCengALh614kAUAF
   SjfvZPm+T7YUQGDkoxUa/YeqkCrhwJIaXHd/H31Y9OfgzhsILtmPQDxUm3GBjhphJFAA6Lf/dKRB
   kEQFn8OnbiEMkVcHoXH9elzpnvifuSqXKEx6Qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bay7evCYBgA+hniNvwMFy+f9waKOVGnD38ssH1PA4jU=;
 b=dFP+16JGtsNrRn+aba5IzRkYboPYWnicB31ucUIDnqRFCHdAzM5W094qTl1Iw38a5R//dg7peFAk
   D65kPu856oPtedFGgpPuY2yke2QYF1HLY2Kn1dQoBykvS4qbaubHJg4X8zaJgRRF9uRlSctMsP8T
   ynSQu9aaNCVdeKbIK2xhv/Br8HVRz+qZPWow7aeL1L0hO16sdsbhNlAzZQRTf7WzJemU90blFFkk
   B1fG9faLmjh9aUOeqyIcKj+PwE4bfqgcOjXFJGqToi3q5pZeYwThLGupEQU6WZC46taDCPdLZe1H
   4HF26Jn2JHXOZZeM1L8vxHV40FwsOuo/jGRYMA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX007VWM166C40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org;
 s=mail20150812; t=1677071883;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=IKN9En50m0NHNAAP6pLa6o2yQ+fMpNFMCT8+sgWJUQY=;
 b=WNK7QBILwJidJA8ZVffPN7SOhQXplDjRj3qR5QhPFwOzIGd1RGjfY0DTS0HUnMbUU8DKtW
 fpU35Xef3UP9eVm1i9f7pQDioidLmnBFUSZ0iq78mpnWa8dtVTwoGR7EBgw4VARVfpqbfg
 XACNCPao7lwJdaTFpyMoqZoCtaeDFa27KztZnKhH6wgzWxJ0Q/bon8vEuzN+60X2EwAKC8
 Ba8FPeELeKGOrvHKvjppgJRQCP6h0FEeSGA4AD6OgUs5nAO4t1RHv1PpGK7gEEz80jWv/c
 1QdRk6cU/fxwoaq2qeVe6X+LTyiXzs09NVo6T5n4Q3FztTA6uL6Hrg1PvPFQ1w==
Message-id: <3459ddb1-b36d-2428-0ce6-358b2bdb31f2@mailbox.org>
Date: Wed, 22 Feb 2023 14:18:02 +0100
MIME-version: 1.0
Content-language: de-DE
To: ocfs2-devel@oss.oracle.com
X-Source-IP: 80.241.56.172
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10628
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 priorityscore=48 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 clxscore=235 mlxlogscore=737 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220117
Subject: [Ocfs2-devel] Kernel 6.1 - ocfs2 NULL pointer exception
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
From: e-m via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: e-m <e-m@mailbox.org>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MBO-RS-META: accqfqtxanq31g48kmou7rhm8nd6dd7f
X-MBO-RS-ID: 7bca6dfa89d50039b13
X-ServerName: mout-p-202.mailbox.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:213.203.238.0/25 ip4:195.10.208.0/24
 ip4:91.198.250.0/24 ip4:80.241.56.0/21 ip6:2001:67c:2050::/48 mx ~all
X-Spam: Clean
X-Proofpoint-GUID: H8GImH4T3rblK1NfcTFuXWC1Xo0-uLNm
X-Proofpoint-ORIG-GUID: H8GImH4T3rblK1NfcTFuXWC1Xo0-uLNm
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAEjyIuM3P9ITye4kkUPtf5wNbwXGYRAWGIwGs97GuqHNK7Dm0p9J953nv46W1Cm
 vt+fgQO2kgqXatRd8zP3F7OSZicjPy9B5CeC8RJeuByDDh/eMVlzXqCdftbceUUW
 LtZ4PDNyFJCYBuuFzur60pKZ7vGpHvRlBcG36sHftqJ3qraoGEySOZpsjqaafcid
 TkOTwDIgOtjXBnWxVK3/pHIpFrzczG9Cci90RydGwAJnQ4vrCymW4z6HnbsgdYQt
 I1eRpSErZTb5XdwMk/VXraxaTV/jw9CC+M0N/LUS3pLZS6O+Ko22Gh6Y1VqQrzrf
 Cym/VmkLcPAyRt6iniNEl+gtC1KaqmC1hNdlqDT8c+rS2ka/rNSZ7PBKPSFdXAox
 p5O2XfyMCMXVkEJlbuZ5so6xSXNYyqx/bXGyeOkRPb+KNkadsezqyNUZvIQ4mfHn
 3d3/oOiTkLcU+rlv16065dXAJOdXVtvc/SMydhOsRKSsDYC/5MluYFj7ud1AHyR3
 0E+KwacQUSxKwWyiuDylmBOG2893UBfe+WSd68ILL8vD

SGksCgpJIGFtIHRyeWluZyB0byB1c2Ugb2NmczIgb24gbXkgbWFjaGluZS4KQXJjaExpbnV4IEtl
cm5lbCA2LjEuMjItYXJjaDEtMQoKSG93ZXZlciwgd2hlbiBJIHRyeSB0byBjcmVhdGUgYSBmaWxl
IChlLmcuICJ0b3VjaCIpIG9uIHRoZSBtb3VudGVkIEZTLCBJIApnZXQgYSBCVUcgd2l0aCBhIFBG
OgpCVUc6IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UsIGFkZHJlc3M6IDAwMDAwMDAw
MDAwMDAwMDAKCkl0IHNlZW1zIHRoYXQgdGhlIHN0cmxlbigpIGluIG9jZnMyX2NhbGNfeGF0dHJf
aW5pdCgpIGlzIHRoZSBwcm9ibGVtIApiZWNhdXNlIHNpLT5uYW1lIGlzIE5VTEwuCldoZW4gSSBt
b2RpZnkgdGhlIGNvZGUgc28gdGhhdCBzdHJsZW4oKSBpcyBub3QgY2FsbGVkIHdoZW4gc2ktPm5h
bWUgaXMgCk5VTEwsIGl0wqAgQlVHcyBvdXQgYXQgYW5vdGhlciBwb3NpdGlvbiBpbiBvY2ZzMl94
YXR0cl9zZXRfaGFuZGxlKCkgCihzdHJsZW4oKSBhZ2FpbikuCkl0IHNlZW1zIGxpa2UgdGhlIHdo
b2xlIG9jZnMyIGtlcm5lbCBjb2RlIGhhcyB0aGlzIHByb2JsZW0gbWl0IHN0cmxlbigpPwoKQ2Fu
IEkgcHJvdmlkZSB5b3Ugd2l0aCBhbnkgYWRkaXRpb25hbCBpbmZvcm1hdGlvbj8KClRoYW5rcyBh
bmQgYmVzdCByZWdhcmRzLApFdGllbm5lCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMy
LWRldmVs
