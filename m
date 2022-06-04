Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F6FC43334
	for <ocfs2-devel@archiver.kernel.org>; Sat,  4 Jun 2022 08:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Jt4I/wnYTD/BfB84qYqwbOwa8PFORdJ80WNB+BJJElk=;
 b=AUV6dU+6yumZ1p5PDbmAid0DBY+Pwij5nUqkOYek2joeboEuQqhZuce6IStRnVX/EaEzqMUl1rxQ
   IVazd9Ai9r7tOv1A7hGxf3bMKLtm8CKspqGGqLkISl3XRSDPyvq9zSVDVET31Ba4FGCOOXH5+Ycz
   t6CQtAsElHvGQAM4Ra6KmT8ax5E4nbtQQogWFMFG6P3xcykSDpfPqJSfnqqWH4rJKchZ6yX2SzWs
   nKbauIKBmdQdwxMv7bifbP/6HiS7igHQiCWKvn63q7erSuoNwuVEE/NZYiKH4PDgNp0Z056YlEMe
   S5VgU+UGc4AJGGJ6vE7Pb4XKvuOih0RAJyFi4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Jt4I/wnYTD/BfB84qYqwbOwa8PFORdJ80WNB+BJJElk=;
 b=OzkKCGkbCPo//e3hbw7wsHY1JF9fbVn1hUI30RoUiYWglmuudWYe2ccR87cm3iGLWpnOqTfCWFra
   fiDtKjk9mC8ONk8zWo5vgNldGcJ7JbzErozp0BBrtAFiQxH7ttUt+I3ez2S6uidpj5Qcpg22Ofl+
   l9YcAWXTl9568MQf9ozKF6iXNFnBgEv5XufN4F/3RQ0lFq3/3gG+b+HYx1LrIqiknxgrt6GNpfN6
   /QuKjGkAwrduWYW7aCAtZ1rP5hq9lk44o9zIxJFKZE5DHod7E95cVt0hGvc8+fPW9dp5doedNhw9
   VatuIPcxTmM9p9GyrJy9mJVg4VW3cswe5pwTFg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCY00NVQ38JN930@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 04 Jun 2022 08:50:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654332323;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=04xg2YC3j1BSpqWUSYEultw7W3oeLAl8ZpcNqS5Wiag=;
 b=Q70bng8w/4VYlbizGRL7IjY659AMHyY2G14gZ6P7wIn+hPtJNpjs6EdAIsFz+vpXUu4nih
 n3b0ao4X4zRUoqpUmta5ht/oOKnFIZJZxRdEZYsn2qqKV2d6vlw9j7aEncAMHY5oehbcux
 CTTHEENpDEHV219fOBoQ6BLclCPs/GY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654332623;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=04xg2YC3j1BSpqWUSYEultw7W3oeLAl8ZpcNqS5Wiag=;
 b=NINUYLeAYJ/19yxWRjVYOLlTLfurZIQ5DnmaXf4VSkz1z02wo50tiwtKuHB16EcmwPM7gH
 6SkeITOoVaHlPHdvYy4KW6I/nntmHIun5O3Ny2hkMvButkjUPy1k0+XM569zIYaea07F88
 PN/fgwEPYD6FQheiRgplQUWdw4OyWQE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0pRidYxrXonSwfcJ4hjIuMLxqqGgQzuPE8XQZ0QwzVDokxOezEDOXA8QhDOkQleDZV1SDj3iskc75HL+KmOBD3+tnQ8hkZWX7i/3tZemh5zkYv2Q82wXAWtv8dvg9Le1z+90TyXGWgtQKere0Mesh1b6hj7+1lfOUXh2FyDhB3ziMJYRHeROQpKZX9ndrx4nanZmWPpHrEARiKPi3zjn0x5qDfu6wO9NchY4aNmDGdGW46KolNgVfisyEl41mmaoHV2LHNpfqcz5JUyEJM10CT7I66jquJI0ulwxmOoHz3JfPJ9wXnaCyxApZZqIGC56PZSPh4JFiG9ZqskqGzW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04xg2YC3j1BSpqWUSYEultw7W3oeLAl8ZpcNqS5Wiag=;
 b=WNjKApWkfHLVIuQ8gEZsZwdJQnL0KB12fQswxWgSB7uN0Fqoy7KQx08kx7jDXv5vUdwGQzRIMnAOtUZNOVbSQcVWxvYtUsjAfI+XHh9tMVG3rXMRnNmEoME8zVLs5aNgpNHj5cAOSXIuJFktdZMM4YiKkDeJNedmi/EM+BM2HwSyrgO9V+FcgNw7UFNI6Q4xBQlxFrov3qj7kgVILuu69y3NgSOGiMENkzLyCxpu3Injw3IS7JrzWSvzk51nH7NaK7Qpobvwk44XXWZXcRn60BBGJ0fAF9ehAeXunj7g7hiRcyOl/FL3GWnHW5r9a/eSIGU6xyxfpG7WuV8UAJOmdw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <3d75bcfa-4841-91cc-ade8-6f85f3d2f6db@suse.com>
