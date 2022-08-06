Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59105C19F2D
	for <ocfs2-devel@archiver.kernel.org>; Sat,  6 Aug 2022 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0M8A1ux43exNRWPP1H+X4YhCdql9uws+xl1aW/5tKjI=;
 b=dnJn3DV4rRvcWJa7KGtUI76rv+sSIZfpGa6L7lHm0zHKTBfKtBiW7FMuaZLt2FCl2TQXQ5IsX5AQ
   +R2frnoVmilq3w0HM8tPAXTEH1ah8dkBd7ZHveIWqmjDvkFT0KhhXahP2BuPPXeC+W4qG5r4OwQq
   /9w7yoQ3aWbfiR1ROSitP0R2qQWRHB/7Xpeni9/zq/HgnEvLGCfN1ZHnfldiMaogPyXpe6MivtQD
   9WizV4nV6XH0a76DhdrPBZj+ozcGPV8ZhfcEC/qbf2DKKLJl0a6NvzCE3oI2ByRk9twhOR0Vh3CA
   ZUmuKxYed/vGsDBSdk8l3zhf6mH94dLmqTZr3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0M8A1ux43exNRWPP1H+X4YhCdql9uws+xl1aW/5tKjI=;
 b=n7IlyAs+W0BNjeEnpG6UA5mDVxS3xTExn2L4evBZka1HUD/4Pr4nRzvlwwCscC3oqpo0lPWBKc9j
   TWooJvZNZtLnGIeajYHJVzLy4GmWXwszLJfi4LpACH9DmeUgtkGSNYTTiu9eIH3VnJ1wrZipBa4r
   r6oG5JA7Ziw0/zqaLTjZ0XjZ6+8SuNkDLR9zeEvfbTNgF2lPLEF8xtv+pSiOig3yja/iSG/NrX64
   LX/gevdC1ZWKR+CotARUJMZXzNVytD7U30sGB2hI4lvtKjF7tx0SCNISSNXcDWyp1jOYnFxu3u3z
   Oq175wEnSMjs2i9wwE+wSGV7YoTN6OC2d2XR8Q==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220729 64bit (built Jul 29
 2022))
 with ESMTPS id <0RG700KI7AEXA320@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 06 Aug 2022 15:44:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I40zm3+4vAAQIgYtphSLkk0NQ5dhqYQngYnLsFGQjm4VOmrJOwq2UXumdREA3RAymyJDx5QvqPxm922WsS93p5HWTxpkGGaPE8QD7lDMvVSV2+6YYw/jjHQLv4JIwXUKA3zfmb7MQnOORb7GxCqFVRx4k0YtY6/20VVcw+KI0PQWi+NuZN0ngdo6oGH6pa6pe3tPUBBw29DHaMANEu85JlEx6QEqjfZOo4wQkcwhGej8hgG/+UwFbeg5XadlE2JDP3mVkfy6Rv6TqUg4gwSM+xDXr1T7JosvsQImXDvPe+N46xN+SOrTQ1imBAX3xowxxD30JuOxwW2fPyC72wlUzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5+udhp0c75ChEMaCWRShLQ7NT9d/iXiAtx+Smj29Rw=;
 b=RLA060IdfNCn0fUOltU9QTq+eOQ5GpnWd/ZdVjJVjy+Yq+qOb1ymDxdnMKLneQO3Oz8rm/b0IQ03zSTn9WiM8QTPzfCqrbOiLvxUI0jufZVRbCIhs50sFDQoBr0QhigdBNSEmowv8vFGhqnfUFJZlvm488NEOnVKfontYqG+ufSJ2kUD5a6Sq0NZcozqAEN0A9Crzr+oohS/EbLo9+IKlQRXYgur7lP/0fb68EwkBIwSvAYTenY4z1uJul/89hP9cr54DTxYIcfGx2WxXHdZCuxLmyrGNFRERGuZ66Zhht598e4kwO/MWhJrFWyINCCK7HSwk888gn+skY617P1Zmw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5+udhp0c75ChEMaCWRShLQ7NT9d/iXiAtx+Smj29Rw=;
 b=sKZfvr3IRvujpvHMJLvSvAO+P2oDNygvKbz1nRF1hxuFLvABay9QppYXuk9nicpoJKfUSS6+quuoVdalQ08HGr4w1p1HQeUQSmegu3CAQxI8ZzaR6bbKk9qBevA655I2GJsnBVWv69WOm8hucG1ifD061UImmn9XPq47hr6opUPQMSw4W2hRqkhV5KFKKnx8FjU0AvhoxXZmEsHVJ+7JxXEZRfLveoJidwvQoUc5l+flfjj8nOKp5v4aFlcPRhqCZUez7sxRJZ5LrLE3PacPXVTSSu8g/k+XQOjnaX48sf6TCc9fuExFC/tnKH9uZuecT7dq8+GmZx10eZnsXgawyQ==
