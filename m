Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C558C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 27 Mar 2022 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T1fU8IYpU742NgzqhoHKxQt4LwuECq8jxPVRGKMSDnI=;
 b=3Md1VBEe0BRbtbhJKu8WA2sqxMYB8+XA51QnRA419aQuyw37rRaCU46S2xrR3XWgoyrb74AWEq6j
   QF1WbI5MJujYyH/fNdxw7Gd0ZUmYNbi0njsqH56EAybzQ3/KcCGJ+EtK3Gs9D56cyYA5xWfmMKiI
   wbdFnwOxCvPvpxV1PnNw97PEqs/z5Qhgu1vhCprAWrYYRcIz+UqvsF7fPRGu7pQ7nXMYex00f2pr
   1h4VW82DOiqGzzQ1EYm6lZ2Rgop8tKFYFqDDL0k+uYNitg+lsy4Sw77PXo0/DAwGI3XWkFmqG2cx
   1bwOqHhYLROY3ET4ChZWTsaUdv8WWIZqbrqHqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T1fU8IYpU742NgzqhoHKxQt4LwuECq8jxPVRGKMSDnI=;
 b=b4S+OTq+GAX+xOsVsu4mchqyXYhesDx+4SIg9NyIr20IFxda8KnsKUvF6mqZzytJiB8WFBFrFWQr
   ayrWbRhMON4LyYNgmOdrdn74fzEzri5KPULTBZp6esI0q7+sxL1E+MvqYD7iMM+HhKBg8inCC30A
   jLivEvBAOUFo7IONKfVbjE0JOglUr6wCPgn29ixt9tgd96YS9PeuWpB/06I+dopaVsKM1/o1O+1G
   0V0sKNTwDrVOg5/ixJrSdEU5qe2wVuZtZFZrEDc7Li0jJy6lPQK0L8NUzSqvTORhF5476cVQ1879
   yUwerJp2m+jIilXU+jE9T3xEPckZYKhH+Fxgag==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9E00FP5XQA3O70@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 27 Mar 2022 16:56:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1648400178;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ywg2k21nt6ENT+bqXJDB+ZJoz1863n2x+pbeaTEumtQ=;
 b=F/7cm+D4WgdrW3y1fj0pQ29qCLv6YuFN7HpKCRFJz1Rzd+rVqk/eSVCnS/pzauQawSS500
 2vqlFKu5Fc+d34rdrPJ2LNbSdT5a4yJKJtl0cDPWAhDa/WOTmVqwrAHWRVLvNiCbxHJr8e
 jhSpknG5VR03B9UbWZV4iJQIGCYQ9Qw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuwujqnYwpkIHSBIcmX74XBm0zv58+xl7XATDCFKTw/NJdC4s/2t02yNb6eBLeXQg3LuZl8MeaQbPm89GRxAKptg6Hccq5pQTAeLgGp16x32pYnvjS7dH+jyEts0TpKkhyPBB8+avkF0Sl2IWIrdGQ1W1iSHSrNaAzrWm09FxcbLcjrLVqS85KrzqmTGuXO2avF3qNMCh0P7/nMssREcruzPUyyRYRn8YsSBW1Jfo4WkrjW3/KkVFwLbzcxdCDfB3bUejszC/VbnnbrFbZXZjTtrANj/jwLYjR6Ih0UTFtV2flIFs99TiproJU7I0uvcXRPqaKpDbh/77lRuGt1hvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=773lZ7wjSVtL6g/iXeeOEeYQdQBnGuZwK+2I5uEYlEk=;
 b=JYaW1ouodK6v7OEGaSYa9r2xZB9YpsFDvYLdJpf9oX9EiIlFRhvaHkIs082qtOO/KLhnPf5Sx4N8hN9RPgZFfUHNT1XJ+huZ5gMtoBn+bSrVVBhCN9H3S3YYtdY+KVJkJkhsFq+MkBVgQxy4e6ongqcgWGGotQB7N2HodnW8Y3zok8snjgHXybGIpslA5lXcTCHVzAR5OfrBsiKEkjkZPiPzdzTja5LSbuCkpQighDMzq9AGGMbgbzrJmr9+aCGmLWdcbwtCp0A9nZMcNwfeMiOyE/zIpRkjjInfeq57kMDFF5umK17/AmwcJGODMMl5KXDP3ZJaZEFyoliB12Uh3g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <95977aaa-2ba1-5eb9-8936-450852676e2b@suse.com>
