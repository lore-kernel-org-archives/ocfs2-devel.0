Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5A0C6FD18
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4KdoTOdH6ef+lDPQE4jos8nzN+ESPcAPYv4taKcx9ac=;
 b=wSHnyw1i54mq1waNo7Q7YfbGtU2dXSkORQmP4TC03htUqgIH2yGUFpiUFbhRuz9e2rtgTX/U1CVT
   AdKGUCgQzMr/f+bBIXUmOLn/7Kk6Ap5aD3fE96Yf8GSNDsOausQ4dsEUfB9EdgZIGorV3BQMmi8x
   5L9xIUtV1xzeADQv/tkof80fXw+4J4iJUiUQxZJ6nUf4Ux1ORmKkULMh8B8LykGhwITRDUhmRwOl
   B/6GfxpyGk1btdBvyzLjBxqSakrNWIxJmlW2U4KsBCb1LbcMkfqL02AzLyPDtJ/p2IIYUa983jZD
   OsOH2PbvUQoK8HpTAwBjC5+sRqfp/jOT81gCpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4KdoTOdH6ef+lDPQE4jos8nzN+ESPcAPYv4taKcx9ac=;
 b=UNkj9GQhvjJ6cPhj0DannQ7vaMirBJJ3Z7U7+pt5aXfROkq3QhdQULdhOgtUDf6OdnCT4iSq+pSW
   zaug447hgMuJ2Q0oqnF9Gc68y+Nu3f1E439ajBCnWMU2xbCvxZ92Y6NWVIufOhiqwfofSeDKXAdv
   5p6TAtkdsskLdHgb6ExvjdD6+wZno0T4F+Xgrja83mLW+fhiI/0buTRd1zZqgREbBkMGuahEoSE/
   JJJwqWvDQ4yFAiDkDY4qhb3K9DtTYJJGCULqn+EW/5F1ZR7MFXMK0I9hqiVG4aeAkCBimKbysymf
   CXTO2j+rL7WAZOFTBI6klapehgxiMOS03SILTA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS800GB5Z5U7J80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 20:20:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1680034806;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=YTUjsnH0pjAMPCdWUs8KgtrmbEQ7uRQfh39xHtc1mOI=;
 b=ZISzzUBAp2B86WTvie3LaaTm+XXMV1NsBYT+ss9Ay2P2TZV18c736vvSEzIoAMgiAD
 yyMfrBITnvGzSe0zitTngdlv9FE5B7kqtcVHa5dUfi5qBhCuM018z5BcpYSoI7bEVt2z
 ZC3kowL2cQRNQzFOhwJRwPeyH2MQqrp8NURsIr5JDzQpyL3WseVUnD7mAC626z6TQglg
 UoOeDKCOiKNAkc7HGHrpOlFtTEimlh5Dg4uX3bQo4lcrs02hnNHTYJq/Kw3dPuYr2VQI
 hXkP49aeyOtDyuAYueE49r0lldY98MycnxQ5Y1KBuHU/CwgwrBTDgx/qGu38MPY3mDw7 CiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680034806;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YTUjsnH0pjAMPCdWUs8KgtrmbEQ7uRQfh39xHtc1mOI=;
 b=Z7BTuTDlO/oelxIuFiy1PWANZyeUgRijiVgYvlxQcNFb9rh20Hrrm1mI0HAHjU68hB
 fN8bZhwoRq5HWL9vlVO/69WQG4kBnEoJTziRgyfliEYOpHJLSUC8NaHQOO1eYRFalaXt
 PjSeHkQUoiZ0crk92r4RXObPj1ZHFfK12bXV+QqwoTCT9B10XLBjPhsD1nss/WFlDHOG
 30butzJ7/yHejZfxAVZJX2i/m6cKVm8dI/MFEPLH7UgPvPNlapOF35HxS3s9fW5qpuof
 GlOXSof8Db/E00+GDxBVY5ArOAH+pT8VZmfYB85dDl96XV7izfb4Gk/EOsEpRVliilSY /YgQ==
X-Gm-Message-State: AAQBX9fLNRlt2i29MHdE8uX8LaJgdNTwEzwhTIbExuQLA+SOq38cyQDG
 IKYoU6tSM7+TAYL6OrVGohaYSw+8x8PxqH9+PgHp
X-Received: by 2002:a05:6902:102a:b0:b71:f49f:8d22 with SMTP id
 x10-20020a056902102a00b00b71f49f8d22mr8605060ybt.3.1680034806304; Tue,
 28 Mar 2023 13:20:06 -0700 (PDT)
