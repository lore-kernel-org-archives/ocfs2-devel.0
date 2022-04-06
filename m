Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF8DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/aDwkc3h3lzEkCDGgGA6U8MVL+Gm5o4buu6kTJ2zBWM=;
 b=Xc32tsIilqJ2CPtLOpSGObnyRzIPPKaRmIh6hEc2BRqRcy3WiFB+VZ/7Bl0KQnjd6fC2CcbmTxQv
   7z2/0Zh5/LCiliG9YoxiKA2rZK6WXgQFIjyVhHPUWp5zF0ZJkpAZFYtTF5bLZ5hOYZVft0cA+6QK
   rxUQAXTfVYmp/LEd4BbGD9VD4qmbb5cCsnGLLyHl94JF09D3S3+x38ESbmNdIvMcZDgvX7lksYNH
   y+9CbThlbtLJQ26RbnXBFyO79Fgu433ByHqvABqfCc2rJ53Om9tgpgUIQ59P5H+j+E8GUWUa/1Ts
   7t3UQODhHiQ33lcWaG1P9AIZdPh0eC/MjiBMHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/aDwkc3h3lzEkCDGgGA6U8MVL+Gm5o4buu6kTJ2zBWM=;
 b=fBlqKty35jdmBvPZowj4+oEe/iUMu0IjQtYDMVQiuLcLp0f4Fr0c/01+gQzHzRb2d7V4B2YTPy1p
   ZJk29Dud1kOVX5JGP7hOVl22FbwohBfZq01mSrBXTrLoLP6iOStoti9rTZxzMZ09E5bNUPI0MVSO
   BDJaRtv5FV8mz2YoJ3tGdFuYV1i+1kxyTRhiMw+XrHPw3iyb6wTST+/GzeYaeOFey0K57/vTuArz
   GDOJUcQ4Kn7MuRHRFPueLRHvtuG1V3ajMuce4WeLFhe4RriHzZ8H1zr0PBYaAIL17lMMDl91V02V
   qP/1tlcxwSmTzQTLZH+IqXA/PPMlRdgIjqjfsg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9X001IZBOGPMC0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 15:14:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649258060;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tCCHQDbEk3Coof3B/THQrCRGL+0Gs1Atpy2vx/pJuTs=;
 b=BCim7ay6/ICe5YmOHPSsI97Cvw5n0bhQ2Js44B/NcMn9ZbalJSGxWwwxPljjdHrTc5FLrx
 a9653AIHB1Q5udcdInAubNUb38GI5wajnHqRyKyvrmTQEeVAAcRWE5uL/EpXV5g3UtQNfr
 AvoOJl3by40vL1AqM2nY3UUZbShlnd0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOfOa4QSujoH/L/nNkJLstE9kTTQK3G3LHxUCz8fjBRXD10XnkDzVjLRzqOBHVKI02JBp0GZE0s1cB9sWGTKSbmoZlwHd4mVeYJUiRbuJC5OM8SNrFRm9eddTAjorlZ8RHni41wEXqJAzKFuQxqVZKjUbj9ahcr/iGNxGsHB+lt1kj8uWHzU+w6lFQ8yRF51mHIcR6DaiEzd+Uk79FlLED0lV6YaBBPNXDB/OeSsGzwMHQ/UfndAeKW4i1Jl1NF9VS+P4dE1Lt2QMthPk66E2YTGeQr/awYFpBD11i/jkl0b37Tcqjttfm+I1oShpdG4Zqdrv92WwprCzb6O2aM3qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCCHQDbEk3Coof3B/THQrCRGL+0Gs1Atpy2vx/pJuTs=;
 b=OlY916Rn5kQbIvgyTwASFn5/+ufbilVFClf5m1nK8+u4TEwhBzKt7PXG7WtQpbI9CtE5hsyGBHA/O7Lys3KyycBnG5IDB/iyUSgISNDYYQ1GZgfNBnCfvJjPzor/CeTXbS3mptw3suxlIxgYcM4pF4ztaVrHyjrdg4/jff2lvH+wJSu3UwJ4AJ0wiUd2FaER42qRAJtc9I4PLK/gaKkNNJ4FPyvkkRAnSZ5/mueASUeyZzyo1sSUqpzUZnbcmpy6WeqNioqoZ6EoaE+CjBQxajJDKLtsTMK17tqdx2I1mFRnxezwD7us2Dvkzxlx0Q7HHZKmpqWxEH9Z4udB0EhmDQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <05048ce3-b12f-dc00-5ff8-4e5d9e123d76@suse.com>
