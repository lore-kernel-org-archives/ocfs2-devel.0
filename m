Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91939C6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Thu, 23 Mar 2023 23:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IcjP8AlYAUQvhL2plKtFITXd0StQh8/A2TcMfzBbpVc=;
 b=q/pKS8DAYIlrHkAgw/R0LvgC089j92c712l4jvQAGiSTwoVAzO8/sYWRSx9l7cnVLQOFWQyNVTyD
   lVG0sOID9C+I2luszt8Kwb0NPWN22W+xdHzcOQFCIwS4bfFSmlSZVh78C5aFUuh0Yvph6MlPn5Vl
   g2MDCcpkhizX4qvnH26gY8UteISRembBhiIXu7L7zdTORsGRODOk1CULxJpd1rtiqxMKfkWhFwnk
   NRYc8jPWGb8p6Xhauyv9RyX+q4d7FVUAukoOW56eQcEPPxo9LyGat93kTVEiw2VyP1IJlrWzbYgf
   pSYHUDiDnWfSoU5qK2PDuQMfFSsSdXPOozE/1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IcjP8AlYAUQvhL2plKtFITXd0StQh8/A2TcMfzBbpVc=;
 b=o3aNxJRa0PSkRyqFXniKhFYNQo/WhrAK8fAxOWEDby8VtjZlv7YENYTrbatYQhUAcJi4GjDO6SQk
   3dkA1bVC6uleQDGTpLwYYIPeg0O4UXl5QmRB94uC2djXSiBE2E+BcUw/PKcyEHSejEq2nH6buIZu
   q2jl20lPg3X71cNit813MGyEDj1C8QDTpGf2oZ7qwOq1jo4bUhdRR7W+kj4IHh30xu3484MQ0uV4
   5xezS4eBGi5kLBOBcCp8KUXPIfm5iEVzEbnvF5wjwcpJUwD9q+fppQsU6iUbHrhg7wJDRzKv8rWn
   FKwktYDUkvJ1neA9ylBYWgnko/fWt14OS6OdNg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RRZ00O38YSR1Z60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 23 Mar 2023 23:34:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1679614431;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=I4UQt9s0uViyb6ofhmfjXLpk2tpOHMTrFO4xtiTE1F0=;
 b=B/0sSV7njn/GnbdGsZmwGqohjHyQKCvOu/6lA3UnCwY5crL557lHVTU44KJxZHT7yP
 aPP+W3L7LsThfn1d73iOPDaxJ4xaogwioYx8PIMl/sbmCYK2QpbhQ/C3TGah4c41AH7d
 34VK1xWYZtimyZLICoxE+b9Eqs8qV62zR0LZst+Hl5muiDzrsbLT4VjJQjVnxo20RgOx
 QS6XgqmI6PTjN2jji+M23xYUJA5aMnZhcnEc1UWcg8cyTAqJUozNTyGh4D0U2mOYANmT
 m2TjS6e7s7ht3ZDMN60F3ByMAURAMBiNlLvT9cSW4f6JHrOJwK9tvY7F3QFHQYSulqjZ TNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679614431;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=I4UQt9s0uViyb6ofhmfjXLpk2tpOHMTrFO4xtiTE1F0=;
 b=nb0LZteDKxLVVcs8oxNXb7LRauHOE2mr2MMPKfqDrlnqxbVdCDl11dxpLsKoqY/yuO
 sVGbnek52yFc5Xnd/K5V8mZvlbvL0fmyBdj7BCdlJxViuKidhNT6fm44Xc4EDgJKOkMO
 0xvUn5PEtbyoW1AP8f8+oH1seUNHXaY3yc6HUxGIyRIcuA0m7eymzuIOk6dBtl7gT2Dr
 RyhSiT/6j4fm9qU8SBXweCM5/f60Oo4rL7/LDsZ5uebBg5W90NbFPqUi7dZgoys/3eSM
 mZK1EU+9BlDl971ECQT6MXQSHsMKWpDl35YcR5HRQQjZcvrZLcX2WbwUwzB/+DoIa7Mo SIQQ==
X-Gm-Message-State: AAQBX9fbKPLR2M3WIesjG7jjeKTMBFtC2VT2eSqFE8EcDaQ49wF6sopZ
 Uvm85cgZd1W0PvYf96enHXwp/vZbK4wtJOikfxwO
X-Received: by 2002:a25:abee:0:b0:b68:7a4a:5258 with SMTP id
 v101-20020a25abee000000b00b687a4a5258mr211351ybi.3.1679614430992; Thu,
 23 Mar 2023 16:33:50 -0700 (PDT)
MIME-version: 1.0
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-2-roberto.sassu@huaweicloud.com>
In-reply-to: <20230314081720.4158676-2-roberto.sassu@huaweicloud.com>
Date: Thu, 23 Mar 2023 19:33:40 -0400
Message-id: <CAHC9VhS1htA=cFqbc3KJsrZ3by6_m=f3Bd0sTbztC=qMZEvedA@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.219.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10658
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=177 phishscore=0 mlxlogscore=843 lowpriorityscore=0 mlxscore=0
 spamscore=0 priorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303230170
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v8 1/6] reiserfs: Switch to
	security_inode_init_security()
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
 AKy350Ythv2mrmo7XSEuLMBIjFRTDHgBFPhqt6X4Wf9cwlS+qXqGx6EuJGwGC9z42MtKE37zO8JrjgFxkcxJXq4nSaI=
