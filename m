Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6234DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun,  5 Jun 2022 03:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qBDL8TuMtmWC8lM0HrX0876qkp54/rjupJ5ruLXGdBw=;
 b=Q8At0n3gNiVGAz9DPsIo05oTZCF9JJ01Jhtlo6q1ahxtvyKxsHa9tm2+TrJD+ceNZLnvMCCz3clz
   k7j5GLKBG3A9U2pUxutJqRsEJdpbLYDUqccs7sEvLnQdsxCgnL6ATkg/u8tLFvjPZebJB30XQddb
   zU8agztCrIYXkZo0xaFJ035kBWrnuSXrO2qAWzvsUfrTC5/wJ0f+WaFPRPKwVgFz5MRZZBPKOnx/
   9I+kXHILLI9kcLKx/wVhP9T+SYvyT4y+uWE9PnmSjFzmKHs2nSTX8bE42GsbmLT2t/JhmgyZjMBG
   +u28QdMKoHgpo/WoQnWuYmAKt9krfIOUVIJjEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qBDL8TuMtmWC8lM0HrX0876qkp54/rjupJ5ruLXGdBw=;
 b=HRxgT3+X1O205A4a5ByHz5iveHnsGmLA+QXmuhwCijhZUlHuwnRbgGt4tHTG21hdRgA8Bx/Vcd2P
   ywLP+ccvkjuHPiAc1U3sjmlnCKdyIR6Aq5S24LvVtooLnI5tdqXFba99sfREPSNecXHGsCYdPaKR
   JuVdt/RN06E+8xEcUUsE+gcJWF3cAz0Suiycr6k0/UOIv4AUT7Nlf4c2gR4HhlFSab0VMpyLyeEk
   sljV0fbAKQUsmmYlywrP6Vso/ncQhdSJS7P/AzcECjFg+4nLb1Av5tHIeLs1rMca+BlDF5Z3VrXA
   kdepotTapPknS9OzKZYfZnwL9scanZxEuGsEWw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ00C4VJTAKR00@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 05 Jun 2022 03:46:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654400765;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=N2BscStCJeVXiV9yIU13U5OFVsva+2+M2Eg0sNoJBAM=;
 b=mfUZ3Vaj+tAMatSzA5HGjh02revJhuBeClLqMyeQ367H/cOo8arGGD3Npt1mOa4+PZKJyH
 yOUhP6FqHiIWNbE+qpMLqXJ1GMaqqZbGeeGY7eszS/svz3X/rYY6apO7RcNsFAmAneNcFN
 jVbwAMvCkSG4b6pVMqKMxH1RZIl+CLU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiB9tCD64VTSpD+Ndgw73XxtN3z62eJfhNKrnkkQ6Iny5up5qzWP+aNPNTXIXgsa3jMVvRjpgxmhfXZ6DeonwPdXxXdpxFfDo10QI6TXR+sQzHK0TV8Ay9sBznt/L7FWO462KF7Vk/6sKX9Iap6Ty2tWHxAy0doH1zjhsuPgZjXciFKh4mv+B4YEa2QSHiOoQwvmBepPY1GzwKYdtoQTxb7DDJoY81JasI/CJ9x6A61ALmaHsOjqFB05Xy9Z7rl4ruUsxyjemXp972ULFxksv/yZbDyIJvxbm63f5Us9znnP2TTI2SRVWLYIYmdRFGmoxNvYM1n5wuDw2BGy27hYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVg2YeYTT1vqcevhUZxgyhgNxFPEKP3MEG87T9zVKac=;
 b=Kfcx1Tq0Lkarclx+6X3jVPeix7yfrvCa5EcyS1aaqA+ACE1eTFh49DxNiBgLfqqQMKJjuSyXDS2vh9Vdr9MzrGKT52GTmGtjIIV9Y1Tl6PqaZwxSnJ/PoerZpl/uWG3zTk1V62Hcso+wzobp0xwiOE9IrT6WPkJveUBxu0Tmz0qeH0Qy4X15qJn0GRQaRpeZD7smoYgb1qgLnSP8cZAcCc/8OsNyuIvGyyDYE3itE9KxHTcgVwSQoGR1Id//BxMXosVzYLMy7fY7ljUKp5GBR9+B4bFBrJcw+XyxnFmWaXp3IELZjJ3jZk9pPcArfWwtiUaTzHrRE8MdOUrpmGKW3A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <19c7aae7-6e5d-0028-87c2-f7534b23aaf4@suse.com>
