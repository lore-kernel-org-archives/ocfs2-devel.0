Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A24B4C7619A
	for <ocfs2-devel@archiver.kernel.org>; Wed,  5 Apr 2023 04:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7C3UFZ/wn6iDIgirtCnDkMZyYMN8/n3zI8xqpO7ztW4=;
 b=vdWoaBRVoBByUm+gXHkoiugRWphsl6/GhX05cbTZ+olPrpbccgGdZD3xkMRiEQJQ+eamrKVQPDKc
   FDOcCrjP09U20OgwBzYKhFtvBZnlwmjaA135nQFxW4V5jSFJ9tXE79u56jSspXRSBv4u2XZcysvJ
   nPqcAQDh+sWNuk3EUelcnC/bmiT9QnfAMzOonccl64T58GbYR3IuScq58dJKR8kcq/9IVD1/9CAp
   osjcFvPErg2Pbx7rsm57iJZ7stA9mkp1VMIO3xR6I8K2eys8fOX3JL9d9B0/0VH++LqNHbQIVkM5
   be2jVuUSoB9aHOgnSo2JE8mzV0TUKuhUGjqQcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7C3UFZ/wn6iDIgirtCnDkMZyYMN8/n3zI8xqpO7ztW4=;
 b=MhtLQqjCyjPt5Oy+Snm71Fp4ZbfUvfyfVQ5aWAHUt4gaR19a8WFukoNo2MizrqFqUuX/3BOQbhOb
   dDfGNINF4AqpSY1NvLEK8jpZLp5cu3BvtjiqSXTBNaMuI6Fp5jBtvoQGDOI0eo8t13QytA4zZ0nQ
   uWrW7sUrk5dJ7X2YCoX351911g+Y8DMXX2vNYuweMqEgd1X0MbiCz5lAMh+4YgbgOqLo0qvmbr8a
   0VYzHSn/z6IybOvg5TogCNnePnRVvNQmxcqCj6ZCQBOk3mrnpBRunhSyDVg7NitvV/PlwGqkweV5
   jWsRXCqTuVdDLIiNruWTdSCXcqKyrKRWjdHOtw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSM00MRYJCW5860@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 05 Apr 2023 04:05:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1680667506; h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to; bh=TJlfy7j3jMnUpTZd8i2RXdQGxubaR4kSxjiHyHktxQU=;
 b=GBLwfW9UJi4zFmg7y/9EKT5SVpOWVKBcOTg6x2OXZDoySEjA2NqEqCXXNliCGLdrIm
 nANtfragDQ9GodkTcqPEAwnnOqLt5VwYILPmMXwTJFTkSdNjfkKykk8r1Y6VQtyxw4tz
 49QTfWGO301+AXZ/tDP5Os97+TmEQtoTmx7a7D6G9iTjsDFMSK0NXGVLS1XFRV6pXVnF
 Vgwi2jCdR+MWGco8cnyO9eIaxK6aByiWUuxhZp86TQv5vGBeDDUblpJ1ckYg8FnjBo47
 vP04pmkcKH+Z2oHyTnSv5LBe8lrlwt2GBG52teC3ieI2/iHqJRH7hKihvKUPAsZrzDCc 3clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1680667506;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=TJlfy7j3jMnUpTZd8i2RXdQGxubaR4kSxjiHyHktxQU=;
 b=kJoD1No3DR2vdYVVOuA3yFeDNNHZ2nQ+yQ9/iTAtjQeGSY/bwZyHQNmno31tKyhLrp
 VGYNNpojV09mjJz85iJKO1b9HitrVb27/l7SBRHxXv4wE0wmv3PQd/8nELfphUym1koc
 aqsVrp0Eg1NuY/N47xW0jvvUp2jp9sRMZSwUH3pOGTuuw2DHVXUWGREJWT/XKgsg03zb
 2mIFClzBxb7SOO27etjO8sR7o7My+P0SETWUGXaO3iN6+lLl+M4qAwZdrxHljRYwRVIv
 7v5obhRsn62B7dtoyVYZRSaq7YtBeeTRtQUc/1ooVwz/Q73tIRbFLElTF8fVC/q/S05q qYFg==
