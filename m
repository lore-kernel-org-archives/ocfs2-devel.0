Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0420AC00144
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JvNhDBsCgVkbf1RVEqarK7UAZyiEH1BOTvzotDDBUbQ=;
 b=agBmuKtzg3KxskwiBeI1taYkMHNZlY5yAZ7Pbjsh2zNX7el8q2usWwkfFDTM142DsGwuecnXzI+z
   0rItHJoDT9ruDkpvS9/YXMrhgJWxoo4QXVll3O0ICOMhZcmZu8Lgz6XiYput353EW0O0Qqag3lrW
   nKXul14FsI2aFccNVyqRjGv8YR9OTB4aB1Hd3qCWj1CfKAIvTmpFsxoxNJheSiL6+B1LtFPhxxII
   j6iepp6qmo19/0EXHYHvO8F9qDDnXDNqBuF7he+JPey1iJIiHS76xDrI+5Fk5oKbPRWZO8dwnNAH
   bystmgRRsHxt1InmQzv/Dcrpiw1Xv1eYoo+nxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JvNhDBsCgVkbf1RVEqarK7UAZyiEH1BOTvzotDDBUbQ=;
 b=PYi56nhehQNTBSyXgzhQ2kbECScj7RAMz24SzQZU9wfgiaHowaY3aIAW+YhhoKnL9vV8PCd4MhKK
   YNYEpqeZq60jl3wXEa08gvULuMrYqGYayaMOu6jxBPP8AX9000VhetYN9HTHNK00imin7BhHX4xz
   9AK4/ZgwPSb8km3pJ08QoOORG3xcGVExQtWMDy6R9t1YP/OsodjY+DTpgPZJCn5J58/k++Iar2oe
   OgKh4s13OxCttSXEtODYrjZUP7rew3VAYURu6a6/ckIGgfIuK/xTN6DifrkVXE8GNxGx0Mmxn1qv
   eIYfmXymznco1D406aPExCnom5DY5pGg7ly+GA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFT00C4V7GQIOE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 01:14:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUFedG9+XCT87XzP18Qi1t00r0pqHTNpsSibtEv5GJES84N35ZXXvcleZFLCYR4dlBl4LHqto7lHcix2JjHrMOplgsqjm1mprQaS2o/awWWEfr3C70Zwoug2QIouWDESZMml6uleX0+hZCtblwFhdb1PSYapgO0gooQZizHw8Ocw+zQi9GOi/sdVFq2M3vbhoD7gLq4ku0Cc6Su4mGCxzd2kUBDrfW4X0yWrqU+VoImp3/GoEqoQ6uv/z8bVto6tvSznjqj8EfTCbn9upKdpqQKU1RplYHLNujHBYJW/fljEolr1bVImUfuB/+5EM7WPoXC/GpVnkIrzAAq5ZKHTWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJsbPycb6tvl6B4nW9XE1iyADKnuQoOewzIG0jZ3KPI=;
 b=JQHtzijd+fk/OEz54YsXwtdSZihLfqToAUhdI7Xn4wOnE7AyVc4mvJKY6h85c0wPIxbL+NHWfevjgs9dJiUfcWdYSEJC37wLZTZtgQ7/6U46yWth5YJ09qNbOsiJWUa34v1wYDO7tRoggKweSVjWYKxH33WAQN/nJmH1xAG/Z8p5bcds5MFxR4YR23VEHiQug8lzuvpDSvXzCzzboaZa3mXxvHwTJF12VGcf7l/mcFhDHUDEVshcrfV5LQxOVCYViOcmGev9WNJssWJvboPI/b6Elb92ZVb+ZJKch5W8DDyt7BHtR4G1ZzxKi3Km6fnETER8ttyiBug2KA9gofwcMg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJsbPycb6tvl6B4nW9XE1iyADKnuQoOewzIG0jZ3KPI=;
 b=OXS4sjaOdDexM6+bRJ2ikH/1V/EY3kQaKH8srhAtFDSzkmr1FiE9+A7+OZNw6DHwpxPK5smqIFqKM8rZKFyzQIwZohgWtdRRgJ28kw20H263yKh1JKeVD8gLPatzzL2LPuOddO0fKcsgqFs5q7oUZmr81tsJZyEYoVE2BPE6+su2aRHS5EHZkK+ltL/MvffSA0G0O1rW3zE1XAVPHl2isN/eDHn5jhj7QkEvBHtt0mkVKsLc6DalaYTdfsWx5NgYnt2ZFK13UCactUQiSEJlQNJ2+HSqJCPbQQfi8womoNttHrlkY/H5RGEKaOTxNqk922KPLABamc4XJlAHZql6nA==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 30 Jul 2022 09:14:07 +0800
