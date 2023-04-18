Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09981C77B7C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Apr 2023 02:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t4HhFI2EsrQ8p+H1rDXJw2yrKp55otRTgrFEgRQ6aro=;
 b=t1i0Mlbki0LG5Djnv6yQoz9jjwpciEKaSTkDBzoydXA0yDOPnAvHwOqNzBEXfkdmHjcvOWCIGINj
   j4NVMiXe34oRPzSxTMpAoHmXzjEq/YKreTCI5bc+XSdFnV+lLop4JBEcuKpG8kTwSJkCmwuB5hBC
   bSl3NL+WwtvWc5izZvUFDApt4nRnjdDW2dTO1SiKLo2PGWoMpbt8RaXkmbtLmaW96WS4kHYbk5+E
   7H2K7N4JASKSFVMVaEVfbBgPrNyvEBjKZdkl3wecf7qBvB6X3g4lhTuv8q5GQgEtObxuMVNPt60N
   SrEPjTw/hng4nQeyw1swXoJw29kSgWaT/k/sLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=t4HhFI2EsrQ8p+H1rDXJw2yrKp55otRTgrFEgRQ6aro=;
 b=t4LY9bBa/Jta0hEqc0HH2HAtACYyTr53l0hVbNhFjCcBZqSRiJojChoo/+yddSkc/Mxt38iTGpFh
   AEAcvX2Q4BStV4E0/4/KBo4k5kZz/YdLQj5aiP4g42l5i0pI8gCwObIVG5WLdvoD6Uhz/+o+S5kZ
   H4T8USn8xTpS+fZm66TMxb8g+m0k8aNsHx/uB7Yz5s2/bV4OM7nSX0dgFS/9hpWlP/mqILI2ae5o
   9MPMroEcDVntDQWgKsEYix3i3xwnQg4je9DYOIUZOCq9fU7oV0lfJnBRu+66yKnWFFrVxTTGLK5B
   IMeNU3Bf1kXlDoPWy/8DiOk4tnT8QZDsyT1H7g==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTA00D0GHNJ69F0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Apr 2023 02:30:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fasheh-com.20221208.gappssmtp.com; s=20221208; t=1681785006; x=1684377006;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=bDxggslLkUgEL2+ia1HCW7STSsqbXoPlZsIfI7N9xmA=;
 b=xa85+Vj2JsBDsYcpf9HcVto042Lzsl6wYDyKCwA7ceCf0RHJN/thMvVIbuf73ZQaoO
 qjGM3DOMOgRV/XSgWd97nupWFK5kcVKQW1SOlrR4VWQmrI2UkzZKcKY3QaNZoCShmO3Q
 izScWvY20VzXjJK/LS7t/MPQZNb5hCtY6uwbaR4KOGdWveQIZB+BzI6IrIRi4mMPaESV
 47uiN76TTBGvYBySgtfDregPYN0pS57TsjG9Bu0V8R1AOX0yHe7QNK/bQAv0fYfmONwq
 NexDaBQFLE1IWFHpIZUawV75XHzVU9ucSPVlSbijCFuc7HOL3G5rRbzeT/OQXFCxx+ig BmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1681785006; x=1684377006;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=bDxggslLkUgEL2+ia1HCW7STSsqbXoPlZsIfI7N9xmA=;
 b=ISb0QHAARunD/OIBDSYIACPtUHOYK9ePUdjoOKXwZYgm1Pa2CqGy3eQQ2d3yHH0eB8
 kPUhnM7ha22JQoaNFkClx4iSO3JAYqAiP6tj8R/D1J1BmaYJpCQGTkxszXp9whbDbmPs
 6nOFtKwdahK/CVv1dhgJhXwLvoawI4mSgPZAWScg4/s7EXkF70twk0ESa0a92Q0MXqSd
 euBm6UBcWiPqhp7eQk3/aLjwhPBlFpU4DbrjfVqLdm6yNztp4ULuHFv7arxb9K/CKnzx
 ZM5zR6maUj8jQREdSxPO+hOPnLGGkBZG4Qq+VJ6UZQnnCqG1+1o4Qhyohpuy13lW8p5x i48Q==
X-Gm-Message-State: AAQBX9eWYbhagkCNNWJCfT1jqKue9S5HYhPxgs8QiZdNv+961ziNY7BF
 m1cjVEFYwKFzC0wtO6LnKY2y9Mav3NfoVUdeBn8YSg==
X-Received: by 2002:a81:af0c:0:b0:54c:2889:7105 with SMTP id
 n12-20020a81af0c000000b0054c28897105mr10993949ywh.0.1681785005975; Mon,
 17 Apr 2023 19:30:05 -0700 (PDT)