X-ServerName: mail-yb1-f170.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: pN2avYN99nnzY6YKQpIXCvR3DTuoEfIQ
X-Proofpoint-GUID: pN2avYN99nnzY6YKQpIXCvR3DTuoEfIQ
Reporting-Meta:
 AAH6KfXONP/l4RO6qlh44QHsbD0X3BuBgmbvrAp2wAzzyK2bYyi6pGyM0Oxzk7hN
 lH9pnHUqa7v96TmYWBkK0Gbdl2moIsRx2sbvv18/GivY8xcLU40wQAht7hGsATA3
 w7/QHgafKnv5xyYZG4ONQgWEa/585HVsUddth8uHVpy+IZq5lV13JEEZbBQpF3Lj
 SQtSx9PLpqkzBfWPhli5nwEmC3eNUOm9knDijHkRSpIi/WMn+1HzhA8U8iy5AEMN
 o7/orARnDh7FS3HUCIGdPJaesNgX81PKLbXBFIKu1v3mZjC9+NV/OkCmaodgjA9Z
 BnOzqD0X8FgPSXYX9UZWKD1f+YUopIYTVKuUtborGCLmGxM4fLneizBbLIj2HKDK
 NuLkBcevo4g1m6XqlS9eJZn6gIlP6142Bm8Fgf3l+tfT3vCOs9VfHCRyaw9OS+wG
 ErAY4ntJWejycGr1eEczfP8mfY8wmC0fuYMhudzRsxDAdjCTb57iZxdb2HUpxlV6
 7X2plgyRnjAoMCfFSzG79S3qpfLVz0IOAOHN7IyRDRZb

T24gVHVlLCBNYXIgMTQsIDIwMjMgYXQgNDoxOOKAr0FNIFJvYmVydG8gU2Fzc3UKPHJvYmVydG8u
c2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPgo+IEZyb206IFJvYmVydG8gU2Fzc3UgPHJv
YmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4KPgo+IEluIHByZXBhcmF0aW9uIGZvciByZW1vdmluZyBz
ZWN1cml0eV9vbGRfaW5vZGVfaW5pdF9zZWN1cml0eSgpLCBzd2l0Y2ggdG8KPiBzZWN1cml0eV9p
bm9kZV9pbml0X3NlY3VyaXR5KCkuIENvbW1pdCA1NzIzMDJhZjEyNTggKCJyZWlzZXJmczogQWRk
IG1pc3NpbmcKPiBjYWxscyB0byByZWlzZXJmc19zZWN1cml0eV9mcmVlKCkiKSBmaXhlZCBwb3Nz
aWJsZSBtZW1vcnkgbGVha3MgYW5kIGFub3RoZXIKPiBpc3N1ZSByZWxhdGVkIHRvIGFkZGluZyBh
biB4YXR0ciBhdCBpbm9kZSBjcmVhdGlvbiB0aW1lLgo+Cj4gRGVmaW5lIHRoZSBpbml0eGF0dHJz
IGNhbGxiYWNrIHJlaXNlcmZzX2luaXR4YXR0cnMoKSwgdG8gcG9wdWxhdGUgdGhlCj4gbmFtZS92
YWx1ZS9sZW4gdHJpcGxlIGluIHRoZSByZWlzZXJmc19zZWN1cml0eV9oYW5kbGUoKSB3aXRoIHRo
ZSBmaXJzdAo+IHhhdHRyIHByb3ZpZGVkIGJ5IExTTXMuIE1ha2UgYSBjb3B5IG9mIHRoZSB4YXR0
ciB2YWx1ZSwgYXMKPiBzZWN1cml0eV9pbm9kZV9pbml0X3NlY3VyaXR5KCkgZnJlZXMgaXQuCj4K
PiBBZnRlciB0aGUgY2FsbCB0byBzZWN1cml0eV9pbm9kZV9pbml0X3NlY3VyaXR5KCksIHJlbW92
ZSB0aGUgY2hlY2sgZm9yCj4gcmV0dXJuaW5nIC1FT1BOT1RTVVBQLCBhcyBzZWN1cml0eV9pbm9k
ZV9pbml0X3NlY3VyaXR5KCkgY2hhbmdlcyBpdCB0bwo+IHplcm8uCj4KPiBNdWx0aXBsZSB4YXR0
cnMgYXJlIGN1cnJlbnRseSBub3Qgc3VwcG9ydGVkLCBhcyB0aGUKPiByZWlzZXJmc19zZWN1cml0
eV9oYW5kbGUgc3RydWN0dXJlIGlzIGV4cG9ydGVkIHRvIHVzZXIgc3BhY2UuIEFzIGEKPiBjb25z
ZXF1ZW5jZSwgZXZlbiBpZiBFVk0gaXMgaW52b2tlZCwgaXQgd2lsbCBub3QgcHJvdmlkZSBhbiB4
YXR0ciAoaWYgaXQKPiBpcyBub3QgdGhlIGZpcnN0IHRvIHNldCBpdCwgaXRzIHhhdHRyIHdpbGwg
YmUgZGlzY2FyZGVkOyBpZiBpdCBpcyB0aGUKPiBmaXJzdCwgaXQgZG9lcyBub3QgaGF2ZSB4YXR0
cnMgdG8gY2FsY3VsYXRlIHRoZSBITUFDIG9uKS4KPgo+IFNpZ25lZC1vZmYtYnk6IFJvYmVydG8g
U2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2FzZXkgU2No
YXVmbGVyIDxjYXNleUBzY2hhdWZsZXItY2EuY29tPgo+IFJldmlld2VkLWJ5OiBNaW1pIFpvaGFy
IDx6b2hhckBsaW51eC5pYm0uY29tPgo+IC0tLQo+ICBmcy9yZWlzZXJmcy94YXR0cl9zZWN1cml0
eS5jIHwgMjMgKysrKysrKysrKysrKysrKysrLS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDE4IGlu
c2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpNZXJnZWQgaW50byBsc20vbmV4dCwgdGhhbmtz
LgoKLS0gCnBhdWwtbW9vcmUuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9y
YWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRl
dmVs