Message-id: <214b55e7-3fe4-2f4e-f148-6b2a7a86f2e2@suse.com>
Date: Sat, 6 Aug 2022 23:44:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Mark Fasheh <mark@fasheh.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
 <20220730011411.11214-4-heming.zhao@suse.com>
 <CAGe7X7kLfsUfb1+yYgD4PffnJYvJVeqrLtub8qC=ujC2gxEzTA@mail.gmail.com>
 <0b33b0c2-71dc-3961-88ee-fb29dedcc7c1@suse.com>
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
In-reply-to:
 <CAGe7X7n7J52w3Jn5Sz5=f2AQohLMK5xK2Pjsd9oPAMSn52+SrQ@mail.gmail.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:VI1PR04MB4671.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(376002)(136003)(39860400002)(396003)(346002)(6666004)(41300700001)(2906002)(86362001)(36756003)(6916009)(31686004)(31696002)(186003)(38100700002)(316002)(6506007)(6486002)(8936002)(478600001)(53546011)(5660300002)(26005)(66476007)(83380400001)(66556008)(4326008)(8676002)(66946007)(6512007)(2616005)(45980500001)(43740500002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 15:44:41.2636 (UTC)
X-Source-IP: 40.107.20.51
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10431
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 clxscore=183 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 priorityscore=143 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208060084
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 3/4] re-enable
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
X-ClientProxiedBy: SG2PR01CA0131.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::35) To VI1PR04MB4671.eurprd04.prod.outlook.com
 (2603:10a6:803:71::11)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 021c4843-8696-4a40-28cf-08da77c29394
