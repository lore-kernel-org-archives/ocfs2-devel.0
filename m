Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0D9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Jun 2022 06:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BIk7cm31zOfoO0OO0M/ObwLfkwaQogEqC73X6PKFWP8=;
 b=f8zgOG5+ZubMlAc5ARxI/sJPkEXCwRIHFFceLQR0Cp2btHTGQFsQjeTkFpOrpzQSXoGeWDGjPJ5f
   625R+WR9SumP8NAxFm4hqypMB1yMjzquoaTiwA/kf6JbT3VU1/1MjNT+UrdRIHAZuFoSgBbXpOnG
   Hzu4m8LtSgVAPnfcvkMnGf4tMInHdMFroqCJx0sKWCP7FxRZMhmbKKTgDkh00u0HyidS8ZuGMQh/
   c4lrAD7osqawDUebiZp/ZBgvB4eSYrcn1FPBcoWuO44kORk/3aaSD6qPfighmgfrmtY7w8logwyZ
   BgHy65SEJhQLNXoDYsMTpLwlsMAvJmXqNrvKWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BIk7cm31zOfoO0OO0M/ObwLfkwaQogEqC73X6PKFWP8=;
 b=ph+cX6tYUNMUTEz5LmCJmXyJwWyseX2Fc2HEhbRERm2vk8FgGdiVE4plhgDZgDZf0BHRmY/pxiiP
   NDm88I2MRyM352tCfSzFJgqoBuqJCkgPuVJ4xRx7mxwKTV+Th8s7g5Lt3bEc+79+9BG6W+WhOwAZ
   Z3pS8bN0HGljDlp9XJu7r1fe9arQoy+epY2f+JYJuov40sCy14W4NV8LYoohCX4CsaP+OnCsQ6q3
   Rska5eaZQ+nlmCPV4koJX0ZVEQ7YEA1g8HVTzOK9Dzz3AbK4DIGaGI7HY7O6GbQOc4CslbE5+0qj
   nv0rlQPExvzfqY2bRmJm0iX6IDIH+ovpS+kE7g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDG00K7JF1CC210@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Jun 2022 06:22:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gkW04v3sGkr5ApTlVkWWuXpZNPsiLsJzD94sVEikhjA=;
 b=I/1YJj29KKtSRVZoChKRTUnzrN7cNL2o3Kn6pPe7eAQgoHJ87Em+E/3KEMPyeFInvfNi
 ssUAdsOOzWOBkWW1dTIvLUpGk7h5/7PzjpBry/VQW4N0biV0czOXhNQCsyRg5QgCRocA
 fdNdmb0C45JNv8W55pJLVRVgLyLJPjrjU6eYfDGN1OB1oJxjJjv4B/9oJ0PUukg/k83L
 BUU1rMbJ+rYGOntvIASk29neCIUQJENEH3pjmT/aabi/vvw9NWc68KKREYnTVUGCxno7
 OSuF4HrYnRfphk4AjACUdiUrfdPlX3oUYlFYp9I6dmS8/dpy1Rh2GbPDivlaDQd0TnzU 6A==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fh+Bz5TVBP3qapLBo6WoTfU3BvIsJm4QOHk5epMYxA5bq39/aVEsB797PUvoophsrKKIgTiOEqSJ0IPe2Y9pn9UIgectSCm6hI3HtHfOxODsTY7hhUHBF0GOdm/Gw/y0wwDkjHt+l1gCB7sehvhRNL5XDOfvZrU33Q6tL905Bp8OEdsKG+t3rafOYzCCn/RMPkqouz6QZfvEBlIx1xskjoe2vNHgsgIrQnA7+MQrWZZ4YJ/s1CnFqmNgvasvQikUbyPRdcmSjo0UNLNPP4CWHMzJnKpzEjHDcnWjg7TNkfRo+YPmAeEBknu0yA61+tJEAoZ7HeBi68JjLwZRWxjKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkW04v3sGkr5ApTlVkWWuXpZNPsiLsJzD94sVEikhjA=;
 b=f3pi9KDZR9exoYqGQGzaPtki5bUUGEU1QFlpK/bW7UuVOL2+HDHziPfaW3i9i8jzyYZML1/9cNM4TfAT9Pt/KMyOv0qh4Bt5TAPxPq7UieuJtHs3XALkPcZLLMuwz8galCVbDc+jgxzGMOOHVTuLW3WABZmwCw6yv4voAhLkjk3o4dIiwJEtDtNbTkPlOE1qQryzU2m+caEJhkU1YZsYN9xjjSwjW/Ce5hEszSuImAXwf/eB+fnfycWWEf8D38XjibGos7yTvCSnh97uuyFXPtBLxRrxglu7EWmn2lbU7M6fRNwSt7e/jXe4kWdIVPuDUeddSA+PLw2bFqUSbDwcvA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkW04v3sGkr5ApTlVkWWuXpZNPsiLsJzD94sVEikhjA=;
 b=h2ZZLjSpFdeklq5/isULTNx5EPcVqMBWdV8LTC6JHn3BNkF7r8ZJhNCYwf8ul55dZvcyNw3zkYkBV8IrReZKT2jL21R3DIT9Tu0saraF+0k8pUuX8T8X3J58HnNu5f1xx299Ka8zeEim1OyGsyjhp2f85exRpeO/uhh9tl2r2qQ=
