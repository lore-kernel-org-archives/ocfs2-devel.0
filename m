Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CDAC00140
	for <ocfs2-devel@archiver.kernel.org>; Sun, 31 Jul 2022 09:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T8DqmiQZEeucQObHhlBunbmBeFKcO0GUKgGCcblaXh8=;
 b=zNnMog0uUeVxsBYTh5tNU9uzqV4PEKVtze+InsXjUF20GQUsN536M5ywJ5R3WHSEE7HaOcmZzkXJ
   uUOJKSbBsBqanwhC0ysacfjlG+zt1QwxedmMbCVThfoOx9cXrNAPYJSnFOc8I9edPCMwcDjp4t98
   orB2cAO4YuKMfeDtw4q0Po0NfZXhqCLdec90lYr7Iz/x+5zmjTplHdVLyynbIx95590AgYJLEt9d
   A76SdUgvLTWk/B1Xd8dxQOQ2QJBXmxsEOX8F3mM/lDoQVgnR7dMWqX76JIW6psdU0UTq4H1yV1ro
   oYFLH1ECh/hHPDITaz8+Tyto8GheQ+sDWpsTfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=T8DqmiQZEeucQObHhlBunbmBeFKcO0GUKgGCcblaXh8=;
 b=ILkVzzKBPH3cEjpnlYLqMVKMv/kZS2eTzrf5aXBl6WhyaxhtNkYatc+IaaiX2B5yAKaQzgBMNuzc
   CYS966qDMEkvbGt7+dYKc9lmD35tUnJwlWddxPz/N9xqrPNtiF6diX+JIT1brPI9MXyaf/heCuhG
   F9X2kYWzpYRjZiVr+1ynRrMmMknUQqLz1lBWwmeQHz2RkV08zCHgpOxuQEIFPnJ+DouCSC4D1ySc
   ywffPT0l1K4wYLZNvnlaiVp/bBwNOHsstnGek9eSSDeL/1Vhsmy9gmizykjxLBza2siP2SJEbmnk
   mTen9EX86e3YT93OhU4G9bxUtO3SFE/lGqQf0A==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFV002MGOC4OEC0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 31 Jul 2022 09:14:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVdEg8WHH1IFL/E0Ki9Zw0IbA6FRdnlOteLQxQfVPvFtC/4RbJjgUxBjlro1gnZ3jXqXn0pSLvFoKogrVM/EmpiQCk6LhMOoaTk5O9QUV5WwPYvZiz4xCNLAWeLetT6auacX4twLTg8ztPhFskLHSmdUceImm2iERc0snhriNnqRxKqJ1vsi7qmw1tyfDzmgwOeuwWUe41UPDuc8P5yekHAZ2jXxKvfiCltR0rx2arolmsyvK25efyrbCIVLdPNsvhZSs2tSNb4qvkI0vB7d6BK1x+sO9LtIg1vN4Yug2pHa4L5FHrCCdJgk/DCbGaN5qptyVA/4BhnTd+QiFnGRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7snZU/UkzKx0TWYtxsVcDHNTIeQtrA9l3ejd9U7DKBw=;
 b=cQ66doTPeGj9r8FXFiXzk3SPTEjnz+qorZs/eunMC6ULP8agzgN+tiSx/5ObQwhOZkQk3VIMHVdwQdDU+RYKUuW0R/lXQT/mXySzcUdT5dG+OZy8Rg2HB+qVk1folDg29l8XtybXCLdQ5hrP2a5bEE0wW4PVmM6HrWL86nB2E9QeGK1taIrJFSM/Jy5f6F0sHl7VFDOhdHHgVsLGN83W5JMNZL3cNiHM6tgpFgwdbXdE2+sDBlzwg0RF7o92qyrGLdkIQePCbPtWoM76VPQDVY2sLZfbkcSok4eyWwzpUwoLgAKajMW3Q4JHVjJ2AiJaQUYz9gJMLOui9CYeofIz5Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7snZU/UkzKx0TWYtxsVcDHNTIeQtrA9l3ejd9U7DKBw=;
 b=GyEhupQG95+ec2Kk0IMW46O4DWaRVLQ/MQpOQFqfmVDspnRZ2W2lTtK6/PKHx4gOnjejLZMCiT6/lb4YIMrH3vLjxCtgLushE3hCD10uNlLSsVHSfTsluKYT65y2sFyqQFCaVhyF3iRfuzHeuj2KgNReWaIeGXm51g/bghRp2mNaa3wxrQ7ofHrwYyfMaX2XkIK5egiBXlCnBgtzytw1SHMJvGgn9IA/VU9zc/63x3tavNTvgiiWJdGxG3Q2Lhm3vXTwiifZ79gPFQnbHUW/G+vljsQqCJb56KY0V4B7z4OQgPijBOg2xXjtzsYpqqqIim9lVhJP4Rp5a6i3fstVJA==