MIME-version: 1.0
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-5-roberto.sassu@huaweicloud.com>
 <CAHC9VhTD3EyDiJs9+NQrgp84JcUs_sx8WONtRk2YYH4m1C8nVw@mail.gmail.com>
 <939e6c88662ad90b963993c4cc1b702083e74a7a.camel@huaweicloud.com>
 <ffc86b3907f7b87d3c568ae62bea3cdb3275be4e.camel@huaweicloud.com>
 <CAHC9VhRNjvjMOF5KLM6BoGfk=QpEBs_ur_CgRdGL5R1bA-JAwg@mail.gmail.com>
 <8b63d00d8ac3f686e51889ea4fc8d83f8ecb300d.camel@huaweicloud.com>
 <CAHC9VhRaKtsM=CuNhDy0Kx0NGSUrVhG+MhwKnHiyJxfgUwx7nA@mail.gmail.com>
 <1e08006f9011efa48deaf656c358ca3d438b9768.camel@huaweicloud.com>
In-reply-to: <1e08006f9011efa48deaf656c358ca3d438b9768.camel@huaweicloud.com>
Date: Tue, 28 Mar 2023 16:19:55 -0400
Message-id: <CAHC9VhRNWeZtxain_Hi-EfS49Vac8_vg7KRRyV4a9Sq3XPhZsg@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.219.172
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10663
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 priorityscore=60 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=767 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=178
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280156
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v8 4/6] security: Allow all LSMs to provide
 xattrs for inode_init_security hook
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
 AKy350ZEFOCwjRsMkv4tCJSQFPlfwfLVNNFZyIK63atBOV/sH54NXrYaRWqhboUJbp5+ys+9+LucpxgK3fri3wARgIs=
X-ServerName: mail-yb1-f172.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: tu9IPTj9ujAI-sJ7j-8wXJSfhcJPs4dl
X-Proofpoint-ORIG-GUID: tu9IPTj9ujAI-sJ7j-8wXJSfhcJPs4dl
Reporting-Meta:
 AAGWbReQSnwFyn7Tgnq+ar6Dc6bfIBlpc9Lyw32mjAsyk8dlklvmhNOEyxhfq6ew
 bbY6iPic910SXCP4w4YA8M7I9oRMoWK1JlIXaUOBztNFCTaRnrFCEOMsfWoULgbD
 5LUyqR08bV2vipqFtjyBsfHC6G4DzFItgzUXkjNnNpt6VzqjNlPimz9mpuXj1d4H
 881oNa/biGiOn0aWNFmnHpeEo1EU1FDYKZVRBQx5vP1YHEJBpejor5f5AEe0p1fo
 l70i231HIyzt/iAyGFcLFzllGsPtPthwfZlHENosGSHZHIC1rO+1ampNErFf9m/Y
 Mjlhp2h13CZS6ZHLKZFAD+mrYLeqqrTA3D54pfcvmM2p5vqUNBhO4iEZ3XX0FpUY
 ut4rpoiZ07vQzM2AcRXWE3SjoHGpCxSDiHX+nhiZJp0yq+Ju1tSesXxHdFgZ9/Z8
 NmmF6kjsNHwFTrQBjYQ5Kn40CjdWy+4fwygiAI/uxKQ4Zacm7oGRAVPBvLamt90U
 ZSSDTjXjauHD8kdLW/2Wi4I2tt6QI9OiUhEgiaVn61vj