X-Gm-Message-State: AAQBX9eSKALATfmzLr3uwfWkkxbGbM2mDkNNV8JvvSR6aI4kZ7n2Rc8b
 bZOIHv8qgS6NXWR1DcXi2ji8iiJ35Uo8+uaKMlc=
X-Received: by 2002:ac2:5291:0:b0:4e9:22ff:948d with SMTP id
 q17-20020ac25291000000b004e922ff948dmr1405756lfm.7.1680667505632; Tue,
 04 Apr 2023 21:05:05 -0700 (PDT)
MIME-version: 1.0
References: <20230404171411.699655-1-zlang@kernel.org>
 <20230404171411.699655-4-zlang@kernel.org>
 <20230404232159.GB109960@frogsfrogsfrogs>
In-reply-to: <20230404232159.GB109960@frogsfrogsfrogs>
Date: Tue, 4 Apr 2023 23:04:53 -0500
Message-id: <CAH2r5mtmppW-vVdBAnxgH3zsH0b9pMUJyT=s3WTr9dnfwpHrWw@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Source-IP: 209.85.167.44
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=101
 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=344
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050036 domainage_hfrom=10097
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 Zorro Lang <zlang@kernel.org>, ebiggers@google.com, amir73il@gmail.com,
 linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 fdmanana@suse.com, ocfs2-devel@oss.oracle.com, jack@suse.com,
 linux-fsdevel@vger.kernel.org, anand.jain@oracle.com,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/5] fstests/MAINTAINERS: add supported
	mailing list
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
From: Steve French via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Steve French <smfrench@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AKy350YUnFw6FnCbM4/rIL7SfmUol3E7+vdFKY2q63D6zsUvp1WRxA+9ht3amnQRmHWnL/rEG8hkq3VPj2+tk7SUk4c=
X-ServerName: mail-lf1-f44.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: TBsfSB_l97IX4vJ1HTmoRIWAYEkyOexc
X-Proofpoint-ORIG-GUID: TBsfSB_l97IX4vJ1HTmoRIWAYEkyOexc
Reporting-Meta:
 AAF0ks8FiFVgok/oKqOYDbd8zbbe2GAzdGFN0ZDRCzty/gK00GD0R/cFX3UF1BJR
 RFEzgSvQYED+3Wofx7DQUWuDx+meQ+OZX17cV0Hx3oV3jCyv1mF47YfinW/1GdC8
 hLzDettbI5/GMc3Yv7uKYMP7A1Rif9sUYYv1k40YR/5uc13UxOXxPRzs27tDH14r
 gLmuzVqfMTDahdcClO+HaCGugIipAehKMlqpq3ysDPPq+otIJeDmbzk4RRJBeiOz
 TIhE0RW2ai5na1MF3y3ll1q9IHPXpi5wRh7C9w21SoZRYYcF/GXny29mh5LSezZL
 9NE/9eHjpYKyFsX1XUVgs3HYKcTo3/4x/UjxNMgKG4zaiIRayXDK7+uOcRMPaXhw
 88f2m+hP/JLaqSz2HENonI4FlW76veWySz7yxJi20Bqg2e8mUUFuoiKD+hOGIiZM
 +ipVorjdhZ8Q6mFKQ4ghdkhgoebIkqA35iftoIi/hXBGYNM0m3teOzWkyUM8vckO
 gInAhDu36wq6nRixkWqE41y2XU9LIlDtLqM1w8z5jari

