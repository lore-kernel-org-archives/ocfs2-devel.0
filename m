Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C472DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 28 Apr 2022 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7W83ab7br48gCpNqY7ezxYpfmLGBfxjlMUG1Ph72Z3w=;
 b=R+pdKfH1LmMzJ64tQoRzE8PmJMVcreFbmR+viXQJoVdR6btM5sX0+10ycuauU2PIhQrSCYrq9rkO
   NgfmNBHRKIyNSmh3Y0DjGcg3hPVd2HhMZ0mB7j0BnBE2jFKQ128H4uelViPyzQ6nzMBH04wDuLG1
   UF9ZRk7v9APm//6LpQDivHpSheGEqGETXpNZvbeEn42FCyMEPwC4q63hIe0nyH5t97aZU9b/sxFn
   pWN2AP89zYILEtdrFO5AdipBBG+PYjk+MjMAeZir52O6cCaTMuBewAn2kcxcFTPxqSOSSb2ta33U
   XaRzsseBT0+53FHzh6yWcXHQ6Hv4zI8cjHZWrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7W83ab7br48gCpNqY7ezxYpfmLGBfxjlMUG1Ph72Z3w=;
 b=mO8AmkrNwxsdMU02HLE3gKPuZ4HdyssIhfl2e5dLJecI+TsEcnFRK+abZE1LZP+W1BW99D8U7gZT
   mAE0qlVEqsGNl/B350UzgjgZ16VHf8/134MbCvHHfGObfGCfWlQVYPwH6ea08P7/49I3cMzP6o+T
   VBkOC0yIcbZtbsqEeJiYt0dbOEM71FaVCPPhq2qANHXXOTK3W/XYkED48ArIkfYWiiTXmCfcRtb3
   Kmlc99qpbE6HD6RJmw3eH4gaBmJlsdK1aILuAj2tyEcs9niPrASMu8OKwteqnNL2JAWm1e4xCi+C
   FMG0K5SoN+pl66BeM+oJecx3hP00kiuJcK7LjQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RB2007F81NGAC90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 28 Apr 2022 14:59:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1651157964;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bY1+gcZwB3Jqp1FHt55Bc+vhGKPFsyvj5gRJfTFYz78=;
 b=jMkCP5ZPOzL22QkiQqU57RguEQGAdkDGf+anujiR2JyVmQVzQ53x+5cXkpA5w+zECAENx5
 5Smu7PXr8IB8uLW/1SyhNUieNTx1IFqK6r5Py870Oo8dFSWdQEk96E2einmcpwVu4gCOCi
 sYwoRRW70nMsmjPxLioROdFc5z8cS5o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQkIpQqEQFmFsA9KYMvq6IzNoxiTzCtudXxwiIvKw+LUpN4f/DcP6dIaY2BFDA4vD3eelrunCvPnjZFMa5cATKZDNRp/TWRXo/7t/Cj3d7qI83Td3Ec+c00Jwa4cKzEFjFocZ03jPiHI87/znE7Ee53Kel0y6rTAbRo+O/eQK0teT8Mpwi7DLUHeDr7rfEdNhZfO08S1/uL/ptKqsboT/NcHpBSONLP1NMHJzu9PAetAE0t72VHffzetuLE5uk5xW4LZ+/+A53yvqFsM7at9VRsbTb9x8eUeQcIVj3B1wJV/lBbT5aU2DZ2b06Q6vZkpAIxYWJfIqdpBlkpEqWPh/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY1+gcZwB3Jqp1FHt55Bc+vhGKPFsyvj5gRJfTFYz78=;
 b=a+TivoETp/6koPtGxn7+mevrr3H7RJ0VN8dpsWay0nRu3Efd1jxBpDQLjQnLzsVy/o3lH7EHktdHOZHJz614G1i2hYozDRPuu07e9zS9hSQCIKs+gC2/Xdi9iBQmiM99d68ZMInJSyIiTkCGeO6o8yB37XPGeE5JV9m/7OnGgYcw4iMgA6z/qAxfkuqx5Svm3W03CnFiNnzri8kwOfpZVCVAjutSTknDJAuWvK6LDbieZWbYGWlBJMN/1uGU7XIufUKeRL6oYi/831ldxaLihhVEqDzkYZBVEfVllkXIoLjgCxLFs5fzl3HLf9Ry7T5v3VZXnok0YkgCrDJR8KFa6A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <ea9f9636-43bd-1079-f788-18f33c1e3e18@suse.com>
