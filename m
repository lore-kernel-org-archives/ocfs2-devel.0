Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCF2C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 18 Mar 2022 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=f9KOa0vxK9Iu9E5EoZxBfQAa2y874P20L4uTz5dhoxI=;
 b=l+WO2mkam7kU0Vr1imHVbf56ME+9ZE4cdnA1fHMm3T3xkG5qt0eH7mqo6x1K9tGPqw6XEDlCQYuA
   zizl/5Prup45AsgRfCiq1IjWwAZxvR2CGkXr03MaHNctzUJ5Rb2bh88VLrJ7V6S+clJO0WsIv7Hg
   g7oqq+MuMFzYklxKKMgElQlxcdv1oKbkJTUFkSfvFKX6rF2lXE8hqj3COTkysxUoEfsGN2rF9y0w
   I8pjcUI2PRoOtQpfi7EI6PLhyZPKFEGe1jbm+W/j+tr2B1a+Y6ERxRaCftt4vDICZ2hlOiSeou5F
   pWLBuWIDLh+SwyGstTNvGOmPnV3TiiCM9SbLVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=f9KOa0vxK9Iu9E5EoZxBfQAa2y874P20L4uTz5dhoxI=;
 b=o4dVFuSmHNwb+z3L7QslewMnUS9oEuSfkWfXaKHgmFngnx9YFKVehw+/RgvTa7VNmUaRHN7PL+4o
   yeo6T76MclZ5GNwWs1bzGt+XvTScOn1QoFD2GYpMa3zPU1JhtX89HBYE8lKTuTj0eXNgewU/uzMw
   5a5RtSt0lJIn+Lg3clo2t6tBaIM9E8im4ZA8lBSHV9oliLLdqOczUzSL2fFMKKPkr+Jh35iuLFYW
   e0/Myfzg7Nug1/gjk8GTBzlDC/3q5hwcBnhAx1D6o9V+m7QFQ74/2atrEz4Bd2h40AQJGT8Cbg6U
   dUe2+W89/C0QtbnSiFi6gdtbzlET5nP5fphSyw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8Y00EZD4JI9Z10@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 18 Mar 2022 15:04:30 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.d=suse.com
 header.s=mimecast20200619; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1647615851;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=/SUmKUSW31YMWPcp7LvYgu/kr1rP2BsymceK7Wf0+oc=;
 b=Soz72iIW+oWlnI8tf/IRl+Kgdd0Y/CE+OENRJlmJE14XIfUaughlhBfF21EgUg+buRO2js
 zkCvw/bzEfpLlcchG0PlzvlrkuOBXX6DOkcuLNqMOcGMtxMacSnqINSE+WrHoun+fqW+ew
 iXRNpfiBon3VALTXNTxbMo2O6Olvubs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsnvuDc/E+LTmkrgrclNsCcQZGSxOnakxke2IZSq/pA4NN4r56+YWscNPMHHKcUH1NA7l3t8+bsq2xBCVqnggvOhlRWdS/J7jAmoVm2BKP0gnHaIGK52KEMz1YhlhvtOi+jCvJYv8sZP3hn+i8k6/nvpnCNtipbyYSyZVjlEnxxGoICGzYksUI9p2sT+CdHEvkVrOv6j2AudF5/ubF5hHAKHxMTVL3zJZEXR1qx0k4EkPxINeC43UdhbIEmnllcXQMNKMtiRs3BM1L7truwqar6LNGMAV4UgLbVVAiaGEYIzwg3UBUX1UMa5mNTz2FOfdxQHLKUpj7qToKfNK33Vmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5nI8B7F8IRYKC2MrunaGM+5uaI9VRtE4Ym6txfFJVQ=;
 b=KzPJC0QWoGYjIloCDJsKEQpG7gKjibwI6YAXFeUhJxSNyioI8+nsZxgbsE+ZPCoIqp4h5/0Llc1JUd8HwILb+zme5eH6DcQjoFXzqiDfAu7g1v6wVJ4F52X/Uqe18drYFeVAazkP3Knb9KhAK8bv0WqG1lierb7RLHeXy0gXTF+S8htj3TTaRfA9uc3n8Uw5XjGCEKIacpUJBWL6YqhFXmoY2K3kRN05F2C0s+HoSO/geZMTjud7RG/Jpk5bZ37b69MleHMNFTqDDwqmxAN7DjYE2pzOcjBTKCQmllifDDypoTqJ9SRe1PQm2BLgCOTKUZWv/274TMUQsH/FpNDRwQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri, 18 Mar 2022 23:04:01 +0800
