Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC6FC678D5
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mmyACWVyDse2OcIiUzY+MGZXz7kGUUARBdvvJbya0EM=;
 b=Nb/Jm4v68aYzZldgPiel5AKibixblp4pqouHXSFwtA/jl1d/r8SxzEh7yrqg/T2a5wiQqDzbbJBf
   15/PbvYwC0UOaAUCUEUbEbSAZqalLvx8DHh4Y9ciG1vVQG75+aw2ht/VUHhzgUrhEVc/g/NkGoy6
   nIREhd5sBoVRalXn9vabBzof8ZXpKQQ+1ACmjFH25i4ksKSqtzeXu4t0FbCkGjy4v9V1jro/BQj6
   9PI52h1qa2vQM+ixlVkHoKRa40Z77MT3hTpeQuMP3s/XesdJitarinChs8xm3O1BB2IJNhjCcmgg
   dGfrQ+Zn+aR00Ac+XgLSVq7abB5REGhwe+3CbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mmyACWVyDse2OcIiUzY+MGZXz7kGUUARBdvvJbya0EM=;
 b=cqbKchfutOclBHs1ABQdZoJXswTd5SYrD86fslY5z2qDY5fWsqE1+KteB3HLNzGndOd4l8VOf74Z
   ukz/Fwsyx1yNhOiLDRgK1kwoiU9VWT/QuZgJnLRVLZmk3trBLK6D+gBrIezCaro2+qqaLWAMi386
   TAbLtSp58Y8Z7GZhcca9ORZPprfja4SMA+6d8mINptJ+96Z7/rNcRRdpgTDvnOTFY6Tf1X7Dt5Qd
   5azELxz/484q5rLtgQW/9zIGE/8HvBMWpmFN/J5ffmiRGe5RyqCbjKct+aI0p4P86K9GlmTXzzPo
   7Glq5Kf9Rbft8ojKYV4wVUYVxOGKN+ytxcU92Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR50074S4VTGQ40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 07:59:53 +0000 (GMT)
Message-id: <e848f2fbff1677023128afe4351e5af28576c058.camel@huaweicloud.com>
To: Valentin =?UTF-8?Q?Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Date: Tue, 07 Mar 2023 08:59:15 +0100
In-reply-to: <ZAZtYjHlhM6IAVpc@valentin-vidic.from.hr>
References: <ZASjOpsoM+nEx/o8@valentin-vidic.from.hr>
 <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
 <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
 <e804e6881e96680107a4db3d4b81e5e898f5fbde.camel@huaweicloud.com>
 <ZAZd0yMvJTV/h/DM@valentin-vidic.from.hr>
 <ZAZtYjHlhM6IAVpc@valentin-vidic.from.hr>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 priorityscore=0 mlxlogscore=462 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=212 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070071
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
X-CM-TRANSID: GxC2BwD3xl3W7gZkm314AQ--.36110S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr13WF4DKF1rtFyxJr1rCrg_yoWftrb_uw
 42gryxJFn5Jr1UXFs7JryagrZ2kFyDJr1rZ3WDKr43uwn3Ga47GFZ7Cas5ZasxWa1Sqr1U
 uF9aqw1rtr1aqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUbOxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267
 AKxVWUJVW8JwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
 ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4
 AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
 6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
 AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
 2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42
 IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVj
 vjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAJBF1jj4ZG2QABsm
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: q0m_dLwm5rPSXOPwM5SBhVgNfemDVJt2
X-Proofpoint-GUID: q0m_dLwm5rPSXOPwM5SBhVgNfemDVJt2
Reporting-Meta:
 AAHyrgr8LbXKZBE6YjMf7Oxxm+Wvb5ASCJ51hjWLfL4OV3uMnAi+SeiVji823+1q
 UXwCZr31BWI8aI/uCf6yVQcs+F047rdDtb7GTcN0l5HnePMzw/Xrnt1WKUxuzJlL
 jxJIfups5lf6PmGhxkRHlxttdD4RBE44w7fXDMW049XiXOmMlettrwCFDR6G81NI
 M+FybAw41d8wXZqe/WDICIT3jk/FaAMhxdcIpfrHCB4MiS3GVGycCd6OrlMfaBBb
 U6I0ERzNGQKm7MluU8TFrPhtzMWFXebVKY/q6jHMZsw0OTsE1kEg1IXQhxudqCdy
 lqaVYES5uWyPvxUoinv668fPd6tJdYgmd3LkE5cq+s31FXKOuxvpp+6yX6XdOqEr
 ERcBpkBzO+B9WFzrCfPMQJCLVftditPVKGBejghkhg1f+5kGNHd99uGJmS//n+AE
 s5VXjw2VWZ2J6iJekOyQuRQcxQQTx5vvCtYXUZjT8gLnX/GEAbjvJOC6tb3nMUZy
 uUZqON/B9LJbKny3BrC3aEZGjCBZDPxia0mLlTWAXiR+

