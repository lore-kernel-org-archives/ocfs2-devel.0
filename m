Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60F7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 14 Apr 2022 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sILeUN/3W6HLbGclyD5Hw6HfvDI0N3fj9cIx6gtMJbo=;
 b=Kb7hA9rUwYVi78qojUWe73woxNmXWhDkWJOBU9XYJdKJeRUBiq654N8y5SJ4AOBvZXWKOC8xN/oy
   wnlhAndd7ajBAi7eN/QcKWb7IBpshQ7l08+R3TZEIAwPJ3LRXeSsO/03Em+VLHXkwset8nhmACO+
   Kn/HTkJaE7sQ1nyQzRNjteGVb3dNhUzs6fwJsAH8uW+Nr/YU1GrSwY1d6/qTqgqSj0FGs4gHc35h
   bPT1ZkQX3RdPjBGqliP5coZYEot77dHEi8NXzu/iOnj8EpbjWoL3Xvbd1cVeVCeymAqOlAWIqh9A
   1NsTQnDkgUHOgfbtEEWuoC42l+NkVpQWGvrThw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sILeUN/3W6HLbGclyD5Hw6HfvDI0N3fj9cIx6gtMJbo=;
 b=VHOo74MEkg+8ijyWJFLRHthwiTqlCa3U2PGhIxHSwOXY4tYZfqcA9lUjC0xpqvpXlUucNpzrSaJE
   YR8kmBJhLL76pJLpv2dQg2ZR3EX6hdLhbqi7qtEh5NrQYblvJLhfPNgHinpJDkgAtWoFsnBgIqnu
   j0r+ktTjiqxz65mJ5PRkokSX5MpqqDKbW3CVLkHE8ySIBgC27NrBr+3ZiJS9Law0/UrO11Z+vaoS
   +7QdQ/VB7XylWjEccmPXjCXZo10GUHLE5E28gf3WmIKYPk4aQvS+7ZzLAZXByW1pCFb/sCYwnfVN
   7ZUcEB531hITLrxT5OgaLi+x4H5cxekmXNxtfQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAB0061EVF15WA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 14 Apr 2022 11:47:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649927708;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QHIfF3AangfXGJCS8EiTI+t0vKfosd2P+6C9BVIg+5o=;
 b=B8JJwU609kqYL4AEkAUGNtpAyi2ksbYfI/Lu3T/3UBod0+w3pasYoiZSJXCjWNWziLuwy9
 OkmgjU/8XjqWBQV9WLF6yJFCE371REwdicraE6r5+wjuMGME4OMW9VwcOPu2oloBcxg5AZ
 ZBBCqa3CzsYQ+7fSFwQZcpI0VWHWDSg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiDzLLt4ORhfIJ1OkWfYThuff8pI6wI0vE/u5QlPc10x4yVKUH386rl4Up3sBNHAVipujTFCXP+w4MHUD1bibDWvxDYFZCOWABtl0p2Aqlcyilr1AugoUCKesL3GtSQ5ouAOyVs1mM6+L/V9nRj4C53nBuC5tvQZ32wmFw5C6qYvGtzZizKFDo1bzWbMHtCbIRwg1k/PRbnVFirEjpxp+8ADs1dsf9gu5A3SEEVYbk90yFsNSazlU3hk1GAxaOeLocveEAS/yDOMlfjgwQ6bfa8+AtyuAQ/cO3O/iFgwZI/hKfwflL+dqQyQtOe53r8HO0cEggJj0dljDoxz46t6eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHIfF3AangfXGJCS8EiTI+t0vKfosd2P+6C9BVIg+5o=;
 b=CEiKkmq/QCXvoJpdK2k2/9SUqGiRHDBj8l63h6D82Vr/bplyJfBiAuZw8Yd2+u2E5e7bXxDHilvyroqq+Md2oLYNIH8Ojt2BUaqVDbP3STtobqYGLoHAt+Te6SlYEBAyMV9D1ubbSUE3XdGIb/PGz0ExzrFJejcN6quwn+68YwU5b6Q3CBNKYlaYOSvft0gXflSQrA/MLW4rshirvT1qaZLahlzCzJLyaCM3+CHJ3r0WeyAih0tovC2sQVrGsd5HtESMWBfMNaN9E9IXcTbKJ/ZUwNB71vW711ghw6G4tJJyxzig5Snj4V74dmDjNIuxtPxud3TqbcoB//J7j7cAGA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <2e85e979-d365-54cc-8895-d9ee9fa9e3ca@suse.com>