Message-id: <20220318150401.2411-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(83380400001)(2906002)(2616005)(107886003)(8936002)(66476007)(66556008)(4326008)(8676002)(66946007)(26005)(186003)(6512007)(508600001)(6506007)(6666004)(36756003)(1076003)(44832011)(316002)(38100700002)(86362001)(6486002)(5660300002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 15:04:08.6182 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289
 signatures=693715
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=198 mlxscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=266 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=954
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180084
Subject: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after	mounting
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: W_9C05OFPqCuO6WyZ4xyww-1
X-ClientProxiedBy: HK0PR01CA0061.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::25) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 238c3416-3769-4626-dd36-08da08f08d6d
X-MS-TrafficTypeDiagnostic: DB7PR04MB5515:EE_
X-Microsoft-Antispam-PRVS:
 <DB7PR04MB5515B18DBB611E07530BDAC197139@DB7PR04MB5515.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 +lthxkNi/qa7jucjlZRbx49+i2EbTaHJ8gERArg/LoNPzoT36v3OgbXQdIN3/7cabegoxVMx6LQsMW9h10GrZa+/sgYM7RR0ovLopMtZlUe0idUbA6q/UwDgx2QC19oosituPN3HbfuaW2Evl2RSrTjH9IvNnsEEBxzVNg0/r9Pvkp1Uui53465QbchRrbqcfkeQG8q62Oe0lnYh8i9pqYlWiwAmRBoYi+umiHUytuKUAlcKh1dZ6ep6dKH9LwZrvIWjhHBmXAOmV3lizfUfXgwVhD2zcQb8VijVBlaT8fb+dinfKZUT2ghBJzQtksyNIBHRRg+KjJgZLagZcDSw16th4lJrvYu42gR3BiXV+IbnCkT/yVzWpBBq8FmZs2HzmrwD4h0p7Y3dD9kpBjeITCIZbGGxAi9awZeM3ivrKmXb3HN0Oyx4dz3/p5SAhD6g1G753Vc9E3A4SVVrIP3pb9u8QgAURR9wOTBoO72j5t89cgO0/XlCX/Mski/fZRdliyTYTTGGkpxIalXYiMg1lGx4edKpB+ROflk5KDnfbSR78laCKQVaEW2g+DwoTTyzc1W+YGWNi4iW+IWxN6T+HYBKnsLvaHD6ja6x5b5gdP8KWCl+laE//hlVaRsS54n0Qf77+C0382/gb4wIJ3LkTQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?4kdNnEApNKsVGDv6/U9PnVzRQmiq/2VvR3B9VSJB4ayYytJq1OcuDQ+9HBI4?=
 =?us-ascii?Q?5iZuCRUB2ydpQdwdjjh2rpd/CcoQVFesAB78jLyueQjPqjA2uheywbHDECBU?=
 =?us-ascii?Q?sFOeLuGpeV1ndBZH43r+sZLg7kgoJiHH21668AzPlTg/kg+QjbL4DBM3MZS2?=
 =?us-ascii?Q?2xdoj0Zfe4VPz13GKzHKEG4QPh6aw0P7sLg2UjL6hj2kPEe8gKf50WUOV1Bx?=
 =?us-ascii?Q?7EZ/DPGkGK/dcD3Nfd5n6ShXrikoAUo7FEmoz310KR8qw1G+wTl+INtf5nAp?=
 =?us-ascii?Q?oQ38/dFYKvJSMMAZzFfj+VzL2hFxxpwtQY25/tqvrkcQGBy8FkO6IdVLXXrX?=
 =?us-ascii?Q?IO8uRhjNFTiZo7q6BaSzpjwSXfm+l91siEV7PO16uQ8oTb0qRc4728CEZdCA?=
 =?us-ascii?Q?EqRFhsuxUasX5BurPtNj0rc2/202IWpMlEWg3S5hnMfyvIsOc8i+5XsdC6jK?=
 =?us-ascii?Q?TkEjJSHd9RsCy0b+KfZ3gAyObiZMBH2plh7idLAkBYIEjrBhMpcPtU07xIsY?=
 =?us-ascii?Q?ZM7uGYWyAg9FPKxiwRgup7jqKdGMED6GDflU2qjp5S+DLABkmAoWdtpqOaTF?=
 =?us-ascii?Q?B4em3wKFMaeOmya+WTilCHcoJIEx/5KjkA6hSaWttl0LwTJwGeR8ug4rGDXO?=
 =?us-ascii?Q?ikvR9ZgwCYMPe+lGNdp59lhGzex4I0PX9loVrnXvPh60rC+FgwB0QGob2N9z?=
 =?us-ascii?Q?0j+4zgy85oi+kLH3sIfENaqhTPzj7LPNeI+UHpIOYUAkYn9nM6VHaNjMYlq1?=
 =?us-ascii?Q?o/k990Y4ZdrssTbnJ2lDDfvUdtvh405qIU4VQmyWmCtv2WfNaYCz2Mt0SVRD?=
 =?us-ascii?Q?gRdVQuCllgVvPlThiRwDReR77hAqdMr9WgAZdmPRynruGcwPOxKMUXLSXvjV?=
 =?us-ascii?Q?2B9vOuTJ8MfSIotfpp7eHR+Ok14ax5ey+iUwlx/ibfahI4IpFJ1dPhirIEsS?=
 =?us-ascii?Q?CHYpcnFfyJs92TGq/7tucyLextWCEemL8tZd/xqDhDxzynjKTk+zyHwQt5zY?=
 =?us-ascii?Q?LC1o6EzuAf0tJyug+PkmhevhTiOnoFCoPTp0ox16z7RxJmWNCLzjWnikJFNq?=
 =?us-ascii?Q?rY6S3beDBy7+yAVfhiXZX11r3nEUp+aEMy9T3KXZSs1YLvZIMFv4OlW+10Gg?=
 =?us-ascii?Q?T4flcYSxPOpx5ZlpHOLZRjINKG4CrXg5x08nDKRxdO3yNWaxAfWtIDlP5kWN?=
 =?us-ascii?Q?7Fb58KsGQKl++85RCwM0Uc63Ve22Uvw9Va3SdYpX0vr11L+14MmMC9pHLYt/?=
 =?us-ascii?Q?iv8oWTMtf5mqrVg5k3LdHZKwhJkLCywJZnbgOlZowB+B4szQ94lqs9VFNFHt?=
 =?us-ascii?Q?swvz1LqMcURUnC4i4ol8im20AIrTF4hMN/iRdUOUsInSmuz5xnxE9e82GVla?=
 =?us-ascii?Q?K7CGT3C+4Sw4baSP6Xs6HSisfWzFcDyAac7uO6LozqZfWsPNGHIRNDaPBbcZ?=
 =?us-ascii?Q?c1w9zdgf/BA0PnOcumFAFtQMrTEQqXtI?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 238c3416-3769-4626-dd36-08da08f08d6d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 5bo72p1Kmf4niuNrrYm72bBmLX0RI0WI2iaXRmS2pzQDTdcA792AVnVldoRIGZoWO7Ausnzq9ULhYRwQqJgi8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5515
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 1DEonknlb46NZb6Em9Nha1zwB5gH7zJl
X-Proofpoint-ORIG-GUID: 1DEonknlb46NZb6Em9Nha1zwB5gH7zJl
Reporting-Meta:
 AAFXLc7X61Q8bO0SzYDWSVtqX8xaMhIeV2dBcqkPU8XootxP7xQ2Vx5UWPtWHXBC
 5i8VYXehBXh7i0bhyf4SNpkkxoTDVrwd/rG/gRPe/Xt/FO1U1mvdkcKb4KLFdQB5
 sTr14EOWkZZ3M4LaQ43jaIkBI6LoxWy4in3z61DUMlztsmh5e25X0Fd2RaaSSH8/
 MWVmsabnUc7lOYYn8cpEyzFuxoxMDBE28WJ9oQnpmLzhcJqM1ULRbu6rSwK4sZxG
 KsOB/+E8TlheApAwCyEksA+Q8E2OWI1hSVNw9rt1x81ro0Z5SaqGe9UmnL8nI1dT
 p0ZXDPL649J2gLPMQjKWpxiiGigIU7XGoqCdLhrYAt8XdJxVOPVRfxCcCKeNmbmI
 t+aBUETF65NlxH96lE5N3lrASviOiLT8DeXbltco0Hk+SaKxIIT9/irQ8sjRqVkA
 xc/8H7UNIN2NfZawHgehu2yLvhkJqMjCiiA0DHxdNqWxAVdcnuNIBVoY67Yw7hUe
 prEtVbvyXivxYY+E+Q4f5xicw4gr77ElpwMzYO4hmr/M

