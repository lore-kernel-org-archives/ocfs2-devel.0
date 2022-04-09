Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34968C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=loHSLfvgToifqQ9jlGPRAX+NrlFpnySsZepKCOUKwR0=;
 b=o4E58TFfDVbgFuvoYOKirLQdmZMZJ2vivFWMI5Zs1FFyVwEbVWUUFzFLoShsmWmO65l0SiS909/e
   CF085I10skYeTOBrN2tZRNGcbDsWZ2TM2uyZPwMps+n44DlnGVPl2CReSNWvVtlHg5Vo6e0UJe2h
   ng8/ptb8TrDO1N+DaVUNwJE47qSMeWvabgDyOkS8JUB+ptdrG0zDxMmNupVviLaoD5poqJywFc3F
   KmleDztjj5dC6O9ZywdiCRTYeRhUsk/PNL/C7kMgmeR8IEWkDCSEFsfcga1GI398IL0yFCtC0dtO
   DTCA+rqx1sKsKCBBHVsivvau6oeIDYrZa5F8Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=loHSLfvgToifqQ9jlGPRAX+NrlFpnySsZepKCOUKwR0=;
 b=FCsPIpN6aMWeC2vMOS81BNw5wA4uDXZF2SQNPqD8QFzAZ8mWIY4xV9dCufAz2+LtJtcGJpPoaXI6
   4vG/2fkn4PsZinDOJMCYkt1Eykzk5oD1TnrW0HKnvfAgDQGZhNz8eh2U0DAeX2/e+3kV+FF4vsp7
   bED4134OAcQ31kPEbkKCaGn51YWGcz53eZRGZtr0uiDy8RdoqCGPlYRyIxO5s0Xmm5yhtX+WSPwo
   6o3ksmgg9eIS77pFBQ2PG3gzxQWXSfNptpCkL2BJBKme/VVK9G527H7PZ1ajuvzvBcQYnO8/pG1w
   P4/2L8zdzbEr3J3QpPM/RP7MdRtUIzQA5/BZ7g==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200O57Z3R6960@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 16:28:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649521701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OjPrcLkYdD6luYIQpUkUdelItbiKCiadP2hWQf3TkPU=;
 b=FsJvpC+ddx6ksxtA5Xl3mgCOJbCj0CfELmLhJQqSXWTcn/oLrKvV5QaYl+Taol7kM9p/2x
 G1hX9PEBsimApA8whv+ma1So/ywaGbbPqHqfL/A1cvD23HJFP5mz606TW9v1zhjx4hsquq
 PdhI7E/ZTFr+gxWh3ZSygo6s0xin25c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izl59WMn+dhKpxeEbuvcxAoJ0NWTE7kHwQS7DtrjO8Zbpe/ADiEwIn8AYbEkiuWpc3Nj+sLSw4VCQm5nCkqAjOLZ2NZXtz1qXOJtCFntumKVrxJ1uWgMeXskqMe2ZjxPtXGlkHQ8VKjbCIwd8qKQmBgN1udX6Aav/MDEmlbb4sjN6HGoC9yF9H6ov2E+6eWXeJC/+BYft0sv9waPxPcH0Bsm15inoJgFhz4CHgDAsQ5Als46NIPypMrUURUSD01DDR6+JFUTwUxRArswHvkeU7wyaNBDxVydZrVwPgyiWnUcF7UcD3WjgMdAgig7GtWsnvAyodxcU3nqYTs+g2EA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjPrcLkYdD6luYIQpUkUdelItbiKCiadP2hWQf3TkPU=;
 b=Hhpihi86uTWxF72IWQR4nBZDDuX+zGznAyNEBL1phdPEH/qYekG+1OLnLzxEywRiJmBvB/+SyU7eDEScE44v4LlO3KoE4VFsO8y3Y5vm15Jb2YMrZ54W3EKZtGNSTyQP7ViwZhfSmVzuCxz0Zjo6+X6/ppH4mfJ5UUEHNz5QlCEGJmOYXI7CCS06FfmNQFLqsOIX+d0xQ+2oLjNJ2bYM9abG0zWvFOLbdCEH8RDwWmgyANWtcATzTAInAcasU/cXrA0rUxG2gOvduAzzz7LN7RHTygyb4SrEtwGTOJZgwuyuOCEzph9Mi8u2qcpS3jzgck/IBT8vw6YOTs1m4ZQw/Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <5c6d27cb-7532-5686-e1a3-a4fda1dabe5f@suse.com>
