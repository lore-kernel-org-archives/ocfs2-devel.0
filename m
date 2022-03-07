Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B22C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  7 Mar 2022 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TStHpUoLjsCE3BwyzMSgzGcIwF/hRYerRaE6rCldNHk=;
 b=xcABXmKe1JhByGwUStNvThXnpUecFwVwbl6I0MRH1LzwAW6MLu2wp3cCGWhHuzkvvl1hYK14w/93
   P+DybGT/5jf1udkJHVw8BWsC9YtZ9lU+pyWj2bFa4+dCXWwRSJ45MjcXxkiZ39C4I/PTm3CX39Mi
   zOOxCiIIS7kfcOsiSISl9wL8DK7I+Ql+CJ7uClexufnFb6VUMKBVz4FIu0zLHce59/qKwKv8DZGn
   vdJwZDVCZi7z0o+TvobrKJ87DlGxc2R+OfyaVxrRGWuXwcdlVxLVzG8Jvtp9eQKJTGhWyVOONOVh
   gMCtbRSCBePGE9dF38joBUqIpN1ni6nGaVmuKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TStHpUoLjsCE3BwyzMSgzGcIwF/hRYerRaE6rCldNHk=;
 b=aQaXfpdoG28CCV+0ivMYRuZ8lPYyE56Jfv4GJDs5hQ3mujKSTxINtfi2nh+Y60QHduGGNBJplZB6
   oKM3VcfmLccjM3aBxMpYpDdXXpNlplmoF5Qg2/MGl+c6GfiEqMNYFjDaek3E1S3MmofHeo4qSA2/
   eHlIcVw9aFVXzi40GZyvo6muFUccwbG1mw0d+xNff9lLFzPvLak4lKeJ4jLN+VafTsKQwoltoEcI
   Awt0cfgLTmZ6oNXnPEJr2ccd/YROSjQfkkHho/pAegYFaNCtRwa+rP5w+qOAcCKFm4YfYfqWd4wx
   Y396jMDPxKWmn7N7L6ZXBy700+cTAltVBkOpGw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220124 64bit (built Jan 24
 2022))
 with ESMTPS id <0R8D00L46QMQHB90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 07 Mar 2022 14:52:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=rpb/RlXQoieHAMTftTctrYPS73VNi5BYJzpG8yUINmw=;
 b=BpBUPcfv/sciJ4RMtMZZM/e4mxuFpyvtb03i+yhLHUmA7YgkCeBGEyDEEB/hG9SdqYyO
 HHgljpSfweAASZAT86M3cBDpsoJFoB3p801CsTne2hOZp6ODBFqhxjog7WI3daAUZYZC
 AbVEkCwNMjkomq6HBQhJghRGxN91M5C00sxrsYUS9FSkoQrOCBX0Q0ULBgpl5UvfY/iV
 gGmoL5pPmm+D3NjbFq1iEk7dAytDooqXP9Dmf//BuT5uJD0OLnWD55vyddGb3u8uCfbg
 0bD5VZURzF70ccvxHbugwgli7XFbald//HmH/t7wjVqQd1Pv3cW8bFvM2FByKTjKN1oy wQ==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUkQibEX5EgUQR+bxF14Nb/pSDheZq9NXSosObTFTbH/v3I7+kTn+HFzj+FGJ7XEN7G4MrdV7miFfzU3PnOycAlkB3FKLJ8WM5lpBvZQe3hqY/lpBGCCnwQTPh5RS6UXPY1G8ZXkTyfJ+b1BkIgdBVLeWEBt4FtPhDhWVR5swNlS4uIboXYzpwC3Kq/kOQJs/kkjlFfqNVpxUyXHqj42hRv5YtoZikdHYejhcWE3bGK+Ja4pKgvwI/xjrJNt6CMziCJcz0MZR2PC0Ek6qvxFODPOMAUk04LNiWvUbqNnxSEawiOVxmp3r301TTm7jmmI7hJJfxxR+BpieQHfMabjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpb/RlXQoieHAMTftTctrYPS73VNi5BYJzpG8yUINmw=;
 b=F8U3V8f5hl+hFX+e/jX7wsdrk6OlOfU2X+lMg+g/O+FvK/WYMcKMIHZJnMNN7hyjFu8polR+NwB6oH79bn0oEJ7y8dnf5qVCY4SFhIjayOAzC+VRi8usfKpRIxUtajCERDYvAC7htC/iBQk/AhaIvyEi11x+xFieVr9iJR19NbA4dSXOakC1Skb6nPW0EuoEO4iGf9mQBH144T5IZOjqo9Amyuk5qZPgIB0VBxpWGR8Bk9x+MXjSL1lYUYe6POaSIP9vYIGeds7oVs7iFwlKwDI+AKQllRDujcNFVHoatJGO1V0BI9CxHKmAbx74juFnMiuR9TgaPav5qWKPxSU9+g==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpb/RlXQoieHAMTftTctrYPS73VNi5BYJzpG8yUINmw=;
 b=sFklqi4uFjix2Tr8oI2+tYd2FGlCZXgQG+hkRcNdd++sNxRLlWIN7jVH+lbhQD1/ZNNMIlpWKi23aLgUG/yBiZzaFLAIXMMlO+S/JLYlMw5shYI1ckqEepgRdYIc60GRDxBUe5WgE0OfpdEAtVXboUdAo6AbXu7lYncitHlbBeg=