Call trace:

  ocfs2: Registered cluster interface user
  dlm: no local IP address has been set
  dlm: cannot start dlm lowcomms -107
  (mount.ocfs2,2225,0):ocfs2_dlm_init:3355 ERROR: status = -107
  (mount.ocfs2,2225,0):ocfs2_mount_volume:1817 ERROR: status = -107
  (mount.ocfs2,2225,0):ocfs2_fill_super:1186 ERROR: status = -107
  BUG: kernel NULL pointer dereference, address: 0000000000000030
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 2225 Comm: mount.ocfs2 Not tainted 5.16.2-1-default #1
openSUSE Tumbleweed b40...e84
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ...
  RIP: 0010:ocfs2_clear_inode+0x2e9/0x720 [ocfs2]
  ...
  Call Trace:
   <TASK>
   ? ocfs2_evict_inode+0x1fe/0x630 [ocfs2 411bc..281]
   evict+0xc0/0x1c0
   ocfs2_release_system_inodes+0x21/0xc0 [ocfs2 411bc..281]
   ocfs2_dismount_volume+0x10b/0x2d0 [ocfs2 411bc..281]
   ocfs2_fill_super+0xaf/0x19e0 [ocfs2 411bc..281]
   mount_bdev+0x182/0x1b0
   ? ocfs2_initialize_super.isra.0+0xf50/0xf50 [ocfs2 411bc..281]
   legacy_get_tree+0x24/0x40
   vfs_get_tree+0x22/0xb0
   path_mount+0x465/0xac0
   __x64_sys_mount+0x103/0x140
   do_syscall_64+0x59/0x80
   ? syscall_exit_to_user_mode+0x18/0x40
   ? do_syscall_64+0x69/0x80
   ? syscall_exit_to_user_mode+0x18/0x40
   ? do_syscall_64+0x69/0x80
   ? exc_page_fault+0x68/0x150
   entry_SYSCALL_64_after_hwframe+0x44/0xae

