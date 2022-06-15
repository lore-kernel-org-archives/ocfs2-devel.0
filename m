Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DAE2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Jun 2022 04:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4TD7CQGWjXvucj5acjRufd0pxTKCHHjp2WGf7oGVDD0=;
 b=VbImhqhB21A1/s/cpaWl3j94CDOn0E8iIJx2WGsilMflKVSi2z2d4UOMOzcMNtI/HXfV51oFUtAe
   xXlVQsjXZtGdRCjnUfbcDqpjD0vhKmzC8drdn6zDLR4vWpGvs5tCqyiudQnxQ0bpnF7hnszH8ovJ
   EFmwkKfUcvZGR/EQ16uqe+O52Z/sU0rMkzFsSv1izX7fl7jc1K0eZbYnxHbCxIOzuFsYN4fl+u5m
   7EMduDY0UZ7LjUs4Avq8yPZO5JvlIpW8cbJej0IWI3D1Qvc2vGuMVTFIBn4re7FSfJAXL+873jbm
   ZfxdPVRZPVXglnqXpM3x3/vuFP4NaeCdEMNz2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4TD7CQGWjXvucj5acjRufd0pxTKCHHjp2WGf7oGVDD0=;
 b=ue7naGG/7efY27U/Ib4XZdwB1Jq1/bw2hvuJ5y0CME5KHfa2QTLteZPbuOYA4UNxoD3BQQqkHj7s
   v+n8oX+AvvhBtlahuAi5rbY5PzhwmRuSPUD3Z2m/ZiNVq5a4gXvq1cBU1CcXlcCV3w5kTu4ZGSAv
   rZOzwbv3eQwK8DzohymDNhqTTXuClSKG6FT2XpPS/foMwhhxCC3BW609Z5mqQDYadPxPqvfchQLZ
   2ZGlotwt/of9ghF2vhQqMs1D8QxrK2drGiqfuOxUIHCqZIcs0zhG9uwl2Ui/N9NeUZKqYJoPj+lx
   ovDtEBjqiFMJ6KEc4TXRChKL2Ja/cdVd/40s6A==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDI00MRS4VWGH50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Jun 2022 04:38:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWl99fEKVqyocI3gj+rDF7ujI7VRK1HE1yTc4CwrRPyvbOCjQEwdEf57pna2pBwJc1kyUtXymV//O1THmSgcTn57DLk4QcqQ1bEFStp5/mM4yIvNUIziSANvD09w9DA3u6QjB4WKehSeIzVTC9umKDO3nLWwDCuLVENj9r665KRcR/dtL/A66evpryZk/iqTs8EFdk5fy3FgrqIiYAOrlt/tMuWIKmFhtwDtHtv6UnKb6y486yEzwTyx3m4OpW6itNO+AWaacBwLqqPM/Js50Anr7CzXqMwbZKz/YQEVTsYGAWVCsX+kby277pA2X+8JFFl/DSbwh4C70KDPiIWC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ehlrxGGdKVqoy6QIq6Sx4VNnrLxx4gqA9Vxs+upEaE=;
 b=CCYShipDCrgswtjEIhWTsCXpbq7oK0AD8I6g2cixplY6zt8cEqHWV/WkjMm7PbEWd9cMnq0PPsCxtMBSd0su8EuZhs6KWg0s6VOry0A54Fg+bTUWrsFVKb4vPvleg29F4DAHKBrAAJIl4a0wHkoMVvgfS0pzRvqfBTWe1/Px6Bu/QmSzT9iXY0KscpKUB02a64yFvo1E8GjCNh+YTtSgkXAFylX3/n3mfCBHz1P0AiAhF8bTPeEJ1SRnaD48AAXVMnZZfl+ys+7jq1hUM3S5Y+wBQ5BSeCdWX03HvnfavERg9b1SVvkLefXT2pV+/8F8B09DEFBWumAHwEcSYf62sw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ehlrxGGdKVqoy6QIq6Sx4VNnrLxx4gqA9Vxs+upEaE=;
 b=lXY+xHCPystjdYRF5n7E6clJ1LG5z7/Nv8SfhdYk95460sB6Wq6zwEc7Uc4/W6dDCpLthnh9YrNSzWN9UtRQbRwy9xoudZxwygtBQ/oR/TtA/VSKNaYH+ItXcB9+ZXysXiytgrc85QqHNDN+gCisQUAU1YpoEFOow2KUYrMmCgaiw5k3/i4du6kGIxTlYesPCIcrebEzh8Oyhkytj9XBJ6yOOy7VrH9Av5n94aopWrbx68yon66sYJWBD7IUciaPWANBbSU/6y45gO81zz0rcSMcBAtKRFW/7DqMyFhhD98IkRwtjvxQrJCW5ZpT7zATJp7jc6bd1+gDnpfbCa7Tkg==