Message-id: <55dbb308-873c-6433-c1f2-8ca176a17be2@suse.com>
Date: Sun, 31 Jul 2022 17:13:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-5-heming.zhao@suse.com>
In-reply-to: <20220730011411.11214-5-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(39850400004)(136003)(376002)(346002)(366004)(396003)(316002)(83380400001)(66476007)(66556008)(4326008)(66946007)(8676002)(2906002)(8936002)(38100700002)(5660300002)(186003)(86362001)(2616005)(31696002)(6666004)(6486002)(6506007)(478600001)(41300700001)(6512007)(26005)(31686004)(53546011)(36756003)(45980500001)(43740500002); DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 09:14:07.8916 (UTC)
X-Source-IP: 40.107.6.74
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10424
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 clxscore=220 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=95 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207310049
Subject: Re: [Ocfs2-devel] [PATCH 4/4] ocfs2: introduce ext4 MMP feature
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
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44a77eb5-ecd3-4b66-a1ce-08da72d505bd
X-MS-TrafficTypeDiagnostic: DB9PR04MB9402:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 FlZuPDp28hYhpLgigRseZkSMzWn9Um8s1UVlg7DOZgYqcYyKuIhvNN7Gr68qUVMd9ogia9lljLt549fn0LDyzDu/Rz9MQ3cgKceOsibnGaaKSka4N3wCZvgoK/L4zGsMx/IYXjejRW9Ezqsfsm5232S3v9K+Pvzhv6IcjxywVIQH0v584SjKhLpFIldT7PV4/gIVjXgAw87QAMOlFcysQhnTqAZMT9a+DMqXj6WDPtRcV3CNFGl1U5Xss9BHmM3brDM+1ox/5umHkp6AscjYPou+P8pKWtn7DdJFxWyqmsBGPO1VBuFMKMKuMWXcZuOAcDcZh3zyTE3jpz/BcjyraVng8MhYzikhg27ICZeywlGIXFx19HPwcGFRrKWhXymw4fUHJ9AyTM1Qi+JSPJVf8swFVEwGFFh0W7uNAtvV23b4lNP/Kj6E0dL1QacxecDl8K8FQhe0d0HG3YMdXklSNOuA+e0d1UxXJaQ3GvuJmDCT9CCGm5xovyGjuIN18xOyHCzA1axuHi8xo1QI6zVnqttwgrKjuA4G8TB1frW3+1PKJLRnxfuVWzcveN51USx0GVgLLzX6DZySIaOVSa6kjMBMBw0M0TxbkDRlYYaaTSywRvyJuHTonRv70H2sfkH90nhhZrqewOPkCg1DkqhcdFNCuSH69G/qkfgzL5KOt6gdN+LLMnNn0U4RRBkf2k3Pf0UG9/kNyboaUhj8isl8s7sJ/n/70twarxtmpwF8INCK3UfSeyObMLNas7ldHuVm1YHkUcWi8ej3BLf9lx6SF8oIZU4KmS0gsoWI6w6TQwmLNhwKoEQ+xZlgIksqcebg
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?OG5Kd1FtVzh5WlJtd2dONkFhanNUelZ6VElxVmM4OEhFbTExT2NJSlZzcGJa?=
 =?utf-8?B?UjFzS05adXhWWWRrcjJ6ZitNWjk4bTJwL1VzcnVScHpZWnVBRE56b2tCYU1G?=
 =?utf-8?B?VkhWWlVXYytlMEV6QUFaRHFXSDdVT2plSG1rVWsvZDNFRm52d1M5UUMwanJB?=
 =?utf-8?B?SVlzdVJHbzlpM0ZYY3FTMXo5NlcrdHh1bmZGTGVaays1TDlVVXFOMC9naGp0?=
 =?utf-8?B?ME5lTUJUclNZdjVFV29ERTJod0c2eWpLMnpKR0Q0YTZYSW5qS2ZSbjYzR1Rw?=
 =?utf-8?B?SlBzS3pKTW9nTUIwM2oxdGlsYVQrNHpyZDdudVVOSFpOcDQvS2dOQ0c3SHNE?=
 =?utf-8?B?aU1mV25rS2g1U3pUVGJHcHJiMFFOU0FrWnR2TG1FU3pNL3hVaTRzbUQxUXoy?=
 =?utf-8?B?K1dtWEltNkZDQTQyREV6N2N6QW1DRFF4QzRjWWx5MUdUNUZZSW1VVzBoYVBn?=
 =?utf-8?B?QVMydFVuR3V5QnlKcEVpWWsrdG1aTU9vc3kvOFdRYXJnOTNsTXNXZW1LK05G?=
 =?utf-8?B?RGRPQVRHa0tXSnI4bkNjSU82YVJLU3B4VVVlQkV4WG9GbVRUcnJnK1FkcE9T?=
 =?utf-8?B?enF5Rk5NZDZqZTQ2YVFYMmg2QUlyMHVnOXQzbnVSeUZtcEVzeUdQRm5Qakpl?=
 =?utf-8?B?WnlUUUxHYkdybTBqUlB0cnVmcXgrTmdzOGxiYnQ4c085aDVkK1dXVm4xaC9j?=
 =?utf-8?B?SEh0c0dhSnJwWTh3NmhXSWIvdGpnOUlBYzQ2TFp3Rm9RNlEvMEswWmxkL3Y1?=
 =?utf-8?B?aXZrZWM0VkM1bUpncGlBakpVemJYNjVJalJLQk05dndoVWNTUW5DdlhVNWdZ?=
 =?utf-8?B?NkhNNWgxdk5oNWJEeCtRNGlPQitaVXFnL3BBV0E2OFM2bElOSUFJK2lzVnli?=
 =?utf-8?B?UkM3SXFQaFRRczNPNkFobmJ4dGNNc2NlaTJHdkszRmlOemExaWl3a202V01h?=
 =?utf-8?B?NjVESWcwOFZHTmtQS3QzOFZUS1ZacVhDRnBoOXR0T0dZTDlyaDFYWUZDdkNF?=
 =?utf-8?B?WFVFd1VEbjJpU3JvNnhyd2tQMm04NUNsTTFGeThOb3RUWTVRbkNTeTJjQ2FP?=
 =?utf-8?B?Q2VCTWJrNTkrUWZwT2J3NTJQU0FuTXZPM3pZQkVHZ1ZOMmRYNjdCeGJJN3ky?=
 =?utf-8?B?TmU4OStyOVJIVkdKTnlDVnN3SEJRNG1jRitpOFFreGVSZE4zdHV3SWVUTXNz?=
 =?utf-8?B?aGJLYnBnRHRMa1UwSEE4ZWZSbkxXYmUxL05KMmJoTUNtY0lSK0ZOckJmSXk5?=
 =?utf-8?B?aUpWaG5wRkVYWUhqald5Wkgyc28yV0VOejJqbFZuY2RmZlpqMzArTjRpMmgw?=
 =?utf-8?B?YnZzdnVUU1JaSGZmcmJJdTYrT043NXF1MmhuenVha2g1dFo4WGkwVmphUUlQ?=
 =?utf-8?B?U0FzYXNKZm5oYWttbUlKR1BoVlFXRmgyR3dPdy90V0tPVnl5Y0swOE5kdldL?=
 =?utf-8?B?K3RVYm1pVG5RQ3R6dmhpYUlZZk9wMmpRdDFwc3hiaENGbFhwK0RjWXp3VU1M?=
 =?utf-8?B?M2F0K1BwMXoxSGRWd2d6T1plRXQ1V2ZxY1E0ckdaVER2QTNWcnBSMWh5RGFT?=
 =?utf-8?B?NlBZcDBVck1jT2c3RVE0UVhFVmEwYUNYUmhybW5lTGlNRjFaMWFUQTlDTlJ4?=
 =?utf-8?B?a0grNmoxMmEzeTNoNDdYMHl6QWhneW5GcjhBTWpLTkhYVEJ0eW9keVlZSkhK?=
 =?utf-8?B?LzVpL21nNU1JQkREdFNSK0I0NFE2OGFWeUVyQmpPZ3RPaEVnSktjaVRxU0NM?=
 =?utf-8?B?N1Z1eHltM21BSEJGWkJSSG0vcEw3N2R3R3lLY1NmOTl6ZVBHM1B5RjR3Uk8x?=
 =?utf-8?B?ckIyakRMUkJMSkU0S28vcWhsTzZZM0o3emFGNGdUSmtxeFVUYmpuSld5cUNt?=
 =?utf-8?B?VDdLYU5hbzR1RlR3Rit4UGhma3djZ2MvZFFsZFJRRUluazdrZFJMaG95bFNC?=
 =?utf-8?B?LzY2K3lqK1RTZHRQZDNBNjd6WGw5THpOM2lYeUllVW1rd3FZWUE5TUFlL1lR?=
 =?utf-8?B?VWF5bXBTWDlHVkh6Z0VYbWVwekc3aWUvUHQzSGttVkxnQVdUSC9JSlkxU1NZ?=
 =?utf-8?B?WTlLaTZGQjNBeUxZMkFoYXQyY0NsejNrVHRDNFBlamlIc3hlMUJvTFQ5a1dm?=
 =?utf-8?Q?x4ITyGpVqEEJ0J8MbsmvZICye?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 44a77eb5-ecd3-4b66-a1ce-08da72d505bd
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 MahjbqFcV001V7uXKrs1T/7GooKHrEquykBDRPWUTsBSq2rki8h9LLBz3WvRFw/9SpJQ6aaAfpvcUtBniNPPfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9402
X-ServerName: mail-eopbgr60074.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: eEa6dNlF5H27mlb2A7tSXXbXbIkqVct4
X-Proofpoint-GUID: eEa6dNlF5H27mlb2A7tSXXbXbIkqVct4
Reporting-Meta:
 AAEPEWG/XbytMtae0DOcIW54iDs9g+IGQyg/jIrOd3zNi2JO/oNjCiMCjTBT0iyx
 7tYq8izl1sHVtmvDVN7aUBa/mEiwWucHdTyWmQ8SuO/kXpREW+9IqKBb/xsGVxQ0
 IixYUJy+CbGfNqQr8Jw40e/pGVPFUo9ReaLYIOZQVQsP0xk59phNil5b9jTPUnYq
 ZEL5JU9CmAdBbxmjCu/zgInp9iptDkztPbR1CtHt8n3iw8Xcg+vUKirZGbrMGcH5
 As9cHttxigxY6fWOIsbsrE9hwPykooP8e3e2WETCTHjIpTgJtt/eUIC8jVnPjYZl
 Ymgbmv/IBrvkAcHwxj0VX4QMXemUPdZGJr9PFnm/18axYfbR88E5wymNuF4pLCXB
 /0MI0zZiC9bIVJaK93bTozACehuPDtDKp+Tq09U+Zp5+SBcfnNspHPt8ze9G1dJN
 Dl2raKmNAxSKwKc9kezdUXsfsDNIzoxThWizE/eWEasPym9MFJR6Cg/39saDvh83
 NgF15dHh2wAbYQpOjLZzY1U3+tp55qoumKLiVbXcuNYU