Date: Thu, 14 Apr 2022 17:14:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220413082957.28774-1-heming.zhao@suse.com>
 <20220413082957.28774-5-heming.zhao@suse.com>
 <283d3a96-67e8-6abf-3b38-151082f30f27@linux.alibaba.com>
In-reply-to: <283d3a96-67e8-6abf-3b38-151082f30f27@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(86362001)(38100700002)(8936002)(6486002)(2906002)(6506007)(53546011)(2616005)(31696002)(5660300002)(6666004)(6512007)(26005)(186003)(83380400001)(66946007)(66476007)(8676002)(66556008)(31686004)(36756003)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:15:04.7622 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10316
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 impostorscore=0 priorityscore=95 phishscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 clxscore=166 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140052
Subject: Re: [Ocfs2-devel] [PATCH v2 4/5] ocfs2: ocfs2_mount_volume does
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
X-MC-Unique: DA3IEMhxN1W8TszWBSVaRA-1
X-ClientProxiedBy: TY2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:404:a6::35) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5329fba5-f7be-4c32-3eb7-08da1df742ff
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3847:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR0402MB38478B0BC583A4558F69654697EF9@AM6PR0402MB3847.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 byCEQ5b4QjKQux0SZeD+n2W/v7Kr4K3CjYd49E0cfYKDj/B35tdT8Fj61TjNTLqbuO7689KtPGHd98BdTJJr3RHp6P7hxXvpgVBGnucO/p7wk+ZdiWrJqktcSkcRAq3x2z2DSC7Tp6ySiHM1rUWrvKY2GcLYn1ACe6zGYugWtg/i2XjbzaZgBZO5vrHiY5lFqXW0JZLYMoYvUJ2qaNQZlRf6iJIYRHZtYGXz2K/+hlYIqWxn4/2po6kH8lBwMO21L48kLcezD7qpYY+Fg9fcJQPMokOBz9LC/OeadinIcU95lQYhuN4H37kdpCVhnRJpA+DbOOxLuSlGTtINN/MQsoTS5ykomp0mwikRwY4Pw8Ej7/9VuZO4ohQdYLp30R9AyB9nj/wApqQpc6xikbUtwQ2wgG61zyufuY11IgEervBNoKoja+WcZmWosIFVF9cXmmmCO4Qw9b8jDVcNi2cL4JhyhhN0sPp0jvjeSL8YEv1HtuRmEM/nwvZiieLBc47oXuEBnrXJbCTX27feG0/Igs6jHhlisJ29mRBXBLKhL4qdXIjm0tffbXbzLKO3cHWe9AAjUmsV8v/hzT98UF3dm4goW2LWNPrzLQvrarOHmIWaDQXO07Bm8Kz4jZzWyYkplgAdSFfisfLks5qK6TbOzLU20O59gZAE+zb0y6wn/R1VjMr4a2BhO+cI7Okf9mNNGfyq+T/JLakRGQpz20e0AYihJcwNnPecROuWBXEbVOE=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RHZjWGlGRXBEdExDVzVXeWtsakdWUVJ6MVdjV0hPb1g5cmZKYVNMclUxdWV5?=
 =?utf-8?B?eHhFd213c0hzemoyYU10cXRDVENKcytTVFpSaGxYUWE2N3VkYWJwZi9PUlJa?=
 =?utf-8?B?b2tBYS85RGxlRmUzVW5WZldjSks3UUVWMmt4bi9VeVNqd1cxdGtPdlFkWWVT?=
 =?utf-8?B?QldUMkZZUFFuV2NhckREZnJFZFc0STdpc1NiRTVGQnFDUVBleEFTck5oZFFj?=
 =?utf-8?B?L0hxTURMOXNXbk1pUzJmWlVFQUZxZVFlcXR6SzJ1MXlPT21wYnA1eVZ4dXpm?=
 =?utf-8?B?YTRUVlgxL28xeDVMcHM1ZVpFMzVRbTdJaFlkUFNXQW9TeGJFTXRsSjQ4RDhC?=
 =?utf-8?B?RnlZbWNYUnN0eHdSWE5qRVVlODJDL3RHanloNUtpOGdwMWlGWG1BUXZSOXJt?=
 =?utf-8?B?ZE9abVl6cTdIOWhKK0RGWHlqMGh4WHRQSzZoQ3NpOXROYUhEc0hxTmYzaUZY?=
 =?utf-8?B?U1Z3V2dRNXg1UnYzdEh0aGZQeXVQdUFoYkVJd3lHSFlhaHRwL3JtTEFMM0ow?=
 =?utf-8?B?V3lXeUx6cTFNbFYybDFxOU5NcVgrV1pqNGd4aUFYS3ZlSFNOT1c4c2dPekVV?=
 =?utf-8?B?Tk0ybjhVai9ja05WRFdaRERBbUJ5VC9FTVIxd3UzbnBPUERQdDNMVDN1SUhw?=
 =?utf-8?B?UVduNzZid0hNTUxMd3llU0FWRU1PU0xGOTJqZ2dHUVJDaVVJczh2RVI4c3l3?=
 =?utf-8?B?cnNOYm4zLzh0d0lLcndySm1LcGJoUU02MlN2TkF5TldGYlJ0ajNGaVlZYXJW?=
 =?utf-8?B?QmRGTklzZXBJQ2kwc0pFalRidGdQektVZUlHckluVWliTk5BdzhOOWxMaGx1?=
 =?utf-8?B?YmxaYzEvQU4wSm9ZcVB4dXZ1aGtCdmZFSUZxN1JWNGltVndUTERMQmU1clhB?=
 =?utf-8?B?aSt5aldYeTFPaXNOaHc3WTAyYlY3QlM2WmttcEo4Q3VJekpKb0lVM25ESVYy?=
 =?utf-8?B?QVBDQTFqNE9sa1dpaGcwMThjZWd6bHFxcVNkNlJmdXpldEFwS3lvWDFibG1T?=
 =?utf-8?B?THNTdi9CZFhWTVlQeDVveGFJUFZueVhmUWxLUWZNaHppYmZjSTc5cTlyVjJ4?=
 =?utf-8?B?YUZWVkpBMzl1cTBHUjVvbWRwZ3Q5NFRtNUVFWEk5bklUaTJORkFjOU9LbU1G?=
 =?utf-8?B?K2dSVGRsNzdXOXU4a2o4c0xnTXhLY0JUTnk1U3hTbm50N0ptTmxKc3lMazk5?=
 =?utf-8?B?aFp5Skg5alhVMHhuMGlPWEJKYTRLcU80UmZuRTRydDZ4UlNjNGttZUxScHAy?=
 =?utf-8?B?Q3J4MXRvN1JnT09RamZPT3ltV0RNZUc0TWNUaVVmVHN2MTMzZDdzZ3c1bWVQ?=
 =?utf-8?B?KzE0cStDdmpWODJRWkVjMXdMMU9BV3c4dURHQ2FxcFE5ejdKVzJ1emFudHNq?=
 =?utf-8?B?UUo4bEt3T2lZajBnUDlTcG4yOEVzZVVnTUNLQ2d3YXJYb3M5WkdhL29mVTNT?=
 =?utf-8?B?d3FkK1BHMEYzN3VBaDhXS2hJeTl3Zm5qNFNoVWR4M2RzL2Q1T0pRS3picFRJ?=
 =?utf-8?B?QWJhckZScWdNekt0R01TOU5keFEycUVqYmtIVlJGdStjWFRaRDNQVkE5V0Yz?=
 =?utf-8?B?L080SFpiV1RLeHNmUUd3VTBGUG94V1dGOWllcDRoUFVoTTJHL1hQL2hPMnUx?=
 =?utf-8?B?LzA4aGFjbytFRm1mZDJRcmM0c1VsTStTWGxtQTNJTUJNWlFOdEErekpZcUpF?=
 =?utf-8?B?dHpYSGp3SzJFUXlmRE5jUGlna01lTjdmTEhBMG12R0o2QTRaRTkyd2QxeWdV?=
 =?utf-8?B?SEpwRlJjTkZYTXpFaW1QUk9Oc0o4ZFZrWjhCYTZHSDdTS0Vld0IyVlVQV2sy?=
 =?utf-8?B?TC9mZEhzbzVDOUg3dk9VcGcxSGRPOU1wS3Q0eFlDSGU0WUFWa3YrWDFLY1py?=
 =?utf-8?B?ZnFLeUh4a21seCtncjBtU2RRYThRL2NqZ0hhd0dRME9jemRncmtybllQNFBL?=
 =?utf-8?B?anVzbWxPdkpTZHcySnRORWplVmpySXAyWW5uTUFSUEt5cHB5cEY1L2VBaHFi?=
 =?utf-8?B?RXJrUVJIWDczK3hZQkVrcWhJV0d1OU9qblRIczloRk96d1d3KzRXVTE3cmd0?=
 =?utf-8?B?UFRzcElNR0Q0bTZnSEJ6b294OU5vK0tVRURQbVRsUUxaWVFSd0NYaHNXS0p2?=
 =?utf-8?B?S3N4bGFOTlNwbDJQOC96QkJZWWxVYlpwRmdJREdSdEpGK3YyTEFSMHJ2ckdW?=
 =?utf-8?B?MXVNcWpqSm1kNGsxUUtnUGlRaHF2WklYRTRSbm5ZRWw0MmpVL1NWUUErQjEv?=
 =?utf-8?B?UFk2ZVBPSFhkUkVtNGpxa0xCcTRTeVR1ekxZSHZBOUhxRjdkN1B1VDZlVm9Q?=
 =?utf-8?B?YmkxSXA4L0RlZlorWmd5VDFjTlJ6TEpOclpNdjJPTnp0UENjeUh1UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 5329fba5-f7be-4c32-3eb7-08da1df742ff
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 XwI3R+gVtrwjRFSH5vX+WgRgo2A7EMb/IFONcQQXiYjam8mobVJsMm7CYuep4tE8nzdnSSTrj91FJU9/2QMSCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3847
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 5khTJ2Q6hdgHJElsbhZw3fyoDt4AAT2H
X-Proofpoint-GUID: 5khTJ2Q6hdgHJElsbhZw3fyoDt4AAT2H
Reporting-Meta:
 AAGLR3hMqJrxVeaSrOWzLH0/+mys+2vU60hRUaiSsBErmeHJZEOjSq4fQ75cSn7e
 yrHNIgLfAPkX7EHXKyND2lrT1h734/TpdAtneu2Ry4egMGe9fZJXEaVkBm6H4sEj
 GExqW4v0PgudrMCGnY9xE+Sd5f3/8o0DfpEZy4AdXLz7fBRvD0FTqO+N+e8G435j
 3DXEMhebnKXUukQA0wH6PxETPW+MnWlKxMRFThylxK0YCe144Fbevg5F0T6T4JOw
 L6nX6B94wqrSQH4QHg3Q/SiKFFYUJznY2fvSDM81bpKBW16FyjkabHHM5ZQnYoAa
 WPCgN8yia4nRGL5U7mWDbIv7UYaGU3kitctNT/fabKha/fB0dH3rD7x+oYkW4Sjs
 rsRMhElxU3LltjYSeaQNnfMQR9SO4TM1GFr5GYGywDoc6asBtKLIcqSHcvy1XjfK
 ehziRJkvVULfl5z/35mlUipBHND1wmmZsklq450otfFhHrADp6Esj82zJnokAsal
 m6GN7sPyWqnuBG6nUDIZvn/o7wSkLx6ufqH5kOUR2J1f

