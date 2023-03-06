Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA6EC64EC4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eDfpSpQZ+6dgvX5oPjPDis5h8rAo7gUPob3V6Nz/r/A=;
 b=PHG+IAa0KJL2TisPAy8i0Kl/VyCheLBTIgcT4ZwuqcjUxp08iqvD/gWzCrxqOlc7tYXuiu6f4dxE
   MGKPYIrLtbz6dks1yOXPRpJ1NgMjK6GI/E1ZPLInyjWuFhyJPyOvfoo4+823C9TaJz2cNqsLuYvp
   GRNf+7Cy/tuevYM9OgJp5cTTcBKmN8X/Lg1lcZV4EhWXecmoavnkRFcAciqCPw/c7r1qTKCn7JHQ
   R9bGSS9W5yVgEkyj/6oo+/dfxA/+8+lAD05pbwXygnNT2ywf/SYc54gEg74uaLwg+0/2LxVBRO0m
   ogiO9q742RuYlQ3w+TBFIxmmFKJu2Jl0bc0W4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=eDfpSpQZ+6dgvX5oPjPDis5h8rAo7gUPob3V6Nz/r/A=;
 b=QrQkUWQuU5yRS0eD6krDlJ68X+CD+J0XKylv7iK+1DmYe13m1qHu9omUGJHnMeiwAJpHRaM2TVgF
   SY+fzqFwPKyMi+k28VcMXPQ7XL/ABENGioNSI+/S1bMAI3i5nOk2ejPXKILwRM44GDI58+WUY8o2
   69hLqpN51pkSFpcSzod103jfpAf3K68FV9logRKSJSJC2fvlX/S8OKJ8bfjo+J5akTBqRdYolTog
   w/EvbJdhA5wIg056RACsGfyzO713awzeUT0N6ckO5Hb+FgV9D49+GVedDIo48i6Vtmk/MB64a9dq
   jvtSgUcwPI7nT4yR65+xm0OZxRonSp3sDiRbSA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR3007ADZ6GS4D0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 16:59:04 +0000 (GMT)
Message-id: <e804e6881e96680107a4db3d4b81e5e898f5fbde.camel@huaweicloud.com>
To: Valentin =?UTF-8?Q?Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Date: Mon, 06 Mar 2023 17:58:30 +0100
In-reply-to: <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
References: <ZASjOpsoM+nEx/o8@valentin-vidic.from.hr>
 <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
 <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 priorityscore=0 mlxlogscore=860 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=225 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060150
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] ocfs2 xattr
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwC3PAi4GwZkMS54AQ--.36115S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw43Ar4UuFWkKr1fCr45Wrg_yoW3JFg_WF
 1kC3sFyw4kX3yxGrZ0k3sYga9agFy8ury0qrWqgr17Jw4rG3WUKrZ3AryfZa4rKa4Sywsr
 CFn3uw48Zw1S9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbokYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267
 AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
 Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
 AY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
 cVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJw
 CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
 vfC2KfnxnUUI43ZEXa7IU1wL05UUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAIBF1jj4ZCNwABsN
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: G0RnNQoz6KpDeEMfYwZPVMxdnkqjmP12
X-Proofpoint-ORIG-GUID: G0RnNQoz6KpDeEMfYwZPVMxdnkqjmP12
Reporting-Meta:
 AAFZuPtU8ZyTnuafn8eBNzvnsY4d+86mvFaN10vzq3nmfoKjpNYmOzlcDpjoKnrU
 yIsVR4xmPHHvMOsY6SUUlPgubNgL+US75TYWD2TcpzwqWOvkOuLmiTqka3Y/1JQY
 9yu4keIvFndc0FSJuGRhgkatUKc7Snh6eUcDVdu160RhhKi5aIDhmo+S9VDFhSWf
 f6FY/7QcBMXQ+reMKZnldaTQMTS4O/q13SCSZ7gOE0CTtp9EiLvnsCISVlmi6A7y
 9aN0YC4LZ6idifyO5fIvw1qvzgx6galOIiMsmONYRf7Gn+zCXOqiEWSrw/aLvwjU
 hhhwRp0wYNmYVvzgCmRvQSJxtooClNkB8NiwROl8TqTccIGNxw5o2ukyc0FJZI85
 kaq4ANcja7VgvsPAL0w4YX48b7wGLuqZ+lKRtqjtpNKlbOpuIIhKvNicZuUdXgPR
 EYeFUm7kkP53DX0qp+QEXIV8GbTI2KafKT/AtNYiaAXKXWRSTPG70jtlgvbWlyCD
 RdHcStYXli10zMABVK8Wnm8mfkPs4/whNZM/XyHU4Y/W

T24gTW9uLCAyMDIzLTAzLTA2IGF0IDExOjQ1ICswMTAwLCBWYWxlbnRpbiBWaWRpxIcgd3JvdGU6
Cj4gT24gTW9uLCBNYXIgMDYsIDIwMjMgYXQgMTA6MTM6NDVBTSArMDEwMCwgUm9iZXJ0byBTYXNz
dSB3cm90ZToKPiA+IHdoaWNoIExTTXMgYXJlIHlvdSBydW5uaW5nPwo+IAo+IFRoaXMgaXMgb24g
RGViaWFuLCBzbyBBcHBBcm1vciBpcyBvbiBieSBkZWZhdWx0LiBJdCBzZWVtcyBsaWtlCj4gb25s
eSBTRUxpbnV4IGFuZCBTTUFDSyBoYXZlIGhvb2tzIGZvciBpbm9kZV9pbml0X3NlY3VyaXR5IHNv
Cj4gZm9yIG90aGVyIExTTXMgJ2NvbnN0IGNoYXIgKipuYW1lJyB3b3VsZCBub3QgZ2V0IHNldD8K
CklmIHRoZXJlIGlzIG5vIGhvb2sgcmVnaXN0ZXJpbmcgdG8gaW5vZGVfaW5pdF9zZWN1cml0eSwg
dGhlb3JldGljYWxseQp0aGUgTFNNIGluZnJhc3RydWN0dXJlIHNob3VsZCByZXR1cm4gLUVPUE5P
VFNVUFAsIHdoaWNoIGNhdXNlcyBvY2ZzMiB0bwpzZXQgc2ktPmVuYWJsZSB0byB6ZXJvLCBhbmQg
bm90IGV4ZWN1dGUgdGhlIGxpbmUgdGhhdCBjYXVzZXMgdGhlIGtlcm5lbAp0byBwYW5pYy4KClRo
ZSBwcm9ibGVtIHdvdWxkIGFyaXNlIGlmIHNvbWVob3cgdGhlIExTTSBpbmZyYXN0cnVjdHVyZSBy
ZXR1cm5zIHplcm8sCndpdGhvdXQgc2V0dGluZyB0aGUgeGF0dHIuIFRoYXQgd291bGQgZXhwbGFp
biB0aGUgcGFuaWMuCgpOb3Qgc3VyZSwgSSB3aWxsIHRoaW5rIG1vcmUuCgpSb2JlcnRvCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwg
bWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