X-MS-TrafficTypeDiagnostic: AM6PR04MB5239:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 QSrg1/cYPiDlJU4nEAYsU6k6tB79NC04kcvOiKv00SYQDKWN7vGFHwLZtXsNNx5xuVbJZXip41zSWKJsdmoXtLZdTr9Kn1euzKDB6aHKccqOcl0Xo1IDGeHZUFloJrlU3Pkn/3bYL6pStfr7EUbiYBtfp9VDKagi3QXCf14qiYL909RE4b0auNFIlTmnNbvW1QnbJeYwdygVH9UCLzjekEFrOtojgnrto0CwQBWut1okEVkGh3NFZ/XzY1U1gG998BS/dluD6rMkRHsC033kvAx/LEYlOjXF8On8TXeK1KhigOCQnPKss0bQM2j+WimpJIqsCxD6Evvq6vHwQSZuZyuAYhFdbUWSRiJ4Rezd2zx8I0qO9dMY8uVnScQyLtvUCVLfUleG02nTTwkqA7uRnb1vFh9uSUz67eH8Bg+DAPMcpXsNbw4ix2SqRycWs//66eDY9RxNofLqvTrugo+eQjVqD7bWUkFJ2HTK4QSaqfS+EVbNJ/lVgqpOVZPKG/7JgtC5eoSu1HPHm2rvVci9A4Ddezu/1TrDLHpwtVpUXMeTDPBFDHB+lorjnQQRLv7BOZ1TG7Kz+zsp2H7uagiEjrElERKF6qVpQF41/VQcCpzRfURIiHa95aeYgjfmAJJkRRRf5L2MP7uM/Rt7lov/H/YTrcGfNZm5C8wkfvCScgQE45FCyKCa3G8dJ6e1OcTPewvJGFG97nLpG42oxl4QE5U/UIKVp6Sz3eJITbGId7vHc4RG8FXo9+3D8I6rINeczaQGEtXr5kAllj/Z44ZsmqeOCHuzrJ2E5XhUZYYbivbJBIQ16OgPHXOJSikcn4Sk9lU6/VvGk5xiFx4vdR0bWw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?RVlxelQzVWN6T0E0dHpzU2RZVitsNmU3bGkySUgxSk8zTmlQeURRQ095Z05G?=
 =?utf-8?B?UVh3bXZkZHUwdG9lMWt2bkg2RkVFSnRyV201a2xsV3NhclpKeDgyczFPRHFL?=
 =?utf-8?B?UEVlZTF2Zi9tVlppMVNTRVpKMlo3Y29rblI2NjRGVDU3K3dmVm54NmlhWHFZ?=
 =?utf-8?B?QVJUT2JtVzJ0enFoNXZNdmtJb1NhTktSeHQ5Y0FOaTFzYUk5dmJGSDBmQkFl?=
 =?utf-8?B?aFFIWEZmSXdKdjZzdXhkN2tkc2FlTDQ2RGtWZ29RUWI2YXdRT3JVYzQ3RUZI?=
 =?utf-8?B?dCs2SmNPSDcvNDNJQkhLZWd3WXlpdzBzampLN1hUNWJSMTUyRVBNd1FsMm1s?=
 =?utf-8?B?a3dFTU9sbDBWbUlQZFVXVk5pSVFGUE8zSENoa2NVQStUYUJ5TElFbnVRQkF4?=
 =?utf-8?B?Smt1UGxkZjlVaWIwOW96NFFCT3p1L3BmNVJLaU9SN0FDTlFmaGc0SEFIVWNO?=
 =?utf-8?B?OVpEMGJGNy9sVkY4K2pnc1FqdGdLR1F2RHI5MlBiTGJuMjVETnFnUnRtRGcz?=
 =?utf-8?B?NCs1Q3FCY0VlUnJRVm8rZlBYa3RyTE9UNktLc0ZscWxCeDVUVm5yMk1QSzN1?=
 =?utf-8?B?T1QyaEFVc1dOQVFwYnNhb1MvdzZGR1dWcDFmdEhnUDlFcE4vUFNlVmdJVHNU?=
 =?utf-8?B?U0Frc1hUTG5vL3hicGlaVEp5MjFheUhyNytabERHOXlhN1pWL2lRVStIeHNu?=
 =?utf-8?B?WVN5NkFOZG1iSGo2SGNiUldVLzM0WlU5VHNZdW5BbFhSV3ZKdlpRL29Bcktk?=
 =?utf-8?B?M2J1VmtyVVhyZW5Yd3FmTUVYS3VlWGpjVi95S3ZHZGlrRVhoUmkzbjJWK1Y3?=
 =?utf-8?B?dEpqRGw2TjJuU0ZiMGJKN0p2V2xDTjl4ZHBKTkN2QWxQQWJESlN5dWpLNkhE?=
 =?utf-8?B?QXVVajFJRm54aGlFL3VRSnJ2TFFCUmRsU0lienNlcmhMV0NLbGoxOHZtQ1By?=
 =?utf-8?B?M2JDZ1c5MWVTMG8vSVJLZzRzNnZwbldVdnFaV3c1YkpXYTBMYVlsZlFxWkdF?=
 =?utf-8?B?MmU1WkM2dGpPa2paeGZ2RmZ6Zzg1Rm1Md3gyaHRCZVlZdWQrK1ZGekNOWTlN?=
 =?utf-8?B?cURHbzBCVjZlVm02bVFZRmFWUDVHNDdDVDA4N0Y3ajU3NTNkTVBGRW13dVB2?=
 =?utf-8?B?YXZlT2NXcnRjVW53aEV4cmpsVUNEWkdpV0lucDZ2YWdyU2IyMjdNUW83WE5W?=
 =?utf-8?B?MWU4NGJtYWtwRFZNbVBXNzBOaHZRdXZGKzFxM3BIRGtpUURsanVSbWZOK2xF?=
 =?utf-8?B?RVpqZTZ6N1RWQnJKY2ZkcytCQTg3b0VYVXFYMWYvY0wwQ3VQWlRhbkEzWHpE?=
 =?utf-8?B?MEVML2t2cEp2Nkp2ZDBEcWFONVZxcVI2N1kyYmYxQXJJbEZHVHJWWk9GdVFD?=
 =?utf-8?B?SVdpWW5pZEkzMnlOTVBZakZvNnVZZFJYVkp4dXdtU0FYNWtEK2xxMkxibWph?=
 =?utf-8?B?N1Q1czd4RVBKRHJBRm5BUTJmdzJNVWlWcW1TbW53S1lRVGlNSElFV25sY0x4?=
 =?utf-8?B?dEdGSVFmRm1HeXBuUEdmQVYxVnNFV1h2Q0JhMkJVM3plQlV3eEpHV00vU0V4?=
 =?utf-8?B?TlJTY3J0RUZpL1R0Um5lWElXaGVMeVZKUGdOV1NXSkErbmVZeTRlcG81VnZn?=
 =?utf-8?B?b0FKZnl4djVmdDJHQk1CY2w4ZW5UMjF1RUZ5MnZkRUFOYzgrSU1ZbzhwcFhK?=
 =?utf-8?B?WDRtcmthNTdGN2NGN1hVMy9rWXdWR0VoODA0OUhReWsveVlpb05OVitCbGUy?=
 =?utf-8?B?NGEvZEN4UXVnTVptank0SUdnc2w1cVZkQ3FjcjZXdXRWUWs4enRsbGs0QkVW?=
 =?utf-8?B?UExtalRic085SHFHcGg2Ujdib1N4MjdLc3dDeGxXWTVBVmNrMUtGYUQxaHU2?=
 =?utf-8?B?THM4R1pmR2htT0V3bDcrUy9IL1FIdVUvaERQRW5NdTd3eVFDMGZRQ2wzRjJi?=
 =?utf-8?B?Sy8yd2I0R1U0dStOSDJ0K0hHVG1TTDV0aW1ERlBWSzRkREp3MUlXRExSWXpV?=
 =?utf-8?B?dEtWV3NQd2tYVDZ3eWh5aDJibi80azJjdVBzWnh0TXh1VEh6RGNhUEhTUFpQ?=
 =?utf-8?B?alBYc3BSV0N4ek0zZDIyOGZjbzUrVDdKSkZhcHN6cHUyNS9zRGNQbktUd3BN?=
 =?utf-8?Q?NafpEGF86h3OH5wM6Z5WG5Vy4?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 021c4843-8696-4a40-28cf-08da77c29394
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 /vRELq/1AB4Qdh1jfzGXp/JLm1MP1RQpApSGoEzqnhO/JmXTKVNITLZQkqcTl8qCQs4KCp30IQQscOGniq/A8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5239
X-ServerName: mail-db8eur05on2051.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Nmb0ZQyl7XnqGFgSNDxtwVRO941wx9D9
X-Proofpoint-GUID: Nmb0ZQyl7XnqGFgSNDxtwVRO941wx9D9
Reporting-Meta:
 AAGiziLS+8BRB7+geQJifg/ggpXqm2Wp0TReqGOjScrpdL3v1BP0eK78uUgAHoNy
 SzOJ87VRmGKAaTKrDvg4l6Qw+TTSX7T6GN9GGuKswnHynkFl+9ZYzI4g6SY9E240
 7WCZnRuUcHpuiinfmq/VHJ4sknmJPl+356TjphB6sJDK9XEeJ64ZiDPVrH9uvna9
 gN0vKuWmgj1SqduirpZjiywMYteB1BussfTZvAEDZiia3iofjPJ9M2WGU3rtQfw0
 6tzs653xM2CWD4kBgYUqeig/aEG+moCXzbFDop2RcwToBr61n3eSseKWGa+TMSGE
 Y34eJxcMUnz2KDNOHrFh0CI+ENgRZXm70n6KBNA7y5+QxAXNEXbqy49GhvnKPvJD
 +i4zKRKNL86KpEIlIfpzsZSzAbb/8fTPufPj0A1ILKZzNdWivlQN4040tw3DVFj8
 qM/bQbXw4xrcofuZmnc88EOgX8QRyyNOhSCd92KettohDKBpug7sGygPSAILsFoP
 Nbi7zugqE7RhZoyFL7Ax1Csvd70St4+cL9T9se3KWVypUA==