T24gTW9uLCAyMDIzLTAzLTA2IGF0IDIzOjQ2ICswMTAwLCBWYWxlbnRpbiBWaWRpxIcgd3JvdGU6
Cj4gT24gTW9uLCBNYXIgMDYsIDIwMjMgYXQgMTA6NDA6MzVQTSArMDEwMCwgVmFsZW50aW4gVmlk
acSHIHdyb3RlOgo+ID4gSSBzdXBwb3NlIHRoZSBmaXggd291bGQgYmUgdG8gY2hhbmdlIHRoZSBk
ZWZhdWx0IHZhbHVlIHRvIC1FT1BOT1RTVVBQPwo+IAo+IENvbmZpcm1lZCwgbmV3IGRlZmF1bHQg
dmFsdWUgZml4ZXMgdGhlIGNyYXNoLiBJdCBpcyBlc3NlbnRpYWx5IHRoZSBzYW1lCj4gcHJvYmxl
bSBhcyB0aGlzIG9uZSBpbiBjZXBoOgo+IAo+IGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxkcy9s
aW51eC9jb21taXQvN2Y1MDU2YjllN2I3MTE0OWJmMTEwNzNmMDBhNTdmYTFhYzI5MjFhOQo+IAo+
IEknbGwgdHJ5IHRvIHByZXBhcmUgYSBwYXRjaC4uLgoKT2ssIHllcy4gSXQgaXMgYSBrbm93biBw
cm9ibGVtLiBJIHRyaWVkIHRvIGZpeCBpdCBzZXZlcmFsIHRpbWVzLCBidXQgbm8KbHVjayB5ZXQu
CgpodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAyMjExMTUxNzU2NTIuMzgzNjgxMS0xLXJv
YmVydG8uc2Fzc3VAaHVhd2VpY2xvdWQuY29tLwoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBm
LzIwMjIxMjA3MTcyNDM0LjQzNTg5My0xLXJvYmVydG8uc2Fzc3VAaHVhd2VpY2xvdWQuY29tLwoK
SWYgeW91IGNoYW5nZSB0aGUgZGVmYXVsdCB2YWx1ZSB0byAtRU9QTk9UU1VQUCwgdGhhdCB3b3Vs
ZCBhZGRyZXNzIHRoZQpwcm9ibGVtIGlmIG5vIGVCUEYgcHJvZ3JhbSBhdHRhY2hlcyB0byB0aGUg
aW5vZGVfaW5pdF9zZWN1cml0eSBob29rLiBJZgpvbmUgZG9lcyBhbmQgcmV0dXJucyB6ZXJvIG9y
IGFueSBwb3NpdGl2ZSB2YWx1ZSwgdGhlIGtlcm5lbCBjYW5ub3QKaGFuZGxlIGl0LgoKUm9iZXJ0
bwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMy
LWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29z
cy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