Message-id: <15f5f645-2e88-22fc-5b3c-1dc8cbe395e9@oracle.com>
Date: Mon, 13 Jun 2022 23:22:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
 <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
In-reply-to: <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 06:22:10.2131 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-14_02:2022-06-13, 2022-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140024
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-ClientProxiedBy: SJ0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:a03:331::27) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1447a99-a30b-4cbd-a672-08da4dce3695
X-MS-TrafficTypeDiagnostic: CH0PR10MB5195:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 iWz2CzeFSZfkm0xiOsElWdn8KH4J6/7NHl0Oza/QdV9oBP10074jiUGsvcDg6EtbIqB4GSmhOfV7DJW6OGrIHgkCIPH+tHuyw54Ruxnlf2efeifNgcZhAPKzSuag8R2xUGIx4UiViBRCa6ecHRK+lpXvjRewH2X1kC/G7N3VoBvYDX4VCFb9ZxKbk4lphJrzECi1Gck4C736aPuOgiZCCb9jrOiZfK1ggWdXeKbyEmdsaBzp/fVF7WNE6BwJnpzR3T/1r3TWzghR6JJ5b1dGpfqJInzCwr8Sl5xCPvYqQwXChblNCFIfHxTMt0qYd68H6Wn9jHEUkRXWO6tOe3NWyd2kbeRZ83tt9fIijGxZtqbQSzgswwbWl+Ip8yM/VIzHuHD/QMynlBcbjXgoi7yGAf2Bn2/WIcwNBP0Q152DOAS7j8y6J5fGSN8IC+WrzNquIS7heUQGd9q6eB7IlOeqgqe8/Yniu0z99/QEQhFF1PuD2dV1a/o4O23pDqnhSZ+a1bnPoP7CZT4QRC0tCj91LguSie6mAw7ZnuBIdx4IdNnVuoEvguAW2z6qL+V9VRzTOUggPZFVaWzEmESiB2AVJLnoaVgGogFhQdYuTBHYBzQ=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b1447a99-a30b-4cbd-a672-08da4dce3695
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 iAE7OIqcKAwtHFcp6H6N0/r+nLM8hAT0M4V5sCf0pMAkCbJeKWRPF/0vfgXgLyw513v/gxfob0uFnzOFz/6bqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5195
X-Proofpoint-ORIG-GUID: G026YJ-jYwCRhzhvKa8v-WU4w_2w8bRm
X-Proofpoint-GUID: G026YJ-jYwCRhzhvKa8v-WU4w_2w8bRm
Reporting-Meta:
 AAEUBPlnBJI/NZo+7LyibFzTXqsuzzyhmYZ/uqDWicHTvmkpcMkafd6OPpZDeVId
 qW6ttYL8k01B7Sf/xvXCoK4mSTJIhHMTvULIBRAVHfvpjQ9n5n5ojNSq9URecVti
 lwdocWhSzt5M5iNMxIvrWOtqmgC27Aa74C5ZTA1T8QVp0CML3nDLWjLIq+SIOEob
 u4+sKvlLmXfWTEBLJAXL8tBO2lsYhKUDvaP9/MGX8Mc1UFBXSdcpOEK07PfS/uR7
 pQfiHkDudFSclm0xP6zQ8/G9tZmGGxBo43My64/16fQtZBNf4oYuRZh3DKg4YWdn
 zn+zunLbfuxJzL31gvCn4aWBs0vPNrCCZ1olOuHI3yPdzDhcquu/T3e159HLJhRs
 wqYkdEDTL+ES91NpvdulIg8TsO2/4hQwudRttQqIZFzUrPcJdqSOsfONjg5NZDx4
 KcNYvuaR+dfk3yUUhumIPCLo7mTdjbs/h0aJOsOpwFYPuZM+WVsa6xf7roWcuQSR
 FFR+Sj+7MJSnFcAvYnFcFq9wdwFYzC0HhiZFeA0RFyjb