Message-id: <cd812972-f596-9635-64a2-3291a0f30605@suse.com>
Date: Wed, 15 Jun 2022 12:37:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Junxiao Bi <junxiao.bi@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
 <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
 <ea848935-abf6-90d6-9313-852cf8344852@linux.alibaba.com>
 <633910e3-83f0-23e1-0b85-78a1a2fbdb91@suse.com>
 <eab76c68-2dfa-bead-ece9-4baa6cb82ef6@linux.alibaba.com>
In-reply-to: <eab76c68-2dfa-bead-ece9-4baa6cb82ef6@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(186003)(110136005)(16799955002)(5660300002)(66946007)(2616005)(86362001)(36756003)(6666004)(31686004)(316002)(8936002)(53546011)(83380400001)(8676002)(2906002)(66476007)(4326008)(66556008)(38100700002)(31696002)(26005)(6486002)(6506007)(508600001)(966005)(6512007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 04:38:00.6699 (UTC)
X-Source-IP: 40.107.14.53
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10378
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=203
 priorityscore=154 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150012
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com (2603:1096:4:54::17)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ef4a1c0-5775-4a59-7793-08da4e88cfa1
X-MS-TrafficTypeDiagnostic: AM6PR04MB4949:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR04MB49499A5A016BF4BA5AA31E7F97AD9@AM6PR04MB4949.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 vNabz+MzNtYTBmWFjpt8w0ekCXNSmmUEHWrF90fdaKEDE/d4UX7ugabmIRzvjL+ftPRalowGmX+BM89p63NaS0/JnHXuQ2iRUyLeH4VNjffU2dDBWyfFtaSH2jKsOX8ASRSyYQ3/yjaWaDtEF+F3f5US4gsMKGXO2I4p1XOfeMjVGwJDzq5uodi5RNVNgdHr4GdQwfqbw+gv+5DQF4krI75rX4Pl+qBpRoKWuqBJ7nkq2pc9YXn7obTW3zgGxUXKhBEYUHW/XTMM0tr4y3zvvEgHKwiaJfUeqacLQct4MMW4ibLv6Zy1MVmPpOL0lflM1WH76mgDxsVPlPLlBWtRiK3xHuWW4AKuwonM6z77rKYH8mygD6yT4GUUGj1DB1nk4LXNvmGikwEtS6eq2LVc9GEELzhOlu2yNlbD9c8JrLYS0WaH+PreNIXMpHWMTYAsdq9Ua0Z/R6yYWUttOU9aYdDvVrxYW/2Yhgur7mARiQtWdttwKWpHya8fHP+eveAm+lgpOrRjzws5xUlcPrnMOPQXeHX/xn5p+fYR0EGNLTe+2rF+S/iJKuZ6ac0DeQa8e3YsfvFqaaCh7Z0jA2iEMfkzMVNFq1EDhFGgXuMLfc4TfWdJz58yNMc127SsRQDHnUj768iDbufPp/W8gVNv9ccezltf1KM4hJfvwJpQxiZGUYXs7OWooNcgFIbnTrAPWFgRHRSEKU06ICMkDQlUyefk4c7XcFokQi9yPF6DC/9BZbRZcoMaE1ruy2URo6Qmix4cZWnszrFT7YsSnUMjSAeZv6rI6YGdS9rW7z/gxgNc22iqUWPF8auHYOAOW+yB
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZFhCdWRNOXdkUVBoRHN6QnFpY2NnU1Z6NjNEazY0bnRZYkZJMGJnQlBQcjFH?=
 =?utf-8?B?YzRsUHEwUDRwVk1MLzlwZWZZdmFMUkFtU0R1bWcyUVVvdTh4ZndNWGQvaU5J?=
 =?utf-8?B?WDdBR3Fwbno4U3M2ZzBodHl5Ry9BRTQ4U1F1V2V5ZGl4L0JQelpPSW5kZEZ1?=
 =?utf-8?B?M0RRK0FsZ2tRdXB4R2VUZzNKMEIwcHZkVHlYVWZqZHhwbTN1MStUU09xK1lt?=
 =?utf-8?B?OW1UTExDSFZOS2pvblk0TmFVdVk2Q2lLNVphT0k2R0xpbVluaU01VGsxbk9Q?=
 =?utf-8?B?bHk4MjQ2a3NqWTAzRUFucW5BallMRVJTMitGay9xU01NNk0yT20zNnpKQWtn?=
 =?utf-8?B?RDN3OEttRFRoRWJVOUJIQXhhdldJSzdGMFIvM0dLUjFNaGVkckpiSFMvbEJN?=
 =?utf-8?B?Qmx6cFFWZHpZREwvRG5Eamw5QmpIVGxsT0h5cVpicnd3dXh3b040RlNPMHVr?=
 =?utf-8?B?c0V6dGFlbW5TeTBtNEVuOThBWHBWUkM3L3MyaXEyVjdnNzJzZ0hyanpGZTJK?=
 =?utf-8?B?dENkZGJZQmI1VTVHTi9NRFdWQVpiM3ozQWM2MmRBTlVFZWVXYlBvQ1E0ZERO?=
 =?utf-8?B?Q3EvMmFGckxvVTlCTWc1M1ZkaE9jdW5HR2Q5WHM4TlRxbVBiTW9lUEZGR3p6?=
 =?utf-8?B?aVJ2OXhxTzZNWTQweXhvbVNCKzZ0dEJFM0lLR3pyU1hCMzhPSUNmVVFWNUVM?=
 =?utf-8?B?NWkyeGxERit2UndFMnpIcUJqZHdTZTR4NWdldXBrYnRLNkVXNE4vTGxsaHFH?=
 =?utf-8?B?dTkvWnphRlNzc3Z6RFYwcGdnN0wrRnlSK2ZtRHN5ZGs1RTM5c1hOWFZYQmQr?=
 =?utf-8?B?SWZWTmV5aldzbWk2UGhTekE5QlNVQnhoeUhmeUdNYTloL0phejF5UmdqRW1Q?=
 =?utf-8?B?bi9kRk9WVkQ0bmhwSTI3eXJ5dmQrTE82MTIvSWVWUk1HUHBxMkZjSk1xYlNY?=
 =?utf-8?B?Z3l6T2p0cDIwZnlQcGdEWityd3ZOa1RuK0lxak5RQ0lFUFprYnFzaFVpVFhs?=
 =?utf-8?B?M3RxbFlCc0kxdCtmdFJpZy9NUS9aTnZjUGNWSFhFS2RMVEdvbk03aXB2djlY?=
 =?utf-8?B?MEQ5KzdOK2pBcUR5TDNGOHdpM3ZkbnlTVUZmOHNKd2ZLV0xacXdCaVoyN2FG?=
 =?utf-8?B?NHpoU2xsMEg5T3dkM3ZRN3o2Y3pnKzdmNVFQaHNpTVNpWTVsRUxSN0FHM3Bq?=
 =?utf-8?B?QXRwVnFTSDF2dy9YdWJHb0VMSTBjTGtTN1gxdkVGc1dyK1lYSUh2ZW9wNWlD?=
 =?utf-8?B?OEtGbWJYc1I0RnBOd2N1R1NNVUI2YmxEaEJOODVvTmxvejVyVEtHZ0d2bUM3?=
 =?utf-8?B?TWs5b0F5cjdTaTdjbU1YdkxXYk03ZDAwRUZCdng3RG01ZnI5WWRtNHJiZlhq?=
 =?utf-8?B?TmxtSzdNbDNIYUFjTHNSSGF5cmw4NGpLa2JrQmhkMlRWMFFqL2hMQ2dOTE5h?=
 =?utf-8?B?S1ROVXpCMENaQkp4RWIweWp5L1p2Ri9iWGJBd0NlQzR5N0NRd0hkOGoxTG5w?=
 =?utf-8?B?Y3I0dEVDTUxGZklSS1dBd3dpb0tiR3RNaWhmVENWV0R3bkRTbWJXcFRaTWgx?=
 =?utf-8?B?QllrcjJsSWxNaXVsRk1Ud0hRNFlmQWJ6c2JDMWVmUlJVRGwzamd4SEhTemFu?=
 =?utf-8?B?TVpCUFNKVmVBUGtEclc1c3EyVnMwcnppcWdIZHdBRzZ1S0FjZ3FwditkeGQ1?=
 =?utf-8?B?Ri9oS0JxUnlocENUUXYwQjBrV1d3M0ptQ2pUem1KLzNONnZBUXVrYzA4S0xX?=
 =?utf-8?B?U1poSkZuVzZYRWVXZStpL3BaRWRybGdNbnRFSmo0djF4TUtaTTdabHE2L2dm?=
 =?utf-8?B?b2lWSUlCR0lCcnNnVGxhNW4wSktWbFRmQ3J4aWZsMVZOVTAxaG5oRGx2akF0?=
 =?utf-8?B?N1QrNkFvMXBGeEprbGp0ZThZOG1JeWpybkhUcjQyL3orOU1OZ2trV3BoL0VH?=
 =?utf-8?B?bWU3a1dvOXZwRUFsWHlja1pHWHoxek5XYlBTblVPay9SYnp0OVhMU1BxdnpV?=
 =?utf-8?B?aVQ3aDI3ZHFScmhuRzJQWVZOU1hoNTR2NnRnNmk5cXZvYnc1SHlLcGJlcnk4?=
 =?utf-8?B?NHlmc0xvaUNIbHFrK2pnWjNob1VhQ0VOVHc1dE0xVUdWWjMyeDc4ditZazRo?=
 =?utf-8?B?NzBNL0RjVmUyU3VrbmpzUVluWXNlSlhQSy9FNjg5SzU0SDQ2dm50a2drRTBp?=
 =?utf-8?B?OVFXQmRxQzNPQ3VTczF0YUM5MlFBR0FiQ0hPRTE5NHNwcEI3SXRwNGZHTERu?=
 =?utf-8?B?dHF6NWd3Z1dtRDlWTElSaDUvQ1hLUlhkL0IyWDlRbGRkT2daZWtOcVE0eC8z?=
 =?utf-8?B?Y3NUbmJsTGk2TDZLa1UxSVJld3YwN1RxWGM3dEI3Z3FJanN3WWt3Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6ef4a1c0-5775-4a59-7793-08da4e88cfa1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 M9WsI5nmsLwBYGB5Hmatf/FN0EmLYxQWU7stc6VBS2SWogbRVmQIgwgQaK9qtcFwCNBpl1SfZGspADEcl+f4xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4949
X-ServerName: mail-eopbgr140053.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: QxhrEkEyBJPCHLSvxPMWdexzV7yjEg-q
X-Proofpoint-GUID: QxhrEkEyBJPCHLSvxPMWdexzV7yjEg-q
Reporting-Meta:
 AAEqcl+TgEV8kEzrLcE0JGroCxsJr35DTT5Su89vJNxQx3aHEWkLwkAfL/nH5kcG
 4HAdj3xGgs3DJTX+bUrKiNqwy+uVXsix+FWn4Jeq7Yo3wQFCHYvzoU5GfKyqc2in
 XoZegeKHnTb99QvmJRdEYhhFAz2zsDYeYjKG47TIBLaHtnBsHxPrOQtePtT4viSU
 35YUIRssYRpezI19Vb94nu283xJd21OsibUJoRqtcT+lQep015lmEk7kC4Onio6t
 9Y2dQGRROs3o402fi3wSaaH11eemz47qvUCTu7S/ob4zPgf7gDTsoWelrwYYF/SG
 BV9rZW4Xia7Wz5dA6loDpnnfx7XJVGxgHyiXyk2GkPdyCmDn+2F42xIks2b6I1J1
 CvnVZxI4k828kY/Ey546HPBUFtNBv3Fil0ibAInJL5IpUIYC5Fawv7sidQ4PxhLH
 318cD6bdrbRozPsQUzcpB+pylENA/N1hdiLmOzIiCnjt/ZWHFoqQviZEhTyCeTUc
 Msy+ZntbQ98MhgOoi3ScD6gLza6X8TpTPA039udtWZA=

T24gNi8xNS8yMiAxMDowMywgSm9zZXBoIFFpIHdyb3RlOgo+IAo+IAo+IE9uIDYvMTQvMjIgODox
MyBQTSwgaGVtaW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6Cj4+IE9uIDYvMTQvMjIgMTE6MjcsIEpv
c2VwaCBRaSB3cm90ZToKPj4+Cj4+Pgo+Pj4gT24gNi8xNC8yMiAxMDo1OSBBTSwgaGVtaW5nLnpo
YW9Ac3VzZS5jb20gd3JvdGU6Cj4+Pj4gT24gNi8xMy8yMiAyMzo0MywgSnVueGlhbyBCaSB3cm90
ZToKPj4+Pj4KPj4+Pj4+IOWcqCAyMDIy5bm0NuaciDEz5pel77yM5LiK5Y2IMTo0OO+8jGhlbWlu
Zy56aGFvQHN1c2UuY29tIOWGmemBk++8mgo+Pj4+Pj4KPj4+Pj4+IO+7v09uIDYvMTMvMjIgMTY6
MjEsIEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4+Pj4gT24gNi8xMy8yMiAzOjU5IFBNLCBoZW1pbmcu
emhhb0BzdXNlLmNvbSB3cm90ZToKPj4+Pj4+Pj4gT24gNi8xMi8yMiAyMjoxNiwgSm9zZXBoIFFp
IHdyb3RlOgo+Pj4+Pj4+Pj4gSGksCj4+Pj4+Pj4+Pgo+Pj4+Pj4+Pj4gV2h5IGNhbid0IHVzZSBs
b2NhbCBtb3VudD8gSSBkb24ndCByZW1lbWJlciBpZiB3ZSBkaXNjdXNzIGFib3V0IHRoaXMuCj4+
Pj4+Pj4+Pgo+Pj4+Pj4+PiBTb3JyeSwgSSBjYW4ndCBmb2xsb3cgeW91ciBxdWVzdGlvbi4KPj4+
Pj4+Pj4gRG8geW91IG1lYW4gd2h5IHJldmVydCBjb21taXQgOTEyZjY1NWQ3OGM1Pwo+Pj4+Pj4+
Pgo+Pj4+Pj4+PiBvciB5b3UgYXJlIGludGVyZXN0IHdpdGggdGhlIGZlYXR1cmUgbG9jYWwgbW91
bnQ/Cj4+Pj4+Pj4+IHRoZSBsb2NhbCBtb3VudCBpcyBjcmVhdGVkIGJ5IG1rZnMub2NmczIsIHdo
aWNoIGNhbid0IGJlIGNvbnZlcnRlZCB0byBjbHVzdGVyZWQuCj4+Pj4+Pj4+IHNlZSBta2ZzLm9j
ZnMyKDgpICctTScgb3B0aW9uLgo+Pj4+Pj4+Pgo+Pj4+Pj4+IFdoYXQgSnVueGlhbydzIG1haW4g
Y29uY2VybiBpcyBkYXRhIGNvcnJ1cHRpb24sIHNvIEknbSBhZnJhaWQgd2UgaGF2ZSB0bwo+Pj4+
Pj4+IGludHJvZHVjZSBhbiBvbmRpc2sgZmVhdHVyZSBiaXQgdG8gcHJldmVudCBtaXhlZCBub2Ns
dXN0ZXIgYW5kIGNsdXN0ZXIKPj4+Pj4+PiBtb3VudCwgc2ltaWxhciB0byBsb2NhbCBtb3VudC4K
Pj4+Pj4+Cj4+Pj4+PiB0aGlzIHBhdGNoIGRlZmluZWQgdHdvIG5ldyB2YXJpYW50cy9mbGFnczoK
Pj4+Pj4+ICNkZWZpbmUgT0NGUzJfU0xPVE1BUF9DTFVTVEVSwqDCoCAxCj4+Pj4+PiAjZGVmaW5l
IE9DRlMyX1NMT1RNQVBfTk9DTFVTVEVSIDIKPj4+Pj4+Cj4+Pj4+PiAoSSBleHBlY3QpIFVuZGVy
IE9DRlMyX1NMT1RNQVBfQ0xVU1RFUiwgZm9yIGNsdXN0ZXJlZCBtb3VudCBtb2RlIGFuZCBmb3Ig
Y29tcGF0aWJpbGl0eSwKPj4+Pj4+IGFueXRoaW5nIGRvZXNuJ3QgbmVlZCB0byBiZSBjaGFuZ2Vk
Lgo+Pj4+Pj4KPj4+Pj4+IE9DRlMyX1NMT1RNQVBfTk9DTFVTVEVSIHdpbGwgaW50cm9kdWNlIGEg
bmV3IHZhbHVlIGZvciBzbG90bWFwIGFyZWEuCj4+Pj4+PiB0aGlzIG5ldyB2YWx1ZSBvbmx5IHRh
a2UgZWZmZWN0IGFmdGVyIGEgc3VjY2Vzc2Z1bGx5IG5vY2x1c3RlciBtb3VudC4KPj4+Pj4+IChw
bHMgZml4IG1lKSwgZXhpc3RlZCBrZXJuZWwvdXNlciBzcGFjZSBjb2RlIGRvbid0IGRvIGFueSBz
cGVjaWFsIGhhbmRsZSBmb3IKPj4+Pj4+IG5vY2x1c3RlcmVkIG1vdW50IG1vZGUgaW4gc2xvdG1h
cCBhcmVhLiBTbyB0aGUgbmV3IHZhbHVlIGlzIGFsc28gY29tcGF0aWJpbGl0eS4KPj4+Pj4+Cj4+
Pj4+PiBBbmQgdGhlIHBhdGNoIGNhbiBhbHNvIHByZXZlbnQgbWl4ZWQgbW91bnQsIHRoZSByZWxh
dGVkIGNvZGUgaXMgaW4gb2NmczJfZmluZF9zbG90KCkuCj4+Pj4+PiBjb2RlIGxvZ2ljOgo+Pj4+
Pj4gLSBub2NsdXN0ZXJlZCBtb3VudCBjb25kaXRpb246IHNsb3RtYXAgaXMgZW1wdHkgb3IgYWxy
ZWFkeSBtb3VudGVkIHdpdGggbm9jbHVzdGVyZWQKPj4+Pj4+IC0gY2x1c3RlcmVkIG1vdW50IGNv
bmRpdGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBhbHJlYWR5IG1vdW50ZWQgd2l0aCBjbHVzdGVy
ZWQuCj4+Pj4+PiAtIGFsbCBvdGhlciBjb25kaXRpb25zIHdpbGwgYmUgZGVuaWVkLgo+Pj4+PiBG
aW5kaW5nIHNsb3QgcmVxdWlyZWQgcmVhZGluZyBzbG90IG1hcCBhbmQgdGhlbsKgIHVwZGF0ZSBz
bG90IG1hcC4gSXQgaXMgbm90IGF0b21pYyAsIHlvdSBjYW7igJl0IHByZXZlbnQgbWl4ZWQgbW91
bnQgdW50aWwgeW91IGhhdmUgYSBjbHVzdGVyIGxvY2suCj4+Pj4KPj4+PiBDb3VsZCBJIHNheSB5
b3VyIG1lbnRpb25lZCB1c2UgY2FzZSBpcyBpbnZhbGlkLgo+Pj4+IEkgYmVsaWV2ZSBhbGwgKHll
cywgKmFsbCopIHRoZSBvY2ZzMiB1c2VycyB1c2UgdGhpcyBmcyB1bmRlciBjbHVzdGVyIG1vZGUg
aW4KPj4+PiB0aGVpciBwcm9kdWN0IGVudi4KPj4+PiBUaGUgbm9jbHVzdGVyIG1vdW50IGlzIG9u
bHkgdXNlZCBvbiBtYWludGFpbmVkIGVudiAoZWcuIGJhY2t1cCwgZnNjaykuCj4+Pj4KPj4+PiBX
ZSBvbmx5IGNvbmNlcm4gdHdvIHdheXM6Cj4+Pj4gMS4gdXNlciBmb3JnZXRzIHRvIHVubW91bnQg
KGVnIGNyYXNoKSBiZWZvcmUgdXNpbmcgYW5vdGhlciBtb3VudCBtb2RlLgo+Pj4+IDIuIHdoZW4g
b2NmczIgdm9sdW1lIGlzIHdvcmtpbmcsIHdoaWNoIHNob3VsZCBkZW55IHZvbHVtZSBpcyBtb3Vu
dGVkIGJ5IGFub3RoZXIgbW9kZS4KPj4+PiAgwqDCoMKgIHRoaXMgbWF5IGhhcHBlbmVkIHVzZXIg
bWlzdGFrZW5seSBydW5zIGNvbW1hbmQgb3Igc2NyaXB0Lgo+Pj4+Cj4+Pj4gQmFzZSBvbiBhYm92
ZSAxICYgMiwgSnVueGlhbyBhYm92ZSBtZW50aW9uZWQgdXNlIGNhc2Ugb25seSBoYXBwZW5zIG9u
IG9uZSBzY2VuYXJpbzoKPj4+PiB0aGUgdm9sdW1lIGRvZXNuJ3QgYmUgbW91bnRlZCBieSBhbnkg
bm9kZSwgdGhlbiB1c2VyIG1pc3Rha2VubHkgbW91bnRzIHZvbHVtZQo+Pj4+IHdpdGggW25vXWNs
dXN0ZXIgbW9kZSBhdCBzYW1lIHRpbWUuIEkgYmVsaWV2ZSB0aGlzIHVzZSBjYXNlIGlzIGludmFs
aWQuIEFuZCBJIGd1ZXNzCj4+Pj4gZ2ZzMiBtYXkgYWxzbyBoYXMgdGhlIHNhbWUgaXNzdWUuCj4+
Pj4KPj4+PiBXaXRoIHRoaXMgcGF0Y2gsIG9jZnMyIGhhcyBtb3JlIHNhbml0eSBjaGVjayBhYmls
aXR5IHRoYW4gb3RoZXIgZnMsIGVnOiB4ZnMsIGV4dDQuCj4+Pj4gU1VTRSBIQSBzdGFjayB3aXRo
IGNvcm9zeW5jK3BhY2VtYWtlciBhbHNvIHN1cHBvcnRzIHJ1bm5pbmcgeGZzL2V4dDQgd2l0aCBB
L1AgbW9kZS4KPj4+PiBUaGUgeGZzL2V4dDQgbmV2ZXIgaGF2ZSBkZXRlY3RpbmcgbW91bnQgc3Rh
dHVzIGNvZGUsIEp1bnhpYW8gbWVudGlvbmVkIG1peGVkIG1vdW50Cj4+Pj4gY2FuIGFsc28gaGFw
cGVucyBvbiB0aGVzZSBmcy4gSG93IGRvIHhmcy9leHQ0L0hBIG1haW50YWluZXJzIGhhbmRsZSBp
dD8gVW5kZXIgdGhlc2UKPj4+PiBmcyBtb3VudGluZyBiZWhhdmlvciwgdGhlc2UgZmllbGRzIG1h
aW50YWluZXJzIGFsc28gdHJlYXQgdGhlIG1peGVkIG1vdW50IGFzCj4+Pj4gaW52YWxpZCB1c2Ug
Y2FzZSBhbmQgaWdub3JlIGhhbmRsZSBpdC4KPj4+Cj4+PiBFeHQ0IGhhcyBhIGZlYXR1cmUgbW1w
IChtdWx0aXBsZSBtb3VudCBwcm90ZWN0aW9uKSB0byBkbyB0aGlzLgo+Pj4gTW9yZSBkZXRhaWxz
IHBsZWFzZSByZWZlciB0bzoKPj4+IGh0dHBzOi8vZXh0NC53aWtpLmtlcm5lbC5vcmcvaW5kZXgu
cGhwL0V4dDRfRGlza19MYXlvdXQKPj4+Cj4+Cj4+IEhpIEpvc2VwaCwKPj4KPj4gSSBjaGVja2Vk
IG1tcCBmZWF0dXJlIHJlbGF0ZWQgY29kZSwgaXQgY2FuIGhlbHAgZXh0NCB0byBhdm9pZCBtdWx0
aXBsZSBtb3VudCBpc3N1ZS4KPj4KPj4gIEZyb20gbXkgY29kZSByZWFkaW5nOgo+PiAtIHRoZSBt
bXAgZmVhdHVyZSBkaWQgbW1wIGNoZWNrIHdoZW4gbW91dGluZy4KPj4gLSB0aGUgbW1wIGZlYXR1
cmUgd2lsbCBzdGFydCBhIGtlcm5lbCB0aHJlYWQgKGttbXBkKSB0byBtb25pdG9yIG1vdW50IHN0
YXR1cy4KPj4gLSBrbW1wZCBkb2VzIGRldGVjdGluZyB1bmRlcmx5aW5nIGRldiBJT3MgdGFzay4K
Pj4KPj4gV2UgY291bGQgcmUtdXNlIG1tcCBmZWF0dXJlIGlkZWEgZm9yIG9jZnMyLCBkbyB5b3Ug
cGxhbiB0byBhZGQgaXQ/Cj4+IElmIHllcywgSSBjb3VsZCB0YWtlIHRoaXMgZmVhdHVyZSBwb3J0
aW5nIGpvYi4KPj4KPiBVbW0uLi4gSSByZWZlciBpdCBqdXN0IGZvciB5b3VyIGluZm9ybWF0aW9u
Lgo+IG9jZnMyIGlzIGNsdXN0ZXIgZmlsZXN5c3RlbSwgZm9yIG5vcm1hbCB1c2VyIHNjZW5hcmlv
cywgd2UgaW50ZW5kIHRvCj4gbW91bnQgb24gbXVsdGlwbGUgbm9kZXMuCj4gRm9yIHVzZSBpdCBh
cyBsb2NhbCBmaWxlc3lzdGVtLCB3ZSBoYXZlIGxvY2FsIG1vdW50IG1vZGUuCgpEbyB5b3UgdGhp
bmsgYW55b25lIHVzZXMgb2NmczIgd2l0aCBsb2NhbCBtb3VudCBtb2RlPwpJbiBteSB2aWV3LCB0
aGVyZSBhcmUgbWFueSBGU3MgcG93ZXIgdGhhbiBvY2ZzMiB1bmRlciBsb2NhbCBtb3VudCBtb2Rl
LiBUaGV5IGFyZQp2ZXJ5IGxpa2VseSB0byBjaG9vc2Ugb3RoZXIgZnMgKGVnLiB4ZnMsIGV4dDQs
IGJ0cmZzKS4KClRoZSBsb2NhbCBtb3VudCBtb2RlIGlzIGZpeGVkIHdoZW4gbWtmcy5vY2ZzMiBh
bmQgd29uJ3QgYmUgY2hhbmdlZCBsYXRlci4KKHBsZWFzZSBjb3JyZWN0IG1lIGlmIGFib3ZlIGxp
bmUgaXMgd3JvbmcuKQpub2NsdXN0ZXIgZmVhdHVyZSBpcyBiYXNlZCBvbiBsb2NhbCBtb3VudCBm
ZWF0dXJlLCBhbmQgbm9jbHVzdGVyIG1vdW50IG1vZGUKaXMgbW9yZSB1c2VmdWwgdGhhbiBsb2Nh
bCBtb3VudC4KSSBldmVuIGhhdmUgYSBib2xkIGlkZWEsIG9jZnMyIGNvdWxkIGRyb3AgbG9jYWwg
bW91bnQgZmVhdHVyZSBzdXBwb3J0LCBhbmQKb25seSBzdXBwb3J0IGNsdXN0ZXIgJiBub2NsdXN0
ZXIgbW91bnQgbW9kZS4KCj4gU28gaXQgc2VlbXMgJ25vY2x1c3RlcicgbW9kZSBsb29rcyBhIGJp
dCB3ZWlyZC4gSSdtIG5vdCBzdXJlIGlmIHRoaXMgaXMKPiBhIGZyZXF1ZW50bHkgaGFwcGVuZWQg
dXNlciBjYXNlLiBPciBjYW4gd2UgZG8gaXQgaW4gY2x1c3RlciBzdGFjayBhcwo+IEp1bnhpYW8g
c3VnZ2VzdGVkPyBPcmFjbGUgYW5kIEkgKGJlZm9yZSkgb25seSB1c2UgbzJjYiwgc28gd2UgZG9u
J3QgaGF2ZQo+IG11Y2ggZXhwZXJpZW5jZSBvbiBjb3Jvc3luYyArIHBhY2VtYWtlci4KCkkgaGFk
IGV4cGxhaW5lZCB0aGUgdXNlY2FzZXMgb2Ygbm9jbHVzdGVyIGluIHByZXZpb3VzIG1haWxzLiBT
VVNFJ3MgY3VzdG9tZXIKdXNlcyB0aGlzIGZlYXR1cmUgdG8gbWFpbnRhaW5lciAoZWcgZnNjaykg
b3IgYmFja3VwLiBEbyB5b3UgcmVtZW1iZXIgb2Nmcy10b29scwpjb21taXQgNzA4NWU5MTc3YWRj
NzE5NzI1MGQ4NzJjNTBhMDVkZmM5YzUzMWJkYywgd2hpY2ggY2FtZSBmcm9tIHJlYWwgd29ybGQu
CkkgYWxzbyBhZ3JlZSBjdXN0b21lciBjYW4gZG8gYWxsIHRoZSBub2NsdXN0ZXIgb3BlcmF0aW9u
cyBpbiBjbHVzdGVyIHN0YWNrLgpUaGUga2V5IG9mIG5vY2x1c3RlciBpcyB0byBieXBhc3Mgc2V0
dGluZyBoYSBzdGFjay4KCkZvciBtaW5pbWFsIGNvZGUgY2hhbmdlLCB0aGlzIHBhdGNoIFsxLzFd
IGlzIGVub3VnaC4KQW5kIGZvciBmaXhpbmcgKEp1bnhpYW8gY29uY2VybmVkKSBtdWx0aSBtb3Vu
dCBzaW11bHRhbmVvdXNseSwgd2UgY291bGQgcGFydGx5IHVzZQpleHQ0IG1tcCBmZWF0dXJlL2lk
ZWEuIG1tcCBtb3VudGluZyBwaGFzZSAoYmVmb3JlIGNyZWF0aW5nIGttbXAgdGhyZWFkKSBjb2Rl
IGlzCmVub3VnaCBmb3IgZml4aW5nIHRoaXMgaXNzdWUuIGFuZCBJIGVzdGltYXRlcyB0aGUgbW1w
IGZvciBvY2ZzMiBjb2RlIGlzIGFib3V0IH4xMDAKbGluZXMuCgpUaGFua3MsCkhlbWluZwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwg
bWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
