Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE76C00144
	for <ocfs2-devel@archiver.kernel.org>; Sat, 30 Jul 2022 01:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fifuMse5vzT+KtFkmoHbCMFanP16oUlqtUKqEL8FQjU=;
 b=WXyTz2EqZ4BzyloZvZfFVa9xV9GJ6DZWLUhSOoCiAbw3g4In/ZeBqU5lsMLoRrXm/KZIhmHYur/G
   +xZ3JbrDmumKw6i4ncGxyJOV3hT8veHhqyz4aDvG/XayMBgXqAZbyJkLAZwsXVKUH5p1toPX3NHy
   J6iICyHXAu3H6wctVhXJvb9CrwKj0Y1Ma4eu+WyknJT+AxKj1SdbUWamsN6H4VgSm9hY5LuHMKcj
   3jKuoqTvw49HckGfttVc9ajBaOIJW3mSYu10qi1WMbIX779wRL2IRNgEl8SRncbWdvdazppNZgA+
   GSPxG5Q690LLq8DBO9XcHSN436Z+Xqr6yZOObQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fifuMse5vzT+KtFkmoHbCMFanP16oUlqtUKqEL8FQjU=;
 b=szBwP3Ph/VmQPxof8HdByVYa5AIarCGLQLat9HNLsjrPB3nzPKgxCj8/XVY3CeZ4i6wCAmlF3Yuk
   MOBqnCZ2Vqk9IOklp6gXBUUCCOZEFN7245AaXqKHJkhXvh5AQhQX3OajoWznIV4VkQehZUgn0/Lb
   bKjtsfMYVYt4RKMdgMB3i7g9gTLELhqQse5o2NkXk0E5cm938PeEBjdee3SPaWtEvW3yByvf1wHn
   obkZoaau7maz2R4D0LlEMClv6IM7PifRsPu0RHQtAthFV4YhaTz+IFIGPbnyBQ5+DMs/8gN1xprF
   bLLIvG1GkMZRa0QcKbpFaFC2GYmaTyoiMVQTvQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFT00LXT7IBFW50@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 30 Jul 2022 01:15:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGYm4mF19ZP82xcz9kcH66gqWwGMVIDvJh8ErK0vdSIQPJSCW79ypdtLUoCa5EbLr1i4Cn6foY7eX5YxDgiXnDLsqtjOFXfmQ2C8Ke7X8+M/NzKJxeVu54LY0oTKz8UHNcmn8v33HYsxhhr9iwD2XMGRqOCacg0o1Jmhy6MDGNRvNnheIxh25tFnJ2h6viQ9MZF0H0jYUoVQ3N7Z65No+rLS/sNpBJ0J8WaiylN5JOSizu0ReIaWUYvNG5JtpFeS8XP+3hgaFj0apn6QWpQUUaFA7BVEcpERJfpl4yCV+f4jIQ4l3FCBica2ODYuluVzE3kk+Tja+bnOYNBtofULHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=425b47NZ//VZqj5kKNsbt72n7ssm1cUueu+VLI/DP2w=;
 b=Rojjt+Nt7cmadVEhsa1Qo2RK8bBansAecPw5NmAdEwJIEGcrZkBgjkbV2WtsletiYJ7fYgaPp2aayZ8DLMD/3RDRfFLegeTIn6n7JrrWjbLVy/knG44okgRt45zlb9riqEGKjuxDCx0BwaJS6J7vM+j+H9Yr8mTB3lFqE5hfZoPPz7SlEHs9rfqLA9e2cAKJmX85W/64GExlGMlnF9SFMCUwy39ecOZMIrLIsVC7kWc4GLkdFdpf2T74uI2UizQcyGZywaK+V3REQC5BBNkUjYDk/twhzKNNL7fQ2ytlkk5WfIjPI09W4+pmIqC3bxk03eCx54f6bQOPaD/FwbUWWA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=425b47NZ//VZqj5kKNsbt72n7ssm1cUueu+VLI/DP2w=;
 b=YTIlbupT/WpSBmBhzz7ZHk39MY2PlpegMzzk6P7ArisWqHRvHsg671PidTYfPHERlFd6UUgnO6eYaNkCZF9nK9LzNYE2dXO+dcABRqSzTpMo5faAE5Hx+hqBoR8iXsAZilkgX5Hr6AMBimRmniKhDaWern72cX8S0hDNY1fZnfVoOQcyLcApzeDY9dg88oQtGpkmxJ/Q6WwQDwSF8jGcqotw3mfVQxJntcqUsactwOSGdsMwXkAmvs9DBoFtWzusiCIk4duLhFOEEDzT/F4khmqYzdnl6Py0+/SFNGOAdkTWR6pqi7js+cjfJof9Bwp/ouQXjw9NEuMGbt+8ZQ4HRA==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Sat, 30 Jul 2022 09:14:10 +0800
