Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA74C77B75
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 May 2023 02:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8BVcPIjFJAiKPdgarp96tSnsFx3SN2sCKHv02ttaLw8=;
 b=dMjMXoyGwJ66T/bTPXvZD0E8VYDl5NDZ0acXDWjtebqXuFSnftDkMsvoIeO0vCCMZSJgoBwIZxzX
   R91SfRyf4vAJKRN0YWTBvEwLj50Jh9YJa2fljGZT7VthbH5yvP08p/F2I0fiSBgQmVk9YqLM1JFJ
   gcsKA5kTbTg+U6IFR/7UN8yPWbpqm7zRoGSy1cZI0YUtVws7A2xWT6t9USpW37y5AoJs71t7V6Us
   JX0/xXqsPIHu1YVbLoIDS3y7FxyZP64Aj3Jj2++lZSTrujGfSoGWehrcjzAsjtRO6VeDBvkZn3kh
   Uh/nobkzN9vvo5/YBS7h7wgXozInYCJqy4GPVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8BVcPIjFJAiKPdgarp96tSnsFx3SN2sCKHv02ttaLw8=;
 b=YBMDQRAZsDlOMRSMSQui4y4BgiVIgCjhxVxzRqPMSRYioEo7/r/2E/3hhU6JMdU8HfsQkH0oKCnl
   msycG/5TpRa/pqhVrzBhaozXjr97bEOC9B7XkIrA9Fq2+HGmREj5Ig9LY+LbZjl9gtyFREixegFs
   CRKO9heUs4BClJcAJpWQZwaAf3I/BU0Fsq69UIowHldF4mmSts9adIj5jbv8+3/EdNq2PqiRkII+
   iC2gl41sZvUyAZv59rtYjYXJAgyGHpIA4yba3IqB5WX0NusbesE5FU++OXiglBRaDv0Q0Ujqhvye
   Qf4ZowBrNYgWQV1brpzBrAqr9V90JRWpjpiqRw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV30048DBLITIE0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 23 May 2023 02:44:06 +0000 (GMT)
Message-id: <002ed0eb-1195-ce7e-06a0-d85155f67f04@linux.alibaba.com>
Date: Tue, 23 May 2023 10:43:11 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
 Heming Zhao <heming.zhao@suse.com>
References: <20230522102506.9205-1-lhenriques@suse.de>
 <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
 <87h6s47dxw.fsf@brahms.olymp> <20230522123623.eozzedrogy4oaj3w@p15>
 <87cz2s7b6m.fsf@brahms.olymp>
In-reply-to: <87cz2s7b6m.fsf@brahms.olymp>
X-Source-IP: 115.124.30.112
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10718
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=822 spamscore=0 impostorscore=0 priorityscore=90 clxscore=81
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230020 domainage_hfrom=8804
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
 read-only filesystem
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjI7rPy_1684809791;
X-ServerName: out30-112.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: e_7LRs0gVNoo0WU2ZNMaEYejq4pX-7Y2
X-Proofpoint-ORIG-GUID: e_7LRs0gVNoo0WU2ZNMaEYejq4pX-7Y2
Reporting-Meta:
 AAEnuR36c2EElkHJuriYBBaSmhIXw/m3ETtXLXnVewUoQWThUZXL2gfjzOEfQ/w6
 OCmJN78TI82oq7HPapT5EjySoR8o/dVIowivJLdwI+2lt2bEN5bsM1u61w2wLfyL
 0xzPujKzKQD1YdjNoPL/9fO0K+nUEfZlEl6xoVKxv0Pk7BXdnL2lY/q0bYak8ed2
 MzV6YKYeYNQCMjQezmkfmXkOoo6qCSN4syhzevpzu0MtViWQchHR1w9GAbgPlsX5
 hhiEuz4LUQmIk4MoHDKe9+tp/HR8O6/OU1WC1qh1DRh0cxNrPN39bjTtqoIectcC
 kGrCqah3AiLKknYz/8LDFMfFgt4pmU7hFEB5htchgF/yKUP4broALstWt6Ii/g5i
 rMk9+i2vZqySvP96wGS4CBe5FniVwhmabOaHD6ksU5zH+PRUZq6LbpVr4O+H8MDR
 dMAKLs3/Ksk1JQChdv6SN5Fg2dn+4+G/cLJUmjaKPZuZKG5L7IUqVeyVo26HaPjO
 sjJgrRWS6YSWnn5hu/axBWeyM0FCh8twVXHnapQBpCvPiA==

