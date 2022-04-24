Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E0E4C433F5
	for <ocfs2-devel@archiver.kernel.org>; Sun, 24 Apr 2022 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CFelwqFjKdVhM1btKtHS/pr634zB3M9VZu/KdRe3H8Q=;
 b=ThIiwIQfyGH2vjCUAK5cwMw9YCTlM6FCokbtCF4VyUbwXBrdOydwQ+LeeSNA+/xJP+YEjcSindUT
   r2iEoVeXTNaYa+7oSj6KXS2QwygcLjAeOOmYTK7Ck0Dld+FtzrxN63HjrGREBr+vOtVZKcwROmdi
   N6Gu5PKGCyDcN8MMfNmVd0YvJ/LnzYFw1tHpbK5S9fNa+oBHdooF3Og0xe/O6L9pUtWCYmAM/em/
   Br0VARCT2TFF3j/XxgEGpUCWw4uE1gmDyAYYXDn2ybxpPBCyzI2LeJCnNQceS47KAxEyMbSKzIEg
   NmAkx0qX2R4ZmZWI+TZqY2fxR4w8CaWlGwvwVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CFelwqFjKdVhM1btKtHS/pr634zB3M9VZu/KdRe3H8Q=;
 b=U50cy6qsOATv+Bz5cUgRYJKtMAye/3rmf72SeG11AwGSSyTEdc0xK+1WomuzjAk7ET0hxKmCMbVn
   XwKKxJMHpSulASgfwDvyiNk2J4axu5xlJdUg2XgAkg/DtLr4E5N8Iv+Dc5kDW86oIAwXR1gWvKs8
   X2OhbgIsWV1Zi0vfQE1xsJVe0ZnoHIHwqCUiGwXwIbkdF8YU2zFkhIiz/DZvqNOQd/VcuqkQ9vvi
   yJc20Q43jf2eNOzfKroVPNwxi721IuK96gkrcqrRak8ovvrI5mM6oK7pEmwglAoBDLKep1BbJJbO
   Cu3DjzGQ7fONMwLtdgueDaQHr1NECsm21lC08w==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAU00J8GHZPKL30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 24 Apr 2022 13:11:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1650805897;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=Irv5yDwHp4yhTrs//+A5rD5YddJk72UPMkxs3FSj37E=;
 b=Y7BZsmV600NNQQa8nxQC6kH7rlFbYtFLXFZSS5d8/alvGHCaVyswR0v5d6GgcayT4H3pLQ
 giMwLtxskytVfGyZfNfAHraLbeDl+LF8z4C882CRIl65UszCS15o0EqgGz+GYp0U+2hevK
 DCBvMPlS1fg8cT/ovbNiWxPhf5H93Og=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwEg2Vg4/xVTg2e6OED35mAp9qmJx+DBz/vg4DwWkZD+G2m6Tr+gs3m0nEfNP/XnlOxg4160Lw9QfclZLqsXmnBsyNxH9lA5sSONusYUUcWeTFXsecVDKPeCsQ8OzYzBHLN7akGMUlBKm4OioY5CTHFb1MTQf8I7Gy9Xiipz81Xp1ue43d0fIVThdxfbsPg7Asx9hKBDq/IjFv6XiCdYjBhMQRjSN6TKaKDzxeXqlJlD1nrtX6wH3zVBLtwKdg1BbKO0Wcu7v9VocdmYTz38h8RvIVfOSDPaO2sSmUhhjXuctN2sLU1F5c3ESvIJKg7ytUaxFTQr/+wq6QDRGjVJeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tZZpEUUqVmeblacdyDUZ+7G9+hSX0m8L7/FYiYgzRc=;
 b=cnA8dUMxW4uL42bLrgoNexbpBghYhExUH4m7peBOYi1ns77FAgXKOboiTTIKGujAxEfPojv4Gi3nFs+8bKVkBYfOT8YHsjQr3ne67fF48TF62o4Hezm8Ki26Kx/dmCfxtL9iWrhd7q2AgsS42YH50w4QPvkUj5qTkNZFXdgicuBbOacq7nkps+1a5y9Y+1TNZ9NrlgatbMYq2jlvzyYIgFHN2nYLmIuD+N5nP+jRDluIwFIjyxhyYIfaIuBvRGPJc+5xAV/J4p2UPb09AbITzQub79g+Sf/lY/hFtjWDX4go6goBmLQzr1vy2rxs9jMcVmj6Gb68xM5XSYeXPMOUuQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sun, 24 Apr 2022 21:11:26 +0800