UmV2aWV3ZWQtYnk6IFN0ZXZlbiBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+CgpPbiBU
dWUsIEFwciA0LCAyMDIzIGF0IDY6MjLigK9QTSBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJu
ZWwub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgQXByIDA1LCAyMDIzIGF0IDAxOjE0OjA5QU0gKzA4
MDAsIFpvcnJvIExhbmcgd3JvdGU6Cj4gPiBUaGUgZnN0ZXN0cyBzdXBwb3J0cyBkaWZmZXJlbnQg
a2luZCBvZiBmcyB0ZXN0aW5nLCBiZXR0ZXIgdG8gY2MKPiA+IHNwZWNpZmljIGZzIG1haWxpbmcg
bGlzdCBmb3Igc3BlY2lmaWMgZnMgdGVzdGluZywgdG8gZ2V0IGJldHRlcgo+ID4gcmV2aWV3aW5n
IHBvaW50cy4gU28gcmVjb3JkIHRoZXNlIG1haWxpbmcgbGlzdHMgYW5kIGZpbGVzIHJlbGF0ZWQK
PiA+IHdpdGggdGhlbSBpbiBNQUlOVEFJTkVSUyBmaWxlLgo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6
IFpvcnJvIExhbmcgPHpsYW5nQGtlcm5lbC5vcmc+Cj4gPiAtLS0KPiA+Cj4gPiBJZiBzb21lb25l
IG1haWxpbmcgbGlzdCBkb2Vzbid0IHdhbnQgdG8gYmUgaW4gY2MgbGlzdCBvZiByZWxhdGVkIGZz
dGVzdHMKPiA+IHBhdGNoLCBwbGVhc2UgcmVwbHkgdGhpcyBlbWFpbCwgSSdsbCByZW1vdmUgdGhh
dCBsaW5lLgo+ID4KPiA+IE9yIGlmIEkgbWlzc2VkIHNvbWVvbmUgbWFpbGluZyBsaXN0LCBwbGVh
c2UgZmVlbCBmcmVlIHRvIHRlbGwgbWUuCj4gPgo+ID4gVGhhbmtzLAo+ID4gWm9ycm8KPiA+Cj4g
PiAgTUFJTlRBSU5FUlMgfCA3NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKwo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA3NyBpbnNlcnRpb25zKCspCj4g
Pgo+ID4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKPiA+IGluZGV4IDA5
YjFhNWEzLi42MjAzNjhjYiAxMDA2NDQKPiA+IC0tLSBhL01BSU5UQUlORVJTCj4gPiArKysgYi9N
QUlOVEFJTkVSUwo+ID4gQEAgLTEwNyw2ICsxMDcsODMgQEAgTWFpbnRhaW5lcnMgTGlzdAo+ID4g
ICAgICAgICBzaG91bGQgc2VuZCBwYXRjaCB0byBmc3Rlc3RzQCBhdCBsZWFzdC4gT3RoZXIgcmVs
ZXZhbnQgbWFpbGluZyBsaXN0Cj4gPiAgICAgICAgIG9yIHJldmlld2VyIG9yIGNvLW1haW50YWlu
ZXIgY2FuIGJlIGluIGNjIGxpc3QuCj4gPgo+ID4gK0JUUkZTCj4gPiArTDogICBsaW51eC1idHJm
c0B2Z2VyLmtlcm5lbC5vcmcKPiA+ICtTOiAgIFN1cHBvcnRlZAo+ID4gK0Y6ICAgdGVzdHMvYnRy
ZnMvCj4gPiArRjogICBjb21tb24vYnRyZnMKPiA+ICsKPiA+ICtDRVBICj4gPiArTDogICBjZXBo
LWRldmVsQHZnZXIua2VybmVsLm9yZwo+ID4gK1M6ICAgU3VwcG9ydGVkCj4gPiArRjogICB0ZXN0
cy9jZXBoLwo+ID4gK0Y6ICAgY29tbW9uL2NlcGgKPiA+ICsKPiA+ICtDSUZTCj4gPiArTDogICBs
aW51eC1jaWZzQHZnZXIua2VybmVsLm9yZwo+ID4gK1M6ICAgU3VwcG9ydGVkCj4gPiArRjogICB0
ZXN0cy9jaWZzCj4gPiArCj4gPiArRVhUNAo+ID4gK0w6ICAgbGludXgtZXh0NEB2Z2VyLmtlcm5l
bC5vcmcKPiA+ICtTOiAgIFN1cHBvcnRlZAo+ID4gK0Y6ICAgdGVzdHMvZXh0NC8KPiA+ICtGOiAg
IGNvbW1vbi9leHQ0Cj4gPiArCj4gPiArRjJGUwo+ID4gK0w6ICAgbGludXgtZjJmcy1kZXZlbEBs
aXN0cy5zb3VyY2Vmb3JnZS5uZXQKPiA+ICtTOiAgIFN1cHBvcnRlZAo+ID4gK0Y6ICAgdGVzdHMv
ZjJmcy8KPiA+ICtGOiAgIGNvbW1vbi9mMmZzCj4gPiArCj4gPiArRlNWRVJJVFkKPiA+ICtMOiAg
IGZzdmVyaXR5QGxpc3RzLmxpbnV4LmRldgo+ID4gK1M6ICAgU3VwcG9ydGVkCj4gPiArRjogICBj
b21tb24vdmVyaXR5Cj4gPiArCj4gPiArRlNDUllQVAo+ID4gK0w6ICAgICAgbGludXgtZnNjcnlw
dEB2Z2VyLmtlcm5lbC5vcmcKPiA+ICtTOiAgIFN1cHBvcnRlZAo+ID4gK0Y6ICAgY29tbW9uL2Vu
Y3J5cHQKPiA+ICsKPiA+ICtGUy1JRE1BUFBFRAo+ID4gK0w6ICAgbGludXgtZnNkZXZlbEB2Z2Vy
Lmtlcm5lbC5vcmcKPiA+ICtTOiAgIFN1cHBvcnRlZAo+ID4gK0Y6ICAgc3JjL3Zmcy8KPiA+ICsK
PiA+ICtORlMKPiA+ICtMOiAgIGxpbnV4LW5mc0B2Z2VyLmtlcm5lbC5vcmcKPiA+ICtTOiAgIFN1
cHBvcnRlZAo+ID4gK0Y6ICAgdGVzdHMvbmZzLwo+ID4gK0Y6ICAgY29tbW9uL25mcwo+ID4gKwo+
ID4gK09DRlMyCj4gPiArTDogICBvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQo+ID4gK1M6ICAg
U3VwcG9ydGVkCj4gPiArRjogICB0ZXN0cy9vY2ZzMi8KPiA+ICsKPiA+ICtPVkVSTEFZRlMKPiA+
ICtMOiAgIGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnCj4gPiArUzogICBTdXBwb3J0ZWQK
PiA+ICtGOiAgIHRlc3RzL292ZXJsYXkKPiA+ICtGOiAgIGNvbW1vbi9vdmVybGF5Cj4gPiArCj4g
PiArVURGCj4gPiArUjogICBKYW4gS2FyYSA8amFja0BzdXNlLmNvbT4KPiA+ICtTOiAgIFN1cHBv
cnRlZAo+ID4gK0Y6ICAgdGVzdHMvdWRmLwo+ID4gKwo+ID4gK1hGUwo+ID4gK0w6ICAgbGludXgt
eGZzQHZnZXIua2VybmVsLm9yZwo+ID4gK1M6ICAgU3VwcG9ydGVkCj4gPiArRjogICBjb21tb24v
ZHVtcAo+ID4gK0Y6ICAgY29tbW9uL2Z1enp5Cj4gPiArRjogICBjb21tb24vaW5qZWN0Cj4gPiAr
RjogICBjb21tb24vcG9wdWxhdGUKPgo+IG5vdGUgdGhhdCBwb3B1bGF0ZSBhbmQgZnV6enkgYXBw
bHkgdG8gZXh0KiBhcyB3ZWxsLgo+Cj4gPiArRjogICBjb21tb24vcmVwYWlyCj4gPiArRjogICBj
b21tb24veGZzCj4gPiArRjogICB0ZXN0cy94ZnMvCj4KPiBPdGhlcndpc2UgbG9va3MgZ29vZCB0
byBtZSwKPgo+IFJldmlld2VkLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3Jn
Pgo+Cj4gLS1ECj4KPiA+ICsKPiA+ICBBTEwKPiA+ICBNOiAgIFpvcnJvIExhbmcgPHpsYW5nQGtl
cm5lbC5vcmc+Cj4gPiAgTDogICBmc3Rlc3RzQHZnZXIua2VybmVsLm9yZwo+ID4gLS0KPiA+IDIu
MzkuMgo+ID4KCgoKLS0gClRoYW5rcywKClN0ZXZlCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2
ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L29jZnMyLWRldmVs
