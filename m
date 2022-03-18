Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BB9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 18 Mar 2022 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OLgncIxvLFlw6IxGD0O/wiv9juNmJJyo/5qme4xWQl8=;
 b=HsNBAyajFAJ6jtBnae+hXpsS2gGG1aSeIiime1ZrhBMILB3P4v/JkNTwPNMVg5srkSN6cMbadS8E
   zxo8dSbNlT8DQuY29sqQjWOu7kJYEfgIWVcVdFO0zLU2CD4eOCJfZpnP16FSNKCzNra0IvEvimv0
   c4KLgnORwf7kmmvFCnT1NzJI/8GAyBKhb+1WXggD0PArxANiZqfKTut75ODqF3PO0z6F6+WxCju1
   VyArv//3cTJJc7b0bRhkDhJlJuDALFRudN6Wufol3EaQvkp87xyMrYrgUcwOC95D9KBeyyD2JXBW
   M5uL0GUcgITvEQM8NB/V87aTT169/N3prQSOBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OLgncIxvLFlw6IxGD0O/wiv9juNmJJyo/5qme4xWQl8=;
 b=SzruzuYpJmqOXNFn+JCrLUqHYTGrxlzbRM3ZdZOQGYBXJ69SqjF7yLCrZ9KAlXT6U8RkisLirx/0
   abx2TeZDwM8psrashUnRK/ulDTOQDHeeLS6pumoPLR3T8ZgTRe+PYSIY6+2/Uj5H9tMQLTx24cLz
   W1phPa3bdFmp8QxIZOv2Jy/V/FQXVVuDaV6ONPEXERFBFRVDBu995+EFyjJw8K1cYsDy8vEMzbwd
   WRvwBZ9IJSieeyiDA5upLTaMsYUbdZdLd/B8N3FG4gjja1N7Ku+8E8p2JCj7p4dxh8tFKIpOfG+i
   vuVd9HpZiDQRHdcKX4ATCDWVGLwKXLW6shx2fA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8Y00CJU3F28F90@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 18 Mar 2022 14:40:14 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1647614401;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zJ43EaRPJmP9O/PvfjOChKU2mAtQ6YgQIv5F+Bj+5YE=;
 b=C1VRWNEOPhmfcJHAwIfRVr6oK9RwsQclwAws/xc5l0o0MzCVybgVqU5ZkkzeCsjRlWYF1G
 JKMWeS8AgnW6uQhLPJWtt9QgzBSTfxZzEcYa3q6SqyNnTIYac/bVDxHEp+EeQ3Rqx/LlGD
 Su/glhPn0nEEryABy8aCPxE3Vc9FKAI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDgbvc3+9YrVMZwllO4bS3weXSqR1EQL0MfcKa95Hf8A5mCWrJrqBsRWnuup0J9P1d7KeTaT0BOSHkwjfR4RLCvq8QxxChmlYR4CctElSIVbJA+2LFccgGXMrrUevn6e/w7zrJwKb0njqJb68JXPu9uiYiJGzwYUTU4wwSpoDhuPXKxKQ4i9JtJ/AaEN2c9K96K7/T8Rxx+/aLUWSY29n917678e0dGX8V+541YSzQFmYlQCLs6vQeRocwhyvyfj42OmviK0+x2VgGXz3nY4gpqcpCAhpW2XUefACqs9Z5jePXmvREHQrM7yLnWJjUeKDj9aKw5yNjNzv/OApMNdsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ43EaRPJmP9O/PvfjOChKU2mAtQ6YgQIv5F+Bj+5YE=;
 b=Mtsntuvl5bI7WnarriLgE6urZv2/+Ay5eXVrSZ2IjEtSyIOHqEEqiRujnJs/caYBvgNAXdqQQuiGnzEnZNvoU2/hgk1pTvTWlPUHGSRmAbE999ljRGzycXn5AXvxhMXK9d5qpjElz6DzxueyU1bYmn38JZvNXz2OMmjAzEd+gDujIBNIqukCWWmzQ/zpGNyVYCUgC4bOVjHPHPQMyYewmzwQW8YaeHSX/l5amhgggRTO4B4P2dICVcqI8hV4fxodxcODcpOmK0cYS7zi3Cc9KV9DpuuBm5g8yCJOivap4nWv6Nyl6D4M0T9Rq1qiwypjnmITPHj+k02nZlQRXDD8iA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <aa8899a0-e642-cf54-c47a-4d419d5ab264@suse.com>