Message-id: <20220424131126.2569-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(66946007)(1076003)(4326008)(2616005)(66476007)(107886003)(86362001)(83380400001)(26005)(186003)(66556008)(8676002)(30864003)(36756003)(6666004)(8936002)(38100700002)(6486002)(44832011)(6506007)(2906002)(6512007)(508600001)(5660300002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2022 13:11:34.2541 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10326
 signatures=694694
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxlogscore=999 priorityscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 clxscore=191 mlxscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204240062
Subject: [Ocfs2-devel] [PATCH] test error handling during mount stage
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
X-MC-Unique: cnw3Qb4iMUeFqq6q4tahOg-1
X-ClientProxiedBy: HKAPR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:203:d0::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de2b58de-11d5-49c9-fd0e-08da25f3f4d5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3344:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR0402MB3344480AFCE2A5D382F4D9E897F99@VI1PR0402MB3344.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 ZTwT+f/UUST8HbG/Jdpwj4/H86S8h/wBx+fWaK78wLtjec9xMzmZ9xU8npAYimhfBXu9IR99SwhypVdzSHCgr8POuNQiBcLHleTamjswADVAv9H48SV2MoeumTVIJ4szU+DIGmI66bTxx1PNveMR5IwPqbRqWHvRYj68fDhyJCdy6t3DqfQAngbGvTOGqX+3T31nNw05XyQJQO56a91SP36HuW+d4NHg9tl+H01zUak8vbmSrqvepwkitom4tPmchtPVCi06+XG9sEuF5MjAft/NiXWqCGedrvn48aGk5oU0HIL0hlQHhC3jbwuFypKhuNlqnHZREpuXw0e0EMT0PwEsNou+7a9Cz2xXGvJrtKs9uUFggF7jYKXECxGVb/9EykfFpJETG/KDwow2lUQ8NtM9/KP/yK4M3x2yLIWCDnFViayqUh0tw5XHOiDByOm0U9+y755g+wtkNUBWcueskfz/UEp4XDA73L2MM4PXxImxJoqJe7j2WA8coLzm4GSRijoMpwMMU+ONIOTECSM/Ggk9+hiW+4zQ11bacAqYzb1vYnGdGYu0Dji60+T3vopa0L7YfDfCXpR1Q9NdDGEGccHsxb3xm1D1AQQlX3YiKxf/fON2EAYk8GAfTiG91lCqlTROqQT6sbbYz1IcQnLgIw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?lplQppIJP3dbQurt3WDn9p9kevw/EBCwFIyUrg4LdrpIp7jqdBCut7cVsngK?=
 =?us-ascii?Q?HFIEtuvw1KKrJk+og7ORIfrtn8wnRJApdkaEq35DsYGFHWRwZeTagBeKgLpL?=
 =?us-ascii?Q?UqgZrk7/QlIAIzkDjdj9des2s5t9eMwOizRAw4BXiDoJ8ZlgpZGqKmNJx+YI?=
 =?us-ascii?Q?4Q67pSkBrAjpbXcTA0kDXsJHpRQ97rsT+Bh1Cuu3+xfzdsZVp9mWCicS4M65?=
 =?us-ascii?Q?e8D6NU5O7AL3uWkGxoLFadW/UWSvWZi5rLobe9wLWti1Ah+hf2dW7VuXqcAz?=
 =?us-ascii?Q?hkkbfV/FtdcW6L/Wpslodn8V3JOrt545hRuttL5caGVjkxZLC3jKxGr+oFP8?=
 =?us-ascii?Q?+1XM0QyaLWFxRoGI/2tpcV6VI/rB+b0ccgyqMYd+k6zkj9dP6Q87WEmfUIeh?=
 =?us-ascii?Q?yqDA4lwD3RmyGP4IrG8VxZ6Vp+6e7y6CyOCUfSrh6nn/QkB8Zz6oJ6cHJIxR?=
 =?us-ascii?Q?faAfa8iVSF/N7ujI41zEglnOX4QJ1NEAIaki42Xt2nRAM/UUfp6djE/abMVs?=
 =?us-ascii?Q?KRXdjAEYcQW3bBziSwIKjdUA6anpy7QX/QdiUpAlOuZgIESai7ypBcAW4rZj?=
 =?us-ascii?Q?vDP5PyysP02X+QT1qVXbzVcBIwhoE7jyIqYcDqFkzan9+niONVrH5VurCSj1?=
 =?us-ascii?Q?VD8ZFHPe2L6PtrAmFkd8Jk9wonR1ES/Wd7KHzNOFpv2JZingYAlt9q95gFtQ?=
 =?us-ascii?Q?fKeyU7TS4vemAFOm/B2WDvKSWgpbwNIfU6U7DrPwNCh6QXN7+uqnEMElFuhM?=
 =?us-ascii?Q?oYwZzTVpzJ+g/5f9D6uE6H5hdk2vHVB42AstgfOUQ7+sZcREytv6+J+zq7A5?=
 =?us-ascii?Q?3Ec+8PtaIlNlFBmvUSoy5WDmadXAwxmLkX3Rj+EsbBdaEGrhbuffDYQHRvTS?=
 =?us-ascii?Q?x2MblIhsDwjddv+CLSEY7V/MaLrHJlCCGu8Jm9M1+AJC8TQpR6K3xsiR4qT1?=
 =?us-ascii?Q?GAPh+B5Lv/G0Jt5MPOihw7BMqkniYgyITZClmvT24K/du82ejlEqCh2Qlzp+?=
 =?us-ascii?Q?92CRIzrFH3ip05he7IviZPkYT7S9am4aB8C3VWzCae9T01SD3B6wfbtgsMdO?=
 =?us-ascii?Q?kBKqDNmSXSThYTnCqhxQ5xbOY2Rg8dLQxRcP9S/7jbPPqXxD4TLpGM+00P2M?=
 =?us-ascii?Q?FmUKC6DlgUnGrnkKy/x3pXRXl7YPQi4b43404s9RcwX4Atg8h1OLBcvIn/V6?=
 =?us-ascii?Q?KC1arbbAWlVOhZxp4yZqbZYVJyaU+mSHAJO8FtSV4jTh9QRS+SmFDT93ZNuR?=
 =?us-ascii?Q?O9erFf5adjWT3etLHv4LDYEl20jov2V4DkU2jQh50TBjDcgNPpiSEAW4ZG76?=
 =?us-ascii?Q?TZaBTp7ZqwpRgSDiVMOZrtXx8JIUfYAFPHr/Y27/QqIBSzIadVj8Z+dnHhN4?=
 =?us-ascii?Q?uDrqNUIRDgqZ+QnTedECUGoPnp6xFEjgP1X5d8rlFVFrppFh8cEL5rFkMe+P?=
 =?us-ascii?Q?n78XWh1RJvQD0Bngz2fBj/M8tCQYtJVZaB8MonUPL5kD8aV6jxu/xwrQlYs8?=
 =?us-ascii?Q?xg9EHMvE4cNJezISDQxnRvh6Qil6FHm1HpXqTm4Fq8x7mhrhe5+4lxW5Ujky?=
 =?us-ascii?Q?w4cZ9xDRKfHQLmrIH5mxm/5vBTHSsYAoKonUElLgXXa1Fraz1aHJEFzCJnLE?=
 =?us-ascii?Q?fda5JTczHrtWZgOTH5rLa8nPOTf5eagjGcpUFN1co3c3BzWI3vGQrbCEKTPN?=
 =?us-ascii?Q?nfnTvjNJlnjhHRF/uF2VizoyyfQoMsGtZR3iUdSObWBG5no+PDIA9I1VJFix?=
 =?us-ascii?Q?lTQXHRudbA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 de2b58de-11d5-49c9-fd0e-08da25f3f4d5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 28UIY9svohe1M+7HjpIl144FQAEDVw6TYKL/VuzAXJ0mZAyjMQfqSPUtnr2sj65ZPcAX/nD0MaN5TqmAYlQpAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3344
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: x6m7rYeoA_81gDh6VQsJRZUQF0O3N5H3
X-Proofpoint-ORIG-GUID: x6m7rYeoA_81gDh6VQsJRZUQF0O3N5H3
Reporting-Meta:
 AAHg0IiMfSHJOB7SFsVEiLwaBy8pZgThZoFBl730Uc6WU4FC3D0FI08FePAQzNeR
 t9Me1CeD0OfylHASK2+vySqshuBKbKSSlFbySMQHtn1+YrPb26f4YK8+AHIdb6fy
 0qm9ulftgzRvjtc6SkRr7nDyo7MgtE1yYGy0VJAESkECoW+C9LzaRmRXML6nm5jK
 PBK+j5jptpEN2fAnMQ2vcD/Mok9iGJ0w9hljmOvG4js0JiC11evGFGQ/GzkfSVDq
 lVZ2E+8BHiVl2cu9i22oIOkinyHPV/ZqoNQV8ME2VHhbGlcIX3fVCKBkgiepW2hB
 khx39Jb0qIXZGCXKPhmjGd7mV6aqMAtB4uDGZ6SMDGQ7Wdoo8JgeiSmp993cCZNJ
 E8kWdozGbNTFe854f8FxBRgAj04TYasAHVRIN6YQ5gVm0TCEjvGv3eJg5/ZxQTjR
 pMeLmZax6+BkbiX/SUTjyw6EX4hhhVdywZeujrA7HvtzoAbEI/KkPMZKCIfx5hn3
 WwUi5KKsp8ad5RhrudaRwWfQEeb+UCcOUEuQ6ZJ495UC0A==

this patch is for test my serial patch only.
I don't any plan to add this patch into upstream code.

test script:

```
path="/sys/kernel/debug/ocfs2/mnt_dbg"
dev=$1
mnt=$2

if [ -z "$dev" ];then
    echo "input device. eg: /dev/vdd"
    exit 1
fi
if [ -z "$mnt" ];then
    echo "input mount point. eg: /mnt"
    exit 1
fi

echo "please monitor: journalctl -f"

for i in {1..39}; do
    already_mount=`lsblk | grep $mnt`
    if [ -n "$already_mount" ]; then
        umount $mnt
    fi
    echo "===> error $i <===="
    echo "$i" > $path
    echo "$path: `cat $path`"
    mount -t ocfs2 $dev $mnt
    sleep 1
done
```

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 169 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 151 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f7298816d8d9..4af861f973fc 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -66,6 +66,52 @@ struct kmem_cache *ocfs2_qf_chunk_cachep;
 
 static struct dentry *ocfs2_debugfs_root;
 
+enum {
+	mnt_dbg_off,
+	mnt_dbg_fill_super_1,
+	mnt_dbg_fill_super_2,//useless
+	mnt_dbg_fill_super_3,//useless
+	mnt_dbg_fill_super_4,
+	mnt_dbg_fill_super_5,
+	mnt_dbg_fill_super_6,
+	mnt_dbg_fill_super_7,
+	mnt_dbg_fill_super_8,
+	mnt_dbg_fill_super_9,
+	mnt_dbg_fill_super_10,//useless
+	mnt_dbg_fill_super_11,
+	mnt_dbg_fill_super_12,
+	mnt_dbg_fill_super_13,
+	mnt_dbg_fill_super_14,
+	mnt_dbg_fill_super_15,
+	mnt_dbg_sb_probe_1,
+	mnt_dbg_sb_probe_2,
+	mnt_dbg_sb_probe_3,
+	mnt_dbg_init_super_1,
+	mnt_dbg_init_super_2,
+	mnt_dbg_init_super_3,
+	mnt_dbg_init_super_4,
+	mnt_dbg_init_super_5,
+	mnt_dbg_init_super_6,
+	mnt_dbg_init_super_7,
+	mnt_dbg_init_super_8,
+	mnt_dbg_init_super_9,
+	mnt_dbg_init_super_10,
+	mnt_dbg_init_super_11,
+	mnt_dbg_init_super_12,
+	mnt_dbg_init_super_13,
+	mnt_dbg_init_super_14,
+	mnt_dbg_init_super_15,
+	mnt_dbg_mount_volume_1,
+	mnt_dbg_mount_volume_2,
+	mnt_dbg_mount_volume_3,
+	mnt_dbg_mount_volume_4,
+	mnt_dbg_mount_volume_5,
+	mnt_dbg_mount_volume_6,
+	mnt_dbg_last = mnt_dbg_mount_volume_6,
+};
+
+static u64 mnt_dbg;
+
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("OCFS2 cluster file system");
@@ -121,6 +167,7 @@ static void ocfs2_free_inode(struct inode *inode);
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
+int mnt_err_inject(u64 mnt_dbg_num);
 
 static struct dquot **ocfs2_get_dquots(struct inode *inode)
 {
@@ -727,6 +774,15 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	return ret;
 }
 
+int mnt_err_inject(u64 mnt_dbg_num)
+{
+	if (mnt_dbg == mnt_dbg_num) {
+		mlog(ML_ERROR, "trigger dbg num: %llu\n", mnt_dbg);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int ocfs2_sb_probe(struct super_block *sb,
 			  struct buffer_head **bh,
 			  int *sector_size,
@@ -741,7 +797,7 @@ static int ocfs2_sb_probe(struct super_block *sb,
 
 	/* may be > 512 */
 	*sector_size = bdev_logical_block_size(sb->s_bdev);
-	if (*sector_size > OCFS2_MAX_BLOCKSIZE) {
+	if (*sector_size > OCFS2_MAX_BLOCKSIZE || mnt_err_inject(mnt_dbg_sb_probe_1) < 0) {
 		mlog(ML_ERROR, "Hardware sector size too large: %d (max=%d)\n",
 		     *sector_size, OCFS2_MAX_BLOCKSIZE);
 		status = -EINVAL;
@@ -772,7 +828,7 @@ static int ocfs2_sb_probe(struct super_block *sb,
 	}
 	brelse(*bh);
 	*bh = NULL;
-	if (status < 0) {
+	if (status < 0 || (status = mnt_err_inject(mnt_dbg_sb_probe_2)) < 0) {
 		mlog(ML_ERROR, "This is an ocfs v1 filesystem which must be "
 		     "upgraded before mounting with ocfs v2\n");
 		goto bail;
@@ -808,6 +864,10 @@ static int ocfs2_sb_probe(struct super_block *sb,
 			break;
 		}
 	}
+	if ((status = mnt_err_inject(mnt_dbg_sb_probe_3)) < 0) {
+		brelse(*bh);
+		*bh = NULL;
+	}
 
 bail:
 	return status;
@@ -987,7 +1047,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	trace_ocfs2_fill_super(sb, data, silent);
 
-	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
+	if (!ocfs2_parse_options(sb, data, &parsed_options, 0) || mnt_err_inject(mnt_dbg_fill_super_1) < 0) {
 		status = -EINVAL;
 		goto out;
 	}
@@ -999,6 +1059,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	//add mnt_err_inject() in ocfs2_initialize_super()
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
 	brelse(bh);
 	bh = NULL;
@@ -1007,7 +1068,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	osb = OCFS2_SB(sb);
 
-	if (!ocfs2_check_set_options(sb, &parsed_options)) {
+	if (!ocfs2_check_set_options(sb, &parsed_options) || mnt_err_inject(mnt_dbg_fill_super_4) < 0) {
 		status = -EINVAL;
 		goto out_super;
 	}
@@ -1025,7 +1086,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		osb->osb_dir_resv_level = parsed_options.dir_resv_level;
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
-	if (status)
+	if (status || (status = mnt_err_inject(mnt_dbg_fill_super_5)) < 0)
 		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
@@ -1036,7 +1097,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Hard readonly mode only if: bdev_read_only, SB_RDONLY,
 	 * heartbeat=none */
 	if (bdev_read_only(sb->s_bdev)) {
-		if (!sb_rdonly(sb)) {
+		if (!sb_rdonly(sb) || mnt_err_inject(mnt_dbg_fill_super_6) < 0) {
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
@@ -1045,7 +1106,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 		/* You should not be able to start a local heartbeat
 		 * on a readonly device. */
-		if (osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) {
+		if ((osb->s_mount_opt & OCFS2_MOUNT_HB_LOCAL) || mnt_err_inject(mnt_dbg_fill_super_7) < 0) {
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
@@ -1053,7 +1114,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
-		if (status < 0) {
+		if (status < 0 || (status = mnt_err_inject(mnt_dbg_fill_super_8)) < 0) {
 			if (status == -EROFS)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
@@ -1074,7 +1135,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0)
+	if (status < 0 || (status = mnt_err_inject(mnt_dbg_fill_super_9)) < 0)
 		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
@@ -1087,6 +1148,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
 							osb->osb_debug_root);
 
+	//add mnt_err_inject() in ocfs2_mount_volume()
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
 		goto out_debugfs;
@@ -1094,14 +1156,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
-	if (!inode) {
+	if (!inode || mnt_err_inject(mnt_dbg_fill_super_11) < 0) {
 		status = -EIO;
 		goto out_dismount;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
-	if (!osb->osb_dev_kset) {
+	if (!osb->osb_dev_kset || mnt_err_inject(mnt_dbg_fill_super_12) < 0) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
 		goto out_dismount;
@@ -1109,7 +1171,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Create filecheck sysfs related directories/files at
 	 * /sys/fs/ocfs2/<devname>/filecheck */
-	if (ocfs2_filecheck_create_sysfs(osb)) {
+	if (ocfs2_filecheck_create_sysfs(osb) || mnt_err_inject(mnt_dbg_fill_super_13) < 0) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
@@ -1117,7 +1179,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	root = d_make_root(inode);
-	if (!root) {
+	if (!root || mnt_err_inject(mnt_dbg_fill_super_14) < 0) {
 		status = -ENOMEM;
 		goto out_dismount;
 	}
@@ -1150,7 +1212,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	 * log recovery can happen but that waits for proper quota setup */
 	if (!sb_rdonly(sb)) {
 		status = ocfs2_enable_quotas(osb);
-		if (status < 0) {
+		if (status < 0 || (status = mnt_err_inject(mnt_dbg_fill_super_15)) < 0) {
 			/* We have to err-out specially here because
 			 * s_root is already set */
 			mlog_errno(status);
@@ -1572,6 +1634,21 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
+static int ocfs2_mnt_dbg_set(void *data, u64 val)
+{
+	u64 *mnt_dbg_num = (u64 *) data;
+	*mnt_dbg_num = val;
+	mlog(ML_ERROR, "set value: %llu\n", val);
+	return 0;
+}
+static int ocfs2_mnt_dbg_get(void *data, u64 *val)
+{
+	u64 *mnt_dbg_num = (u64 *) data;
+	*val = *mnt_dbg_num;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(ocfs2_mnt_dbg_fops, ocfs2_mnt_dbg_get, ocfs2_mnt_dbg_set, "%llu\n");
+
 static int __init ocfs2_init(void)
 {
 	int status;
@@ -1586,6 +1663,9 @@ static int __init ocfs2_init(void)
 
 	ocfs2_debugfs_root = debugfs_create_dir("ocfs2", NULL);
 
+	debugfs_create_file("mnt_dbg", S_IFREG|S_IRUSR, ocfs2_debugfs_root,
+			    &mnt_dbg, &ocfs2_mnt_dbg_fops);
+
 	ocfs2_set_locking_protocol();
 
 	status = register_quota_format(&ocfs2_quota_format);
@@ -1815,16 +1895,22 @@ static int ocfs2_mount_volume(struct super_block *sb)
 			" disk does not match the running cluster name.\n");
 		goto out;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_mount_volume_1)) < 0) {
+		goto out_dlm;
+	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_dlm;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_mount_volume_2)) < 0) {
+		goto out_super_lock;
+	}
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
-	if (status < 0) {
+	if (status < 0 || (status = mnt_err_inject(mnt_dbg_mount_volume_3)) < 0) {
 		mlog_errno(status);
 		goto out_super_lock;
 	}
@@ -1835,9 +1921,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		mlog_errno(status);
 		goto out_super_lock;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_mount_volume_4)) < 0) {
+		goto out_system_inodes;
+	}
 
 	status = ocfs2_check_volume(osb);
-	if (status < 0) {
+	if (status < 0 || (status = mnt_err_inject(mnt_dbg_mount_volume_5)) < 0) {
 		mlog_errno(status);
 		goto out_system_inodes;
 	}
@@ -1847,6 +1936,10 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		mlog_errno(status);
 		goto out_system_inodes;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_mount_volume_6)) < 0) {
+		ocfs2_truncate_log_shutdown(osb);
+		goto out_system_inodes;
+	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
@@ -2032,6 +2125,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_1)) < 0) {
+		goto out;
+	}
 
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
@@ -2087,7 +2183,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		 MAJOR(osb->sb->s_dev), MINOR(osb->sb->s_dev));
 
 	osb->max_slots = le16_to_cpu(di->id2.i_super.s_max_slots);
-	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0) {
+	if (osb->max_slots > OCFS2_MAX_SLOTS || osb->max_slots == 0 || mnt_err_inject(mnt_dbg_init_super_2) < 0) {
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
@@ -2102,6 +2198,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_3)) < 0) {
+		goto out_recovery_map;
+	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
 
@@ -2126,6 +2225,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		status = -ENOMEM;
 		goto out_recovery_map;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_4)) < 0) {
+		goto out_vol_label;
+	}
 
 	osb->slot_recovery_generations =
 		kcalloc(osb->max_slots, sizeof(*osb->slot_recovery_generations),
@@ -2135,6 +2237,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_vol_label;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_5)) < 0) {
+		goto out_slot_recovery_gen;
+	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
 	osb->osb_orphan_wipes = kcalloc(osb->max_slots,
@@ -2145,6 +2250,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_slot_recovery_gen;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_6)) < 0) {
+		goto out_orphan_wipes;
+	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
 
@@ -2207,6 +2315,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	status = ocfs2_journal_alloc(osb);
 	if (status < 0)
 		goto out_orphan_wipes;
+	if ((status = mnt_err_inject(mnt_dbg_init_super_7)) < 0) {
+		goto out_journal;
+	}
 
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
@@ -2223,6 +2334,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		status = -EINVAL;
 		goto out_journal;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_8)) < 0) {
+		goto out_journal;
+	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
 						le32_to_cpu(di->i_clusters));
@@ -2235,6 +2349,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		status = -EFBIG;
 		goto out_journal;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_9)) < 0) {
+		goto out_journal;
+	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
@@ -2242,6 +2359,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		status = -ENOMEM;
 		goto out_journal;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_10)) < 0) {
+		goto out_uuid_str;
+	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
 		OCFS2_MAX_VOL_LABEL_LEN);
@@ -2262,6 +2382,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_uuid_str;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_11)) < 0) {
+		goto out_dlm_out;
+	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
 
@@ -2271,13 +2394,16 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_dlm_out;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_12)) < 0) {
+		goto out_system_inodes;
+	}
 
 	/*
 	 * global bitmap
 	 */
 	inode = ocfs2_get_system_file_inode(osb, GLOBAL_BITMAP_SYSTEM_INODE,
 					    OCFS2_INVALID_SLOT);
-	if (!inode) {
+	if (!inode || mnt_err_inject(mnt_dbg_init_super_13) < 0) {
 		status = -EINVAL;
 		mlog_errno(status);
 		goto out_system_inodes;
@@ -2295,6 +2421,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_system_inodes;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_14)) < 0) {
+		goto out_slot_info;
+	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
@@ -2302,6 +2431,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		mlog_errno(status);
 		goto out_slot_info;
 	}
+	if ((status = mnt_err_inject(mnt_dbg_init_super_15)) < 0) {
+		destroy_workqueue(osb->ocfs2_wq);
+		goto out_slot_info;
+	}
 
 	return status;
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
