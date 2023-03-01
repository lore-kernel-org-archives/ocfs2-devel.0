Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74299C64EC7
	for <ocfs2-devel@archiver.kernel.org>; Wed,  1 Mar 2023 02:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RuZBwuMOVJWiTBENURzs1hE0ybeOdPS22X6Tbbi1x7s=;
 b=2lAYusc3htvd53T/O4/ucnaa1ptgTDM1oiT/W+Ndfqyq7sTKKQ8hdjzfvEJDvU56jNoPHmuQgrG7
   5yegEmtEz74un8p8AWZmUgD2LIqgh4rQqCUc2Vl49QWhBgUK56wDsj8MeDvMV9EK03HYXYdIN+LG
   rY/y++xjAaqatZWgHf/+3XquluG6LCoILhq22gwR42v4akWxd5sZ//IaomIXmJl+S6oKy+QAIGpS
   J3F+QIKum78Elm1UIhDDNgkHxB7lECJMZtF6QTYUqCZazw/Vqe5kyjmZ2+zS4EvrhjPzpApBKl0G
   UUyHKTNmjA1i4dsx6FABiur6mf/Xk1evPvhRHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RuZBwuMOVJWiTBENURzs1hE0ybeOdPS22X6Tbbi1x7s=;
 b=srDruUD9ZNEO9mSSQ7LDI19EBtuaOA2NcpunGjl22SfdxuAPRGYJT765FEOWL+ETZUqCE4WZFxd8
   kPimKgWPOfehFcCs8a1n+aR2oI6OD2faAcNEeEun5asxTmbpJuFD8peR+I69GuVZFb047oOjw94o
   IbcKPHzjjxM5wRC3D6vJ2Hhg7bRGcxfuibXBQXqQSImyHlOyy5MxLolm36kir6ArvNG/MbyXtr3e
   46/7eNCWnvbcj/VwWj1wHlrm15gWXGrBG3UluBU7jsSK+y71TeIKF0bNWbaw0i9ojNpwixQgMmSG
   x/FDbMaRpTppMPV2+ngAAYQDpvtRk7r3AmTOIA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQT00HM8KJ02HC0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 01 Mar 2023 02:06:36 +0000 (GMT)
Message-id: <50c26dfd-afd4-5dc2-212c-a02e84a75440@linux.alibaba.com>
Date: Wed, 1 Mar 2023 10:06:18 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, Joseph Qi <jiangqi903@gmail.com>,
 ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
 <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
 <20230226084544.weep4qypu3mzgjic@c73> <20230226152238.a2wxbriw2sbxmkbk@c73>
 <ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com>
In-reply-to: <ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com>
X-Source-IP: 115.124.30.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10631
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 clxscore=69 impostorscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 priorityscore=130 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010014 domainage_hfrom=8721
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R521e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0Vcl8xIa_1677636378;
X-ServerName: out30-118.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: lAa3uSCiYwZo6OFISo2eaBZqWCWUjM_x
X-Proofpoint-ORIG-GUID: lAa3uSCiYwZo6OFISo2eaBZqWCWUjM_x
Reporting-Meta:
 AAFpLV1Cwkw8o1oV2DONsMaFNkOS9frsSQtospXwLSfniPdkHhCH0dgGacteqLXl
 f+A0f8QNo6sjDZroeNcMqCR+g+lWx/U8s68qN996NWDTRTIRIqiMVcXhd+twrNeY
 l4O+GRqKql4PUsOmlkectBtn+xAOQt1bVQhNsE6dLd+27mqneY10slM9SVgNNg9Y
 Lx9XIr18pyY/SooVAdmESYCiIPrIV5LoifogdtPRGD79SySOoCC78zl+nD4oVSG3
 N0D3RTeaIeOYj9e+kVVp82O066FmjGr1fp3rGJeqi8TeEg60n8Q8cZy39Ndug0Y+
 jSrlkG3uoXf8a7w03+Ttr9WAxHRugyoPBZ0HcARoPr5m7tKPiQwBVyqAkzx7GHgV
 UYZxT4Hy770Us0JPXxRa0cYd3edZl/5LSP/YyWDA6MF18DbFgk3p0FQZ2DLgCKM4
 xTcBBKxrSdN5UOGtEX/a+dyOW2hIwFXbuoZtdKVack2W1XFCHDn40fcHWb4NqKLw
 y/X4bvSupu72gOo3jxRHBEJgpAYvQBJ2y3mHoxJY0Fk=

