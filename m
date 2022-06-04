Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6E9C43334
	for <ocfs2-devel@archiver.kernel.org>; Sat,  4 Jun 2022 22:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FNGGIkPg0aghemy8nSWoaZ9r9Du3xyL+lJJXNvrXtOU=;
 b=yBKownBvxoCEUGggofnIGBc69wtKTTfu6iqah79HdR+KhEeoP3zjWHWSvNt6TM3E3oDM06x33fvL
   czSGoMmCjQ5V5q7+ZA18G10nSDLrPyd0SADKWdZnMWjntifHqWgd5UGVIUj2UEqUI4KVHcHEosYK
   t5fdvAkis0JpTX3lGkQVhZPwOLzIeUBGD2q235B7vIQUfhfHbXWCECso0IJ52wSMs9Bj/2we8GHN
   R8b8INJ8YZxwtB0DqKaHqmOcxdCnf/Z1zoZ2ViHuychIDAaGWfaddqb5fCtfcFiFjjYpsI2MvPk3
   +hTy1lb8lJ+glq5Fm3sDqobacmxsfeS4sfE87A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FNGGIkPg0aghemy8nSWoaZ9r9Du3xyL+lJJXNvrXtOU=;
 b=VzmJLAe45kN44ekK++oJCap6bRIYmSiJu/oKC7Ft1nLj0ySEBxa+T2ti3sTh6MfTVQvy48BmkuYf
   trRiWcRU6t2ceNPC34GrRyaXw7o0d6bN0KqPVfE9pKA9FYYa7CRwD7OGNneO34tR3J2qq2naRZDI
   9RhT9Wg+tvZAMAmiThLw9tfHctJ8vtnnY8xSmqnHCyOTX/TOp/vl8st9JBA7xFn6ndjTU2N4TUNT
   wwOSnXuLq3usih3Y17P6agMBeTrNHVbwewRp4W3lCg0OUfE6mLWXeU4hrLj5JbRQpECxmP9eboJU
   8gtrHQaMjfrlMnkrWeSAbX928+AqK4bq8vwS6w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ00CQQ51I3560@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 04 Jun 2022 22:27:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wRU76Fhwh/ZweCxs3wbn+8FiXC7RdiPQa95c/g4+HC0=;
 b=hNOgBYxG/SfK5lOc0n3Yy6jIzhL0NNbaUPAl7l8a6NLQAoVqnWySSUJ2Cflw324539Sb
 Pj5e3DhAGtLy44FKlm2wtobZgJf1QPhUetHFJD8qhFYiZp7kk+gYACSlfOWq8LQ2Lt+n
 ZmTrbjHnit9nkZn6K+lRMX4k/THrYRhYNEneDMrqHaP7QxHmrtKcD+nYk5eVsTnis1Dx
 h1ahaWRSz1JAfWSjcVRBVcXVgEyuLX6JUe7tnBdV3KuYNWW++QWCZUNDSmKNxXrWUoR1
 TJ/8MlZcwRfTcP11/uKpZVCm+V2q5MTiJrBfeSXo6M/d85l3EfohVM4GG4qnUvXokz9Q sg==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOccHgEVQKQQzqz5MDZhjnY0E6sI91hJaFhdbKu6HgtfhWV8fib0JZrv7xiJUu1lbcQ5aWqILKIV0XZWUmC1MKjq7jz6fjQxeZE+8pjKcwt64Ksc1bgfJth0I0IjJXqpg7ktDtR2TgZbnvDfTxpwXOIV+9SYKPaTEIghwTgmQBiPAvSadgiI/CJZ9YisyPJT570J1XMt62y8fM5FHn+k2piVpIus5oayKDyfSOq0S43xCuDOOr04kyyJpQn2B0j97blq1Dc8XtRBeIYTKPpx5+MzUJb+j7dn8uly3RWoHg8McButW7R9IL5PJuuTidBV3COejQC8V75EnJyozzCcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRU76Fhwh/ZweCxs3wbn+8FiXC7RdiPQa95c/g4+HC0=;
 b=Vyf0abnfrQ/qYTfp3FwdEB8gj1nB7xVMHqx3aQhL9QvJQorFQI4WQfUViiRRR7w+YfQOsYMYm8vofaKeUiIJzkfWZjligD+Qsdcok0oonPtGTnz+nf/y5+Lhnf+qNep5nDUAYTZeg1jDIhdubo4CTtZv18RtX/Kb07L5rvG+YreSWGf6yUOS+g/5nbSfKO3lZeZPDZ/WzI54lTNfyNNERySNrz582wcusxnCQNlFKiyJjwjcjsU3i2D/TOCEvE0wEAzGT+jMyKyZDUgjfPm9dU4+miGA+p7XyEC9qdru9Z6WZiX/uMECg90Eutk1K9qbO02oNRP/MwjBaA4ox/EmMg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRU76Fhwh/ZweCxs3wbn+8FiXC7RdiPQa95c/g4+HC0=;
 b=j0vT6+oo3GkFYfpN5IHXJfd46OTqdi2tvJPV+AV2nSp9eSJ7pVR8xzsdue9PyILW9UqmyeJghUgBTqWjDQ4tGnaixV07/g4tEVq6rV6+nnQH/2QMggPl32IeztbjUmtgceo3cTbOEEYrb3At5qekUXrezsxEORpeTPNIwHo6L08=
