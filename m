Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F41EC76196
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Mar 2023 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4j729wc93W8QvalHX+Q1zYXdiybhMIkZYk205njg4Ow=;
 b=NwIudHhfOKoqPgicMQqUDxasGSsLsn5lmSbvAWn7ANGhUOpscsAGz4Pm83AStokWbO2tiF4Og7zp
   7Vo/prHbPspW81UFnG/NR0iVRgiJn0GJzU2xKxPph3vjr4RajqVYkfaTrV4f0hN/Jis005nlH0RM
   TrBZYOe+zW/GMFU5C2UpDHz7WgkKJgCZmjS9XLcKqxWLc4W6Ji3G0NQkMU5v3tsU4QBBHfHayOIN
   /QCIfSOSE1V20rKtpopobRuYk4XU8BsVTgxyNNEd2ZSTV8kIV+XadIHr6V79FdOWXgJ7Bkwgo/3A
   AxZvFMdLSLCjLeo6rZAAbiqwGZU9uzcD7RPavQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4j729wc93W8QvalHX+Q1zYXdiybhMIkZYk205njg4Ow=;
 b=Oy5LlMHsYeZAVsyUb36mBu32ddQTr3fPpRGZJ1Qsogn4WqB/TXTbwGc7teDzLuHPzkwaEcYPWRDy
   USIUV4bGABVJXk34rjAli/22rTvg2j/u6rxfpnX3SZb4AV2k4atBdZy6rnv2t1/96YtGsDNsGGlg
   KzUgguVQnruj6WHq1OY8vBJZLJn56FCpvDtL2wmRUyR/5k6NdvygArMxXxlP+Q3wWnl9GzcnAlc+
   qQ6d9z978uFjCuV2ekoRJU6SvTt7PtQddUT95xRFT7FT6wrzqc6pJJfNKdE9NQs5BYoLsStBFpsf
   OL5vCiw7RSq4HZogqOCe6hj+qJev1tLT/F58wQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS100BK53P8U9C0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Mar 2023 14:17:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; t=1679667440;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=qyz70q0exwlxpG0yMPJfrMAVsSG+06PVBNztaJhtJqo=;
 b=AOQvr9b4IDlun2P9WBqyFgYrZnRMnWkZbi7nKD1h77svDtysp3k2+svumSz94wRohI
 DHZZwnayCvXPboUZHbIPyaInyWGXe1MZU80EoiXvTGptGU5x9ycbCOmJQPEv5+ToeKhI
 M28EIQd9BR39cjtGdwuyZiW6Z7sHOCN3XEb/+rDt/zaSbv28B5BeAQweq/nnqcNzKhfQ
 8dNPfrfNpTMGHcndWQbl5qRBpRC+A5GBdNdTaoP1dpsA4MjG2imDAtn4mnZCDF0V7zF9
 v0rIKu1s/EOQIUsfRTFmsVupWgV2UUt+PQt8qEAWmu6B4mKm/O6meI3joa44DP3+Dbq0 WgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679667440;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=qyz70q0exwlxpG0yMPJfrMAVsSG+06PVBNztaJhtJqo=;
 b=w3fbMAh5gJLpXN4rcO1vz21u0ZHXJt9ysb2WQqwirP3odWqTR14cGyYZv7OcAdZcum
 Cbsht92TSSqbux8NQKlMX7WqHFgJEkMi7wlBRKUMQJ8OXT0L1T7Wh1b9Sd8iSt3/gdt2
 0iRdGEvnnXKEsuax4RqnBQAL54M6YLXAQ7q8oGrOw16lwjO3SNQuQsaKHn7uM4pzXCWH
 nfvt3pwQ41IqAaMmDdic+sW/PhFQxmsgSC/lyO78crt/3kNudLZLvOdDOuJ/ciq0QEZ+
 1FmJCgDrXYmoVkBko34pVcifX31NlM3rmtzRg58lYtc1r56eny6ySHF/A5dIx1Fdm+NT 2GtQ==
X-Gm-Message-State: AAQBX9eMfMVD7P4CIVGVlA3mwDxXFft21EGzC7AfpFzhLu0sbmwN6SAP
 dTt1vsIUeSMh/z+F8IXFQ2Xe7BQpZ/TSPCMOE67t
X-Received: by 2002:a05:6902:1586:b0:b76:ceb2:661b with SMTP id
 k6-20020a056902158600b00b76ceb2661bmr1495681ybu.3.1679667440030; Fri,
 24 Mar 2023 07:17:20 -0700 (PDT)
MIME-version: 1.0
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-5-roberto.sassu@huaweicloud.com>
 <CAHC9VhTD3EyDiJs9+NQrgp84JcUs_sx8WONtRk2YYH4m1C8nVw@mail.gmail.com>
 <5d8d802a-7664-fdf0-52ef-5817634d870d@schaufler-ca.com>
In-reply-to: <5d8d802a-7664-fdf0-52ef-5817634d870d@schaufler-ca.com>
Date: Fri, 24 Mar 2023 10:17:09 -0400
Message-id: <CAHC9VhRxsY6B3dL7db4b8bfznEz6rK2qiaDug4Hc_ywvU3vB5A@mail.gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
X-Source-IP: 209.85.219.176
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10659
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=150 phishscore=0 mlxlogscore=639 lowpriorityscore=0 mlxscore=0
 spamscore=0 priorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240116
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 Roberto Sassu <roberto.sassu@huaweicloud.com>, eparis@parisplace.org,
 linux-integrity@vger.kernel.org, stephen.smalley.work@gmail.com,
 ocfs2-devel@oss.oracle.com, serge@hallyn.com
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
 AKy350amz4iSWC/J6MBpFaFbKcK0anHYtISoEVuIwiCetg7GwG+iRm9rYxlweWMrGHUcXR2/Z4SwCvWYK/Z/pHw7RwU=