How to trigger:

  tb-ocfs1 # dd if=/dev/zero of=/dev/vdb bs=1M count=20 oflag=direct
  tb-ocfs1 # mkfs.ocfs2 --cluster-stack=pcmk -N 4 /dev/vdb \
             --cluster-name=ocfstst

             == there is no dlm running ==
  tb-ocfs1 # mount -t ocfs2 /dev/vdb /mnt
             == kernel crash ==

Analysis:

After commit da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown"),
Journal init later than before, it makes NULL pointer access in free
routine.

ocfs2_fill_super
 + ocfs2_mount_volume
 |  ocfs2_dlm_init //failed, osb->journal still NULL.
 + ...
 + ocfs2_dismount_volume
    ocfs2_release_system_inodes
      ...
       evict
        ...
         ocfs2_clear_inode
          ocfs2_checkpoint_inode
           ocfs2_ci_fully_checkpointed
            time_after(journal->j_trans_id, ci->ci_last_trans)
             + journal is empty, crash!

How to fix:

create a new function _inode_direct_free() to handle journal non-exist
case.

Fixes: da5e7c87827e8 ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
v3: change patch subject
    change fix method:
    - v1/v2 focused on the points of accessing osb->journal.
    - v3 directly free inodes
v2: revise commit log
    add checking in ocfs2_dismount_volume()
---
 fs/ocfs2/localalloc.c | 12 ++++++++
 fs/ocfs2/super.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5f6bacbeef6b..c7694c2a1000 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -412,6 +412,18 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 		goto out_mutex;
 	}
 
