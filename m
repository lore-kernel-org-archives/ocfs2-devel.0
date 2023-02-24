Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C980AC61DA4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 24 Feb 2023 00:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/F1GNV9HjowQukbsPyMD/7wLXirHzXZcRULPo8BwUks=;
 b=Xu1miKoCogohu48nUof+TnnKvbBVh1qigEuAdawDkptvsbRqWxh120b6BY4mZprBAPaUc8wpAVnB
   bJ3jRlcrGMfo5FbfusdE4idDQE6IRN9Y85u5Brad8wTxreLMGRzI3h7NXj+hxuT90QqnXEhdwnix
   5lBzwUn6VhtJ6jbhuFuWedLf8wm2pA6r/AkHKXiKuP0nSJcsymy46RuKSmneeRfNlPLyzdzyI9XN
   QBZWdG0+ot5lrA9TX67e1fzFNh1dakyRvw1hthaEijqixzscF/mCGoOxmtXUV2LMNGXWOsO1Iq4h
   X07RNq0U9TpGymTaizA2Z6y0GXlI3MLLJ1Iofw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/F1GNV9HjowQukbsPyMD/7wLXirHzXZcRULPo8BwUks=;
 b=Mnb6A3+9gIDgr+S7JPWStzFE4uUUSUDOGWB/DPvbR5XCVBBZf1Y3rIavqcLj/nejCeifo7sgOLHE
   m2mnMvzSP1NfudNbCF+EvNDuBu85pulIAe2hjGc8v3RPk1I8OnekhvbpaaW9+pYtUPVDqtPRR/OJ
   e1IwK9AkwBkbTTSP0Vu/HmuRGFqXP7OTlzTVjER2bpHDpPG15F8evqES3WdOVyieJafAS6bsPe8N
   yoUL7p/tAWi01w5+pJX0KFDe8C1RYtJr52HTtekBsRittf8zWBF6A4FRZbyRNt4rj0s6rD9wPkVu
   6GtesbBOGeuELawTk0uhGhisx05WXy6kgVZTRQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQK0043G6VTQE40@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 24 Feb 2023 00:33:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgBUlgk3vWvkaRclxtu7PWblH8wTsupRdhSFy2YWCc3dRnA2GBXiK+yPEWdF9EUojUmmqf/F3m0wSfiJaUUGo501zYledohI5THAc8fHVNzRuAKTuupCQwrcfU0wYxy1IEJVcqeATZkN4e+vDn6VHXkGNFh6uCo5NR3oD5gfN5GNfAsa3vy2/DgqmSaBdyeMFhVHkAC23kw2sP+k+zjQYXbhm6HoTbpFCH9ueyUhjTgpOO+0g7JmYMIi2IykwlW8SJHeamAQmdkCjahtOqjLZlZuSkhcqSJr3ToOZw12N4ReHB4sJWJk+DfxidW97KphzTcf1TkMfSPP+BTna2M2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gj4mYUa4s4+G2gps+PQMRCXkCt+iCFCzOzm0z0mBpDg=;
 b=BMutQk0ojKvhtxcLA8MnGArHSqb/ZlmpR7DrpBE1ue/1kATEC/k0bJEo5Vg3+iYI98IYxwFyAUpvjQhxg2K0YawHg2oBtADq9k+yULnqrKJqQ8x/WxjXZtzaTJJ9PrOeMBwvPKQvkm+0zN7PEQ/1GaEFXaPdXay0xtZFpWyvGmwDdpYzupde5yZrWLqGJbVemptEkJiiaDkNRnsZNuJRhGfXvKi7uWE36y19WHhoHToa7Z9PSM2MR27zGG6+Lr/28cAJD3fl7Zm0HZPQnbuSz9bTMXfQ/1+2NVprlfPxcc9ZSMiBfrgrxmIaGIU1arsYQpw+gkmjipA+ZxlGI8koOQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj4mYUa4s4+G2gps+PQMRCXkCt+iCFCzOzm0z0mBpDg=;
 b=X+x75lHG70AT0wpFx0TGQhxq0vSOTr1cccHyJ1o/eByY6zoFSaFlfZ3b/hfM2g890f67a9ntrrxnJ6SZnTYP22gOy9wOMSNAHx6AKrKVYmTYEfSisYRnEn9yFp7DjsTe6o2VoktxhClCHvsAWYJ1OukoJebIfZniuiu6gy36lJLLmmpgKWUXpWF8DIq/d5k22erNnv3jzK70lmu5p/zull0VO9Y5o7npDPeK8nzS4bA2NvXLV1+RclIlbRTLqJJjAzxAMCbpYKFB96JdKvuWLiKtfGwD24VbRJLpXfJw2SNST6Zts2rQghUeWonmtdMibLVivYgOv3WzhJjJUTo2Ig==