Date: Wed, 6 Apr 2022 23:14:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220404164055.1434-1-heming.zhao@suse.com>
 <f0bee20d-9f3d-0fce-e20b-0a24e3d7025c@linux.alibaba.com>
Content-language: en-US
In-reply-to: <f0bee20d-9f3d-0fce-e20b-0a24e3d7025c@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8676002)(66556008)(38100700002)(66946007)(66476007)(316002)(6666004)(86362001)(2616005)(6486002)(508600001)(6512007)(53546011)(36756003)(83380400001)(6506007)(2906002)(31686004)(26005)(186003)(31696002)(5660300002)(30864003)(8936002)(21314003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 15:14:16.9731 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=192 impostorscore=0 clxscore=211 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060074
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix error handling during mounting
	stage
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
X-MC-Unique: gmxBPDkZOp6vBcFJ7uh3Rw-1
X-ClientProxiedBy: TYAPR01CA0208.jpnprd01.prod.outlook.com
 (2603:1096:404:29::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5f84fff-f96a-4bde-a36c-08da17e01dcf
X-MS-TrafficTypeDiagnostic: AM0PR04MB7106:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR04MB7106F9CE4A27018DDDD18AD297E79@AM0PR04MB7106.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 V5MAHZLoAnRf6Arpaz0YBrdgPVSIJRTX96Hie/VIlZ7epUKy0CL6F958qytVfnNdF3KflWFVpNBwmlzacgOI73hwIPNtn9gQH69QpJ/k1blTEAsnlStCvK+on4dXNyDZTDczxtG0Hu5Tf6gq94m7VvMaj8uEPUknIZdSIB3hUyfyJGP6t6PGz1pTaBeUXHJVKyBFu8UAfEcFKQibSgNo8Y+zI05mpXzb53s60XjXDfZ9OVnDLM7rIPD/D+4rKjwGjm+5PPSnC9i1hhxddJj3NfkvN3KzDiH9vvux+YEilWHspqDcWFnnzcr0mrrWxUB/e7H1KrY/Zv+83cKbIEoEO33bCYyvzGdu8tBqV9nuwBqt+SVEapb3o/VwMEB4yPOROOTeQlv0q30kYWEe1sx23IwWhS21IMVJNzZ7GaE03MyoHNAYJHwiTr9o2M5O1z6AcP8InZEZil9+CnayA4WTEFvjdM7RJvkYAvdr/zlROsCqcB5NADopm51TcfciCziTVm3aU7qomEzT7A9ElyWAEvCR9LnDWq2x0aqea6+JwniVKH0GiwIQwQwp4MFB2H22GAVoGgnCqK9O2/GNbt3Bzyet+b55sOo+5Mbc2uDnOVswQrh4mzOf4WbPKFw0/V94sCu2IB+CxoT19THYcZ0TVZH/+oqnczqWdDZT3/abHDte4tbsd1lvhqdX7ewRjcz9vuHZJzEGpkunjSmlWabYHBdxe8J4m7NNVfQFry4b/SM4ADiktxjBPWQ4bNaiwJQe
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YitVOWZnSzJZdTcrS3hHaE1JMURHKzNnK1ZJSFFDVkMyZ2oyOXg1MnpZNzdG?=
 =?utf-8?B?L0tzZURLVUtNQTNkbUVpVnFrREx1clJSTXNBUFgvSG84RHZwQm10TmVwSnhP?=
 =?utf-8?B?RzByemlCbTN5STlHRGI1UHBNYUhwYTRHSTFqQ2pLWTJudUhod0ppQm9Cakk4?=
 =?utf-8?B?MUtvb1VtcjdMN1ZHMlNDUU55SW9lMFdOdVgxcXQ3YU9qbEU5K2dZSjFXS1lB?=
 =?utf-8?B?Y2tUNm5QS3lFdHJBWnRIQWRnNFdoVmRoYytyc3lCNnl1MEZHc1FvOTFEV283?=
 =?utf-8?B?cVJLM2FqanZmTHNGQU9LSERnTUlVYlBic1I5YlJOY1NxMlA5TG9FYmRGVllr?=
 =?utf-8?B?VVE2djZkL1AzcWhRS3ZITVN3ekM3aVNkcUVvaGs5WjBKdCtDdkZ2NFdqaHho?=
 =?utf-8?B?dnl3bG1wTGVlMU1JZlVPV1VYOWJXWjJzSEpzSlh5b05VNkpBQ3lBb3pPbm5m?=
 =?utf-8?B?VXNvb2F6TlB4WWdNVTRBRXJzM3ZWUXorQ1NvRWFnSUV0KzhBekZoSWZrUjY1?=
 =?utf-8?B?M2VVMXl5dUs4a2ZMSVVvZDU4Z0lqZHNpOHBQeFU1UXNtRE9nTW1XSHRoU1l4?=
 =?utf-8?B?cEdQMEZOcGxYdHczSzJqd3JQaFZJMXVXVjJkaS83NFk0c1FHcGR2d1FJbURR?=
 =?utf-8?B?bW51WEdhYVRkMUFLWG8wRExaTHNOVUN2WmdiVmJBZlYwSnBaMVZLRStyNGpI?=
 =?utf-8?B?MW5vV3dNUXV5cVZTMm9aUFZxWVR1RENkanlyNEwrMXZNY3FPMUtwbitVc0g4?=
 =?utf-8?B?Qjk0SzJHeEFFb2c2eElNQVYrOEdNQTd3WXI2cTB0VzYxdHR1bkx4RGNmVllT?=
 =?utf-8?B?Zm5IS2x4bHk3dGVYc2lRZHJFZ2VmemtuM2N1dnhsd3BTVXFlRSt4MldkWUtn?=
 =?utf-8?B?MHB5Z01IUlpMYkR2Y0hZYUZ2K3EvOWdwbXZHMUJ1UmFGRU54Ny9VYzUzeFk1?=
 =?utf-8?B?RXZLTHVhY2lXM2QrWnpOUklybEQ5T2cvNmpJUHFBZW0xd0pTRXo5ZWxUU2g3?=
 =?utf-8?B?VjhjWjlJT2lRaUFXR2JHWTAra0M1TGVsM0FFRE4vb21Ud3NiUmY1cXpQa0Uw?=
 =?utf-8?B?dGpKeVNFeml3TzBZUFcwSXBpbkJBOGxraTJSdHhoQjAzbTF6dzVZZmIxVko4?=
 =?utf-8?B?OGpqK3lpVjMxRmxjSnJ6ZkRTL2NJdFFOa3NUR1J1TWkwWno0dVhKWnpLeDNq?=
 =?utf-8?B?TTJiMHB6bkZZeHZrYmtVZ2x5TGV2TWl5ZUh0MGRiWXkvdHArTnNUb2M3OFh1?=
 =?utf-8?B?NGZLbUlHMjg1Q0VwNnd1cDNSOWprV3VmVWNJekR1U0ZSaTVYdVNrR0hsY094?=
 =?utf-8?B?MDB3K01NamVZd2FYbExEcGNFVHZKbDA0K1EyRXR6ZFR3Mi9sY2pyd0NYTVZX?=
 =?utf-8?B?YVpHMG0zSHpCYlBVUlpVYjkreVRhbGRxekt4aHR2Z0NuRm1GbU1XNFJITzRm?=
 =?utf-8?B?V1JYV3BvamtBSmRrQnA5bjI5ckNTU1h0V0dlVVZuak4xTGFSalYwZTgvdVhh?=
 =?utf-8?B?ckNEZzRuK2FGaTdwbmUydlh6Nm9wMDBTbGtTT3hOTmdVZVZSd1JidnE4NmxO?=
 =?utf-8?B?QUNTT2krTTJHWXErUS82Z2pJWWk3Z1ZKVkthZHpPcmc2Q0tVTlJlUE9idVkw?=
 =?utf-8?B?S09ibDNQK210aDhnK0ZyZVRVNjlsL1lEdVRCTkJLSWpZbFZNd3JZbVZhNWk4?=
 =?utf-8?B?T2VKMEVNVU1GTDljNWhRK1piN3UwSHprWHNMajJrZmtrU2NERXlvekk5czVC?=
 =?utf-8?B?aElXbVZCTUlqVXd1REM1U3A0cVpkM1N5UmxmNmlwOUlFbERnbDJEanlxSUNz?=
 =?utf-8?B?cm94d0RTYWQrOEpmSXNVRG9kNzFWcWRDNFJQYVpSSEdBV0tFcVE1bFlrMnYz?=
 =?utf-8?B?MzUwRDZSWWNRZytTZUZkVFpkTnpHbTZXb0t3a1dySzlqbXlOR2RQZVQyc3pC?=
 =?utf-8?B?dTduNU82ZnVGNW1XNktQMi9pb1pXbmpIanpKOUNFR0swdHNUUWVjSk9zUTlX?=
 =?utf-8?B?ejhsaXNTaTJoYzcvNHRqUU9BYkZKMTZhdTJrNTkvSWNmdFE2ZlFwNjVSU0x0?=
 =?utf-8?B?R2w0Nlh4dlcwamk1S1JnbkpKeW8rYklzcStQcXlQQWV6bDc1cFI5clpZYS9L?=
 =?utf-8?B?ZWtPcmZQNjY4VmRqZ2NmdHpoaXl1bjU5Q0RHU3BsQXphOHJHckZ4OThqeUZG?=
 =?utf-8?B?VWRLRWRvNlJnMW1WKzhVVzlHWGFGTWovcTRLeERQV3cvSGgvTUhoUkJOL25p?=
 =?utf-8?B?OWlWK1VBb1lHM3lUTFFCcEdlS0hGUTZUWkJLaHY2MEkxajJvdXU4SW5pelJO?=
 =?utf-8?B?Um9kb2FoZ0NEK0l1aDdUTzc5eEJHblVubE5CYURqY1BWT2xlRFgzQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 e5f84fff-f96a-4bde-a36c-08da17e01dcf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 PclEGqMpIff7xEQfXB9R+KDHA/xaU+Ssrmgu1ULnjNNNHafDtDb/WFXBWWQ7J08RfW6PAnvfnxnocUoD54hOnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7106
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yJnHjhaL4rAv8bKQdChTnpnnzNJZgMzy
X-Proofpoint-GUID: yJnHjhaL4rAv8bKQdChTnpnnzNJZgMzy
Reporting-Meta:
 AAELJ+jiixwTZPV6n3UfCKTtjekvnTSddfbMwuTajImxmGQWw0CABB7DF4m1GwHs
 vkFYhQqkQVn6jovVmWXEtdbxYzc8Ws53pc7JJQCl3NN7dPhq5xt8FVBpZi/Y/ejw
 ak+zaMWSpsnI6nZx+/qrKUwGvzIeMDNmMTnGDH7mivOtE/5QAUeLVQw8cnWZinSL
 EWSQqxonyGlbd6B9Lfg81grcVfFUybXiAy3Wxlvy1xPqamkQqft+trgaqJFMxrm4
 dZGUS+v+GfY71t3tVFjeHimHqC7dKSYanF7/aUPPwqNbPbPtxbcW/dS4QKFPq9PP
 KT8ILND0m+SdA19xXg5BlHTby4flCmDjEzwANyPZQNwuvoT7Lu0diBeWyrQbkga1
 tCqdct31EFwbYB0g81n1S0+0XiFuBXTSdjWnuQJFTtuOcfH+gvDMbh6Zx0QcPxf8
 zUgkNJzMnCK+hNp3Ei4dAaX/0Pn6dxfPRAkeilVEOFHwwZjtsWKF1RBLNW0QIm7i
 6ZLAgrExf30wkQxKA2kXQoLO09tK20DKaYNR6BEuyrH2EQ==

On 4/6/22 17:27, Joseph Qi wrote:
> 
> On 4/5/22 12:40 AM, Heming Zhao wrote:
>> This is draft version, It only passed compiling & mount/umount test.
>> I want to know if my idea is acceptable for maintainers.
>>
>> There left one issue: mounting crash when no dlm connection. I still
>> can't find out a better solution without directly free inode memory.
>> So I marked the related function (ocfs2_release_system_inodes) with
>> comment: "/* FIXME crash when no journal */"
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/reservations.c |   4 +-
>>   fs/ocfs2/reservations.h |   2 +-
>>   fs/ocfs2/super.c        | 156 +++++++++++++++++++++++++---------------
>>   3 files changed, 99 insertions(+), 63 deletions(-)
>>
>> diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
>> index 769e466887b0..a9d1296d736d 100644
>> --- a/fs/ocfs2/reservations.c
>> +++ b/fs/ocfs2/reservations.c
>> @@ -198,7 +198,7 @@ void ocfs2_resv_set_type(struct ocfs2_alloc_reservation *resv,
>>   	resv->r_flags |= flags;
>>   }
>>   
>> -int ocfs2_resmap_init(struct ocfs2_super *osb,
>> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>>   		      struct ocfs2_reservation_map *resmap)
>>   {
>>   	memset(resmap, 0, sizeof(*resmap));
>> @@ -207,8 +207,6 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
>>   	resmap->m_reservations = RB_ROOT;
>>   	/* m_bitmap_len is initialized to zero by the above memset. */
>>   	INIT_LIST_HEAD(&resmap->m_lru);
>> -
>> -	return 0;
>>   }
>>   
>>   static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
>> diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
>> index 677c50663595..6e5559d6940d 100644
>> --- a/fs/ocfs2/reservations.h
>> +++ b/fs/ocfs2/reservations.h
>> @@ -81,7 +81,7 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
>>    * Only possible return value other than '0' is -ENOMEM for failure to
>>    * allocation mirror bitmap.
>>    */
>> -int ocfs2_resmap_init(struct ocfs2_super *osb,
>> +void ocfs2_resmap_init(struct ocfs2_super *osb,
>>   		      struct ocfs2_reservation_map *resmap);
>>   
>>   /**
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 477cdf94122e..04d7bc7e1110 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -112,6 +112,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   				  struct buffer_head *bh,
>>   				  int sector_size,
>>   				  struct ocfs2_blockcheck_stats *stats);
>> +static void ocfs2_uninitialize_super(struct ocfs2_super *osb);
>>   static int ocfs2_get_sector(struct super_block *sb,
>>   			    struct buffer_head **bh,
>>   			    int block,
>> @@ -458,6 +459,7 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
>>   			continue;
>>   		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>   		if (!new) {
>> +			/* FIXME crash when no journal */
> 
> I don't have better idea at moment, so we may factor out part of journal init
> and put bofore.

I will do the revert commit da5e7c87827e8 job in next patch verion (v1).

> 
>>   			ocfs2_release_system_inodes(osb);
>>   			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
>>   			mlog_errno(status);
>> @@ -488,6 +490,7 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>>   			continue;
>>   		new = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
>>   		if (!new) {
>> +			/* FIXME crash when no journal */
>>   			ocfs2_release_system_inodes(osb);
>>   			status = ocfs2_is_soft_readonly(osb) ? -EROFS : -EINVAL;
>>   			mlog(ML_ERROR, "status=%d, sysfile=%d, slot=%d\n",
>> @@ -989,28 +992,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
>>   		status = -EINVAL;
>> -		goto read_super_error;
>> +		goto finally;
>>   	}
>>   
>>   	/* probe for superblock */
>>   	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
>>   	if (status < 0) {
>>   		mlog(ML_ERROR, "superblock probe failed!\n");
>> -		goto read_super_error;
>> +		goto finally;
>>   	}
>>   
>>   	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
>> -	osb = OCFS2_SB(sb);
>> -	if (status < 0) {
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> -	}
>>   	brelse(bh);
>>   	bh = NULL;
>> +	if (status < 0) {
>> +		goto finally;
>> +	}
>> +	osb = OCFS2_SB(sb);

please note I move "osb = xx" & "if (xx)" after brelse(bh);
So bh don't need to free in goto label place.

>>   
>>   	if (!ocfs2_check_set_options(sb, &parsed_options)) {
>>   		status = -EINVAL;
>> -		goto read_super_error;
>> +		goto super_out;
>>   	}
>>   	osb->s_mount_opt = parsed_options.mount_opt;
>>   	osb->s_atime_quantum = parsed_options.atime_quantum;
>> @@ -1027,7 +1029,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
>>   	if (status)
>> -		goto read_super_error;
>> +		goto super_out;
>>   
>>   	sb->s_magic = OCFS2_SUPER_MAGIC;
>>   
>> @@ -1041,7 +1043,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   			status = -EACCES;
>>   			mlog(ML_ERROR, "Readonly device detected but readonly "
>>   			     "mount was not specified.\n");
>> -			goto read_super_error;
>> +			goto super_out;
>>   		}
>>   
>>   		/* You should not be able to start a local heartbeat
>> @@ -1050,7 +1052,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   			status = -EROFS;
>>   			mlog(ML_ERROR, "Local heartbeat specified on readonly "
>>   			     "device.\n");
>> -			goto read_super_error;
>> +			goto super_out;
>>   		}
>>   
>>   		status = ocfs2_check_journals_nolocks(osb);
>> @@ -1061,7 +1063,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   				     "unavailable.\n");
>>   			else
>>   				mlog_errno(status);
>> -			goto read_super_error;
>> +			goto super_out;
>>   		}
>>   
>>   		ocfs2_set_ro_flag(osb, 1);
>> @@ -1079,7 +1081,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   	status = ocfs2_verify_heartbeat(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto read_super_error;
>> +		goto super_out;
>>   	}
>>   
>>   	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
>> @@ -1094,15 +1096,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	status = ocfs2_mount_volume(sb);
>>   	if (status < 0)
>> -		goto read_super_error;
>> +		goto debugfs_out;
>>   
>>   	if (osb->root_inode)
>>   		inode = igrab(osb->root_inode);
>>   
>>   	if (!inode) {
>>   		status = -EIO;
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> +		goto journal_out;
>>   	}
>>   
>>   	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
>> @@ -1110,7 +1111,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   	if (!osb->osb_dev_kset) {
>>   		status = -ENOMEM;
>>   		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
>> -		goto read_super_error;
>> +		goto journal_out;
>>   	}
>>   
>>   	/* Create filecheck sysfs related directories/files at
>> @@ -1119,14 +1120,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   		status = -ENOMEM;
>>   		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
>>   			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
>> -		goto read_super_error;
>> +		goto journal_out;
>>   	}
>>   
>>   	root = d_make_root(inode);
>>   	if (!root) {
>>   		status = -ENOMEM;
>> -		mlog_errno(status);
>> -		goto read_super_error;
>> +		goto journal_out;
>>   	}
>>   
>>   	sb->s_root = root;
>> @@ -1178,17 +1178,22 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>>   
>>   	return status;
>>   
>> -read_super_error:
>> -	brelse(bh);
>> +journal_out:
>> +	mlog_errno(status);
>> +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
>> +	wake_up(&osb->osb_mount_event);
>> +	ocfs2_dismount_volume(sb, 1);
>>   
>> -	if (status)
>> -		mlog_errno(status);
>> +	return status;
>>   
>> -	if (osb) {
>> -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
>> -		wake_up(&osb->osb_mount_event);
>> -		ocfs2_dismount_volume(sb, 1);
>> -	}
>> +debugfs_out:
>> +	debugfs_remove_recursive(osb->osb_debug_root);
>> +super_out:
>> +	/* FIXME crash when no journal */
>> +	ocfs2_release_system_inodes(osb);
>> +	ocfs2_uninitialize_super(osb);
>> +finally:
> 
> Missing brelse(bh) since it will goto here if ocfs2_sb_probe()
> fails.

No. please also check my previous comment. if ocfs2_sb_probe() fails, bh is
released before return. and in normal code flow, bh will be released after
ocfs2_initialize_super() return. So no need to call brelse(bh) in error
handling place.

> Suggest we name the label as out_xxx, and I have to take more
> time to review the above changes.

OK, will change in next patch version (v1).

> 
>> +	mlog_errno(status);
>>   
>>   	return status;
>>   }
>> @@ -1803,11 +1808,10 @@ static int ocfs2_get_sector(struct super_block *sb,
>>   static int ocfs2_mount_volume(struct super_block *sb)
>>   {
>>   	int status = 0;
>> -	int unlock_super = 0;
>>   	struct ocfs2_super *osb = OCFS2_SB(sb);
>>   
>>   	if (ocfs2_is_hard_readonly(osb))
>> -		goto leave;
>> +		goto finally;
>>   
>>   	mutex_init(&osb->obs_trim_fs_mutex);
>>   
>> @@ -1817,44 +1821,54 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>   		if (status == -EBADR && ocfs2_userspace_stack(osb))
>>   			mlog(ML_ERROR, "couldn't mount because cluster name on"
>>   			" disk does not match the running cluster name.\n");
>> -		goto leave;
>> +		goto finally;
>>   	}
>>   
>>   	status = ocfs2_super_lock(osb, 1);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto dlm_out;
>>   	}
>> -	unlock_super = 1;
>>   
>>   	/* This will load up the node map and add ourselves to it. */
>>   	status = ocfs2_find_slot(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto super_lock;
>>   	}
>>   
>>   	/* load all node-local system inodes */
>>   	status = ocfs2_init_local_system_inodes(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto super_lock;
>>   	}
>>   
>>   	status = ocfs2_check_volume(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto leave;
>> +		goto system_inodes;
>>   	}
>>   
>>   	status = ocfs2_truncate_log_init(osb);
>> -	if (status < 0)
>> +	if (status < 0) {
>>   		mlog_errno(status);
>> +		goto journal_shutdown;
>> +	}
>>   
>> -leave:
>> -	if (unlock_super)
>> -		ocfs2_super_unlock(osb, 1);
>> +	ocfs2_super_unlock(osb, 1);
>> +	return status;
>>   
>> +journal_shutdown:
>> +	ocfs2_journal_shutdown(osb);
>> +system_inodes:
>> +	/* FIXME crash when no journal */
>> +	ocfs2_release_system_inodes(osb);
>> +super_lock:
>> +	ocfs2_super_unlock(osb, 1);
>> +dlm_out:
>> +	ocfs2_dlm_shutdown(osb, 0);
>> +finally:
>>   	return status;
>>   }
>>   
>> @@ -2110,17 +2124,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   
>>   	init_waitqueue_head(&osb->osb_mount_event);
>>   
>> -	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>> -	if (status) {
>> -		mlog_errno(status);
>> -		goto bail;
>> -	}
>> +	ocfs2_resmap_init(osb, &osb->osb_la_resmap);
>>   
>>   	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
>>   	if (!osb->vol_label) {
>>   		mlog(ML_ERROR, "unable to alloc vol label\n");
>>   		status = -ENOMEM;
>> -		goto bail;
>> +		goto recovery_map;
>>   	}
>>   
>>   	osb->slot_recovery_generations =
>> @@ -2129,7 +2139,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->slot_recovery_generations) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto vol_label;
>>   	}
>>   
>>   	init_waitqueue_head(&osb->osb_wipe_event);
>> @@ -2139,7 +2149,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->osb_orphan_wipes) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto slot_recovery_gen;
>>   	}
>>   
>>   	osb->osb_rf_lock_tree = RB_ROOT;
>> @@ -2155,13 +2165,13 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "couldn't mount because of unsupported "
>>   		     "optional features (%x).\n", i);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto orphan_wipes;
>>   	}
>>   	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
>>   		mlog(ML_ERROR, "couldn't mount RDWR because of "
>>   		     "unsupported optional features (%x).\n", i);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto orphan_wipes;
>>   	}
>>   
>>   	if (ocfs2_clusterinfo_valid(osb)) {
>> @@ -2182,7 +2192,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   			     "cluster stack label (%s) \n",
>>   			     osb->osb_cluster_stack);
>>   			status = -EINVAL;
>> -			goto bail;
>> +			goto orphan_wipes;
>>   		}
>>   		memcpy(osb->osb_cluster_name,
>>   			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
>> @@ -2208,7 +2218,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
>>   		     osb->s_clustersize);
>>   		status = -EINVAL;
>> -		goto bail;
>> +		goto orphan_wipes;
>>   	}
>>   
>>   	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
>> @@ -2220,14 +2230,14 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   		mlog(ML_ERROR, "Volume too large "
>>   		     "to mount safely on this system");
>>   		status = -EFBIG;
>> -		goto bail;
>> +		goto orphan_wipes;
>>   	}
>>   
>>   	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>>   				 sizeof(di->id2.i_super.s_uuid))) {
>>   		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
>>   		status = -ENOMEM;
>> -		goto bail;
>> +		goto orphan_wipes;
>>   	}
>>   
>>   	strlcpy(osb->vol_label, di->id2.i_super.s_label,
>> @@ -2247,7 +2257,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!osb->osb_dlm_debug) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto uuid_str;
>>   	}
>>   
>>   	atomic_set(&osb->vol_state, VOLUME_INIT);
>> @@ -2256,7 +2266,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	status = ocfs2_init_global_system_inodes(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto dlm_out;
>>   	}
>>   
>>   	/*
>> @@ -2267,7 +2277,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	if (!inode) {
>>   		status = -EINVAL;
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto system_inodes;
>>   	}
>>   
>>   	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
>> @@ -2280,19 +2290,47 @@ static int ocfs2_initialize_super(struct super_block *sb,
>>   	status = ocfs2_init_slot_info(osb);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> -		goto bail;
>> +		goto system_inodes;
>>   	}
>>   
>>   	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
>>   	if (!osb->ocfs2_wq) {
>>   		status = -ENOMEM;
>>   		mlog_errno(status);
>> +		goto slot_info;
>>   	}
>>   
>> +	return status;
>> +
>> +slot_info:
>> +	ocfs2_free_slot_info(osb);
>> +system_inodes:
>> +	/* FIXME crash when no journal */
>> +	ocfs2_release_system_inodes(osb);
>> +dlm_out:
>> +	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
>> +uuid_str:
>> +	kfree(osb->uuid_str);
>> +orphan_wipes:
>> +	kfree(osb->osb_orphan_wipes);
>> +slot_recovery_gen:
>> +	kfree(osb->slot_recovery_generations);
>> +vol_label:
>> +	kfree(osb->vol_label);
>> +recovery_map:
>> +	kfree(osb->recovery_map);
>>   bail:
>> +	kfree(osb);
>>   	return status;
>>   }
> Could we split ocfs2_initialize_super() changes as a single patch?
> Also suggest we name the label as out_xxx.
> 

NO problem.

>>   
>> +static void ocfs2_uninitialize_super(struct ocfs2_super *osb)
>> +{
>> +	kfree(osb->recovery_map);
>> +	ocfs2_delete_osb(osb);
>> +	kfree(osb);
>> +}
> 
> Since ocfs2_initialize_super() does more than above, I don't think
> the name is quite suitable here.
> If we the above operations are enough, I suggest just open code in
> error handling.
> 

No problem, will change to directly call these three line codes.
I checked many times and thought they're enough.

Thank you for your kindly review. please wait for patch v1.

- Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