Date: Thu, 28 Apr 2022 22:59:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <20220424130952.2436-1-heming.zhao@suse.com>
 <20220424130952.2436-4-heming.zhao@suse.com>
 <df95d0b8-0fa4-e705-9a2b-5db888f53282@linux.alibaba.com>
In-reply-to: <df95d0b8-0fa4-e705-9a2b-5db888f53282@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(86362001)(2616005)(186003)(83380400001)(38100700002)(31696002)(316002)(5660300002)(110136005)(36756003)(8676002)(8936002)(66476007)(66946007)(66556008)(2906002)(6512007)(53546011)(26005)(6666004)(6486002)(508600001)(31686004)(6506007)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 14:59:19.7957 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10330
 signatures=694622
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0 priorityscore=196
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=291 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280091
Subject: Re: [Ocfs2-devel] [PATCH v3 3/5] ocfs2: ocfs2_initialize_super does
 cleanup job before return error
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
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: jKG14SiqNbKwYSqSVGEPpA-1
X-ClientProxiedBy: SI2PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::7) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f066e477-554a-43c1-cdec-08da2927ac17
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3823:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB382336053A55C617FFE7C73597FD9@VI1PR0402MB3823.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 uSnxc/H/hdLdAe1QsNrIdh7BOb/vCzt7OuI/Yw8retX35WD9xvXtwRfNt3rD5VA+vYfKgnFiApeJ4KAnftOeFq9CslxoVcGyhlG8UOT6yz4BG9JZ9NHYkd6R8cu5fXqlPCloFYZ3mZw37gVAtFaEXHYVeeS3qahAYr53WsfCVURWKKosqjwBj2Bme7UbzSR8EEDegnLNSz664yAuYHmC2RmlXGmmmIXlPEPNtzadt33F0kMx/UDKLYXIlxspC/7PYQ/kkRtkpt/oyJVqOQiEmTxKQqVlgmwDtF3gwD/2PO2aRVEjh7UrWgEMjHSXEcTi7tB3pFBZC7sKnNFd4Z+nH1LeNoe4k9u66gEI+d3+6ZZb2iwliD4Gtrwpbn6+KoJhDDgdwgwTl4c7jUT+kPKuA2BCje56b6TtCVepJ9HoqaZP1QV71FJwPKRRveeKT2JzXmeuVupmeS7VOUIHq4f9Osa0dhVySAY7HyoU1b+6VnJNXuLSxSTxvrJN0B4jYI0eMwZ2GnSZJUqZlWhxhpSjHScujnDlhtFE/3laIy+JbSqw1VxA/84W6Un+o2+KV4z2yB0e/Nc2bAb6bCQ/37wwZ7A4iUfS1kh/le+d9YFZYLChYTXdeTgXfpxEJM1zgaIV3Tc6U00MV5tXfQ/QsIdOvFfZRpD3TQ/E/pQU6oOyR1xh4nrN19hnKQzydyqvDtH7cEozcBjfuYcMvTeskyF9gwSncBZdOj+Q7DZkk+L3BfBc/Su3B1+kWi2MdpSaohhe9dRp2t4z5lKLF2q9cLOtHQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NXBxVENsOEkwc3paRGt2SEh4ZGVOeWNyR0U1TEJ4SUh6R1RpbmV0WDNzTlJJ?=
 =?utf-8?B?THJWYVBsOEdYRGxPcTVIOUd2RGc0QWczRmRrSVRldHBNQ3RoVk1YWldrSGll?=
 =?utf-8?B?T0V1ZVBiZXBFUERvNVd3UUJwb2s3UVJIT2dJalZrOGczZTk3Z3ZVckErZWdl?=
 =?utf-8?B?blIvc3Z1cFpWamNGeW5BenV1cE1zc1JXUzl4UkErNDdBZW5SdmJZQmFZWGMr?=
 =?utf-8?B?N0RTNlpkSG1GK1RoTDFPR0RKSHcwWDZtMUpMN0twdFVkUWRGRjNkZ082eVpJ?=
 =?utf-8?B?RW0rMDVCbnBsL2NNRks4Nklxc0d0Qy9yNU0xK0dyK0JySVVjTGRKN3JZNUdP?=
 =?utf-8?B?UHc3amJRdXdUTlJ3QlI2Y3RBOVNxV2s1MmQxWS9pVC9aS3p2L1lCNjF3d0dk?=
 =?utf-8?B?Z2xleUg3aTQ1OWE0aHVhK1BUbW4xajRUUEpReTlFaGZVM1RjK1JadTFqMHlX?=
 =?utf-8?B?Zi85N3NhdlVVQlRoTTUzNFVNTE5nR0NpSHNOZnpHT1hodDVVYVFnR0ZQRk0w?=
 =?utf-8?B?YmFzcmV0NENsdFQwY1puQVNnQW5BUzF4YkxaZkZ1UU9vT0thd01xdkhDbXlO?=
 =?utf-8?B?YUJmSHVCK3BIZlhJNllYV3FWaWZScHYzWWtWckdlN3JKc3Zvc1loZVpmZzhU?=
 =?utf-8?B?UmZkeHdqZWQ0YzM2a0ZFRUliNG43L1NrdFlmUWVnQTRsRmc1ZzVMMVltRkhJ?=
 =?utf-8?B?NGJib3phTlE4VVRzWWVQRjFkU1V6K01sMnlUaGZzTVdxNC9DenFXN1hTUENE?=
 =?utf-8?B?MzhPQkdzQ0FKVERMOFVTZ1pGWW9ObEZrdEdVcmU3RFdXRm55UCtvU0JaN25C?=
 =?utf-8?B?bHZOZi9MV0V4UVN5a2pqL3RvSXBIUkx6empCdE4rMlFYa2YvVXU5VTVGd0cz?=
 =?utf-8?B?WmRIN050WGJicnJVTTJxTEhoZC9rVVZLYW1HZXBXNEdqcVlkYWFaWVBENnF1?=
 =?utf-8?B?bWpyU3ppTk5GQkI3V1VBZktXSDZmUXN6TVZaNDdISkJFdnA5UHNmL2s5M3Ft?=
 =?utf-8?B?cm1vMnBTVXZVckMzYkxvaGdPU0dEcmJPazhhS296N0kzYXhhQlNvR1ZQMXov?=
 =?utf-8?B?dWoyMUp3VlFJaDFvWUpxblU3VXFaTjYveWgrWlNyQmluMHkveDZVR1g1ZzJv?=
 =?utf-8?B?L0taRllZeVhjdGhlZmthSFB1KzdyWlpNOG14bFJqM25ZUDVUSFBHUEIvMUt1?=
 =?utf-8?B?cTNCWk8zYnFUaWhkRWNyNkdwTmtzMmU4RkQzZ3ppbVdTVjVmR0czTEp6ZnN6?=
 =?utf-8?B?ajdWN3JKckNreWk2SytVQ2oyU1JQSWYrWlBEc2hrL2pmUG5hck1lWkJtbDVH?=
 =?utf-8?B?SnBpRk9XQ2hnamdyYThXdFc4dURDNHowNU1yNjFGUCtzdjgvVXBQYi90UnhG?=
 =?utf-8?B?b0t5ZVNwMmMxdjdtaUt5NzNETkVFdDk1azdsUGMyOE5RTFFoMDVrY2V5a1Rl?=
 =?utf-8?B?cWVSaDNleS8vMXNCY2pFN2tZZXdFUkNPS3NmYWpHM2V0SXREUUhVeWtnK2ZX?=
 =?utf-8?B?NWdnM2cydTBZMy9iUnNmMG5Oa1cyc3AyZ1hxK1dPUnRhV1cydERnUS9GMldm?=
 =?utf-8?B?dzd4R2JVVUwxOU1pcDZBT2JqY2VKaSt4WUZJMEtkUHY5YnprZnZocC9TMXd2?=
 =?utf-8?B?UkFwcFBIMU50S3cxYWlzTUZwdkFDaVJtS2lUQ3p4U0ZWRTJ1cytjK1AyOHdw?=
 =?utf-8?B?a1RQUy9ZdGVTZzE3eDNDT05WQmxrZFBjR2N4dVFhQWJPTUh6UnFFb3RLeUpH?=
 =?utf-8?B?aXNMVG5HOVV2K1NjRTE0TW8vdHJwLzNBekExbjZIOUdJZGZUUm1iSGgyMThy?=
 =?utf-8?B?Q3YvSkZXREJkUU56S3ZQZ2NCZFVCcGdBZWtWQkdWTCsxZTJiVzZBZG5HZ0FK?=
 =?utf-8?B?VjZYcUZjMHpXL3R4Tjd3ZVJCYTJ2VGU3YklxNjRaclhvS0pCSVBwbHNLSGlY?=
 =?utf-8?B?VjNOQk9zREtBZFFieENuNnRWK3pRQ205cW4vTlBGNjJnUXdsT0FZQmhhdzJ6?=
 =?utf-8?B?L3lCeFJnYWxsWk0xV1NXcndwQkxBY3pCWVpnb3lOSis3UWpvblRNVUFwdS9m?=
 =?utf-8?B?YkljV0EyYzFiNEJLYmxwazRaaUNJNnp1MnFhQlluR2xyVlFtTEdFa2JWT0Q2?=
 =?utf-8?B?UVdacGkrcXllR2gvd0VkSXVNS0dYQTRJK1dUdWIrZlduTlZLNWc5MXNPcE52?=
 =?utf-8?B?Lzg2WTI3bWFZYUdwWk5vNlNhZ0J2VXlTbXpqQ1FPdlE5OXh0NmkzZmhZQ1h1?=
 =?utf-8?B?eVRkSzc5RURPazVXSVpwd0dMeTRsMDhSbkluZGFRR2N0SXdhSFlwSFBwWFcy?=
 =?utf-8?B?bkdzQ2JrRWthOGRJaWViZHRTcVBMZndhVjRvM2RWVmErcWxERWxRUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f066e477-554a-43c1-cdec-08da2927ac17
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 3G00JiXWK/eB9aP12mQ8+AJatN2lmbu1W84PsD7avGg/toQfjxsVGr3dEO0zskWEBkpnmf/EQyozHgS6gM5/9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3823
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: WgH7JAD5sxZw48WYhjrBnV3y0YlwZsr3
X-Proofpoint-GUID: WgH7JAD5sxZw48WYhjrBnV3y0YlwZsr3
Reporting-Meta:
 AAG9DQ/C6qu8MDMJsvDxcauDQ3BjkmBCcpaXVCXY5a8RcfrCZt9ABzUoHoWFyISr
 +eoBYKH49QcePoEnXIWbgyv+SVowz1sJ83pbTW+nwdNLMW+HOi1FRUUY9JWgcvXd
 QxSOhsQimEqlGLImNnuuQrle52our1bYM0L/QDHzNVoAWUB/HMoEKtHBlLX9F9OV
 mnzPU3U+pxcHRodhn9+JRhZC1feUU/8435GUAA7l04WWV/EWpfKJ9WSLQjx/djHx
 PZSOdiCSdrotmMN0O0bg84keUedUTkKZ5EIOgFlrrsCIXZ0offVQfVGpmBfw0F2o
 qwlaRpVg+pq6cCn5MjjtUrvllU4GIDI3/77W7P/bODiLjy0SiO0mCG+bgW7eA3XY
 1sLoAjuMJ8KjVmwPkO7dRZmpfmlfpIAjz/nxgF1kyZWSwkdcWlTKraq0REslZrk5
 rJbav4tFNkbxGrjRs6Nxu6irV6xIs4/rUBDzpdjvKIgyRoYAi5yQBFfwbE6xcgc+
 u+ImTL4d1A3cq8dslaFWIQbvi4pfSE0mr4gkXmOaTZaH9g==