Date: Sat, 4 Jun 2022 16:45:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220603222801.42488-1-junxiao.bi@oracle.com>
In-reply-to: <20220603222801.42488-1-junxiao.bi@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(31696002)(5660300002)(8936002)(66946007)(8676002)(66556008)(66476007)(86362001)(2906002)(6512007)(6486002)(31686004)(6506007)(6666004)(53546011)(508600001)(26005)(36756003)(38100700002)(2616005)(83380400001)(316002)(186003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 08:45:19.6458 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10367
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=162 bulkscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 clxscore=183
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206040042
Subject: Re: [Ocfs2-devel] [PATCH] Revert
 "ocfs2: mount shared volume without ha stack"
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
X-MC-Unique: sC7g0CYRNK2z1aIPWmIuzw-1
X-ClientProxiedBy: TYAPR01CA0024.jpnprd01.prod.outlook.com (2603:1096:404::36)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a54ba8-4c2e-4229-2f44-08da46068e06
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2541:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0401MB2541E7FE99A20E13E6A3FAD997A09@VI1PR0401MB2541.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 hHI9afx67nqtgrR2wUYmlyKRSwDs6LtPYT4kOhJGZ5Oa7kiT+ZAydiLEuyAIa40MFo8z+EnIGFnvQHcDJ/IFrOW5ZX8aiKA333tV+LTISUhEOk90683tRA/l+aXOh1Gvj2qcOVb/K1OzLhpuknLJ+njyMErzrB0lq7aGUWvXIMirIoIwj2z7SkSkSoNw11QgDmy7bmMVWsQLxrpGjJgPy80ZoVNwWW4omMfZyRQeD/2qBOOuyMlCGOFYmJ1vAaHv4qKfBuhIihYpmU7sLik6WXGesBQ79VoFfqQYGef7fVkZUpqNpmrorCL4GBbe7Yf0f9l27ky9DoWvqymbsx2fEiru3W2B/ScVBTrCI2myaNl5xdX+GEjrE8gHc+4qtPdJfIVuOYItk4icaJRzBMHxiE1JbXw4L7AAV6xCAmh62JRjZP51lfxWXkbxtpsmSkww9EU5Q/fOd1xSfhvb2V5ocOzI8V7P0UFGI0xWL+X41GOZDhmeQ8F+8xA7v1chA8qDoFJcvSApYkqXKEx/tq12jp72TY4xC/7BmOrVaUtGSgzUbMmJm+YqPKiewJAWuWGq6JCrGGGBeynmTwpHXSy0yVTtkCbKzk3KDoXDybJhj+42nw6Q4dzUuZjDX+q6SLmJm7jkHEeha+lzcz/DMzTVivM6Si6NqlitNCK3c4eAWO5ovmd5Q/fcAaT0qJGELjDt2kIFkjGbiQqtlOG2xhuuFA2OiyzvjJ3kEWWNFAOq8UI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bE9LZmZ3SVdIcWlBNnlIWGpoSXZpSlFYb0V2Y0tIaVFWYWtzdzM1RjljamJI?=
 =?utf-8?B?R0NjSHkxVHdYM255WU15THpFVnR1RFNnL0FjNUtwWS9raFZYdmJWRTkwL0Ix?=
 =?utf-8?B?NVhiUXA3Umd1TDdQcWRqMURQOXBkVXlZOXRKUEVrUkt1ckxKREpWeVkva29x?=
 =?utf-8?B?TlV1cldwbndYa1k3cWdISTl1d3N0aWkvUHMybVdiWlZLdDlqYndZZVJoWWQ1?=
 =?utf-8?B?RkthcXhxa0FyZzZHMXZEL3dRL3Byc2dmbFVORVZ6NzBYbGhwSHkxSXZWd0Nq?=
 =?utf-8?B?WFplQkJqMmtKRTFlT2NPVGxpYTdzN0dyNlpGMjlpMjU4VEJXS2hnU3ArTzZF?=
 =?utf-8?B?b2hiSi92RG5sZmVUUTZ1MWQ3V205dzltenF0Sm41bjNWUUMwRytvWUwrQnV5?=
 =?utf-8?B?ZlhPMTBYTG4xSnRKL2VjWklEV2tCNWs0c2xMYUpPVG5CdVVRQVpkWXNQbkM5?=
 =?utf-8?B?Z21Vdi9aSmhXQnk3dExya0xROElxcU90Rno0N2dqcEpZaXZPVXJ2cVFneHU0?=
 =?utf-8?B?RGlYN1dPWkxSZ09ibkoyT0tHWVJXV0xhbmROVXhpb2xKdUVwN1FtNURzM292?=
 =?utf-8?B?R0JST0NJeWhOUlovdTFFQ1NDYmpzRVhmSWRKOTZrN2NKYS84eHNPV21EWDk2?=
 =?utf-8?B?NHE5OWZSQURURWsvU0pJandxeldzVVphRHoxb1N2eFhVbXNiY3d3WEJscUFy?=
 =?utf-8?B?Q0VQOFl6WHRoVVJBUnFETEVzRzduRzJKL2hYbktQWnZ1bzN6YjJhZ2NFMlhN?=
 =?utf-8?B?bGQ1UDJRS0dhZUpsWFprL2JCT1V3ajlCTitvMnpMRFBwVEoveUZ4VjU1RHQr?=
 =?utf-8?B?U0FoOHVqQU1FUnE4SWlOb0hZUUliR0EydkNqZzZVZEZzcnNqZU45Vk5nV1pJ?=
 =?utf-8?B?SHA1MlFxL1NyZjQ5c1BvYlRSY2ZEdFNuNDZCenNObzFEVGJzN1NrM0NLV3Jz?=
 =?utf-8?B?QWpFbmZ6eFVjc2RjeDJxSkxFK3FTU0duU3YzU2N1eDRtSExnZmV3RHRlZDhs?=
 =?utf-8?B?cDhPaWJ5V1QxMFlTNDA4MkV5UHFKR2w4Vnk2U25rY2lsV0U5UjZMZzMweVB6?=
 =?utf-8?B?UjEvWmsvQks5RG5PZ0RZQUMyWmRZdHBOUlBTZzVJVFhxbGVaZUdEdTJoV3lC?=
 =?utf-8?B?aXNyRE1OOWszeC8zd1VxK2VReHVlRTJUR3FuRmRqUFpLUW1JR1JVQ1hMNVF1?=
 =?utf-8?B?Ky9STDlXYVlyWnd6MEFyZjBFdTgyR2xHcWhXM2VrODJodE1mcVpaREN4MWU2?=
 =?utf-8?B?YWxIdG9PVFpWYXVNQytoY0dneG03aEQ3cTYvUlplQXlxUDB2Ync5ajFJMTda?=
 =?utf-8?B?dDlGc0cyQWNiZGpDNjdMTDQ0SkQ3cEgxUHpZWGhtbk0vVE5BS2RmSnFnWW05?=
 =?utf-8?B?aFVHY2RqajJzb3RTcVZDU05TOFdkZ0taaldpUGd2RzFMN3FUWllEVEEyZEdS?=
 =?utf-8?B?dmxSQ3owS1A0WjRXWURZTXhlZ0FvVFUzRjZiRlNEaG5YVXV2MENZd053TmNx?=
 =?utf-8?B?S3U4WXZ3Rmw0ZXRwSWlKNEllaUxFY25IMHREUFIrZ2dzZko5VzBGRzhvYTM0?=
 =?utf-8?B?QzNXTnlGQVdDQnJKbGNYMS9MRW5nQWRnZzNybnorcVhzTk1YZ0pmMkd2Vkxz?=
 =?utf-8?B?d3NNQWl2TGVMeXVWaFBpYjkvUklHNXlob0orVjFJY3JtRE5MSDF6S3RaV2tB?=
 =?utf-8?B?UlhaellpRWt4MitXKy9vSlVaRXFvb0hYc3dVZzFpR1p1bkRBL1VaSndMTXNz?=
 =?utf-8?B?WjlXY3JjQTdmS0FyWXk2RkR3eFRCOXkyR3hkVllYWGFVOUkvWFljdUJxU05J?=
 =?utf-8?B?UnJhR2JmcXZyRmtiZzFxS3pTd2lJNkdFdUtmUzZHTWlJczlGOW9CSDhQa0ov?=
 =?utf-8?B?ZDRNcGFYTE0xUHUrYVNxei83YXExUFplNHFQYU0xTzFndmNMUzU1OWY5ZkVB?=
 =?utf-8?B?ZllBR3YvRXBkRkNZa2RqSVlib1RZNkxpVkIxbUVKa0IyRHFGMWJ4T3dBWUJ1?=
 =?utf-8?B?QjJ0YmptZFQ0SGJsaG40NjF3RmRiaGxSUzVycVQvWUhFZVJqWHlWbjRpdnAr?=
 =?utf-8?B?Mm1BQjZlOTFCMndRRXhEVUZOZ3ZldVFhSEJ6bzMzOVFudjZQSkFJNnpSangz?=
 =?utf-8?B?OStNVjRUNlZLaHY3UldScTZkeEZwQkRwM0crVmgzbENha3d2K2VnZWQzTkJz?=
 =?utf-8?B?UU9pQXBZMTJXb2dsU01Edk5wNU90UWVrRnV4b3kyWE8rTlZpenYrU3JObGZp?=
 =?utf-8?B?MXFHMnE2OGt5d2hLWnkzblhDV0I5QXlTMTl3M1FUSk1VNHc5REwwQlp4c3ZM?=
 =?utf-8?B?bTF2TThIQXcySmVMbGkxcDZ3TXlJN2Q1YlNFWU9xVkE4QXVQN1FGUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e6a54ba8-4c2e-4229-2f44-08da46068e06
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 8r8M6QaUIiiF5ihKj5jQWrCYw1jLIObzKcMajaog/y4UfGxSvTr22ndjzkB5ZHLg3VOfnsgVgF6xX7EFnxIp+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2541
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: kguZYvyvdsyQh3FtGLpooG0a-wUJ1CKx
X-Proofpoint-GUID: kguZYvyvdsyQh3FtGLpooG0a-wUJ1CKx
Reporting-Meta:
 AAE3+x6sAh4xupwanUuEKVMq5AKEaOTS+HDAB5LaQP31MnfWrPCc36Io7RtOh6dS
 cMFieBgjjKk98zaibET4kYnmL+J2zMfdwUYaS6ax8Xh+dLxpjwwpDlmI4Hue+cVv
 Zfn3J39ctxrDJLW0/6qz1sPNdmdCE57AmIodjfRw16q7LyLfHIOyjs8xkHcn9hUE
 72z9zxKDXP9nolQ34wwNmXYWjAfzbjxP7I3h4Nsh61OfGPRZu/wIampKo198q3JJ
 shr+kLzP8ylq0B+PnPtQ2BGup5w+suhi/5SxxrsDIpzE4e9iQzXpJ2avqb9Fnr1y
 GBXPkFt5tXa9o9caD0QtlLQvVghfinqhqhRZfdCGVCtGz/hI3qVlg9rihpINXnrC
 2bYc4D0nRFNy2E7QBu9LyE3IA41NLFEG5Yg5ie1zRWfVtQrewN2GAG0CjksUKU3x
 domU6+07Rq8dxhmYQmoySCX5neuP+3DJecL46cjVQkxQCqilKIIG5xbC/XTo/kY1
 P4ci3HiCrPpSt/fOkg+vzJIUQlZzQy57KvN2F727VQ==

Hello Junxiao,

On 6/4/22 06:28, Junxiao Bi via Ocfs2-devel wrote:
> This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.
> 
> This commit introduced a regression that can cause mount hung.
> The changes in __ocfs2_find_empty_slot causes that any node with
> none-zero node number can grab the slot that was already taken by
> node 0, so node 1 will access the same journal with node 0, when it
> try to grab journal cluster lock, it will hung because it was already
> acquired by node 0.
> It's very easy to reproduce this, in one cluster, mount node 0 first,
> then node 1, you will see the following call trace from node 1.

 From your description, it looks your env mixed local-mount & clustered-mount.

Could you mind to share your test/reproducible steps.
And which ha stack do you use, pmck or o2cb?

I failed to reproduce it, my test steps (with pcmk stack):
```
node1:
mount -t ocfs2 /dev/vdd /mnt

node2:
for i in {1..100}; do
  echo "mount <$i>"; mount -t ocfs2 /dev/vdd /mnt;
  sleep 3;
  echo "umount"; umount /mnt;
done
```

This local mount feature helps SUSE customers to maintain ocfs2 partition, it's useful.
I want to find whether there is a idear way to fix the hung issue.

> 
> [13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
> [13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
> [13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
> [13148.749354] Call Trace:
> [13148.750718]  <TASK>
> [13148.752019]  ? usleep_range+0x90/0x89
> [13148.753882]  __schedule+0x210/0x567
> [13148.755684]  schedule+0x44/0xa8
> [13148.757270]  schedule_timeout+0x106/0x13c
> [13148.759273]  ? __prepare_to_swait+0x53/0x78
> [13148.761218]  __wait_for_common+0xae/0x163
> [13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
> [13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
> [13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
> [13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
> [13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
> [13148.775401]  ? iput+0x69/0xba
> [13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
> [13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
> [13148.781756]  mount_bdev+0x190/0x1b7
> [13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
> [13148.785634]  legacy_get_tree+0x27/0x48
> [13148.787466]  vfs_get_tree+0x25/0xd0
> [13148.789270]  do_new_mount+0x18c/0x2d9
> [13148.791046]  __x64_sys_mount+0x10e/0x142
> [13148.792911]  do_syscall_64+0x3b/0x89
> [13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
> [13148.797051] RIP: 0033:0x7f2309f6e26e
> [13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> [13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
> [13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
> [13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
> [13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
> [13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
> [13148.816564]  </TASK>
> 
> To fix it, we can just fix __ocfs2_find_empty_slot. But original commit
> introduced the feature to mount ocfs2 locally even it is cluster based,
> that is a very dangerous, it can easily cause serious data corruption,
> there is no way to stop other nodes mounting the fs and corrupting it.

I can't follow your meaning. When users want to use local mount feature, they MUST know
what they are doing, and how to use it.

 From mount.ocfs2 (8), there also writes *only* mount fs on *one* node at the same time.
And also tell user fs will be damaged under wrong action.

```
nocluster

   This  option  allows  users  to  mount a clustered volume without configuring the cluster

   stack.  However, you must be aware that you can only mount the file system from one  node

   at the same time, otherwise, the file system may be damaged. Please use it with caution.
```

> Setup ha or other cluster-aware stack is just the cost that we have to
> take for avoiding corruption, otherwise we have to do it in kernel.

It's a little bit serious to totally revert this commit just under lacking sanity
check. If you or maintainer think the local mount should do more jobs to prevent mix
local-mount and clustered-mount scenario, we could add more sanity check during
local mounting.

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