CgpPbiA1LzIyLzIzIDk6MjIgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPiBIZW1pbmcgWmhh
byA8aGVtaW5nLnpoYW9Ac3VzZS5jb20+IHdyaXRlczoKPiAKPj4gT24gTW9uLCBNYXkgMjIsIDIw
MjMgYXQgMDE6MjM6MDdQTSArMDEwMCwgTHXDrXMgSGVucmlxdWVzIHdyb3RlOgo+Pj4gSm9zZXBo
IFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IHdyaXRlczoKPj4+Cj4+Pj4gT24gNS8y
Mi8yMyA2OjI1IFBNLCBMdcOtcyBIZW5yaXF1ZXMgd3JvdGU6Cj4+Pj4+IEl0J3MgdHJpdmlhbCB0
byB0cmlnZ2VyIGEgdXNlLWFmdGVyLWZyZWUgYnVnIGluIHRoZSBvY2ZzMiBxdW90YXMgY29kZSB1
c2luZwo+Pj4+PiBmc3Rlc3QgZ2VuZXJpYy80NTIuICBBZnRlciBtb3VudGluZyBhIGZpbGVzeXN0
ZW0gYXMgcmVhZC1vbmx5LCBxdW90YXMgYXJlCj4+Pj4KPj4+PiBnZW5lcmljLzQ1MiBpcyBmb3Ig
dGVzdGluZyBleHQ0IG1vdW50ZWQgd2l0aCBkYXggYW5kIHJvLgo+Pj4+IEJ1dCBvY2ZzMiBkb2Vz
bid0IHN1cHBvcnQgZGF4IHlldC4KPj4+Cj4+PiBSaWdodCwgYnV0IEkgdGhpbmsgaXQncyBzdGls
bCB1c2VmdWwgdG8gcnVuIHRoZSAnZ2VuZXJpYycgdGVzdC1zdWl0ZSBpbiBhCj4+PiBmaWxlc3lz
dGVtLiAgV2UgY2FuIGFsd2F5cyBmaW5kIGlzc3VlcyBpbiB0aGUgdGVzdCBpdHNlbGYgb3IsIGlu
IHRoaXMKPj4+IGNhc2UsIGEgYnVnIGluIHRoZSBmaWxlc3lzdGVtLgo+Pgo+PiBJdCBsb29rcyB5
b3UgZGlkIHNvbWUgc3BlY2lhbCBzdGVwcyBmb3IgNDUyLiBJbiBteSBlbnYsIHdpdGhvdXQgY2hh
bmdpbmcKPj4gYW55dGhpbmcsIEkgY291bGQgcGFzcyB0aGlzIGNhc2Ugc3VjY2Vzc2Z1bGx5LiAK
PiAKPiBObywgSSBoYXZlbid0IGNoYW5nZWQgYW55dGhpbmcgdG8gdGhlIHRlc3QuICBJIGp1c3Qg
bWFrZSBzdXJlIHRoZXJlJ3MgYQo+IHNjcmF0Y2ggZGV2aWNlIHRvIGJlIHVzZWQuCj4gCj4gTWF5
YmUgeW91IGNhbiB0cnkgdG8gZW5hYmxlIEtBU0FOIHRvIGNhdGNoIHRoZSBVQUYuICBJJ3ZlIGZv
dW5kIHRoZSBidWcKPiB3aXRob3V0IEtBU0FOIChpLmUuIEkgc2F3IGEgTlVMTCBwb2ludGVyIHBh
bmljKSwgYnV0IGVuYWJsaW5nIGl0IGFsc28KPiBkZXRlY3RzIHRoZSBpc3N1ZSAtLSBzZWUgYmVs
b3cuCj4gCj4gQ2hlZXJzLAoKV2UnZCBiZXR0ZXIgYXBwZW5kIHBhbmljIGRtZXNnIHRvIHBhdGNo
IGRlc2NyaXB0aW9uIGFzIHdlbGwuCgpUaGFua3MsCkpvc2VwaAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9s
aXN0aW5mby9vY2ZzMi1kZXZlbA==