T24gNi8xMy8yMiA3OjU5IFBNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKCj4gT24gNi8x
My8yMiAyMzo0MywgSnVueGlhbyBCaSB3cm90ZToKPj4KPj4+IOWcqCAyMDIy5bm0NuaciDEz5pel
77yM5LiK5Y2IMTo0OO+8jGhlbWluZy56aGFvQHN1c2UuY29tIOWGmemBk++8mgo+Pj4KPj4+IO+7
v09uIDYvMTMvMjIgMTY6MjEsIEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4gT24gNi8xMy8yMiAzOjU5
IFBNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4+Pj4gT24gNi8xMi8yMiAyMjoxNiwg
Sm9zZXBoIFFpIHdyb3RlOgo+Pj4+Pj4gSGksCj4+Pj4+Pgo+Pj4+Pj4gV2h5IGNhbid0IHVzZSBs
b2NhbCBtb3VudD8gSSBkb24ndCByZW1lbWJlciBpZiB3ZSBkaXNjdXNzIGFib3V0IAo+Pj4+Pj4g
dGhpcy4KPj4+Pj4+Cj4+Pj4+IFNvcnJ5LCBJIGNhbid0IGZvbGxvdyB5b3VyIHF1ZXN0aW9uLgo+
Pj4+PiBEbyB5b3UgbWVhbiB3aHkgcmV2ZXJ0IGNvbW1pdCA5MTJmNjU1ZDc4YzU/Cj4+Pj4+Cj4+
Pj4+IG9yIHlvdSBhcmUgaW50ZXJlc3Qgd2l0aCB0aGUgZmVhdHVyZSBsb2NhbCBtb3VudD8KPj4+
Pj4gdGhlIGxvY2FsIG1vdW50IGlzIGNyZWF0ZWQgYnkgbWtmcy5vY2ZzMiwgd2hpY2ggY2FuJ3Qg
YmUgY29udmVydGVkIAo+Pj4+PiB0byBjbHVzdGVyZWQuCj4+Pj4+IHNlZSBta2ZzLm9jZnMyKDgp
ICctTScgb3B0aW9uLgo+Pj4+Pgo+Pj4+IFdoYXQgSnVueGlhbydzIG1haW4gY29uY2VybiBpcyBk
YXRhIGNvcnJ1cHRpb24sIHNvIEknbSBhZnJhaWQgd2UgCj4+Pj4gaGF2ZSB0bwo+Pj4+IGludHJv
ZHVjZSBhbiBvbmRpc2sgZmVhdHVyZSBiaXQgdG8gcHJldmVudCBtaXhlZCBub2NsdXN0ZXIgYW5k
IGNsdXN0ZXIKPj4+PiBtb3VudCwgc2ltaWxhciB0byBsb2NhbCBtb3VudC4KPj4+Cj4+PiB0aGlz
IHBhdGNoIGRlZmluZWQgdHdvIG5ldyB2YXJpYW50cy9mbGFnczoKPj4+ICNkZWZpbmUgT0NGUzJf
U0xPVE1BUF9DTFVTVEVSwqDCoCAxCj4+PiAjZGVmaW5lIE9DRlMyX1NMT1RNQVBfTk9DTFVTVEVS
IDIKPj4+Cj4+PiAoSSBleHBlY3QpIFVuZGVyIE9DRlMyX1NMT1RNQVBfQ0xVU1RFUiwgZm9yIGNs
dXN0ZXJlZCBtb3VudCBtb2RlIGFuZCAKPj4+IGZvciBjb21wYXRpYmlsaXR5LAo+Pj4gYW55dGhp
bmcgZG9lc24ndCBuZWVkIHRvIGJlIGNoYW5nZWQuCj4+Pgo+Pj4gT0NGUzJfU0xPVE1BUF9OT0NM
VVNURVIgd2lsbCBpbnRyb2R1Y2UgYSBuZXcgdmFsdWUgZm9yIHNsb3RtYXAgYXJlYS4KPj4+IHRo
aXMgbmV3IHZhbHVlIG9ubHkgdGFrZSBlZmZlY3QgYWZ0ZXIgYSBzdWNjZXNzZnVsbHkgbm9jbHVz
dGVyIG1vdW50Lgo+Pj4gKHBscyBmaXggbWUpLCBleGlzdGVkIGtlcm5lbC91c2VyIHNwYWNlIGNv
ZGUgZG9uJ3QgZG8gYW55IHNwZWNpYWwgCj4+PiBoYW5kbGUgZm9yCj4+PiBub2NsdXN0ZXJlZCBt
b3VudCBtb2RlIGluIHNsb3RtYXAgYXJlYS4gU28gdGhlIG5ldyB2YWx1ZSBpcyBhbHNvIAo+Pj4g
Y29tcGF0aWJpbGl0eS4KPj4+Cj4+PiBBbmQgdGhlIHBhdGNoIGNhbiBhbHNvIHByZXZlbnQgbWl4
ZWQgbW91bnQsIHRoZSByZWxhdGVkIGNvZGUgaXMgaW4gCj4+PiBvY2ZzMl9maW5kX3Nsb3QoKS4K
Pj4+IGNvZGUgbG9naWM6Cj4+PiAtIG5vY2x1c3RlcmVkIG1vdW50IGNvbmRpdGlvbjogc2xvdG1h
cCBpcyBlbXB0eSBvciBhbHJlYWR5IG1vdW50ZWQgCj4+PiB3aXRoIG5vY2x1c3RlcmVkCj4+PiAt
IGNsdXN0ZXJlZCBtb3VudCBjb25kaXRpb246IHNsb3RtYXAgaXMgZW1wdHkgb3IgYWxyZWFkeSBt
b3VudGVkIAo+Pj4gd2l0aCBjbHVzdGVyZWQuCj4+PiAtIGFsbCBvdGhlciBjb25kaXRpb25zIHdp
bGwgYmUgZGVuaWVkLgo+PiBGaW5kaW5nIHNsb3QgcmVxdWlyZWQgcmVhZGluZyBzbG90IG1hcCBh
bmQgdGhlbsKgIHVwZGF0ZSBzbG90IG1hcC4gSXQgCj4+IGlzIG5vdCBhdG9taWMgLCB5b3UgY2Fu
4oCZdCBwcmV2ZW50IG1peGVkIG1vdW50IHVudGlsIHlvdSBoYXZlIGEgCj4+IGNsdXN0ZXIgbG9j
ay4KPgo+IENvdWxkIEkgc2F5IHlvdXIgbWVudGlvbmVkIHVzZSBjYXNlIGlzIGludmFsaWQuCj4g
SSBiZWxpZXZlIGFsbCAoeWVzLCAqYWxsKikgdGhlIG9jZnMyIHVzZXJzIHVzZSB0aGlzIGZzIHVu
ZGVyIGNsdXN0ZXIgCj4gbW9kZSBpbgo+IHRoZWlyIHByb2R1Y3QgZW52Lgo+IFRoZSBub2NsdXN0
ZXIgbW91bnQgaXMgb25seSB1c2VkIG9uIG1haW50YWluZWQgZW52IChlZy4gYmFja3VwLCBmc2Nr
KS4KPgo+IFdlIG9ubHkgY29uY2VybiB0d28gd2F5czoKPiAxLiB1c2VyIGZvcmdldHMgdG8gdW5t
b3VudCAoZWcgY3Jhc2gpIGJlZm9yZSB1c2luZyBhbm90aGVyIG1vdW50IG1vZGUuCj4gMi4gd2hl
biBvY2ZzMiB2b2x1bWUgaXMgd29ya2luZywgd2hpY2ggc2hvdWxkIGRlbnkgdm9sdW1lIGlzIG1v
dW50ZWQgCj4gYnkgYW5vdGhlciBtb2RlLgo+IMKgwqAgdGhpcyBtYXkgaGFwcGVuZWQgdXNlciBt
aXN0YWtlbmx5IHJ1bnMgY29tbWFuZCBvciBzY3JpcHQuCj4KPiBCYXNlIG9uIGFib3ZlIDEgJiAy
LCBKdW54aWFvIGFib3ZlIG1lbnRpb25lZCB1c2UgY2FzZSBvbmx5IGhhcHBlbnMgb24gCj4gb25l
IHNjZW5hcmlvOgo+IHRoZSB2b2x1bWUgZG9lc24ndCBiZSBtb3VudGVkIGJ5IGFueSBub2RlLCB0
aGVuIHVzZXIgbWlzdGFrZW5seSBtb3VudHMgCj4gdm9sdW1lCj4gd2l0aCBbbm9dY2x1c3RlciBt
b2RlIGF0IHNhbWUgdGltZS4gSSBiZWxpZXZlIHRoaXMgdXNlIGNhc2UgaXMgCj4gaW52YWxpZC4g
QW5kIEkgZ3Vlc3MKPiBnZnMyIG1heSBhbHNvIGhhcyB0aGUgc2FtZSBpc3N1ZS4KCllvdSBtaXNz
ZWQgdGhlIHBvaW50LCBpIG5ldmVyIHNhaWQgdGhhdCdzIHRoZSB1c2VyIGNhc2UuIFRoZSBwb2lu
dCBpcyAKd2l0aCB5b3VyIGZlYXR1cmUgb2NmczIgY291bGQgYmUgY29ycnVwdGVkIGR1ZSB0byBt
aXN0YWtlIGRvbmUgYnkgCmN1c3RvbWVyLCB0aGlua2luZyBhYm91dCB3aHkgZnNjay5vY2ZzMi9t
a2ZzLm9jZnMyIGNoZWNrIHRoYXQgYmVmb3JlIApjaGFuZ2luZyBhbnl0aGluZy4KCllvdSdkIGJl
dHRlciBtYWtlIHN1cmUgZ2ZzMiBoYWQgdGhhdCBpc3N1ZSwgaWYgc28sIGkgdGhpbmsgeW91IHNo
b3VsZCAKcmFpc2UgYSBidWcgdG8gdGhlbS4KClRoYW5rcywKCkp1bnhpYW8uCgo+IFdpdGggdGhp
cyBwYXRjaCwgb2NmczIgaGFzIG1vcmUgc2FuaXR5IGNoZWNrIGFiaWxpdHkgdGhhbiBvdGhlciBm
cywgCj4gZWc6IHhmcywgZXh0NC4KPiBTVVNFIEhBIHN0YWNrIHdpdGggY29yb3N5bmMrcGFjZW1h
a2VyIGFsc28gc3VwcG9ydHMgcnVubmluZyB4ZnMvZXh0NCAKPiB3aXRoIEEvUCBtb2RlLgo+IFRo
ZSB4ZnMvZXh0NCBuZXZlciBoYXZlIGRldGVjdGluZyBtb3VudCBzdGF0dXMgY29kZSwgSnVueGlh
byBtZW50aW9uZWQgCj4gbWl4ZWQgbW91bnQKPiBjYW4gYWxzbyBoYXBwZW5zIG9uIHRoZXNlIGZz
LiBIb3cgZG8geGZzL2V4dDQvSEEgbWFpbnRhaW5lcnMgaGFuZGxlIAo+IGl0PyBVbmRlciB0aGVz
ZQo+IGZzIG1vdW50aW5nIGJlaGF2aW9yLCB0aGVzZSBmaWVsZHMgbWFpbnRhaW5lcnMgYWxzbyB0
cmVhdCB0aGUgbWl4ZWQgCj4gbW91bnQgYXMKPiBpbnZhbGlkIHVzZSBjYXNlIGFuZCBpZ25vcmUg
aGFuZGxlIGl0Lgo+Cj4gL0hlbWluZwo+Cj4+Pgo+Pj4+IEFub3RoZXIgc2NlbmFyaW8gaXMgam91
cm5hbCByZXBsYXkgYWZ0ZXIgY3Jhc2guCj4+Pgo+Pj4gdGhpcyBwYXRjaCBzZXQgYSBydWxlOgo+
Pj4gSWYgbGFzdCBtb3VudCBkaWRuJ3QgZG8gdW1vdW50LCAoZWc6IGNyYXNoIGhhcHBlbmVkKSwg
dGhlIG5leHQgbW91bnQgCj4+PiBNVVNUIGJlIHNhbWUgbW91bnQgdHlwZS4KPj4+IChwbGVhc2Ug
YWxzbyBjaGVjayBhYm92ZSBsaW5lcyBvZiAnY29kZSBsb2dpYycuKQo+Pj4KPj4+IEluIG15IHZp
ZXcsIHRoaXMgcnVsZSBpcyBlbm91Z2ggdG8gaGFuZGxlIGNyYXNoIHNjZW5hcmlvLgo+Pj4gU28g
bXkgcGF0Y2ggc2hvdWxkIGJlIHBvbGlzaGVkIGluIHNvbWV3aGVyZSwgYnV0IGl0IGlzIHdvcmth
YmxlLgo+Pj4KPj4+IFRoYW5rcywKPj4+IEhlbWluZwo+CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczIt
ZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL29jZnMyLWRldmVs