Date: Fri, 18 Mar 2022 22:39:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
References: <20220318134845.1749-1-heming.zhao@suse.com>
In-reply-to: <20220318134845.1749-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(316002)(83380400001)(31696002)(8676002)(66946007)(86362001)(26005)(6666004)(186003)(508600001)(6512007)(66476007)(66556008)(6506007)(5660300002)(53546011)(6486002)(36756003)(8936002)(38100700002)(31686004)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 14:39:58.9938 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289
 signatures=693715
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=198 mlxlogscore=794
 malwarescore=0 bulkscore=0 clxscore=266 phishscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180081
Subject: Re: [Ocfs2-devel] [PATCH v3] ocfs2: fix kernel crash after mounting
 when journal doesn't ready
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
X-MC-Unique: nVGFq7wrMoSysGe_O0dVkw-1
X-ClientProxiedBy: HKAPR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:203:d0::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe178a2c-58fe-4fe8-aa04-08da08ed2d4f
X-MS-TrafficTypeDiagnostic: DB6PR04MB2949:EE_
X-Microsoft-Antispam-PRVS:
 <DB6PR04MB2949C798D42AC627F4F0D74797139@DB6PR04MB2949.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 u3txs6uLVCTRaZVcay/+HMzOcX6UQKrzQK3Mlm10Zvs8pT0YbEEV1L9dm061iiA5oGW6icIXRuEIr0ro+nmZ1ZYSo58CvnwhW7qsV0YH9haMZta1vtbeZNRZW30oRwBDKUod5XYihz1/3l2t9za7yE7nxzMqntm3PcQ+uynranP2qGH3oDUDJPOCH/FNo4uNPCNhFL+zVr8CPB4TwMd6o7+28+R6tFwRO4qpWhTQuoKsGMhzzD0K9Qrl6fJ98pQYmiscXYiU8JU4URVdIV347lehAo6TvQnUuotL/0HaJWXexx4G5lfjQNnG6tkBMHqbXNjWZFLoEEOvs3RM7a6zrWQzBfYZR/SCWI7hj8tWkcj7XOwfuOm43Sk0Higu17YJCnZ8fxIWWTTFyd7zsFQt4pyCLtDq83qZJllk306jxcSKWfWLG999dym4wrnouV8kkAe+ONvGU1AhFCwunWF8aBwDHgaWsb/6R92K792CAf364ZxZJi0ffyVW+r1eYI+XEacyTeFRuBRV2SiuTEoODtKNIsvMJGNmbDvmNOQfOftO7sbRK+0l4fBzGhkbPRw1T1ee3dg40Ghu4ty0+xGQOu2bWSkykeFO/idzqLns/ZCCRJ4iNw1eZnULkKNLbHEX0hKEo786QSlOirGhDDfart5fhvhJm7KbHQva8LGiwT7lqb9bYQRcEErxBKu9UHrAdC++nJ2uB+PmATTuTWsEuLy8nixd+z5D1JdRnFQ0YKI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dzhaZjNaajhsb1NmOUhqOWtzcHZ4OTEwcm13QlVUS1dmNGV6d2pQMXAydlh0?=
 =?utf-8?B?b3ZMWTgyR29XdmF2ajdBSGZETG5tNVN2WUcrQmt4cnAzVmxGK1NUNTdkalVq?=
 =?utf-8?B?UU12L1pudTZCeXE2R3ZQQy9uN1JuSER5bWJha2kxUWUvcVZRL3J3ZTVSditY?=
 =?utf-8?B?dDdLMFRGSklLbm9Lamw5Tkk0TXlJVWMydVZRamhSVnNWbjBvY0hDempXdEYy?=
 =?utf-8?B?OHdlRVRiZ2MxcWRqYlc4c1lJM2NZNTkyTnp2S3RFemMxSkR1a2Vyb2dKQktp?=
 =?utf-8?B?ZVMvSkpBQlcrYzhGemhRVGhKMi9hSEZndnphMTA3TDQ4VDRkcC8vdGFBZm1P?=
 =?utf-8?B?Ly9HWmlac2ZRSFlMeTVzamxaVnBURTk2ZkRoUUl2VEIyN0Q3alpZYmFHVWQ4?=
 =?utf-8?B?Ry9OMDVIUEU5QmNHSFBMRktyblFISXM0WDhtelJwNThzT29lQ3M3WDhGU2dq?=
 =?utf-8?B?UHFvWUw2OXNKM2Y2YmRZeHVLbFQ4ZDRpWEtKY2pFM0NOUkpPRVhHM2VndWlW?=
 =?utf-8?B?K3E2bktVVmJ3cS9Od1ZGeC9Ubmg4cFlyT3FMaVNxMHVlYXBJN2ExYjBtcW4w?=
 =?utf-8?B?ajN3S282MDJOWkxrV0lpVlRNdFpyYXJzVGE0WnBvRDZsN0tTV3M4OFJhR2ZP?=
 =?utf-8?B?Z3dMZ0k5Z3RZdXRMYVlpd1ZDUEJFb01nOEVSNEROWVY5OTFqRzlPV3lqODJH?=
 =?utf-8?B?WlROTEFIZDVwMVhHR09TYzg3NUtNT1dEbXIxRGV3RUNpTGtlVU5wTmtscWVL?=
 =?utf-8?B?NWtiVUNmSTZualFaSi9SQUl6SWQ4N09QQzFpYW90TTRrRmc5ZmR5MHJTWkdt?=
 =?utf-8?B?aGVuOHNyZ0s2NGQ5MXk3MkNLdCtBZ3BNeGtKKyttVXgxaVhRL2xjWm9kY0RV?=
 =?utf-8?B?TlJaT3ZwM2lrU2RSSDFrbmRncjYwd3J0bTBEZi9IRnhUb29XY0hFSWtoUk05?=
 =?utf-8?B?aDc3SGhQT2hIY0U1TlozR05yajVtcThjdStHTXJxOFhicU5jeWtRMlBoN0dy?=
 =?utf-8?B?ZUUvSXR5KzZHUk94eEE4MlJkWERuZEp6bklqdlkvQkFEbmdXbHhkQ3RjUUhU?=
 =?utf-8?B?elY5YmJ3ZlFsN2QwYUhqS1M4aWRaN3ZRQ1RjTDh5bXU0MU4zb09hVHhjK3RU?=
 =?utf-8?B?V2hEcUtXZ1RydEtzcGZRQ1UzMGcwNjl5aXNOYUhmeFRTUVhsWkVaR2hPYndR?=
 =?utf-8?B?cHdQTU1PaGR6SVhJQUpqMitNWk5vdWVQOHpFbXAzQ001MlcxWU94MGdTRzJO?=
 =?utf-8?B?ZUNvMlRHQmJycGRTK3htZmJFc0lYMCtKcmo0TUJ3WEVHRlJlNnFlbGtjSHlr?=
 =?utf-8?B?dnplbEJFN1BEckQwbkw5QWlQb2hmQTlaMkJaNjZDdWRzSU5HNGZZRmI0TGlX?=
 =?utf-8?B?RnRKRXNnTk9DSmE2L2JMRlZzdkM1Z2d3b29NOHZFMXNOZEdOQmRBZzBOaXBT?=
 =?utf-8?B?bUprTVQ5QWRkY1R5dzNrdVpIWnFnOEhXMXdPRjdEUG0vZ0Vialcxckh6QTc3?=
 =?utf-8?B?UGxsUmI1bkZqTzVrNDcyZnZmRmJ0d0hFUWtTcFJoQ2VONTBvcUhuRENxQXhl?=
 =?utf-8?B?M1RadERtNytzRSt2MTJhWjYvMkthVzFEQnV6M3RzUmJHUFZ2YkowV2lHK3ZC?=
 =?utf-8?B?QnVGWlhGSG1lRG53eE96ZWkvQzdTd1c2SHdlblBJTDNFbDA0QkY5ejlEdUI2?=
 =?utf-8?B?TjkyL0ZiUHl5RnVRSHhvbmN1bFl2TjhpVGJvYW9xeXluTWdSK1J0OEkySitW?=
 =?utf-8?B?bmtGb2xkNkVNWFN5ckszSGM3eDVPZUZ5VitpZTUyZUxObldTWW43VU5JSDE4?=
 =?utf-8?B?bmREOU1BRGQvNDFlWHRUY3pzMjUvem1zUVczS3RuQjV4WExWTUVnRjU5ck9p?=
 =?utf-8?B?YW9ISDc1Y2szSHIxenNZU0RHbEdIa05nZzQrZUdRc1JEemJWMytlVnM0K0dV?=
 =?utf-8?Q?J9DWGjIJpY8iQJqbDkTTDLVzni+VwtiW?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 fe178a2c-58fe-4fe8-aa04-08da08ed2d4f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 yc/3PFxnJTwrdwVXjIhaLdIozMxMXGab8Ys76+xZQJ+nWid3susNil7G39iDfGhPdp+LgF19ZFlsG7QjpWeZsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2949
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: gWa2oFljsDM1oXREkNZ9LmGym_FnCj4z
X-Proofpoint-GUID: gWa2oFljsDM1oXREkNZ9LmGym_FnCj4z
Reporting-Meta:
 AAFmWTZtL1CGIBPTJOlPHbaQCmCaTgHedt+ho2DkLOagF4FE5fU/+VnCKlPk+bNp
 e2XEPa9W8RTzODQiPK7JZPZd0aPVwkgkHLk+QCfqdybmCBjCWpcWMw1X1OQ20+dw
 V6fwG2TX7yRTtDXRsaSoQDZqusLdSVYVFPogxMZjRM9AS1h71+9MXA3JTGGfhfs0
 EyPlWDksfMvgMcigaE/OBbFCzX/gPuyTabSFBoPtf3Qw6otHMkqT+BT294o4T2IP
 9sHY6TSztMl1v3liLiybpNM85+FC6nam1bh0J0i6+P6eqWohP/4f9BfuxiY++Vgh
 guTygupg8Yh7ZnoD/n/FTg38OyatkPjjwTnp9HgDt+mzBlmEgOQxW+RxnwtDTxhD
 cxd+cAuQuwsBCa0fqGJsrtHVPoIhkTCL8X8Rs1mob/9dhHza2r3kLxPnLkN0LqvQ
 yl9QDjcXT3VeIKLMQoc2Ct92niFUDzju5D9z1QJmRLNzJYRgW7WbidCaaqOgl4Tz
 LXtrz4e3mNPhR828qRLjYTcBsvtXEVDWAS1ifH3MMLAY