T24gVHVlLCBNYXIgMjgsIDIwMjMgYXQgMzo0N+KAr0FNIFJvYmVydG8gU2Fzc3UKPHJvYmVydG8u
c2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPgo+IE9uIE1vbiwgMjAyMy0wMy0yNyBhdCAx
NzowMiAtMDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIE1vbiwgTWFyIDI3LCAyMDIzIGF0
IDM6MzDigK9BTSBSb2JlcnRvIFNhc3N1Cj4gPiA8cm9iZXJ0by5zYXNzdUBodWF3ZWljbG91ZC5j
b20+IHdyb3RlOgo+ID4gPiBPbiBGcmksIDIwMjMtMDMtMjQgYXQgMTc6MzkgLTA0MDAsIFBhdWwg
TW9vcmUgd3JvdGU6Cj4gPiA+ID4gT24gRnJpLCBNYXIgMjQsIDIwMjMgYXQgOToyNuKAr0FNIFJv
YmVydG8gU2Fzc3UKPiA+ID4gPiA8cm9iZXJ0by5zYXNzdUBodWF3ZWljbG91ZC5jb20+IHdyb3Rl
Ogo+ID4gPiA+ID4gT24gRnJpLCAyMDIzLTAzLTI0IGF0IDExOjE4ICswMTAwLCBSb2JlcnRvIFNh
c3N1IHdyb3RlOgo+ID4gPiA+ID4gPiBPbiBUaHUsIDIwMjMtMDMtMjMgYXQgMjA6MDkgLTA0MDAs
IFBhdWwgTW9vcmUgd3JvdGU6Cj4gPiA+ID4gPiA+ID4gT24gVHVlLCBNYXIgMTQsIDIwMjMgYXQg
NDoxOeKAr0FNIFJvYmVydG8gU2Fzc3UKPiA+ID4gPiA+ID4gPiA8cm9iZXJ0by5zYXNzdUBodWF3
ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4gPiA+ID4gPiA+ID4gRnJvbTogUm9iZXJ0byBTYXNzdSA8
cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPgoKLi4uCgo+ID4gT2theSwgdGhhdCdzIGZhaXIsIGJ1
dCB3ZSBjb3VsZCBzdGlsbCBwYXNzIHRoZSBmdWxsIHhhdHRycyBhcnJheSBhbmQgYQo+ID4gcmVm
ZXJlbmNlIHRvIHRoZSBjdXJyZW50IGNvdW50IHdoaWNoIGNvdWxkIGJlIGJvdGggcmVhZCBhbmQg
dXBkYXRlZCBieQo+ID4gdGhlIGluZGl2aWR1YWwgTFNNcywgcmlnaHQ/Cj4KPiBZZXMsIHdlIGNv
dWxkIGRvLgo+Cj4gPiBUaGUgaXNzdWUgaXMgdGhhdCB0aGUgc2VwYXJhdGUgY29tcGFjdGlvbiBz
dGFnZSBpcyBub3Qgc29tZXRoaW5nIHdlCj4gPiB3YW50IHRvIGhhdmUgdG8gZG8gaWYgd2UgY2Fu
IGF2b2lkIGl0LiAgTWF5YmUgd2UncmUgc3R1Y2sgd2l0aCBpdCwgYnV0Cj4gPiBJJ20gbm90IHll
dCBjb252aW5jZWQgdGhhdCB3ZSBjYW4ndCBtYWtlIHNvbWUgbWlub3IgY2hhbmdlcyB0byB0aGUK
PiA+IExTTXMgdG8gYXZvaWQgdGhlIGNvbXBhY3Rpb24gc3RlcC4KPgo+IEkgbGlrZWQgbW9yZSB0
aGUgaWRlYSB0aGF0IExTTXMgZG8gd2hhdCB0aGV5IGFyZSBtb3N0IGZhbWlsaWFyIHdpdGgsCj4g
Z2V0IGFuIG9mZnNldCBpbiBhIHNlY3VyaXR5IGJsb2Igb3IsIGluIHRoaXMgY2FzZSwgYSBzdGFy
dGluZyBzbG90IGluCj4gdGhlIG5ld194YXR0cnMgYXJyYXksIGFuZCB3cml0ZSB0aGVyZS4KPgo+
IHYzIGhhZCB0aGUgbHNtX2ZpbmRfeGF0dHJfc2xvdCgpIGhlbHBlciwgdG8gZ2V0IHRoZSBzdGFy
dGluZyBzbG90LCBidXQKPiBzb21laG93IEkgZmluZCBpdCBsZXNzIGludHVpdGl2ZS4KPgo+IE9r
LCBpZiB5b3UgcHJlZmVyIHRvIGF2b2lkIHRoZSBjb21wYWN0aW9uIHN0YWdlLCBJIHdpbGwgcmV3
cml0ZSB0aGlzCj4gcGF0Y2guCgpNeSBjb25jZXJuIGlzIGhhdmluZyB0byBsb29rIHRocm91Z2gg
dGhlIHhhdHRyIGFycmF5IGFmdGVyIGVhY2ggTFNNCmhhcyBiZWVuIHJ1biBhbmQgaW4gYXQgbGVh
c3Qgb25lIGNhc2UgaGF2aW5nIHRvIHRoZW4gZG8gYSBtZW1jcHkoKSB0bwprZWVwIHRoZSBhcnJh
eSBwYWNrZWQuICBUaGVyZSBhcmUgc29tZSBjYXNlcyB3aGVyZSB0aGVyZSBpcyBubyB3YXkgdG8K
YXZvaWQgYWxsIHRoYXQgZXh0cmEgd29yaywgYnV0IGhlcmUgSSB0aGluayB3ZSBoYXZlIHRoZSBM
U01zIGRvIHRoZQpSaWdodCBUaGluZyB3aXRoIHJlc3BlY3QgdG8gcGFja2luZyB0aGUgeGF0dHIg
YXJyYXkgd2l0aG91dCBvdmVybHkKYnVyZGVuaW5nIHRoZSBpbmRpdmlkdWFsIExTTXMuCgpEb2Vz
IHRoYXQgbWFrZSBzZW5zZT8gIEl0IGJhc2ljYWxseSBjb21lcyBkb3duIHRvIGJlaW5nIHNtYXJ0
IGFib3V0Cm91ciBhYnN0cmFjdGlvbnMgYW5kIGJvdGggc2VsZWN0aXZlbHksIGFuZCBjYXJlZnVs
bHksIGJyZWFraW5nIHRoZW0Kd2hlbiB0aGVyZSBpcyBhIHJlYXNvbmFibGUgcGVyZm9ybWFuY2Ug
Z2FpbiB0byBiZSBoYWQuCgotLSAKcGF1bC1tb29yZS5jb20KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2Zz
Mi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlz
dGluZm8vb2NmczItZGV2ZWw=