Date: Mon, 7 Mar 2022 17:51:38 +0300
To: ocfs2-devel@oss.oracle.com
Message-id: <20220307145138.GA22641@kili>
Content-disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 14:51:50.4390 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278
 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070086
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Subject: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: ZR0P278CA0101.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7416e3f3-b95b-4628-cf87-08da004a02c8
X-MS-TrafficTypeDiagnostic: BL0PR10MB2819:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 qKwxJHedfEEU9MSA6cYuCeFzIgmMXbXjZyjSYfFaYnPMtejU3qfQHCIiPHu2fWPC0tgFfeQq7WXmrFWimq0ZYqHCD/eSaadKClGNOi+wM8T1RRWVKl8/ER/LWQe2cpnfyLtYWqBwYAt1Iz8OdwrrRPfP4Bw9cjzMNA4R6GpkK75m+9PENYv3msXsqIPNU5/XxPQ7WJ2OS6UvgNIXz3FkEzF2JFZpd6fofNcCmICypywckNEpvHlFCZy/Z2e4F7dRx5rNx+ix6XyxEruN0JK3Jbh3GgAk2Jefz8isGIjHyNWIfqKGiLsaeiwNgAztGDvj0EiVlkiT8Hss5NdrbxkcIJ2ibYkO9lmOuwv6++VEzVe1VHVbHrtOAhdlHRzJps7P3x4C8QHXevFxJHIFfJv7RcfoFZLoKsLL28tTS0aDsWlelNpcvqQo+kPWRAVXsiv6sFQg2BHRBS+DszZBzi4vYduXuqY3ghVh1tEnRvauSk8ns6WGzZ75pfQhBOcbUT5MIB/T2PgXrbdSxlVpyL5fIt0Psechvl9HG48ez/tBJvQ1GXacCHttKRu/cmKV8TxBv+eHEhQh9ju2MQr9V7WnXAFOAWHsM5mvK9RXIm3ZKt8=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 7416e3f3-b95b-4628-cf87-08da004a02c8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 B1WRK8ITCO0h6m+Zevt1InWtx2JUNu68h6rnVzF9DusAcRnJJQM2D5DjQq24rgww13NhBEmKLPWYbRXyau53UlL/mZL0TDEh5tlXs8faWIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2819
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 62.8.65.185
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR10MB2819.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: FbIiCi_4QFokbCHQoJDG28BF3MJ0WUOC
X-Proofpoint-GUID: FbIiCi_4QFokbCHQoJDG28BF3MJ0WUOC
Reporting-Meta:
 AAFm/BCA0JmmoHTAtqcvXLgx0SsWuCNMvJC7QsKeO1eSDxcKmd+oYJsua998No+n
 GgouYX+9oIkKtcjSgvSJYSsIvlcf3Z9GTtJUUEgRueIPKtpflzpGwDbrLhxNR1TL
 GSvNJxFdojjV6p949QCukmsSC2AICZskFTosJseD2Gwr64lxkNT/vuVtM/csGfnz
 T3xpCazA69LoL/faBzsD1WtfKHbyaBh95NECvuFS5h0OBMO3Jsr1fIRfWBFlsZ6z
 nszvxbVCnC9KDx9wLWkDrnjLCtKw3pFE6IJDQoZx4Z0loMavkOr7lVTmmxlW+oUg
 /RP/9z2tGIjiwy15qllfOHtsCwuL8fllaktnEfcFsOKgSiFJHhPRXqM8WnzAglAK
 57KYknUUDsCUG3gWyvWzzjrC7TtT9G9yqlRKtO4FhJDQFDm4PyiAfFUJA4ghFlXd
 wOekkSrsGsOJfZu/mZMtLhwIWrK+0m5tigsfGHZrsFcJE8HU5i5Wfr8RwJ6IAZju
 aaOKjSorO3cu6h80tB2bp1Xsc2EPo+/0EzFg2ziiBZg=