Message-id: <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
Date: Sat, 4 Jun 2022 15:27:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
In-reply-to: <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 22:27:04.8018 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-04_06:2022-06-02, 2022-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206040099
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: BYAPR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:40::27) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9a9b3f8-d04e-4315-0d46-08da46795a1f
X-MS-TrafficTypeDiagnostic: BL0PR10MB3057:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 MHfANT8bjh7z6Z8aN8P08N+VLI73Q41kUoDxg5eds4XXyasrq6IA+t3yl9qL0kD4wBk3wRA3Aljl+tDQldfHE6ZVsOIMyDpVCe56hRCeN45sgKW1mVTTT3MLCXnRlC06oWGy6NsCsgtm+GxUiGaQK4gGF8PF4BvzeiW5bNhchjnxFZscmCIoGy45gPNnuzH9lVi+01TvYTSsEhjgXJwKhw3d1CRvbbaX5oooVZSAL2zH4RiAGyYxgm1/zPOIQchRrPVGyqSLM0SxPtxv1vCplLhYtmwB1qH4bVwuYYH0QAWteH6AkZaZJIfwO3X7u1xKHfGzhTmVqOpfZiTPZ67kpe0Wd/xZxzH4g2Wm1S8N2TQLz3leXdYolgWgCTnoyg/Tvsdq4rxcF+yg9jilrskgRnTO25V8RLoHVtR6HVVnYhoFmSLOfKI+EGnrTyqw7lD8PcgFmhj2UVOBoxDGrDTG1bV0RUbQoDR+EHFI88lzeHZ97AdF0BMmyfqtfj9x2FIipyeSkAgIKBBHIEqRihY+jFuekjpKcXVoyhFHndFmd2SBonvJpuK28ou/iZ5tCyZ6BoY7h9EDYFc3Gy8yrL9KIM4Oq4ZTvpHwArl3xs0dWa8=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 c9a9b3f8-d04e-4315-0d46-08da46795a1f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 L63cDgxIt5l2M9xe7VMIw6UcTgzUPqwU03y3Swxm5tUz2lg6fHcq97/L6VGwWVaJFA3SlAqdiV+UkcqhQnqOBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3057
X-Proofpoint-GUID: yT9yp7oz9MzGDWYtmiRQNmBaBA12t3vT
X-Proofpoint-ORIG-GUID: yT9yp7oz9MzGDWYtmiRQNmBaBA12t3vT
Reporting-Meta:
 AAFZIUhv0zxPDSCQRdWGd2qXrsITgFEnfJWX6o2V1xQ48eFjbxTioAo+gYMMH/CV
 SYze66U3yeBw/MwXdfkcZ/nG3OGnS2ZeRR3ouBhhiwlgcCG++BkspiQzYNdk3wzE
 xkCq/xULEDPmmRy61rGFx13UD7g1enAfoJYxhS51hlP3GlxnzK5LPqORjHcqcL5i
 wMaSMKKKxd8qVHp6oOLLG2+WBKx7vPFthtLqEW0LhYDsd8ZlU3rmMNMMWdVtlNmz
 khRTuTxxJi+9f2OiqMuFVhFdiRdJwHRrDR8YBGVy5wlcMJDeQWLNS/Yd8uq7VBC2
 4gsx5dnCeCLAjFRNbmyS+EE3FrL2tkpyQaWpDGlWFPEA3r/Ce0I8qbuzP+YWixct
 Oo5j2BXHAaZ9CcM616IUJlIEeIJyLEAu/9TcIBJ0PRJ5zpbbtkCoLhxvK8Sl1Ucf
 VxsP5Czh7PuN0GIozyNvAjshN2Ybu2aOZhe+bZAc7rhtSc56C0BO2mA7kE24qvLU
 Nz3mFmUjQ7LODDzOrjrCKgtyEaoK+ICBHfS48i+jwGtI

