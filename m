Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE9FC636CC
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Feb 2023 06:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JHK+Rr8ADQmJPPHt0pzfqkC7OUlj3lgTTzkXOuvDWkc=;
 b=Ri205IR8LIaP8nLuFc1A67pfDIgaAbmyotFyduKnJIeQxM8fvCgFFuJFJrcmr0c3qcLrKVgr27rX
   IgpQM63HaqVsu27v+01qr9VgJijY8qSLMPgW2UlkHJbPqDJr6wu2kRb8uGqQ/uLIraAqPXlP1FrK
   FDX4ah6PzEGmbGVRnsUXYLcYeHomU4GW3MwavPowdR67UMkTH5LzeClZeQbvv77k0QVs+oK0RGsZ
   MzKNKxp4CDeRq0l1ZiR9+H1sOUsavHrZZ6t1Up0sS6gPs9bLeXzlxfihd2sFlF2HBtjADIqur+SD
   EmHYXxuNxmO7NWiUimTfZL1Chd6SrDvIRJru3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JHK+Rr8ADQmJPPHt0pzfqkC7OUlj3lgTTzkXOuvDWkc=;
 b=pqR0TvTBKMBJgAHQX6eFDPu2dUT0NB4r0VkmDCVnzOUeCgeYLMWY8KCYoWsI7pb5Fv3rVp8sbCID
   WeINAHPMMdnkYbkXyZABXSFmqku/AECItmpUfhRrE/QgqAMM5Pm5Cb/p8ue1V87pQ9LsO1LjHEoT
   4BUr8tNdrL9Om8BpxL1HDe1c9jO2Au8BKbXSbfVSN0DohkoMcf2R8ioUZ9DV71blVs+RaIM7ELTm
   jAoIqylS7Qzcm//ebu2gvgmIG9oYZYuKaKW7xn0MR8blsXX05IBKl0lHn/QiHv1t9e6aJll08BS6
   7XvFc1Je64YUdIiXV5fLQEZVcZFALts6L7uGwg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ300FJ7YYBNH40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Feb 2023 06:20:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve9VTOSOpQTrAub0/QGic4gw7cz0NYW99AIhdOGgVMJpx6gW7m+PB//wzk8EMVKhL4S3XPYZuANzd0UYWcdlFv8xwSsRMbJG2x4XALqt9ljQ5mU0ClRzt6UgU9qaHCkZlE/RSW1cY13p3vWYm6AIOuVQPGQu0gDpV+cxpYXPxhv9VxETSb5Ogj1UA6bRx1G4JsBF0fj5aDdvkejuNQJXKlvJcb+2kBQQGJc54FRbpXekEteTB6oc+Yg/dw5xC4Cf7INx0JORU1LR/s7pRjtIXSLJVDb4XM/8Epw0fFexhsX+KTph1BaZf06IWh5Jup/6YkBmR1UMt8DDma77FO3ddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzeexNjyVOFqnxQfreKyPhIeBxgXRkLIgkcddMZxLEg=;
 b=fCO15VwPurxzyh2jQEag5P2jVoCkR4yqP+lWp29BDAKBRcx3Q55elkMf3Jsjr7lu1H1okp85jwWmWRBvA7G+YCt+zMVumCDNiMLOlJ6GNCrWjiHux16t2UYDUx5H/NPgEAOe70cWfkmP0asW65jYiT2VAA9PAQ90KdBF9vSw7Tlw2rrRd4hPG1yPCPGfdurRiGlvkfHgWsopBlNm+Cfn6i1qm2FUoFFZBKR87PE8BhgaqD6LJehcDhXSBipuDmS+WeZ7ubBeF+HUr9ikoMnC9Xf58zkr7YDcKRZnsINrU5xDZUVtjxug1vNihtdD70OFxgNQoAnHRS/vDzGR355aSg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzeexNjyVOFqnxQfreKyPhIeBxgXRkLIgkcddMZxLEg=;
 b=KXVicFesIFE9TQXg3tejc+O3JBpHTsPkx18iRWremXCoM2/X3Zdg91EzTBz5kYWgmhzDmDpQnpERzdCdLuqVwMgJZ67HOwnbmmgKWMeI79PxhVrZqA2oP240t1JHSZKGSkyd68IcR5JBvcgDBou4Bz8sud1mw4KYXeaqaEsrZPNzN8BEDxLG2/hCcSIdC76MpfbF+B45r5x0m0W6hzUZVXBKFPCQQDSFMtba2jOY2uXJKUp/aCr6kIWEpy0y5oqTU7LeT24UQBnPodKEsAY+C3HmMkfoPzTT9x7RLvCu74cMS0AS/wyH0bqczsPdHemzsi0Z+QaiiMxViz5vnDjUMQ==
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20230210100457.xv5wchadnd7kkazb@c73>
 <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
 <20230214043344.szvhwukkdkzsky5n@c73>
 <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
 <20230214114829.zxemgnnb22sdba3l@c73>
 <6e2a7c7f-1318-b611-094c-71008d03be20@linux.alibaba.com>