Message-id: <20220730011411.11214-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(41300700001)(966005)(5660300002)(8936002)(66946007)(478600001)(83380400001)(66556008)(8676002)(316002)(4326008)(66476007)(6486002)(2616005)(1076003)(186003)(6666004)(6506007)(26005)(6512007)(2906002)(44832011)(86362001)(36756003);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 01:14:30.2632 (UTC)
X-Source-IP: 40.107.1.73
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10423
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 clxscore=189 priorityscore=140 suspectscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300005
Subject: [Ocfs2-devel] [PATCH 0/4] re-enable non-clustered mount & add MMP
	support
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
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abf1174e-e4a4-4934-0648-08da71c8da8b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 +XRrgdS2CiV9+R86eP0WLR4B0BrqlAFaa9cD+mSJOQNT6COlBJrei0dEmBD16koaX9kbe3s9godlmoypXlfVoO0fwXLkFL6onJqneuzClfAJhEMzG+u7h4S81V/oXWKmkS4vzH6k9DjO2kEGN4id2Q1hnezWJWiyU0KFTHY14EnwPUjtzltGL8ketypf6IlhZfOs2MLorGPCEbc4YEuhcLYERULCVDBDe3xN4Z2La0AvV4DkpZCchyWOM3Hwnw4D+RGc4qbTnFswsI144TysNf1Q2GmHEqzCzZP+fivieopxfJ2llltXQyel/mp6FGNBbe/ZabsvR9+t+5tiOAwlIkSrqa3WRfkq9cNyjbYc/CQmGSEcO53cDsnJggpdBgOjVseLx5Ih/DIVDH/vHkWggQ3cm6jGsbYogQnOVFJoQ4yBVSI998W9Dy7vrNxFCzyQ1np5MSHuWoZcD2/vUP9QmcV3Onj1vszIeNZWqlXIdIX/7RkBTKHi7y2PRV3gANppflbfo6vbe9TelzMwTJmfpdsrguC3eoRYlrKqFn9S8hpe04DnIEC4bYH6Q1rKQfjYIOUA1QNZYWb+dHBfp1INVzuHGTqj6r/lAjpmspnzccVvD4hnaA1LFNITnC4zcmCqa96cy4LbFAgrVNSX+W/8OmnIKJdbwS9i4apnJzYqjS6cMy7RNSPwpyK5A0UYK+SqkCsXbpV5HUnWUoLmAL8EM6PqeGhsSCDP3UiDs3eemu42hXoKkhwHfUvHkHU26v3+XKFtdyUGJpXlNAC/ONJiKQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?+gYOuve6rk4KoXDc79/A54vIr5dbKWvUMgP8bJqNr2pisPdO94l3OsNExou1?=
 =?us-ascii?Q?ZbaDCc+1oANVjNfE+KSfEBFfju1IPSxTKNDGqr1y8EihEfLqYeyKbYMxuIwb?=
 =?us-ascii?Q?1A9switu2ChEb7eTguSwNrrJY/WxjoVsHJt2pO4fQZFNI6t3KYcXZK3OEzV4?=
 =?us-ascii?Q?nOCwBpq5SWsB/5ZvTsEAURe7oqVpWJg4D7Ojs8ix+Nc7RH582vPf6p/061SW?=
 =?us-ascii?Q?MatOHG9vJgbsXeZL2HAOTIpQXgqpLrbxcSyzmTDWvUQKlEjXDforxq7e+ZwX?=
 =?us-ascii?Q?TPSG7UOq/iXcUAVBhxbwuKS+9ZE/NmssDqVes4rtQUlvKX8Ori7zYUF73Z/w?=
 =?us-ascii?Q?tBLxr5IgU9Uv3j9jJSbxwuUmalYxQM7W1ygxUPpBTMwv4ymiYqhw3DQ9ZYYq?=
 =?us-ascii?Q?GAvgNJ0W59iWqy5fXpalnG6yK0oZA0bmoPSzArsUfNPZpcF8VW0shf4sACBj?=
 =?us-ascii?Q?aFBAQy0/YkhlA87IHwxU3vRhMnKsXfU3OJ5bOt0ctJiXCzUP6hEn4DVkkG1Q?=
 =?us-ascii?Q?SXzwZgcxhCKoYJpdm7fR6v4gDOHlFXPSyJPeaIC1Odc60F0Zwm3phmcmonVV?=
 =?us-ascii?Q?s27RQJ8IopBtZUIXl5O0VQ36bR3HWeUxc99MuovDpnZVRSKjoejeK9C4oSpy?=
 =?us-ascii?Q?QYe3Er8Zv4yVjKCWvmenmgYRFswknCuhfNSBNio/77puNSA0JRVCB2pXfvX5?=
 =?us-ascii?Q?0+tjisqbxalLfco2PFZsFeBo2qfQ/JKeFvxDFVgCR5fLB/b756yx7UA2zuSQ?=
 =?us-ascii?Q?JTPCcd6Po82lr1BrhVXh5elsNaEcK+eQKAVpaqn+P5CTvUdVheDvjFfyJ6xc?=
 =?us-ascii?Q?zfpLmOEp3sLb6RUYkMAzTmxHPgKLkPTrpTkHYSCvMnAWgst55+vhvyYiU05Q?=
 =?us-ascii?Q?TtZhngHU49Fu3kmk2CLgqqAG21H0VupsYqX3lx7LTINbMzVh4r4NFIVLOrOh?=
 =?us-ascii?Q?HL7M3tHL6BvkuAFORWy7e9YC5amI+cwz9GLY+v4RLBjsfq5nlXrzaATQgHiJ?=
 =?us-ascii?Q?Fm1ejnkle6tPZO32vkocLSuuf70+ZilZhTFZcJQaBgLCz9NicobtQV5eJiCg?=
 =?us-ascii?Q?8/7zkOCmwwO8iFzgHjD6FpFe+goEsfXl6XmG8cFqMAeATtPBgwr0m1DiqS8u?=
 =?us-ascii?Q?/vel/n+n0lzmrrzZ3av7XnRhRKlnasIXzMxg3lmvyzV/kfgjbYZf1WNvpicB?=
 =?us-ascii?Q?LF4I1EvvFiIUGVkyQ3IiUpKMBP/XdJLXnYdMNS9Rhmd8DmlIHCJ2RleXxe+O?=
 =?us-ascii?Q?KTs7ffXfEAW2VfbGDxAEhrLv6FQ/Tbz4OF89SA5e4sgCLsDAXZqRF9tp9zF+?=
 =?us-ascii?Q?cLsFtsqfT+yschpePcuJe8O2KFW61UvkCmxIZYnrulVX3YZWjtc+eKh2Nqma?=
 =?us-ascii?Q?ZypjGS/AMZ6FIg1Yg/F2jiB3dVuhw3bgf7bGBfDYcAlTMDtPWtKXXDN7dwkT?=
 =?us-ascii?Q?3sCZiKN18ImL0iWuB1zjXJnQcXigjkk09fCz2qKM0ZgSEDkHnbUnd78cBFO/?=
 =?us-ascii?Q?+TvzOKkrKCrwaREv3hKJO1fAUiqPuedwcNLycFyvrpw9EDZcvVQQJTu1EfIa?=
 =?us-ascii?Q?VZcJOXjsRurZu7HeKwt1+qpex0JCNkAyNzGWcC2X?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 abf1174e-e4a4-4934-0648-08da71c8da8b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Z9eOZ3wNW/3AcTRgwgr6wjA6+FTWjqajyt7jaAnAO/vfMZH3J3W9ztnBWNfh//BSiFEMS1L/iSAVKaHjFxF6Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