SGksCgpPbiAyLzI3LzIzIDEwOjU5IEFNLCBKb3NlcGggUWkgdmlhIE9jZnMyLWRldmVsIHdyb3Rl
Ogo+IAo+IAo+IE9uIDIvMjYvMjMgMTE6MjIgUE0sIEhlbWluZyBaaGFvIHdyb3RlOgo+PiBPbiBT
dW4sIEZlYiAyNiwgMjAyMyBhdCAwNDo0NTo0NFBNICswODAwLCBIZW1pbmcgWmhhbyB2aWEgT2Nm
czItZGV2ZWwgd3JvdGU6Cj4+PiBPbiBGcmksIEZlYiAyNCwgMjAyMyBhdCAwNjo1OTo0N1BNICsw
ODAwLCBKb3NlcGggUWkgd3JvdGU6Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDIvMjQvMjMgNDowMyBQTSwg
SGVtaW5nIFpoYW8gd3JvdGU6Cj4+Pj4+IE9uIDIvMjQvMjMgMzo1MiBQTSwgSm9zZXBoIFFpIHdy
b3RlOgo+Pj4+Pj4KPj4+Pj4+Cj4+Pj4+PiBPbiAyLzI0LzIzIDM6NDggUE0sIEhlbWluZyBaaGFv
IHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToKPj4+Pj4+PiBPbiAyLzI0LzIzIDI6NTQgUE0sIEpvc2Vw
aCBRaSB3cm90ZToKPj4+Pj4+Pj4gSSBjYW4gcmVwcm9kdWNlIHRoaXMgaW4gbXkgbG9jYWwgVk0u
Cj4+Pj4+Pj4+IEkndmUgdHJhY2VkIG9jZnMyX2Rpc21vdW50X3ZvbHVtZSBhbmQgZm91bmQgdGhh
dCBpdCBoYXNuJ3QgYmVlbiBjYWxsZWQuCj4+Pj4+Pj4+IFNvIEVCVVNZIGlzIHJldHVybmVkIGlu
IFZGUyBsYXllci4gSSBndWVzcyBzb21ldGhpbmcgd3Jvbmcgd2hlbiBkb2luZwo+Pj4+Pj4+PiBh
IGNvcHkgd2l0aCBsaW5rZWQgU1FFcyAobm9ybWFsIGNvcHkgc2VlbXMgbm8gcHJvYmxlbSkuCj4+
Pj4+Pj4+Cj4+Pj4+Pj4KPj4+Pj4+PiBJIGFtIGluY2xpbmVkIHRvIGFncmVlIHdpdGggeW91LiBJ
IGFsc28gdGVzdCBsaWJ1cmluZyBleGFtcGxlcyBhcHBzCj4+Pj4+Pj4gb24gZXh0NCBwYXJ0aXRp
b24sIGV2ZXJ5dGhpbmcgbG9va3MgZmluZS4KPj4+Pj4+Pgo+Pj4+Pj4+IEkgdXNlZCBiZWxvdyBi
cGZ0cmFjZSBtZXRob2QsIHRoZSByZXR2YWwgaXMgJzMnLgo+Pj4+Pj4+IMKgwqBicGZ0cmFjZSAt
ZSAna3I6bW50X2dldF9jb3VudHtwcmludGYoIiVkXG4iLCByZXR2YWwpO30nCj4+Pj4+Pj4KPj4+
Pj4+PiBJdCByZXNwb25kcyB0byBmbG93OiBwYXRoX3Vtb3VudCgpID0+IGRvX3Vtb3VudCA9PiBt
bnRfZ2V0X2NvdW50IChnZXRzICczJykKPj4+Pj4+Pgo+Pj4+Pj4gWWVzLCB0aGF0J3MgdGhlIHBs
YWNlIHJldHVybiBFQlVTWS4KPj4+Pj4+IFNvIHRoZSBwcm9ibGVtIHNlZW1zIHRvIGJlIGdldG1u
dC9wdXRtbnQgbm90IG1hdGNoIGluIHRoaXMgY2FzZS4KPj4+Pj4+Cj4+Pj4+Cj4+Pj4+IEkgZGlk
bid0IGZhbWlsaWFyIHdpdGggc2V0dGluZyB1cCBrZXJuZWwgYmktc2VhcmNoIGVudi4gSSB1c2Vk
IG9uZSBsYXN0IHllYXIKPj4+Pj4gb3BlblNVU0UgdHVtYmx3ZWVkICh3aXRoIGtlcm5lbCA1LjE2
LjIpLCB0aGlzIHVtb3VudCBpc3N1ZSBkb2Vzbid0IGV4aXN0Lgo+Pj4+PiBTbyB0aGVyZSBpcyBh
IHBvc3NpYmlsaXR5IG9uZSBvY2ZzMiBjb21taXQgaW50cm9kdWNlZCB0aGlzIGlzc3VlLgo+Pj4+
IFlvdSBjYW4gY2hlY2tvdXQgZWFjaCBtYWlsaW5lIHZlcnNpb24gbGlrZSBMaW51eCA2LjAsIDYu
MSwgLi4uIGFuZCB0cnkKPj4+PiB0byBjaGVjayBpZiBpdCBjYW4gYmUgcmVwcm9kdWNlZC4KPj4+
Cj4+PiBJIGRyb3AgdGhpcyBtZXRob2QsIG15IG1hY2hpbmUgY3B1IGlzIG9sZCwgY29tcGlsaW5n
IGtlcm5lbCB3aWxsIHRha2UgdG9vIG11Y2gKPj4+IHRpbWUuCj4+Pgo+Pj4+Cj4+Pj4gSSd2ZSB0
cmllZCB0cmFjZSBtbnRnZXQvbW50cHV0IHVzaW5nIHRoZSBmb2xsb3dpbmcgYnBmdHJhY2Ugc2Ny
aXB0LAo+Pj4+IGxpbmstY3Agb3V0cHV0IHNob3dzIGl0IG1pc3NlcyBhIGZwdXQuCj4+Pj4KPj4+
PiAjaW5jbHVkZSA8bGludXgvbW91bnQuaD4KPj4+PiAjaW5jbHVkZSA8bGludXgvc3RyaW5nLmg+
Cj4+Pj4KPj4+PiBrcHJvYmU6bW50Z2V0Cj4+Pj4gewo+Pj4+IAkkbiA9ICgoc3RydWN0IHZmc21v
dW50ICopYXJnMCktPm1udF9zYi0+c190eXBlLT5uYW1lOwo+Pj4+Cj4+Pj4gCWlmICghc3RybmNt
cChzdHIoJG4pLCAib2NmczIiLCA1KSkgewo+Pj4+IAkJQFtjb21tXSArPSAxOwo+Pj4+Cj4+Pj4g
CQlwcmludGYoIiVzIiwga3N0YWNrKTsKPj4+PiAJfQo+Pj4+IH0KPj4+Pgo+Pj4+IGtwcm9iZTpt
bnRwdXQKPj4+PiB7Cj4+Pj4gCSRuID0gKChzdHJ1Y3QgdmZzbW91bnQgKilhcmcwKS0+bW50X3Ni
LT5zX3R5cGUtPm5hbWU7Cj4+Pj4KPj4+PiAJaWYgKCFzdHJuY21wKHN0cigkbiksICJvY2ZzMiIs
IDUpKSB7Cj4+Pj4gCQlAW2NvbW1dICs9MTsKPj4+Pgo+Pj4+IAkJcHJpbnRmKCIlcyIsIGtzdGFj
ayk7Cj4+Pj4gCX0KPj4+PiB9Cj4+Pj4KPj4+Cj4+PiBJIHVzZWQgYmVsb3cgc2NyaXB0IHRvIGZp
bmQgc291cmNlIGZpbGUgaG9sZCBmX2NvdW50Lgo+Pj4KPj4+IGUuZzogLi9saW5rLWNwIC9tbnQv
YWEuYmluIC9tbnQvMQo+Pj4gVGhlIHNjcmlwdCB3aWxsIHNob3cgZl9jb3VudCBvZiBhYS5iaW4g
b25seSBkb3duIHRvIDMuIFdlIGV4cGVjdCBmX2NvdW50IHZhbHVlCj4+PiBkb3duIHRvIDEgdGhl
biB0cmlnZ2VyIG1udHB1dC4KPj4+Cj4+PiBgYGAKPj4+ICNpbmNsdWRlIDxsaW51eC9tb3VudC5o
Pgo+Pj4gI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5oPgo+Pj4gI2luY2x1ZGUgPGxpbnV4L2RjYWNo
ZS5oPgo+Pj4gI2luY2x1ZGUgPGxpbnV4L3BhdGguaD4KPj4+ICNpbmNsdWRlIDxsaW51eC9mc19z
dHJ1Y3QuaD4KPj4+ICNpbmNsdWRlIDxsaW51eC9mcy5oPgo+Pj4gI2luY2x1ZGUgPGxpbnV4L2lv
X3VyaW5nX3R5cGVzLmg+Cj4+Pgo+Pj4gazpmcHV0Cj4+PiB7Cj4+PiAJJGYgPSAoc3RydWN0IGZp
bGUgKilhcmcwOwo+Pj4gCSRjbnQgPSAkZi0+Zl9jb3VudDsKPj4+Cj4+PiAJaWYgKCFzdHJuY21w
KGNvbW0sICJsaW5rLWNwIiwgNykpIHsKPj4+IAkJcHJpbnRmKCJcbiBbbGluay1jcF0gZnB1dCgp
IG5hbWU6JXMgZl9jb3VudDolbGxkIDwlcD4gbW50OiVwXG4iLAo+Pj4gCQkJICAgCXN0cigkZi0+
Zl9wYXRoLmRlbnRyeS0+ZF9uYW1lLm5hbWUpLCAkY250LmNvdW50ZXIsIGtwdHIoJGYpLCBrcHRy
KCRmLT5mX3BhdGgubW50KSk7Cj4+PiAJCS8vcHJpbnRmKCIlc1xuIiwga3N0YWNrKTsKPj4+IAl9
Cj4+PiB9Cj4+PiBgYGAKPj4+Cj4+Cj4+IEkgYW0gbm90IGZhbWlsaWFyIHdpdGggaW9fdXJpbmcs
IGFuZCBjYW4ndCBtYWtlIHN1cmUgbXkgYW5hbHlzaXMgaXMgY29ycmVjdC4KPj4gQmVjYXVzZSBv
Y2ZzMl9maWxlX3JlYWRfaXRlcigpIHJldHVybnMgLUVPUE5PVFNVUFAsIHRoZW4gZmFpbHMKPj4g
aW9faXRlcl9kb19yZWFkKCksIHRoZSBpb19pc3N1ZV9zcWUgbWlzc2luZyBmcHV0KCkgd2hpY2gg
Y2F1c2VzIHVtb3VudCBmYWlsdXJlCj4+IGlzc3VlLgo+Pgo+PiBpb19pc3N1ZV9zcWUKPj4gICsg
aW9fYXNzaWduX2ZpbGUgLy9jYWxsIGZnZXQoKSwgYnV0IG1pc3NpbmcgZnB1dCgpCj4+ICArIGRl
Zi0+aXNzdWUoKQo+PiAgfCAgaW9fcmVhZAo+PiAgfCAgICsgaW9faXRlcl9kb19yZWFkCj4+ICB8
ICAgfCAgb2NmczJfZmlsZV9yZWFkX2l0ZXIKPj4gIHwgICB8ICAgcmV0dXJuOiAtRU9QTk9UU1VQ
UCAvL2lvY2ItPmtpX2ZsYWdzOjB4OAo+PiAgfCAgICsga2lvY2JfZG9uZQo+PiAgfCAgICAgICsg
aW9fcndfZG9uZSgmcnctPmtpb2NiLCByZXQpCj4+ICB8ICAgICAgfCAgIGtpb2NiLT5raV9jb21w
bGV0ZShraW9jYiwgcmV0KQo+PiAgfCAgICAgIHwgICAgaW9fY29tcGxldGVfcncKPj4gIHwgICAg
ICB8ICAgICAgX19pb19jb21wbGV0ZV9yd19jb21tb24KPj4gIHwgICAgICB8ICAgICAgICsgcmVx
LT5mbGFncyB8PSBSRVFfRl9SRUlTU1VFIHwgUkVRX0ZfUEFSVElBTF9JTzsKPj4gIHwgICAgICB8
ICAgICAgICsgcmV0dXJuIHRydWUKPj4gIHwgICAgICArIGlvX3JlcV90YXNrX3F1ZXVlX3JlaXNz
dWUvaW9fcmVxX3Rhc2tfcXVldWVfZmFpbAo+PiAgfCAgICAgICsgcmV0dXJuIElPVV9JU1NVRV9T
S0lQX0NPTVBMRVRFOwo+PiAgfAo+PiAgKyByZXR1cm4gMDsKPj4KPiBTZWVtcyBub3QgdGhlIGNh
c2UuCj4gUmVpc3N1ZSB3aWxsIHF1ZXVlIHdvcmsgdG8gaW93cSwgYW5kIGZwdXQgd2lsbCBmaW5h
bGx5IGdldCBjYWxsZWQgaW4KPiBpb193cV9mcmVlX3dvcmsoKSBvbmNlIHdvcmsgaXMgaGFuZGxl
ZC4KPiAKSSd2ZSBzZW50IGEgZml4IHRvIGlvX3VyaW5nLCBwbGVhc2UgcmVmZXI6Cmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2lvLXVyaW5nLzE2Nzc1ODkxNzE3OC4xMjgyNi4xMzQ4MTkzNDM2MjE2
Njc5Mzk1Ny5iNC10eUBrZXJuZWwuZGsvVC8jdAoKVGhhbmtzLApKb3NlcGgKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcg
bGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21h
aWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