+	if (!osb->journal) {
+		/* Does here make sense to handle bh? */
+		if (osb->local_alloc_bh)
+			brelse(osb->local_alloc_bh);
+		osb->local_alloc_bh = NULL;
+		osb->local_alloc_state = OCFS2_LA_UNUSED;
+
+		/*  After out_unlock calling iput() is safe, in theory system inode
+		 * still be hold in dismount flow */
+		goto out_unlock;
+	}
+
 	/* WINDOW_MOVE_CREDITS is a bit heavy... */
 	handle = ocfs2_start_trans(osb, OCFS2_WINDOW_MOVE_CREDITS);
 	if (IS_ERR(handle)) {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8bde30fa5387..65aedfdcb2f9 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -504,28 +504,79 @@ static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
 	return status;
 }
 
+/*
+ * This function does the directly release action, which makes sure
+ * there is no memory & lockres leak for inode.
+ *
+ * How it works:
+ *
+ * refer iput() flow, which will call following key functions:
+ *   ocfs2_drop_inode, ocfs2_evict_inode, ocfs2_clear_inode, ocfs2_free_inode.
+ *
+ * - ocfs2_drop_inode() & ocfs2_clear_inode() are useless when directly remove.
+ * - other ocfs2_xx_inode() should be mentioned in this function.
+ */
+static void _inode_direct_free(struct ocfs2_super *osb, struct inode *inode)
+{
+	int status;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	/* 1> copy from ocfs2_evict_inode() */
+	truncate_inode_pages_final(&inode->i_data);
+
+	ocfs2_open_unlock(inode);
+
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
+
+	status = ocfs2_drop_inode_locks(inode);
+	if (status < 0)
+		mlog_errno(status);
+
+	ocfs2_lock_res_free(&oi->ip_rw_lockres);
+	ocfs2_lock_res_free(&oi->ip_inode_lockres);
+	ocfs2_lock_res_free(&oi->ip_open_lockres);
+	ocfs2_metadata_cache_exit(INODE_CACHE(inode));
+
+	oi->ip_flags = 0;
+	oi->ip_dir_start_lookup = 0;
+	oi->ip_blkno = 0ULL;
+
+	/* 2> free memory */
+	ocfs2_free_inode(inode);
+}
+
+static void _inode_iput_free(struct ocfs2_super *osb, struct inode *inode)
+{
+	iput(inode);
+}
+
 static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 {
 	int i;
 	struct inode *inode;
+	void (*_free_inode)(struct ocfs2_super *osb, struct inode *inode);
+
+	_free_inode = osb->journal ? _inode_iput_free : _inode_direct_free;
 
 	for (i = 0; i < NUM_GLOBAL_SYSTEM_INODES; i++) {
 		inode = osb->global_system_inodes[i];
 		if (inode) {
-			iput(inode);
+			_free_inode(osb, inode);
 			osb->global_system_inodes[i] = NULL;
 		}
 	}
 
 	inode = osb->sys_root_inode;
 	if (inode) {
-		iput(inode);
+		_free_inode(osb, inode);
 		osb->sys_root_inode = NULL;
 	}
 
 	inode = osb->root_inode;
 	if (inode) {
-		iput(inode);
+		_free_inode(osb, inode);
 		osb->root_inode = NULL;
 	}
 
@@ -534,7 +585,7 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 
 	for (i = 0; i < NUM_LOCAL_SYSTEM_INODES * osb->max_slots; i++) {
 		if (osb->local_system_inodes[i]) {
-			iput(osb->local_system_inodes[i]);
+			_free_inode(osb, osb->local_system_inodes[i]);
 			osb->local_system_inodes[i] = NULL;
 		}
 	}
@@ -1870,6 +1921,13 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	if (!osb->journal) {
+		ocfs2_shutdown_local_alloc(osb);
+		ocfs2_recovery_exit(osb);
+		ocfs2_purge_refcount_trees(osb);
+		goto put_slot;
+	}
+
 	/* Remove file check sysfs related directores/files,
 	 * and wait for the pending file check operations */
 	ocfs2_filecheck_remove_sysfs(osb);
@@ -1897,6 +1955,7 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	ocfs2_purge_refcount_trees(osb);
 
+put_slot:
 	/* No cluster connection means we've failed during mount, so skip
 	 * all the steps which depended on that to complete. */
 	if (osb->cconn) {
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