X-ServerName: mail-eopbgr10073.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: C1UJOL1iTGpBhld67MKjptrvDquz5gY5
X-Proofpoint-ORIG-GUID: C1UJOL1iTGpBhld67MKjptrvDquz5gY5
Reporting-Meta:
 AAG/6Z91NJ3MYVHFPjK/Hg3lyBzt20hmGpd8yUcYpZz6AMD7H9J9+zJ4ixzLLxnV
 NoocuCyIhE7ZPYpjqKRc5uOzZPIZYlywwICM9gAafDOrXCitMZMqKb1HcUr8WccB
 mQadhW4BOHOp5IcMrsP8EpGM6PUe9WShWe74odqovwoNjq2hBapcJkLe3RUsG/i2
 7NMIvfJtCGyg1AfDASeOgNs5apfFsxwMTQDUNKTEF4LXuWGGtcNF/ci+cs0AR40O
 YG4tbWmgmJOs/DeuigMWJPPMXTu/df+Lu2bNL6TzA6Q/MWJ4sbqwPRhXorLNKl+c
 3ClsTi2Qx/0oi1QZI3p8ablNbeGFHkRnQDgPcyywj7osurB7wImMgQ6YPHhXGRKE
 XKA+p60hcFPJ/G3KMm7e3GOVCVN+oV7l/AV1GAazbWjxTrR6hNmG5xx4nDu/yhKo
 bPE/ai7D2gnzSSRln8pU1QCZvVhGdUmjSAaLZAaiGAsHWiW4Z/HjFsN6EnppNEid
 sF4Zv6iHyng/4OqycpEUR3j/y17FdS2VdFunxpyNzatkuA==