Message-id: <20220730011411.11214-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220730011411.11214-1-heming.zhao@suse.com>
References: <20220730011411.11214-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM6PR04MB4662.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(396003)(366004)(39860400002)(376002)(136003)(346002)(38100700002)(41300700001)(5660300002)(8936002)(66946007)(478600001)(83380400001)(66556008)(8676002)(316002)(4326008)(66476007)(6486002)(2616005)(1076003)(186003)(6666004)(6506007)(26005)(6512007)(2906002)(44832011)(86362001)(36756003); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 01:15:27.8218 (UTC)
X-Source-IP: 40.107.1.68
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10423
 signatures=596356
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 priorityscore=136 spamscore=0 lowpriorityscore=0 clxscore=243
 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207300005
Subject: [Ocfs2-devel] [PATCH 3/4] re-enable
 "ocfs2: mount shared volume	without ha stack"
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
X-ClientProxiedBy: SG2PR01CA0109.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::13) To AM6PR04MB4662.eurprd04.prod.outlook.com
 (2603:10a6:20b:1b::21)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70add5a9-805c-417e-9d83-08da71c8fcd2
X-MS-TrafficTypeDiagnostic: AM6PR04MB4840:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 rFVgW6jebLVxP4NV88SSI5QN/9mnAawUo8wcdCTgWaqge0z1rfhmLchLTM8uwzWMG425jdaYZOTL6mBMlXSEJ2CN/FkGi7pMBOq2Ervrp2MxwC+rR1SWvuZTpM+pzNy1fNvtFbF6///T0LJOgOdiiUpGFQPHxYqXMnwkolsb+EDvHF0ZjJ1EXKdShK5llaAgRNxMiDsHtzQy/WEkEkeT5kJVnc3rNkrY1EXFjzHmQ2NXlBVeBQCmkCSsZcuZTTzKKvKr7udbnm1mJPkqKU8iFBrYk1VbJAtjkr5y7BY+3s4WjEynqQI6nr6k5FG/8Rcpyhp3L8NZLp4KHWO4u5UvGT9W1k9CPxACkprr4dDeaQ5cRjrqWrnToR/SeThVrqlQZAE5RtDD2RZI949P/OrsLlFSK+CGa7Rs9lWOFGONsuU7jxCFfKX9bm7q5fWVDdF5fXNtSeQzzLrdVq61b7ZcmM1k33h4twoUCM801xsrywVx1jRy5v3OFerxJA7onwzEACcr6OTGQQki7+vhv35OmwrKKcejv8wbuzMbDCk7ggJkh4Nj3Rarmvm4hdn8+t2GMRK1HTaGfzc5r0o+pTjkSHUD5nG6by77pzDQ02VdEjF/fZ0wuEJmnTnQ0iK1SIoRZlzoXo3ApIBAr0ZgqJegi54ijQxdZqojsIjgKIkbivX40HDWtQRT6PFjUXMJ3YBpxmsJ/4vdvPk+XFT+cp8BdCodV0gPk1Ig9y+WtoN4Dg1OC+dzlynUCZ4WlAPxBQfS
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ksETU3LZMfpSTNIPJGzFlrE8WE+vU/Kz+4FvQsLgzipyFO78A3imZutmtaCa?=
 =?us-ascii?Q?rl2aUpAxEy+frficf+tYZT98SF55IPVDV7qgXNvp1adbGMDDp+4Kxb/O2MG1?=
 =?us-ascii?Q?Jldwv2j1NPvvFDla8iXLYh6hxvp/lSrDxZyQmzeoWqMxW1vkTfQ7/rGYT8IE?=
 =?us-ascii?Q?XxS9SLKtQYDmjblOtE9bpYiZ72JZDLOZXrYlslx0HmZ02zJKi9WLgl9mz6dC?=
 =?us-ascii?Q?ybqfCsC84VluNmFNqy11bZvCb/fXhN4/LBrSKSZPB6TEGctEFoQy9eb6eLmU?=
 =?us-ascii?Q?zLWzHO0fJiZzag5nIk9d6aSEjWovbx/R3Qz2fl7vVHFMxGc7BRYqAS+E655r?=
 =?us-ascii?Q?4UT8ngXKMtrYnHkR70D4DsMcrRT04YTDOlMbyiwqXrP824VGJHgxOO8qaJ5r?=
 =?us-ascii?Q?ZqDvrdpNV145jKD70BOlHxoonQNxO10VtCG6fDKC6DQ8jJjBg9gINqUQALWM?=
 =?us-ascii?Q?0H6EovbR3b6Ouu1rTxml3xuWLcjZ3zNx0yNt0UfFQWVPS/xljUxCtvEBcmAi?=
 =?us-ascii?Q?vWNtTl0gUuzkbK9q78LmjiECQ91/hgi1yoea3JXV6bT7rSMJW1FMCg0Hwpdm?=
 =?us-ascii?Q?CRahzCBlntUGxUBltyj+dmknR2GGLHlFD/0eB8nEwBPDfY4cfyJndrlEqItp?=
 =?us-ascii?Q?sjKzhwHOYl3eCXyezxk2d+ngcChH61q0+mDgvkdD49iidMCKKojcTE11s2C3?=
 =?us-ascii?Q?KTq7MSa3RZYngH9GxWGuICwe41GJAalBgiBmBOBbaKbgGqhZPqlsVIMAQmjX?=
 =?us-ascii?Q?FUEIGL70+SlUL5mCkKtWsmrp8VYZVRX4HdKJfduNJ2WeDqqYLq/elwcmRUU5?=
 =?us-ascii?Q?8jFZR/GxSM833/+ucKdNOXx5lfLuqrXaiX7chJhgEifLg7vL4cMBH74Ij17n?=
 =?us-ascii?Q?3GKonnXHagzhJ38ZoY3muspAlRhIfxmmSvk22kjnbvYK41eAtqe1SvT7NK9j?=
 =?us-ascii?Q?qKXR+ArNWLl6bukEpeqY8Zz9ruQSnnWaFHp3d8tiZm27jRroNPXZ/uPEhTtK?=
 =?us-ascii?Q?La1aui1yFG1SGZXvnqFeLaCIBC3zJ9BLaexDHsoH3GwOxfhQTbwf8UYq6VV3?=
 =?us-ascii?Q?aoiop47WnCj5qGdoC1ZyXo50C1522lC4PKNiclvn206iG1euQ78gtpQbGrEP?=
 =?us-ascii?Q?jGBcn6tfgSx3D4wyIDMmi37VJf+jlQxBKeyoMkTru7Z/Xs5JTqlMNBpmUDdr?=
 =?us-ascii?Q?qC7tXxLsenKKsisS9DReoWbwlTwzHYzFooF75d7xC/INXUw7VEzrD+2+6hzE?=
 =?us-ascii?Q?0um3r13XQ3uLcR2ZHqOh4Xz76QbqwEOXlkcsRs6wY/PI3wsifg2gVzFks4++?=
 =?us-ascii?Q?koR4OH6xDIXTKYy614dtygyzgpebEllQT2Sc82hQAE8m8xAIPk9smeZTLnyj?=
 =?us-ascii?Q?nDYecsU4nBC909+mtqO4Vn1xo8LU2dMy9k8LF1h+QzpHudPYmz96WLGfMLJy?=
 =?us-ascii?Q?PvUIG4Pwc+k27HVWkj29KzGuf8PNVSUN6TU3dTHr9cKqk7qjRVqRX0EQJEre?=
 =?us-ascii?Q?7n96NCi0PInxNT6i38GkntC+XJGw+z3ILYhMeke75h+AJWYLfWICRsBfqXpG?=
 =?us-ascii?Q?AN7YH6zJ3UaUL1TyiKElSTw7axS7ScDYVp028L28?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 70add5a9-805c-417e-9d83-08da71c8fcd2
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4662.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 gT9zEGFMKbfdpA+F0Vh+x4nH1cPuzUFviZLd7/RSdB2nJde8D+7JbxuWTfNJXv+kNtAFWoRtBO4tTFyuEqeEOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4840
X-ServerName: mail-eopbgr10068.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: gB8bqNNApMxhAyLiXvwsCzVxoNE-bjax
X-Proofpoint-GUID: gB8bqNNApMxhAyLiXvwsCzVxoNE-bjax
Reporting-Meta:
 AAE1DFZ4j7U4WpLz07R9UegAw7/CF68Ncp7MSoO+wT6mcBdNWgLkYhRZsS04yyDI
 fIvUpY+ONG2cGXdbkAveBJHMFpLDsY85a6xp5NCNGBMoud2Ub6n5/Urkj72GQxXE
 rx5OuoTa6DLI2hUaW7KtyHLrvinTARigs4Ybh0dO1ZPKD2N3Ldz8ejGknSib7yqY
 meLioi/e5QmoYwJvBmJrUzy7QnLqm9PQFtH2/5p5tQEe6uNDKnaXBzqedzgGMBvX
 gNIsm3ehPKuN2VzL+GInlISWkIDdfdfqYLE1GjGnQgMxKUkXDnUtilwafoEEJp9m
 z3vZ/KMWI4anZ+/fpf+rEGARCApsbA8tVSMuaalJ4n5Hvs09RocxlfUdaekByb5Z
 gPDBSzTp3HIRdWi/3Qy/o8By/yw/DB0/R7sptDo1Kf2eOsOKvxIc9yIUuWK3aMCK
 LSeyq8h7AQk5pbAyB/CpTfMDPZsrSJC9fjHuMJxrpjXrGveyhhu0oYeNYx2kxIBx
 YPsHo6ewLlqs6DAYp27PVPtVGOb+pQPbhlMlkFU12cY=