X-ServerName: mail-yb1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: kjh_GNkejby8CfcGzaTLe46qGRbw_dVK
X-Proofpoint-ORIG-GUID: kjh_GNkejby8CfcGzaTLe46qGRbw_dVK
Reporting-Meta:
 AAG8GykvpPgeUJ1HzOUPEs4RYhVAPkhRfJ4GUzm0Nfw3PbDrDHEFvSHIyoHvzNkI
 ihp2J9yD28me87bLDibJ+3VOzJFDSTEG/ouc1/6garg42SR5Gs8cJeEuABBG4RLU
 Ka8ZOaOCCMABdSNIMH3E3chvAmd6buyFGo8DQEmCDUfTdN7oV5TLxtjLzws7ycre
 DiHTxjiYE5q6tGgIN9KOKOztzcBNLW6rpWaRC1nHKyu7NC92tHkeEYvp97esNhHF
 AeMBlXBFBeRkaB0gjYpnLbgc+YZEbuM3j84+RYrUS18Ag2U8ebJpBUyPLjU9Xhk2
 6ZOu7nD2syI+DghXfrC6Dg4V8mrFn/8sxbaX08T2UTuH6UwN4mLerB2Xv5M7lG/S
 tjbNS7KbcriAkPHnhXL+mwmCgFkTgFnBlk0AWLzXtteBq1Wbcm3/6s+WskLdjGTT
 ojzVV1hnbeHnaC7C7FVo2OBP0LW6Jonit9o0AJTQ+F02b+zElUzKUm90OMweIKXB
 gsT4Rrtyq45JvtudTtznWTvXHuWLfNP1eIDDenySe6c=

T24gVGh1LCBNYXIgMjMsIDIwMjMgYXQgOTowMeKAr1BNIENhc2V5IFNjaGF1ZmxlciA8Y2FzZXlA
c2NoYXVmbGVyLWNhLmNvbT4gd3JvdGU6Cj4gT24gMy8yMy8yMDIzIDU6MDkgUE0sIFBhdWwgTW9v
cmUgd3JvdGU6Cj4gPiBPbiBUdWUsIE1hciAxNCwgMjAyMyBhdCA0OjE54oCvQU0gUm9iZXJ0byBT
YXNzdQo+ID4gPHJvYmVydG8uc2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKCi4uLgoKPiA+
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9sc21faG9va3MuaCBiL2luY2x1ZGUvbGludXgv
bHNtX2hvb2tzLmgKPiA+PiBpbmRleCBjMmJlNjZjNjY5YS4uNzVhMmY4NWI0OWQgMTAwNjQ0Cj4g
Pj4gLS0tIGEvaW5jbHVkZS9saW51eC9sc21faG9va3MuaAo+ID4+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvbHNtX2hvb2tzLmgKPiA+PiBAQCAtNjMsNiArNjMsNyBAQCBzdHJ1Y3QgbHNtX2Jsb2Jfc2l6
ZXMgewo+ID4+ICAgICAgICAgaW50ICAgICBsYnNfaXBjOwo+ID4+ICAgICAgICAgaW50ICAgICBs
YnNfbXNnX21zZzsKPiA+PiAgICAgICAgIGludCAgICAgbGJzX3Rhc2s7Cj4gPj4gKyAgICAgICBp
bnQgICAgIGxic194YXR0cjsgLyogbnVtYmVyIG9mIHhhdHRyIHNsb3RzIGluIG5ld194YXR0cnMg
YXJyYXkgKi8KPiA+Cj4gPiBObyBuZWVkIGZvciB0aGUgY29tbWVudCwgd2UgZG9uJ3QgZG8gaXQg
Zm9yIHRoZSBvdGhlciBmaWVsZHMuCj4KPiBJIGFza2VkIGZvciB0aGUgY29tbWVudC4gbGJzX3hh
dHRyIGlzIHRoZSBudW1iZXIgb2YgZW50cmllcywgd2hpY2ggaXMKPiBkaWZmZXJlbnQgZnJvbSB0
aGUgb3RoZXIgZmllbGRzLiBUaGUgb3RoZXIgZmllbGRzIGNvbnRhaW4gYmxvYiBzaXplcyBpbgo+
IGJ5dGVzLiBJbmNvbnNpc3RlbnQgYmVoYXZpb3Igc2hvdWxkIGJlIG5vdGVkLgoKRmFpciBlbm91
Z2guICBTaW5jZSB0aGF0J3MgdGhlIGNhc2UsIGxldCdzIGVuY29kZSBzb21ldGhpbmcgaW4gdGhl
CmZpZWxkIG5hbWUgaXRzZWxmIHNvIHRoYXQgZXZlcnkgdXNlciBoYXMgYSBzbGlnaHQgcmVtaW5k
ZXIgdGhhdCBpdCBpcwphIGNvdW50IGFuZCBub3QgYSBzaXplLiAgSG93IGFib3V0ICdsYnNfeGF0
dHJfY291bnQnIG9yIHNpbWlsYXI/CgotLSAKcGF1bC1tb29yZS5jb20KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlz
dApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxt
YW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