On 4/13/22 19:25, Joseph Qi wrote:
> 
> 
> On 4/13/22 4:29 PM, Heming Zhao wrote:
>> After this patch, when error, ocfs2_fill_super doesn't take care to
>> release resources which are allocated in ocfs2_mount_volume.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/super.c | 42 +++++++++++++++++++++++++++---------------
>>   1 file changed, 27 insertions(+), 15 deletions(-)
>> ... ...
>> -leave:
>> -	if (unlock_super)
>> -		ocfs2_super_unlock(osb, 1);
>> +	ocfs2_super_unlock(osb, 1);
>> +	return 0;
>>   
>> +out_system_inodes:
>> +	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
>> +		ocfs2_shutdown_local_alloc(osb);
>> +	ocfs2_release_system_inodes(osb);
>> +	ocfs2_journal_shutdown(osb);
>> +out_super_lock:
>> +	ocfs2_super_unlock(osb, 1);
>> +out_dlm:
>> +	ocfs2_dlm_shutdown(osb, 0);
>> +out:
>>   	return status;
>>   }
>>   
>> @@ -2393,14 +2402,17 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
>>   	return status;
>>   }
>>   
>> +/*
>> + * If this function returns failure, caller responds to release
>> + * here alloced resources.
>> + */
>>   static int ocfs2_check_volume(struct ocfs2_super *osb)
>>   {
>>   	int status;
>>   	int dirty;
>>   	int local;
>> -	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
>> -						  * recover
>> -						  * ourselves. */
>> +    /* only used if we recover ourselves. */
> 
> Malformed. Actually I don't think we have to touch this function.
> 

OK. Will roll back my changes.
My original intention is to add comment at front of this function to info caller.
To remind them to don't forget to release the alloced resources when fails.

- Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
