Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52647C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 18 Mar 2022 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1T3DHAAe/QVC6PzRyjNXkRB8bzjLwa6hhWJ9X8ipUkA=;
 b=wKIUTDSMg+uBo60lUcR+nKzTsvNKsm3zRUmj907ytUzbQXTl+8OEiCjzbTk83JevpJjSXYqbEuZu
   L/UUtdAQf/9xFa1SVfmb6mH3T+EKEi1fv+NKn73tAp2wMTHQruzuzd6AbVJeSDEaeb2bzuufNa9B
   jR50hl4c0yb5uBw50CEWdyj8lTMQ3trWyOww44y2X3qMZksvDvIElEZ6IsrlY8y6FljtUUxRb+4/
   aERT6RCpfXtgQXqLnNR2j5Jtp4XR0znFOXGRELjHDqMUcyiBGd4ZGa35XLBzzHrNfFSaBnHTLUhO
   WgZqltI98DgUw7H+c/4574P949HERwQSjpf0sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1T3DHAAe/QVC6PzRyjNXkRB8bzjLwa6hhWJ9X8ipUkA=;
 b=bitH4U0/+ylqKFW18GLauVvkieoHee9Se4+mXA5KZCfiQboZU9GZyEu+thZEMq0IBB4kdJTWsD6G
   +GPrRqQJT3bFVFxFjx95E47l0vtxgqa8fJRsU96pg1KJPDDAQLAlRauZdCUPTwtJIxaVJeapH/0n
   IiqO2tAy7Kp+IBhMYMdGVoZprH0e3nHMr6a/IefNvGeGcK8P/3jnM1TPtDkxr7T7zSqsCy5AsfCd
   2tV/AbPr6fySYe9VmxoilecD6+AQyI52ex66Ps86yoH8hsErFuecZ4Bm7Hg6cKnOIlonirfqtJIE
   LJbvXQqMzFQyiCJena//ZyBTOkPG3lev9i9sFw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8Y00ID911V52C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 18 Mar 2022 13:49:07 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=heming.zhao@suse.com; dkim=pass header.s=mimecast20200619
 header.d=suse.com; dmarc=pass header.from=suse.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1647611334;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=bnRXeFWWiVC0wRIRUUNalUPR1vMczcnBiNJKAKPcMfw=;
 b=CbaYQmhE3aVS0Gq7TW9lqMyadOJf9bpXdkSiCCbaO/2ad+wWGgLSRuAWXTmk1u1edU2iiH
 aohHPRCNDXjYu9Pd73KdQ4zJQQVVzBq5x2du7qeWPPUTp6evxCx7kp0qdiNhx+lrN2kntD
 O17+JNax9ALeuS+Bz8Kdj2XuoJWTxUE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/YalPnN2hBXAoAS5o4HF2J85WcYy55+onTpkOm9A8IQPVnHX8sXBoJKcQKzQc6xWF2EwesNKsUY9335tM7KI79Lhd9WM/u00mw9dde2PZ9LwEdbnlFN3G7+6Q66q1XMimqnz5vvtvZXKpMU07KvOJwuXcZzQBq/o4PwVEXgAnttkj/nMfaV8zzKZn6dmFVu7GatN4TWDjSkogBDTMCDh9LZ4wZGXiJTOpDa7FwHqukxMBf48XXtTkcQ2utFPKeh4qvuYevD173wmKxbOg8WawnzjZK5HmkfWSZEjUAZQ1kWfJdZqRKXtj+S8PXYsG7dsZGMA0ovqm/iYcrZhVno3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gZG/bGnGlFKiS2MsnD697QERsT8HKfXP9pzRV9hXTo=;
 b=iOzNPDJh9uvj6MQYZycchScgvsTzZnreDsAVuYievozKx9IDukRbn/e7Ly3un0d/tXrsxzjraXNGk3nkdt3e49ZAv6biJNluAOPh//Fd1kN4urPZhX3trrwjh/XR7z7lyvL/abru6qbSdd93u574bDBBcUdCNzXrdcwpNkz9cbxcxQDqr9NPY5aS+RF1sJBuE3/p3Vr0Y1rLX2bDY1A5MXsEz5/nfa2hTwIqI1s16iartbhNZ+LAZzHLFOwrMU222633EhQMLlw0OAEfEHk9CkaT3gM3ulTV68WnpIcFwkMNovbQWt8+flmz+4+BdxkzQVVX1q0hb8KOwk2V/bgUkQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri, 18 Mar 2022 21:48:45 +0800