the key different between local mount and non-clustered mount:
local mount feature (tunefs.ocfs2 --fs-features=[no]local) can't do
convert job without ha stack. non-clustered mount feature can run
totally without ha stack.

commit 912f655d78c5 ("ocfs2: mount shared volume without ha stack") had
bug, then commit c80af0c250c8f8a3c978aa5aafbe9c39b336b813 reverted it.

Let's give some explain for the issue mentioned by commit c80af0c250c8.

Under Junxiao's call trace, in __ocfs2_find_empty_slot(), the 'if'
accessment is wrong. sl_node_num could be 0 at o2cb env.

with current information, the trigger flow (base on 912f655d78c5):
1>
nodeA with 'node_num = 0' for mounting. it will succeed.
at this time, slotmap extent block will contains es_valid:1 &
es_node_num:0 for nodeA
then ocfs2_update_disk_slot() will write back slotmap info to disk.

2>
then, nodeB with 'node_num = 1' for mounting
this time, osb->node_num is 1 (set by config file), osb->preferred is
OCFS2_INVALID_SLOT (set by ocfs2_parse_options).

ocfs2_find_slot
 + ocfs2_update_slot_info //read slotmap info from disk
 |  + set si->si_slots[0].es_valid = 1 & si->si_slots[0].sl_node_num = 0
 |
 + __ocfs2_node_num_to_slot //will return -ENOENT.
 + __ocfs2_find_empty_slot
    + if ((preferred >= 0) && (preferred < si->si_num_slots))
    |  fails enter this 'if' for preferred value is OCFS2_INVALID_SLOT
    |
    + 'for(i = 0; i < si->si_num_slots; i++)' search slot 0
      successfully.
    |  'si->si_slots[0].sl_node_num' is false. trigger 'break' condition.
    |
    + return slot 0.
       it will cause nodeB grab nodeA journal dlm lock, then trigger hung.