Date: Sun, 10 Apr 2022 00:28:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-2-heming.zhao@suse.com>
 <7a09992f-8eb5-b3c8-5c5e-0dd7f275fe8f@linux.alibaba.com>
Content-language: en-US
In-reply-to: <7a09992f-8eb5-b3c8-5c5e-0dd7f275fe8f@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(38100700002)(31696002)(86362001)(36756003)(5660300002)(83380400001)(8936002)(66556008)(66476007)(66946007)(8676002)(31686004)(316002)(2906002)(26005)(186003)(6666004)(6512007)(6506007)(53546011)(2616005)(508600001)(6486002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 16:28:18.0231 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10312
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 mlxlogscore=999 clxscore=199 mlxscore=0 spamscore=0
 priorityscore=202 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090107
Subject: Re: [Ocfs2-devel] [PATCH v1 1/5] ocfs2: partly revert da5e7c87827e8
 for mounting crash issue
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
X-MC-Unique: fyntuQHaMLWO-jpQ6u0iTg-1
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5818b17c-fc5e-4bfc-1ce9-08da1a45f424
X-MS-TrafficTypeDiagnostic: VI1PR04MB6894:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB68940EA8362C217C3259AC1A97E89@VI1PR04MB6894.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Fy1vyNXg1RHznsNtW7UIqWhIgGVlNUNK+k9REsTakr+b0QqFv7zWVISEsFfymYPDinRPoFG4tuRZpNizYcH8PX/IiIT5jMa9MbDyzPLv6IVGnv8X2tLzIOpy2d0/9kayS9QWwlLsX78mOUd2YVoGLBvrMIHUUkR/JKpmOCGC/NGKkpHe2NhAd+soSCKIdTT3yV0YlcFfpLQe0XVYXrxGQglDnqgOVIj3R5SHms9Fd5g8DcdSar38U1+vDYjeIJrhsDoMGXnm9WHdUsDs9ejII6Lbd129eXv8E/9d1aU6/CNei8EsM5CQvy7cMpg9WHtiC8s3yrIXdwyp+0Zv90TU2kuQ3fX1GLiJtdOqrmawm6iwHyJSUIfJAAF5cCDw+cHevEmgrN5rvwCOLUxQ+EaBxoG/i4RrdcElAc3o3nEEdZNFn9pTUyrOju/A+XXoHycQZyiWIw/rAztSwFuL7N7jzeqd28B4fW4vnwUPcMq/nAtkE9dXoJUiymamj+TDtti8YR8tN6G5CS5bUmBnPaJFKmDNB+qVCHtpmxSxlQEpYlZ3drGftl8SLP0mSCuZ84dT/UTHUjwAib7v0PNG9pvD95CLpbLv6jhnoE+v+zMDTOjTieWZW7qVmZ5vhqJPmmKEGkEdKSsYmqPk1oPSMrhROVPm36TenYlaDr6/EgCjZRE5nX4ekuX/ClSS8oqavnSxk80kJVI8tHkcLM9oXKHcaVfwuGz26mfepIoWN3gBhdo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dUVjS3pQS2UvR0pXS3BFb04xQ04zU1BEV09RTE5nSHlhWXhDRXlaZFU3eWds?=
 =?utf-8?B?QkNyQUMzL3RSMTBlRVFkZTU1bkl0NTk1MmNGRXNnc1dPOFBOVGFjdUhsZkVT?=
 =?utf-8?B?TTB5eGZpcjVnMmJSOXRSZTd2TzNpMVB3MDBOVS8wbklOcko5UzhBeWRodi8w?=
 =?utf-8?B?RkFVSHA0Vyt2alIxanFKQlUxVStUSldiNGdFUnFIRStDM2hhNm5wYVBVNXdr?=
 =?utf-8?B?SmxXQjl3UWM4RWpQRVhnQXJHbXFlMTNHNCt5TU9kdUZIVWNnK2w1MTllQXRu?=
 =?utf-8?B?RE1CRFErakhjNCtHbFBYZ1Q5OVlkdTJLRkljRmM4TytHZGJTeDRhVXZneGpR?=
 =?utf-8?B?QkhFTk5Sa3R0a2RGQzFYYy9maEFPSUwvc1RXTGFQaW05a1ZHMFNLMGdpbmIr?=
 =?utf-8?B?UURsVDV5Z29BNjJ4a294bjRyYSs3S0xuVnhwYTJTcWZCMDIxSEhsM3FtY3Jt?=
 =?utf-8?B?TU91N3FIRnArV1VTdzdkRjJYZlY0OE9YWFlIbkZmZWsxMUtmUUxVeGUvbk9Y?=
 =?utf-8?B?RHdjL0FCdDhETFA3bGZnYVVoZjRyTW5hY2oyRVFLaUNUaFdKTFR5U0FLNVNn?=
 =?utf-8?B?Rk5Kc1crUHdGUUp0d09EV29QUEdLU1h4bldHMm1XekFzSjREdkJEdERjU3o5?=
 =?utf-8?B?N3dqcFU0SnoyR3ViKzJOd1pua05BOVZNdTMrQ1hoK2ZpaHRDU2VZN04reDlS?=
 =?utf-8?B?RzFBcmUrRGthTVpRa0Qvbm5zMkFYNG1KZTdYWHNYTHgxMURjbFo4OU8rYm0w?=
 =?utf-8?B?eGhoMnkyT3psR1ptdW1GWHlsOWtBZ1l2VDRtckRLaC84bTVrQXhvOWxBT1JW?=
 =?utf-8?B?K3BEODhuS3hmdGJsRmk5MkIyeVFlVitacXhDVitqNG5MOWN2UHB5bWtUZWNQ?=
 =?utf-8?B?ZGdzQ3NtYlZPUWxVS0NUS2ovWFU2NG5YeTNGMFN3N2JRbE0yMHdoVHRvR2la?=
 =?utf-8?B?Z1IxNW9FQ3VFMUx5dUZxK1dMMXlDdFo0eVhLWURuSDRpNHhXYUluOE5ReXdC?=
 =?utf-8?B?S3VRNFZaNGdzL09mUWVCc0xOYmRVOTZwcWNqb1paLzg0TnBvMkZPNGkvYUNC?=
 =?utf-8?B?SzNEMHAyNlpGdmZIVlRuMHp3QjZISFk0T3hpczdXOWhMWVg1OURSQmJ0QzZT?=
 =?utf-8?B?Y2VHa3ozQjlLaU5HWmVIS3g0VlBsdDQ2bFpJZ2ZVekVTSlJiTFg2L3ZQUnVQ?=
 =?utf-8?B?ZVEzSGdXODRPZFRxa0dqTFZEajM4OEhTa0xmWExEVGZIWVZTbUJrNVh5dnln?=
 =?utf-8?B?SzViZmUxR1NLT0QxZU53UlVsOHJCUkp0Y2JUS3d3clpPYkdwK29Ybm5SL0Mz?=
 =?utf-8?B?SHhIZEszVXlZb0pTbkVEV2s4elE2MCtrSFFEK2MrRzFGUXZwdElQeU83NkpB?=
 =?utf-8?B?ZHduVWJwQW83emhaRGxRdWpubkpwbmRRMEQwTUdFSk1RaWRxSTlKYUFMRVc0?=
 =?utf-8?B?cUpyUkMvZUQ3ZTZRcWsrbG1Qam1zZFVMNzNMNWlOZFpxYk83VEtjM3ZNbXlT?=
 =?utf-8?B?T2RnZUpVeG5kT2ZlRS9HWU1TWmkvd29KYkh3cWtTSGxWWWcweWNSbUNBbjFK?=
 =?utf-8?B?QnZoRUVRdFJFZkd5eVNEcE5tSDBvTTAzUk9Wa0hscWNUV3NaWFRHQ0dPU0Uw?=
 =?utf-8?B?Z0t0bVRiQUJ3L3NuVkRFb1JhWnpLanoyUWFTaUMvZ2JoR3dyZEtVUHNXRFQ3?=
 =?utf-8?B?bWxqL1FxQWxFUy9VWGFJL21BYTd5aThMcmFIT1h4NGZNU0dDeE9lTU1RcDVr?=
 =?utf-8?B?Q0Y0T1AyNmVhbWpRc0N2aWxyVGV6UDZiWmZpSXRwcURhdnVBWDZLVlVadGxX?=
 =?utf-8?B?OW1WWUNPMjVMeWtFMkR4ODZ4T0YrMkNHRVpnN3EvTGhZNDRWMmExOXVCMWt3?=
 =?utf-8?B?SjJYWklvMEY1UWthdWlOVW40cDBNZ2JOYmwyTzVSQWM5Q3JzYzVjNTgvYlNs?=
 =?utf-8?B?akdBSjk0SExLUCtLWkExUGRRTnFkVncwcWFXREdSYUFyZUZQWmp5UTFvSXNL?=
 =?utf-8?B?UmhqNk54OU9nOG5TclpLQ2UrZ2pENkNqaTB4US9aei9wRHJzRDlFeGM1aW5t?=
 =?utf-8?B?SklhZGJhM2VwZWs5S3hCamFvUlh5T1ZKOERoS1ZoRXUyKzJmQXNDcTdiQWg2?=
 =?utf-8?B?NENnVVM5N3g0ZHZGa0krVjFuM1FseEtiTzVFdUFKdEZrSS9MM0NLa2hEVEtl?=
 =?utf-8?B?Z2txYkNZSWMzR3RUb0UxZUJxaHhmdjNLR3R2TVhFU254WGpaN1I0RU9pczMv?=
 =?utf-8?B?eTlzcGwxS25tWlhVRXJNWjdTM3lNUVV4aGxPMW5ZMGZsWDhGRDZDZjcxMC92?=
 =?utf-8?B?TVZEakduNWhyZHBTaisvMXZibG4zVWY3UVJhVDJKMlBtVDlFZW1VUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5818b17c-fc5e-4bfc-1ce9-08da1a45f424
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 dD5WqwN5u3apEI7oLHg929A/U8WCGzmXQFYCbpq7/7RsLbqRNTtfPseQo+yiJXrbPRYzZSJtIasJr6pP6xJ9qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6894
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xdDyogkOHY8YK7pYVpQvVF3vWdSfFhFF
X-Proofpoint-GUID: xdDyogkOHY8YK7pYVpQvVF3vWdSfFhFF
Reporting-Meta:
 AAGBjT6H4M4dT+RJ0L2jtiC7LslCD7Z/QtiW6TI71TVjG+oUwqddp7NsRUJBmkQg
 mouABfIGedPNvpAoH7Bm+H8AbUbpkpZE6+ejnZbyxRx0JIm1uX+VKcfQ3XXk1aeI
 +cGmT3VMcv9hsb++HP5teh88VCKFeGYoGQsxnSTsj5A286cqEN6XcUSPjigHtCV4
 pQMwu39cuvYVwGUSxHm5Op7Vba1REkamhO67oTNqXX8nnRroijSTeqOc/ecYpqb8
 kZY0ky4GM0eZpobAbta++eH/Jnc3k0FJOQ/g9DnmzRKX1+XaaPihzGiIuqBEjVLx
 WuwiXn0e+DwKJTuEw43JqbtNJtxi48lLEf7m0q6QcAHuZwyuSbqirRorWw7ofXLG
 x3Hi/kZDJtfL61zGi1TSkO05ajpO+ulR5XDASWb5FWfkqOB+HdBEIINe4be+ZaCp
 e084TkIbMYZdMbp47Hc75FC65Dm8zRKal8PnmZ4RUKDPV37TXE/OwTDcr55txzPF
 upHcp4itWByRNY6P1wTqjmDzL3A0uK24NwnBXZA8JuQ=

On 4/9/22 21:11, Joseph Qi wrote:
> Suggest rename the subject, something like
> ocfs2: fix mount crash if journal is not alloced

OK.

> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
>> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
>> journal init later than before, it makes NULL pointer access in free
>> routine.
>>
>> Crash flow:
>>
>> ocfs2_fill_super
>>   + ocfs2_mount_volume
>>   |  + ocfs2_dlm_init //fail & return, osb->journal is NULL.
>>   |  + ...
>>   |  + ocfs2_check_volume //no chance to init osb->journal
>>   |
>>   + ...
>>   + ocfs2_dismount_volume
>>      ocfs2_release_system_inodes
>>        ...
>>         evict
>>          ...
>>           ocfs2_clear_inode
>>            ocfs2_checkpoint_inode
>>             ocfs2_ci_fully_checkpointed
>>              time_after(journal->j_trans_id, ci->ci_last_trans)
>>               + journal is empty, crash!
>>
>> For fixing, there are three solutions:
>>
>> 1> Revert commit da5e7c87827e8
>>
>> For avoiding kernel crash, this make sense for us. We only concerned
>> whether there has any non-system inode access before dlm init. The
>> answer is NO. And all journal replay/recovery handling happen after
>> dlm & journal init done. So this method is not graceful but workable.
>>
>> 2> Add osb->journal check in free inode routine (eg ocfs2_clear_inode)
>>
>> The fix code is special for mounting phase, but it will continue
>> working after mounting stage. In another word, this method adds useless
>> code in normal inode free flow.
>>
>> 3> Do directly free inode in mounting phase
>>
>> This method is brutal/complex and may introduce unsafe code, currently
>> maintainer didn't like.
>>
>> At last, we chose method <1> and partly reverted commit da5e7c87827e8.
>> We reverted journal init code, and kept cleanup code flow.
>>
>> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/inode.c   |  4 ++--
>>   fs/ocfs2/journal.c | 21 +--------------------
>>   fs/ocfs2/super.c   | 33 +++++++++++++++++++++++++++++++++
>>   3 files changed, 36 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 5739dc301569..bb116c39b581 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -125,6 +125,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>>   	struct inode *inode = NULL;
>>   	struct super_block *sb = osb->sb;
>>   	struct ocfs2_find_inode_args args;
>> +	journal_t *journal = osb->journal->j_journal;
>>   
>>   	trace_ocfs2_iget_begin((unsigned long long)blkno, flags,
>>   			       sysfile_type);
>> @@ -171,11 +172,10 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
>>   	 * part of the transaction - the inode could have been reclaimed and
>>   	 * now it is reread from disk.
>>   	 */
>> -	if (osb->journal) {
>> +	if (journal) {
>>   		transaction_t *transaction;
>>   		tid_t tid;
>>   		struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> -		journal_t *journal = osb->journal->j_journal;
>>   
>>   		read_lock(&journal->j_state_lock);
>>   		if (journal->j_running_transaction)
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 1887a2708709..afb85de3bb60 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -815,30 +815,11 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>>   	int status = -1;
>>   	struct inode *inode = NULL; /* the journal inode */
>>   	journal_t *j_journal = NULL;
>> -	struct ocfs2_journal *journal = NULL;
>> +	struct ocfs2_journal *journal = osb->journal;
>>   	struct ocfs2_dinode *di = NULL;
>>   	struct buffer_head *bh = NULL;
>>   	int inode_lock = 0;
>>   
>> -	/* initialize our journal structure */
>> -	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
>> -	if (!journal) {
>> -		mlog(ML_ERROR, "unable to alloc journal\n");
>> -		status = -ENOMEM;
>> -		goto done;
>> -	}
>> -	osb->journal = journal;
>> -	journal->j_osb = osb;
>> -
>> -	atomic_set(&journal->j_num_trans, 0);
>> -	init_rwsem(&journal->j_trans_barrier);
>> -	init_waitqueue_head(&journal->j_checkpointed);
>> -	spin_lock_init(&journal->j_lock);
>> -	journal->j_trans_id = 1UL;
>> -	INIT_LIST_HEAD(&journal->j_la_cleanups);
>> -	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
>> -	journal->j_state = OCFS2_JOURNAL_FREE;
>> -
>>   	/* already have the inode for our journal */
>>   	inode = ocfs2_get_system_file_inode(osb, JOURNAL_SYSTEM_INODE,
>>   					    osb->slot_num);
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 477cdf94122e..5f63a2333e52 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2015,6 +2015,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	int i, cbits, bbits;
>>   	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
>>   	struct inode *inode = NULL;
>> +	struct ocfs2_journal *journal;
>>   	struct ocfs2_super *osb;
>>   	u64 total_blocks;
>>   
>> @@ -2195,6 +2196,32 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   
>>   	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>>   
>> +	/* FIXME
>> +	 * This should be done in ocfs2_journal_init(), but unknown
>> +	 * ordering issues will cause the filesystem to crash.
>> +	 * If anyone wants to figure out what part of the code
>> +	 * refers to osb->journal before ocfs2_journal_init() is run,
>> +	 * be my guest.
>> +	 */
>> +	/* initialize our journal structure */
>> +	journal = kzalloc(sizeof(struct ocfs2_journal), GFP_KERNEL);
>> +	if (!journal) {
>> +		mlog(ML_ERROR, "unable to alloc journal\n");
>> +		status = -ENOMEM;
>> +		goto bail;
>> +	}
>> +	osb->journal = journal;
>> +	journal->j_osb = osb;
>> +
>> +	atomic_set(&journal->j_num_trans, 0);
>> +	init_rwsem(&journal->j_trans_barrier);
>> +	init_waitqueue_head(&journal->j_checkpointed);
>> +	spin_lock_init(&journal->j_lock);
>> +	journal->j_trans_id = 1UL;
>> +	INIT_LIST_HEAD(&journal->j_la_cleanups);
>> +	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
>> +	journal->j_state = OCFS2_JOURNAL_FREE;
>> +
> We may fold these into a new function, such as ocfs2_journal_alloc().
> 

OK, will create a new function in journal.c
For this area FIXME comment, the legacy comment humor & vague. In my view, we
already got the order issue clearly, why not we change it as below?
     /*
      * FIXME
      * This should be done in ocfs2_journal_init(), but any inode
      * writes back operation will cause the filesystem to crash.
      */

Thanks,
Heming
> 
>>   	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
>>   	init_llist_head(&osb->dquot_drop_list);
>>   
>> @@ -2483,6 +2510,12 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>>   
>>   	kfree(osb->osb_orphan_wipes);
>>   	kfree(osb->slot_recovery_generations);
>> +	/* FIXME
>> +	 * This belongs in journal shutdown, but because we have to
>> +	 * allocate osb->journal at the middle of ocfs2_initialize_super(),
>> +	 * we free it here.
>> +	 */
>> +	kfree(osb->journal);
>>   	kfree(osb->local_alloc_copy);
>>   	kfree(osb->uuid_str);
>>   	kfree(osb->vol_label);
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