On 4/28/22 19:37, Joseph Qi wrote:
> 
> 
> On 4/24/22 9:09 PM, Heming Zhao wrote:
>> After this patch, when error, ocfs2_fill_super doesn't take care to
>> release resources which are allocated in ocfs2_initialize_super.
>>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/super.c | 59 +++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 41 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 8014c690ef72..758ea3313f88 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2022,7 +2022,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out;
>>   	}
>>   
>>   	sb->s_fs_info = osb;
>> @@ -2083,7 +2083,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
>>   		     osb->max_slots);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto out;
>>   	}
>>   
>>   	ocfs2_orphan_scan_init(osb);
>> @@ -2092,7 +2092,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (status) {
>>   		mlog(ML_ERROR, "Unable to initialize recovery state\n");
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out;
>>   	}
>>   
>>   	init_waitqueue_head(&osb->checkpoint_event);
>> @@ -2116,7 +2116,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->vol_label) {
>>   		mlog(ML_ERROR, "unable to alloc vol label\n");
>>   		status = -ENOMEM;
>> -		goto bail;
>> +		goto out_recovery_map;
>>   	}
>>   
>>   	osb->slot_recovery_generations =
>> @@ -2125,7 +2125,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->slot_recovery_generations) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_vol_label;
>>   	}
>>   
>>   	init_waitqueue_head(&osb->osb_wipe_event);
>> @@ -2135,7 +2135,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->osb_orphan_wipes) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_slot_recovery_gen;
>>   	}
>>   
>>   	osb->osb_rf_lock_tree = RB_ROOT;
>> @@ -2151,13 +2151,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "couldn't mount because of unsupported "
>>   		     "optional features (%x).\n", i);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto out_orphan_wipes;
>>   	}
>>   	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
>>   		mlog(ML_ERROR, "couldn't mount RDWR because of "
>>   		     "unsupported optional features (%x).\n", i);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto out_orphan_wipes;
>>   	}
>>   
>>   	if (ocfs2_clusterinfo_valid(osb)) {
>> @@ -2178,7 +2178,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   			     "cluster stack label (%s) \n",
>>   			     osb->osb_cluster_stack);
>>   			status = -EINVAL;
>> -			goto bail;
>> +			goto out_orphan_wipes;
>>   		}
>>   		memcpy(osb->osb_cluster_name,
>>   			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
>> @@ -2198,7 +2198,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	 */
>>   	status = ocfs2_journal_alloc(osb);
>>   	if (status < 0)
>> -		goto bail;
>> +		goto out_orphan_wipes;
>>   
>>   	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>>   	init_llist_head(&osb->dquot_drop_list);
>> @@ -2213,7 +2213,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>>   		     osb->s_clustersize);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto out_journal;
>>   	}
>>   
>>   	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
>> @@ -2225,14 +2225,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "Volume too large "
>>   		     "to mount safely on this system");
>>   		status = -EFBIG;
>> -		goto bail;
>> +		goto out_journal;
>>   	}
>>   
>>   	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>>   				 sizeof(di->id2.i_super.s_uuid))) {
>>   		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
>>   		status = -ENOMEM;
>> -		goto bail;
>> +		goto out_journal;
>>   	}
>>   
>>   	strlcpy(osb->vol_label, di->id2.i_super.s_label,
>> @@ -2252,7 +2252,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->osb_dlm_debug) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_uuid_str;
>>   	}
>>   
>>   	atomic_set(&osb->vol_state, VOLUME_INIT);
>> @@ -2261,7 +2261,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	status = ocfs2_init_global_system_inodes(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_dlm_out;
>>   	}
>>   
>>   	/*
>> @@ -2272,7 +2272,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!inode) {
>>   		status = -EINVAL;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_system_inodes;
>>   	}
>>   
>>   	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
>> @@ -2285,16 +2285,39 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	status = ocfs2_init_slot_info(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto out_system_inodes;
>>   	}
>>   
>>   	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
>>   	if (!osb->ocfs2_wq) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> +		goto out_slot_info;
>>   	}
>>   
>> -bail:
>> +	return status;
>> +
>> +out_slot_info:
>> +	ocfs2_free_slot_info(osb);
>> +out_system_inodes:
>> +	ocfs2_release_system_inodes(osb);
>> +out_dlm_out:
>> +	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
>> +out_uuid_str:
>> +	kfree(osb->uuid_str);
>> +out_journal:
>> +	kfree(osb->journal);
>> +out_orphan_wipes:
>> +	kfree(osb->osb_orphan_wipes);
>> +out_slot_recovery_gen:
>> +	kfree(osb->slot_recovery_generations);
>> +out_vol_label:
>> +	kfree(osb->vol_label);
>> +out_recovery_map:
>> +	kfree(osb->recovery_map);
>> +out:
>> +	kfree(osb);
>> +	sb->s_fs_info = NULL;
> 
> Or just set "osb" to NULL is enough to keep code consistency.
> Other looks good. Once it is resolved, feel free to add:
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

In the front of ocfs2_initialize_super, the sb->s_fs_info is set to osb.
So set osb to NULL is not enough, sb->s_fs_info still keep wild pointer.
The caller (ocfs2_fill_super) will fetch the wild value from OCFS2_SB(sb).

Another question: do I need to resend v3 patch with "Reviewed-by: Joseph Qi ..."

Thanks,
Heming

> 
> 
>>   	return status;
>>   }
>>   
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