Hello OCFS Devs,

There is a big push to re-write list_for_each_entry() so that you
can't use the list iterator outside the loop.  I wrote a check for that
but this code has me puzzled.

The patch b0d4f817ba5d: "ocfs2/dlm: Fix race in adding/removing
lockres' to/from the tracking list" from Dec 16, 2008, leads to the
following Smatch static checker warning:

	fs/ocfs2/dlm/dlmdebug.c:573 lockres_seq_start()
	warn: iterator used outside loop: 'res'

fs/ocfs2/dlm/dlmdebug.c
    539 static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
    540 {
    541         struct debug_lockres *dl = m->private;
    542         struct dlm_ctxt *dlm = dl->dl_ctxt;
    543         struct dlm_lock_resource *oldres = dl->dl_res;
    544         struct dlm_lock_resource *res = NULL;
    545         struct list_head *track_list;
    546 
    547         spin_lock(&dlm->track_lock);
    548         if (oldres)
    549                 track_list = &oldres->tracking;
    550         else {
    551                 track_list = &dlm->tracking_list;
    552                 if (list_empty(track_list)) {
    553                         dl = NULL;
    554                         spin_unlock(&dlm->track_lock);
    555                         goto bail;
    556                 }

Why not do the list_empty() check after the else statement.  In the
current code if "&oldres->tracking" is empty it will lead to a crash.

    557         }
    558 
    559         list_for_each_entry(res, track_list, tracking) {
    560                 if (&res->tracking == &dlm->tracking_list)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This should never be possible.  How is it possible?  If
&dlm->tracking_list is the list head the it's not possible without
memory corruption.  If &oldres->tracking is the list head then I do not
see how it is possible without memory corruption.  We can't mix different
types of list entries on the same list head?

    561                         res = NULL;
    562                 else
    563                         dlm_lockres_get(res);
    564                 break;

If we using list_first_entry() instead of open coding it then this
function becomes a lot simpler.  See patch below:

    565         }
    566         spin_unlock(&dlm->track_lock);
    567 
    568         if (oldres)
    569                 dlm_lockres_put(oldres);
    570 
    571         dl->dl_res = res;
    572 
--> 573         if (res) {
    574                 spin_lock(&res->spinlock);

Here is where the crash would happen if the &oldres->tracking list is
empty.

    575                 dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
    576                 spin_unlock(&res->spinlock);
    577         } else
    578                 dl = NULL;
    579 
    580 bail:
    581         /* passed to seq_show */
    582         return dl;
    583 }

Here is a patch which removes the "if (&res->tracking == &dlm->tracking_list)"
and uses list_first_entry_or_null().  It removes 13 lines of code.

regards,
dan carpenter

---
 fs/ocfs2/dlm/dlmdebug.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index d442cf5dda8a..fb61cdfe0d06 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -547,37 +547,24 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
 	spin_lock(&dlm->track_lock);
 	if (oldres)
 		track_list = &oldres->tracking;
-	else {
+	else
 		track_list = &dlm->tracking_list;
-		if (list_empty(track_list)) {
-			dl = NULL;
-			spin_unlock(&dlm->track_lock);
-			goto bail;
-		}
-	}
 
-	list_for_each_entry(res, track_list, tracking) {
-		if (&res->tracking == &dlm->tracking_list)
-			res = NULL;
-		else
-			dlm_lockres_get(res);
-		break;
-	}
+	res = list_first_entry_or_null(track_list, struct dlm_lock_resource,
+				       tracking);
 	spin_unlock(&dlm->track_lock);
+	if (!res)
+		return NULL;
 
 	if (oldres)
 		dlm_lockres_put(oldres);
 
 	dl->dl_res = res;
 
-	if (res) {
-		spin_lock(&res->spinlock);
-		dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
-		spin_unlock(&res->spinlock);
-	} else
-		dl = NULL;
+	spin_lock(&res->spinlock);
+	dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
+	spin_unlock(&res->spinlock);
 
-bail:
 	/* passed to seq_show */
 	return dl;
 }
-- 
2.20.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