How to do for this bug?

This commit re-enabled 912f655d78c5, next commit (add MMP support) will fix
the issue.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/ocfs2.h    |  4 +++-
 fs/ocfs2/slot_map.c | 46 ++++++++++++++++++++++++++-------------------
 fs/ocfs2/super.c    | 21 +++++++++++++++++++++
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 740b64238312..337527571461 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,6 +277,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
+	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -672,7 +673,8 @@ static inline int ocfs2_cluster_o2cb_global_heartbeat(struct ocfs2_super *osb)
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
+	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
+		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index da7718cef735..0b0ae3ebb0cf 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,14 +252,16 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid) {
+		if (!si->si_slots[preferred].sl_valid ||
+		    !si->si_slots[preferred].sl_node_num) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid) {
+		if (!si->si_slots[i].sl_valid ||
+		    !si->si_slots[i].sl_node_num) {
 			ret = i;
 			break;
 		}
@@ -454,24 +456,30 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	/* search for ourselves first and take the slot if it already
-	 * exists. Perhaps we need to mark this in a variable for our
-	 * own journal recovery? Possibly not, though we certainly
-	 * need to warn to the user */
-	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
-	if (slot < 0) {
-		/* if no slot yet, then just take 1st available
-		 * one. */
-		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
+	if (ocfs2_mount_local(osb))
+		/* use slot 0 directly in local mode */
+		slot = 0;
+	else {
+		/* search for ourselves first and take the slot if it already
+		 * exists. Perhaps we need to mark this in a variable for our
+		 * own journal recovery? Possibly not, though we certainly
+		 * need to warn to the user */
+		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
 		if (slot < 0) {
-			spin_unlock(&osb->osb_lock);
-			mlog(ML_ERROR, "no free slots available!\n");
-			status = -EINVAL;
-			goto bail;
-		}
-	} else
-		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
-		       "allocated to this node!\n", slot, osb->dev_str);
+			/* if no slot yet, then just take 1st available
+			 * one. */
+			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
+			if (slot < 0) {
+				spin_unlock(&osb->osb_lock);
+				mlog(ML_ERROR, "no free slots available!\n");
+				status = -EINVAL;
+				goto bail;
+			}
+		} else
+			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
+			       "already allocated to this node!\n",
+			       slot, osb->dev_str);
+	}
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 438be028935d..f7298816d8d9 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -172,6 +172,7 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
+	Opt_nocluster,
 	Opt_err,
 };
 
@@ -205,6 +206,7 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
+	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -616,6 +618,13 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
+	tmp = OCFS2_MOUNT_NOCLUSTER;
+	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
+		ret = -EINVAL;
+		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
+		goto out;
+	}
+
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -856,6 +865,7 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
+	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1127,6 +1137,11 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
+	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
+	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
+		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
+		       "without cluster aware mode.\n", osb->dev_str);
+
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1437,6 +1452,9 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
+		case Opt_nocluster:
+			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1548,6 +1566,9 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
+	if (opts & OCFS2_MOUNT_NOCLUSTER)
+		seq_printf(s, ",nocluster");
+
 	return 0;
 }
 
-- 
2.37.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