Sorry, I forgot to add changelog in patch v3, will resend it.
Please review with resent v3 patch.

Thanks

On 3/18/22 21:48, Heming Zhao wrote:
> Call trace:
> 
>    ocfs2: Registered cluster interface user
>    dlm: no local IP address has been set
>    dlm: cannot start dlm lowcomms -107
>    (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
>    (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
>    (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
>    BUG: kernel NULL pointer dereference, address: 0000000000000030
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP NOPTI
>    CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1
> openSUSE Tumbleweed b40...e84
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
>    RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
>    ...
>    Call Trace:
>     <TASK>
>     ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
>     evict+0xc0/0x1c0
>     ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
>     ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
>     ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
>     mount_bdev+0x182/0x1b0
>     ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
>     legacy_get_tree+0x24/0x40
>     vfs_get_tree+0x22/0xb0
>     path_mount+0x465/0xac0
>     __x64_sys_mount+0x103/0x140
>     do_syscall_64+0x59/0x80
>     ? syscall_exit_to_user_mode+0x18/0x40
>     ? do_syscall_64+0x69/0x80
>     ? syscall_exit_to_user_mode+0x18/0x40
>     ? do_syscall_64+0x69/0x80
>     ? exc_page_fault+0x68/0x150
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> How to trigger:
> 
>    tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
>    tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
>               --cluster-name=ocfstst
> 
>               == there is no dlm running ==
>    tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
>               == kernel crash ==
> 
> Analysis:
> 
> After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
> Journal init later than before, it makes NULL pointer access in free
> routine.
> 
> ocfs2_fill_super
>   + ocfs2_mount_volume
>   |  ocfs2_dlm_init //failed, osb->journal still NULL.
>   + ...
>   + ocfs2_dismount_volume
>      ocfs2_release_system_inodes
>        ...
>         evict
>          ...
>           ocfs2_clear_inode
>            ocfs2_checkpoint_inode
>             ocfs2_ci_fully_checkpointed
>              time_after(journal->j_trans_id, ci->ci_last_trans)
>               + journal is empty, crash!
> 
> How to fix:
> 
> create a new function _inode_direct_free() to handle journal non-exist
> case.
> 
> Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/localalloc.c | 12 ++++++++
>   fs/ocfs2/super.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
>   2 files changed, 75 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5f6bacbeef6b..c7694c2a1000 100644
> ...
>   
> +put_slot:
>   	/* No cluster connection means we've failed during mount, so skip
>   	 * all the steps which depended on that to complete. */
>   	if (osb->cconn) {


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