On 7/30/22 09:14, Heming Zhao wrote:
> MMP (multiple mount protection) gives filesystem ability to prevent
> from being mounted multiple times.
> 
> For avoiding data corruption when non-clustered and/or clustered mount
> are happening at same time, this commit introduced MMP feature. MMP
> idea is from ext4 MMP (fs/ext4/mmp.c) code. For ocfs2 is a clustered
> fs and also for compatible with existing slotmap feature, I did some
> optimization and modification when porting from ext4 to ocfs2.
> 
> For optimization:
> mmp has a kthread kmmpd-<dev>, which is only created in non-clustered
> mode.
> 
> We set a rule:
> If last mount didn't do unmount, (eg: crash), the next mount MUST be
> same mount type.
> 
> At last, this commit also fix commit c80af0c250c8 ("Revert "ocfs2:
> mount shared volume without ha stack") mentioned issue.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/ocfs2.h    |   2 +
>   fs/ocfs2/ocfs2_fs.h |  13 +-
>   fs/ocfs2/slot_map.c | 459 ++++++++++++++++++++++++++++++++++++++++++--
>   fs/ocfs2/slot_map.h |   3 +
>   fs/ocfs2/super.c    |  23 ++-
>   5 files changed, 479 insertions(+), 21 deletions(-)
> ... ...
>   /*C0*/  __le64 s_reserved2[15];		/* Fill out superblock */
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index 0b0ae3ebb0cf..86a21140ead6 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> ... ...
> +void ocfs2_stop_mmpd(struct ocfs2_super *osb)
> +{
> +	if (osb->mmp_task) {
> +		kthread_stop(osb->mmp_task);
> +		osb->mmp_task = NULL;
> +	}
> +}
> +
> +/*
> + * Protect the filesystem from being mounted more than once.
> + *
> + * This function was inspired by ext4 MMP feature. Because HA stack
> + * helps ocfs2 to manage nodes join/leave, so we only focus on MMP
> + * under nocluster mode.
> + * Another info is ocfs2 only uses slot 0 on nocuster mode.
> + *
> + * es_valid:
> + *  0: not available
> + *  1: valid, cluster mode
> + *  2: valid, nocluster mod> + *
> + * parameters:
> + *  osb: the struct ocfs2_super
> + *  noclustered: under noclustered mount
> + *  slot: prefer slot number

Sorry, above es_valid & parameters comments are outdated. I will remove them on next version.

> + */
> +int ocfs2_multi_mount_protect(struct ocfs2_super *osb, int noclustered)


I forgot to run checkpatch.pl for all 4 patches. And checkpatch.pl reported many
format warning. I prefer these patches as draft version, let's discuss the mmp+noncluster
idea is workable/acceptable. If no one reject these code, I will file v1.

(For test cases, I put them in cover letter.)

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