Date: Fri, 24 Feb 2023 08:32:51 +0800
To: joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com
Message-id: <20230224003251.otqzmap2f64o3fpf@c73>
Content-disposition: inline
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(7916004)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(26005)(9686003)(6486002)(186003)(66946007)(8676002)(66556008)(66476007)(8936002)(83380400001)(5660300002)(6506007)(6512007)(1076003)(6666004)(316002)(478600001)(4744005)(41300700001)(38100700002)(86362001)(44832011)(2906002)(33716001); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 00:33:02.4228 (UTC)
X-Source-IP: 40.107.6.66
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10630
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 phishscore=0 mlxlogscore=606 clxscore=182 suspectscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 priorityscore=207 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240002
Subject: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: TYAPR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::36) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PA4PR04MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8457c8-8df0-4de2-24e8-08db15feb013
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 /OEMs6rNTfktvMwn0NkvYMlo3SMm4Itl7EMzG7aQB1n8nBltjfEwOnZWCNS+4ILUoRFeC9aBT6rjrPkIcHukpL426rEmbsaJLDVAg02pIKi1J+QDY5iSCvVzRbJ0NoXxBhgmeic4q1IzJcmUbHw5bx2iu7lpvNE1JrGkVvgW0dzoSYpGwzYvZvizCMNTBjS0nBsKHKx+a9Q1Ym1Pyft1C4paYb5nGgmMuTCeAX5meHp2OT4ZfQcBAcy5Fk8WAh3wzTrRC88y4AEP5zV4NZmQ5bJgAulTQEM6DLpZnt1Ey9lYlotKluwFSY1s+ha0DrBSSTC+23RK81W4R4L50nOv6nmAaPU9i0bPSXd8scJH5n/WDcZ8CTjk0azL7PFeSxq0zDqj5xjMrAeBNE9/V+mZnWWI4EjlPlv0Szt435X34rwxyshlG91vAfFOLbX3rGh+aPImQ7MkPDSlYdV+SpOxNuCCh1xyexvtwBO+rJDjdNcAPTj+CZMZMtN9FFzSr1hVRrfSuYNIR/WrOtDQ0xISYNTlpixS95x2XZde82aCzXBH/RjEZA5PZF+VNJWODsQFvz6JT7Eq6wBPiVE/3OTi8UCYc23r24xwyvdqGzylEB7+W2u9LhLL090Q/UsrEixo/TFdOaSQB20qtGwHMzZKIw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?58HyYEvq3+01NF8/05DTslmdqvZ2MOrlPd0w5G986ih5vl5gO1tU/sbQJUb8?=
 =?us-ascii?Q?ih1HlI95BVTAeX6stox77w03dubsyC7/UBWcrbzU5ZEUj/Y2IVGsYDcPYy61?=
 =?us-ascii?Q?sT219YXSbKmwgQ/L4Ng6nidGauG9+xwxZGpGEvVrYo5KApiFiKFu1NGtdXUN?=
 =?us-ascii?Q?5QjI3EKUQwBK8zYIFUZaYIieyy4V1clq7aXFFob4VVaHeOqefqKdtHCUu+ul?=
 =?us-ascii?Q?5jiCLf+ASh9ssytnvRE8r39Gy1k3gqzwkhiVe2pP572QDZhX2WExN1dyHMrb?=
 =?us-ascii?Q?jcv9oMHfOrzBAgOtUc/nTlh5NIeFNEp/7xOuBA79Vt3VnPwb3mcVYEq64Wi6?=
 =?us-ascii?Q?UXfs5vMi85/+VruEN0kskSeqqY7pKMpWm3Ftj9ZmWMpedsQn/VgpksNqvOTh?=
 =?us-ascii?Q?ytDy8kRVgeTmXiM1ucy6jtvnGQI3uH1qE79W8OCtZ0JJS3sM0qV/bUkS7BX5?=
 =?us-ascii?Q?0LHXrwFh1nsKCp8Z2F/XL9m7euCN6fgQv1nbACKxbEbiokgOC0FFr+EqQKz3?=
 =?us-ascii?Q?g4mb3jx23O9+nNMUk0Tc78bg78ypMrwfpLc6ZaJMYAy9kj19zUDQQOn10Dv1?=
 =?us-ascii?Q?6tkvpqvjCG48+3CB9g5wwcR1xygbs1w7kuMlcMPEpPAUlLWydeOQGKv8XSO0?=
 =?us-ascii?Q?vfCe/Te0x8bv5jiZ+uP2J/HyvvczFwp0MYEgnUYFLxHMU8psc2Xdp4WBCmPv?=
 =?us-ascii?Q?u2f68/Hyk8KdstPt3oH+QMFYPMF68DiJFCb9mqgCWiosN1UP6iuwvQAkN/vE?=
 =?us-ascii?Q?YUvJvM7C9QBUxzldJ2n4675Pm5WDjWHrpKqyUuyZ5XGW18CHArz9z6dKTi3X?=
 =?us-ascii?Q?iCDCVouVYYkFMk3skr3NfN6ZGc0GyBctHXKqTraU113qXrpxOYdRvSTNVOUI?=
 =?us-ascii?Q?6BuXQdo68ke+LwJekFI8JLgMU63gOQp6HajHZslU2wODNqArJ+jjGMnVafoA?=
 =?us-ascii?Q?rJeMoBqemkbLqpFanPNdTBmVAN1nLRSuhWmi5E4rSnsptqCbLzNe7tLic/pa?=
 =?us-ascii?Q?Q7l4PR2xY5SZeaD+Yr28JVUc8xVD8DPcKKqPBzYjhoBFC9Z3heQJ/YKi3ys6?=
 =?us-ascii?Q?D0h9f+/GVfHWtsP5IcZmUTCO1EUTSjogQoHFpBWswgTdR2b/c8UbAHE+4wcL?=
 =?us-ascii?Q?YheSBG39ZkMWhtdPTeNkDJId1ciyrNI3/ZnhqsH6v78z8Oy6UGUsVKtiF5+b?=
 =?us-ascii?Q?fBY1yZq80xXKPOBeoB6oHh3P3sVfHiQpaavj1mpLrZ6kYUxrGWqzrFk9LQZL?=
 =?us-ascii?Q?klZqaUcNkzdvLXZ3LJ0jRStGxveSDNyUSl+lLjHLcrkra0uNhHoKqk9APOBU?=
 =?us-ascii?Q?/XdtunKY45FTo++ccRBxIE8x8VzssZznCKYXJQttEWeB48eEQVKOClhx5YUS?=
 =?us-ascii?Q?2AbGtutaqkjC+BTp9/+Qb4gTu+QbTO35SAp++adL1qdjAUZbiXwgroOb+ZQh?=
 =?us-ascii?Q?+UP9Q35pVC/uHSMr87mpulxXOur9GnxHQNDdwSC3yJLj15ZrGFHjlODkTaE1?=
 =?us-ascii?Q?AFKEkic+svwna6d8PyjCLWTnc+2gDzmQrHZ16YXagq/cPXIUmTFM3JmhCxHA?=
 =?us-ascii?Q?G56veuC3fFTk40RqM5opNboRWW94QtKgwk4dS0UX?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 7b8457c8-8df0-4de2-24e8-08db15feb013
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 dLfa6ZUb4G+y73OsIGnxruN9iW1RDk8BSPcTcq4a2foWTb/b8+pjvLKQoSAPNycVuyGobJJfYyMuIOHSXUJQag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7982
X-ServerName: mail-db3eur04on2066.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: wj27o3r5uyeHXSY7Rh0UNW6I_36lkal_
X-Proofpoint-ORIG-GUID: wj27o3r5uyeHXSY7Rh0UNW6I_36lkal_
Reporting-Meta:
 AAHyQbcmPKAnXQJ1ytxVEGokIoDH3mB+9XP7Y8WygO2p/FM5jTv+H/KtoFIFa9qS
 kEv4ydqs7n2/oEIDtFuwH5IN+W+wMTcN+Q5U9llVN8HT9lwfuGpkNIBKQH9Rhdlo
 +fhw4ryfmKqc4CrcD08mWSJNazR9T3dKaQLHtYmRivzfdxplAZrhmgmizekRFStw
 rUfzLN5ikap5AoV3fHmA4zAYP3z6ArkQ35knd5Z0OHUqhwmibUR6U9WqWyUICgXG
 zqmqnQGyD+oe6oA3ZZgL2OshBziZ4a9+VTmAaCMH4BQo1tEsxy8V6L+thOKNPBUF
 dge395f0GGovJX5fkhIEthVQHlzmYXdqYk//RcPoS8vgPGUDrdVVTAs63xamNYDF
 ph96F7q3oO/jnngkY6TFZGX9oCsTy0j8Qi2LAOPxKGAWf0MG4YgDTrK5rLTxoPlR
 K5X06bhLZQBsoSM/LsPivNEgnHmnh/NV2nieQ4AOuoxRCy12jvR8BPx4zyQs6ROP
 TuZMoy0Qt7YJjEK7LmA2C3WroFSk652SQaNE0uh99bQJmg==

Hello List,

I found a weird bug on ocfs2. I am busying with other jobs, if anyone have time
he/she could fix it. This bug is blocking fstest generic/013 test case, and also
blocking fstest to do later test cases.

How to trigger:
```
git clone git://git.kernel.dk/liburing.git
cd liburing
make
cd examples
mount -t ocfs2 /dev/sda /mnt
cp /etc/hosts /mnt/a
./link-cp /mnt/a /mnt/b
umount /mnt
```

umount trigger error message:
```
# umount /mnt 
umount: /mnt: target is busy.
```

The umount error can only be triggered by liburing write operation.

Thanks,
Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