Message-id: <f71ffaed-318a-f1f8-350c-fef09932feea@suse.com>
Date: Wed, 15 Feb 2023 14:20:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-reply-to: <6e2a7c7f-1318-b611-094c-71008d03be20@linux.alibaba.com>
Content-language: en-US
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199018)(36756003)(6666004)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(6486002)(2906002)(8936002)(41300700001)(5660300002)(44832011)(38100700002)(26005)(186003)(6512007)(53546011)(6506007)(2616005)(83380400001)(107886003)(478600001)(86362001)(31696002)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 06:20:17.9222 (UTC)
X-Source-IP: 40.107.249.50
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10621
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=948 priorityscore=166 bulkscore=0 impostorscore=0 clxscore=184
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150056
Cc: jack@suse.com
Subject: Re: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SGAP274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::24)
 To PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS8PR04MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: 05c8c0dd-118c-487a-eac2-08db0f1cb545
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 3eshveOKkrCRCKXkzmLsl8mmc5lJZYzhbinLRkBCWMJkWs000991yeFnETF9Hfw11Ig9ATSdI88R/bzQt+OnpG7UAEVfvAwQ5jyf1EYFBpxdFDJLgaOIYotWZBJage0Sl2FzQEwCtmB43KePU/Vf1D7IfoZdNxoZr/YJ+5MSeU0UfbFIkmIwzEK542EHj/irKcPhhqcixftNnuD9MOQTfEMmvYEwA5Vb1kWbReThTduxUnxZJNNF+AU4ZoB0N7u6/xjG+DlBG0jmae3yKRNH1RV0+hp43u3l1xUvz5x4bmQvNFi1XDuUKUm5wumMHMWlJwOBeHBA91gNT+/fXQxwNb4iO3luqI1UYDM2PyLfHQJaqC/uI2vXFrVzGi2LkZzO//4VEcRBjQ/vW2807/Be9EEj/YnOgEsFeBcFh8mv48P6VAhWHVGpAzmbtjIvhmNGxdlwZEH/BRKcxzs0K5sl/btO/C3QldgNOioe65JrkuSUY5fUi8emculhjxmtOtuC2v0mCw+8blLXfJqqUAZmZ2/mkWzPdkzQ5ZN9mzlrptKK13YNmDH742qHbbu5+d9JSLPMKtLSMdJha7CQkRyH40MCGS7c6Sz/S/jcI+s0OqyVUCNFTSGKFG3WI6GK1/Y75txAHA5haAWRRV1sYCJYKT9pMIC7Zind2bxux1SUS4YLYCq4IZLa6fSaGlJakjziPGzCxAhxlZ05Fe5q4GbTR8/wK+gX7qPn+Gmt67WJiIA=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?V1FoSkVJY1FnU3Mvb0VmSkxtUU1wVlcycUNxWDFiTGtSMXJjSHJNL1ArQ2cv?=
 =?utf-8?B?MlZNd2IvbkI0WHpCTi9UejMwbEx6RWFyZXc4cjBoN01xczhHYUVwMkd0WXJS?=
 =?utf-8?B?TlhZVmxNWjlrcmszbHRiL0xMWjJqbVMwZ0Z3cm9CVUVOWE5MMmZqT1ZPU2JZ?=
 =?utf-8?B?VURLTjFCRzFXNVh2dlVOeEJ4YUN1WHhPaUhtcUs3Sy9FRzZuZCs3VWxmR2cw?=
 =?utf-8?B?c09XZUJLWnVEaFMwT3FWR3haekFSRExqRXpWZW91NGh0V0o3ZkpjeHlERUtw?=
 =?utf-8?B?UjI5em1tbUhJMEFxYmNzVmtQVGloMnk1NGR5NWhpWDFKcGVWSXprbitRNCtm?=
 =?utf-8?B?WUlkQ0dLR0tWTUFmQllmWHZQeTNGdzUrSUttTVBSQXJYVXg2VEhsd0p1MVhk?=
 =?utf-8?B?cVRsQ0I1Tmh4UzMrazZtNXlvQktSanpyMlVIU09ZbTFGS2xFZXNkL1dEcXA2?=
 =?utf-8?B?UCtUNzYwSDREWHR0Q0V6UEFWUmhZdHVZWXY1R1VibmREbmpnL2pRcVl5MnR0?=
 =?utf-8?B?NEVSbHpIL1E4OFhHMG10YTVDVFFNT040ZmFVd1REMThkL3l3K3hmUE5MZWlj?=
 =?utf-8?B?QXdNUUVEaHo5T3hqYjNwK2tjTy9adk9lYk1lZHZxTk5XQitYVzNFSmszNEgr?=
 =?utf-8?B?VnpaYVNNV1RNSEpYZUl5SHcxWm9tc2RSbHpkcXQ3ckZEZ3YxYkM0QkpIN0Nl?=
 =?utf-8?B?UWpTbWJ3a3FmTFhUNlk0ellqM2xKemdIUlhwVDB4bFdGNzl0cGxsbjlKWHdh?=
 =?utf-8?B?OHVpbXVidkllaXpQcmxhODJmTnc1djVEd0JQdS8vT1NnSDRFc2ZuY01TdE5h?=
 =?utf-8?B?ZlYxT3AzcC9HNDVBblJUYVE1R3VjZm16bjdJa0VyelhmVWxzNURQYVFoZjZs?=
 =?utf-8?B?SFc5MVI4WGVpdmZLL2hGbmRIVng1RmtTT2EvbnV3QjEraWQ5UGIzNXhkcHlp?=
 =?utf-8?B?MG92TVoxRlNGdmFET0lRMjlSRlZhNU80UXZVVTNmTFlCMmRnOXVXZGZrY0N3?=
 =?utf-8?B?bVNFQlhJTWhXeno2dW1LQUpxdUJwZ0U0eExSSnQyTldkUlRvZnZ3OFZwTXRG?=
 =?utf-8?B?MDhqN1NRZnJPNHZDU0pWdFZscUdGZW5QVjFqbXFqUFFmZEZRZ2MyK3kraUti?=
 =?utf-8?B?ZmlIcWtXc2JIeTY3VWNGbG5Lb0w3ZnI1ZkVYUmlIY3ZNREZIVWJ6MWg5YVUx?=
 =?utf-8?B?ZUFkeFlYVUtrdTAvcVJja01Benc5MTZPK1pjMUFieDZidStKMm9wR2pPbFRQ?=
 =?utf-8?B?Wm9hbDBrMCs3NkkvZ3UyY2ZrSmpMMGRqdFl1NDk3NTFNZWx4N0l1Q3RLZjRJ?=
 =?utf-8?B?dGsyc0RJdGE2bnhXY3M0MnpZOVdNTU5IZFkvRkFWWTdQNDU0WTZ1Mi9XdFdt?=
 =?utf-8?B?bWxYd2FuWkpmeWNkK1VvVmtHYmtGbWNaWFRHcDNxcXZ1VkdxSlk0ekwwWjRt?=
 =?utf-8?B?Z2JhTVl6a2JkRzRsdHg2NU5EUitDazZaZGZpZzRYQXB2ZkFyc1NsbXdEUGNX?=
 =?utf-8?B?eG5admliQXdJL0tzQm9EakFXRVFkd25ReEU4KzFnUnJtTDN5bzIxaS9CUEto?=
 =?utf-8?B?ZVp4amFBK3pzcHZwYUdiT3dvVkx0bVZRaVJHelpKZW1CYjg5MEhCSVNpN0lW?=
 =?utf-8?B?RC84bm9hZ3gvVWw1eWh3aC81Y1BGb3hNU2w1ZForZVprc2V2d0VSRjBVTTVw?=
 =?utf-8?B?R1ZGTHA0U2ZkMzdwK2hxenZ0Q2FCcVV3aXgxOTI2cG9nOHlWUlo0NWIwMmF5?=
 =?utf-8?B?Vk51Rlo3bnJRRkJmTTZUVDkzaTRVaUp0M1piRkpKWW5JQzhrT0U2d1VhMm9s?=
 =?utf-8?B?Uy9PMnBKVHMyWms5d3RCM1Bwd1pjMVFjQ1haekpRRnRDZFduSUNacXRZT3da?=
 =?utf-8?B?RU12VlJYZGRjaGc5MWlZQXB6WTlOWHo2Tm42dUF5L1lPblZkVWdqZjhFSUlW?=
 =?utf-8?B?SVZ6eGIxM25aZkVLQjUvMWxsT0hkSFJ4QlliNU1va2JOT25aMFRVUUQwWGZ0?=
 =?utf-8?B?YVp0Q0N1dFRQaitIb2pvSStJMThLU0NNeU1XRDk0eUwvdnk3NVdBaUo1UERY?=
 =?utf-8?B?TDZ0V2ZybTd5RnhvM25tbkM1RElVM3BKbHcybmJZYWExdXpNZWlXV1ZXT3dN?=
 =?utf-8?Q?84jlL0GC/IavoytWMvwkthIHl?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 05c8c0dd-118c-487a-eac2-08db0f1cb545
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 H1foY2bVe1QPzpYLS5M5iNI79UgYTcquEkEXGYKy+tb1yQRARF4Jf9kdrr7KO0jxwGQ8CBtn31lnKvjrhl5Mrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7847
X-ServerName: mail-db5eur02on2050.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sLGw7P0HHyfJ6jggQoh5-kIcnhJZnMYh
X-Proofpoint-GUID: sLGw7P0HHyfJ6jggQoh5-kIcnhJZnMYh
Reporting-Meta:
 AAFxvKHiEAlEslJQ86WHLL6IfSRlHQ5VDdbVtQkcHdqhXfAjl5Adn0NlXrP89R/4
 1ISk93QbjcyqWAxreeyjEEpvnsUwL2J3BjR3I9xnveGBgw7UfJTAyNgiwCGpLEgO
 eiVJmTmYLE+Ea6gOwQLX1D9o0lhnWxY0rLjPF9OdiCThPf2V6gQ+SzXDQkO66uok
 Yx5MMLjLg2QrDNezlSDH1vn4C0tGwGhllGJUcFHLMT03bf1dUyMA5ao+ngrO9VWE
 f+9y9Ocq92ylT9bycVL1n4gSc6PsUqjtrrNeOxbWyzBYve+PreBKAhw+/N9HSz+r
 3EM59eS+qAtwiujwT4BaNoRxFyY8POxwQdXri3h1pgV+y7aTq9svSDqC+sGmR9Fc
 8vrU9jXBqFR7f0ujKGEBXxTL7cPKbxVC+jzUWpn4v2FAiFpe+gwSNiGtSnF2QeZL
 n7ePnKG4bMrjrG1cYt8eQHjnjgTwxQ4uMSDELIBceWDjQjRpvehihFK6X6a/7kQD
 vLoW2zbhOZOVVk00DKwPExGklUmIDJrVBU6r4049dkLS