Ck9uIDYvNC8yMiAzOjEwIEFNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPiBIZWxsbyBK
dW54aWFvLAo+Cj4gT24gNi80LzIyIDA2OjMxLCBKdW54aWFvIEJpIHZpYSBPY2ZzMi1kZXZlbCB3
cm90ZToKPj4gV2hlbiB1bmxpbmsgYSBkbG1mcywgZmlyc3QgaXQgd2lsbCBpbnZva2UgZGxtZnNf
dW5saW5rKCksIGFuZCB0aGVuIAo+PiBpbnZva2UKPj4gZGxtZnNfZXZpY3RfaW5vZGUoKSwgdXNl
cl9kbG1fZGVzdHJveV9sb2NrKCkgaXMgaW52b2tlZCBpbiBib3RoIHBsYWNlcywKPj4gdGhlIHNl
Y29uZCBvbmUgZnJvbSBkbG1mc19ldmljdF9pbm9kZSgpIHdpbGwgZ2V0IEVCVVNZIGVycm9yIGJl
Y2F1c2UKPj4gVVNFUl9MT0NLX0lOX1RFQVJET1dOIGlzIGFscmVhZHkgc2V0IGluIGxvY2tyZXMu
IFRoaXMgZG9lc24ndCBhZmZlY3QKPj4gYW55IGZ1bmN0aW9uLCBqdXN0IHRoZSBlcnJvciBsb2cg
aXMgYW5vbnlpbmcuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEp1bnhpYW8gQmkgPGp1bnhpYW8uYmlA
b3JhY2xlLmNvbT4KPj4gLS0tCj4+IMKgIGZzL29jZnMyL2RsbWZzL2RsbWZzLmMgfCAxNCArKysr
KysrKysrKy0tLQo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMgYi9mcy9v
Y2ZzMi9kbG1mcy9kbG1mcy5jCj4+IGluZGV4IGUzNjA1NDNhZDdlNy4uYTEyMDYxMGRmZjdlIDEw
MDY0NAo+PiAtLS0gYS9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jCj4+ICsrKyBiL2ZzL29jZnMyL2Rs
bWZzL2RsbWZzLmMKPj4gQEAgLTI5NiwxNyArMjk2LDI1IEBAIHN0YXRpYyB2b2lkIGRsbWZzX2V2
aWN0X2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCj4+IMKgIHsKPj4gwqDCoMKgwqDCoCBpbnQg
c3RhdHVzOwo+PiDCoMKgwqDCoMKgIHN0cnVjdCBkbG1mc19pbm9kZV9wcml2YXRlICppcDsKPj4g
K8KgwqDCoCBzdHJ1Y3QgdXNlcl9sb2NrX3JlcyAqbG9ja3JlczsKPj4gK8KgwqDCoCBpbnQgZGVz
dHJveWVkOwo+PiDCoCDCoMKgwqDCoMKgIGNsZWFyX2lub2RlKGlub2RlKTsKPj4gwqAgwqDCoMKg
wqDCoCBtbG9nKDAsICJpbm9kZSAlbHVcbiIsIGlub2RlLT5pX2lubyk7Cj4+IMKgIMKgwqDCoMKg
wqAgaXAgPSBETE1GU19JKGlub2RlKTsKPj4gK8KgwqDCoCBsb2NrcmVzID0gJmlwLT5pcF9sb2Nr
cmVzOwo+PiDCoCDCoMKgwqDCoMKgIGlmIChTX0lTUkVHKGlub2RlLT5pX21vZGUpKSB7Cj4+IC3C
oMKgwqDCoMKgwqDCoCBzdGF0dXMgPSB1c2VyX2RsbV9kZXN0cm95X2xvY2soJmlwLT5pcF9sb2Nr
cmVzKTsKPj4gLcKgwqDCoMKgwqDCoMKgIGlmIChzdGF0dXMgPCAwKQo+PiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBtbG9nX2Vycm5vKHN0YXR1cyk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBzcGluX2xv
Y2soJmxvY2tyZXMtPmxfbG9jayk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBkZXN0cm95ZWQgPSAhIShs
b2NrcmVzLT5sX2ZsYWdzICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKTsKPj4gK8KgwqDCoMKgwqDC
oMKgIHNwaW5fdW5sb2NrKCZsb2NrcmVzLT5sX2xvY2spOwo+Cj4gVGhpcyBhcmVhIGNvZGUgZG9l
cyB0aGUgc2FtZSB3b3JrIGluIHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygpLiBXaHkgbm90IAo+IHRv
IGdpdmUgYW5vdGhlcgo+IGVycm5vIChlLmcgLUVBR0FJTikgZm9yIHVzZXJfZGxtX2Rlc3Ryb3lf
bG9jayB3aGVuIGxfZmxhZ3MgY29udGFpbnMgCj4gVVNFUl9MT0NLX0lOX1RFQVJET1dOLgo+IHRo
ZW4gY2hhbmdlICdpZiAoc3RhdHVzIDwgMCknIHRvICdpZiAoc3RhdHVzIDwgMCAmJiBzdGF0dXMg
IT0gLUVBR0FJTiknCgpJIGRvbid0IHRoaW5rIHdlIHNob3VsZCBkbyB0aGF0LiBJdCdzIHJlYXNv
bmFibGUgZm9yIAp1c2VyX2RsbV9kZXN0cm95X2xvY2soKSB0byByZXR1cm4gRUJVU1kgaW4gdGhh
dCBjYXNlLiBFQUdBSU4gaXMgZm9yIHRoZSAKY2FzZSwgeW91IGludm9rZSBpdCBzZWNvbmQgdGlt
ZSB5b3UgbWF5IHN1Y2NlZWQuIFRoYXQncyBub3QgdGhlIGNhc2UgaGVyZS4KClRoYW5rcywKCkp1
bnhpYW8uCgo+Cj4gVGhhbmtzLAo+IEhlbWluZwo+Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoIWRl
c3Ryb3llZCkgewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGF0dXMgPSB1c2VyX2RsbV9k
ZXN0cm95X2xvY2sobG9ja3Jlcyk7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChzdGF0
dXMgPCAwKQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1sb2dfZXJybm8oc3Rh
dHVzKTsKPj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlwdXQoaXAt
PmlwX3BhcmVudCk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIGNsZWFyX2ZpZWxkczsKPj4g
wqDCoMKgwqDCoCB9Cj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNv
bQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