MIME-version: 1.0
References: <20230417205631.1956027-1-arnd@kernel.org>
In-reply-to: <20230417205631.1956027-1-arnd@kernel.org>
Date: Mon, 17 Apr 2023 19:29:55 -0700
Message-id: <CAGe7X7ntw_iZUsKbcg7PwJAeAqtFBia20rKs=Q__mtYaCMdc2w@mail.gmail.com>
To: Arnd Bergmann <arnd@kernel.org>
X-Source-IP: 209.85.128.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10683
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=704 adultscore=0 spamscore=0
 unknownsenderscore=20 priorityscore=134 suspectscore=0 clxscore=312
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304180022
Cc: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?B?SmFuIEjDtnBwbmVy?= <hoeppner@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Mark Fasheh via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mark Fasheh <mark@fasheh.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350bKvrXu9w5GkD4lbrkV8di9EMGrf1pWcKqHnAs24Nn8t8I6pbkm8kneRJMSkr6k/zfpXVg4hEe2duVvIPfKQi4=
X-ServerName: mail-yw1-f170.google.com
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: qAXUqdhAKvlYeW4_dCNfnBLSDaZjQjct
X-Proofpoint-ORIG-GUID: qAXUqdhAKvlYeW4_dCNfnBLSDaZjQjct
Reporting-Meta:
 AAECf3mME7dbrVZO4x5PJRbRIF26vPXnkSGGnHg1rZorOMOmJS7pBUMT6TysgmcJ
 +nUjQliWVRX1MxKHGiNX8ZxMzHNDPyqy0qqiGsLU8+Ff29MGQo2GNF1baY3z1O+c
 AQIPzabZRQ2V4xLNi+J1i0OUzyTbyS4piJ9cOmY1Fz3L2qkXIAGWKgXxOOsmzNSy
 8nmJPqtC6SP3pSwz9uyexWgOt8xFAu1BA2AZNFOJSJoPUGdR2vWJu+TChd8SPNEA
 n6e0BKUpysQWo0qehLVRStJ/7uq8bqY3iigJ9iwXR6/eCoIV8WhM5HC4pAe1vw3x
 GyMfiwjYq82o6VlVoYSWQNOsXBNFR+Io+qd6xTyYHVloNDq++EOYk4VFHAeIUZxw
 VLByTsYZaXcaHXeeC4f0mGUos2bDo5mbSx23GE0F8fiTDGvD6PzD62YROgFuxo3i
 atMPopTBQZuz2wbOWl32mg62goUgRV1Z6QF/zG4qC+LkngZxGKNmqVJvQtGjNne1
 MTx2uLl0Ac2meMZoS0iL190cE8USbQux9cTTjzidHvBx

T24gTW9uLCBBcHIgMTcsIDIwMjMgYXQgMTo1NuKAr1BNIEFybmQgQmVyZ21hbm4gPGFybmRAa2Vy
bmVsLm9yZz4gd3JvdGU6Cj4gT24gMzItYml0IGFyY2hpdGVjdHVyZXMgd2l0aCBLQVNBTl9TVEFD
SyBlbmFibGVkLCB0aGUgdG90YWwgc3RhY2sgdXNhZ2UKPiBvZiB0aGUgb2NmczJfaW9jdGwgZnVu
Y3Rpb24gZ3Jvd3MgYmV5b25kIHRoZSB3YXJuaW5nIGxpbWl0Ogo+Cj4gZnMvb2NmczIvaW9jdGwu
YzogSW4gZnVuY3Rpb24gJ29jZnMyX2lvY3RsJzoKPiBmcy9vY2ZzMi9pb2N0bC5jOjkzNDoxOiBl
cnJvcjogdGhlIGZyYW1lIHNpemUgb2YgMTQ0OCBieXRlcyBpcyBsYXJnZXIgdGhhbiAxNDAwIGJ5
dGVzIFstV2Vycm9yPWZyYW1lLWxhcmdlci10aGFuPV0KPgo+IE1vdmUgZWFjaCBvZiB0aGUgdmFy
aWFibGVzIGludG8gYSBiYXNpYyBibG9jaywgYW5kIG1hcmsgb2NmczJfaW5mb19oYW5kbGUoKQo+
IGFzIG5vaW5saW5lX2Zvcl9zdGFjaywgaW4gb3JkZXIgdG8gaGF2ZSB0aGUgdmFyaWFibGUgc2hh
cmUgc3RhY2sgc2xvdHMuCgpUaGFua3MgZm9yIHRoaXMsCgpSZXZpZXdlZC1ieTogTWFyayBGYXNo
ZWggPG1hcmtAZmFzaGVoLmNvbT4KICAtLU1hcmsKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZl
bEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWw=