On 2/15/23 10:06 AM, Joseph Qi wrote:
> 
> 
> On 2/14/23 7:48 PM, Heming Zhao wrote:
>> On Tue, Feb 14, 2023 at 07:08:16PM +0800, Joseph Qi wrote:
>>> Hi,
>>>
>>> On 2/14/23 12:33 PM, Heming Zhao wrote:
>>>> On Tue, Feb 14, 2023 at 10:52:30AM +0800, Joseph Qi wrote:
>>>>> Hi, Sorry about the late reply.
>>>>> This thread is indeed a long time ago:(
>>>>> It seems that I said the two ocfs2_journal_access_di() are for different
>>>>> buffer head. Anyway, I have to recall the discussion before and get back
>>>>> to you.
>>>>>
>>>> If you belive from [a] to [b.1] doesn't need any journal protection, my patch
>>>> makes sense from theory.
>>>>
>>>>  From code logic, if the defrag path (ocfs2_split_extent) doesn't call
>>>> jbd2_journal_restart(), current code is absolute correct. Increasing credits
>>>> can't help avoid jbd2 assert crash, but make more easily to trigger crash,
>>>> because it makes jbd2_journal_extend() more easily to return "status > 0". In my
>>>> view, the correct fix should delete the access/dirty pair and make sure the
>>>> ocfs2_split_extent() is journal self-service.
>>>>
>>>> Different buffer head issue could be handled by rechecking ocfs2_split_extent(),
>>>> make sure all journal handle branches are correct. I already checked
>>>> ocfs2_split_extent, but I can't assure my eyes didn't miss any corner.
>>>
>>> ocfs2_split_extent are not just 'read' operations, it may grow the tree,
>>> that's why we have to do a transaction here.
>>
>> You misunderstand my meaning, my mean: from the caller __ocfs2_move_extent()
>> calling ocfs2_journal_access_di() (below [a]) to (before) the handling
>> ctxt.c_contig_type (below [b.1]) in ocfs2_split_extent, this area is purely read
>> operations. It's the range [ [a], [b.1]) (include [a], not include [b.1])
>>
>> __ocfs2_move_extent
>>   + ocfs2_journal_access_di //[a]   <------+
>>   + ocfs2_split_extent      //[b]          | [a, b.1) area is read operations
>>   |  + if                   //[b.1] <------+
>>   |  |  A
>>   |  |  +---- from this line, this func starts r/w IOs & needs jbd2 operations
>>   |  |
>>   |  |   ocfs2_replace_extent_rec()/ocfs2_split_and_insert()
>>   |  + else
>>   |      ocfs2_try_to_merge_extent ()
>>   |
>>   + ocfs2_journal_dirty     //[c]
>>
>>>
>>> The whole code flow:
>>> ocfs2_ioctl_move_extents
>>>    ocfs2_move_extents
>>>      __ocfs2_move_extents_range
>>>        ocfs2_defrag_extent  [1]
>>>          ocfs2_start_trans  [a]
>>>          __ocfs2_move_extent
>>>            ocfs2_journal_access_di
>>>            ocfs2_split_extent
>>>            ocfs2_journal_dirty
>>>          ocfs2_commit_trans
>>>        ocfs2_move_extent  [2]
>>>          ocfs2_start_trans
>>>          __ocfs2_move_extent
>>>            ocfs2_journal_access_di
>>>            ocfs2_split_extent
>>>            ocfs2_journal_dirty
>>>          ocfs2_commit_trans
>>>      ocfs2_start_trans  [b]
>>>      ocfs2_journal_access_di
>>>      ocfs2_journal_dirty
>>>      ocfs2_commit_trans
>>>
>>> In above, [a] and [b] are different transaction start/commit pair, and
>>> each allocates different journal credits, even they are operate the same
>>> bh, they are still different operations.
>>
>> I agree above writing, but it can't change my conclusion: ocfs2_split_extent()
>> is journal self-service.
> 
> Don't understand what does 'journal self-service' mean.

Sorry for my English skill, I invent this word 'journal self-service'.
The meaning is: this function could handle journal operations totally by itself.
Caller doesn't need to call access/dirty pair. Caller only needs to call jbd2
journal start/stop pair.

Because ocfs2_start_trans() & ocfs2_commit_trans are reenterable function,
we even could add these two func in ocfs2_split_extent(). Then any caller won't
take care of any journal operations when calling ocfs2_split_extent().

> 
>> It seems the author meaning: he wanted [a] to protect defragging actions (extents
>> changes), wanted [b] to protect inode ctime changes. the
>> ocfs2_start_trans/ocfs2_commit_trans in [a] area is necessary. but the
>> access/dirty pair in __ocfs2_move_extent() is potential crash risk.
>>
> If so, what is transaction [a] protect? (no dirty buffer)

Transaction [a] protects the dirty buffers in ocfs2_split_extent().
ocfs2_split_extent() has already correctly used access/dirty pair to
mark/handle dirty buffers.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