Date: Sun, 5 Jun 2022 11:45:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
 <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
 <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
 <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
 <20220605014817.kussyrri5t2235gw@c73>
 <91D8ADED-567A-4B03-AB83-00801355EE45@oracle.com>
In-reply-to: <91D8ADED-567A-4B03-AB83-00801355EE45@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(26005)(2906002)(6512007)(8936002)(508600001)(6506007)(5660300002)(316002)(6666004)(38100700002)(53546011)(6486002)(83380400001)(36756003)(8676002)(6916009)(66476007)(66946007)(66556008)(2616005)(4326008)(31696002)(186003)(31686004)(86362001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2022 03:46:01.9540 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10368
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=162 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=184 impostorscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050014
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: AV_H7HbbNDGdVq3Ev7Rppw-2
X-ClientProxiedBy: SG2PR03CA0132.apcprd03.prod.outlook.com (2603:1096:4:91::36)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ad4a778-1ec1-4ec4-4f73-08da46a5e8e2
X-MS-TrafficTypeDiagnostic: AM0PR04MB4529:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB4529CB64C90197E4FD2365AD97A39@AM0PR04MB4529.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 XwsQl3h/YZKd8IZjS7B1bGwKYStScWrf+pKCEFaCJPxHGdQtCmfBh2r5b6bsGpGtrzGfqO2v9bAxlfpbrzNVPUmNCHAOYUUfdZCc+m892NkdyE5LREp24mrM5Cim9Oh50QyZxAEso1URW1zaTKh6L42foX44ncbL+7oltthJKBn4oz1nadcklY8P2YESkVIpOqXelCQvMCF+cnYpxVzjFSxMxJwMpEg47/ID7nRTE5SisVibG4NXWmkMlLe7ezDx0y2XfQSHApYwPolgQQS4yLo6W2wjr2WFmWrDKyywDtlcAm2B8Y0OvZUJ41iYqzqJOpUqv99n/Ve1Djf2Z37BefagtR3Cr09JkzCzLRI+UGaVVdbKPes/R9zX8xSBkiARhQMOPmzIHYR7njAVecJzbLMnD4Z/Fztofk0FLy+dEjmMsgYnVw3UCljmTRdB4233AkeX0Vqqd6LEOT/gEaM775z4jlg1UUrtSbKsvWfN3hncIeXjhqastMlnBBb1K2DOzF9OXANZWA9PWXJ/m0gRMpIq0BCFk4yzAj/6jBrfUhgYvq6Um2cBANVkZNC9NoUIIH45dsIplkCtMYPExrg7N9O3WZu0zOisOpmYFR04HCq8jp45fkZTdZQyZRtQf8o6grg3uVKvYMOH6xKcjScrixVRicynVWzD0k94Qkwm7apZaRB4HcRKVEQzzZovcSzDflz9w243pJHVU2ltZjWv8Jlqnr1WJZvMufrTXxAzB8o=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vq5FbUIaxzKWTvfUNQzIRkGrC4b1BYIPRupBzOklhbwpctT1t8TDbPB/QXfz?=
 =?us-ascii?Q?UL/TZ4j0Z2I+7fHZyqiSQ+YIwQtD6rHeDvTmMLvPSL592ZwMfcDFtX+TKWwK?=
 =?us-ascii?Q?VmFjuLlKVzeacsXdZs9md9hUHmA1GEy0ICUFjcSc+MBux3E/cOSyBJ93FFjK?=
 =?us-ascii?Q?60f+4tjjEpEPzBGiJ1ugje9PZrPfvJcx9RE+2v1T4sXlos173joFFNT9MiZK?=
 =?us-ascii?Q?vPVPxN0NVBDUl4SvtqCLXa/BykuhVu0Vlzo8sqljg5Y3yQgieMdqPxJ8Zd/k?=
 =?us-ascii?Q?oKAwSfa2HB8SbFboFkDxT7jscbz2MClS4/+D/mewAd5+vSa2N/8R8oHOvMok?=
 =?us-ascii?Q?Eo+A4vZCtbM/JYqF0LPKm/I6acRic4vcl9UvGWU5fgk0N3sIdEeWcUZRH1op?=
 =?us-ascii?Q?V0yxVtHohYSsc5rSw1PR7A/oS4XuPLCwlLsvQzQz3+S+KVgxxFKIPGjv6Oom?=
 =?us-ascii?Q?GBUjDrXHjxbsEx898Og/j9gNqIYk+yVFFeEcj0lDn4mMCu8DxA8OGIDWCMtJ?=
 =?us-ascii?Q?jhkJ/iFRKZR6jfNmKpAZEWp99qu08UM8M4YGHyDFhG8rVCL9bTP5ePGPST/c?=
 =?us-ascii?Q?qmC8qM23P3WVQ9nC87pymIDaql3JDYo9r99ku1QS/LF+ip9E2gXNpnQHltD2?=
 =?us-ascii?Q?TwfSX42ma1QEfQqV6No1R/fsSoL0L39Ir3QDUb0JbU9zcT+P7onYnsdtHx/U?=
 =?us-ascii?Q?wan7qf4FVJtBPttnyPena9cjWXDmSto6l29S9pzHYeKpASaeSic3ewr8r2DE?=
 =?us-ascii?Q?/DXlCdKVpb3SeaEdG+C93m0CAFs2SN0awkzRlmYDOeyGNhoDlQLeaOK1dSIF?=
 =?us-ascii?Q?6IZ8q9GjjZL/edvozT7aCnKpIWF/gajG2PqB05OP5oLws6Kp68jonFr+2t/K?=
 =?us-ascii?Q?o6Avc/Pk9x+gTM75+2lE2TNDdbtLDQarv5AtmrmBOyHOmsAC+6EqL2iJTyEo?=
 =?us-ascii?Q?2UARPkQGEozurk2lNlwMZ8SS3O7UbTSwmwrWnJ/0qCemvKfLxiUqwlTMvHwP?=
 =?us-ascii?Q?80DkZ8mEq5aD57uNDg4oC7wcxO/vrPeAoK48gDMI5wX8Ks04WJiK5Ryy/nUh?=
 =?us-ascii?Q?/G9pQclED7np9gexhZNf+84Zh4lFSOR8AQsSQ+6S1SKDezkjgNLlMVV7OoZW?=
 =?us-ascii?Q?aD2+WV4PUcHZ+q3lZtwr+RxrM5xQTgIfLt6J2XJSRtHRAKn89sYb9SYFmrtO?=
 =?us-ascii?Q?6uRixKkVnOXYrWQmUo5cNk6lwm/ARYYEbLvcj1gH/2hp/tM44m5zpLl6O/wT?=
 =?us-ascii?Q?pGmZHf0o6fF30nZ39015smjN0wqmSOvXVxInOJ8lbJzM6hp2wYnO9x8eu74S?=
 =?us-ascii?Q?x3zfRu2zmXV9iAsRX6kJf1bkPQ2apzqJ3ye82D/EPF6Vs00vrvZpQ3e7GqxF?=
 =?us-ascii?Q?ycrCP8QSgtK5Oop2KH6lBm1GdHMNtm37tPmESgX43yj21R5GMoQ2A3FMD8fB?=
 =?us-ascii?Q?en8Od3E4HR2BrqWGdHN5I9GhfAzjm+8j3tthu2d4hlpcfsJre2kwIwNmFo6x?=
 =?us-ascii?Q?LTa/p7PvDO2ru9dwvYKHpznfwQkezM03E1ZvV+TKm/VXEIzOOA0RsEtxz+QV?=
 =?us-ascii?Q?c67+xBlu78uFCDU6FOZgBf1Y1QIUkTJ7F0jklqMUOxoeVE31IwEL1djTmjoG?=
 =?us-ascii?Q?CqGYKS9+2G28oenldbwZd+9Ufk8VhaS85VjkEBJKij/2BMmavBEimhpmq0/s?=
 =?us-ascii?Q?j3OPETyEK5IJMcug7rumoQndYPUekRyxXh2+1VwRRI2fdCTo2nCmoVPTiHzZ?=
 =?us-ascii?Q?RWt8+yr0dg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6ad4a778-1ec1-4ec4-4f73-08da46a5e8e2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 He3TSVYflC8Ea1IK9guzvso7v3UJb660VZUepiaOmISFf2NAKuDHRll7qpWaRynQpMSn08/UVswLzM8qA/t34A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4529
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: GuUJIADuxNvCnwI_5ZtklLUzQr9Ib4FG
X-Proofpoint-GUID: GuUJIADuxNvCnwI_5ZtklLUzQr9Ib4FG
Reporting-Meta:
 AAGSHL4xC5lGd62aMzI9fQuA2RloOYEJiAg+cY3Sb7GRNdhxGTe5hBT2QKJbrK2B
 WfURGXE3W/rOaBkVerwVAF6hFfyWjtPqSJKytJMjHwgraL64mqIXQ/lQCytkWiR6
 g+kRg5Vc5JQRh33ASJoxGVbZRllPxX+e8LrQVdaUGf0AhPeD5JwLkP+t1GTTosts
 Cy9R2KIU/4a+7IQFW94zUY0O1JhFKa1mK2ldWSjDDtPQcYBAX1qRJsQJGO8xoLoE
 Ejwi665IqswfRSpNW1pDqi9QYrnu0PpBgqr58xO9v81CqFmAi4VDnYzYWct9/aaR
 REOjuHYaR/JkCNfTK0FwlfqmsVaeFm+cpwwixcZCwvAr2K2awkB9e09vAY6rxzWO
 wIE+C1rkiDI/lbIH1ca+OOpw7arWrnaMHqZfDUyjERgHV6xu9PsC4ktSMoiAYEri
 5jfHcKYksvbOB7GnuYEzuZD5aYrkDPHJWLt5UsukN67idhMaM8Pk8YrFgSb8jw4H
 9q0/auXgDL+azhgkJofVY9N0Ke0nDNUYD74Xa6viFlsQ

T24gNi81LzIyIDEwOjQwLCBKdW54aWFvIEJpIHdyb3RlOgo+IAo+PiDlnKggMjAyMuW5tDbmnIg0
5pel77yM5LiL5Y2INjo0OO+8jEhlbWluZyBaaGFvIDxoZW1pbmcuemhhb0BzdXNlLmNvbT4g5YaZ
6YGT77yaCj4+Cj4+IO+7v3NvcnJ5IGZvciBteSBsYXN0IHJlcGx5LiB0aHVuZGVyYmlyZCBtZXNz
ZWQgdXAgZm9ybWF0LiBJIHJlc2VuZCBteSByZXBseQo+PiB3aXRoIG5lb211dHQsIHBsZWFzZSBj
aGVjayBpdC4KPj4gKG5vIG5ldyBjaGFuZ2UgYmV0d2VlbiB0aGUgbGFzdCBtZXNzZWQtdXAgbWFp
bCBhbmQgdGhpcyBtYWlsLikKPj4KPj4+IE9uIFN1biwgSnVuIDA1LCAyMDIyIGF0IDEyOjQ4OjE4
QU0gKzAwMDAsIEp1bnhpYW8gQmkgd3JvdGU6Cj4+Pgo+Pj4KPj4+Pj4g5ZyoIDIwMjLlubQ25pyI
NOaXpe+8jOS4i+WNiDQ6MTfvvIxoZW1pbmcuemhhb0BzdXNlLmNvbSDlhpnpgZPvvJoKPj4+Pgo+
Pj4+IO+7v09uIDYvNS8yMiAwNjoyNywgSnVueGlhbyBCaSB3cm90ZToKPj4+Pj4+IE9uIDYvNC8y
MiAzOjEwIEFNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4+Pj4+IEhlbGxvIEp1bnhp
YW8sCj4+Pj4+Pgo+Pj4+Pj4gT24gNi80LzIyIDA2OjMxLCBKdW54aWFvIEJpIHZpYSBPY2ZzMi1k
ZXZlbCB3cm90ZToKPj4+Pj4+PiBXaGVuIHVubGluayBhIGRsbWZzLCBmaXJzdCBpdCB3aWxsIGlu
dm9rZSBkbG1mc191bmxpbmsoKSwgYW5kIHRoZW4gaW52b2tlCj4+Pj4+Pj4gZGxtZnNfZXZpY3Rf
aW5vZGUoKSwgdXNlcl9kbG1fZGVzdHJveV9sb2NrKCkgaXMgaW52b2tlZCBpbiBib3RoIHBsYWNl
cywKPj4+Pj4+PiB0aGUgc2Vjb25kIG9uZSBmcm9tIGRsbWZzX2V2aWN0X2lub2RlKCkgd2lsbCBn
ZXQgRUJVU1kgZXJyb3IgYmVjYXVzZQo+Pj4+Pj4+IFVTRVJfTE9DS19JTl9URUFSRE9XTiBpcyBh
bHJlYWR5IHNldCBpbiBsb2NrcmVzLiBUaGlzIGRvZXNuJ3QgYWZmZWN0Cj4+Pj4+Pj4gYW55IGZ1
bmN0aW9uLCBqdXN0IHRoZSBlcnJvciBsb2cgaXMgYW5vbnlpbmcuCj4+Pj4+Pj4KPj4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+Cj4+Pj4+Pj4g
LS0tCj4+Pj4+Pj4gICBmcy9vY2ZzMi9kbG1mcy9kbG1mcy5jIHwgMTQgKysrKysrKysrKystLS0K
Pj4+Pj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQo+Pj4+Pj4+Cj4+Pj4+Pj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMgYi9m
cy9vY2ZzMi9kbG1mcy9kbG1mcy5jCj4+Pj4+Pj4gaW5kZXggZTM2MDU0M2FkN2U3Li5hMTIwNjEw
ZGZmN2UgMTAwNjQ0Cj4+Pj4+Pj4gLS0tIGEvZnMvb2NmczIvZGxtZnMvZGxtZnMuYwo+Pj4+Pj4+
ICsrKyBiL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMKPj4+Pj4+PiBAQCAtMjk2LDE3ICsyOTYsMjUg
QEAgc3RhdGljIHZvaWQgZGxtZnNfZXZpY3RfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKPj4+
Pj4+PiAgIHsKPj4+Pj4+PiAgICAgICBpbnQgc3RhdHVzOwo+Pj4+Pj4+ICAgICAgIHN0cnVjdCBk
bG1mc19pbm9kZV9wcml2YXRlICppcDsKPj4+Pj4+PiArICAgIHN0cnVjdCB1c2VyX2xvY2tfcmVz
ICpsb2NrcmVzOwo+Pj4+Pj4+ICsgICAgaW50IGRlc3Ryb3llZDsKPj4+Pj4+PiAgICAgICAgIGNs
ZWFyX2lub2RlKGlub2RlKTsKPj4+Pj4+PiAgICAgICAgIG1sb2coMCwgImlub2RlICVsdVxuIiwg
aW5vZGUtPmlfaW5vKTsKPj4+Pj4+PiAgICAgICAgIGlwID0gRExNRlNfSShpbm9kZSk7Cj4+Pj4+
Pj4gKyAgICBsb2NrcmVzID0gJmlwLT5pcF9sb2NrcmVzOwo+Pj4+Pj4+ICAgICAgICAgaWYgKFNf
SVNSRUcoaW5vZGUtPmlfbW9kZSkpIHsKPj4+Pj4+PiAtICAgICAgICBzdGF0dXMgPSB1c2VyX2Rs
bV9kZXN0cm95X2xvY2soJmlwLT5pcF9sb2NrcmVzKTsKPj4+Pj4+PiAtICAgICAgICBpZiAoc3Rh
dHVzIDwgMCkKPj4+Pj4+PiAtICAgICAgICAgICAgbWxvZ19lcnJubyhzdGF0dXMpOwo+Pj4+Pj4+
ICsgICAgICAgIHNwaW5fbG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4+Pj4+PiArICAgICAgICBk
ZXN0cm95ZWQgPSAhIShsb2NrcmVzLT5sX2ZsYWdzICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKTsK
Pj4+Pj4+PiArICAgICAgICBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4+Pj4+Cj4+
Pj4+PiBUaGlzIGFyZWEgY29kZSBkb2VzIHRoZSBzYW1lIHdvcmsgaW4gdXNlcl9kbG1fZGVzdHJv
eV9sb2NrKCkuIFdoeSBub3QgdG8gZ2l2ZSBhbm90aGVyCj4+Pj4+PiBlcnJubyAoZS5nIC1FQUdB
SU4pIGZvciB1c2VyX2RsbV9kZXN0cm95X2xvY2sgd2hlbiBsX2ZsYWdzIGNvbnRhaW5zIFVTRVJf
TE9DS19JTl9URUFSRE9XTi4KPj4+Pj4+IHRoZW4gY2hhbmdlICdpZiAoc3RhdHVzIDwgMCknIHRv
ICdpZiAoc3RhdHVzIDwgMCAmJiBzdGF0dXMgIT0gLUVBR0FJTiknCj4+Pj4+IEkgZG9uJ3QgdGhp
bmsgd2Ugc2hvdWxkIGRvIHRoYXQuIEl0J3MgcmVhc29uYWJsZSBmb3IgdXNlcl9kbG1fZGVzdHJv
eV9sb2NrKCkgdG8gcmV0dXJuIEVCVVNZIGluIHRoYXQgY2FzZS4gRUFHQUlOIGlzIGZvciB0aGUg
Y2FzZSwgeW91IGludm9rZSBpdCBzZWNvbmQgdGltZSB5b3UgbWF5IHN1Y2NlZWQuIFRoYXQncyBu
b3QgdGhlIGNhc2UgaGVyZS4KPj4+Pgo+Pj4+IEkgYWdyZWUgdGhlIEVBR0FJTiBpcyBub3QgZ29v
ZCwgYnV0IGRvIHlvdSB0aGluayB0aGUgZXJybm8gaWRlYSBpcyByZWFzb25hYmxlPwo+Pj4+IHVz
ZXJfZGxtX2Rlc3Ryb3lfbG9jayBvbmx5IGhhcyB0d28gY2FsbGVyczogZGxtZnNfZXZpY3RfaW5v
ZGUgJiBkbG1mc191bmxpbmsuCj4+Pj4gdGhlIGNvZGUgbG9naWMgaXMgY2xlYXIsIHdlIGNhbiBj
aG9vc2UgYW5vdGhlciBlcnJubywgb3IgZXZlbiBjcmVhdGUgYSBuZXcgb25lLgo+Pj4+IGl0IGNv
c3RzIHRvbyBtdWNoIHRvIHVzZSBzcGluX2xvY2sgdG8gYXZvaWQgcHJpbnQgYW4gZXJyb3IgbG9n
Lgo+Pj4gUmVnYXJkaW5nIGNvc3QsIHRoZSBzdWdnZXN0ZWQgd2F5IGhhcyBldmVuIGhpZ2hlciBj
b3N0LCB0aGUgc3BpbiBsb2NrIGNhbuKAmXQgYmUgYXZvaWRlZCB1bmxlc3MgeW91IGRvbuKAmXQg
YWNjZXNzIHRoZSBsb2NrcmVzIGFuZCBhbiBleHRyYSBmdW5jdGlvbiBjYWxsIHdhcyBhbHNvIGFk
ZGVkLgo+Pj4gQWN0dWFsbHkgdGhhdCBmdW5jdGlvbiBzaG91bGRu4oCZdCBiZSBpbnZva2VkIGJl
Y2F1c2UgaXQgd2FzIGFscmVhZHkgaW52b2tlZCBvbmNlIGluIHRoaXMgZmxvdy4gSSBkb27igJl0
IHRoaW5rIHdlIHNob3VsZCBjaGFuZ2UgcmV0dXJuIHZhbHVlIG9mIHRoYXQgZnVuY3Rpb24sIEVC
VVNZIGxvb2tzIG1vc3QgcmVhc29uYWJsZSByZXR1cm4gdmFsdWUgZm9yIG1lLgo+Pgo+PiBJIGNh
bid0IHNlZSB3aHkgbXkgaWRlYSBjb3N0IG1vcmUuCj4+IFRoZSBwYXRjaCAoJ05FV19FUlJOTycg
c2hvdWxkIGJlIGNoYW5nZWQpIHdpdGggbXkgaWRlYToKPj4KPj4gZGlmZiAtLWdpdCBhL2ZzL29j
ZnMyL2RsbWZzL2RsbWZzLmMgYi9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jCj4+IGluZGV4IGUzNjA1
NDNhZDdlNy4uZGQ0NzU1NmIwN2ZhIDEwMDY0NAo+PiAtLS0gYS9mcy9vY2ZzMi9kbG1mcy9kbG1m
cy5jCj4+ICsrKyBiL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMKPj4gQEAgLTMwNSw3ICszMDUsNyBA
QCBzdGF0aWMgdm9pZCBkbG1mc19ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQo+Pgo+
PiAgICAgIGlmIChTX0lTUkVHKGlub2RlLT5pX21vZGUpKSB7Cj4+ICAgICAgICAgIHN0YXR1cyA9
IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygmaXAtPmlwX2xvY2tyZXMpOwo+PiAtICAgICAgICBpZiAo
c3RhdHVzIDwgMCkKPj4gKyAgICAgICAgaWYgKHN0YXR1cyA8IDAgJiYgc3RhdHVzICE9IC1ORVdf
RVJSTk8pCj4+ICAgICAgICAgICAgICBtbG9nX2Vycm5vKHN0YXR1cyk7Cj4+ICAgICAgICAgIGlw
dXQoaXAtPmlwX3BhcmVudCk7Cj4+ICAgICAgICAgIGdvdG8gY2xlYXJfZmllbGRzOwo+PiBkaWZm
IC0tZ2l0IGEvZnMvb2NmczIvZGxtZnMvdXNlcmRsbS5jIGIvZnMvb2NmczIvZGxtZnMvdXNlcmRs
bS5jCj4+IGluZGV4IDYxN2M5MmU3YjkyNS4uOTNiOGQ3YmFkOTZlIDEwMDY0NAo+PiAtLS0gYS9m
cy9vY2ZzMi9kbG1mcy91c2VyZGxtLmMKPj4gKysrIGIvZnMvb2NmczIvZGxtZnMvdXNlcmRsbS5j
Cj4+IEBAIC02MDAsNiArNjAwLDcgQEAgaW50IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jayhzdHJ1Y3Qg
dXNlcl9sb2NrX3Jlcwo+PiAqbG9ja3JlcykKPj4gICAgICBzcGluX2xvY2soJmxvY2tyZXMtPmxf
bG9jayk7Cj4+ICAgICAgaWYgKGxvY2tyZXMtPmxfZmxhZ3MgJiBVU0VSX0xPQ0tfSU5fVEVBUkRP
V04pIHsKPj4gICAgICAgICAgc3Bpbl91bmxvY2soJmxvY2tyZXMtPmxfbG9jayk7Cj4+ICsgICAg
ICAgIHN0YXR1cyA9IC1ORVdfRVJSTk87Cj4+ICAgICAgICAgIGdvdG8gYmFpbDsKPj4gICAgICB9
Cj4+Cj4+IHlvdXIgcGF0Y2ggYWRkZWQgbWFueSBjb2RlcyBhbmQgYWRkIGFub3RoZXIgJ2lmJyBi
cmFuY2guCj4+IC0gdGhlIG1hbnkgY29kZXM6IGNwdSB3aWxsIHNwZW5kIG1vcmUgdGltZSB0byBj
b21wbGV0ZSB0aGUgc2FtZSB3b3JrLgo+PiAtIHRoZSBuZXcgYWRkZWQgJ2lmJyBicmFuY2ggd2ls
bCBicmVha3MgY3B1IHBpcGVsaW5lLgo+Pgo+PiBteSBwYXRjaCBvbmx5IGNoYW5nZXMgMiBsaW5l
cywgbWF5YmUgYWRkIDIgbGluZXMgY3B1IGluc3RydWN0IHdpdGhvdXQgYWRkaW5nCj4+IG5ldyBi
cmVha2luZyBjcHUgcGlwZWxpbmUgY2FzZS4KPiBZb3VyIHBhdGNoIGludm9rZWQgdXNlcl9kbG1f
ZGVzdHJveV9sb2NrLCB0aGF0IHdpbGwgZXhlY3V0ZSBhbHNvIHRoZSBpZiBhbmQgc3BpbiBsb2Nr
LiBQbHVzIGZ1bmN0aW9uIGNhbGwsIHRoYXTigJlzIG5vdCBoaWdoZXIgY29zdD8KClRoYW5rIHlv
dSBmb3IgeW91ciBleHBsYW5hdGlvbiwgSSBnb3QgeW91ciBwYXRjaCBtZWFuaW5nLgpZZXMsIG15
IGlkZWEgY29zdCBtb3JlLiBMZXQncyB3YWl0IGZvciBtYWludGFpbmVyIGNvbW1lbnQuCgovSGVt
aW5nCgo+Pgo+Pj4+Pj4KPj4+Pj4+PiArICAgICAgICBpZiAoIWRlc3Ryb3llZCkgewo+Pj4+Pj4+
ICsgICAgICAgICAgICBzdGF0dXMgPSB1c2VyX2RsbV9kZXN0cm95X2xvY2sobG9ja3Jlcyk7Cj4+
Pj4+Pj4gKyAgICAgICAgICAgIGlmIChzdGF0dXMgPCAwKQo+Pj4+Pj4+ICsgICAgICAgICAgICAg
ICAgbWxvZ19lcnJubyhzdGF0dXMpOwo+Pj4+Pj4+ICsgICAgICAgIH0KPj4+Pj4+PiAgICAgICAg
ICAgaXB1dChpcC0+aXBfcGFyZW50KTsKPj4+Pj4+PiAgICAgICAgICAgZ290byBjbGVhcl9maWVs
ZHM7Cj4+Pj4+Pj4gICAgICAgfQo+Pj4+Pj4KPj4+Pgo+PgoKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2Zz
Mi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlz
dGluZm8vb2NmczItZGV2ZWw=