Date: Mon, 28 Mar 2022 00:56:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220318150401.2411-1-heming.zhao@suse.com>
 <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
 <9efaf256-4f66-32ca-96ef-7b2617396c27@suse.com>
 <3fb78714-1e48-e72a-c8cf-52ca5723562b@linux.alibaba.com>
In-reply-to: <3fb78714-1e48-e72a-c8cf-52ca5723562b@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(31686004)(6666004)(26005)(316002)(8936002)(2906002)(36756003)(6486002)(2616005)(186003)(6506007)(53546011)(6512007)(38100700002)(31696002)(508600001)(86362001)(83380400001)(66556008)(8676002)(5660300002)(66476007)(66946007)(4326008)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2022 16:56:16.2933 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10299
 signatures=694973
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 clxscore=206 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=108 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203270105
Cc: vvidic@valentin-vidic.from.hr
Subject: Re: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after
 mounting when journal doesn't ready
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: SrCadzVNNfiZY6VB3SSKsw-1
X-ClientProxiedBy: HK2PR02CA0138.apcprd02.prod.outlook.com
 (2603:1096:202:16::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9432ce02-1237-47d0-4c4a-08da1012b514
X-MS-TrafficTypeDiagnostic: AM0PR04MB4995:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB4995EF9F6734E95CB494A986971C9@AM0PR04MB4995.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 u9LZ3GrZd6W72JCVPlYiUkS04/c+x8D9AcQp7mH6Ek7xGratyxS32aJV4WJzZP8GaMcK2jBgQeZuioYSpUl5nLpR1RV5dIT8UslfZrp0nmGAOp6nS7QKTFIYGsAg0JkQlOtgntCmvzVHm7aVa3KC8W4usj+vSL3RbXsu/FU0pXZvBcJBbf33dkidTHefAR1upuBCwMDYuoMWA2Y2Qm46WkuhuJfCi2QJuKdE9EUsyczne4Csb3b9h91mZIx4rL/N8yYm8Pac7PsZ4Ueb8ri1gWI9G2YyXcBMAxWkty/foWdM6szyjoQUEZlF257V5VI5RhyOyRZz8GfJSldXYnOs/qSxC/FD4GTMES09dg/ZZ+c4R62wz/0IoLOOBTSL/n1utYeiWuw2kn1FiyBjLuqUFj4q/0NvjnQedaxgwAyo6arAg9x1DkloCo++K5RU7TaOehsXPT9QrB2/aDqm2Fo67IsrDM3Qro2HhVzRRoQQv1EY6FItWxF/Lach32R2YOk8xckGKQsKSzdem+ZEgSfJ8cGnJMl+OXPvb7u+YSJ9AX0DSJIPMkAUjq/Sz1UvoO8LGLo/jX+gXq4PFJsT7CuketMinf4EMka+qVLh2Y2VI0e7tU/ZFS9+gS5w68JkcJjzpIy4tqiouLIdvPANPtT327y3qThfWBobpYpYj1VRJqkgPGlEQaENMTfdjUAIOe68dt5AKPvmEhnNme3cpR3/RZ8f+14VOX7LAhBbaOsCwbE=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?glr1m2Dh/snEbeHcIHsB4ceY0s+Vbxi7Nd5PqmqBfB+2CUcreCgdFSJJsswm?=
 =?us-ascii?Q?lFbKWbUYrLULrmKoYEKGivqFs38eOXMZtql2DG9Fduvop2kebvG5K6GnBFmP?=
 =?us-ascii?Q?dWdTdUhJcaItI0cxd7qgeRlUGtD7DaHCwNaAk6jUBgIgkAlK/Zh/5BiUbP+5?=
 =?us-ascii?Q?4sHTNJ3UPll8cHo3soKWRsSTSvtYyTQFaTrYoCNM9PB5H3SCGYozw9kypvmh?=
 =?us-ascii?Q?OvLYxLDTkuRT+P9JMRaj2Pa7uc3Gxgwq0XodGQUSAJoUTWRUDdy9NYbDMqly?=
 =?us-ascii?Q?NsLtkmaThRyfrrgsr6pXldk0FIjj/JkxF0zXPrQGfxRUEVGVz5oyrdk5+G/q?=
 =?us-ascii?Q?HWycHXfisG/ImsKHocHcgp2KjrYBBRcaqNYV8kDRNwBL0GtP1xYNaYlDn/sU?=
 =?us-ascii?Q?zsoQVIpajGJA2oCgkV/TA1WVz8uddpQbziaSqlHGW5aADwRORACgX0DWn688?=
 =?us-ascii?Q?IQYpQ78JQkJMMop18xWsBszk8qrConsMgK18SrPIYPC8bGlKXZkSpqElJROO?=
 =?us-ascii?Q?zE5wRDkHYZrdTuSpD0Tt6+3/YnI7LdIuuFem9MikbyyOY3itvuPVMCq5i6KI?=
 =?us-ascii?Q?20c87czMsl5DDZs37LZEat3YyYkh5yVTmOM5lRTJYLtnocSrUqz5gu8IGgZB?=
 =?us-ascii?Q?Hr+nqapH9gu5D/vRUzpW4ZVP/5WbZMFlnydH6L2ijwN3cbWEdSP6qlrsCS4k?=
 =?us-ascii?Q?NKyvypddbU9On5KMp3TJRskAxhr9Vlk2hf2R07HEudVxMUbwabgeMdOH2jTS?=
 =?us-ascii?Q?CZhTqqq1LdXXG0Ox1AlJgsH3FJ5nGnJGwGuCSzyu7SrT05NbH+ZJrOtCGa+N?=
 =?us-ascii?Q?Pk6SD+2Hz6Rkvl9awqWzFaxHx3qVQvii9icwDK5qMyre3wKHTQIZvA2J8UfM?=
 =?us-ascii?Q?R8mcHdHEslTP4ZXtUkvesrwvrjvH/LEkO3wTUDD74C7+Wl89upKNNMkbCatw?=
 =?us-ascii?Q?MasTG8ICXFWSctt4L1DToPvYsdUwhp/KLE0oYmc4kmhakSZHZLE3asMsMk9c?=
 =?us-ascii?Q?c1G9xY47FYNOa97qew2rS4YA4LFg/5uFNPJRPwkUPo1ruZ0k+Oxj6ntMwhvu?=
 =?us-ascii?Q?uWxVuU5dYw5EXUpOpS9a+uA92EHezVdtPk+f0jBR4ZC1LbA1/O2bzE8QTLz3?=
 =?us-ascii?Q?LVgCOowgJblM7gTZoW0jhms+gUupwmtpHZ/DF9pWLtlFJP7lh9KfeLvJ/00N?=
 =?us-ascii?Q?Sq+7snsGcgd095c+x18fvJt0ZxlCJecO94z4nkIYm6OlNuT/fLMLBesk7MkK?=
 =?us-ascii?Q?YugKS0u2EZ+bgOhvrYFMrAGgyErvqTraymyw0YQ9DvvzTIFgef9AmJGIM3ah?=
 =?us-ascii?Q?doBWv5EtCmX8rjRkHJbpizIbX6C+g0YAm3AnrpoM6qwYzDcrreVfPtl6xhh4?=
 =?us-ascii?Q?kihcE0RY167KJTNZNLSR6iAwuD8J1xfSZGpXxPoagwoO1L11GA+NasT/ukl8?=
 =?us-ascii?Q?h5q0rFoTSlJqosGgIqebuTOpX8HIyHxRpxeNKBGR+jR1+0o0k0yiYf+GUy1B?=
 =?us-ascii?Q?LdNazsThKE18iYBKEXbhcytG5MgbGI0VSPRVUJl9ekQ8iJsdgbFNL7fR/7cq?=
 =?us-ascii?Q?znBhCNLhmXL1fA+MtEgk8Fk3d7zVVDS4uvb1UC00/k+Yk8F9KC+VbdR5Oe9n?=
 =?us-ascii?Q?9c0k9Hwn8+MKCd008zgNsj1k7RmUUckfu+6Gks4Pzpy8JBlyYa08DdvqwYlI?=
 =?us-ascii?Q?EGMoAeLqvKLqpX1j8YaK9bx/ZlXVrrpIdyb047ewJ/4//n0GpPLD7athshVR?=
 =?us-ascii?Q?KzuEwh4SuA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 9432ce02-1237-47d0-4c4a-08da1012b514
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /WmyiRFGda+iXbFNdufUfsvN0rML1xQYfitPSORMo6RvNoKWbZjXzN4pNjbeW6gNGYpkmioyWcncS/BfQXltaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4995
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: cKEIkihcNNpZCQPu_VZrAd_sqrjStDHn
X-Proofpoint-ORIG-GUID: cKEIkihcNNpZCQPu_VZrAd_sqrjStDHn
Reporting-Meta:
 AAHjYcY/APe1CT+fD/84F+FUMqh4tjtk7yfLKcrMQgV8Eww4jRBcte7Xbqi3rpd9
 FEaxFCD+425evqSEZggsTnyXSl0nB9oVdLK84wOwjn0Jtg1auo2zcg35E7PSK7EM
 22y1AJHuq7ulHdH+crmUD1xMQYikrU8TKUVObwHH6aFDjG7XYS6yEA759hek5SGU
 Npb009BpXmFfYOui389+SMRR2DEYssymob8eI5fkAjQIB6HHFs50ExTJkapFa5Qq
 yjFU7RQZopnd7kczflojyUm+HIpWDggVdgSTemBLg+S/F1MJRIqlVV95zqrfQOzF
 5qhaK2ey+rwlt0isuP9AcTyHBtqPhddeceeamMx2JBBkkyFi7/VXiIiPg9jsS2gr
 iK9AmYWQCBWnhzRz2o2a6RmGzv5aQRgMwND55xmK4fLau330u4htCY9iq4eVIrWO
 u8AxjxaaP1F+egl1DerL1ZB7+SK1v4aBvb0FBPo+S84AjYXZkIPN+eoL/NGcWpo1
 uquZAC6scU9J/EoDNpdQa/aCLzwVQxf9c0vB0eekNBqqVQ==

T24gMy8yOC8yMiAwMDowNCwgSm9zZXBoIFFpIHdyb3RlOgo+IAo+IAo+IE9uIDMvMjcvMjIgNjoz
NyBQTSwgaGVtaW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6Cj4+IEhlbGxvIEpvc2VwaCwKPj4KPj4g
Q291bGQgd2Ugc3BlZWQgdXAgdGhpcyBjcmFzaCBmaXhpbmc/IEkgY291bGQgdHJpZ2dlciB0aGlz
IGtpbmQgb2YgY3Jhc2ggYXQgbGVhc3QgdHdvIHdheXMuCj4+IERvIHlvdSBoYXZlIGFub3RoZXIg
YWx0ZXJuYXRpdmUgcGF0Y2g/Cj4+Cj4gQXMgSSd2ZSBkZXNjcmliZWQgaW4gcHJldmlvdXMgbWFp
bCwgSSBkb24ndCB3YW50IHRvIGZpeCBpdCBpbiB0aGUgd2F5Cj4geW91IHByb3Bvc2VkLgoKSSBh
bSBPSyB3aXRoIHlvdXIgbWluZCwgYW5kIG9ubHkgaG9wZSB0byBmaXggdGhpcyBwcm9ibGVtIEFT
QVAuCgo+IEFuZCBJIGFtIGFmcmFpZCB3ZSBuZWVkIGRvIGEgdGhvcm91Z2hseSBjaGVjayBzaW5j
ZSBJJ3ZlIGZvdW5kIHRoZXJlCj4gYXJlIG90aGVyIGlzc3VlcyBpbiBvY2ZzMl9maWxsX3N1cGVy
KCksIGUuZy4KPiAKPiBvY2ZzMl9maWxsX3N1cGVyCj4gICAgb2NmczJfaW5pdGlhbGl6ZV9zdXBl
ciAvLyBmYWlscyBpbiBjaGVjayBtYXhfc2xvdHMKPiAKPiBUaGVuIG9zYi0+b3NiX21vdW50X2V2
ZW50IGlzIG5vdCBwcm9wZXJseSBpbml0aWFsaXplZCwgYW5kIHRoZW4gd2lsbAo+IGNyYXNoIGF0
IHdha2VfdXAoJm9zYi0+b3NiX21vdW50X2V2ZW50KS4KPiAKClRoZSBlcnJvciBoYW5kbGluZyBp
biBvY2ZzMl9maWxsX3N1cGVyKCkgaXMgdG9vIHNpbXBsZS4gSU1PLCB0aGVyZSBuZWVkcyB0byBh
ZGQgbW9yZQpraW5kcyBvZiAiZ290byBsYWJsZSIgb3IgcmVwbGFjZSBzb21lICJnb3RvIiB3aXRo
ICJyZXR1cm4iIGZvciBkaXJlY3RseSBicmVha2luZwppbml0IHJvdXRpbmUuCgp0aGUgb2NmczJf
aW5pdGlhbGl6ZV9zdXBlcigpIGxvb2tzIHRvbyBsb25nIHRvIGhhbmRsZSBlcnJvciBjYXNlcyBn
cmFjZWZ1bGx5LgpJIGNhbiBpbWFnZSB0aGVyZSBjb3VsZCBiZSB0d28gdHlwZSBzb2x1dGlvbnM6
CjE+IHNwbGl0IG9jZnMyX2luaXRpYWxpemVfc3VwZXIoKSBpbnRvIHNvbWUgc21hbGxlciBmdW5j
cy4gYW5kIG9jZnMyX2ZpbGxfc3VwZXIoKQogICAgY2FsbHMgdGhlc2Ugc3BsaXRlZCBmdW5jcywg
aGFuZGxlcyBkaWZmZXJlbnQgZXJyb3IgY2FzZXMuCjI+IG9jZnMyX2luaXRpYWxpemVfc3VwZXIo
KSByZXR1cm5zIG1vcmUgbWVhbmluZ2Z1bCBlcnJvciBudW1iZXIsIHRoZW4KICAgIG9jZnMyX2Zp
bGxfc3VwZXIoKSBjb3VsZCBoYW5kbGUgdGhlbSBjYXNlIGJ5IGNhc2UuCiAgICBpLmUuIGFkZCBh
IG5ldyBlbnVtIGZvciBvY2ZzMl9pbml0aWFsaXplX3N1cGVyKCkgcmV0dXJuCiAgICBlbnVtIHsK
CiAgICAgICBPU0JfQUxMT0NfRVJSLAoKICAgICAgIE1BWF9TTE9UU19FUlIsCgogICAgICAgUkVD
T1ZFUllfRVJSLAoKICAgICAgIFJFU01BUF9FUlIsCgogICAgICAgLi4uCgogICAgfTsKCi0gSGVt
aW5nCgo+IAo+PiBPbiAzLzIwLzIyIDIxOjUxLCBKb3NlcGggUWkgd3JvdGU6Cj4+PiBJIGRvbid0
IHRoaW5rIGl0IGRlc2VydmVzIGEgY29tcGxleCBmaXggbGlrZSB0aGlzLgo+Pj4gaXB1dCgpIGlz
IGEgY29tbW9uIGFjdGlvbiBhbmQgd2UgZG9uJ3Qgd2FudCB0byByZS1jcmVhdGUgYSBwcml2YXRl
IGZsb3cKPj4+IGluIG9jZnMyLiBBbHNvIEkgdGhpbmsgaXQncyBub3Qgc2FmZS4KPj4+IEkgc3Vn
Z2VzdCB3ZSB0YWtlIHRoZSB3YXkgdG8gbWFrZSBzdXJlIG9jZnMyIGpvdXJuYWwgaXMgdGhlcmUg
YXMgYQo+Pj4gcHJlcmVxdWlzaXRlLgo+Pgo+PiBsZXQncyBpbWFnZSB0aGUgam91cm5hbCBpbml0
IGJlZm9yZSBhbnkgaW5vZGUgb3BlcmF0aW9ucy4gYW5kIHRoZW4gdGhlcmUgd2lsbAo+PiBjcmVh
dGUgYSBnYXAgYmV0d2VlbiAiam91cm5hbCBpbml0IiBhbmQgImRsbSBpbml0Ii4gZm9yIGEgcnVs
ZSwgYW55IGlub2RlIG9wZXJhdGlvbgo+PiBzaG91bGQgYmUgdW5kZXIgZGxtIGxvY2sgcHJvdGVj
dGluZy4gaWYgdGhlcmUgaXMgYSBmYWlsZWQgYmVmb3JlIGRsbSBpbml0Lgo+PiBob3cgdG8gaGFu
ZGxlIGxvY2tpbmcgY29uc2lzdGVuY3k/Cj4+IHRoZSBjb3JyZWN0IGNvZGUgbG9naWMgc2hvdWxk
IGRvIGpvdXJuYWwgaW5pdCBhZnRlciBkbG0gbG9jayBpbml0LiBJTU8gdGhlIGNvbW1pdAo+PiBj
Y2Q5NzliZGJjZTlmICgiT0NGUzI6IFRoZSBTZWNvbmQgT3JhY2xlIENsdXN0ZXIgRmlsZXN5c3Rl
bSIpIG1hZGUgdGhlIGxvY2tpbmcKPj4gbWlzdGFrZSBvbiBmaXJzdCBjb2RlIHZlcnNpb24uIEJ1
dCBhdXRob3Igd3JvdGUgY29tbWVudCB0byBleHBsYWluIHRoZSByZWFzb24uCj4+Cj4+ICDCoMKg
wqAgYGBgCj4+ICDCoMKgwqAgLyogRklYTUUKPj4gIMKgwqDCoMKgICogVGhpcyBzaG91bGQgYmUg
ZG9uZSBpbiBvY2ZzMl9qb3VybmFsX2luaXQoKSwgYnV0IHVua25vd24KPj4gIMKgwqDCoMKgICog
b3JkZXJpbmcgaXNzdWVzIHdpbGwgY2F1c2UgdGhlIGZpbGVzeXN0ZW0gdG8gY3Jhc2guCj4+ICDC
oMKgwqDCoCAqIElmIGFueW9uZSB3YW50cyB0byBmaWd1cmUgb3V0IHdoYXQgcGFydCBvZiB0aGUg
Y29kZQo+PiAgwqDCoMKgwqAgKiByZWZlcnMgdG8gb3NiLT5qb3VybmFsIGJlZm9yZSBvY2ZzMl9q
b3VybmFsX2luaXQoKSBpcyBydW4sCj4+ICDCoMKgwqDCoCAqIGJlIG15IGd1ZXN0Lgo+PiAgwqDC
oMKgwqAgKi8KPj4gIMKgwqDCoCBgYGAKPj4KPj4gV2UgZG9uJ3Qgc2ltcGx5IHR1cm4gYmFjayB0
byBwaWNrIHVwIHRoZSBwcm9ibGVtYXRpYyBjb2RlIGxvZ2ljLiB3ZSBzaG91bGQKPj4gZmluZCBh
IG5ldyBtZXRob2QuCj4+Cj4+IC0gSGVtaW5nCj4+Cj4+Pgo+Pj4gT24gMy8xOC8yMiAxMTowNCBQ
TSwgSGVtaW5nIFpoYW8gd3JvdGU6Cj4+Pj4gQ2FsbCB0cmFjZToKPj4+Pgo+Pj4+ICDCoMKgIG9j
ZnMyOiBSZWdpc3RlcmVkIGNsdXN0ZXIgaW50ZXJmYWNlIHVzZXIKPj4+PiAgwqDCoCBkbG06IG5v
IGxvY2FsIElQIGFkZHJlc3MgaGFzIGJlZW4gc2V0Cj4+Pj4gIMKgwqAgZGxtOiBjYW5ub3Qgc3Rh
cnQgZGxtIGxvd2NvbW1zIC0xMDcKPj4+PiAgwqDCoCAobW91bnQub2NmczIsMjIyNSwwKTpvY2Zz
Ml9kbG1faW5pdDozMzU1IEVSUk9SOiBzdGF0dXMgPSAtMTA3Cj4+Pj4gIMKgwqAgKG1vdW50Lm9j
ZnMyLDIyMjUsMCk6b2NmczJfbW91bnRfdm9sdW1lOjE4MTcgRVJST1I6IHN0YXR1cyA9IC0xMDcK
Pj4+PiAgwqDCoCAobW91bnQub2NmczIsMjIyNSwwKTpvY2ZzMl9maWxsX3N1cGVyOjExODYgRVJS
T1I6IHN0YXR1cyA9IC0xMDcKPj4+PiAgwqDCoCBCVUc6IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVy
ZWZlcmVuY2UsIGFkZHJlc3M6IDAwMDAwMDAwMDAwMDAwMzAKPj4+PiAgwqDCoCAjUEY6IHN1cGVy
dmlzb3IgcmVhZCBhY2Nlc3MgaW4ga2VybmVsIG1vZGUKPj4+PiAgwqDCoCAjUEY6IGVycm9yX2Nv
ZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UKPj4+PiAgwqDCoCBQR0QgMCBQNEQgMAo+Pj4+
ICDCoMKgIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBOT1BUSQo+Pj4+ICDCoMKgIENQVTog
MCBQSUQ6IDIyMjUgQ29tbTogbW91bnQub2NmczIgTm90IHRhaW50ZWQgNS4xNi4yLTEtZGVmYXVs
dCAjMQo+Pj4+IG9wZW5TVVNFIFR1bWJsZXdlZWQgYjQwLi4uZTg0Cj4+Pj4gIMKgwqAgSGFyZHdh
cmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoUTM1ICsgSUNIOSwgMjAwOSksIEJJT1MgLi4uCj4+
Pj4gIMKgwqAgUklQOiAwMDEwOm9jZnMyX2NsZWFyX2lub2RlKzB4MmU5LzB4NzIwIFtvY2ZzMl0K
Pj4+PiAgwqDCoCAuLi4KPj4+PiAgwqDCoCBDYWxsIFRyYWNlOgo+Pj4+ICDCoMKgwqAgPFRBU0s+
Cj4+Pj4gIMKgwqDCoCA/IG9jZnMyX2V2aWN0X2lub2RlKzB4MWZlLzB4NjMwIFtvY2ZzMiA0MTFi
Yy4uMjgxXQo+Pj4+ICDCoMKgwqAgZXZpY3QrMHhjMC8weDFjMAo+Pj4+ICDCoMKgwqAgb2NmczJf
cmVsZWFzZV9zeXN0ZW1faW5vZGVzKzB4MjEvMHhjMCBbb2NmczIgNDExYmMuLjI4MV0KPj4+PiAg
wqDCoMKgIG9jZnMyX2Rpc21vdW50X3ZvbHVtZSsweDEwYi8weDJkMCBbb2NmczIgNDExYmMuLjI4
MV0KPj4+PiAgwqDCoMKgIG9jZnMyX2ZpbGxfc3VwZXIrMHhhZi8weDE5ZTAgW29jZnMyIDQxMWJj
Li4yODFdCj4+Pj4gIMKgwqDCoCBtb3VudF9iZGV2KzB4MTgyLzB4MWIwCj4+Pj4gIMKgwqDCoCA/
IG9jZnMyX2luaXRpYWxpemVfc3VwZXIuaXNyYS4wKzB4ZjUwLzB4ZjUwIFtvY2ZzMiA0MTFiYy4u
MjgxXQo+Pj4+ICDCoMKgwqAgbGVnYWN5X2dldF90cmVlKzB4MjQvMHg0MAo+Pj4+ICDCoMKgwqAg
dmZzX2dldF90cmVlKzB4MjIvMHhiMAo+Pj4+ICDCoMKgwqAgcGF0aF9tb3VudCsweDQ2NS8weGFj
MAo+Pj4+ICDCoMKgwqAgX194NjRfc3lzX21vdW50KzB4MTAzLzB4MTQwCj4+Pj4gIMKgwqDCoCBk
b19zeXNjYWxsXzY0KzB4NTkvMHg4MAo+Pj4+ICDCoMKgwqAgPyBzeXNjYWxsX2V4aXRfdG9fdXNl
cl9tb2RlKzB4MTgvMHg0MAo+Pj4+ICDCoMKgwqAgPyBkb19zeXNjYWxsXzY0KzB4NjkvMHg4MAo+
Pj4+ICDCoMKgwqAgPyBzeXNjYWxsX2V4aXRfdG9fdXNlcl9tb2RlKzB4MTgvMHg0MAo+Pj4+ICDC
oMKgwqAgPyBkb19zeXNjYWxsXzY0KzB4NjkvMHg4MAo+Pj4+ICDCoMKgwqAgPyBleGNfcGFnZV9m
YXVsdCsweDY4LzB4MTUwCj4+Pj4gIMKgwqDCoCBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJh
bWUrMHg0NC8weGFlCj4+Pj4KPj4+PiBIb3cgdG8gdHJpZ2dlcjoKPj4+Pgo+Pj4+ICDCoMKgIHRi
LW9jZnMxICMgZGQgaWY9L2Rldi96ZXJvIG9mPS9kZXYvdmRiIGJzPTFNIGNvdW50PTIwIG9mbGFn
PWRpcmVjdAo+Pj4+ICDCoMKgIHRiLW9jZnMxICMgbWtmcy5vY2ZzMiAtLWNsdXN0ZXItc3RhY2s9
cGNtayAtTiA0IC9kZXYvdmRiIFwKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLS1j
bHVzdGVyLW5hbWU9b2Nmc3RzdAo+Pj4+Cj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ID09IHRoZXJlIGlzIG5vIGRsbSBydW5uaW5nID09Cj4+Pj4gIMKgwqAgdGItb2NmczEgIyBtb3Vu
dCAtdCBvY2ZzMiAvZGV2L3ZkYiAvbW50Cj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ID09IGtlcm5lbCBjcmFzaCA9PQo+Pj4+Cj4+Pj4gQW5hbHlzaXM6Cj4+Pj4KPj4+PiBBZnRlciBj
b21taXQgZGE1ZTdjODc4MjdlOCAoIm9jZnMyOiBjbGVhbnVwIGpvdXJuYWwgaW5pdCBhbmQgc2h1
dGRvd24iKSwKPj4+PiBKb3VybmFsIGluaXQgbGF0ZXIgdGhhbiBiZWZvcmUsIGl0IG1ha2VzIE5V
TEwgcG9pbnRlciBhY2Nlc3MgaW4gZnJlZQo+Pj4+IHJvdXRpbmUuCj4+Pj4KPj4+PiBvY2ZzMl9m
aWxsX3N1cGVyCj4+Pj4gIMKgICsgb2NmczJfbW91bnRfdm9sdW1lCj4+Pj4gIMKgIHzCoCBvY2Zz
Ml9kbG1faW5pdCAvL2ZhaWxlZCwgb3NiLT5qb3VybmFsIHN0aWxsIE5VTEwuCj4+Pj4gIMKgICsg
Li4uCj4+Pj4gIMKgICsgb2NmczJfZGlzbW91bnRfdm9sdW1lCj4+Pj4gIMKgwqDCoMKgIG9jZnMy
X3JlbGVhc2Vfc3lzdGVtX2lub2Rlcwo+Pj4+ICDCoMKgwqDCoMKgwqAgLi4uCj4+Pj4gIMKgwqDC
oMKgwqDCoMKgIGV2aWN0Cj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqAgLi4uCj4+Pj4gIMKgwqDCoMKg
wqDCoMKgwqDCoCBvY2ZzMl9jbGVhcl9pbm9kZQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBv
Y2ZzMl9jaGVja3BvaW50X2lub2RlCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgb2NmczJf
Y2lfZnVsbHlfY2hlY2twb2ludGVkCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0aW1l
X2FmdGVyKGpvdXJuYWwtPmpfdHJhbnNfaWQsIGNpLT5jaV9sYXN0X3RyYW5zKQo+Pj4+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCArIGpvdXJuYWwgaXMgZW1wdHksIGNyYXNoIQo+Pj4+Cj4+
Pj4gSG93IHRvIGZpeDoKPj4+Pgo+Pj4+IGNyZWF0ZSBhIG5ldyBmdW5jdGlvbiBfaW5vZGVfZGly
ZWN0X2ZyZWUoKSB0byBoYW5kbGUgam91cm5hbCBub24tZXhpc3QKPj4+PiBjYXNlLgo+Pj4+Cj4+
Pj4gRml4ZXM6IGRhNWU3Yzg3ODI3ZTggKCJvY2ZzMjogY2xlYW51cCBqb3VybmFsIGluaXQgYW5k
IHNodXRkb3duIikKPj4+PiBTaWduZWQtb2ZmLWJ5OiBIZW1pbmcgWmhhbyA8aGVtaW5nLnpoYW9A
c3VzZS5jb20+Cj4+Pj4gLS0tCj4+Pj4gdjM6IGNoYW5nZSBwYXRjaCBzdWJqZWN0Cj4+Pj4gIMKg
wqDCoMKgIGNoYW5nZSBmaXggbWV0aG9kOgo+Pj4+ICDCoMKgwqDCoCAtIHYxL3YyIGZvY3VzZWQg
b24gdGhlIHBvaW50cyBvZiBhY2Nlc3Npbmcgb3NiLT5qb3VybmFsLgo+Pj4+ICDCoMKgwqDCoCAt
IHYzIGRpcmVjdGx5IGZyZWUgaW5vZGVzCj4+Pj4gdjI6IHJldmlzZSBjb21taXQgbG9nCj4+Pj4g
IMKgwqDCoMKgIGFkZCBjaGVja2luZyBpbiBvY2ZzMl9kaXNtb3VudF92b2x1bWUoKQo+Pj4+IC0t
LQo+Pj4+ICDCoCBmcy9vY2ZzMi9sb2NhbGFsbG9jLmMgfCAxMiArKysrKysrKwo+Pj4+ICDCoCBm
cy9vY2ZzMi9zdXBlci5jwqDCoMKgwqDCoCB8IDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0KPj4+PiAgwqAgMiBmaWxlcyBjaGFuZ2VkLCA3NSBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQo+Pj4+IC4uLgo+Pj4KPiAKCgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2Nm
czItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL29jZnMyLWRldmVs