Message-id: <20220318134845.1749-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(86362001)(6512007)(316002)(83380400001)(6506007)(6666004)(508600001)(6486002)(36756003)(186003)(26005)(5660300002)(1076003)(8936002)(107886003)(44832011)(2616005)(2906002)(4326008)(8676002)(66556008)(66476007)(66946007)(38100700002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:48:52.4453 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289
 signatures=693715
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 clxscore=266
 adultscore=0 priorityscore=197 mlxlogscore=968 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180076
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: fix kernel crash after mounting	when
 journal doesn't ready
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
X-MC-Unique: E-l1o2b0PpeubIErSrYJ6w-2
X-ClientProxiedBy: HK2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:202::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b40bad2c-bf0a-47ff-f4a3-08da08e60996
X-MS-TrafficTypeDiagnostic: AM9PR04MB8684:EE_
X-Microsoft-Antispam-PRVS:
 <AM9PR04MB868485E429E3F2B07ECCE4DD97139@AM9PR04MB8684.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 FawS3gTsiyJzj5z+t4TZcfPk/p48FJl8hRmSfPyug1pTogRQvaGOZmL2bpwJJlF6uzjYTPITr9EJqRDbu+Q09kW+QQ90coPVA6G6AAiYZnoQYdKtpaJ9tmEh8UHT6ri22J9/zpYKbYuQbn4X41s/LruS/Wm4oh7x/OfOglJee48qUn6nxtseK/fm13ImF1ge/Sqq6miDIlHqVRJ2wbJsGiBovhgpKSNzA2gHOgxYF5KoQYCea8JIxkTwHTlRA1DARyUgqz5FQK3wmy10ya0dVH4Sy6AB/Q9d5i2DzBodq3UwuS5kIh4aT4xX7ByXrVlEtjlmg4Dk+8pFMkQmSmt/XPvhedTIKnWw2wOh78UDPcvb1NmtLEhCkcKc4Ckzj4BWcH0L8kHWIDR+UYhdorDXYOJ7tifSxhZ3CPgif80k3PFKtb6zakJ+pBfM3h2+edniOOMofuTqRiiZcvt+ohAhx64heDsB/HzUmdkqU26camtaQYURga3ciHbIArpPutbrZGGc9kSSrRfJBZxk/EqM5o8gf8VgVUDDIa74U+tfQ/v+B4LT8fmi0L7qjoigyoHuz9aBLnhBDVdLFVVZvHsJd7oLc/aV/fvjh7k5xCkUk18PBnkNdpLjxIRGTYEJxxSKavPR+SSJI4vIfsFkIRw9Yg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?JgD3wFOBvzmpV+14WDyDCKECAAEf+xyufK7730ZyU4f0Jpp58Kf90pS0aszG?=
 =?us-ascii?Q?v2tXfJv3rYLCiFgQeDIbTglZPhe/REgEw9QCp+147FwHv7reAXMruxzGpKWT?=
 =?us-ascii?Q?JGoaCgXN067VPgKFZnuY6zEXlrmdJV1jgwDFmO2aV3XOpzRlHS8nlIgziqX6?=
 =?us-ascii?Q?Iw6OUixd2FRnEjGVTruRuPI2KH8A1KHHtG5wIgsg6r5qU4+E/BIHemoX9LdS?=
 =?us-ascii?Q?bcWwOIHXc5ipLiuxqeUY8FIeIuhBkUE39tH3Oswcec+9RcgdkAqpDTcIJi8J?=
 =?us-ascii?Q?TV0T6iBpPwsTxNmNDvwi8S/nfa4EBwC4Dfffx2nxGuWDBNKMqg5AfbtXdWgy?=
 =?us-ascii?Q?x9g8Qjjw7W1BTv+cBPfcoCF5UOnNeQx5BsuchadlodIJAfNNmxKyDiCm3+y7?=
 =?us-ascii?Q?3H+eH07/VY9lDWiI2SUG3L49C8VUDJQ6jvdlNiWHtdZgc6Pzpmh+xyN4W0pT?=
 =?us-ascii?Q?FDQIGiKlW2F3ghXfCp41hwgr+rm12c6UOWQox8ggXilUMn4G0/TH+OU8T8fn?=
 =?us-ascii?Q?zZFHUdqDAcRvt2qAvWB0+MAYU4ePpvib2YrAMBppWWgiVTNKJp05slpYxF4O?=
 =?us-ascii?Q?1VCh7kGZ/PbIe+otWO4U8wgJu+NWsoD0dXpoyUEWbZX2ww4hZUBNFMRUDNhv?=
 =?us-ascii?Q?+/Sxsv8CKvhzCU5VemwI7F8gOqdtc+/zpz5V3DluQaw72RgXRrXXYGZhyRj1?=
 =?us-ascii?Q?Ev0ULhCpUvpierXj/l/w+ybETDgYB4hwHzLuvXouIFT7aF+8BmntIE8H0mDj?=
 =?us-ascii?Q?IU5wsuP6XfhZ9mpR7ikMUBbLzm5Oip32jr1VxRKpr9otfR41v7XgACb8EhHV?=
 =?us-ascii?Q?3dlE9H3s8YzCq1SYFhI4lXBlP24dPRPyZFKMthT+ETIgsDTgpnFAgXGvgOw5?=
 =?us-ascii?Q?JpndGieni+eM6N1f4lCNWhJfV3L6UQic/x3NH8EfsOMhXRzLhfYQHZqTzeh2?=
 =?us-ascii?Q?qncYAl/RORiaXMHinRSDCLNkCRQjnh+Ib9xjHDLhGlMLU9l3SgifLXyGnf5c?=
 =?us-ascii?Q?2NC/eXaargiDTxV0s47SGmmA6IMR6Xhp+1pCUGZ/f53YLs4iC8oklxaQJDt0?=
 =?us-ascii?Q?jF7Zf1VU6qkfXZqGwM5iHoPNajNZGFHIO9f1Rbgboblf/or4JVuSgx+G9Mk4?=
 =?us-ascii?Q?TRSho9nCndsT1zrRrauWbaQ3rUhKzGhlGV7H52cJDkOfjjb2IF82SPlIFSAh?=
 =?us-ascii?Q?kfZWtd77Kf04b1kHcBDBNIpEbWXHwkLTFgogA6jcfSLEKG/N/UzFEaflPLxT?=
 =?us-ascii?Q?AP/q0eKbBGpZ18vbLYFG+35oDh+bMGNvTAi/0VgClVT9wvVNYqBWEVuWJ22c?=
 =?us-ascii?Q?3TG7tD9EI0zVNKN5uTTa6x4QYUWmUxOnSwnkvLFsCvQCIsgRWKMCCDUwzrQI?=
 =?us-ascii?Q?XquL0Sisr66KudM3L6NXNP41pJT0FhWliGJSxnOg7fZQGYj/lDdVVPTYnpzi?=
 =?us-ascii?Q?Z1rB02t+6LSgpFlbz3PUKzYJ65NEjQnh?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 b40bad2c-bf0a-47ff-f4a3-08da08e60996
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 nHs2iBa8ElYetrOtpSu4xe2NvCdsidIFyD/+qRGGtz7dSF00aKHLDbYX/4WVs4MC2Dt0/vPkqhvSokhPxiIf5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8684
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: fxSGZ-NlFpLDXlanKQeYhL0N9HG6oRuV
X-Proofpoint-ORIG-GUID: fxSGZ-NlFpLDXlanKQeYhL0N9HG6oRuV
Reporting-Meta:
 AAFw8flGfduKKibfulCzCBHjfWn9/umALQMnBo4N3WWXWSRi01JkZuQeATgWOHFE
 WUXjft/90SJCET7Otw3EHyBp4BRysCC9Y0/VpzOBvl4tDo8/yrUVyGZ9WJiIXmPZ
 Y7s80T2nEZb+o5ZaZTco95Sd6V0jBvOA2oJelOFk0ktBpmlH9stIYyRWpcsvcAbN
 noVxkyw85gidcG8J7KMLDdnEWUtCJKOxcRkVoXmrySDPauch+vqGRxyP+77FGwq0
 XP37JOKiDHAWeZLDBQxkCNybDvgMbcdXXC0WWm4tFqLwC/CLusj0n2VX88mhQ2rX
 JFR2tsa/mXpUFXcwj4p+4gqdexKCd39E9X1G4mdQQGBi/LD8z8p4OW4O7Brl+S4r
 r3SAkrh2XgmfMhN4BR2+Js0mFeEs7A+ElDqGqm40tNo0vUv0etkXFPu/YuutPpG6
 +y9q84NYMQuGLmRuBrazaLJT8jOn0KQvq3M3nhCFh+DxI4rOvCfOGxDzGCRNYfLz
 A827GK0sKUC/ZZtJoGnYHepssKbN9bSoH1I3qEACOQ==

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