Hi Mark,

On 8/5/22 07:53, Mark Fasheh wrote:
> Hi Heming,
> 
> On Sun, Jul 31, 2022 at 6:02 PM heming.zhao@suse.com
> <heming.zhao@suse.com> wrote:
>>
>> Hello Mark,
>>
>> On 8/1/22 01:42, Mark Fasheh wrote:
>>> Hi Heming,
>>>
>>> On Fri, Jul 29, 2022 at 6:15 PM Heming Zhao via Ocfs2-devel
>>> <ocfs2-devel@oss.oracle.com> wrote:
>>>>
>>>> the key different between local mount and non-clustered mount:
>>>> local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
>>>> convert job without ha stack. non-clustered mount feature can run
>>>> totally without ha stack.
>>>
>>> Can you please elaborate on this? Local mounts can run without a
>>> cluster stack so I don't see the difference there. We have
>>
>> I am using pacemaker cluster stack. In my env, the trouble of the converting between
>> local and clustered mounts are only happening on cluster stack.
>>
>> the non-clustered mount feature (Gang He commit: 912f655d78c5) gave ocfs2 the ability
>> to mount volume at any env (with/without cluster stack).
>> The 912f655d78c5 derived from SUSE customer complain: User wanted to fsck the backup
>> ocfs2 volume in non-clustered env. They wanted to access the volume quickly and didn't
>> want to take time/resource to set up HA stack. (by the way, pcmk stack at least needs
>> two nodes to set up a cluster.)
> 
> Ok. I had some time to look over the ext4 mmp patches. I feel like
> there are two questions here:
> 
> 1) Is MMP a useful feature for Ocfs2
> 
> My answer is yes absolutely, the user should have the option to enable
> this on local mounts.
> 