This serial patches re-enable ocfs2 non-clustered mount feature.

the previous patch c80af0c250c8 (Revert "ocfs2: mount shared volume
without ha stack") revert Gang's non-clustered mount patch. This
serial patches re-enable ocfs2 non-clustered mount.

the key different between local mount and non-clustered mount: 
local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
convert job without ha stack. non-clustered mount feature can run
totally without ha stack.

For avoiding data corruption when non-clustered & clustered mount are
happening at same time, this serial patches also introduces MMP
feature. MMP (Multiple Mount Protection) idea got from ext4 MMP
(fs/ext4/mmp.c) which protects fs from being mounted more than once.
For ocfs2 is a clustered fs and also for compatible with existing
slotmap feature, I did some optimization and modification when
porting from ext4 MMP to ocfs2.

The related userspace code for supporting MMP had been sent to github
for reviewing:
- https://github.com/markfasheh/ocfs2-tools/pull/58

ocfs2-tools enable MMP and check status:

```
# enable MMP
tunefs.ocfs2 --fs-feature=mmp /dev/vdb

# check the command result
tunefs.ocfs2 -Q "%H\n" /dev/vdb | grep MMP

# active MMP on nocluster mount
mount -t ocfs2 -o nocluster /dev/vdb /mnt

# check slotmap info
# echo slotmap | PAGER=cat debugfs.ocfs2 /dev/vdb
```

=== below are test cases for patches ====

<1> non-clustered mount vs local mount

1.1 tunefs.ocfs2 can't convert local/nolocal mount without ha stack.

```
(on ha stack env)
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=local /dev/vdb  (<== success)
tunefs.ocfs2 --fs-features=nolocal /dev/vdb  (<== success)
(on another node without ha stack)
tunefs.ocfs2 --fs-features=local /dev/vdb  (<== failure)
```

1.2 non-cluster feature can run without ha stack.
```
(on ha stack env)
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
(on another node without ha stack)
mount -t ocfs2 -o nocluster /dev/vdb /mnt  (<== success)
```


<2> do clustered & non-clustered mount on same node

2.1  non-clustered mount => clustered mount

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 -o nocluster /dev/vdb /mnt
mount -t ocfs2 /dev/vdb /mnt               (<=== failure)
```

2.2 clustered mount => non-clustered mount

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 /dev/vdb /mnt
mount -t ocfs2 -o nocluster /dev/vdb /mnt  (<=== failure)
```

<3> one node does clustered mount, another does non-clustered mount

test rule: clustered mount and non-clustered mount can not exist at same
time.

3.1 clustered mount @node1 => [no]clustered mount @node2

```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 /dev/vdb /mnt

node2:
mount -t ocfs2 /dev/vdb /mnt              (<== success)
umount /mnt
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== failure)
```

3.2 enable mmp, repeate 3.1 case

```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=mmp /dev/vdb   (<== enable mmp)
mount -t ocfs2 /dev/vdb /mnt

node2:
mount -t ocfs2 /dev/vdb /mnt              (<== wait ~22s [*] for mmp,
then success)
umount /mnt
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== failure)
```

[*] 22s:
(OCFS2_MMP_MIN_CHECK_INTERVAL * 2 + 1) * 2 times (calling
schedule_timeout_interruptible)

3.3 noclustered mount @node1 => [no]clustered  mount @node2

```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 -o nocluster /dev/vdb /mnt

node2:
mount -t ocfs2 /dev/vdb /mnt              (<== failure)
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== success, without mmp
enable)
umount /mnt               (<== will ZERO out slotmap area while node1
still mounting)
```

3.4 enable mmp, repeate 3.3 case.

```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=mmp /dev/vdb   (<== enable mmp)
mount -t ocfs2 -o nocluster /dev/vdb /mnt

node2:
mount -t ocfs2 /dev/vdb /mnt              (<== failure)
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== failure, denied by mmp)
```

<4> simulate mounting after machine crash

info:
- below all steps do on one node
- address 287387648 is the '//slot_map' extent address.
- test the rule: If last mount didn't do unmount, (eg: crash), the next
  mount MUST be same mount type.

4.0 how to calculate '//slot_map' extent address

```
# PAGER=cat debugfs.ocfs2 -R "stats" /dev/vdb | grep "Block Size Bits"
        Block Size Bits: 12   Cluster Size Bits: 12

# PAGER=cat debugfs.ocfs2 -R "stat //slot_map" /dev/vdb | grep -A1
# "Block#"
        ## Offset        Clusters       Block#          Flags
        0  0             1              70163           0x0
```

70163 * (1<<12) = 70163 * 4096 = 287387648


4.1 clustered mount => crash => non-clustered mount fails => clean
slotmap => non-clustered mount succeeds

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 /dev/vdb /mnt
dd if=/dev/vdb bs=1 count=32 skip=287387648
of=/root/slotmap.cluster.mnted  (<== backup slot info)
umount /mnt
dd if=/root/slotmap.cluster.mnted of=/dev/vdb seek=287387648 bs=1
count=32 (<== overwrite)

mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== failure
mount -t ocfs2 /dev/vdb /mnt && umount /mnt <== clean slot 0
mount -t ocfs2 -o nocluster /dev/vdb /mnt   <== success
```

4.2  non-clustered mount => crash => clustered mount fails => clean
slotmap => clustered mount succeeds

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 -o nocluster /dev/vdb /mnt
dd if=/dev/vdb bs=1 count=32 skip=287387648
of=/root/slotmap.nocluster.mnted
umount /mnt
dd if=/root/slotmap.nocluster.mnted of=/dev/vdb seek=287387648 bs=1
count=32

mount -t ocfs2 /dev/vdb /mnt   <== failure
mount -t ocfs2 -o nocluster /dev/vdb /mnt && umount /mnt <== clean slot
0
mount -t ocfs2 /dev/vdb /mnt   <== success
```

<5> MMP test

5.1 node1 noclustered mount => node 2 noclustered mount

disable mmp
```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
mount -t ocfs2 -o nocluster /dev/vdb /mnt

node2:
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== success)
```

enable mmp
```
node1:
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=mmp /dev/vdb
mount -t ocfs2 -o nocluster /dev/vdb /mnt

node2:
mount -t ocfs2 -o nocluster /dev/vdb /mnt (<== wait ~12s[*], failure by
mmp)
```

[*] 12s:
sleep (OCFS2_MMP_MIN_CHECK_INTERVAL * 2 + 1) then detect mmp_seq was
changed, then failed.

5.2 node1 clustered mount => node 2 clustered mount

see case 3.2

5.3 node1 noclustered mount => node 2 noclustered mount

see case 3.4

5.4 remount test

5.4.1 non-clustered mount (run commands on same node)

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=mmp /dev/vdb

mount -t ocfs2 -o nocluster /dev/vdb /mnt
ps axj | grep kmmpd                            (<== will show kmmpd)
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_MMP_SEQ')

mount -o remount,ro,nocluster /dev/vdb /mnt    (<== kmmpd will stop)
ps axj | grep kmmpd  (<== won't show kmmpd)
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_MMP_SEQ_CLEAN')

mount -o remount,rw,nocluster /dev/vdb /mnt    (<== kmmpd will start)
ps axj | grep kmmpd  (<== will show kmmpd)
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_MMP_SEQ')
```

5.4.2 clustered mount

```
mkfs.ocfs2 --cluster-stack=pcmk --cluster-name=hacluster -N 4 /dev/vdb
tunefs.ocfs2 --fs-features=mmp /dev/vdb

mount -t ocfs2 /dev/vdb /mnt                   (<== clustered mount
won't create kmmpd)
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_VALID_CLUSTER')

mount -o remount,ro /dev/vdb /mnt
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_VALID_CLUSTER')

mount -o remount,rw /dev/vdb /mnt              (<== wait for ~22s by mmp
start)
PAGER=cat debugfs.ocfs2 -R "slotmap" /dev/vdb  (<== show
'OCFS2_VALID_CLUSTER')
```

Heming Zhao (4):
  ocfs2: Fix freeing uninitialized resource on ocfs2_dlm_shutdown
  ocfs2: add mlog ML_WARNING support
  re-enable "ocfs2: mount shared volume without ha stack"
  ocfs2: introduce ext4 MMP feature

 fs/ocfs2/cluster/masklog.c |   3 +
 fs/ocfs2/cluster/masklog.h |   9 +-
 fs/ocfs2/dlmglue.c         |   3 +
 fs/ocfs2/ocfs2.h           |   6 +-
 fs/ocfs2/ocfs2_fs.h        |  13 +-
 fs/ocfs2/slot_map.c        | 479 +++++++++++++++++++++++++++++++++++--
 fs/ocfs2/slot_map.h        |   3 +
 fs/ocfs2/super.c           |  42 +++-
 8 files changed, 527 insertions(+), 31 deletions(-)

-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