me too.
> 
> 2) Should we allow the user to bypass our cluster checks?
> 
> On this question I'm still a 'no'. I simply haven't seen enough
> evidence to warrant such a drastic change in policy. Allowing it via
> mount option too just feels extremely error-prone. I think we need to
> explore alternative avenues to help
> ing the user out here. As you noted in your followup, a single node
> config is entirely possible in pacemaker (I've run that config
> myself). Why not provide an easy way for the user to drop down to that
> sort of a config? I know that's kind
> of pushing responsibility for this to the cluster stack, but that's
> where it belongs in the first place.
> 

the reason for creating commit 912f655d78c5d4a is user didn't want to do any

set up job for cluster stack. So any HA solution (eg: automatically config

single node, auto install required software, create VM with already set up HA

stack, etc) is not remove the pain point. Base on bypass cluster setup, there only

left non-clustered mount. And in end user viewpoint, non-clustered mount is

also the most easy way to mount ocfs2 volume.

> Another option might be an 'observer mode' mount, where the node
> participates in the cluster (and the file system locking) but purely
> in a read-only fashion.
> 

In my feeling, the 'observer mode' is just read-only mount, we don't need to
create it.
For 912f655d78c5d4a, user take a snapshot for ocfs2 volume, and do health-check

on a different env (not production env). there may belong to two different network.

> 
>>> tunefs.ocfs2 look for and join the cluster so as to avoid corrupting
>>> users data - that's a feature, not a bug. So what I'm seeing here is
>>> just opening us to potential corruptions. Is there a specific use case
>>> here that you're trying to account for? Are you fixing a particular
>>> bug?
>>>
>>
>> Tunefs.ocfs2 still needs HA/dlm stack to protect joining action. commit 912f655d78c5
>> works on non-clustered env, which needs other tech (eg. MMP) to protect corrupting.
> 
> FWIW, I'm glad that we pulled commit 912f655d78c5 and I do not think
> we should go back to that paradigm.
> 

If you or other maintainers prefer to pull out non-clustered mount, I respect

the decision.

> 
>>   From my viewpoint, the non-clustered mount code is based on local mount code,
>> which gives more flexible than local mount. non-clustered mount uses unify mount
>> style align with clustered mount. I think users will like more to use non-clustered
>> mount than using tunefs.ocfs2 to change mount type.
> 
> Can we get rid of the mount option, and make mmp something that users
> can turn on for Ocfs2 local mounts? I don't recall if we make a slot
> map for local mounts or not but it wouldn't be difficult to add that.
> 

 From tech side, it's possible to enable mmp in local mount.

Without 912f655d78c5d4a, local-mount uses slot 0 (the first available slot).

> Btw, thank you very much for all of these patches, and also thank you
> for the very detailed test cases in your initial email. I'll try to
> give the actual code a review as well.
> 
> Thanks,
>    --Mark

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
